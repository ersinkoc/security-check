---
name: sc-lang-go
description: Go-specific security deep scan
---

# SC: Go Security Deep Scan

## Purpose
Detects Go-specific security anti-patterns, common mistakes, and language-idiomatic attack vectors that generic vulnerability skills cannot catch.

## Activation
Activates when Go is detected in architecture.md.

## Checklist Reference
References `checklists/go-security-checklist.md`.

## Go-Specific Vulnerability Patterns

---

### 1. Unsafe Package Usage and Reflect Abuse

**Pattern:** Direct use of `unsafe.Pointer` to bypass Go type system, or `reflect` to access unexported fields, disabling memory safety guarantees.

**Dangerous functions/patterns:**
- `unsafe.Pointer`, `unsafe.Sizeof`, `unsafe.Offsetof`, `unsafe.Alignof`
- `reflect.NewAt`, `reflect.Value.Pointer()`, `reflect.Value.UnsafeAddr()`
- Casting `unsafe.Pointer` to `uintptr` and back (pointer arithmetic)
- Using `//go:linkname` to access internal runtime symbols

**Safe alternative:** Use type-safe interfaces, generics (Go 1.18+), and exported APIs. If unsafe is unavoidable, isolate it in a single package with extensive tests and document the invariants.

**Vulnerable code:**
```go
func readPrivateField(s interface{}) string {
    v := reflect.ValueOf(s).Elem()
    f := v.FieldByName("secret")
    // Bypass unexported field protection via unsafe
    ptr := unsafe.Pointer(f.UnsafeAddr())
    return *(*string)(ptr)
}
```

**Safe code:**
```go
// Export the field or provide an accessor method
type Config struct {
    Secret string // exported, or use a getter
}

func (c *Config) GetSecret() string {
    return c.Secret
}
```

---

### 2. CGo Boundary Safety

**Pattern:** Passing Go-managed memory across the CGo boundary without ensuring it remains valid, or accepting unsanitized C strings that may not be null-terminated.

**Dangerous functions/patterns:**
- `C.CString()` without corresponding `C.free()`
- Passing Go pointers to C functions that store them (violates CGo pointer rules)
- `C.GoString()` on untrusted C memory without length bounds
- `C.GoBytes()` with attacker-controlled length parameter

**Safe alternative:** Always free C-allocated memory, use `C.GoStringN()` with validated lengths, and never let C code retain Go pointers across calls.

**Vulnerable code:**
```go
// #include <stdlib.h>
// #include <string.h>
import "C"

func processInput(input string) {
    cStr := C.CString(input)
    // Memory leak: C.free never called
    C.some_c_function(cStr)
}
```

**Safe code:**
```go
// #include <stdlib.h>
import "C"
import "unsafe"

func processInput(input string) {
    cStr := C.CString(input)
    defer C.free(unsafe.Pointer(cStr))
    C.some_c_function(cStr)
}
```

---

### 3. Goroutine Leaks and Channel Deadlocks

**Pattern:** Spawning goroutines that block forever on channel operations, HTTP requests, or I/O without cancellation, leading to memory exhaustion and denial of service.

**Dangerous functions/patterns:**
- Unbuffered channel sends/receives without select + context
- `go func()` without a termination path
- Channel created but never closed, leaving receivers blocked
- Infinite loops inside goroutines without exit conditions

**Safe alternative:** Always pass a `context.Context` to goroutines, use `select` with `ctx.Done()`, and prefer buffered channels or explicit close signals.

**Vulnerable code:**
```go
func fetch(urls []string) []string {
    results := make(chan string)
    for _, url := range urls {
        go func(u string) {
            resp, _ := http.Get(u)
            body, _ := io.ReadAll(resp.Body)
            results <- string(body) // blocks forever if nobody reads
        }(url)
    }
    // If len(urls) > expected, goroutines leak
    return []string{<-results}
}
```

**Safe code:**
```go
func fetch(ctx context.Context, urls []string) ([]string, error) {
    g, ctx := errgroup.WithContext(ctx)
    results := make([]string, len(urls))
    for i, url := range urls {
        i, url := i, url
        g.Go(func() error {
            req, err := http.NewRequestWithContext(ctx, "GET", url, nil)
            if err != nil {
                return err
            }
            resp, err := http.DefaultClient.Do(req)
            if err != nil {
                return err
            }
            defer resp.Body.Close()
            body, err := io.ReadAll(io.LimitReader(resp.Body, 1<<20))
            if err != nil {
                return err
            }
            results[i] = string(body)
            return nil
        })
    }
    if err := g.Wait(); err != nil {
        return nil, err
    }
    return results, nil
}
```

---

### 4. Race Conditions (go vet -race)

**Pattern:** Concurrent reads and writes to shared variables without synchronization, leading to data corruption and undefined behavior.

**Dangerous functions/patterns:**
- Global mutable state accessed from multiple goroutines
- Map read/write from different goroutines (runtime panic in Go 1.6+)
- Struct fields modified concurrently without mutex
- Non-atomic counter increments (`count++` from multiple goroutines)

**Safe alternative:** Use `sync.Mutex`, `sync.RWMutex`, `sync/atomic`, or `sync.Map`. Run CI with `-race` flag. Prefer channel-based communication where possible.

**Vulnerable code:**
```go
var cache = make(map[string]string)

func handler(w http.ResponseWriter, r *http.Request) {
    key := r.URL.Query().Get("key")
    // Concurrent map read/write = fatal panic
    if v, ok := cache[key]; ok {
        fmt.Fprint(w, v)
        return
    }
    cache[key] = computeValue(key)
}
```

**Safe code:**
```go
var (
    cache   = make(map[string]string)
    cacheMu sync.RWMutex
)

func handler(w http.ResponseWriter, r *http.Request) {
    key := r.URL.Query().Get("key")

    cacheMu.RLock()
    v, ok := cache[key]
    cacheMu.RUnlock()
    if ok {
        fmt.Fprint(w, v)
        return
    }

    value := computeValue(key)
    cacheMu.Lock()
    cache[key] = value
    cacheMu.Unlock()
    fmt.Fprint(w, value)
}
```

---

### 5. html/template vs text/template XSS

**Pattern:** Using `text/template` to render HTML content, which performs no escaping and allows script injection.

**Dangerous functions/patterns:**
- `text/template.New()` used for HTML output
- `template.HTML()` type cast to bypass escaping in `html/template`
- `template.JS()`, `template.CSS()`, `template.URL()` with user input
- Rendering user input in `<script>` blocks even with `html/template`

**Safe alternative:** Always use `html/template` for any output rendered in a browser. Never cast user-controlled data to `template.HTML`. Use CSP headers as defense in depth.

**Vulnerable code:**
```go
import "text/template"

func renderPage(w http.ResponseWriter, username string) {
    t := template.Must(template.New("page").Parse(
        `<h1>Welcome, {{.}}</h1>`))
    // username = "<script>alert(1)</script>" => XSS
    t.Execute(w, username)
}
```

**Safe code:**
```go
import "html/template"

func renderPage(w http.ResponseWriter, username string) {
    t := template.Must(template.New("page").Parse(
        `<h1>Welcome, {{.}}</h1>`))
    // html/template auto-escapes: &lt;script&gt;...
    t.Execute(w, username)
}
```

---

### 6. crypto/rand vs math/rand

**Pattern:** Using `math/rand` for security-sensitive operations such as token generation, password creation, or nonce selection.

**Dangerous functions/patterns:**
- `math/rand.Read()`, `math/rand.Int()`, `math/rand.Intn()`
- `math/rand.New(math/rand.NewSource(time.Now().UnixNano()))` for tokens
- Any `math/rand` use for session IDs, CSRF tokens, OTPs, or salts

**Safe alternative:** Use `crypto/rand.Read()` or `crypto/rand.Int()` for all security-sensitive randomness. In Go 1.22+, `math/rand/v2` auto-seeds from crypto/rand but still should not be used for cryptographic purposes.

**Vulnerable code:**
```go
import "math/rand"

func generateToken() string {
    const charset = "abcdefghijklmnopqrstuvwxyz0123456789"
    b := make([]byte, 32)
    for i := range b {
        b[i] = charset[rand.Intn(len(charset))]
    }
    return string(b) // Predictable output
}
```

**Safe code:**
```go
import "crypto/rand"
import "encoding/hex"

func generateToken() (string, error) {
    b := make([]byte, 32)
    if _, err := rand.Read(b); err != nil {
        return "", err
    }
    return hex.EncodeToString(b), nil
}
```

---

### 7. TLS Configuration Mistakes

**Pattern:** Disabling TLS verification, using deprecated TLS versions, or configuring weak cipher suites in production code.

**Dangerous functions/patterns:**
- `InsecureSkipVerify: true` in `tls.Config`
- `MinVersion` set to `tls.VersionTLS10` or `tls.VersionTLS11`
- Explicit weak cipher suites in `CipherSuites` list
- Custom `VerifyPeerCertificate` that always returns nil
- `http.DefaultTransport` modification with insecure TLS

**Safe alternative:** Let Go select cipher suites automatically (secure defaults since Go 1.17). Set `MinVersion: tls.VersionTLS12`. Never set `InsecureSkipVerify` in production.

**Vulnerable code:**
```go
client := &http.Client{
    Transport: &http.Transport{
        TLSClientConfig: &tls.Config{
            InsecureSkipVerify: true, // Disables ALL certificate validation
            MinVersion:         tls.VersionTLS10,
        },
    },
}
```

**Safe code:**
```go
client := &http.Client{
    Transport: &http.Transport{
        TLSClientConfig: &tls.Config{
            MinVersion: tls.VersionTLS12,
            // Let Go pick secure cipher suites automatically
        },
    },
}
```

---

### 8. os/exec Command Injection

**Pattern:** Building shell commands from user input using string concatenation or passing user input to shell interpreters.

**Dangerous functions/patterns:**
- `exec.Command("sh", "-c", userInput)`
- `exec.Command("bash", "-c", fmt.Sprintf("grep %s file", userInput))`
- String concatenation in command arguments
- `os.StartProcess` with unsanitized arguments

**Safe alternative:** Pass arguments as separate elements to `exec.Command` (bypasses shell interpretation). Validate input against an allowlist. Never invoke a shell interpreter with user-controlled strings.

**Vulnerable code:**
```go
func search(w http.ResponseWriter, r *http.Request) {
    query := r.URL.Query().Get("q")
    // User sends q="; rm -rf /"
    cmd := exec.Command("sh", "-c", "grep "+query+" /var/log/app.log")
    output, _ := cmd.CombinedOutput()
    w.Write(output)
}
```

**Safe code:**
```go
func search(w http.ResponseWriter, r *http.Request) {
    query := r.URL.Query().Get("q")
    // Arguments passed directly, no shell interpretation
    cmd := exec.Command("grep", "--", query, "/var/log/app.log")
    output, err := cmd.CombinedOutput()
    if err != nil {
        http.Error(w, "search failed", http.StatusInternalServerError)
        return
    }
    w.Write(output)
}
```

---

### 9. filepath.Join Traversal

**Pattern:** Assuming `filepath.Join` prevents directory traversal. It resolves `..` components but does not reject them, allowing escape from the intended base directory.

**Dangerous functions/patterns:**
- `filepath.Join(baseDir, userInput)` without prefix validation
- `path.Join` (URL path variant) with unchecked input
- Serving files with `http.ServeFile` using unvalidated paths
- Using `os.Open(filepath.Join(base, userInput))` without checking result is under `base`

**Safe alternative:** After joining, verify the result starts with the intended base directory using `filepath.Rel` or `strings.HasPrefix` on the cleaned absolute path.

**Vulnerable code:**
```go
func serveFile(w http.ResponseWriter, r *http.Request) {
    name := r.URL.Query().Get("file")
    // name = "../../etc/passwd" => serves /etc/passwd
    path := filepath.Join("/var/www/static", name)
    http.ServeFile(w, r, path)
}
```

**Safe code:**
```go
func serveFile(w http.ResponseWriter, r *http.Request) {
    name := r.URL.Query().Get("file")
    basePath := "/var/www/static"
    fullPath := filepath.Join(basePath, filepath.Clean("/"+name))
    // Verify the resolved path is still under basePath
    if !strings.HasPrefix(fullPath, basePath+string(os.PathSeparator)) {
        http.Error(w, "forbidden", http.StatusForbidden)
        return
    }
    http.ServeFile(w, r, fullPath)
}
```

---

### 10. net/http Missing Timeouts and Header Injection

**Pattern:** Using default `http.Server` or `http.Client` without timeouts, enabling slowloris attacks and resource exhaustion. Also, injecting CRLF into HTTP headers via user input.

**Dangerous functions/patterns:**
- `http.ListenAndServe()` (no timeouts set)
- `&http.Server{}` without `ReadTimeout`, `WriteTimeout`, `IdleTimeout`
- `http.DefaultClient` (zero timeout = wait forever)
- `w.Header().Set("Location", userInput)` (CRLF injection in Go < 1.22)
- `http.Get(userURL)` without timeout or SSRF protection

**Safe alternative:** Always configure explicit timeouts on both servers and clients. Validate and sanitize header values. Use `net/http` built-in header sanitization (Go 1.22+).

**Vulnerable code:**
```go
func main() {
    // No timeouts: vulnerable to slowloris
    http.ListenAndServe(":8080", handler)
}
```

**Safe code:**
```go
func main() {
    srv := &http.Server{
        Addr:              ":8080",
        Handler:           handler,
        ReadTimeout:       5 * time.Second,
        WriteTimeout:      10 * time.Second,
        IdleTimeout:       120 * time.Second,
        ReadHeaderTimeout: 2 * time.Second,
        MaxHeaderBytes:    1 << 20, // 1 MB
    }
    log.Fatal(srv.ListenAndServe())
}
```

---

### 11. encoding/json Deserialization Risks

**Pattern:** Unmarshaling JSON from untrusted sources without size limits, struct validation, or awareness of Go zero-value behavior for missing fields.

**Dangerous functions/patterns:**
- `json.NewDecoder(r.Body).Decode(&obj)` without `http.MaxBytesReader`
- Missing field validation after unmarshal (zero values treated as valid)
- `json.Number` misuse leading to integer overflow
- `json.RawMessage` stored and re-serialized without validation
- `interface{}` as target type allowing type confusion

**Safe alternative:** Limit body size with `http.MaxBytesReader`. Use `DisallowUnknownFields()`. Validate all fields post-unmarshal. Use strongly typed structs.

**Vulnerable code:**
```go
func createUser(w http.ResponseWriter, r *http.Request) {
    var user User
    // No body size limit: attacker sends 10 GB JSON
    json.NewDecoder(r.Body).Decode(&user)
    // user.Role is "" (zero value) if omitted, might bypass checks
    db.Create(&user)
}
```

**Safe code:**
```go
func createUser(w http.ResponseWriter, r *http.Request) {
    r.Body = http.MaxBytesReader(w, r.Body, 1<<20) // 1 MB limit
    dec := json.NewDecoder(r.Body)
    dec.DisallowUnknownFields()
    var user User
    if err := dec.Decode(&user); err != nil {
        http.Error(w, "invalid JSON", http.StatusBadRequest)
        return
    }
    if err := validateUser(user); err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }
    db.Create(&user)
}
```

---

### 12. Integer Overflow in Type Conversions

**Pattern:** Converting between integer types (especially `int64` to `int32`, or `int` to `uint`) without bounds checking, leading to silent truncation or sign flip.

**Dangerous functions/patterns:**
- `int32(someInt64)` without range check
- `uint(signedInt)` when signedInt can be negative
- `int(someUint64)` when value exceeds `math.MaxInt`
- `strconv.Atoi` result used directly as array index or allocation size
- Arithmetic on `int` values near `math.MaxInt` without overflow checks

**Safe alternative:** Always validate ranges before narrowing conversions. Use `math.MaxInt32`, `math.MinInt32`, etc., for bounds checks. Consider using `math/big` for arbitrary precision.

**Vulnerable code:**
```go
func allocateBuffer(r *http.Request) []byte {
    sizeStr := r.URL.Query().Get("size")
    size, _ := strconv.ParseInt(sizeStr, 10, 64)
    // Truncation: size=2147483648 becomes 0 or negative as int32
    buf := make([]byte, int32(size))
    return buf
}
```

**Safe code:**
```go
func allocateBuffer(r *http.Request) ([]byte, error) {
    sizeStr := r.URL.Query().Get("size")
    size, err := strconv.ParseInt(sizeStr, 10, 64)
    if err != nil || size <= 0 || size > 10*1024*1024 {
        return nil, fmt.Errorf("invalid size: must be 1 to 10MB")
    }
    return make([]byte, size), nil
}
```

---

### 13. Go Module Supply Chain

**Pattern:** Pulling in unvetted dependencies, using replace directives pointing to mutable sources, or ignoring checksum database verification.

**Dangerous functions/patterns:**
- `GONOSUMCHECK=*` or `GONOSUMDB=*` environment variables
- `GOFLAGS=-insecure` allowing HTTP module downloads
- `replace` directives in `go.mod` pointing to remote repos (not local paths)
- Importing vanity import paths that redirect to untrusted repositories
- Dependencies with `+incompatible` suffix (pre-module, no verified checksums)
- Missing `go.sum` from version control

**Safe alternative:** Commit `go.sum` to version control. Use `GOPRIV` only for genuinely private modules. Run `go mod verify` in CI. Use `govulncheck` to scan for known vulnerabilities. Pin dependencies to exact versions.

**Vulnerable code:**
```
// go.mod with mutable replace directive
module myapp

go 1.21

require github.com/untrusted/lib v1.0.0

replace github.com/untrusted/lib => github.com/someone-else/fork master
// ^^^ master is mutable, could change at any time
```

**Safe code:**
```
// go.mod with pinned, checksummed dependencies
module myapp

go 1.21

require github.com/trusted/lib v1.2.3
// go.sum committed, GONOSUMCHECK not set, govulncheck in CI
```

---

### 14. context.Context Misuse

**Pattern:** Ignoring context cancellation in long-running operations, storing security-sensitive values in context, or creating contexts that never get cancelled.

**Dangerous functions/patterns:**
- `context.Background()` in request handlers instead of `r.Context()`
- `context.TODO()` left in production code
- Storing authentication tokens in context values (no type safety)
- Ignoring `ctx.Done()` in loops or blocking operations
- `context.WithCancel` without ever calling the cancel function (leak)

**Safe alternative:** Always propagate the request context. Use typed context keys. Always defer cancel functions. Check `ctx.Err()` in loops.

**Vulnerable code:**
```go
func handler(w http.ResponseWriter, r *http.Request) {
    // Ignores client disconnection; wastes resources on cancelled requests
    ctx := context.Background()
    result, err := expensiveQuery(ctx)
    // ...
}

// Storing sensitive data in context without type safety
ctx = context.WithValue(ctx, "authToken", token) // any code can read with string key
```

**Safe code:**
```go
type contextKey int
const authTokenKey contextKey = iota

func handler(w http.ResponseWriter, r *http.Request) {
    ctx := r.Context() // Respects client cancellation
    result, err := expensiveQuery(ctx)
    if err != nil {
        if ctx.Err() != nil {
            return // Client disconnected, stop processing
        }
        http.Error(w, "query failed", http.StatusInternalServerError)
        return
    }
    // ...
}

// Type-safe context key prevents accidental collisions
ctx = context.WithValue(ctx, authTokenKey, token)
```

---

### 15. Defer Ordering Bugs

**Pattern:** Misunderstanding LIFO execution order of `defer` statements, or deferring in loops causing resource accumulation, or deferring calls with evaluated-at-defer-time arguments.

**Dangerous functions/patterns:**
- `defer f.Close()` before checking `os.Open` error (nil pointer panic)
- `defer` inside a loop (resources not released until function returns)
- `defer resp.Body.Close()` without checking if resp is nil
- `defer mu.Unlock()` placed before `mu.Lock()` (unlock before lock)
- Deferred function with arguments evaluated at defer time, not execution time

**Safe alternative:** Always check errors before deferring cleanup. Use anonymous functions for deferred calls needing current variable values. Extract loop bodies into separate functions when deferring inside loops.

**Vulnerable code:**
```go
func processFiles(paths []string) error {
    for _, p := range paths {
        f, err := os.Open(p)
        if err != nil {
            return err
        }
        defer f.Close() // All files remain open until function returns!
        process(f)
    }
    return nil
}
```

**Safe code:**
```go
func processFiles(paths []string) error {
    for _, p := range paths {
        if err := processOneFile(p); err != nil {
            return err
        }
    }
    return nil
}

func processOneFile(path string) error {
    f, err := os.Open(path)
    if err != nil {
        return err
    }
    defer f.Close()
    return process(f)
}
```

---

### 16. Panic Recovery Anti-Patterns

**Pattern:** Using `recover()` to silently swallow panics, hiding security-critical errors, or failing to recover in goroutines (crashing the entire process).

**Dangerous functions/patterns:**
- `recover()` that discards the panic value without logging
- Missing `recover()` in spawned goroutines (unrecovered panic kills process)
- Using `panic` for control flow or error handling
- Recovery that continues execution in a corrupted state
- Panic values containing sensitive information exposed to users

**Safe alternative:** Always log recovered panics with stack traces. Return 500 errors to clients without internal details. Use middleware for HTTP panic recovery. Never continue business logic after recovery.

**Vulnerable code:**
```go
func handler(w http.ResponseWriter, r *http.Request) {
    defer func() {
        if r := recover(); r != nil {
            // Silently swallowed: security errors hidden, no alerting
        }
    }()
    riskyOperation()
}
```

**Safe code:**
```go
func recoveryMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        defer func() {
            if rec := recover(); rec != nil {
                stack := debug.Stack()
                log.Printf("PANIC: %v\n%s", rec, stack)
                // Generic error to client, details only in server logs
                http.Error(w, "Internal Server Error", http.StatusInternalServerError)
            }
        }()
        next.ServeHTTP(w, r)
    })
}
```

---

### 17. gRPC Security

**Pattern:** Running gRPC services without TLS, missing authentication interceptors, or trusting client-provided metadata without validation.

**Dangerous functions/patterns:**
- `grpc.NewServer()` without TLS credentials (plaintext gRPC)
- Missing unary/stream interceptors for authentication
- `metadata.FromIncomingContext()` values used without validation
- `grpc.WithInsecure()` (deprecated) or `grpc.WithTransportCredentials(insecure.NewCredentials())`
- No rate limiting on streaming RPCs
- Unbounded message sizes (`grpc.MaxRecvMsgSize` set too high)

**Safe alternative:** Always use TLS. Implement auth interceptors. Validate all metadata values. Set reasonable message size limits. Use deadlines on all RPCs.

**Vulnerable code:**
```go
func main() {
    // No TLS, no auth, no message size limits
    srv := grpc.NewServer()
    pb.RegisterMyServiceServer(srv, &myService{})
    lis, _ := net.Listen("tcp", ":50051")
    srv.Serve(lis)
}
```

**Safe code:**
```go
func main() {
    creds, err := credentials.NewServerTLSFromFile("cert.pem", "key.pem")
    if err != nil {
        log.Fatal(err)
    }
    srv := grpc.NewServer(
        grpc.Creds(creds),
        grpc.UnaryInterceptor(authUnaryInterceptor),
        grpc.StreamInterceptor(authStreamInterceptor),
        grpc.MaxRecvMsgSize(4 * 1024 * 1024), // 4 MB limit
    )
    pb.RegisterMyServiceServer(srv, &myService{})
    lis, _ := net.Listen("tcp", ":50051")
    log.Fatal(srv.Serve(lis))
}
```

---

### 18. sql.DB Pool Exhaustion

**Pattern:** Failing to close `sql.Rows`, holding transactions open indefinitely, or misconfiguring connection pool settings, leading to connection starvation and denial of service.

**Dangerous functions/patterns:**
- `db.Query()` without `defer rows.Close()`
- `db.Begin()` without guaranteed `tx.Rollback()` or `tx.Commit()`
- No `SetMaxOpenConns`, `SetMaxIdleConns`, or `SetConnMaxLifetime`
- Scanning rows inside a transaction that holds a lock
- `QueryRow().Scan()` error ignored (connection may not be returned)

**Safe alternative:** Always close rows with defer. Set pool limits. Use context-aware queries. Ensure transactions are always committed or rolled back.

**Vulnerable code:**
```go
func getUsers(db *sql.DB) ([]User, error) {
    rows, err := db.Query("SELECT id, name FROM users")
    if err != nil {
        return nil, err
    }
    // Missing rows.Close(): connections leak until pool exhausted
    var users []User
    for rows.Next() {
        var u User
        rows.Scan(&u.ID, &u.Name)
        users = append(users, u)
    }
    return users, nil
}
```

**Safe code:**
```go
func getUsers(ctx context.Context, db *sql.DB) ([]User, error) {
    rows, err := db.QueryContext(ctx, "SELECT id, name FROM users")
    if err != nil {
        return nil, err
    }
    defer rows.Close()

    var users []User
    for rows.Next() {
        var u User
        if err := rows.Scan(&u.ID, &u.Name); err != nil {
            return nil, fmt.Errorf("scanning user: %w", err)
        }
        users = append(users, u)
    }
    if err := rows.Err(); err != nil {
        return nil, fmt.Errorf("iterating rows: %w", err)
    }
    return users, nil
}

// At initialization:
func initDB() *sql.DB {
    db, err := sql.Open("postgres", dsn)
    if err != nil {
        log.Fatal(err)
    }
    db.SetMaxOpenConns(25)
    db.SetMaxIdleConns(5)
    db.SetConnMaxLifetime(5 * time.Minute)
    return db
}
```

---

### 19. Slice/Map Concurrent Access

**Pattern:** Reading and writing to slices or maps from multiple goroutines without synchronization. Maps cause fatal runtime panics; slices cause silent data corruption.

**Dangerous functions/patterns:**
- Appending to a shared slice from multiple goroutines
- Reading/writing shared map without mutex (fatal: concurrent map writes)
- Passing a slice to a goroutine and modifying the original
- Sharing slice headers across goroutines (data races on len/cap)

**Safe alternative:** Use `sync.Map` for concurrent map access, or protect maps/slices with `sync.RWMutex`. Prefer goroutine-local data and channels. Use the `-race` detector in tests.

**Vulnerable code:**
```go
var results []string

func collectResults(urls []string) []string {
    var wg sync.WaitGroup
    for _, url := range urls {
        wg.Add(1)
        go func(u string) {
            defer wg.Done()
            result := fetch(u)
            // DATA RACE: concurrent append to shared slice
            results = append(results, result)
        }(url)
    }
    wg.Wait()
    return results
}
```

**Safe code:**
```go
func collectResults(urls []string) []string {
    var (
        mu      sync.Mutex
        results []string
        wg      sync.WaitGroup
    )
    for _, url := range urls {
        wg.Add(1)
        go func(u string) {
            defer wg.Done()
            result := fetch(u)
            mu.Lock()
            results = append(results, result)
            mu.Unlock()
        }(url)
    }
    wg.Wait()
    return results
}
```

---

### 20. Error Wrapping Info Disclosure

**Pattern:** Returning internal error details (file paths, SQL queries, stack traces, internal hostnames) to external users through error wrapping chains or raw error messages in HTTP responses.

**Dangerous functions/patterns:**
- `http.Error(w, err.Error(), 500)` where err contains internal details
- `fmt.Errorf("query %s failed: %w", sqlQuery, err)` exposed to API consumer
- Logging frameworks that serialize the full error chain to response bodies
- `errors.Unwrap` chains exposing driver-level errors to clients
- Panic messages containing file paths reaching the user

**Safe alternative:** Map internal errors to generic user-facing messages. Log detailed errors server-side only. Use error sentinel types to classify errors without exposing details.

**Vulnerable code:**
```go
func getUser(w http.ResponseWriter, r *http.Request) {
    user, err := db.QueryRow("SELECT * FROM users WHERE id = $1", id)
    if err != nil {
        // Exposes: "pq: relation \"users\" does not exist" or
        // "dial tcp 10.0.1.5:5432: connect: connection refused"
        http.Error(w, fmt.Sprintf("failed to get user: %v", err), 500)
        return
    }
}
```

**Safe code:**
```go
func getUser(w http.ResponseWriter, r *http.Request) {
    user, err := db.QueryRowContext(r.Context(),
        "SELECT * FROM users WHERE id = $1", id)
    if err != nil {
        // Log internal details server-side
        log.Printf("getUser: query failed for id=%s: %v", id, err)
        // Return generic message to client
        http.Error(w, "user lookup failed", http.StatusInternalServerError)
        return
    }
}
```

---

## Scan Procedure

1. **Identify Go source files:** Locate all `.go` files, `go.mod`, and `go.sum` in the target.
2. **Dependency analysis:** Check `go.mod` for risky dependencies, replace directives, and missing checksums.
3. **Run static checks:** Verify `go vet`, `staticcheck`, and `govulncheck` are configured in CI.
4. **Pattern scan:** For each category above, search the codebase for dangerous patterns using AST-aware grep or `go vet` analysis.
5. **Context evaluation:** Determine if each finding is exploitable given the application threat model (internet-facing vs internal, data sensitivity).
6. **Severity assignment:** Rate each finding using CVSS or qualitative severity (CRITICAL / HIGH / MEDIUM / LOW / INFO).

## Output Format

Each finding MUST be reported in the following standard format:

```
### [SEVERITY] Finding Title

- **Category:** (one of the 20 categories above)
- **Location:** `package/file.go:line`
- **Pattern Matched:** (the dangerous pattern detected)
- **Description:** Concise explanation of the vulnerability and its impact.
- **Exploitability:** How an attacker would exploit this in practice.
- **Remediation:** Specific code change or configuration fix required.
- **Reference:** Link to CWE, Go documentation, or security advisory.
```

Findings should be grouped by severity (CRITICAL first, then HIGH, MEDIUM, LOW, INFO) and deduplicated. Each finding must reference exactly one category from the checklist above.
