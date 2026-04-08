# Go Security Checklist

> 415+ security checks for Go applications.
> Used by security-check sc-lang-go skill as reference.

## How to Use
This checklist is automatically referenced by the sc-lang-go skill during security scans. It can also be used manually during code review.

## Categories

### 1. Input Validation & Sanitization (25 items)

- [ ] SC-GO-001: Validate all external input — Ensure every value from HTTP requests, CLI args, environment variables, and file reads is validated before use. Severity: Critical. CWE: CWE-20.
- [ ] SC-GO-002: Reject null bytes in string input — Check for and reject embedded null bytes (\x00) in string inputs that interact with C libraries or file systems. Severity: High. CWE: CWE-158.
- [ ] SC-GO-003: Enforce maximum input length — Set and enforce maximum length limits on all string inputs to prevent buffer exhaustion and ReDoS. Severity: High. CWE: CWE-770.
- [ ] SC-GO-004: Validate integer boundaries — Check that integer inputs fall within expected min/max ranges before arithmetic operations. Severity: High. CWE: CWE-190.
- [ ] SC-GO-005: Sanitize input for HTML output — Use html/template (not text/template) for HTML rendering to auto-escape output. Severity: Critical. CWE: CWE-79.
- [ ] SC-GO-006: Validate email format with net/mail — Use net/mail.ParseAddress or a well-tested regex rather than custom parsing for email validation. Severity: Medium. CWE: CWE-20.
- [ ] SC-GO-007: Validate URL input with net/url.Parse — Parse and validate all URL inputs using net/url.Parse and verify scheme and host. Severity: High. CWE: CWE-20.
- [ ] SC-GO-008: Prevent CRLF injection — Strip or reject \r\n sequences in inputs used in HTTP headers, logs, or SMTP commands. Severity: High. CWE: CWE-93.
- [ ] SC-GO-009: Validate content type on upload — Check the Content-Type header and perform magic byte verification for file uploads. Severity: Medium. CWE: CWE-434.
- [ ] SC-GO-010: Use allowlists over denylists — Prefer allowlist-based validation (known-good characters/values) over denylist-based approaches. Severity: Medium. CWE: CWE-184.
- [ ] SC-GO-011: Validate JSON schema before processing — Validate incoming JSON against a schema before unmarshalling into business logic structs. Severity: Medium. CWE: CWE-20.
- [ ] SC-GO-012: Prevent path traversal in input — Validate that user-supplied path components do not contain ../ or absolute path prefixes. Severity: Critical. CWE: CWE-22.
- [ ] SC-GO-013: Normalize Unicode before validation — Normalize Unicode strings (NFC/NFKC) before performing security-relevant comparisons or validation. Severity: Medium. CWE: CWE-176.
- [ ] SC-GO-014: Validate regex patterns from user input — If accepting regex from users, compile with a timeout or use RE2-safe patterns to prevent ReDoS. Severity: High. CWE: CWE-1333.
- [ ] SC-GO-015: Sanitize input for SQL — Use parameterized queries instead of string concatenation for all SQL statements. Severity: Critical. CWE: CWE-89.
- [ ] SC-GO-016: Sanitize input for OS commands — Never pass unsanitized user input to os/exec; use argument arrays instead of shell strings. Severity: Critical. CWE: CWE-78.
- [ ] SC-GO-017: Validate MIME types for file uploads — Verify file MIME types using http.DetectContentType and do not rely solely on file extensions. Severity: Medium. CWE: CWE-434.
- [ ] SC-GO-018: Limit request body size — Use http.MaxBytesReader to limit the size of incoming HTTP request bodies. Severity: High. CWE: CWE-770.
- [ ] SC-GO-019: Validate IP address input — Parse and validate IP addresses using net.ParseIP rather than regex or string matching. Severity: Medium. CWE: CWE-20.
- [ ] SC-GO-020: Reject overlong UTF-8 sequences — Ensure inputs are valid UTF-8 using utf8.Valid before processing. Severity: Medium. CWE: CWE-176.
- [ ] SC-GO-021: Prevent XML injection — Use encoding/xml with properly escaped values; avoid string concatenation for XML construction. Severity: High. CWE: CWE-91.
- [ ] SC-GO-022: Validate struct tags for binding — Ensure Go struct tags used for input binding (json, form, xml) have proper validation annotations. Severity: Medium. CWE: CWE-20.
- [ ] SC-GO-023: Strip dangerous HTML tags — When accepting HTML input, use a sanitizer library like bluemonday to strip dangerous tags and attributes. Severity: High. CWE: CWE-79.
- [ ] SC-GO-024: Validate numeric string conversions — Check errors from strconv.Atoi, strconv.ParseInt, and similar functions to prevent invalid data propagation. Severity: Medium. CWE: CWE-20.
- [ ] SC-GO-025: Prevent HTTP parameter pollution — Validate that query parameters are not duplicated or conflicting when multiple values are accepted. Severity: Medium. CWE: CWE-235.

### 2. Authentication & Session Management (20 items)

- [ ] SC-GO-026: Use bcrypt or argon2 for password hashing — Hash passwords with golang.org/x/crypto/bcrypt or argon2id; never use MD5, SHA1, or SHA256 alone. Severity: Critical. CWE: CWE-916.
- [ ] SC-GO-027: Enforce minimum password complexity — Require passwords to meet length, character class, and entropy requirements. Severity: Medium. CWE: CWE-521.
- [ ] SC-GO-028: Use constant-time comparison for secrets — Use crypto/subtle.ConstantTimeCompare for comparing tokens, passwords, and secrets to prevent timing attacks. Severity: High. CWE: CWE-208.
- [ ] SC-GO-029: Implement session expiration — Set absolute and idle timeout durations on all sessions and invalidate them server-side. Severity: High. CWE: CWE-613.
- [ ] SC-GO-030: Regenerate session ID after login — Create a new session identifier after successful authentication to prevent session fixation. Severity: High. CWE: CWE-384.
- [ ] SC-GO-031: Secure session cookie attributes — Set HttpOnly, Secure, SameSite=Strict, and appropriate Path/Domain on session cookies. Severity: High. CWE: CWE-614.
- [ ] SC-GO-032: Implement account lockout — Lock accounts after a configurable number of failed authentication attempts. Severity: Medium. CWE: CWE-307.
- [ ] SC-GO-033: Use cryptographically random session IDs — Generate session tokens using crypto/rand, not math/rand, to ensure unpredictability. Severity: Critical. CWE: CWE-330.
- [ ] SC-GO-034: Implement CSRF protection — Include and validate CSRF tokens for all state-changing requests in web applications. Severity: High. CWE: CWE-352.
- [ ] SC-GO-035: Validate JWT signature algorithm — Explicitly specify the expected signing algorithm when validating JWTs to prevent algorithm confusion attacks. Severity: Critical. CWE: CWE-347.
- [ ] SC-GO-036: Validate JWT claims — Verify exp, iat, nbf, iss, and aud claims in JWTs; do not rely on signature verification alone. Severity: High. CWE: CWE-287.
- [ ] SC-GO-037: Store tokens securely server-side — Store session and refresh tokens in secure server-side storage; never expose them in URLs or logs. Severity: High. CWE: CWE-522.
- [ ] SC-GO-038: Implement multi-factor authentication — Support MFA/2FA for high-privilege operations and sensitive account changes. Severity: Medium. CWE: CWE-308.
- [ ] SC-GO-039: Invalidate sessions on password change — Destroy all active sessions when a user changes their password. Severity: Medium. CWE: CWE-613.
- [ ] SC-GO-040: Implement secure password reset — Use time-limited, single-use, cryptographically random tokens for password reset flows. Severity: High. CWE: CWE-640.
- [ ] SC-GO-041: Prevent user enumeration — Return identical responses for valid and invalid usernames during login and password reset. Severity: Medium. CWE: CWE-203.
- [ ] SC-GO-042: Validate OAuth2 state parameter — Include and validate a cryptographically random state parameter in OAuth2 flows. Severity: High. CWE: CWE-352.
- [ ] SC-GO-043: Implement token revocation — Provide a mechanism to revoke access and refresh tokens before their natural expiry. Severity: Medium. CWE: CWE-613.
- [ ] SC-GO-044: Limit session concurrency — Restrict the number of simultaneous active sessions per user account. Severity: Low. CWE: CWE-770.
- [ ] SC-GO-045: Protect against credential stuffing — Implement rate limiting, CAPTCHA, and breached-password checks for authentication endpoints. Severity: High. CWE: CWE-307.

### 3. Authorization & Access Control (20 items)

- [ ] SC-GO-046: Enforce authorization on every endpoint — Apply authorization checks server-side for every API endpoint and resource access; do not rely on client-side checks. Severity: Critical. CWE: CWE-862.
- [ ] SC-GO-047: Implement principle of least privilege — Grant only the minimum permissions necessary for each user role and service account. Severity: High. CWE: CWE-269.
- [ ] SC-GO-048: Validate resource ownership — Verify that the authenticated user owns or has permission to access the requested resource (IDOR prevention). Severity: Critical. CWE: CWE-639.
- [ ] SC-GO-049: Use middleware for authorization — Centralize authorization logic in middleware or interceptors rather than repeating checks in handlers. Severity: Medium. CWE: CWE-862.
- [ ] SC-GO-050: Prevent privilege escalation — Validate that users cannot modify their own roles, permissions, or access levels through API manipulation. Severity: Critical. CWE: CWE-269.
- [ ] SC-GO-051: Enforce role-based access control — Implement RBAC with clearly defined roles and permissions mapped to application functions. Severity: High. CWE: CWE-862.
- [ ] SC-GO-052: Validate function-level access — Ensure administrative and privileged functions are not accessible to regular users. Severity: Critical. CWE: CWE-285.
- [ ] SC-GO-053: Check authorization for file access — Verify user permissions before serving files, not just authentication status. Severity: High. CWE: CWE-862.
- [ ] SC-GO-054: Implement deny-by-default — Default to denying access and explicitly grant permissions rather than denying specific cases. Severity: High. CWE: CWE-276.
- [ ] SC-GO-055: Protect horizontal access — Prevent users from accessing other users' data by validating tenant/user scope on all queries. Severity: Critical. CWE: CWE-639.
- [ ] SC-GO-056: Validate indirect object references — Map user-facing IDs to internal references server-side to prevent IDOR vulnerabilities. Severity: High. CWE: CWE-639.
- [ ] SC-GO-057: Restrict admin panel access — Protect administrative interfaces with additional authentication and IP-based restrictions. Severity: High. CWE: CWE-269.
- [ ] SC-GO-058: Enforce authorization on GraphQL resolvers — Apply per-field and per-resolver authorization in GraphQL APIs, not just at the query level. Severity: High. CWE: CWE-862.
- [ ] SC-GO-059: Validate API key scopes — Check that API keys have the required scope for the requested operation. Severity: High. CWE: CWE-285.
- [ ] SC-GO-060: Implement attribute-based access control — Use ABAC where RBAC is insufficient, considering user attributes, resource attributes, and environment conditions. Severity: Medium. CWE: CWE-862.
- [ ] SC-GO-061: Log authorization failures — Record all authorization failures with user identity, resource, and timestamp for audit purposes. Severity: Medium. CWE: CWE-778.
- [ ] SC-GO-062: Prevent mass assignment — Use explicit field mapping when binding request data to structs; do not auto-bind all fields. Severity: High. CWE: CWE-915.
- [ ] SC-GO-063: Validate multi-tenancy boundaries — Enforce tenant isolation at the data layer and verify tenant context on every request. Severity: Critical. CWE: CWE-668.
- [ ] SC-GO-064: Restrict cross-service access — Validate service-to-service authentication and authorization in microservice architectures. Severity: High. CWE: CWE-285.
- [ ] SC-GO-065: Prevent forced browsing — Ensure that direct URL access to resources is subject to the same authorization as navigated access. Severity: High. CWE: CWE-425.

### 4. Cryptography (25 items)

- [ ] SC-GO-066: Use crypto/rand for random numbers — Always use crypto/rand.Read for security-sensitive random values; never use math/rand. Severity: Critical. CWE: CWE-338.
- [ ] SC-GO-067: Use strong TLS configuration — Configure TLS with MinVersion TLS 1.2, prefer TLS 1.3, and disable weak cipher suites. Severity: High. CWE: CWE-326.
- [ ] SC-GO-068: Verify TLS certificates — Never set InsecureSkipVerify to true in production TLS configurations. Severity: Critical. CWE: CWE-295.
- [ ] SC-GO-069: Use AES-GCM or ChaCha20-Poly1305 — Use authenticated encryption (AEAD) ciphers; avoid ECB mode and unauthenticated ciphers. Severity: High. CWE: CWE-327.
- [ ] SC-GO-070: Never hardcode cryptographic keys — Load encryption keys from secure vaults or environment variables; never embed them in source code. Severity: Critical. CWE: CWE-798.
- [ ] SC-GO-071: Use unique nonces for each encryption — Generate a fresh random nonce for every encryption operation; never reuse nonces. Severity: Critical. CWE: CWE-323.
- [ ] SC-GO-072: Use appropriate key sizes — Use at least 256-bit keys for AES, 2048-bit for RSA (preferring 4096), and 256-bit for ECDSA. Severity: High. CWE: CWE-326.
- [ ] SC-GO-073: Implement key rotation — Design cryptographic systems to support regular key rotation without data loss. Severity: Medium. CWE: CWE-320.
- [ ] SC-GO-074: Use HMAC for message authentication — Use crypto/hmac with SHA-256 or better for message authentication codes; do not use plain hashes. Severity: High. CWE: CWE-328.
- [ ] SC-GO-075: Avoid deprecated hash functions — Do not use MD5 or SHA1 for any security purpose; use SHA-256 or SHA-3 instead. Severity: High. CWE: CWE-328.
- [ ] SC-GO-076: Use constant-time comparison for MACs — Compare HMACs and MACs using crypto/subtle.ConstantTimeCompare to prevent timing attacks. Severity: High. CWE: CWE-208.
- [ ] SC-GO-077: Validate certificate chains — Verify the entire certificate chain including intermediate certificates and revocation status. Severity: High. CWE: CWE-295.
- [ ] SC-GO-078: Use proper RSA padding — Use OAEP padding for RSA encryption and PSS for RSA signatures; avoid PKCS1v15. Severity: High. CWE: CWE-780.
- [ ] SC-GO-079: Protect private keys at rest — Encrypt private keys stored on disk and restrict file permissions to the owning process. Severity: High. CWE: CWE-312.
- [ ] SC-GO-080: Use Ed25519 for signatures — Prefer Ed25519 over RSA or ECDSA for digital signatures due to its security and performance characteristics. Severity: Medium. CWE: CWE-327.
- [ ] SC-GO-081: Implement certificate pinning for critical connections — Pin certificates or public keys for connections to known critical services to prevent MITM attacks. Severity: Medium. CWE: CWE-295.
- [ ] SC-GO-082: Derive keys with proper KDFs — Use Argon2id, scrypt, or PBKDF2 with high iteration counts for deriving keys from passwords. Severity: High. CWE: CWE-916.
- [ ] SC-GO-083: Use unique salts for each hash — Generate a random salt per password/key derivation; never reuse salts. Severity: High. CWE: CWE-760.
- [ ] SC-GO-084: Validate cryptographic input lengths — Check that ciphertext, nonce, and key inputs are the correct length before cryptographic operations. Severity: Medium. CWE: CWE-20.
- [ ] SC-GO-085: Avoid custom cryptographic implementations — Use Go standard library or golang.org/x/crypto packages; never implement custom ciphers or protocols. Severity: Critical. CWE: CWE-327.
- [ ] SC-GO-086: Securely erase key material from memory — Zero out byte slices containing keys and secrets after use, though Go GC may limit effectiveness. Severity: Medium. CWE: CWE-316.
- [ ] SC-GO-087: Use appropriate elliptic curves — Use P-256, P-384, or P-521 curves from crypto/elliptic; avoid custom or non-standard curves. Severity: High. CWE: CWE-327.
- [ ] SC-GO-088: Implement proper IV/nonce generation — Use crypto/rand for IV/nonce generation; never derive IVs from predictable data. Severity: High. CWE: CWE-329.
- [ ] SC-GO-089: Validate digital signatures before trust — Always verify signatures on data (JWTs, signed payloads, certificates) before processing content. Severity: Critical. CWE: CWE-347.
- [ ] SC-GO-090: Prevent downgrade attacks — Enforce minimum acceptable TLS versions and cipher suites; reject connections that attempt downgrades. Severity: High. CWE: CWE-757.

### 5. Error Handling & Logging (20 items)

- [ ] SC-GO-091: Never expose stack traces to users — Return generic error messages to clients; log detailed errors server-side only. Severity: Medium. CWE: CWE-209.
- [ ] SC-GO-092: Check all error returns — Handle every returned error in Go; do not use blank identifier to discard errors from security-relevant operations. Severity: High. CWE: CWE-391.
- [ ] SC-GO-093: Avoid panic in production handlers — Use recover() in goroutines and HTTP handlers; never let panics crash the entire service. Severity: High. CWE: CWE-248.
- [ ] SC-GO-094: Do not log sensitive data — Exclude passwords, tokens, credit card numbers, PII, and secrets from log output. Severity: High. CWE: CWE-532.
- [ ] SC-GO-095: Use structured logging — Use structured logging (slog, zerolog, zap) to prevent log injection and enable consistent parsing. Severity: Medium. CWE: CWE-117.
- [ ] SC-GO-096: Prevent log injection — Sanitize user-controlled data before writing it to logs to prevent log forging attacks. Severity: Medium. CWE: CWE-117.
- [ ] SC-GO-097: Implement centralized error handling — Use a consistent error handling strategy across the application to prevent inconsistent security behavior. Severity: Medium. CWE: CWE-755.
- [ ] SC-GO-098: Log security-relevant events — Log authentication attempts, authorization failures, input validation failures, and configuration changes. Severity: Medium. CWE: CWE-778.
- [ ] SC-GO-099: Use error wrapping properly — Use fmt.Errorf with %w for error chains but ensure wrapped internal errors are not exposed to clients. Severity: Medium. CWE: CWE-209.
- [ ] SC-GO-100: Implement error rate limiting — Detect and throttle excessive error rates that may indicate attacks or abuse. Severity: Medium. CWE: CWE-770.
- [ ] SC-GO-101: Differentiate client and server errors — Return 4xx for client errors and 5xx for server errors; do not leak implementation details in either. Severity: Low. CWE: CWE-209.
- [ ] SC-GO-102: Handle deferred function errors — Check and log errors from deferred Close(), Flush(), and similar calls. Severity: Medium. CWE: CWE-391.
- [ ] SC-GO-103: Avoid error messages that reveal system info — Do not include file paths, database names, internal IPs, or software versions in error messages returned to clients. Severity: Medium. CWE: CWE-200.
- [ ] SC-GO-104: Use sentinel errors for security decisions — Define and compare sentinel errors (errors.Is) for security decisions rather than string matching on error messages. Severity: Medium. CWE: CWE-697.
- [ ] SC-GO-105: Implement graceful degradation — Fail securely when dependencies are unavailable; do not bypass security checks on error. Severity: High. CWE: CWE-636.
- [ ] SC-GO-106: Log sufficient context for forensics — Include request ID, user ID, timestamp, source IP, and action in security log entries. Severity: Medium. CWE: CWE-778.
- [ ] SC-GO-107: Protect log files — Set restrictive permissions on log files and directories; rotate and archive logs securely. Severity: Medium. CWE: CWE-276.
- [ ] SC-GO-108: Handle EOF and unexpected disconnects — Properly handle io.EOF and io.ErrUnexpectedEOF in network and file operations without leaking state. Severity: Medium. CWE: CWE-755.
- [ ] SC-GO-109: Implement panic recovery middleware — Install panic recovery middleware in HTTP servers to prevent a single request panic from crashing the server. Severity: High. CWE: CWE-248.
- [ ] SC-GO-110: Do not swallow errors silently — Never use _ to discard errors from security-relevant operations like crypto, auth, or I/O. Severity: High. CWE: CWE-390.

### 6. Data Protection & Privacy (20 items)

- [ ] SC-GO-111: Encrypt sensitive data at rest — Encrypt PII, credentials, and sensitive business data before storing in databases or files. Severity: High. CWE: CWE-312.
- [ ] SC-GO-112: Encrypt data in transit — Use TLS for all network communications; never transmit sensitive data over plaintext HTTP. Severity: High. CWE: CWE-319.
- [ ] SC-GO-113: Implement data masking for logs — Mask or redact sensitive fields (SSN, credit card, etc.) when they must appear in logs or debug output. Severity: High. CWE: CWE-532.
- [ ] SC-GO-114: Minimize data collection — Collect and store only the minimum data necessary for the application's function. Severity: Medium. CWE: CWE-359.
- [ ] SC-GO-115: Implement data retention policies — Automatically purge or anonymize data that exceeds its retention period. Severity: Medium. CWE: CWE-359.
- [ ] SC-GO-116: Protect data in memory — Minimize the time sensitive data remains in memory; avoid copying secrets to multiple variables. Severity: Medium. CWE: CWE-316.
- [ ] SC-GO-117: Use secure deletion — Overwrite sensitive data before freeing memory or deleting files rather than simple deletion. Severity: Medium. CWE: CWE-226.
- [ ] SC-GO-118: Implement field-level encryption — Encrypt individual sensitive fields in database records rather than relying solely on disk encryption. Severity: Medium. CWE: CWE-312.
- [ ] SC-GO-119: Prevent data leakage in error responses — Ensure error responses do not contain database records, internal identifiers, or PII. Severity: High. CWE: CWE-200.
- [ ] SC-GO-120: Sanitize data for export — Validate and sanitize data before exporting to CSV, JSON, or other formats to prevent formula injection. Severity: Medium. CWE: CWE-1236.
- [ ] SC-GO-121: Implement data classification — Tag data with sensitivity levels and apply appropriate protection measures per classification. Severity: Medium. CWE: CWE-668.
- [ ] SC-GO-122: Protect backups — Encrypt database backups and restrict access to backup storage. Severity: High. CWE: CWE-312.
- [ ] SC-GO-123: Prevent cache-based data leakage — Set appropriate Cache-Control headers for sensitive responses; do not cache PII or tokens. Severity: Medium. CWE: CWE-524.
- [ ] SC-GO-124: Implement right to deletion — Support data subject deletion requests by removing or anonymizing all related data. Severity: Medium. CWE: CWE-359.
- [ ] SC-GO-125: Protect data in URL parameters — Never pass sensitive data (tokens, passwords, PII) in URL query parameters. Severity: High. CWE: CWE-598.
- [ ] SC-GO-126: Implement audit trails for data access — Log all access to sensitive data with user identity and timestamp for compliance auditing. Severity: Medium. CWE: CWE-778.
- [ ] SC-GO-127: Use separate encryption keys per tenant — Isolate tenant data with per-tenant encryption keys in multi-tenant applications. Severity: High. CWE: CWE-668.
- [ ] SC-GO-128: Prevent clipboard data leakage — Avoid copying sensitive data to system clipboard in CLI applications. Severity: Low. CWE: CWE-200.
- [ ] SC-GO-129: Redact sensitive headers — Strip Authorization, Cookie, and other sensitive headers before logging HTTP requests. Severity: High. CWE: CWE-532.
- [ ] SC-GO-130: Validate data integrity — Use checksums or HMACs to detect tampering of stored or transmitted data. Severity: Medium. CWE: CWE-354.

### 7. SQL/NoSQL/ORM Security (20 items)

- [ ] SC-GO-131: Use parameterized queries — Always use prepared statements or parameterized queries with database/sql; never concatenate user input into SQL. Severity: Critical. CWE: CWE-89.
- [ ] SC-GO-132: Use Query for SELECT, Exec for mutations — Use db.Query/db.QueryRow for reads and db.Exec for writes to prevent unintended data modification. Severity: Medium. CWE: CWE-89.
- [ ] SC-GO-133: Validate dynamic table/column names — If table or column names must be dynamic, validate against an allowlist; they cannot be parameterized. Severity: High. CWE: CWE-89.
- [ ] SC-GO-134: Close rows after query — Always call rows.Close() (preferably deferred) after db.Query to prevent connection pool exhaustion. Severity: Medium. CWE: CWE-772.
- [ ] SC-GO-135: Check rows.Err() after iteration — Always check rows.Err() after the scan loop to detect errors that occurred during iteration. Severity: Medium. CWE: CWE-252.
- [ ] SC-GO-136: Use transactions for multi-step operations — Wrap related database operations in transactions to maintain data consistency and prevent race conditions. Severity: Medium. CWE: CWE-367.
- [ ] SC-GO-137: Set connection pool limits — Configure SetMaxOpenConns, SetMaxIdleConns, and SetConnMaxLifetime to prevent connection exhaustion. Severity: Medium. CWE: CWE-770.
- [ ] SC-GO-138: Use database connection timeouts — Set context timeouts on all database operations using context.WithTimeout. Severity: Medium. CWE: CWE-400.
- [ ] SC-GO-139: Prevent NoSQL injection — Sanitize inputs used in MongoDB, Redis, and other NoSQL queries; use typed query builders. Severity: High. CWE: CWE-943.
- [ ] SC-GO-140: Validate GORM raw queries — When using GORM's Raw() or Exec(), use parameterized queries; do not concatenate input. Severity: Critical. CWE: CWE-89.
- [ ] SC-GO-141: Use database-level encryption — Enable TLS for database connections and use encrypted connections by default. Severity: High. CWE: CWE-319.
- [ ] SC-GO-142: Restrict database user privileges — Use database accounts with minimum required privileges; do not connect as root/admin. Severity: High. CWE: CWE-269.
- [ ] SC-GO-143: Prevent SQL injection in ORDER BY — Validate ORDER BY column names against an allowlist; parameterized queries do not protect ORDER BY clauses. Severity: High. CWE: CWE-89.
- [ ] SC-GO-144: Prevent SQL injection in LIKE patterns — Escape wildcard characters (%, _) in user input used in LIKE clauses. Severity: Medium. CWE: CWE-89.
- [ ] SC-GO-145: Use ORM safely — When using GORM, sqlx, or ent, use the ORM's built-in parameterization and avoid raw query methods with concatenation. Severity: High. CWE: CWE-89.
- [ ] SC-GO-146: Implement query result limits — Apply LIMIT clauses to all queries that return lists to prevent memory exhaustion from unbounded result sets. Severity: Medium. CWE: CWE-770.
- [ ] SC-GO-147: Prevent second-order SQL injection — Validate data retrieved from the database before using it in subsequent queries. Severity: High. CWE: CWE-89.
- [ ] SC-GO-148: Use read replicas for read operations — Separate read and write database connections to limit the impact of SQL injection on write operations. Severity: Low. CWE: CWE-269.
- [ ] SC-GO-149: Sanitize Redis commands — Validate and sanitize inputs used in Redis commands to prevent Redis injection. Severity: High. CWE: CWE-943.
- [ ] SC-GO-150: Audit ORM-generated queries — Review and test the SQL generated by ORMs to ensure proper parameterization and no unintended behavior. Severity: Medium. CWE: CWE-89.

### 8. File Operations (20 items)

- [ ] SC-GO-151: Prevent path traversal with filepath.Clean — Use filepath.Clean and validate that resolved paths stay within the intended directory. Severity: Critical. CWE: CWE-22.
- [ ] SC-GO-152: Validate symlink targets — Check that symbolic links do not point outside the allowed directory before following them. Severity: High. CWE: CWE-59.
- [ ] SC-GO-153: Set restrictive file permissions — Create files with os.OpenFile using restrictive permissions (0600 for sensitive, 0644 for general). Severity: Medium. CWE: CWE-276.
- [ ] SC-GO-154: Use os.CreateTemp safely — Use os.CreateTemp with an appropriate directory and clean up temporary files after use. Severity: Medium. CWE: CWE-377.
- [ ] SC-GO-155: Limit file upload sizes — Enforce maximum file size limits at the application level before writing uploads to disk. Severity: Medium. CWE: CWE-770.
- [ ] SC-GO-156: Validate file type by content — Verify file types using magic bytes (http.DetectContentType) rather than relying on file extensions. Severity: Medium. CWE: CWE-434.
- [ ] SC-GO-157: Prevent directory listing — Do not serve directory listings; configure http.FileServer with a custom filesystem that blocks index pages. Severity: Medium. CWE: CWE-548.
- [ ] SC-GO-158: Use filepath.Join safely — Understand that filepath.Join resolves .. components but does not prevent escaping a base path; validate the result. Severity: High. CWE: CWE-22.
- [ ] SC-GO-159: Close file handles promptly — Always close files with defer f.Close() immediately after opening; check and handle the Close error. Severity: Medium. CWE: CWE-772.
- [ ] SC-GO-160: Prevent TOCTOU race conditions on files — Avoid checking file attributes and then acting on them separately; use atomic file operations where possible. Severity: Medium. CWE: CWE-367.
- [ ] SC-GO-161: Restrict file upload directories — Store uploaded files outside the web root and serve them through a handler that applies access controls. Severity: High. CWE: CWE-434.
- [ ] SC-GO-162: Sanitize filenames — Remove or replace special characters, path separators, and Unicode tricks in user-supplied filenames. Severity: High. CWE: CWE-22.
- [ ] SC-GO-163: Use os.MkdirAll with restrictive permissions — Create directories with restrictive permissions (0750 or less) and verify the umask is appropriate. Severity: Medium. CWE: CWE-276.
- [ ] SC-GO-164: Prevent zip slip attacks — When extracting archives, validate that extracted file paths do not escape the destination directory. Severity: Critical. CWE: CWE-22.
- [ ] SC-GO-165: Limit archive extraction size — Enforce maximum total extraction size and file count when unpacking archives to prevent zip bombs. Severity: High. CWE: CWE-409.
- [ ] SC-GO-166: Use io.LimitReader for file reads — Wrap file readers with io.LimitReader when reading untrusted files to prevent memory exhaustion. Severity: Medium. CWE: CWE-770.
- [ ] SC-GO-167: Check file existence before creation — Use os.O_CREATE|os.O_EXCL flags to prevent overwriting existing files atomically. Severity: Medium. CWE: CWE-367.
- [ ] SC-GO-168: Prevent writing to /dev or special files — Validate that file paths do not resolve to device files or special system paths. Severity: High. CWE: CWE-22.
- [ ] SC-GO-169: Implement file integrity checks — Use checksums or signatures to verify file integrity before processing critical files. Severity: Medium. CWE: CWE-354.
- [ ] SC-GO-170: Set appropriate umask — Set the process umask to restrict default file permissions created by the application. Severity: Medium. CWE: CWE-276.

### 9. Network & HTTP Security (25 items)

- [ ] SC-GO-171: Set HTTP server timeouts — Configure ReadTimeout, WriteTimeout, IdleTimeout, and ReadHeaderTimeout on http.Server. Severity: High. CWE: CWE-400.
- [ ] SC-GO-172: Disable HTTP/2 if not needed — Explicitly configure HTTP/2 support or disable it if the application does not require it. Severity: Low. CWE: CWE-400.
- [ ] SC-GO-173: Set security headers — Include X-Content-Type-Options, X-Frame-Options, Strict-Transport-Security, and Content-Security-Policy headers. Severity: Medium. CWE: CWE-693.
- [ ] SC-GO-174: Prevent open redirects — Validate redirect URLs against an allowlist; do not redirect to user-supplied URLs without validation. Severity: Medium. CWE: CWE-601.
- [ ] SC-GO-175: Prevent SSRF — Validate and restrict outbound HTTP requests; block requests to internal/private IP ranges and metadata endpoints. Severity: Critical. CWE: CWE-918.
- [ ] SC-GO-176: Use timeouts on HTTP clients — Set Timeout on http.Client and use context.WithTimeout for individual requests. Severity: Medium. CWE: CWE-400.
- [ ] SC-GO-177: Limit response body size — Use io.LimitReader when reading HTTP response bodies from untrusted sources. Severity: Medium. CWE: CWE-770.
- [ ] SC-GO-178: Validate Host header — Check the Host header against an allowlist to prevent host header injection attacks. Severity: Medium. CWE: CWE-644.
- [ ] SC-GO-179: Close HTTP response bodies — Always close resp.Body with defer resp.Body.Close() after http.Client requests. Severity: Medium. CWE: CWE-772.
- [ ] SC-GO-180: Implement rate limiting — Apply rate limiting to all endpoints, especially authentication and resource-intensive operations. Severity: High. CWE: CWE-770.
- [ ] SC-GO-181: Use HTTPS-only cookies — Set the Secure flag on all cookies so they are only sent over HTTPS. Severity: High. CWE: CWE-614.
- [ ] SC-GO-182: Prevent HTTP request smuggling — Configure HTTP servers and reverse proxies to normalize and reject ambiguous Content-Length/Transfer-Encoding headers. Severity: High. CWE: CWE-444.
- [ ] SC-GO-183: Validate Content-Type — Verify the Content-Type header matches the expected format before parsing request bodies. Severity: Medium. CWE: CWE-436.
- [ ] SC-GO-184: Implement CORS properly — Configure CORS with specific origins; never use Access-Control-Allow-Origin: * with credentials. Severity: High. CWE: CWE-346.
- [ ] SC-GO-185: Protect WebSocket connections — Validate the Origin header for WebSocket upgrade requests and implement authentication on WS connections. Severity: High. CWE: CWE-346.
- [ ] SC-GO-186: Use net.Listener with TLS — Wrap network listeners with tls.NewListener for all production TCP services. Severity: High. CWE: CWE-319.
- [ ] SC-GO-187: Prevent DNS rebinding — Validate the resolved IP address of DNS names before connecting to prevent DNS rebinding attacks. Severity: Medium. CWE: CWE-350.
- [ ] SC-GO-188: Implement request size limits — Set MaxHeaderBytes on http.Server and use http.MaxBytesReader for body limits. Severity: Medium. CWE: CWE-770.
- [ ] SC-GO-189: Disable unnecessary HTTP methods — Reject HTTP methods (TRACE, OPTIONS with sensitive data) that are not required by the application. Severity: Low. CWE: CWE-749.
- [ ] SC-GO-190: Set proper referrer policy — Include Referrer-Policy header to control how much referrer information is sent with requests. Severity: Low. CWE: CWE-200.
- [ ] SC-GO-191: Validate X-Forwarded-For — Only trust X-Forwarded-For and other proxy headers from known reverse proxies; do not blindly trust client-supplied values. Severity: Medium. CWE: CWE-346.
- [ ] SC-GO-192: Prevent slow-read/slow-post attacks — Set aggressive timeouts and minimum data rate thresholds to counter slow HTTP attacks. Severity: Medium. CWE: CWE-400.
- [ ] SC-GO-193: Use connection limits — Limit the maximum number of concurrent connections to prevent connection exhaustion DoS. Severity: Medium. CWE: CWE-770.
- [ ] SC-GO-194: Implement proper HTTP/2 server push security — Validate server push targets and prevent pushing sensitive resources. Severity: Low. CWE: CWE-346.
- [ ] SC-GO-195: Disable HTTP TRACE method — Disable the TRACE method to prevent cross-site tracing (XST) attacks. Severity: Low. CWE: CWE-693.

### 10. Serialization & Deserialization (15 items)

- [ ] SC-GO-196: Limit JSON unmarshalling depth — Use json.NewDecoder with a LimitReader to prevent deeply nested JSON from causing stack exhaustion. Severity: High. CWE: CWE-674.
- [ ] SC-GO-197: Validate JSON field types — Use typed structs for JSON unmarshalling rather than map[string]interface{} to enforce expected types. Severity: Medium. CWE: CWE-502.
- [ ] SC-GO-198: Handle unknown JSON fields — Use json.Decoder.DisallowUnknownFields() to reject JSON with unexpected fields. Severity: Medium. CWE: CWE-20.
- [ ] SC-GO-199: Prevent XML entity expansion — Disable external entity processing in encoding/xml to prevent XXE attacks. Severity: Critical. CWE: CWE-611.
- [ ] SC-GO-200: Limit XML nesting depth — Restrict the depth of XML documents parsed to prevent billion-laughs and similar attacks. Severity: High. CWE: CWE-776.
- [ ] SC-GO-201: Validate gob decoder input — Only decode gob data from trusted sources; gob can instantiate arbitrary types. Severity: High. CWE: CWE-502.
- [ ] SC-GO-202: Prevent YAML deserialization attacks — Use a safe YAML parser that does not support arbitrary type instantiation. Severity: High. CWE: CWE-502.
- [ ] SC-GO-203: Validate Protocol Buffer messages — Validate proto message sizes and field values after deserialization. Severity: Medium. CWE: CWE-20.
- [ ] SC-GO-204: Prevent msgpack deserialization attacks — Validate and limit msgpack input size before deserialization. Severity: Medium. CWE: CWE-502.
- [ ] SC-GO-205: Use encoding/json instead of unsafe alternatives — Prefer encoding/json over third-party JSON libraries that may sacrifice safety for speed. Severity: Medium. CWE: CWE-502.
- [ ] SC-GO-206: Prevent TOML deserialization abuse — Validate TOML configuration sizes and structure before parsing. Severity: Low. CWE: CWE-502.
- [ ] SC-GO-207: Sanitize output serialization — Ensure sensitive fields are excluded from JSON/XML serialization using struct tags (json:"-"). Severity: High. CWE: CWE-200.
- [ ] SC-GO-208: Validate deserialized data — Apply business validation rules to deserialized data; do not trust the structure alone. Severity: Medium. CWE: CWE-502.
- [ ] SC-GO-209: Prevent CSV injection — Escape leading =, +, -, @, and tab characters in CSV output to prevent formula injection. Severity: Medium. CWE: CWE-1236.
- [ ] SC-GO-210: Use json.Number for numeric precision — Use json.Decoder.UseNumber() or json.Number when numeric precision matters to prevent silent truncation. Severity: Low. CWE: CWE-681.

### 11. Concurrency & Race Conditions (25 items)

- [ ] SC-GO-211: Protect shared state with sync.Mutex — Use sync.Mutex or sync.RWMutex to protect all shared mutable state accessed by multiple goroutines. Severity: High. CWE: CWE-362.
- [ ] SC-GO-212: Run tests with -race flag — Run all tests with `go test -race` to detect data races during development and CI. Severity: High. CWE: CWE-362.
- [ ] SC-GO-213: Use sync/atomic for simple counters — Use atomic operations (atomic.AddInt64, atomic.LoadInt64) for simple shared counters instead of mutex locks. Severity: Medium. CWE: CWE-362.
- [ ] SC-GO-214: Prevent goroutine leaks — Ensure all goroutines have a termination path using context cancellation, done channels, or WaitGroups. Severity: High. CWE: CWE-772.
- [ ] SC-GO-215: Use buffered channels appropriately — Size channel buffers appropriately to prevent goroutine blocking and deadlocks. Severity: Medium. CWE: CWE-833.
- [ ] SC-GO-216: Avoid closing channels from receiver side — Only close channels from the sender side to prevent panics from sending on closed channels. Severity: Medium. CWE: CWE-362.
- [ ] SC-GO-217: Use sync.Once for initialization — Use sync.Once to ensure one-time initialization is safe across concurrent goroutines. Severity: Medium. CWE: CWE-362.
- [ ] SC-GO-218: Prevent map concurrent access — Use sync.Map or protect standard maps with mutexes; concurrent map read/write causes a fatal panic. Severity: Critical. CWE: CWE-362.
- [ ] SC-GO-219: Use context for goroutine cancellation — Pass context.Context to goroutines and respect cancellation to prevent resource leaks. Severity: High. CWE: CWE-772.
- [ ] SC-GO-220: Prevent channel deadlocks — Ensure every channel send has a corresponding receive and use select with default or timeout to prevent deadlocks. Severity: High. CWE: CWE-833.
- [ ] SC-GO-221: Use sync.WaitGroup correctly — Call wg.Add() before launching goroutines, not inside them, to prevent race conditions. Severity: Medium. CWE: CWE-362.
- [ ] SC-GO-222: Protect slice concurrent access — Guard concurrent slice reads and writes with a mutex; Go slices are not goroutine-safe. Severity: High. CWE: CWE-362.
- [ ] SC-GO-223: Avoid goroutine-per-request without limits — Use a worker pool or semaphore to limit the number of concurrent goroutines to prevent resource exhaustion. Severity: High. CWE: CWE-770.
- [ ] SC-GO-224: Use errgroup for concurrent error handling — Use golang.org/x/sync/errgroup to manage groups of goroutines with proper error propagation and cancellation. Severity: Medium. CWE: CWE-755.
- [ ] SC-GO-225: Prevent TOCTOU in concurrent code — Do not check a condition and then act on it without holding a lock, as the condition may change between check and use. Severity: High. CWE: CWE-367.
- [ ] SC-GO-226: Use atomic.Value for configuration updates — Use atomic.Value for safely publishing configuration or state updates read by multiple goroutines. Severity: Medium. CWE: CWE-362.
- [ ] SC-GO-227: Avoid timer leaks — Stop or drain timers and tickers (time.Timer, time.Ticker) when they are no longer needed. Severity: Medium. CWE: CWE-772.
- [ ] SC-GO-228: Prevent race conditions in tests — Use t.Parallel() carefully and ensure test fixtures are not shared mutably between parallel test cases. Severity: Medium. CWE: CWE-362.
- [ ] SC-GO-229: Avoid copying sync primitives — Never copy sync.Mutex, sync.WaitGroup, or sync.Cond; pass them by pointer to prevent undefined behavior. Severity: High. CWE: CWE-362.
- [ ] SC-GO-230: Use select for channel multiplexing — Use select statements with timeouts when reading from multiple channels to prevent blocking indefinitely. Severity: Medium. CWE: CWE-833.
- [ ] SC-GO-231: Protect global variables — Avoid mutable global variables; if necessary, protect them with sync.RWMutex or use atomic operations. Severity: High. CWE: CWE-362.
- [ ] SC-GO-232: Implement graceful shutdown — Use os.Signal, context cancellation, and sync.WaitGroup to shut down goroutines gracefully without data loss. Severity: Medium. CWE: CWE-404.
- [ ] SC-GO-233: Prevent race conditions in singleton pattern — Use sync.Once to implement singletons safely rather than double-checked locking. Severity: Medium. CWE: CWE-362.
- [ ] SC-GO-234: Avoid shared state in HTTP handlers — Use handler-scoped variables or request-scoped context rather than shared mutable state across HTTP handlers. Severity: High. CWE: CWE-362.
- [ ] SC-GO-235: Use semaphore for resource limiting — Use golang.org/x/sync/semaphore to limit concurrent access to bounded resources. Severity: Medium. CWE: CWE-770.

### 12. Dependency & Supply Chain (20 items)

- [ ] SC-GO-236: Audit go.sum for integrity — Verify go.sum hashes are checked on every build; do not use GONOSUMCHECK or GONOSUMDB for production dependencies. Severity: High. CWE: CWE-494.
- [ ] SC-GO-237: Use govulncheck regularly — Run govulncheck to scan dependencies for known vulnerabilities. Severity: High. CWE: CWE-1035.
- [ ] SC-GO-238: Pin dependency versions — Use exact versions in go.mod rather than version ranges to ensure reproducible builds. Severity: Medium. CWE: CWE-829.
- [ ] SC-GO-239: Verify module checksums — Ensure GONOSUMCHECK is not set and go.sum is committed to version control. Severity: High. CWE: CWE-494.
- [ ] SC-GO-240: Use GOPROXY wisely — Configure GOPROXY to use trusted proxies (e.g., proxy.golang.org) and avoid direct fetches from untrusted sources. Severity: Medium. CWE: CWE-494.
- [ ] SC-GO-241: Audit transitive dependencies — Review the full dependency tree (go mod graph) for unexpected or suspicious transitive dependencies. Severity: Medium. CWE: CWE-1035.
- [ ] SC-GO-242: Avoid abandoned dependencies — Check dependency maintenance status; replace abandoned packages that no longer receive security updates. Severity: Medium. CWE: CWE-1104.
- [ ] SC-GO-243: Use go mod vendor for reproducibility — Vendor dependencies for air-gapped or high-security environments to prevent supply chain attacks. Severity: Medium. CWE: CWE-494.
- [ ] SC-GO-244: Review dependency licenses — Audit dependency licenses for compatibility and security implications. Severity: Low. CWE: CWE-829.
- [ ] SC-GO-245: Limit dependency count — Minimize the number of external dependencies to reduce attack surface. Severity: Medium. CWE: CWE-1104.
- [ ] SC-GO-246: Monitor for dependency vulnerabilities — Set up automated alerts for newly disclosed vulnerabilities in project dependencies. Severity: High. CWE: CWE-1035.
- [ ] SC-GO-247: Verify module authenticity — Validate that imported module paths match expected source repositories; watch for typosquatting. Severity: High. CWE: CWE-494.
- [ ] SC-GO-248: Use GONOSUMDB cautiously — Only exclude private modules from the checksum database; never disable it globally. Severity: Medium. CWE: CWE-494.
- [ ] SC-GO-249: Avoid replace directives in production — Remove local replace directives from go.mod before deploying to production. Severity: Medium. CWE: CWE-829.
- [ ] SC-GO-250: Audit build tags — Review build tags and conditional compilation for paths that could bypass security checks. Severity: Medium. CWE: CWE-829.
- [ ] SC-GO-251: Use signed commits for dependencies — Prefer dependencies from repositories that use signed commits and tags. Severity: Low. CWE: CWE-494.
- [ ] SC-GO-252: Implement SBOM generation — Generate a Software Bill of Materials for tracking and auditing all dependencies in production. Severity: Medium. CWE: CWE-1035.
- [ ] SC-GO-253: Avoid importing test-only dependencies — Ensure test-only dependencies do not leak into production binaries. Severity: Low. CWE: CWE-829.
- [ ] SC-GO-254: Review CGo dependencies — Audit C libraries linked through CGo for vulnerabilities and ensure they are from trusted sources. Severity: High. CWE: CWE-829.
- [ ] SC-GO-255: Use private module proxies — Configure GOPRIVATE and use an authenticated private proxy for internal modules. Severity: Medium. CWE: CWE-494.

### 13. Configuration & Secrets Management (20 items)

- [ ] SC-GO-256: Never hardcode secrets — Do not embed passwords, API keys, tokens, or private keys in source code. Severity: Critical. CWE: CWE-798.
- [ ] SC-GO-257: Use environment variables for secrets — Load secrets from environment variables or dedicated secret management systems. Severity: High. CWE: CWE-798.
- [ ] SC-GO-258: Validate configuration at startup — Validate all configuration values at application startup and fail fast on invalid or missing values. Severity: Medium. CWE: CWE-1188.
- [ ] SC-GO-259: Use secret management systems — Integrate with HashiCorp Vault, AWS Secrets Manager, or similar systems for production secrets. Severity: High. CWE: CWE-522.
- [ ] SC-GO-260: Restrict .env file permissions — Set .env files to 0600 permissions and ensure they are listed in .gitignore. Severity: Medium. CWE: CWE-276.
- [ ] SC-GO-261: Rotate secrets regularly — Implement automated secret rotation for database passwords, API keys, and certificates. Severity: Medium. CWE: CWE-798.
- [ ] SC-GO-262: Disable debug mode in production — Ensure debug flags, verbose logging, and development-only features are disabled in production builds. Severity: High. CWE: CWE-489.
- [ ] SC-GO-263: Separate configuration by environment — Use distinct configuration files and secrets for development, staging, and production. Severity: Medium. CWE: CWE-1188.
- [ ] SC-GO-264: Prevent config injection — Validate configuration values loaded from external sources to prevent injection attacks. Severity: High. CWE: CWE-94.
- [ ] SC-GO-265: Encrypt sensitive configuration — Encrypt sensitive configuration values at rest in configuration files and databases. Severity: Medium. CWE: CWE-312.
- [ ] SC-GO-266: Use build tags for environment separation — Use Go build tags to include/exclude environment-specific code at compile time. Severity: Low. CWE: CWE-489.
- [ ] SC-GO-267: Prevent secrets in version control — Use pre-commit hooks (e.g., git-secrets, gitleaks) to detect secrets before committing. Severity: High. CWE: CWE-798.
- [ ] SC-GO-268: Avoid logging configuration values — Do not log configuration values that may contain secrets at any log level. Severity: High. CWE: CWE-532.
- [ ] SC-GO-269: Use HTTPS for configuration endpoints — Fetch remote configuration only over HTTPS with certificate validation. Severity: High. CWE: CWE-319.
- [ ] SC-GO-270: Implement configuration audit trails — Log all configuration changes with the identity of the changer and timestamp. Severity: Medium. CWE: CWE-778.
- [ ] SC-GO-271: Set secure default configuration — Ensure default configuration values are secure and require explicit opt-in for less secure options. Severity: Medium. CWE: CWE-1188.
- [ ] SC-GO-272: Restrict admin configuration endpoints — Protect configuration management APIs with strong authentication and authorization. Severity: High. CWE: CWE-269.
- [ ] SC-GO-273: Use feature flags securely — Ensure feature flags cannot be manipulated by clients and are evaluated server-side. Severity: Medium. CWE: CWE-284.
- [ ] SC-GO-274: Prevent environment variable injection — Validate that environment variables are not set from untrusted sources (e.g., CGI, request headers). Severity: High. CWE: CWE-74.
- [ ] SC-GO-275: Remove default credentials — Ensure no default usernames, passwords, or API keys exist in the deployed application. Severity: Critical. CWE: CWE-1392.

### 14. Memory Safety (20 items)

- [ ] SC-GO-276: Avoid unsafe package — Do not use unsafe.Pointer unless absolutely necessary; it bypasses Go's type safety and memory protection. Severity: Critical. CWE: CWE-787.
- [ ] SC-GO-277: Prevent slice out-of-bounds access — Always check slice length before indexing; use range loops where possible. Severity: High. CWE: CWE-125.
- [ ] SC-GO-278: Prevent nil pointer dereference — Check interface values and pointers for nil before dereferencing, especially from external sources. Severity: High. CWE: CWE-476.
- [ ] SC-GO-279: Avoid CGo memory issues — Properly manage C memory in CGo calls; free C-allocated memory and do not pass Go pointers to C that will persist. Severity: High. CWE: CWE-787.
- [ ] SC-GO-280: Prevent integer overflow — Check for overflow before arithmetic operations on int, int32, and similar types that may wrap. Severity: High. CWE: CWE-190.
- [ ] SC-GO-281: Limit allocation size from user input — Validate size parameters before allocating slices or maps based on user-supplied values (e.g., make([]byte, userSize)). Severity: High. CWE: CWE-770.
- [ ] SC-GO-282: Prevent memory leaks from unclosed resources — Close all io.Closer implementations (files, connections, response bodies) to prevent memory leaks. Severity: Medium. CWE: CWE-772.
- [ ] SC-GO-283: Avoid holding large buffers — Release references to large byte slices and strings when no longer needed to allow garbage collection. Severity: Medium. CWE: CWE-401.
- [ ] SC-GO-284: Use copy for slice duplication — Use copy() to create independent slice copies; simple re-slicing shares underlying arrays. Severity: Medium. CWE: CWE-362.
- [ ] SC-GO-285: Validate reflect operations — Check types before using reflect.Value methods like Elem(), Field(), and Index() to prevent panics. Severity: Medium. CWE: CWE-476.
- [ ] SC-GO-286: Limit recursion depth — Set explicit recursion depth limits to prevent stack overflow from deeply nested input data. Severity: High. CWE: CWE-674.
- [ ] SC-GO-287: Avoid string to byte slice aliasing — Understand that converting between string and []byte creates a copy; never use unsafe to alias them. Severity: Medium. CWE: CWE-787.
- [ ] SC-GO-288: Prevent map capacity exhaustion — Limit the number of entries in maps populated from user input to prevent memory exhaustion. Severity: Medium. CWE: CWE-770.
- [ ] SC-GO-289: Validate CGo pointer rules — Follow the CGo pointer passing rules; do not pass Go pointers containing Go pointers to C code. Severity: High. CWE: CWE-787.
- [ ] SC-GO-290: Use pprof for memory profiling — Regularly profile production memory usage to detect leaks and unexpected allocation patterns. Severity: Low. CWE: CWE-401.
- [ ] SC-GO-291: Prevent finalizer-based resource leaks — Do not rely on runtime.SetFinalizer for critical resource cleanup; use explicit Close methods. Severity: Medium. CWE: CWE-772.
- [ ] SC-GO-292: Avoid interface{}/any for security data — Use strongly typed values for security-critical data (tokens, permissions) to prevent type confusion. Severity: Medium. CWE: CWE-843.
- [ ] SC-GO-293: Limit goroutine stack growth — Be aware that goroutine stacks grow dynamically; deeply recursive goroutines can exhaust memory. Severity: Medium. CWE: CWE-770.
- [ ] SC-GO-294: Use sync.Pool carefully — Ensure objects returned from sync.Pool are properly reset before use to prevent data leakage between operations. Severity: Medium. CWE: CWE-212.
- [ ] SC-GO-295: Prevent slice header corruption — Never use unsafe to modify slice headers; this can cause out-of-bounds access and memory corruption. Severity: Critical. CWE: CWE-787.

### 15. Go-Specific Patterns (25 items)

- [ ] SC-GO-296: Use html/template not text/template for HTML — Use html/template package which auto-escapes output; text/template does not escape and leads to XSS. Severity: Critical. CWE: CWE-79.
- [ ] SC-GO-297: Use crypto/rand not math/rand for security — Never use math/rand for tokens, keys, or nonces; it is deterministic and predictable. Severity: Critical. CWE: CWE-338.
- [ ] SC-GO-298: Prevent os/exec command injection — Use exec.Command with separate arguments; never pass user input through shell expansion with sh -c. Severity: Critical. CWE: CWE-78.
- [ ] SC-GO-299: Handle defer execution order — Understand that defers execute LIFO; ensure cleanup logic does not depend on forward-order execution. Severity: Medium. CWE: CWE-670.
- [ ] SC-GO-300: Avoid defer in loops — Do not defer resource cleanup inside loops; defers execute at function return, causing resource accumulation. Severity: High. CWE: CWE-772.
- [ ] SC-GO-301: Use context.Context for cancellation — Pass context.Context as the first parameter and use it for timeouts and cancellation propagation. Severity: Medium. CWE: CWE-400.
- [ ] SC-GO-302: Avoid context.WithValue for security data — Do not store security-critical data (auth tokens, permissions) in context.Value where type safety is weak. Severity: Medium. CWE: CWE-843.
- [ ] SC-GO-303: Use errors.Is and errors.As — Use errors.Is/errors.As for error comparison instead of == or type assertions to handle wrapped errors correctly. Severity: Medium. CWE: CWE-697.
- [ ] SC-GO-304: Avoid init() for security-critical setup — Avoid using init() functions for security setup as their execution order is hard to control and test. Severity: Medium. CWE: CWE-696.
- [ ] SC-GO-305: Prevent goroutine leaks from HTTP clients — Set timeouts on HTTP clients and cancel contexts to prevent goroutines from blocking forever on stalled connections. Severity: High. CWE: CWE-772.
- [ ] SC-GO-306: Use embed.FS safely — Validate that embedded file paths using go:embed do not include sensitive files. Severity: Medium. CWE: CWE-200.
- [ ] SC-GO-307: Validate type assertions — Always use the two-value form of type assertions (val, ok := x.(Type)) to prevent panics. Severity: Medium. CWE: CWE-476.
- [ ] SC-GO-308: Avoid reflect.MakeFunc for untrusted input — Do not use reflect to create or invoke functions based on untrusted input. Severity: High. CWE: CWE-470.
- [ ] SC-GO-309: Use go vet in CI — Run go vet as part of CI to catch common mistakes including printf format errors and unreachable code. Severity: Medium. CWE: CWE-670.
- [ ] SC-GO-310: Handle channel direction — Use directional channels (chan<-, <-chan) in function signatures to prevent unintended reads or writes. Severity: Low. CWE: CWE-362.
- [ ] SC-GO-311: Use generics for type-safe collections — Prefer generics over interface{}/any for security-critical data structures to get compile-time type checking. Severity: Low. CWE: CWE-843.
- [ ] SC-GO-312: Avoid global http.DefaultClient — Create custom http.Client instances with appropriate timeouts rather than using http.DefaultClient. Severity: Medium. CWE: CWE-400.
- [ ] SC-GO-313: Prevent panic from nil function calls — Check function variables for nil before calling them, especially callbacks and interface method values. Severity: Medium. CWE: CWE-476.
- [ ] SC-GO-314: Use strings.EqualFold for case-insensitive comparison — Use strings.EqualFold instead of strings.ToLower comparison to prevent locale-related bypass issues. Severity: Low. CWE: CWE-178.
- [ ] SC-GO-315: Avoid leaking goroutines in tests — Ensure test goroutines are properly cleaned up; use libraries like goleak to detect leaks. Severity: Low. CWE: CWE-772.
- [ ] SC-GO-316: Use time.After carefully — Be aware that time.After creates a timer that is not garbage collected until it fires; use time.NewTimer in loops. Severity: Medium. CWE: CWE-772.
- [ ] SC-GO-317: Validate regexp.Compile input — Use regexp.MustCompile only for compile-time constants; use regexp.Compile with error checking for runtime patterns. Severity: Medium. CWE: CWE-400.
- [ ] SC-GO-318: Use net.JoinHostPort for addresses — Use net.JoinHostPort to construct host:port strings to handle IPv6 addresses correctly. Severity: Low. CWE: CWE-20.
- [ ] SC-GO-319: Avoid recovering from all panics — Use targeted recover() that checks the panic value; do not silently swallow all panics as this may mask security issues. Severity: Medium. CWE: CWE-755.
- [ ] SC-GO-320: Use build constraints for platform security — Apply platform-specific security measures using build constraints (//go:build) for OS-specific code. Severity: Low. CWE: CWE-670.

### 16. Framework-Specific Checks (net/http, Gin, Echo, Fiber) (25 items)

- [ ] SC-GO-321: Configure net/http timeouts — Always set ReadTimeout, WriteTimeout, IdleTimeout on http.Server; the defaults are no timeout. Severity: Critical. CWE: CWE-400.
- [ ] SC-GO-322: Use http.Error for error responses — Use http.Error or similar to set proper status codes; do not just write error text without status. Severity: Low. CWE: CWE-209.
- [ ] SC-GO-323: Prevent path traversal in http.FileServer — Wrap http.Dir with a custom file system or use http.FS to prevent directory traversal. Severity: High. CWE: CWE-22.
- [ ] SC-GO-324: Use http.StripPrefix safely — Validate that StripPrefix does not expose unintended paths when combined with FileServer. Severity: Medium. CWE: CWE-22.
- [ ] SC-GO-325: Set Gin mode to release — Set gin.SetMode(gin.ReleaseMode) in production to prevent debug information exposure. Severity: Medium. CWE: CWE-489.
- [ ] SC-GO-326: Use Gin trusted proxies — Configure Gin's SetTrustedProxies() to prevent IP spoofing through header injection. Severity: High. CWE: CWE-346.
- [ ] SC-GO-327: Validate Gin binding — Use ShouldBind* methods (not Bind*) to handle binding errors explicitly and return proper error responses. Severity: Medium. CWE: CWE-20.
- [ ] SC-GO-328: Enable Gin CSRF middleware — Apply CSRF protection middleware for HTML form-based Gin applications. Severity: High. CWE: CWE-352.
- [ ] SC-GO-329: Use Echo middleware ordering — Apply security middleware (recovery, CORS, CSRF) before business logic middleware in Echo. Severity: Medium. CWE: CWE-696.
- [ ] SC-GO-330: Configure Echo body limit — Use Echo's BodyLimit middleware to restrict maximum request body size. Severity: Medium. CWE: CWE-770.
- [ ] SC-GO-331: Use Echo secure middleware — Enable Echo's Secure middleware for automatic security headers. Severity: Medium. CWE: CWE-693.
- [ ] SC-GO-332: Validate Echo path parameters — Validate path parameters in Echo handlers before use; they are raw strings without validation. Severity: High. CWE: CWE-20.
- [ ] SC-GO-333: Configure Fiber request limits — Set Fiber's BodyLimit, ReadBufferSize, and WriteBufferSize to prevent resource exhaustion. Severity: Medium. CWE: CWE-770.
- [ ] SC-GO-334: Use Fiber CSRF middleware — Apply Fiber's CSRF middleware for state-changing operations. Severity: High. CWE: CWE-352.
- [ ] SC-GO-335: Handle Fiber immutable strings — Be aware that Fiber reuses request buffers; use c.Params(), c.Query() with copy if storing values beyond the handler. Severity: High. CWE: CWE-362.
- [ ] SC-GO-336: Use Fiber helmet middleware — Enable Fiber's Helmet middleware for security headers. Severity: Medium. CWE: CWE-693.
- [ ] SC-GO-337: Validate multipart form parsing — Set limits on multipart form parsing (MaxMultipartMemory in Gin, BodyLimit in Fiber). Severity: Medium. CWE: CWE-770.
- [ ] SC-GO-338: Use framework-provided validators — Leverage built-in validation (go-playground/validator in Gin) rather than manual validation. Severity: Medium. CWE: CWE-20.
- [ ] SC-GO-339: Prevent Gin template injection — Use Gin's HTML rendering with html/template; do not use text/template in Gin handlers. Severity: High. CWE: CWE-79.
- [ ] SC-GO-340: Use framework error handlers — Implement custom error handlers that do not leak stack traces or internal details to clients. Severity: Medium. CWE: CWE-209.
- [ ] SC-GO-341: Configure framework logging safely — Ensure framework access logs do not contain sensitive request data (auth headers, body contents). Severity: Medium. CWE: CWE-532.
- [ ] SC-GO-342: Use net/http ServeMux routing carefully — Understand that Go's default ServeMux does path cleaning which may cause routing surprises; consider third-party routers. Severity: Medium. CWE: CWE-22.
- [ ] SC-GO-343: Prevent regex DoS in routing — Avoid user-influenced regex patterns in route matching; use literal path matching where possible. Severity: Medium. CWE: CWE-1333.
- [ ] SC-GO-344: Handle HEAD requests properly — Ensure HEAD request handlers do not perform destructive side effects and match GET behavior. Severity: Low. CWE: CWE-749.
- [ ] SC-GO-345: Secure static file serving — Restrict static file serving to specific directories and file types; prevent serving of .go, .env, and config files. Severity: High. CWE: CWE-538.

### 17. API Security (20 items)

- [ ] SC-GO-346: Implement API authentication — Require authentication on all API endpoints except explicitly public ones. Severity: Critical. CWE: CWE-306.
- [ ] SC-GO-347: Validate API request content type — Enforce expected Content-Type headers and reject requests with unexpected types. Severity: Medium. CWE: CWE-436.
- [ ] SC-GO-348: Implement API rate limiting — Apply per-client and per-endpoint rate limits using token bucket or leaky bucket algorithms. Severity: High. CWE: CWE-770.
- [ ] SC-GO-349: Use API versioning — Implement API versioning to allow deprecation of insecure endpoints without breaking clients. Severity: Low. CWE: CWE-1059.
- [ ] SC-GO-350: Validate GraphQL query depth — Limit GraphQL query depth and complexity to prevent resource exhaustion attacks. Severity: High. CWE: CWE-400.
- [ ] SC-GO-351: Prevent GraphQL introspection in production — Disable GraphQL introspection queries in production environments. Severity: Medium. CWE: CWE-200.
- [ ] SC-GO-352: Implement gRPC authentication — Use gRPC interceptors to enforce authentication on all RPC methods. Severity: Critical. CWE: CWE-306.
- [ ] SC-GO-353: Use gRPC TLS — Configure gRPC servers and clients to use TLS; do not use grpc.WithInsecure() in production. Severity: High. CWE: CWE-319.
- [ ] SC-GO-354: Set gRPC message size limits — Configure MaxRecvMsgSize and MaxSendMsgSize on gRPC servers to prevent large message attacks. Severity: Medium. CWE: CWE-770.
- [ ] SC-GO-355: Validate gRPC metadata — Validate metadata (headers) in gRPC interceptors; do not trust client-supplied metadata blindly. Severity: Medium. CWE: CWE-20.
- [ ] SC-GO-356: Implement API pagination — Enforce pagination limits on list endpoints to prevent resource exhaustion from large result sets. Severity: Medium. CWE: CWE-770.
- [ ] SC-GO-357: Use idempotency keys — Implement idempotency keys for mutating API operations to prevent duplicate processing. Severity: Medium. CWE: CWE-837.
- [ ] SC-GO-358: Validate webhook signatures — Verify HMAC or digital signatures on incoming webhook payloads before processing. Severity: High. CWE: CWE-347.
- [ ] SC-GO-359: Implement API key rotation — Support API key rotation without downtime by accepting both old and new keys during a transition period. Severity: Medium. CWE: CWE-798.
- [ ] SC-GO-360: Prevent mass data exposure — Implement field-level filtering on API responses; do not return entire database records by default. Severity: High. CWE: CWE-200.
- [ ] SC-GO-361: Secure REST API with proper HTTP methods — Use correct HTTP methods (GET for reads, POST for creates, etc.) and reject method misuse. Severity: Medium. CWE: CWE-749.
- [ ] SC-GO-362: Implement request signing — Use HMAC-based request signing for service-to-service API calls. Severity: Medium. CWE: CWE-345.
- [ ] SC-GO-363: Validate API response content type — Set correct Content-Type headers on API responses to prevent MIME sniffing. Severity: Low. CWE: CWE-436.
- [ ] SC-GO-364: Implement gRPC deadline propagation — Propagate deadlines through gRPC context to prevent cascading timeouts and resource exhaustion. Severity: Medium. CWE: CWE-400.
- [ ] SC-GO-365: Protect batch endpoints — Limit the number of items in batch API requests to prevent resource exhaustion. Severity: Medium. CWE: CWE-770.

### 18. Testing & CI/CD Security (15 items)

- [ ] SC-GO-366: Run go test -race in CI — Enable the race detector in CI pipelines to catch concurrency bugs before deployment. Severity: High. CWE: CWE-362.
- [ ] SC-GO-367: Implement security-focused unit tests — Write tests for authentication bypass, authorization escalation, and input validation edge cases. Severity: Medium. CWE: CWE-1053.
- [ ] SC-GO-368: Use fuzz testing — Implement Go native fuzz tests (testing.F) for parsers, validators, and security-critical functions. Severity: Medium. CWE: CWE-20.
- [ ] SC-GO-369: Run staticcheck in CI — Include staticcheck or golangci-lint in CI to catch security-relevant code issues. Severity: Medium. CWE: CWE-670.
- [ ] SC-GO-370: Scan for secrets in CI — Use gitleaks, trufflehog, or similar tools in CI to prevent secret commits. Severity: High. CWE: CWE-798.
- [ ] SC-GO-371: Use gosec for security analysis — Run gosec (Go Security Checker) as part of CI to find security issues. Severity: High. CWE: CWE-1035.
- [ ] SC-GO-372: Do not use test credentials in production — Ensure test credentials, test keys, and mock data are not included in production builds. Severity: Critical. CWE: CWE-798.
- [ ] SC-GO-373: Secure CI/CD pipeline secrets — Store CI/CD secrets in the platform's secret management; do not hardcode them in pipeline files. Severity: High. CWE: CWE-798.
- [ ] SC-GO-374: Verify binary integrity — Sign and verify Go binaries after building; use SLSA provenance for supply chain integrity. Severity: Medium. CWE: CWE-494.
- [ ] SC-GO-375: Test error handling paths — Write tests that exercise error handling and failure modes, not just happy paths. Severity: Medium. CWE: CWE-755.
- [ ] SC-GO-376: Use minimal Docker images — Build Go binaries as static executables and deploy in scratch or distroless Docker images. Severity: Medium. CWE: CWE-1104.
- [ ] SC-GO-377: Scan Docker images for vulnerabilities — Use trivy, grype, or similar tools to scan container images in CI. Severity: High. CWE: CWE-1035.
- [ ] SC-GO-378: Implement integration security tests — Test authentication, authorization, TLS, and input validation in integration tests with real dependencies. Severity: Medium. CWE: CWE-1053.
- [ ] SC-GO-379: Enforce code review for security changes — Require peer review for changes to authentication, authorization, cryptography, and configuration. Severity: Medium. CWE: CWE-1053.
- [ ] SC-GO-380: Test with CGO_ENABLED=0 — Build and test with CGO_ENABLED=0 where possible to eliminate CGo-related vulnerabilities. Severity: Low. CWE: CWE-829.

### 19. Logging & Monitoring Security (15 items)

- [ ] SC-GO-381: Implement security event monitoring — Monitor and alert on authentication failures, authorization violations, and input validation failures. Severity: High. CWE: CWE-778.
- [ ] SC-GO-382: Use structured log format — Use JSON or structured logging to enable automated parsing and security analysis. Severity: Medium. CWE: CWE-117.
- [ ] SC-GO-383: Implement distributed tracing — Use OpenTelemetry or similar tracing to track requests across services for security analysis. Severity: Medium. CWE: CWE-778.
- [ ] SC-GO-384: Set up anomaly detection — Monitor for unusual patterns (spike in errors, unusual access patterns, off-hours activity). Severity: Medium. CWE: CWE-778.
- [ ] SC-GO-385: Protect log aggregation — Secure connections to log aggregation services using TLS and authentication. Severity: Medium. CWE: CWE-319.
- [ ] SC-GO-386: Implement health check security — Protect /health and /metrics endpoints from unauthorized access in production. Severity: Medium. CWE: CWE-200.
- [ ] SC-GO-387: Monitor resource usage — Alert on unusual CPU, memory, goroutine count, or connection patterns that may indicate attacks. Severity: Medium. CWE: CWE-400.
- [ ] SC-GO-388: Implement audit logging — Create immutable audit logs for all security-relevant operations with who, what, when, and where. Severity: High. CWE: CWE-778.
- [ ] SC-GO-389: Use request IDs for correlation — Generate and propagate unique request IDs for correlating log entries across services. Severity: Low. CWE: CWE-778.
- [ ] SC-GO-390: Monitor goroutine counts — Alert on goroutine count growth which may indicate leaks or DoS attacks. Severity: Medium. CWE: CWE-772.
- [ ] SC-GO-391: Implement log retention — Configure log retention policies that satisfy compliance requirements while allowing forensic investigation. Severity: Medium. CWE: CWE-778.
- [ ] SC-GO-392: Protect pprof endpoints — Never expose /debug/pprof/ endpoints publicly; restrict them to localhost or admin networks. Severity: Critical. CWE: CWE-215.
- [ ] SC-GO-393: Monitor dependency versions — Set up alerts when deployed applications use dependencies with known vulnerabilities. Severity: Medium. CWE: CWE-1035.
- [ ] SC-GO-394: Log TLS connection details — Log TLS version, cipher suite, and certificate details for debugging and compliance. Severity: Low. CWE: CWE-778.
- [ ] SC-GO-395: Implement alerting escalation — Define escalation policies for security events with appropriate urgency and notification channels. Severity: Medium. CWE: CWE-778.

### 20. Third-Party Integration Security (20 items)

- [ ] SC-GO-396: Validate webhook payloads — Verify signatures or shared secrets on all incoming webhook payloads before processing. Severity: High. CWE: CWE-347.
- [ ] SC-GO-397: Use OAuth2 token exchange safely — Validate all OAuth2 tokens, check scopes, and handle token expiration properly. Severity: High. CWE: CWE-287.
- [ ] SC-GO-398: Set timeouts on third-party API calls — Configure timeouts on all HTTP clients calling external services to prevent hanging. Severity: Medium. CWE: CWE-400.
- [ ] SC-GO-399: Implement circuit breakers — Use circuit breaker patterns for third-party calls to prevent cascading failures. Severity: Medium. CWE: CWE-400.
- [ ] SC-GO-400: Validate third-party API responses — Validate structure, types, and ranges of data received from third-party APIs before use. Severity: Medium. CWE: CWE-20.
- [ ] SC-GO-401: Use TLS for third-party connections — Ensure all connections to external services use TLS with certificate validation. Severity: High. CWE: CWE-319.
- [ ] SC-GO-402: Protect third-party API credentials — Store third-party API keys and secrets in secure vaults, not in configuration files or source code. Severity: High. CWE: CWE-798.
- [ ] SC-GO-403: Implement retry limits — Limit retry attempts for failed third-party calls to prevent amplification attacks and resource exhaustion. Severity: Medium. CWE: CWE-770.
- [ ] SC-GO-404: Sanitize data from external APIs — Treat data from third-party APIs as untrusted; validate and sanitize before use in queries, templates, or commands. Severity: High. CWE: CWE-20.
- [ ] SC-GO-405: Implement payment integration security — Use PCI-compliant payment providers; never store or log full credit card numbers. Severity: Critical. CWE: CWE-312.
- [ ] SC-GO-406: Validate S3/cloud storage signed URLs — Set appropriate expiration times on pre-signed URLs and validate bucket/object paths. Severity: Medium. CWE: CWE-284.
- [ ] SC-GO-407: Secure email sending — Use authenticated SMTP with TLS; validate email addresses and sanitize email content to prevent injection. Severity: Medium. CWE: CWE-93.
- [ ] SC-GO-408: Implement message queue security — Use authenticated and encrypted connections to message brokers (RabbitMQ, Kafka, NATS). Severity: High. CWE: CWE-319.
- [ ] SC-GO-409: Validate SSO/SAML assertions — Verify SAML signatures, timestamps, audience, and issuer before trusting assertions. Severity: Critical. CWE: CWE-347.
- [ ] SC-GO-410: Prevent LDAP injection — Use parameterized LDAP queries; escape special characters in user-supplied LDAP filter values. Severity: High. CWE: CWE-90.
- [ ] SC-GO-411: Secure DNS lookups — Use DNS over HTTPS (DoH) or DNSSEC validation for security-critical DNS lookups. Severity: Medium. CWE: CWE-350.
- [ ] SC-GO-412: Validate cloud metadata access — Restrict access to cloud instance metadata endpoints (169.254.169.254) from application code. Severity: High. CWE: CWE-918.
- [ ] SC-GO-413: Implement external service allowlisting — Maintain an allowlist of external hosts and IPs that the application is permitted to connect to. Severity: Medium. CWE: CWE-918.
- [ ] SC-GO-414: Secure gRPC client connections — Use grpc.WithTransportCredentials for all gRPC client connections; never use WithInsecure in production. Severity: High. CWE: CWE-319.
- [ ] SC-GO-415: Validate certificate transparency logs — Check Certificate Transparency logs for certificates issued for your domains to detect unauthorized issuance. Severity: Low. CWE: CWE-295.
