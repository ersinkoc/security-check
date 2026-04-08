---
name: sc-lang-rust
description: Rust-specific security deep scan
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Rust Security Deep Scan

## Purpose

Detects Rust-specific security anti-patterns focusing on unsafe code, FFI boundaries, concurrency pitfalls, and areas where Rust's safety guarantees can be circumvented. Despite Rust's strong type system, vulnerabilities exist in unsafe blocks, integer overflow behavior, and third-party crate misuse.

## Activation

Activates when Rust is detected in `security-report/architecture.md`.

## Checklist Reference

References `checklists/rust-security-checklist.md`.

## Rust-Specific Vulnerability Patterns

### Category 1: Unsafe Block Audit

```rust
// VULNERABLE: Raw pointer dereference without validation
unsafe {
    let ptr = addr as *const u8;
    let value = *ptr; // Segfault or arbitrary memory read!
}

// VULNERABLE: transmute between incompatible types
let x: u64 = unsafe { std::mem::transmute(user_input_f64) }; // UB if NaN

// SAFE: Minimize unsafe scope, document invariants, validate inputs
unsafe {
    assert!(!ptr.is_null(), "null pointer");
    let value = *ptr;
}
```

### Category 2: FFI Boundary Validation

```rust
// VULNERABLE: Trusting C string without validation
extern "C" fn process(input: *const c_char) {
    let s = unsafe { CStr::from_ptr(input) }; // Null ptr → UB!

// SAFE: Validate before dereferencing
extern "C" fn process(input: *const c_char) {
    if input.is_null() { return; }
    let s = unsafe { CStr::from_ptr(input) };
    let s = s.to_str().unwrap_or_default(); // Handle invalid UTF-8
}
```

### Category 3: Command Injection

```rust
// VULNERABLE: User input in shell command
use std::process::Command;
Command::new("sh").arg("-c").arg(format!("echo {}", user_input)).output();

// SAFE: Direct execution without shell
Command::new("echo").arg(user_input).output();
```

### Category 4: Path Traversal

```rust
// VULNERABLE: Path join with user input
let path = PathBuf::from("/uploads").join(user_filename);
std::fs::read(path)?; // ../../../etc/passwd

// SAFE: Canonicalize and verify
let base = PathBuf::from("/uploads").canonicalize()?;
let target = base.join(user_filename).canonicalize()?;
if !target.starts_with(&base) { return Err("path traversal"); }
```

### Category 5: Integer Overflow

```rust
// In release mode, integer overflow WRAPS silently
let x: u8 = 255;
let y = x + 1; // In debug: panic. In release: y = 0!

// SAFE: Use checked/saturating arithmetic
let y = x.checked_add(1).ok_or("overflow")?;
let y = x.saturating_add(1); // Caps at 255
```

### Category 6: panic!() in Library Code

```rust
// VULNERABLE: panic in library code causes caller to abort/unwind unexpectedly
pub fn parse(input: &str) -> Data {
    let idx = input.find(':').unwrap(); // Panics on invalid input!
}

// SAFE: Return Result
pub fn parse(input: &str) -> Result<Data, ParseError> {
    let idx = input.find(':').ok_or(ParseError::MissingDelimiter)?;
}
```

### Category 7: Rc/Arc Reference Cycles

```rust
// VULNERABLE: Reference cycle → memory leak (denial of service)
use std::rc::Rc;
use std::cell::RefCell;
let a = Rc::new(RefCell::new(Node { next: None }));
let b = Rc::new(RefCell::new(Node { next: Some(a.clone()) }));
a.borrow_mut().next = Some(b.clone()); // Cycle! Never freed

// SAFE: Use Weak references
use std::rc::Weak;
a.borrow_mut().parent = Rc::downgrade(&b); // Weak ref, no cycle
```

### Category 8: Send/Sync Trait Misuse

```rust
// VULNERABLE: Unsafe impl Send for non-thread-safe type
struct MyWrapper(*mut c_void);
unsafe impl Send for MyWrapper {} // UB if *mut c_void is not thread-safe!

// SAFE: Only impl Send if the contained data is truly thread-safe
// Audit all unsafe impl Send/Sync carefully
```

### Category 9: Interior Mutability Data Race

```rust
// VULNERABLE: RefCell in multi-threaded context (not Send)
// Cell/RefCell are not Sync, so this is a compile error in safe Rust
// But unsafe code may bypass this
```

### Category 10: Serde Deserialization Bombs

```rust
// VULNERABLE: Unbounded deserialization
let data: Value = serde_json::from_str(&user_input)?; // 10GB JSON → OOM
let data: Vec<Vec<Vec<String>>> = serde_json::from_str(&input)?; // Deep nesting → stack overflow

// SAFE: Limit input size before deserialization
if user_input.len() > MAX_SIZE { return Err("too large"); }
```

### Category 11: Actix-web/Axum Security

```rust
// VULNERABLE: Missing auth middleware on protected routes
HttpServer::new(|| {
    App::new()
        .route("/admin", web::get().to(admin_handler)) // No auth!
})

// SAFE: Auth middleware
App::new()
    .service(
        web::scope("/admin")
            .wrap(AuthMiddleware)
            .route("", web::get().to(admin_handler))
    )
```

### Category 12: Cargo Supply Chain

- `build.rs` in dependencies can execute arbitrary code at compile time
- Proc macros run arbitrary code during compilation
- Check for typosquatted crate names
- Review `cargo audit` for known vulnerabilities
- Verify `Cargo.lock` is committed for applications

### Category 13: Pin/Unpin Unsoundness

```rust
// VULNERABLE: Moving pinned data
// Incorrect Pin implementations can lead to UB with self-referential structs
// Audit any manual Pin implementations carefully
```

### Category 14: MaybeUninit UB

```rust
// VULNERABLE: Reading uninitialized memory
let x: MaybeUninit<u64> = MaybeUninit::uninit();
let val = unsafe { x.assume_init() }; // UB! Reading uninitialized data

// SAFE: Initialize before reading
let mut x = MaybeUninit::uninit();
x.write(42);
let val = unsafe { x.assume_init() }; // OK
```

### Category 15: Tokio Task Cancellation Safety

```rust
// VULNERABLE: .await point in the middle of non-atomic operation
async fn transfer(from: &mut Account, to: &mut Account, amount: u64) {
    from.balance -= amount;
    db.save(from).await; // If cancelled here, 'to' never gets credited!
    to.balance += amount;
    db.save(to).await;
}

// SAFE: Use transactions
async fn transfer(from: &mut Account, to: &mut Account, amount: u64) {
    let tx = db.begin().await?;
    // Both operations in same transaction
    tx.commit().await?;
}
```

### Category 16: .await in Drop

```rust
// VULNERABLE: Async operations in Drop impl don't work
impl Drop for MyResource {
    fn drop(&mut self) {
        // Cannot .await here! This blocks the runtime
        // tokio::runtime::Handle::current().block_on(cleanup()); // Deadlock!
    }
}

// SAFE: Use explicit async cleanup method
impl MyResource {
    async fn cleanup(self) { /* ... */ }
}
```

### Category 17: Regex DoS

```rust
// VULNERABLE: Complex regex with user input
let re = Regex::new(&user_pattern)?; // User crafts slow regex

// SAFE: Use regex with size limits, or don't compile user-provided patterns
let re = RegexBuilder::new(&pattern).size_limit(1024 * 1024).build()?;
```

### Category 18: Unsafe Trait Implementations

```rust
// Audit all unsafe trait implementations for correctness
// Common patterns: Iterator (wrong size_hint), TrustedLen, GlobalAlloc
```

### Category 19: Memory Leaks via Box::leak

```rust
// VULNERABLE: Intentional leak can be DoS vector
let leaked: &'static str = Box::leak(user_string.into_boxed_str());
// If called repeatedly with user input → unbounded memory growth

// SAFE: Use proper lifetime management
```

### Category 20: Error Handling Information Disclosure

```rust
// VULNERABLE: Returning internal error details to clients
HttpResponse::InternalServerError().body(format!("Error: {err:?}"))

// SAFE: Log internally, return generic error
tracing::error!("Database error: {err:?}");
HttpResponse::InternalServerError().body("Internal server error")
```

## Output Format

### Finding: RS-{NNN}
- **Title:** Rust-specific vulnerability
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-XXX
- **Description:** What was found
- **Remediation:** Rust-idiomatic fix with code example
- **References:** CWE link, Rust security documentation
