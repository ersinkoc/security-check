# Rust Security Checklist

> 400+ security checks for Rust applications.
> Used by security-check sc-lang-rust skill as reference.

## How to Use
This checklist is automatically referenced by the sc-lang-rust skill during security scans. It can also be used manually during code review.

## Categories

### 1. Input Validation & Sanitization (22 items)

- [ ] SC-RS-001: Validate string length limits — Ensure all user-supplied strings are checked against maximum length before processing to prevent buffer exhaustion. Severity: High. CWE: CWE-120.
- [ ] SC-RS-002: Sanitize HTML in user input — Strip or escape HTML tags from user input before rendering to prevent cross-site scripting. Severity: Critical. CWE: CWE-79.
- [ ] SC-RS-003: Validate numeric range boundaries — Check that numeric inputs fall within expected minimum and maximum bounds before arithmetic operations. Severity: High. CWE: CWE-190.
- [ ] SC-RS-004: Reject null bytes in strings — Detect and reject embedded null bytes in strings passed to C FFI or file system operations. Severity: High. CWE: CWE-158.
- [ ] SC-RS-005: Validate UTF-8 encoding — Ensure all external byte inputs are valid UTF-8 before converting to Rust strings, using from_utf8 instead of from_utf8_unchecked. Severity: High. CWE: CWE-176.
- [ ] SC-RS-006: Sanitize path traversal characters — Strip or reject ../ and ..\ sequences from user-supplied file paths. Severity: Critical. CWE: CWE-22.
- [ ] SC-RS-007: Validate email format — Use a well-tested regex or library to validate email addresses before processing. Severity: Medium. CWE: CWE-20.
- [ ] SC-RS-008: Validate URL schemes — Restrict URL inputs to expected schemes (https, http) to prevent javascript: or data: URI injection. Severity: High. CWE: CWE-601.
- [ ] SC-RS-009: Limit collection sizes from input — Enforce maximum sizes on Vec, HashMap, and other collections populated from untrusted input to prevent memory exhaustion. Severity: High. CWE: CWE-400.
- [ ] SC-RS-010: Validate regex input complexity — Limit the complexity and length of user-supplied regular expressions to prevent ReDoS attacks. Severity: High. CWE: CWE-1333.
- [ ] SC-RS-011: Sanitize SQL parameters — Use parameterized queries or prepared statements instead of string interpolation for database queries. Severity: Critical. CWE: CWE-89.
- [ ] SC-RS-012: Validate content type headers — Verify Content-Type headers match expected formats before parsing request bodies. Severity: Medium. CWE: CWE-20.
- [ ] SC-RS-013: Reject oversized request bodies — Enforce maximum request body size limits at the framework level to prevent denial of service. Severity: High. CWE: CWE-400.
- [ ] SC-RS-014: Validate integer parsing safely — Use str::parse::<T>() with proper error handling instead of unchecked conversions. Severity: Medium. CWE: CWE-704.
- [ ] SC-RS-015: Sanitize log output — Strip or escape control characters and newlines from user input before writing to logs. Severity: Medium. CWE: CWE-117.
- [ ] SC-RS-016: Validate JSON schema — Validate incoming JSON against an expected schema before processing to reject malformed or malicious payloads. Severity: Medium. CWE: CWE-20.
- [ ] SC-RS-017: Prevent CRLF injection — Reject or sanitize carriage return and line feed characters in HTTP header values derived from user input. Severity: High. CWE: CWE-93.
- [ ] SC-RS-018: Validate MIME types — Verify uploaded file MIME types using content inspection, not just the declared Content-Type. Severity: Medium. CWE: CWE-434.
- [ ] SC-RS-019: Limit recursion depth on input parsing — Set explicit recursion limits when parsing nested structures (JSON, XML, protobuf) from untrusted sources. Severity: High. CWE: CWE-674.
- [ ] SC-RS-020: Validate enum variants from integers — Use TryFrom instead of transmute when converting integer values to enum variants from external input. Severity: High. CWE: CWE-704.
- [ ] SC-RS-021: Sanitize command arguments — Escape or validate all user-supplied arguments passed to std::process::Command to prevent command injection. Severity: Critical. CWE: CWE-78.
- [ ] SC-RS-022: Validate IP address formats — Parse and validate IP address strings using std::net::IpAddr rather than raw string matching. Severity: Medium. CWE: CWE-20.

### 2. Authentication & Session Management (16 items)

- [ ] SC-RS-023: Use constant-time comparison for tokens — Compare authentication tokens and secrets using constant-time equality functions to prevent timing attacks. Severity: High. CWE: CWE-208.
- [ ] SC-RS-024: Hash passwords with Argon2 — Use argon2 or bcrypt crates for password hashing instead of SHA-256 or custom schemes. Severity: Critical. CWE: CWE-916.
- [ ] SC-RS-025: Enforce session expiration — Set and enforce maximum session lifetimes and idle timeouts on all session tokens. Severity: High. CWE: CWE-613.
- [ ] SC-RS-026: Regenerate session IDs after login — Issue a new session identifier after successful authentication to prevent session fixation. Severity: High. CWE: CWE-384.
- [ ] SC-RS-027: Validate JWT signatures — Always verify JWT signature and algorithm before trusting claims, rejecting "alg: none". Severity: Critical. CWE: CWE-347.
- [ ] SC-RS-028: Set secure cookie flags — Mark session cookies with Secure, HttpOnly, and SameSite attributes. Severity: High. CWE: CWE-614.
- [ ] SC-RS-029: Implement account lockout — Lock accounts after repeated failed authentication attempts to prevent brute force. Severity: Medium. CWE: CWE-307.
- [ ] SC-RS-030: Use cryptographically random session IDs — Generate session tokens using rand::rngs::OsRng or equivalent CSPRNG, not rand::thread_rng. Severity: Critical. CWE: CWE-330.
- [ ] SC-RS-031: Validate OAuth state parameter — Verify the OAuth state parameter on callback to prevent CSRF during authentication flows. Severity: High. CWE: CWE-352.
- [ ] SC-RS-032: Invalidate sessions on logout — Destroy server-side session data and clear client cookies when users log out. Severity: Medium. CWE: CWE-613.
- [ ] SC-RS-033: Protect against credential stuffing — Implement rate limiting and CAPTCHA on authentication endpoints. Severity: Medium. CWE: CWE-307.
- [ ] SC-RS-034: Avoid hardcoded credentials — Never embed passwords, API keys, or tokens directly in source code. Severity: Critical. CWE: CWE-798.
- [ ] SC-RS-035: Enforce password complexity — Require minimum password length and complexity requirements at the application level. Severity: Medium. CWE: CWE-521.
- [ ] SC-RS-036: Validate bearer token format — Check bearer token structure and expiration before processing protected requests. Severity: High. CWE: CWE-287.
- [ ] SC-RS-037: Implement multi-factor authentication — Support and encourage MFA for sensitive operations and admin access. Severity: Medium. CWE: CWE-308.
- [ ] SC-RS-038: Prevent session token leakage in URLs — Never pass session identifiers as URL query parameters; use headers or cookies instead. Severity: High. CWE: CWE-598.

### 3. Authorization & Access Control (16 items)

- [ ] SC-RS-039: Enforce least privilege — Grant the minimum necessary permissions to each user role and service account. Severity: High. CWE: CWE-269.
- [ ] SC-RS-040: Validate resource ownership — Verify that the authenticated user owns or has access to the requested resource before returning it. Severity: Critical. CWE: CWE-639.
- [ ] SC-RS-041: Implement role-based access control — Use a consistent RBAC framework to check permissions at every protected endpoint. Severity: High. CWE: CWE-285.
- [ ] SC-RS-042: Check authorization on every request — Perform authorization checks server-side on each request, not just on initial navigation. Severity: Critical. CWE: CWE-862.
- [ ] SC-RS-043: Prevent horizontal privilege escalation — Ensure users cannot access other users' data by manipulating IDs or parameters. Severity: Critical. CWE: CWE-639.
- [ ] SC-RS-044: Prevent vertical privilege escalation — Verify that regular users cannot invoke admin-level operations by forging requests. Severity: Critical. CWE: CWE-269.
- [ ] SC-RS-045: Validate function-level access — Apply authorization checks to every internal function or API handler that performs privileged operations. Severity: High. CWE: CWE-285.
- [ ] SC-RS-046: Restrict admin panel access — Protect administrative interfaces with separate authentication and IP-based restrictions. Severity: High. CWE: CWE-269.
- [ ] SC-RS-047: Enforce CORS policies — Configure CORS headers to allow only trusted origins and specific HTTP methods. Severity: High. CWE: CWE-346.
- [ ] SC-RS-048: Audit authorization failures — Log all failed authorization attempts with sufficient context for investigation. Severity: Medium. CWE: CWE-778.
- [ ] SC-RS-049: Prevent IDOR attacks — Use indirect references or UUIDs instead of sequential database IDs in API responses. Severity: High. CWE: CWE-639.
- [ ] SC-RS-050: Validate permission on file downloads — Check authorization before serving files, even if file paths are obscured. Severity: High. CWE: CWE-862.
- [ ] SC-RS-051: Separate public and private routes — Organize route handlers into clearly separated public and authenticated groups. Severity: Medium. CWE: CWE-285.
- [ ] SC-RS-052: Use deny-by-default policies — Default to denying access unless an explicit permission grant exists. Severity: High. CWE: CWE-276.
- [ ] SC-RS-053: Validate API scopes — Enforce OAuth scope restrictions on API endpoints to limit token capabilities. Severity: High. CWE: CWE-285.
- [ ] SC-RS-054: Protect against mass assignment — Restrict which struct fields can be populated from user input using dedicated DTOs. Severity: High. CWE: CWE-915.

### 4. Cryptography (26 items)

- [ ] SC-RS-055: Use vetted cryptography libraries — Rely on well-audited crates like ring, rustls, or rust-crypto instead of implementing custom cryptography. Severity: Critical. CWE: CWE-327.
- [ ] SC-RS-056: Avoid deprecated algorithms — Do not use MD5, SHA-1, DES, RC4, or other broken cryptographic algorithms for security purposes. Severity: Critical. CWE: CWE-327.
- [ ] SC-RS-057: Use appropriate key lengths — Ensure RSA keys are at least 2048 bits and AES keys are at least 128 bits. Severity: High. CWE: CWE-326.
- [ ] SC-RS-058: Generate keys with CSPRNG — Use OsRng or another cryptographically secure random number generator for all key material. Severity: Critical. CWE: CWE-338.
- [ ] SC-RS-059: Use unique IVs and nonces — Generate a fresh random IV or nonce for every encryption operation; never reuse nonces with the same key. Severity: Critical. CWE: CWE-329.
- [ ] SC-RS-060: Implement authenticated encryption — Use AEAD modes like AES-GCM or ChaCha20-Poly1305 instead of unauthenticated modes like AES-CBC. Severity: High. CWE: CWE-353.
- [ ] SC-RS-061: Protect private keys — Store private keys encrypted at rest and restrict file permissions to owner-only. Severity: Critical. CWE: CWE-312.
- [ ] SC-RS-062: Validate TLS certificates — Enable certificate validation in all TLS connections and do not accept self-signed certificates in production. Severity: Critical. CWE: CWE-295.
- [ ] SC-RS-063: Pin TLS certificates for critical services — Implement certificate pinning for connections to critical backend services. Severity: Medium. CWE: CWE-295.
- [ ] SC-RS-064: Use TLS 1.2 or higher — Disable TLS 1.0 and 1.1 in rustls or native-tls configurations. Severity: High. CWE: CWE-326.
- [ ] SC-RS-065: Verify HMAC before processing — Always verify message authentication codes before decrypting or processing the associated data. Severity: Critical. CWE: CWE-347.
- [ ] SC-RS-066: Avoid ECB mode — Never use ECB block cipher mode as it leaks patterns in encrypted data. Severity: High. CWE: CWE-327.
- [ ] SC-RS-067: Zeroize sensitive memory — Use the zeroize crate to clear cryptographic keys and secrets from memory when they are no longer needed. Severity: High. CWE: CWE-244.
- [ ] SC-RS-068: Use constant-time cryptographic operations — Ensure all comparison operations on secrets, MACs, and hashes use constant-time functions. Severity: High. CWE: CWE-208.
- [ ] SC-RS-069: Implement proper key rotation — Design systems to support periodic cryptographic key rotation without downtime. Severity: Medium. CWE: CWE-324.
- [ ] SC-RS-070: Use key derivation functions — Derive encryption keys from passwords using PBKDF2, scrypt, or Argon2 with appropriate parameters. Severity: High. CWE: CWE-916.
- [ ] SC-RS-071: Validate certificate chains — Verify the entire certificate chain up to a trusted root CA, not just the leaf certificate. Severity: High. CWE: CWE-296.
- [ ] SC-RS-072: Do not log cryptographic material — Ensure private keys, session keys, and plaintext secrets are never written to log files. Severity: Critical. CWE: CWE-532.
- [ ] SC-RS-073: Use secure random for salts — Generate unique random salts for each password hash using a CSPRNG. Severity: High. CWE: CWE-760.
- [ ] SC-RS-074: Avoid hardcoded cryptographic keys — Never embed encryption keys or secrets directly in source code or configuration files. Severity: Critical. CWE: CWE-321.
- [ ] SC-RS-075: Validate key sizes at runtime — Assert that key material passed to cryptographic functions has the expected length. Severity: Medium. CWE: CWE-326.
- [ ] SC-RS-076: Use separate keys for separate purposes — Do not reuse the same key for both encryption and signing or across different contexts. Severity: High. CWE: CWE-323.
- [ ] SC-RS-077: Protect against padding oracle attacks — Use authenticated encryption modes or implement encrypt-then-MAC to prevent padding oracle vulnerabilities. Severity: High. CWE: CWE-354.
- [ ] SC-RS-078: Secure random number seeding — Never seed random number generators with predictable values like timestamps or PIDs. Severity: High. CWE: CWE-335.
- [ ] SC-RS-079: Validate cryptographic output lengths — Check that hash digests and ciphertext have expected lengths before further processing. Severity: Medium. CWE: CWE-130.
- [ ] SC-RS-080: Use domain separation in hashing — Include context-specific prefixes or domain separators in hash inputs to prevent cross-protocol attacks. Severity: Medium. CWE: CWE-327.

### 5. Error Handling & Logging (21 items)

- [ ] SC-RS-081: Do not expose internal errors to users — Return generic error messages to clients while logging detailed errors server-side. Severity: Medium. CWE: CWE-209.
- [ ] SC-RS-082: Avoid unwrap in production code — Replace .unwrap() and .expect() with proper error handling using Result and the ? operator in library and server code. Severity: High. CWE: CWE-248.
- [ ] SC-RS-083: Handle all Result variants — Ensure every Result return value is explicitly handled, not silently discarded with let _ =. Severity: Medium. CWE: CWE-252.
- [ ] SC-RS-084: Implement custom error types — Define application-specific error types that hide implementation details from external consumers. Severity: Medium. CWE: CWE-209.
- [ ] SC-RS-085: Prevent panic propagation across FFI — Catch panics at FFI boundaries using catch_unwind to prevent undefined behavior. Severity: Critical. CWE: CWE-248.
- [ ] SC-RS-086: Log security-relevant events — Record authentication attempts, authorization failures, and input validation errors. Severity: Medium. CWE: CWE-778.
- [ ] SC-RS-087: Do not log sensitive data — Exclude passwords, tokens, credit card numbers, and PII from log messages. Severity: High. CWE: CWE-532.
- [ ] SC-RS-088: Use structured logging — Employ structured logging (e.g., tracing, slog) to enable reliable parsing and filtering of security events. Severity: Low. CWE: CWE-778.
- [ ] SC-RS-089: Handle panic in async tasks — Use catch_unwind or JoinHandle error handling in spawned async tasks to prevent silent failures. Severity: Medium. CWE: CWE-248.
- [ ] SC-RS-090: Avoid stack overflow in error handling — Ensure error Display/Debug implementations do not recursively call themselves or create unbounded output. Severity: Medium. CWE: CWE-674.
- [ ] SC-RS-091: Do not expose file paths in errors — Strip internal file system paths from error messages returned to clients. Severity: Medium. CWE: CWE-209.
- [ ] SC-RS-092: Do not expose database errors — Catch and translate database error messages before returning them to users to prevent schema leakage. Severity: Medium. CWE: CWE-209.
- [ ] SC-RS-093: Rate-limit error responses — Throttle error responses on authentication and sensitive endpoints to slow brute-force attacks. Severity: Medium. CWE: CWE-307.
- [ ] SC-RS-094: Implement global panic handler — Set a custom panic hook to log panics centrally rather than allowing uncontrolled output. Severity: Medium. CWE: CWE-248.
- [ ] SC-RS-095: Do not return stack traces in production — Disable debug-level stack traces and backtraces in production error responses. Severity: Medium. CWE: CWE-209.
- [ ] SC-RS-096: Handle out-of-memory gracefully — Configure global allocators to handle allocation failures without crashing or leaking state. Severity: Medium. CWE: CWE-789.
- [ ] SC-RS-097: Avoid error message injection — Ensure user-controlled data included in error messages is escaped to prevent log injection. Severity: Medium. CWE: CWE-117.
- [ ] SC-RS-098: Log errors with correlation IDs — Include request-scoped identifiers in log entries to enable tracing across distributed systems. Severity: Low. CWE: CWE-778.
- [ ] SC-RS-099: Validate error codes before mapping — Ensure error code mappings handle unexpected or out-of-range error values safely. Severity: Low. CWE: CWE-393.
- [ ] SC-RS-100: Avoid double panics — Ensure Drop implementations and panic hooks do not panic, which would cause immediate abort. Severity: High. CWE: CWE-248.
- [ ] SC-RS-101: Use #[must_use] on error-returning functions — Annotate functions returning Result with #[must_use] to prevent ignored errors at compile time. Severity: Medium. CWE: CWE-252.

### 6. Data Protection & Privacy (16 items)

- [ ] SC-RS-102: Encrypt sensitive data at rest — Encrypt PII, credentials, and other sensitive data before storing in databases or files. Severity: High. CWE: CWE-312.
- [ ] SC-RS-103: Encrypt data in transit — Use TLS for all network communications carrying sensitive data. Severity: High. CWE: CWE-319.
- [ ] SC-RS-104: Implement data minimization — Collect and retain only the minimum data necessary for the application's purpose. Severity: Medium. CWE: CWE-359.
- [ ] SC-RS-105: Mask sensitive data in displays — Redact or partially mask sensitive fields (SSNs, credit cards) when displayed or logged. Severity: Medium. CWE: CWE-359.
- [ ] SC-RS-106: Implement secure data deletion — Overwrite sensitive data before freeing memory using zeroize or secrecy crates. Severity: High. CWE: CWE-226.
- [ ] SC-RS-107: Prevent sensitive data in core dumps — Disable core dumps in production or mark sensitive pages as non-dumpable. Severity: Medium. CWE: CWE-528.
- [ ] SC-RS-108: Use secrecy crate for secrets — Wrap sensitive values in Secret<T> to prevent accidental logging and provide zeroize-on-drop. Severity: Medium. CWE: CWE-200.
- [ ] SC-RS-109: Implement data retention policies — Automatically purge or anonymize data past its retention period. Severity: Medium. CWE: CWE-359.
- [ ] SC-RS-110: Prevent data leakage in debug output — Implement custom Debug traits for types containing secrets to suppress sensitive fields. Severity: Medium. CWE: CWE-215.
- [ ] SC-RS-111: Sanitize data exports — Remove or redact sensitive fields when exporting data to CSV, JSON, or other formats. Severity: Medium. CWE: CWE-200.
- [ ] SC-RS-112: Protect clipboard operations — Clear clipboard contents containing sensitive data after use. Severity: Low. CWE: CWE-200.
- [ ] SC-RS-113: Prevent data leakage via error messages — Ensure error messages do not contain raw database records or user PII. Severity: Medium. CWE: CWE-209.
- [ ] SC-RS-114: Implement field-level encryption — Encrypt individual sensitive database fields independently where full-database encryption is insufficient. Severity: Medium. CWE: CWE-312.
- [ ] SC-RS-115: Validate data before cross-boundary transfer — Sanitize and validate all data before passing between trust boundaries (e.g., service-to-service). Severity: High. CWE: CWE-20.
- [ ] SC-RS-116: Implement consent-based data processing — Ensure data processing respects user consent preferences and GDPR/CCPA requirements. Severity: Medium. CWE: CWE-359.
- [ ] SC-RS-117: Protect against memory disclosure — Ensure uninitialized memory is never exposed in responses, logs, or error messages. Severity: High. CWE: CWE-908.

### 7. SQL/NoSQL/ORM Security (16 items)

- [ ] SC-RS-118: Use parameterized queries — Always use parameterized or prepared statements for all database queries, never string concatenation. Severity: Critical. CWE: CWE-89.
- [ ] SC-RS-119: Validate ORM query inputs — Ensure all inputs to Diesel, SQLx, or SeaORM queries are properly typed and validated. Severity: High. CWE: CWE-89.
- [ ] SC-RS-120: Limit query result sizes — Use LIMIT clauses and pagination to prevent queries from returning unbounded result sets. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-121: Protect against NoSQL injection — Sanitize inputs used in MongoDB, Redis, or other NoSQL query constructions. Severity: Critical. CWE: CWE-943.
- [ ] SC-RS-122: Use least-privilege database accounts — Connect to databases with accounts that have only the minimum required permissions. Severity: High. CWE: CWE-269.
- [ ] SC-RS-123: Encrypt database connections — Enable TLS for all database connections, especially across network boundaries. Severity: High. CWE: CWE-319.
- [ ] SC-RS-124: Protect against second-order injection — Validate data retrieved from the database before using it in subsequent queries. Severity: High. CWE: CWE-89.
- [ ] SC-RS-125: Sanitize LIKE clause patterns — Escape special characters (%, _) in user input used in SQL LIKE clauses. Severity: Medium. CWE: CWE-89.
- [ ] SC-RS-126: Use database connection pooling securely — Configure connection pools with timeouts and maximum connection limits to prevent exhaustion. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-127: Validate raw SQL usage — Audit all raw SQL strings (sql_query, raw_sql) for injection vulnerabilities. Severity: Critical. CWE: CWE-89.
- [ ] SC-RS-128: Handle database errors without information leakage — Catch and translate database constraint and syntax errors before returning to clients. Severity: Medium. CWE: CWE-209.
- [ ] SC-RS-129: Prevent mass data extraction — Implement query complexity limits and rate limiting on data-access endpoints. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-130: Use database migrations securely — Validate migration scripts for destructive operations and test rollbacks. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-131: Protect stored procedures — Review and parameterize any stored procedures called from Rust application code. Severity: High. CWE: CWE-89.
- [ ] SC-RS-132: Audit dynamic query construction — Review any code that builds SQL queries dynamically based on user input for injection risks. Severity: Critical. CWE: CWE-89.
- [ ] SC-RS-133: Validate database schema assumptions — Ensure application code correctly handles schema changes and missing columns without crashing. Severity: Medium. CWE: CWE-20.

### 8. File Operations (21 items)

- [ ] SC-RS-134: Canonicalize file paths — Use std::fs::canonicalize to resolve symbolic links and relative paths before access checks. Severity: High. CWE: CWE-22.
- [ ] SC-RS-135: Restrict file access to allowed directories — Validate that resolved file paths fall within an expected base directory. Severity: Critical. CWE: CWE-22.
- [ ] SC-RS-136: Set restrictive file permissions — Create files with minimal permissions (e.g., 0o600) and avoid world-readable or world-writable modes. Severity: High. CWE: CWE-276.
- [ ] SC-RS-137: Validate file extensions — Check file extensions against an allowlist, not a denylist, for uploaded files. Severity: Medium. CWE: CWE-434.
- [ ] SC-RS-138: Prevent symlink attacks — Check for and refuse to follow symbolic links in security-sensitive file operations. Severity: High. CWE: CWE-59.
- [ ] SC-RS-139: Use atomic file operations — Write files atomically using write-to-temp-then-rename to prevent partial writes and TOCTOU races. Severity: Medium. CWE: CWE-367.
- [ ] SC-RS-140: Limit file upload sizes — Enforce maximum file sizes at the web framework level before writing to disk. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-141: Validate file content types — Inspect file content (magic bytes) to verify type rather than trusting file extensions alone. Severity: Medium. CWE: CWE-434.
- [ ] SC-RS-142: Create temporary files securely — Use tempfile crate to create temporary files with restricted permissions in secure directories. Severity: Medium. CWE: CWE-377.
- [ ] SC-RS-143: Clean up temporary files — Ensure temporary files are deleted after use, even in error paths, using RAII or Drop. Severity: Low. CWE: CWE-459.
- [ ] SC-RS-144: Prevent zip slip attacks — Validate paths extracted from archive files to ensure they do not escape the target directory. Severity: Critical. CWE: CWE-22.
- [ ] SC-RS-145: Handle file locking — Use advisory or mandatory file locks when multiple processes may access the same file concurrently. Severity: Medium. CWE: CWE-367.
- [ ] SC-RS-146: Avoid TOCTOU in file checks — Do not check file existence or permissions and then operate on the file in separate steps. Severity: High. CWE: CWE-367.
- [ ] SC-RS-147: Validate file path characters — Reject file paths containing control characters or null bytes. Severity: High. CWE: CWE-158.
- [ ] SC-RS-148: Limit directory listing depth — Restrict recursive directory traversal depth to prevent excessive resource consumption. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-149: Sanitize file names — Remove or replace special characters in user-supplied file names before saving to disk. Severity: Medium. CWE: CWE-22.
- [ ] SC-RS-150: Protect against file descriptor exhaustion — Limit the number of open file descriptors and close files promptly after use. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-151: Avoid following hard links — Detect and handle hard links that may point to sensitive files outside allowed directories. Severity: Medium. CWE: CWE-59.
- [ ] SC-RS-152: Validate archive extraction paths — Check all file paths within tar, zip, or other archives for path traversal before extraction. Severity: Critical. CWE: CWE-22.
- [ ] SC-RS-153: Use O_NOFOLLOW for sensitive opens — Open files with O_NOFOLLOW flag equivalent to avoid following symlinks to unintended targets. Severity: Medium. CWE: CWE-59.
- [ ] SC-RS-154: Protect configuration file integrity — Verify checksums or signatures of configuration files before loading. Severity: Medium. CWE: CWE-345.

### 9. Network & HTTP Security (21 items)

- [ ] SC-RS-155: Enable HTTPS everywhere — Serve all HTTP traffic over TLS and redirect plain HTTP to HTTPS. Severity: High. CWE: CWE-319.
- [ ] SC-RS-156: Set security headers — Include Content-Security-Policy, X-Content-Type-Options, X-Frame-Options, and Strict-Transport-Security headers. Severity: Medium. CWE: CWE-693.
- [ ] SC-RS-157: Implement CSRF protection — Use CSRF tokens for state-changing requests in web applications. Severity: High. CWE: CWE-352.
- [ ] SC-RS-158: Configure request timeouts — Set read, write, and idle timeouts on all HTTP server and client connections. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-159: Limit concurrent connections — Configure maximum concurrent connection limits to prevent resource exhaustion. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-160: Validate Host headers — Check Host and X-Forwarded-Host headers against an allowlist to prevent host header injection. Severity: Medium. CWE: CWE-20.
- [ ] SC-RS-161: Prevent SSRF attacks — Validate and restrict outgoing HTTP requests to prevent server-side request forgery. Severity: Critical. CWE: CWE-918.
- [ ] SC-RS-162: Block requests to internal networks — Deny HTTP client requests to private IP ranges (10.x, 172.16.x, 192.168.x, 127.x) from user-controlled URLs. Severity: High. CWE: CWE-918.
- [ ] SC-RS-163: Implement rate limiting — Apply per-IP and per-user rate limits on all API and authentication endpoints. Severity: Medium. CWE: CWE-770.
- [ ] SC-RS-164: Validate redirect URLs — Check redirect targets against an allowlist to prevent open redirect vulnerabilities. Severity: Medium. CWE: CWE-601.
- [ ] SC-RS-165: Configure CORS carefully — Set Access-Control-Allow-Origin to specific trusted domains, never wildcard for authenticated endpoints. Severity: High. CWE: CWE-346.
- [ ] SC-RS-166: Disable unnecessary HTTP methods — Allow only required HTTP methods (GET, POST, etc.) and reject others with 405. Severity: Low. CWE: CWE-749.
- [ ] SC-RS-167: Validate WebSocket origins — Check WebSocket connection origin headers to prevent cross-site WebSocket hijacking. Severity: High. CWE: CWE-346.
- [ ] SC-RS-168: Implement connection draining — Gracefully drain existing connections during shutdown to prevent data loss. Severity: Low. CWE: CWE-404.
- [ ] SC-RS-169: Protect against HTTP request smuggling — Normalize and validate Content-Length and Transfer-Encoding headers to prevent request smuggling. Severity: High. CWE: CWE-444.
- [ ] SC-RS-170: Set DNS resolution timeouts — Configure DNS lookup timeouts to prevent hanging on unresponsive DNS servers. Severity: Low. CWE: CWE-400.
- [ ] SC-RS-171: Validate SSL/TLS hostname — Ensure TLS connections verify that the certificate hostname matches the requested hostname. Severity: Critical. CWE: CWE-297.
- [ ] SC-RS-172: Implement circuit breakers — Use circuit breaker patterns for outgoing HTTP requests to prevent cascade failures. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-173: Protect against Slowloris — Configure minimum data rates and header timeouts to mitigate slow HTTP denial-of-service attacks. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-174: Use HTTP/2 safely — Enable HTTP/2 with proper frame size limits and concurrent stream limits. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-175: Validate Content-Length — Reject requests where Content-Length does not match the actual body size. Severity: Medium. CWE: CWE-444.

### 10. Serialization & Deserialization (26 items)

- [ ] SC-RS-176: Set serde deserialization limits — Configure maximum depth and size limits when deserializing untrusted data with serde. Severity: High. CWE: CWE-400.
- [ ] SC-RS-177: Prevent serde bombs — Limit nesting depth and collection sizes in deserialized JSON/YAML/TOML to prevent exponential memory consumption. Severity: High. CWE: CWE-400.
- [ ] SC-RS-178: Deny unknown fields — Use #[serde(deny_unknown_fields)] on structs receiving untrusted input to reject unexpected data. Severity: Medium. CWE: CWE-20.
- [ ] SC-RS-179: Validate deserialized data — Apply validation logic after deserialization, as serde only checks structure, not business rules. Severity: High. CWE: CWE-20.
- [ ] SC-RS-180: Avoid deserializing into arbitrary types — Do not deserialize into Box<dyn Any> or erased types that bypass compile-time checks. Severity: High. CWE: CWE-502.
- [ ] SC-RS-181: Protect against YAML deserialization attacks — Use serde_yaml safely by disabling tag resolution that could trigger arbitrary type instantiation. Severity: High. CWE: CWE-502.
- [ ] SC-RS-182: Limit protobuf message sizes — Set maximum message size limits when deserializing Protocol Buffer messages with prost or protobuf crate. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-183: Validate XML against schema — Validate XML input against an expected schema and disable external entity processing. Severity: High. CWE: CWE-611.
- [ ] SC-RS-184: Disable XML external entities — Configure XML parsers to disable DTD processing and external entity resolution. Severity: Critical. CWE: CWE-611.
- [ ] SC-RS-185: Use typed deserialization — Deserialize into strongly-typed Rust structs rather than serde_json::Value where possible. Severity: Medium. CWE: CWE-502.
- [ ] SC-RS-186: Validate enum variant deserialization — Ensure deserialized enum variants are within expected values and handle unknown variants gracefully. Severity: Medium. CWE: CWE-20.
- [ ] SC-RS-187: Prevent integer overflow in deserialization — Use bounded integer types or custom deserializers to prevent overflow when deserializing numeric fields. Severity: Medium. CWE: CWE-190.
- [ ] SC-RS-188: Handle deserialization errors gracefully — Return appropriate error responses for malformed input rather than panicking. Severity: Medium. CWE: CWE-248.
- [ ] SC-RS-189: Validate string length in deserialized structs — Use custom deserializers or validators to enforce string length limits on deserialized fields. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-190: Protect bincode deserialization — Set configuration limits when using bincode for untrusted data as it trusts length prefixes. Severity: High. CWE: CWE-502.
- [ ] SC-RS-191: Avoid serde_json::from_reader on untrusted streams — Use from_slice with pre-validated buffers or set reader limits to prevent unbounded reading. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-192: Validate MessagePack deserialization — Apply size and depth limits when deserializing MessagePack data from untrusted sources. Severity: Medium. CWE: CWE-502.
- [ ] SC-RS-193: Use #[serde(rename_all)] consistently — Apply consistent field naming conventions to prevent deserialization mismatches. Severity: Low. CWE: CWE-20.
- [ ] SC-RS-194: Validate CBOR input sizes — Limit CBOR payload sizes and nesting depth when processing untrusted data. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-195: Prevent unbounded Vec deserialization — Use custom deserializers to cap the maximum number of elements in deserialized Vec fields. Severity: High. CWE: CWE-400.
- [ ] SC-RS-196: Audit custom Deserialize implementations — Review hand-written Deserialize impls for panics, infinite loops, and unchecked operations. Severity: High. CWE: CWE-502.
- [ ] SC-RS-197: Validate flatbuffers input — Verify FlatBuffer data integrity before accessing fields as the format trusts offset tables. Severity: High. CWE: CWE-125.
- [ ] SC-RS-198: Prevent duplicate key attacks — Handle duplicate keys in JSON/YAML maps by either rejecting them or using last-value-wins consistently. Severity: Medium. CWE: CWE-20.
- [ ] SC-RS-199: Protect against billion laughs in XML/YAML — Limit entity expansion in XML and alias resolution in YAML to prevent exponential blowup attacks. Severity: High. CWE: CWE-776.
- [ ] SC-RS-200: Avoid unsafe deserialization of function pointers — Never deserialize function pointers or vtable references from untrusted data. Severity: Critical. CWE: CWE-502.
- [ ] SC-RS-201: Validate serialization round-trip integrity — Ensure that serialize-then-deserialize produces equivalent data, especially for custom types. Severity: Low. CWE: CWE-502.

### 11. Concurrency & Race Conditions (31 items)

- [ ] SC-RS-202: Avoid data races with proper synchronization — Use Mutex, RwLock, or atomic types for all shared mutable state across threads. Severity: High. CWE: CWE-362.
- [ ] SC-RS-203: Prevent deadlocks with lock ordering — Establish and document a consistent lock acquisition order when multiple locks are needed. Severity: High. CWE: CWE-833.
- [ ] SC-RS-204: Use Arc for shared ownership across threads — Wrap heap-allocated data in Arc<T> when sharing between threads instead of raw pointers. Severity: High. CWE: CWE-362.
- [ ] SC-RS-205: Validate Send and Sync bounds — Ensure types shared across threads correctly implement Send and Sync, especially when using unsafe. Severity: Critical. CWE: CWE-362.
- [ ] SC-RS-206: Prevent Rc usage across threads — Never use Rc<T> in multi-threaded contexts; use Arc<T> instead. Severity: High. CWE: CWE-362.
- [ ] SC-RS-207: Handle mutex poisoning — Check for and handle PoisonError when acquiring mutex locks after another thread has panicked. Severity: Medium. CWE: CWE-362.
- [ ] SC-RS-208: Avoid holding locks across await points — Never hold a MutexGuard or RwLockGuard across .await points in async code to prevent deadlocks. Severity: High. CWE: CWE-833.
- [ ] SC-RS-209: Use tokio::sync for async contexts — Use tokio::sync::Mutex instead of std::sync::Mutex in async code to avoid blocking the runtime. Severity: High. CWE: CWE-833.
- [ ] SC-RS-210: Protect against TOCTOU races — Perform check-and-act operations atomically rather than as separate steps. Severity: High. CWE: CWE-367.
- [ ] SC-RS-211: Use atomic operations for simple counters — Prefer AtomicUsize and other atomic types over Mutex for simple numeric state. Severity: Low. CWE: CWE-362.
- [ ] SC-RS-212: Ensure cancellation safety in async tasks — Design async functions to be cancellation-safe when used with tokio::select! or similar. Severity: High. CWE: CWE-362.
- [ ] SC-RS-213: Handle tokio select! cancellation — Ensure that when a select! branch is cancelled, partially completed operations are properly rolled back or cleaned up. Severity: High. CWE: CWE-362.
- [ ] SC-RS-214: Prevent resource leaks in cancelled futures — Use Drop guards to release resources when async operations are cancelled mid-execution. Severity: Medium. CWE: CWE-404.
- [ ] SC-RS-215: Limit concurrent task spawning — Bound the number of concurrently spawned tasks to prevent thread pool and memory exhaustion. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-216: Use channels safely — Handle both send and receive errors on mpsc/oneshot channels to prevent panics and deadlocks. Severity: Medium. CWE: CWE-362.
- [ ] SC-RS-217: Protect against Rc/Arc reference cycles — Break reference cycles using Weak<T> to prevent memory leaks in cyclic data structures. Severity: Medium. CWE: CWE-401.
- [ ] SC-RS-218: Use RwLock appropriately — Prefer RwLock over Mutex when reads vastly outnumber writes, but avoid writer starvation. Severity: Low. CWE: CWE-362.
- [ ] SC-RS-219: Validate thread pool configurations — Set appropriate thread pool sizes based on workload characteristics and available resources. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-220: Prevent priority inversion — Avoid scenarios where high-priority threads are blocked waiting for locks held by low-priority threads. Severity: Medium. CWE: CWE-833.
- [ ] SC-RS-221: Use crossbeam for scoped threads — Prefer crossbeam scoped threads over manual lifetime management to prevent use-after-free in thread spawning. Severity: Medium. CWE: CWE-416.
- [ ] SC-RS-222: Handle task panics in thread pools — Configure thread pools to catch and handle panics rather than silently losing tasks. Severity: Medium. CWE: CWE-248.
- [ ] SC-RS-223: Avoid interior mutability with Cell across threads — Never share Cell<T> or RefCell<T> across thread boundaries as they are not thread-safe. Severity: High. CWE: CWE-362.
- [ ] SC-RS-224: Use Condvar correctly — Always re-check conditions after Condvar::wait returns due to possible spurious wakeups. Severity: Medium. CWE: CWE-362.
- [ ] SC-RS-225: Prevent async runtime blocking — Never call blocking operations in async tasks without spawn_blocking or block_in_place. Severity: High. CWE: CWE-833.
- [ ] SC-RS-226: Validate memory ordering for atomics — Use the correct Ordering (SeqCst, AcqRel, etc.) for atomic operations based on the synchronization requirements. Severity: High. CWE: CWE-362.
- [ ] SC-RS-227: Handle semaphore permits correctly — Ensure semaphore permits are released on all code paths, including error and panic paths. Severity: Medium. CWE: CWE-404.
- [ ] SC-RS-228: Prevent stale reads with volatile — Use volatile reads/writes or atomics when interfacing with memory-mapped I/O or shared memory. Severity: High. CWE: CWE-362.
- [ ] SC-RS-229: Protect shared file access — Use file locks or other coordination mechanisms when multiple threads or processes access the same file. Severity: Medium. CWE: CWE-367.
- [ ] SC-RS-230: Handle async stream backpressure — Implement backpressure in async streams to prevent unbounded buffering. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-231: Validate concurrent collection usage — Use concurrent-safe collections (dashmap, crossbeam) instead of wrapping standard collections in Mutex for performance-critical paths. Severity: Low. CWE: CWE-362.
- [ ] SC-RS-232: Ensure graceful shutdown of concurrent tasks — Implement cooperative cancellation to cleanly shut down all spawned tasks on application exit. Severity: Medium. CWE: CWE-404.

### 12. Dependency & Supply Chain (26 items)

- [ ] SC-RS-233: Audit dependencies with cargo-audit — Run cargo audit regularly to detect known vulnerabilities in dependencies. Severity: High. CWE: CWE-1035.
- [ ] SC-RS-234: Pin dependency versions — Use exact versions or narrow version ranges in Cargo.toml to prevent unexpected updates. Severity: Medium. CWE: CWE-1035.
- [ ] SC-RS-235: Review build.rs scripts — Audit build.rs scripts of dependencies for arbitrary code execution during builds. Severity: Critical. CWE: CWE-506.
- [ ] SC-RS-236: Check for typosquatted crates — Verify crate names carefully to avoid installing malicious packages with similar names. Severity: High. CWE: CWE-506.
- [ ] SC-RS-237: Use cargo-vet or cargo-crev — Employ supply chain verification tools to review and attest to dependency trustworthiness. Severity: Medium. CWE: CWE-1035.
- [ ] SC-RS-238: Minimize dependency count — Reduce the dependency tree to minimize attack surface and audit burden. Severity: Medium. CWE: CWE-1035.
- [ ] SC-RS-239: Review proc macro dependencies — Audit procedural macro crates as they execute during compilation with full system access. Severity: High. CWE: CWE-506.
- [ ] SC-RS-240: Lock dependency versions with Cargo.lock — Commit Cargo.lock to version control for applications to ensure reproducible builds. Severity: Medium. CWE: CWE-1035.
- [ ] SC-RS-241: Monitor dependency licenses — Verify that all dependency licenses are compatible with your project's license and policies. Severity: Low. CWE: CWE-1035.
- [ ] SC-RS-242: Check for yanked crate versions — Detect and replace yanked crate versions that may have been withdrawn for security reasons. Severity: Medium. CWE: CWE-1035.
- [ ] SC-RS-243: Use cargo-deny for policy enforcement — Configure cargo-deny to enforce policies on licenses, advisories, and sources. Severity: Medium. CWE: CWE-1035.
- [ ] SC-RS-244: Verify crate download sources — Ensure crates are downloaded from crates.io or trusted private registries only. Severity: High. CWE: CWE-494.
- [ ] SC-RS-245: Audit git dependencies — Review crates sourced from git repositories as they bypass crates.io publishing checks. Severity: High. CWE: CWE-494.
- [ ] SC-RS-246: Review path dependencies — Audit local path dependencies for unauthorized modifications. Severity: Medium. CWE: CWE-494.
- [ ] SC-RS-247: Check for unmaintained crates — Identify and plan replacements for dependencies that are no longer maintained. Severity: Medium. CWE: CWE-1035.
- [ ] SC-RS-248: Review feature flags of dependencies — Audit which feature flags are enabled on dependencies, as features may enable unsafe code or additional attack surface. Severity: Medium. CWE: CWE-1035.
- [ ] SC-RS-249: Protect against dependency confusion — Use private registries with scoping to prevent dependency confusion attacks. Severity: High. CWE: CWE-427.
- [ ] SC-RS-250: Validate checksum integrity — Verify that downloaded crate checksums match expected values in Cargo.lock. Severity: High. CWE: CWE-354.
- [ ] SC-RS-251: Monitor for new CVEs — Subscribe to security advisories for all direct and transitive dependencies. Severity: Medium. CWE: CWE-1035.
- [ ] SC-RS-252: Audit transitive dependencies — Review the full dependency tree, not just direct dependencies, for security issues. Severity: Medium. CWE: CWE-1035.
- [ ] SC-RS-253: Restrict build script capabilities — Sandbox or limit build.rs network access and file system operations where possible. Severity: Medium. CWE: CWE-506.
- [ ] SC-RS-254: Use reproducible builds — Configure builds to be reproducible to detect tampering in the build pipeline. Severity: Medium. CWE: CWE-1035.
- [ ] SC-RS-255: Avoid wildcard dependencies — Never use * version specifications in Cargo.toml. Severity: Medium. CWE: CWE-1035.
- [ ] SC-RS-256: Review MSRV compatibility — Ensure dependency minimum supported Rust versions align with your toolchain to avoid build issues. Severity: Low. CWE: CWE-1035.
- [ ] SC-RS-257: Check for known malicious crates — Cross-reference dependencies against known malicious crate databases before adoption. Severity: Critical. CWE: CWE-506.
- [ ] SC-RS-258: Audit workspace member dependencies — Review dependencies across all workspace members for consistency and security. Severity: Medium. CWE: CWE-1035.

### 13. Configuration & Secrets Management (16 items)

- [ ] SC-RS-259: Externalize secrets — Store secrets in environment variables, vaults, or secret managers, not in source code or config files. Severity: Critical. CWE: CWE-798.
- [ ] SC-RS-260: Encrypt configuration files containing secrets — Encrypt any configuration files that must contain sensitive values. Severity: High. CWE: CWE-312.
- [ ] SC-RS-261: Validate configuration values — Check all configuration values against expected types, ranges, and formats at startup. Severity: Medium. CWE: CWE-20.
- [ ] SC-RS-262: Use different configs per environment — Maintain separate configurations for development, staging, and production environments. Severity: Medium. CWE: CWE-489.
- [ ] SC-RS-263: Disable debug features in production — Ensure debug endpoints, verbose logging, and diagnostic tools are disabled in production. Severity: High. CWE: CWE-489.
- [ ] SC-RS-264: Protect .env files — Add .env files to .gitignore and restrict their file permissions. Severity: High. CWE: CWE-538.
- [ ] SC-RS-265: Rotate secrets regularly — Implement automated secret rotation for API keys, database passwords, and encryption keys. Severity: Medium. CWE: CWE-324.
- [ ] SC-RS-266: Use vault integration — Integrate with HashiCorp Vault, AWS Secrets Manager, or similar services for dynamic secret management. Severity: Medium. CWE: CWE-522.
- [ ] SC-RS-267: Validate environment variable types — Parse and validate environment variables into strongly-typed values at startup. Severity: Medium. CWE: CWE-20.
- [ ] SC-RS-268: Protect against config injection — Sanitize configuration values that are interpolated into commands, queries, or templates. Severity: High. CWE: CWE-94.
- [ ] SC-RS-269: Set secure defaults — Ensure all configuration options default to the most secure values. Severity: Medium. CWE: CWE-276.
- [ ] SC-RS-270: Restrict config file permissions — Set file permissions on configuration files to be readable only by the application user. Severity: Medium. CWE: CWE-276.
- [ ] SC-RS-271: Log configuration loading failures — Record configuration parsing and validation failures to aid debugging without exposing secret values. Severity: Low. CWE: CWE-778.
- [ ] SC-RS-272: Prevent secret leakage in process listings — Avoid passing secrets as command-line arguments which are visible in process listings. Severity: High. CWE: CWE-214.
- [ ] SC-RS-273: Validate feature flag configurations — Ensure feature flag systems cannot be manipulated to enable dangerous functionality. Severity: Medium. CWE: CWE-20.
- [ ] SC-RS-274: Use compile-time configuration where possible — Prefer compile-time constants for security-critical configuration to prevent runtime tampering. Severity: Low. CWE: CWE-20.

### 14. Memory Safety & Unsafe Code (42 items)

- [ ] SC-RS-275: Minimize unsafe blocks — Use unsafe code only when absolutely necessary and wrap it in safe abstractions. Severity: High. CWE: CWE-119.
- [ ] SC-RS-276: Document safety invariants — Add // SAFETY: comments to every unsafe block explaining why the operation is sound. Severity: Medium. CWE: CWE-119.
- [ ] SC-RS-277: Validate raw pointer dereferences — Ensure all raw pointers are non-null, properly aligned, and point to valid memory before dereferencing. Severity: Critical. CWE: CWE-476.
- [ ] SC-RS-278: Prevent use-after-free — Ensure raw pointers are not dereferenced after the memory they point to has been freed. Severity: Critical. CWE: CWE-416.
- [ ] SC-RS-279: Prevent double-free — Ensure Drop is not called multiple times on the same allocation when using ManuallyDrop or raw pointers. Severity: Critical. CWE: CWE-415.
- [ ] SC-RS-280: Validate transmute correctness — Verify that std::mem::transmute is only used between types with identical size, alignment, and valid representations. Severity: Critical. CWE: CWE-843.
- [ ] SC-RS-281: Avoid transmute to change lifetimes — Never use transmute to extend or alter reference lifetimes as this can create dangling references. Severity: Critical. CWE: CWE-416.
- [ ] SC-RS-282: Use MaybeUninit correctly — Initialize MaybeUninit values before calling assume_init and never create references to uninitialized memory. Severity: Critical. CWE: CWE-908.
- [ ] SC-RS-283: Validate slice::from_raw_parts arguments — Ensure the pointer is valid, properly aligned, and the length does not exceed the allocation for slice construction. Severity: Critical. CWE: CWE-125.
- [ ] SC-RS-284: Prevent buffer overflows in unsafe code — Verify all index calculations and buffer sizes in unsafe code to prevent out-of-bounds access. Severity: Critical. CWE: CWE-120.
- [ ] SC-RS-285: Validate union field access — Access union fields only when the active variant is known, as reading the wrong field is undefined behavior. Severity: High. CWE: CWE-843.
- [ ] SC-RS-286: Handle FFI null pointers — Check all pointers received from C/FFI functions for null before dereferencing. Severity: Critical. CWE: CWE-476.
- [ ] SC-RS-287: Validate FFI string conversions — Use CStr and CString correctly when passing strings across the FFI boundary, ensuring null termination. Severity: High. CWE: CWE-170.
- [ ] SC-RS-288: Prevent integer overflow in pointer arithmetic — Check for overflow when performing pointer offset calculations in unsafe code. Severity: High. CWE: CWE-190.
- [ ] SC-RS-289: Validate alignment in unsafe code — Ensure all memory accesses respect the alignment requirements of the target type. Severity: High. CWE: CWE-119.
- [ ] SC-RS-290: Audit unsafe impl Send — Verify that types implementing Send via unsafe impl actually satisfy the thread-safety requirements. Severity: Critical. CWE: CWE-362.
- [ ] SC-RS-291: Audit unsafe impl Sync — Verify that types implementing Sync via unsafe impl can actually be safely shared between threads. Severity: Critical. CWE: CWE-362.
- [ ] SC-RS-292: Prevent memory leaks with ManuallyDrop — Ensure ManuallyDrop values are eventually dropped or cleaned up on all code paths. Severity: Medium. CWE: CWE-401.
- [ ] SC-RS-293: Validate Vec::set_len usage — Only call Vec::set_len to decrease length or after initializing elements up to the new length. Severity: Critical. CWE: CWE-908.
- [ ] SC-RS-294: Avoid undefined behavior with uninitialized memory — Never create references to uninitialized memory; use MaybeUninit or ptr::write instead. Severity: Critical. CWE: CWE-908.
- [ ] SC-RS-295: Validate extern function signatures — Ensure extern "C" function declarations exactly match the C library's expected signature including types and calling convention. Severity: High. CWE: CWE-686.
- [ ] SC-RS-296: Handle panics in unsafe code — Ensure panic safety by considering what happens to invariants if code between unsafe operations panics. Severity: High. CWE: CWE-248.
- [ ] SC-RS-297: Prevent dangling pointers from Box::into_raw — Track ownership of raw pointers from Box::into_raw and ensure exactly one Box::from_raw reconstructs them. Severity: Critical. CWE: CWE-416.
- [ ] SC-RS-298: Validate pointer provenance — Ensure pointers used in unsafe code are derived from valid allocations and not fabricated from integers. Severity: High. CWE: CWE-119.
- [ ] SC-RS-299: Use NonNull for non-nullable pointers — Prefer NonNull<T> over *mut T when pointers are guaranteed non-null to encode the invariant in the type. Severity: Medium. CWE: CWE-476.
- [ ] SC-RS-300: Audit inline assembly — Review all asm! and global_asm! blocks for memory safety, register clobbering, and correctness. Severity: Critical. CWE: CWE-119.
- [ ] SC-RS-301: Prevent aliasing violations — Ensure mutable references created in unsafe code do not alias with other references to the same data. Severity: Critical. CWE: CWE-119.
- [ ] SC-RS-302: Validate Layout in allocator usage — Ensure Layout passed to alloc/dealloc has non-zero size and correct alignment. Severity: High. CWE: CWE-119.
- [ ] SC-RS-303: Handle FFI ownership correctly — Clearly define and document whether Rust or C owns allocated memory at FFI boundaries. Severity: High. CWE: CWE-401.
- [ ] SC-RS-304: Validate PhantomData usage — Use PhantomData correctly to communicate ownership and lifetime relationships to the compiler. Severity: Medium. CWE: CWE-119.
- [ ] SC-RS-305: Prevent undefined behavior from invalid values — Never create invalid values (e.g., bool that is not 0 or 1, null references) even in unsafe code. Severity: Critical. CWE: CWE-843.
- [ ] SC-RS-306: Use ptr::read/write for unaligned access — Use ptr::read_unaligned/write_unaligned instead of direct dereference for potentially unaligned memory. Severity: High. CWE: CWE-119.
- [ ] SC-RS-307: Validate custom allocator implementations — Audit custom GlobalAlloc implementations for memory safety and thread safety. Severity: Critical. CWE: CWE-119.
- [ ] SC-RS-308: Prevent out-of-bounds with pointer offset — Ensure ptr::offset and ptr::add do not move pointers outside allocated objects. Severity: Critical. CWE: CWE-125.
- [ ] SC-RS-309: Handle zero-sized types in unsafe code — Account for ZST behavior (zero-size, unique addresses) in generic unsafe code operating on raw pointers. Severity: Medium. CWE: CWE-119.
- [ ] SC-RS-310: Validate drop safety for Pin — Ensure Pin<T> values are not moved after pinning, especially in unsafe Drop implementations. Severity: High. CWE: CWE-416.
- [ ] SC-RS-311: Audit forget usage — Review std::mem::forget usage to ensure it does not cause resource leaks or safety invariant violations. Severity: Medium. CWE: CWE-401.
- [ ] SC-RS-312: Prevent UB from niche optimization — Never exploit niche values (e.g., None representation for Option<NonZero>) in unsafe code without proper understanding. Severity: High. CWE: CWE-843.
- [ ] SC-RS-313: Validate extern type sizes — Ensure extern types used in FFI have correct sizes matching the C definition. Severity: High. CWE: CWE-131.
- [ ] SC-RS-314: Use #[repr(C)] for FFI structs — Mark structs shared with C code as #[repr(C)] to ensure predictable memory layout. Severity: High. CWE: CWE-119.
- [ ] SC-RS-315: Validate bit patterns after transmute — After transmuting bytes to a type, verify the resulting value is a valid bit pattern for that type. Severity: Critical. CWE: CWE-843.
- [ ] SC-RS-316: Prevent stack overflow in recursive unsafe code — Set stack size limits and add depth checks in recursive algorithms that use unsafe operations. Severity: Medium. CWE: CWE-674.

### 15. Rust-Specific Patterns (31 items)

- [ ] SC-RS-317: Handle integer overflow explicitly — Use checked_add, saturating_mul, or wrapping_sub instead of relying on debug-mode overflow panics. Severity: High. CWE: CWE-190.
- [ ] SC-RS-318: Avoid panic in library code — Libraries should return Result instead of panicking, as callers cannot reliably catch panics. Severity: High. CWE: CWE-248.
- [ ] SC-RS-319: Use newtype pattern for validated types — Wrap validated values in newtype structs to prevent re-use of unvalidated data. Severity: Medium. CWE: CWE-20.
- [ ] SC-RS-320: Prevent index out of bounds — Use .get() instead of direct indexing ([]) when the index may be out of bounds. Severity: Medium. CWE: CWE-125.
- [ ] SC-RS-321: Handle Option properly — Use match, if let, or combinators instead of unwrap() on Option values that may be None. Severity: Medium. CWE: CWE-476.
- [ ] SC-RS-322: Avoid unreachable_unchecked misuse — Only use unreachable_unchecked when the condition is provably unreachable; prefer unreachable! otherwise. Severity: Critical. CWE: CWE-617.
- [ ] SC-RS-323: Use type system for state machines — Encode state transitions in the type system to prevent invalid state transitions at compile time. Severity: Medium. CWE: CWE-691.
- [ ] SC-RS-324: Prevent iterator invalidation — Do not modify collections while iterating over them; use retain(), drain(), or collect intermediate results. Severity: Medium. CWE: CWE-119.
- [ ] SC-RS-325: Handle string encoding correctly — Use OsStr/OsString for OS-level paths and strings that may not be valid UTF-8. Severity: Medium. CWE: CWE-176.
- [ ] SC-RS-326: Prevent silent truncation in as casts — Use TryFrom or TryInto instead of as for numeric conversions to detect truncation. Severity: High. CWE: CWE-681.
- [ ] SC-RS-327: Use exhaustive pattern matching — Avoid catch-all _ patterns in matches over enums to get compiler warnings when new variants are added. Severity: Medium. CWE: CWE-478.
- [ ] SC-RS-328: Handle overflow in duration calculations — Use checked_add on Duration and Instant to prevent overflow in timeout calculations. Severity: Medium. CWE: CWE-190.
- [ ] SC-RS-329: Prevent infinite loops in iterators — Ensure custom Iterator implementations always make progress and eventually return None. Severity: Medium. CWE: CWE-835.
- [ ] SC-RS-330: Use builder pattern for complex configuration — Use typed builders to ensure required fields are set and invalid configurations are rejected at compile time. Severity: Low. CWE: CWE-20.
- [ ] SC-RS-331: Validate From/Into implementations — Ensure From trait implementations for untrusted types include validation logic. Severity: Medium. CWE: CWE-20.
- [ ] SC-RS-332: Handle empty collections — Check for empty collections before operations like min(), max(), or indexing. Severity: Low. CWE: CWE-476.
- [ ] SC-RS-333: Use NonZeroU* for non-zero invariants — Use NonZeroU32 and similar types to prevent division-by-zero and encode non-zero invariants. Severity: Medium. CWE: CWE-369.
- [ ] SC-RS-334: Prevent usize overflow on 32-bit platforms — Account for usize being 32 bits on 32-bit targets when performing size calculations. Severity: Medium. CWE: CWE-190.
- [ ] SC-RS-335: Handle lossy conversions explicitly — Use to_string_lossy or from_utf8_lossy consciously and document where data loss may occur. Severity: Low. CWE: CWE-176.
- [ ] SC-RS-336: Validate Deref/DerefMut implementations — Ensure custom Deref implementations do not expose unsafe invariant violations. Severity: Medium. CWE: CWE-119.
- [ ] SC-RS-337: Use PhantomPinned for self-referential structs — Mark self-referential types with PhantomPinned to prevent moves that would invalidate internal pointers. Severity: High. CWE: CWE-416.
- [ ] SC-RS-338: Handle RefCell borrow panics — Use try_borrow and try_borrow_mut instead of borrow and borrow_mut when runtime borrow violations are possible. Severity: Medium. CWE: CWE-248.
- [ ] SC-RS-339: Validate Display implementations for security — Ensure Display implementations do not leak sensitive data when types are formatted in logs or errors. Severity: Medium. CWE: CWE-200.
- [ ] SC-RS-340: Use cfg attributes for platform-specific security — Apply platform-specific security configurations using conditional compilation attributes. Severity: Low. CWE: CWE-20.
- [ ] SC-RS-341: Handle capacity overflow in collections — Check for capacity overflow when pre-allocating large Vec or HashMap from untrusted size hints. Severity: High. CWE: CWE-190.
- [ ] SC-RS-342: Prevent silent integer wrapping — Enable overflow-checks in release profile for security-sensitive arithmetic, or use explicit checked operations. Severity: High. CWE: CWE-190.
- [ ] SC-RS-343: Handle str::split edge cases — Account for empty strings and trailing delimiters when splitting strings from untrusted input. Severity: Low. CWE: CWE-20.
- [ ] SC-RS-344: Validate trait object safety — Ensure trait objects (dyn Trait) are only created for object-safe traits to prevent compilation issues and unsafe workarounds. Severity: Low. CWE: CWE-119.
- [ ] SC-RS-345: Use Cow for efficient string handling — Use Cow<str> to avoid unnecessary allocations while maintaining ownership clarity. Severity: Low. CWE: CWE-400.
- [ ] SC-RS-346: Handle float comparison correctly — Use epsilon-based comparison or ordered float types instead of direct == for floating-point values in security-relevant logic. Severity: Medium. CWE: CWE-681.
- [ ] SC-RS-347: Validate generic type bounds — Ensure generic type parameters have appropriate trait bounds to prevent misuse. Severity: Low. CWE: CWE-20.

### 16. Framework-Specific: Actix-web/Axum/Rocket (26 items)

- [ ] SC-RS-348: Configure body size limits — Set explicit maximum request body sizes in Actix-web, Axum, or Rocket to prevent memory exhaustion. Severity: High. CWE: CWE-400.
- [ ] SC-RS-349: Use extractors with validation — Apply input validation on path, query, and JSON extractors rather than trusting raw values. Severity: High. CWE: CWE-20.
- [ ] SC-RS-350: Implement authentication middleware — Use framework middleware/guards to enforce authentication on protected routes consistently. Severity: Critical. CWE: CWE-287.
- [ ] SC-RS-351: Configure CORS middleware properly — Set specific allowed origins, methods, and headers in framework CORS configuration. Severity: High. CWE: CWE-346.
- [ ] SC-RS-352: Enable security headers middleware — Add middleware to set X-Content-Type-Options, X-Frame-Options, and CSP headers on all responses. Severity: Medium. CWE: CWE-693.
- [ ] SC-RS-353: Handle multipart uploads securely — Validate file size, type, and name in multipart form processing and store to secure locations. Severity: High. CWE: CWE-434.
- [ ] SC-RS-354: Protect against path traversal in routes — Validate path parameters and file-serving routes against directory traversal attacks. Severity: Critical. CWE: CWE-22.
- [ ] SC-RS-355: Implement rate limiting middleware — Add per-route or global rate limiting to prevent abuse of API endpoints. Severity: Medium. CWE: CWE-770.
- [ ] SC-RS-356: Use typed state extraction — Use framework-typed state extractors (Data, State, Extension) instead of global mutable state. Severity: Medium. CWE: CWE-362.
- [ ] SC-RS-357: Configure TLS in the framework — Enable TLS termination directly in the framework or ensure it is handled by a reverse proxy. Severity: High. CWE: CWE-319.
- [ ] SC-RS-358: Handle WebSocket messages safely — Validate and size-limit WebSocket messages and implement connection timeouts. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-359: Protect against template injection — Use auto-escaping in Tera, Askama, or other template engines and never render raw user input. Severity: High. CWE: CWE-79.
- [ ] SC-RS-360: Configure session storage securely — Use server-side session stores (Redis, database) with encryption rather than client-side cookies. Severity: Medium. CWE: CWE-539.
- [ ] SC-RS-361: Validate custom header extraction — Sanitize values extracted from custom HTTP headers before using them in application logic. Severity: Medium. CWE: CWE-20.
- [ ] SC-RS-362: Handle graceful shutdown — Implement proper shutdown handlers that complete in-flight requests and release resources. Severity: Low. CWE: CWE-404.
- [ ] SC-RS-363: Limit query parameter count — Restrict the number of accepted query parameters to prevent query parameter pollution attacks. Severity: Medium. CWE: CWE-235.
- [ ] SC-RS-364: Protect static file serving — Restrict static file serving to specific directories and prevent directory listing. Severity: Medium. CWE: CWE-548.
- [ ] SC-RS-365: Validate JSON content type — Reject requests to JSON endpoints that do not have the correct Content-Type header. Severity: Low. CWE: CWE-20.
- [ ] SC-RS-366: Use framework error handlers — Implement custom error handlers that return safe error responses instead of framework defaults. Severity: Medium. CWE: CWE-209.
- [ ] SC-RS-367: Configure keepalive timeouts — Set appropriate HTTP keepalive timeout values to prevent connection exhaustion. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-368: Validate Accept headers — Check Accept headers and return appropriate content types to prevent content type confusion. Severity: Low. CWE: CWE-20.
- [ ] SC-RS-369: Implement request ID tracing — Generate and propagate unique request IDs through middleware for security event correlation. Severity: Low. CWE: CWE-778.
- [ ] SC-RS-370: Protect against HTTP verb tampering — Ensure route handlers only respond to the intended HTTP methods. Severity: Medium. CWE: CWE-749.
- [ ] SC-RS-371: Validate redirect responses — Ensure redirect URIs in framework responses are validated against an allowlist. Severity: Medium. CWE: CWE-601.
- [ ] SC-RS-372: Handle form parsing limits — Set maximum field count and field size limits for URL-encoded form parsing. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-373: Use framework-provided CSRF protection — Enable and configure built-in CSRF protection tokens for state-changing form submissions. Severity: High. CWE: CWE-352.

### 17. API Security (16 items)

- [ ] SC-RS-374: Implement API versioning — Version APIs to allow security patches without breaking client compatibility. Severity: Low. CWE: CWE-693.
- [ ] SC-RS-375: Validate API request schemas — Validate all API request payloads against defined schemas before processing. Severity: High. CWE: CWE-20.
- [ ] SC-RS-376: Implement API key rotation — Support API key rotation without downtime by accepting both old and new keys during transition. Severity: Medium. CWE: CWE-324.
- [ ] SC-RS-377: Rate limit API endpoints individually — Apply different rate limits to different API endpoints based on their sensitivity and cost. Severity: Medium. CWE: CWE-770.
- [ ] SC-RS-378: Protect against GraphQL depth attacks — Limit query depth and complexity for GraphQL APIs to prevent denial of service. Severity: High. CWE: CWE-400.
- [ ] SC-RS-379: Validate pagination parameters — Check page size and offset parameters for reasonable bounds to prevent resource exhaustion. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-380: Implement request signing — Use HMAC-based request signing for API-to-API communication to ensure integrity and authenticity. Severity: Medium. CWE: CWE-345.
- [ ] SC-RS-381: Protect against batch operation abuse — Limit the number of operations in batch API requests to prevent resource exhaustion. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-382: Return minimal error information — API error responses should not include stack traces, internal paths, or implementation details. Severity: Medium. CWE: CWE-209.
- [ ] SC-RS-383: Validate webhook signatures — Verify HMAC or digital signatures on incoming webhook payloads before processing. Severity: High. CWE: CWE-347.
- [ ] SC-RS-384: Implement API request idempotency — Use idempotency keys for mutating operations to prevent replay attacks and duplicate processing. Severity: Medium. CWE: CWE-352.
- [ ] SC-RS-385: Protect against enumeration attacks — Use consistent response times and messages to prevent user/resource enumeration via API probing. Severity: Medium. CWE: CWE-204.
- [ ] SC-RS-386: Validate gRPC metadata — Sanitize and validate all gRPC metadata headers from untrusted clients. Severity: Medium. CWE: CWE-20.
- [ ] SC-RS-387: Protect against GraphQL introspection abuse — Disable GraphQL introspection in production to prevent schema disclosure. Severity: Medium. CWE: CWE-200.
- [ ] SC-RS-388: Implement API audit logging — Log all API requests with timestamps, client identity, and action for security audit trails. Severity: Medium. CWE: CWE-778.
- [ ] SC-RS-389: Validate response data — Ensure API responses do not inadvertently include sensitive fields that should be excluded. Severity: Medium. CWE: CWE-200.

### 18. Testing & CI/CD Security (16 items)

- [ ] SC-RS-390: Run cargo clippy in CI — Enable clippy with deny warnings in CI pipelines to catch common security-relevant lints. Severity: Medium. CWE: CWE-710.
- [ ] SC-RS-391: Use cargo-fuzz for fuzzing — Implement fuzz testing for parsers, deserializers, and other input-processing code. Severity: Medium. CWE: CWE-20.
- [ ] SC-RS-392: Run Miri for unsafe code — Use Miri to detect undefined behavior in unsafe code during testing. Severity: High. CWE: CWE-119.
- [ ] SC-RS-393: Test with AddressSanitizer — Compile and test with -Zsanitizer=address to detect memory safety issues. Severity: High. CWE: CWE-119.
- [ ] SC-RS-394: Implement property-based testing — Use proptest or quickcheck for security-critical code to test with random inputs. Severity: Medium. CWE: CWE-20.
- [ ] SC-RS-395: Test error handling paths — Write explicit tests for error handling, invalid inputs, and edge cases. Severity: Medium. CWE: CWE-248.
- [ ] SC-RS-396: Run cargo audit in CI — Automate dependency vulnerability scanning as part of the CI pipeline. Severity: High. CWE: CWE-1035.
- [ ] SC-RS-397: Protect CI secrets — Use CI platform secret management and never print secrets in build logs. Severity: High. CWE: CWE-532.
- [ ] SC-RS-398: Verify build reproducibility — Check that CI builds produce identical artifacts from the same source to detect tampering. Severity: Medium. CWE: CWE-1035.
- [ ] SC-RS-399: Test with ThreadSanitizer — Compile and test with -Zsanitizer=thread to detect data races in concurrent code. Severity: High. CWE: CWE-362.
- [ ] SC-RS-400: Sign release artifacts — Digitally sign release binaries and publish checksums to enable verification by consumers. Severity: Medium. CWE: CWE-345.
- [ ] SC-RS-401: Scan for secrets in commits — Use tools like gitleaks or trufflehog in CI to detect accidentally committed secrets. Severity: High. CWE: CWE-798.
- [ ] SC-RS-402: Test with overflow checks enabled — Run tests with overflow-checks = true in release mode to detect integer overflow bugs. Severity: Medium. CWE: CWE-190.
- [ ] SC-RS-403: Implement SAST scanning — Integrate static analysis tools like cargo-geiger or rust-audit into the CI pipeline. Severity: Medium. CWE: CWE-119.
- [ ] SC-RS-404: Test boundary conditions — Explicitly test maximum, minimum, zero, and negative values for all numeric inputs. Severity: Medium. CWE: CWE-20.
- [ ] SC-RS-405: Protect CI/CD pipeline configuration — Restrict write access to CI configuration files and require reviews for changes. Severity: High. CWE: CWE-284.

### 19. Logging & Monitoring Security (12 items)

- [ ] SC-RS-406: Implement centralized logging — Aggregate logs from all application instances to a central, tamper-resistant logging service. Severity: Medium. CWE: CWE-778.
- [ ] SC-RS-407: Protect log integrity — Write logs to append-only storage or sign log entries to detect tampering. Severity: Medium. CWE: CWE-117.
- [ ] SC-RS-408: Implement security alerting — Configure alerts for authentication failures, authorization violations, and anomalous patterns. Severity: Medium. CWE: CWE-778.
- [ ] SC-RS-409: Monitor for dependency vulnerabilities — Set up automated monitoring for new CVEs affecting project dependencies. Severity: Medium. CWE: CWE-1035.
- [ ] SC-RS-410: Log authentication events — Record all login attempts, password changes, and session operations with timestamps and source IPs. Severity: Medium. CWE: CWE-778.
- [ ] SC-RS-411: Implement audit trails — Maintain immutable audit logs for all security-relevant operations and data access. Severity: Medium. CWE: CWE-778.
- [ ] SC-RS-412: Monitor resource utilization — Track CPU, memory, and connection metrics to detect denial-of-service conditions. Severity: Low. CWE: CWE-400.
- [ ] SC-RS-413: Rotate log files — Implement log rotation with retention policies to prevent disk exhaustion and ensure compliance. Severity: Low. CWE: CWE-400.
- [ ] SC-RS-414: Protect log transport — Encrypt log data in transit to centralized logging services using TLS. Severity: Medium. CWE: CWE-319.
- [ ] SC-RS-415: Filter sensitive data from traces — Configure distributed tracing to exclude sensitive request/response bodies and headers. Severity: Medium. CWE: CWE-532.
- [ ] SC-RS-416: Monitor for unusual error rates — Alert on sudden spikes in error rates that may indicate attack attempts or system compromise. Severity: Medium. CWE: CWE-778.
- [ ] SC-RS-417: Implement health check security — Protect health check endpoints from information disclosure while keeping them functional. Severity: Low. CWE: CWE-200.

### 20. Third-Party Integration Security (12 items)

- [ ] SC-RS-418: Validate webhook payloads — Verify signatures and validate schemas on all incoming webhook data from third-party services. Severity: High. CWE: CWE-345.
- [ ] SC-RS-419: Use timeouts for external calls — Set connection and response timeouts on all HTTP client calls to external services. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-420: Sanitize data from external APIs — Treat all data received from third-party APIs as untrusted and validate before processing. Severity: High. CWE: CWE-20.
- [ ] SC-RS-421: Protect API keys for external services — Store third-party API keys in secret management systems, not in source code. Severity: Critical. CWE: CWE-798.
- [ ] SC-RS-422: Implement circuit breakers for integrations — Use circuit breaker patterns to prevent cascade failures when external services are unavailable. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-423: Log external API interactions — Record all requests and responses to third-party services for debugging and security auditing. Severity: Low. CWE: CWE-778.
- [ ] SC-RS-424: Validate OAuth tokens from providers — Verify OAuth tokens against the provider's token introspection endpoint rather than trusting claims. Severity: High. CWE: CWE-287.
- [ ] SC-RS-425: Handle external service errors gracefully — Ensure failures from external services do not expose internal details or crash the application. Severity: Medium. CWE: CWE-209.
- [ ] SC-RS-426: Implement retry limits — Set maximum retry counts for failed external service calls to prevent infinite retry loops. Severity: Medium. CWE: CWE-400.
- [ ] SC-RS-427: Validate TLS certificates of external services — Ensure outgoing HTTPS connections validate the server's TLS certificate and hostname. Severity: High. CWE: CWE-295.
- [ ] SC-RS-428: Restrict outgoing network access — Limit which external hosts and ports the application can connect to, using firewall rules or proxy configurations. Severity: Medium. CWE: CWE-918.
- [ ] SC-RS-429: Protect against SSRF via integrations — Validate and restrict URLs constructed from user input before making requests to external services. Severity: Critical. CWE: CWE-918.
