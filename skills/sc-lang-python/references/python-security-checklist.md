# Python Security Checklist

> 400+ security checks for Python applications.
> Used by security-check sc-lang-python skill as reference.

## How to Use
This checklist is automatically referenced by the sc-lang-python skill during security scans. It can also be used manually during code review.

## Categories

---

### 1. Input Validation & Sanitization (25 items)

- [ ] SC-PY-001: Unvalidated user input in eval() — User-controlled strings passed to `eval()` allow arbitrary code execution. Severity: Critical. CWE: CWE-95.
- [ ] SC-PY-002: Unvalidated user input in exec() — User-controlled strings passed to `exec()` allow arbitrary code execution. Severity: Critical. CWE: CWE-95.
- [ ] SC-PY-003: Format string injection via f-strings — User input interpolated into f-strings or `.format()` can leak variables from local/global scope. Severity: High. CWE: CWE-134.
- [ ] SC-PY-004: Regular expression denial of service (ReDoS) — Untrusted input matched against complex regex patterns can cause catastrophic backtracking. Severity: Medium. CWE: CWE-1333.
- [ ] SC-PY-005: Missing input length validation — Accepting unbounded input without length limits can exhaust memory or cause denial of service. Severity: Medium. CWE: CWE-770.
- [ ] SC-PY-006: Insufficient allowlist validation — Using denylists instead of allowlists for input validation misses novel attack vectors. Severity: Medium. CWE: CWE-184.
- [ ] SC-PY-007: Unicode normalization bypass — Failing to normalize Unicode before validation allows homoglyph or encoding attacks to bypass filters. Severity: Medium. CWE: CWE-176.
- [ ] SC-PY-008: HTML injection via unescaped output — User input rendered in HTML templates without escaping enables cross-site scripting. Severity: High. CWE: CWE-79.
- [ ] SC-PY-009: Command injection via os.system() — Passing user input to `os.system()` allows shell command injection. Severity: Critical. CWE: CWE-78.
- [ ] SC-PY-010: Command injection via subprocess with shell=True — Using `subprocess.call(..., shell=True)` with user input enables shell injection. Severity: Critical. CWE: CWE-78.
- [ ] SC-PY-011: LDAP injection — Unsanitized user input in LDAP queries can modify query logic or extract unauthorized data. Severity: High. CWE: CWE-90.
- [ ] SC-PY-012: XML injection — User input included in XML documents without escaping can alter document structure. Severity: Medium. CWE: CWE-91.
- [ ] SC-PY-013: XPath injection — Unsanitized input in XPath queries allows data extraction or authentication bypass. Severity: High. CWE: CWE-643.
- [ ] SC-PY-014: Log injection — Unvalidated user input written to logs can forge log entries or inject control characters. Severity: Medium. CWE: CWE-117.
- [ ] SC-PY-015: Email header injection — User input in email headers without sanitization allows additional header injection. Severity: Medium. CWE: CWE-93.
- [ ] SC-PY-016: Server-side template injection (SSTI) — User input rendered through a template engine without sandboxing allows remote code execution. Severity: Critical. CWE: CWE-1336.
- [ ] SC-PY-017: Null byte injection — Null bytes in user input can truncate strings in C-backed libraries, bypassing validation. Severity: Medium. CWE: CWE-158.
- [ ] SC-PY-018: Integer overflow/underflow in input — Numeric input not validated against min/max bounds can cause unexpected behavior in calculations. Severity: Medium. CWE: CWE-190.
- [ ] SC-PY-019: Missing content-type validation — Accepting file uploads without verifying MIME type allows malicious file delivery. Severity: Medium. CWE: CWE-434.
- [ ] SC-PY-020: Unsafe string concatenation for queries — Building queries by concatenating user input instead of using parameterized queries. Severity: High. CWE: CWE-89.
- [ ] SC-PY-021: Insufficient URL validation — Accepting user-supplied URLs without scheme and host validation enables SSRF attacks. Severity: High. CWE: CWE-918.
- [ ] SC-PY-022: Missing array/list bounds checking — User-supplied indices used to access lists without bounds checking can cause IndexError or data leak. Severity: Low. CWE: CWE-129.
- [ ] SC-PY-023: Unvalidated redirect URL — User-controlled URLs used in HTTP redirects enable open redirect attacks. Severity: Medium. CWE: CWE-601.
- [ ] SC-PY-024: Input type confusion — Accepting multiple types (str, list, dict) without type validation can cause unexpected behavior. Severity: Medium. CWE: CWE-843.
- [ ] SC-PY-025: Missing multipart form data validation — Failing to validate multipart form fields allows oversized or malformed uploads. Severity: Medium. CWE: CWE-20.

---

### 2. Authentication & Session Management (20 items)

- [ ] SC-PY-026: Hardcoded credentials — Usernames, passwords, or API keys hardcoded in source code are easily extracted. Severity: Critical. CWE: CWE-798.
- [ ] SC-PY-027: Weak password hashing with hashlib — Using `hashlib.md5()` or `hashlib.sha256()` without salting for password storage instead of bcrypt/argon2. Severity: High. CWE: CWE-916.
- [ ] SC-PY-028: Missing brute-force protection — Login endpoints without rate limiting or account lockout are vulnerable to credential stuffing. Severity: High. CWE: CWE-307.
- [ ] SC-PY-029: Insecure session token generation — Using `random` module instead of `secrets` for generating session tokens produces predictable values. Severity: High. CWE: CWE-330.
- [ ] SC-PY-030: Session fixation — Failing to regenerate session IDs after authentication allows session fixation attacks. Severity: High. CWE: CWE-384.
- [ ] SC-PY-031: Missing session expiration — Sessions without timeout or expiration persist indefinitely, increasing hijack risk. Severity: Medium. CWE: CWE-613.
- [ ] SC-PY-032: JWT secret in source code — Hardcoding JWT signing secrets in application code exposes them to version control leaks. Severity: Critical. CWE: CWE-798.
- [ ] SC-PY-033: JWT algorithm confusion — Accepting multiple JWT algorithms without validation enables algorithm-switching attacks (e.g., none, HS256 vs RS256). Severity: High. CWE: CWE-327.
- [ ] SC-PY-034: Missing JWT expiration validation — Not verifying `exp` claim in JWT tokens allows indefinite token reuse. Severity: Medium. CWE: CWE-613.
- [ ] SC-PY-035: Insecure cookie attributes — Session cookies missing `Secure`, `HttpOnly`, or `SameSite` flags are exposed to interception or XSS theft. Severity: Medium. CWE: CWE-614.
- [ ] SC-PY-036: Credential logging — Logging passwords, tokens, or secrets in plaintext exposes them in log files. Severity: High. CWE: CWE-532.
- [ ] SC-PY-037: Timing attack on password comparison — Using `==` to compare password hashes leaks information via timing side channels instead of `hmac.compare_digest()`. Severity: Medium. CWE: CWE-208.
- [ ] SC-PY-038: Missing multi-factor authentication — Sensitive operations lack a second authentication factor, relying solely on passwords. Severity: Medium. CWE: CWE-308.
- [ ] SC-PY-039: Password stored in plaintext — Storing passwords without hashing in databases or files. Severity: Critical. CWE: CWE-256.
- [ ] SC-PY-040: Insecure password reset flow — Password reset tokens that are predictable, non-expiring, or reusable enable account takeover. Severity: High. CWE: CWE-640.
- [ ] SC-PY-041: OAuth state parameter missing — OAuth flows without a `state` parameter are vulnerable to CSRF-based login attacks. Severity: Medium. CWE: CWE-352.
- [ ] SC-PY-042: Insufficient token entropy — Authentication tokens with fewer than 128 bits of entropy can be brute-forced. Severity: Medium. CWE: CWE-331.
- [ ] SC-PY-043: Cleartext token transmission — Sending authentication tokens over HTTP instead of HTTPS exposes them to interception. Severity: High. CWE: CWE-319.
- [ ] SC-PY-044: Missing account lockout mechanism — No lockout after repeated failed login attempts allows unlimited password guessing. Severity: Medium. CWE: CWE-307.
- [ ] SC-PY-045: Verbose authentication error messages — Distinguishing between "user not found" and "wrong password" in error messages enables user enumeration. Severity: Low. CWE: CWE-209.

---

### 3. Authorization & Access Control (20 items)

- [ ] SC-PY-046: Missing authorization checks — Endpoints or functions accessible without verifying user permissions allow unauthorized access. Severity: Critical. CWE: CWE-862.
- [ ] SC-PY-047: Insecure direct object reference (IDOR) — Using user-supplied IDs to access resources without ownership verification. Severity: High. CWE: CWE-639.
- [ ] SC-PY-048: Privilege escalation via role manipulation — User-controlled role fields in requests allow self-assignment of higher privileges. Severity: Critical. CWE: CWE-269.
- [ ] SC-PY-049: Path traversal in authorization — Authorization checks that rely on URL path matching can be bypassed with path traversal sequences. Severity: High. CWE: CWE-22.
- [ ] SC-PY-050: Horizontal privilege escalation — Users can access other users' resources by modifying identifiers without cross-user authorization checks. Severity: High. CWE: CWE-639.
- [ ] SC-PY-051: Missing function-level access control — Administrative functions accessible to regular users due to missing decorator or middleware checks. Severity: Critical. CWE: CWE-285.
- [ ] SC-PY-052: Broken object property-level authorization — API responses exposing internal fields (e.g., is_admin, password_hash) that should be filtered per role. Severity: Medium. CWE: CWE-213.
- [ ] SC-PY-053: JWT claims not verified for authorization — Trusting JWT payload claims without server-side verification of roles/permissions. Severity: High. CWE: CWE-285.
- [ ] SC-PY-054: Mass assignment vulnerability — Accepting all request fields for model updates allows setting protected attributes like `is_admin`. Severity: High. CWE: CWE-915.
- [ ] SC-PY-055: Default-allow access policy — Access control defaulting to allow rather than deny when rules are missing. Severity: High. CWE: CWE-276.
- [ ] SC-PY-056: Client-side authorization enforcement — Relying on frontend to enforce access controls that can be bypassed by direct API calls. Severity: High. CWE: CWE-602.
- [ ] SC-PY-057: Inconsistent authorization across endpoints — The same resource accessible through multiple endpoints with different authorization requirements. Severity: Medium. CWE: CWE-285.
- [ ] SC-PY-058: Missing rate limiting on sensitive operations — Administrative or destructive operations without rate limits allow abuse. Severity: Medium. CWE: CWE-770.
- [ ] SC-PY-059: Insecure access control in file serving — Serving user files without verifying the requesting user owns the file. Severity: High. CWE: CWE-639.
- [ ] SC-PY-060: Failure to restrict URL access — Hidden admin pages accessible by direct URL without authentication checks. Severity: High. CWE: CWE-425.
- [ ] SC-PY-061: Authorization bypass via HTTP method — Access controls only applied to GET/POST but not PUT/DELETE/PATCH on the same resource. Severity: Medium. CWE: CWE-285.
- [ ] SC-PY-062: Missing ownership validation on delete — Delete operations that don't verify the requesting user owns the resource. Severity: High. CWE: CWE-862.
- [ ] SC-PY-063: Shared resource leakage — Multi-tenant applications exposing data across tenant boundaries due to missing tenant filters. Severity: Critical. CWE: CWE-668.
- [ ] SC-PY-064: Decorator ordering issues for auth — Incorrect ordering of authentication/authorization decorators on Flask/Django views can skip checks. Severity: High. CWE: CWE-285.
- [ ] SC-PY-065: Unprotected GraphQL introspection — GraphQL introspection left enabled in production reveals the entire API schema. Severity: Medium. CWE: CWE-200.

---

### 4. Cryptography (25 items)

- [ ] SC-PY-066: Use of MD5 for security purposes — Using `hashlib.md5()` for hashing passwords or verifying integrity is cryptographically broken. Severity: High. CWE: CWE-328.
- [ ] SC-PY-067: Use of SHA1 for security purposes — Using `hashlib.sha1()` for digital signatures or certificates is deprecated and collision-prone. Severity: High. CWE: CWE-328.
- [ ] SC-PY-068: Use of DES/3DES encryption — Using DES or Triple-DES for encryption is obsolete and provides insufficient key length. Severity: High. CWE: CWE-327.
- [ ] SC-PY-069: ECB mode in block cipher — Using AES in ECB mode does not provide semantic security; identical plaintext blocks produce identical ciphertext. Severity: High. CWE: CWE-327.
- [ ] SC-PY-070: Static/hardcoded encryption keys — Encryption keys embedded in source code are easily extracted by anyone with code access. Severity: Critical. CWE: CWE-321.
- [ ] SC-PY-071: Static/hardcoded initialization vectors — Reusing the same IV for encryption breaks the semantic security of CBC and CTR modes. Severity: High. CWE: CWE-329.
- [ ] SC-PY-072: Missing HMAC on ciphertext — Encrypting without authentication (encrypt-only) is vulnerable to padding oracle and bit-flipping attacks. Severity: High. CWE: CWE-353.
- [ ] SC-PY-073: Weak random number generation for crypto — Using `random.random()` or `random.randint()` for cryptographic keys or nonces instead of `secrets` module. Severity: Critical. CWE: CWE-338.
- [ ] SC-PY-074: Insufficient key length — Using RSA keys under 2048 bits or AES keys under 128 bits provides inadequate security margin. Severity: High. CWE: CWE-326.
- [ ] SC-PY-075: Broken key derivation — Using simple hashing instead of PBKDF2, scrypt, or Argon2 for deriving keys from passwords. Severity: High. CWE: CWE-916.
- [ ] SC-PY-076: Missing salt in password hashing — Hashing passwords without a unique per-user salt enables rainbow table attacks. Severity: High. CWE: CWE-916.
- [ ] SC-PY-077: Insecure TLS/SSL version — Allowing SSLv3, TLS 1.0, or TLS 1.1 connections that have known vulnerabilities. Severity: High. CWE: CWE-326.
- [ ] SC-PY-078: Certificate validation disabled — Setting `verify=False` in requests or disabling SSL certificate verification in urllib3. Severity: High. CWE: CWE-295.
- [ ] SC-PY-079: Predictable PRNG seed — Seeding `random.seed()` with a fixed or low-entropy value makes output predictable. Severity: Medium. CWE: CWE-335.
- [ ] SC-PY-080: RSA without proper padding — Using raw RSA (textbook RSA) without OAEP or PSS padding enables known attacks. Severity: High. CWE: CWE-780.
- [ ] SC-PY-081: Private key exposure in logs or errors — Private keys or key material included in log messages or error responses. Severity: Critical. CWE: CWE-532.
- [ ] SC-PY-082: Deprecated cryptographic library — Using PyCrypto (unmaintained) instead of PyCryptodome or `cryptography` library. Severity: Medium. CWE: CWE-327.
- [ ] SC-PY-083: Improper certificate pinning — Missing or improperly implemented certificate pinning allows man-in-the-middle attacks. Severity: Medium. CWE: CWE-295.
- [ ] SC-PY-084: Nonce reuse in stream ciphers — Reusing a nonce with AES-CTR or ChaCha20 completely breaks confidentiality. Severity: Critical. CWE: CWE-323.
- [ ] SC-PY-085: Side-channel leakage in crypto operations — Non-constant-time comparison of MACs or signatures leaks information via timing. Severity: Medium. CWE: CWE-208.
- [ ] SC-PY-086: Encrypt-then-MAC vs MAC-then-Encrypt — Using MAC-then-Encrypt ordering is vulnerable to padding oracle attacks; prefer Encrypt-then-MAC or AEAD. Severity: Medium. CWE: CWE-327.
- [ ] SC-PY-087: Custom cryptographic implementation — Implementing custom encryption or hashing algorithms instead of using vetted libraries. Severity: High. CWE: CWE-327.
- [ ] SC-PY-088: Insecure key storage — Storing encryption keys in plaintext files, environment variables without protection, or databases. Severity: High. CWE: CWE-312.
- [ ] SC-PY-089: Missing key rotation mechanism — Cryptographic keys used indefinitely without rotation increase exposure window on compromise. Severity: Medium. CWE: CWE-324.
- [ ] SC-PY-090: Weak PBKDF2 iteration count — Using fewer than 600,000 iterations for PBKDF2-HMAC-SHA256 allows faster brute-force attacks. Severity: Medium. CWE: CWE-916.

---

### 5. Error Handling & Logging (20 items)

- [ ] SC-PY-091: Detailed stack traces in production — Returning full tracebacks to users reveals internal paths, library versions, and code structure. Severity: Medium. CWE: CWE-209.
- [ ] SC-PY-092: Bare except clause — Using `except:` or `except Exception` without proper handling silently swallows security-relevant errors. Severity: Medium. CWE: CWE-754.
- [ ] SC-PY-093: Sensitive data in exception messages — Including passwords, tokens, or PII in exception messages that may be logged or displayed. Severity: High. CWE: CWE-209.
- [ ] SC-PY-094: Missing error logging — Security-relevant events (failed logins, authorization failures) not logged for audit trail. Severity: Medium. CWE: CWE-778.
- [ ] SC-PY-095: Excessive logging of sensitive data — Logging full request bodies, headers with auth tokens, or user PII violates data protection principles. Severity: High. CWE: CWE-532.
- [ ] SC-PY-096: Log injection via user input — Unsanitized user input in log messages enables log forging or log-based injection attacks. Severity: Medium. CWE: CWE-117.
- [ ] SC-PY-097: Debug mode enabled in production — Running Flask with `debug=True` or Django with `DEBUG=True` in production exposes sensitive info and enables code execution. Severity: Critical. CWE: CWE-489.
- [ ] SC-PY-098: Unhandled exceptions revealing internals — Uncaught exceptions returning default error pages with framework internals to users. Severity: Medium. CWE: CWE-209.
- [ ] SC-PY-099: Missing rate limiting on error-triggering endpoints — Endpoints that generate errors without rate limits enable log flooding denial of service. Severity: Low. CWE: CWE-770.
- [ ] SC-PY-100: Error handling bypass of security checks — Exception handlers that skip subsequent security validation when an error occurs. Severity: High. CWE: CWE-755.
- [ ] SC-PY-101: Missing logging of authentication events — Failed and successful authentication events not logged, preventing security monitoring. Severity: Medium. CWE: CWE-778.
- [ ] SC-PY-102: Insecure logging configuration — Log files writable by all users or stored in publicly accessible directories. Severity: Medium. CWE: CWE-276.
- [ ] SC-PY-103: Missing log integrity protection — Logs without tamper detection allow attackers to cover tracks after compromise. Severity: Low. CWE: CWE-354.
- [ ] SC-PY-104: Exception-based information leakage in APIs — API error responses including internal exception types, database details, or ORM specifics. Severity: Medium. CWE: CWE-209.
- [ ] SC-PY-105: Silent failure on critical operations — Security-critical operations that fail silently without alerting or logging the failure. Severity: High. CWE: CWE-390.
- [ ] SC-PY-106: Uncaught SystemExit or KeyboardInterrupt — Catching `BaseException` can intercept `SystemExit` and `KeyboardInterrupt`, preventing clean shutdown. Severity: Low. CWE: CWE-754.
- [ ] SC-PY-107: Missing structured logging — Using unstructured log formats makes security event correlation and analysis difficult. Severity: Low. CWE: CWE-778.
- [ ] SC-PY-108: Logging to stdout in production — Writing security logs only to stdout/stderr without persistent storage loses audit trail. Severity: Low. CWE: CWE-778.
- [ ] SC-PY-109: Overly broad exception handling hiding bugs — Catching all exceptions at a high level masks bugs that could indicate security issues. Severity: Medium. CWE: CWE-396.
- [ ] SC-PY-110: Missing correlation IDs in security logs — Security events without correlation IDs make it impossible to trace attack sequences. Severity: Low. CWE: CWE-778.

---

### 6. Data Protection & Privacy (20 items)

- [ ] SC-PY-111: PII stored in plaintext — Personally identifiable information stored without encryption or pseudonymization. Severity: High. CWE: CWE-312.
- [ ] SC-PY-112: Sensitive data in URL parameters — Passwords, tokens, or PII passed as URL query parameters visible in browser history and server logs. Severity: Medium. CWE: CWE-598.
- [ ] SC-PY-113: Missing data-at-rest encryption — Sensitive data stored in databases or files without encryption. Severity: High. CWE: CWE-311.
- [ ] SC-PY-114: Missing data-in-transit encryption — Sensitive data transmitted over unencrypted HTTP connections. Severity: High. CWE: CWE-319.
- [ ] SC-PY-115: Exposure of internal data structures — Returning entire database model objects in API responses instead of curated DTOs. Severity: Medium. CWE: CWE-200.
- [ ] SC-PY-116: Insecure temporary file creation — Using `tempfile.mktemp()` instead of `tempfile.mkstemp()` creates race-condition-prone temp files. Severity: Medium. CWE: CWE-377.
- [ ] SC-PY-117: Data remnants in memory — Sensitive data not cleared from memory after use, remaining accessible in process memory or core dumps. Severity: Medium. CWE: CWE-316.
- [ ] SC-PY-118: Missing data retention policy enforcement — Sensitive data retained indefinitely without automated purging violates privacy regulations. Severity: Medium. CWE: CWE-404.
- [ ] SC-PY-119: Sensitive data in version control — Configuration files with secrets, private keys, or database credentials committed to git. Severity: Critical. CWE: CWE-540.
- [ ] SC-PY-120: Inadequate data masking in non-production — Production data used in development/staging environments without proper anonymization. Severity: Medium. CWE: CWE-200.
- [ ] SC-PY-121: Cache storing sensitive data — Caching layers (Redis, Memcached) storing sensitive data without encryption or TTL. Severity: Medium. CWE: CWE-524.
- [ ] SC-PY-122: Clipboard data exposure — Sensitive data copied to clipboard without automatic clearing enables cross-application leakage. Severity: Low. CWE: CWE-200.
- [ ] SC-PY-123: Missing HTTP cache-control headers for sensitive pages — Sensitive responses without `Cache-Control: no-store` may be cached by browsers or proxies. Severity: Medium. CWE: CWE-525.
- [ ] SC-PY-124: Backup data exposure — Database backups stored unencrypted or in publicly accessible storage. Severity: High. CWE: CWE-312.
- [ ] SC-PY-125: Missing data classification — No classification system for data sensitivity leading to inconsistent protection levels. Severity: Low. CWE: CWE-200.
- [ ] SC-PY-126: Sensitive data in error reports — Error reporting services (Sentry, Rollbar) capturing PII or secrets from request/exception context. Severity: High. CWE: CWE-209.
- [ ] SC-PY-127: Inadequate GDPR/CCPA compliance — Missing data subject access, portability, or deletion functionality required by privacy regulations. Severity: Medium. CWE: CWE-359.
- [ ] SC-PY-128: Leaking data through HTTP Referer — Pages with sensitive URL parameters sending Referer headers to third-party resources. Severity: Medium. CWE: CWE-200.
- [ ] SC-PY-129: Insecure data serialization for storage — Using pickle to serialize sensitive data for persistent storage creates both security and integrity risks. Severity: High. CWE: CWE-502.
- [ ] SC-PY-130: Over-collection of user data — Collecting more personal data than required for the stated purpose violates data minimization principles. Severity: Low. CWE: CWE-359.

---

### 7. SQL/NoSQL/ORM Security (20 items)

- [ ] SC-PY-131: SQL injection via string formatting — Building SQL queries with f-strings, `.format()`, or `%` operator with user input. Severity: Critical. CWE: CWE-89.
- [ ] SC-PY-132: SQL injection via raw queries — Using Django `raw()`, SQLAlchemy `text()`, or `cursor.execute()` with string concatenation. Severity: Critical. CWE: CWE-89.
- [ ] SC-PY-133: NoSQL injection in MongoDB — Unsanitized user input in PyMongo query filters allowing operator injection (`$gt`, `$ne`, `$where`). Severity: High. CWE: CWE-943.
- [ ] SC-PY-134: ORM filter bypass via extra() — Using Django ORM `.extra()` method with unsanitized input bypasses ORM's built-in protections. Severity: High. CWE: CWE-89.
- [ ] SC-PY-135: Second-order SQL injection — Data safely stored but later retrieved and used unsafely in SQL query construction. Severity: High. CWE: CWE-89.
- [ ] SC-PY-136: Blind SQL injection via timing — SQL queries with user input that can be exploited through response time differences to extract data. Severity: High. CWE: CWE-89.
- [ ] SC-PY-137: Insecure database connection strings — Database connection strings with embedded credentials or without TLS enabled. Severity: High. CWE: CWE-319.
- [ ] SC-PY-138: Missing parameterized queries — Using string interpolation in any database query instead of parameterized/prepared statements. Severity: High. CWE: CWE-89.
- [ ] SC-PY-139: Excessive database privileges — Application database user having unnecessary privileges like DROP, CREATE, or GRANT. Severity: Medium. CWE: CWE-250.
- [ ] SC-PY-140: SQL injection in ORDER BY clauses — Dynamic ORDER BY constructed from user input, where parameterization typically doesn't apply. Severity: Medium. CWE: CWE-89.
- [ ] SC-PY-141: SQL injection in LIKE patterns — User input used in LIKE clauses without escaping wildcards (`%`, `_`) can alter query behavior. Severity: Low. CWE: CWE-89.
- [ ] SC-PY-142: Missing query result size limits — Queries without LIMIT/pagination allowing extraction of entire database tables. Severity: Medium. CWE: CWE-770.
- [ ] SC-PY-143: Unvalidated database schema input — User input used in table or column names without validation enables SQL injection outside value context. Severity: High. CWE: CWE-89.
- [ ] SC-PY-144: Django QuerySet annotation injection — Using `RawSQL()` or unsanitized input in `.annotate()` allows SQL injection through ORM. Severity: High. CWE: CWE-89.
- [ ] SC-PY-145: Redis command injection — Unsanitized user input in Redis commands can execute arbitrary Redis operations. Severity: High. CWE: CWE-77.
- [ ] SC-PY-146: MongoDB JavaScript injection — User input in MongoDB `$where` clauses enables server-side JavaScript execution. Severity: Critical. CWE: CWE-943.
- [ ] SC-PY-147: Database credentials in source code — Database connection credentials hardcoded instead of read from environment or secrets manager. Severity: High. CWE: CWE-798.
- [ ] SC-PY-148: Missing database query logging for security events — Security-relevant database operations not logged for audit and forensic analysis. Severity: Low. CWE: CWE-778.
- [ ] SC-PY-149: Stored procedure injection — Calling stored procedures with unsanitized user input parameters. Severity: High. CWE: CWE-89.
- [ ] SC-PY-150: Missing database connection encryption — Connecting to databases without TLS/SSL allows network eavesdropping on queries and results. Severity: Medium. CWE: CWE-319.

---

### 8. File Operations (20 items)

- [ ] SC-PY-151: Path traversal via user input — User-supplied filenames containing `../` sequences access files outside intended directory. Severity: High. CWE: CWE-22.
- [ ] SC-PY-152: Unrestricted file upload — Accepting file uploads without type, size, or content validation allows malicious file storage. Severity: High. CWE: CWE-434.
- [ ] SC-PY-153: Symlink following — File operations that follow symbolic links can be tricked into reading or writing unintended files. Severity: Medium. CWE: CWE-59.
- [ ] SC-PY-154: Insecure file permissions — Creating files with world-readable/writable permissions (e.g., `os.chmod(path, 0o777)`). Severity: Medium. CWE: CWE-276.
- [ ] SC-PY-155: Race condition in file operations (TOCTOU) — Checking file properties and then operating on the file creates a time-of-check-to-time-of-use gap. Severity: Medium. CWE: CWE-367.
- [ ] SC-PY-156: Unsafe temporary file usage — Using predictable temp file names or insecure temp directories allows symlink attacks. Severity: Medium. CWE: CWE-377.
- [ ] SC-PY-157: Directory listing exposure — Serving directory listings that reveal file structure and potentially sensitive filenames. Severity: Low. CWE: CWE-548.
- [ ] SC-PY-158: Missing file size limits — Accepting arbitrarily large file uploads causing disk exhaustion or denial of service. Severity: Medium. CWE: CWE-770.
- [ ] SC-PY-159: Unsafe file name handling — Using original user-supplied filenames for storage without sanitization enables path injection. Severity: Medium. CWE: CWE-73.
- [ ] SC-PY-160: File content validation bypass — Validating file type by extension only, not by content/magic bytes, allows disguised malicious files. Severity: Medium. CWE: CWE-434.
- [ ] SC-PY-161: Zip bomb / decompression bomb — Extracting user-supplied archives without checking decompressed size can exhaust disk and memory. Severity: Medium. CWE: CWE-409.
- [ ] SC-PY-162: Unsafe zipfile extraction — Using `zipfile.extractall()` without checking for path traversal in archive entry names. Severity: High. CWE: CWE-22.
- [ ] SC-PY-163: Insecure use of shutil — Using `shutil.copytree()` or `shutil.move()` with user-controlled paths without validation. Severity: Medium. CWE: CWE-22.
- [ ] SC-PY-164: Missing file deletion after processing — Temporary files containing sensitive data not deleted after use persist on disk. Severity: Low. CWE: CWE-459.
- [ ] SC-PY-165: Unsafe tarfile extraction — Using `tarfile.extractall()` without filtering allows path traversal and symlink attacks (CVE-2007-4559). Severity: High. CWE: CWE-22.
- [ ] SC-PY-166: World-writable configuration files — Application configuration files with overly permissive permissions allow unauthorized modification. Severity: Medium. CWE: CWE-276.
- [ ] SC-PY-167: Serving files from user-controlled paths — Using `send_file()` or `open()` with user-controlled paths without proper sandboxing. Severity: High. CWE: CWE-22.
- [ ] SC-PY-168: Missing file locking — Concurrent file access without locking can cause data corruption or race conditions. Severity: Low. CWE: CWE-362.
- [ ] SC-PY-169: Executable file upload — Allowing upload of `.py`, `.sh`, `.exe`, or other executable files that could be executed server-side. Severity: High. CWE: CWE-434.
- [ ] SC-PY-170: Insecure file deserialization — Reading and deserializing files (pickle, YAML) from user-controlled paths without validation. Severity: High. CWE: CWE-502.

---

### 9. Network & HTTP Security (25 items)

- [ ] SC-PY-171: Server-side request forgery (SSRF) — Making HTTP requests to user-supplied URLs without restricting internal/private IP ranges. Severity: High. CWE: CWE-918.
- [ ] SC-PY-172: Missing HTTPS enforcement — Application serving or accepting traffic over HTTP without redirecting to HTTPS. Severity: Medium. CWE: CWE-319.
- [ ] SC-PY-173: SSL certificate verification disabled — Using `requests.get(url, verify=False)` or `urllib3.disable_warnings()` to skip TLS verification. Severity: High. CWE: CWE-295.
- [ ] SC-PY-174: Missing CORS configuration — Cross-Origin Resource Sharing headers missing or overly permissive (`Access-Control-Allow-Origin: *`). Severity: Medium. CWE: CWE-942.
- [ ] SC-PY-175: Missing CSRF protection — State-changing endpoints without CSRF tokens are vulnerable to cross-site request forgery. Severity: High. CWE: CWE-352.
- [ ] SC-PY-176: Host header injection — Trusting the HTTP Host header for URL generation allows cache poisoning and password reset hijacking. Severity: Medium. CWE: CWE-644.
- [ ] SC-PY-177: Missing Content-Security-Policy header — Absence of CSP header allows inline scripts and loading resources from any origin. Severity: Medium. CWE: CWE-1021.
- [ ] SC-PY-178: Missing X-Content-Type-Options header — Without `nosniff`, browsers may MIME-sniff responses, interpreting uploads as executable content. Severity: Low. CWE: CWE-16.
- [ ] SC-PY-179: Missing X-Frame-Options header — Without frame restrictions, pages can be embedded in iframes for clickjacking attacks. Severity: Medium. CWE: CWE-1021.
- [ ] SC-PY-180: HTTP request smuggling — Inconsistencies in Content-Length and Transfer-Encoding handling between Python server and proxy. Severity: High. CWE: CWE-444.
- [ ] SC-PY-181: Unvalidated webhook URLs — Registering webhook callback URLs without validation allows SSRF via webhook delivery. Severity: Medium. CWE: CWE-918.
- [ ] SC-PY-182: Missing HTTP Strict-Transport-Security — Absence of HSTS header allows SSL stripping attacks on subsequent visits. Severity: Medium. CWE: CWE-319.
- [ ] SC-PY-183: DNS rebinding vulnerability — Web servers binding to 0.0.0.0 without host validation are vulnerable to DNS rebinding attacks. Severity: Medium. CWE: CWE-350.
- [ ] SC-PY-184: Insecure WebSocket connections — WebSocket connections over `ws://` instead of `wss://` transmit data in cleartext. Severity: Medium. CWE: CWE-319.
- [ ] SC-PY-185: Missing WebSocket origin validation — WebSocket endpoints accepting connections from any origin without checking Origin header. Severity: Medium. CWE: CWE-346.
- [ ] SC-PY-186: Response splitting via headers — User input in HTTP response headers containing CRLF characters enabling response splitting. Severity: Medium. CWE: CWE-113.
- [ ] SC-PY-187: Unsafe redirect handling — Following HTTP redirects in server-side requests can redirect to internal services (SSRF). Severity: Medium. CWE: CWE-918.
- [ ] SC-PY-188: Missing request timeout — HTTP client requests without timeouts can hang indefinitely, causing resource exhaustion. Severity: Medium. CWE: CWE-400.
- [ ] SC-PY-189: XML External Entity (XXE) processing — Parsing XML from untrusted sources with external entity processing enabled. Severity: High. CWE: CWE-611.
- [ ] SC-PY-190: Billion laughs XML attack — XML parsers without entity expansion limits vulnerable to exponential entity expansion DoS. Severity: Medium. CWE: CWE-776.
- [ ] SC-PY-191: Unprotected proxy configuration — HTTP proxy settings modifiable via environment variables allowing traffic interception. Severity: Medium. CWE: CWE-15.
- [ ] SC-PY-192: IP address spoofing via X-Forwarded-For — Trusting client-supplied X-Forwarded-For headers for IP-based access control. Severity: Medium. CWE: CWE-290.
- [ ] SC-PY-193: Missing Referrer-Policy header — Without Referrer-Policy, sensitive URL paths and parameters leak via Referer headers to third parties. Severity: Low. CWE: CWE-200.
- [ ] SC-PY-194: GraphQL query depth/complexity abuse — GraphQL endpoints without query depth or complexity limits enable denial of service via nested queries. Severity: Medium. CWE: CWE-400.
- [ ] SC-PY-195: HTTP method override abuse — Supporting `X-HTTP-Method-Override` headers can bypass method-based access controls. Severity: Medium. CWE: CWE-285.

---

### 10. Serialization & Deserialization (20 items)

- [ ] SC-PY-196: Pickle deserialization RCE — Deserializing untrusted data with `pickle.loads()` or `pickle.load()` allows arbitrary code execution via `__reduce__`. Severity: Critical. CWE: CWE-502.
- [ ] SC-PY-197: Unsafe YAML loading — Using `yaml.load()` without `Loader=SafeLoader` enables arbitrary Python object instantiation and RCE. Severity: Critical. CWE: CWE-502.
- [ ] SC-PY-198: Unsafe shelve module usage — The `shelve` module uses pickle internally, making it vulnerable to deserialization attacks on untrusted data. Severity: High. CWE: CWE-502.
- [ ] SC-PY-199: Unsafe marshal deserialization — Using `marshal.loads()` on untrusted data can cause crashes and potentially code execution. Severity: High. CWE: CWE-502.
- [ ] SC-PY-200: JSON deserialization with custom decoders — Custom JSON decoders that instantiate objects from type fields in untrusted JSON data. Severity: Medium. CWE: CWE-502.
- [ ] SC-PY-201: Insecure XML deserialization — Using `xmlrpc` or custom XML deserialization that instantiates arbitrary classes. Severity: High. CWE: CWE-502.
- [ ] SC-PY-202: Unsafe MessagePack deserialization — Using MessagePack with `raw=False` and custom ext types on untrusted input enabling object injection. Severity: Medium. CWE: CWE-502.
- [ ] SC-PY-203: Pickle in Redis/Memcached — Storing pickled objects in shared caches where other applications or attackers can inject malicious payloads. Severity: High. CWE: CWE-502.
- [ ] SC-PY-204: Unsafe jsonpickle usage — Using `jsonpickle.decode()` on untrusted input allows arbitrary object creation and code execution. Severity: Critical. CWE: CWE-502.
- [ ] SC-PY-205: Pickle in multiprocessing — Using pickle-based IPC in multiprocessing where untrusted processes share data. Severity: Medium. CWE: CWE-502.
- [ ] SC-PY-206: Unsafe dill deserialization — Using `dill.loads()` on untrusted data provides even broader code execution surface than pickle. Severity: Critical. CWE: CWE-502.
- [ ] SC-PY-207: Unsafe cloudpickle deserialization — Deserializing untrusted data with `cloudpickle` allows arbitrary code execution. Severity: Critical. CWE: CWE-502.
- [ ] SC-PY-208: XML-RPC deserialization — Python's `xmlrpc.server` or `xmlrpc.client` processing untrusted XML input without entity restrictions. Severity: Medium. CWE: CWE-611.
- [ ] SC-PY-209: Unsafe Protocol Buffer handling — Custom protobuf deserialization that maps to arbitrary Python types without validation. Severity: Medium. CWE: CWE-502.
- [ ] SC-PY-210: Pickle in Django sessions — Using pickle-based session serializer in Django allows RCE if session data is tampered with. Severity: High. CWE: CWE-502.
- [ ] SC-PY-211: Unsafe TOML loading with custom constructors — Custom TOML loaders that execute code or instantiate objects from configuration values. Severity: Medium. CWE: CWE-502.
- [ ] SC-PY-212: Serialization of sensitive data — Serializing objects containing secrets, tokens, or credentials for storage or transmission. Severity: Medium. CWE: CWE-312.
- [ ] SC-PY-213: Deserialization bomb — Maliciously crafted serialized data that expands to enormous objects causing memory exhaustion. Severity: Medium. CWE: CWE-400.
- [ ] SC-PY-214: Pickle protocol version mismatch — Using high pickle protocol versions that may not be validated by older security tools. Severity: Low. CWE: CWE-502.
- [ ] SC-PY-215: Unsafe numpy load — Using `numpy.load(allow_pickle=True)` on untrusted `.npy`/`.npz` files enables pickle-based RCE. Severity: High. CWE: CWE-502.

---

### 11. Concurrency & Race Conditions (15 items)

- [ ] SC-PY-216: Race condition in authentication — Time-of-check-to-time-of-use gap between verifying credentials and granting access. Severity: High. CWE: CWE-367.
- [ ] SC-PY-217: Race condition in file access — Checking file existence/permissions and then accessing the file in separate operations. Severity: Medium. CWE: CWE-367.
- [ ] SC-PY-218: Thread-unsafe global state — Mutable global variables accessed by multiple threads without synchronization in WSGI/ASGI apps. Severity: Medium. CWE: CWE-362.
- [ ] SC-PY-219: Race condition in balance/counter updates — Non-atomic read-modify-write operations on account balances or inventory counts. Severity: High. CWE: CWE-362.
- [ ] SC-PY-220: Missing database transaction isolation — Concurrent database operations without proper isolation level allowing dirty or phantom reads. Severity: Medium. CWE: CWE-362.
- [ ] SC-PY-221: Signal handler race condition — Python signal handlers that modify shared state accessed by the main thread. Severity: Medium. CWE: CWE-364.
- [ ] SC-PY-222: Race condition in temp file creation — Creating temporary files in a shared directory without using `os.O_EXCL` flag for atomicity. Severity: Medium. CWE: CWE-377.
- [ ] SC-PY-223: Double-checked locking anti-pattern — Implementing double-checked locking incorrectly in Python, which GIL does not fully protect. Severity: Low. CWE: CWE-362.
- [ ] SC-PY-224: Async race condition — Concurrent async tasks modifying shared state without proper synchronization via asyncio locks. Severity: Medium. CWE: CWE-362.
- [ ] SC-PY-225: Race condition in rate limiting — Rate limit counters checked and incremented non-atomically allowing burst bypass. Severity: Medium. CWE: CWE-362.
- [ ] SC-PY-226: Thread pool exhaustion — Unbounded thread pool creation for handling requests leading to resource exhaustion DoS. Severity: Medium. CWE: CWE-400.
- [ ] SC-PY-227: Deadlock enabling denial of service — Lock acquisition ordering inconsistencies causing deadlocks that freeze the application. Severity: Medium. CWE: CWE-833.
- [ ] SC-PY-228: Race condition in token refresh — Concurrent requests triggering multiple token refresh operations causing token invalidation. Severity: Medium. CWE: CWE-362.
- [ ] SC-PY-229: Non-atomic configuration reload — Reloading configuration at runtime while requests are being served with partially updated config. Severity: Low. CWE: CWE-362.
- [ ] SC-PY-230: GIL-bypass race conditions in C extensions — Python C extensions releasing the GIL while accessing Python objects create true race conditions. Severity: Medium. CWE: CWE-362.

---

### 12. Dependency & Supply Chain (25 items)

- [ ] SC-PY-231: Known vulnerable dependencies — Using Python packages with known CVEs without updating to patched versions. Severity: High. CWE: CWE-1035.
- [ ] SC-PY-232: Typosquatting packages — Installing packages with names similar to popular ones (e.g., `reqeusts` instead of `requests`). Severity: Critical. CWE: CWE-427.
- [ ] SC-PY-233: Unpinned dependency versions — Using `requests>=2.0` instead of `requests==2.31.0` allows unexpected major version upgrades. Severity: Medium. CWE: CWE-1035.
- [ ] SC-PY-234: Missing hash verification for packages — Installing packages without hash checking (`--require-hashes`) allows tampered package installation. Severity: Medium. CWE: CWE-345.
- [ ] SC-PY-235: Malicious setup.py execution — Running `pip install` on packages with malicious `setup.py` that executes code during installation. Severity: Critical. CWE: CWE-506.
- [ ] SC-PY-236: Dependency confusion attack — Private package names that collide with public PyPI packages allowing substitution. Severity: Critical. CWE: CWE-427.
- [ ] SC-PY-237: Abandoned/unmaintained packages — Depending on packages with no updates or maintainer activity for extended periods. Severity: Medium. CWE: CWE-1104.
- [ ] SC-PY-238: Excessive transitive dependencies — Deep dependency trees increasing the attack surface through indirect vulnerable packages. Severity: Medium. CWE: CWE-1104.
- [ ] SC-PY-239: Missing pip audit integration — Not running `pip-audit` or `safety check` in CI/CD to detect known vulnerabilities. Severity: Medium. CWE: CWE-1035.
- [ ] SC-PY-240: Insecure package index configuration — Using custom PyPI indexes over HTTP or without certificate verification. Severity: High. CWE: CWE-319.
- [ ] SC-PY-241: Missing lock file — Not using `pip-tools`, `poetry.lock`, or `Pipfile.lock` to ensure reproducible dependency resolution. Severity: Medium. CWE: CWE-1035.
- [ ] SC-PY-242: eval() in setup.py parsing — Using `eval()` to parse version strings or configuration from `setup.py` of third-party packages. Severity: High. CWE: CWE-95.
- [ ] SC-PY-243: Unverified package signatures — Installing packages without verifying PGP signatures or provenance attestations. Severity: Low. CWE: CWE-345.
- [ ] SC-PY-244: Git-based dependencies without pinning — Dependencies installed from git URLs without pinning to a specific commit hash. Severity: Medium. CWE: CWE-829.
- [ ] SC-PY-245: Vendored dependencies not updated — Copying third-party code into the project without tracking upstream security fixes. Severity: Medium. CWE: CWE-1104.
- [ ] SC-PY-246: Missing SBOM generation — No Software Bill of Materials generated for dependency tracking and vulnerability management. Severity: Low. CWE: CWE-1035.
- [ ] SC-PY-247: Post-install script execution — Packages with `post_install` hooks that download and execute additional code at install time. Severity: High. CWE: CWE-506.
- [ ] SC-PY-248: Namespace package hijacking — Namespace packages allowing malicious code injection into legitimate package namespaces. Severity: High. CWE: CWE-427.
- [ ] SC-PY-249: Outdated base Docker image — Python Docker images based on outdated OS versions with known system-level vulnerabilities. Severity: Medium. CWE: CWE-1104.
- [ ] SC-PY-250: Missing Dependabot/Renovate — No automated dependency update tooling to receive timely security patch notifications. Severity: Low. CWE: CWE-1035.
- [ ] SC-PY-251: Binary wheel without source audit — Installing pre-compiled binary wheels without ability to audit the compiled code. Severity: Medium. CWE: CWE-506.
- [ ] SC-PY-252: Dev dependencies in production — Development-only packages (pytest, debugpy) installed in production images increasing attack surface. Severity: Low. CWE: CWE-1104.
- [ ] SC-PY-253: Unrestricted extras_require — Installing package extras that pull in additional unneeded dependencies. Severity: Low. CWE: CWE-1104.
- [ ] SC-PY-254: pip install from untrusted URL — Using `pip install https://...` from unverified URLs without integrity checks. Severity: High. CWE: CWE-829.
- [ ] SC-PY-255: Missing Python version constraint — Packages without `python_requires` may install on unsupported Python versions with different security characteristics. Severity: Low. CWE: CWE-1035.

---

### 13. Configuration & Secrets Management (20 items)

- [ ] SC-PY-256: Secrets in environment variables without protection — Storing secrets in plain environment variables accessible to any process in the same user context. Severity: Medium. CWE: CWE-526.
- [ ] SC-PY-257: Django SECRET_KEY exposed — Django `SECRET_KEY` hardcoded or committed to version control enabling session forgery and RCE. Severity: Critical. CWE: CWE-798.
- [ ] SC-PY-258: Flask secret_key weak or default — Flask app using a weak, short, or default `secret_key` allowing session cookie forgery. Severity: Critical. CWE: CWE-798.
- [ ] SC-PY-259: Debug mode in production configuration — Debug flags enabled in production configuration files or environment settings. Severity: High. CWE: CWE-489.
- [ ] SC-PY-260: Insecure default configuration — Security-relevant settings defaulting to insecure values when configuration is missing. Severity: Medium. CWE: CWE-276.
- [ ] SC-PY-261: .env file committed to version control — `.env` files containing secrets tracked by git without being in `.gitignore`. Severity: Critical. CWE: CWE-540.
- [ ] SC-PY-262: Missing .gitignore for sensitive files — No `.gitignore` entries for `*.pem`, `*.key`, `.env`, `secrets.*`, or credential files. Severity: Medium. CWE: CWE-540.
- [ ] SC-PY-263: Secrets in configuration management — Plaintext secrets in Ansible playbooks, Terraform state, or other IaC files. Severity: High. CWE: CWE-312.
- [ ] SC-PY-264: API keys in client-side code — Server-side API keys exposed in JavaScript bundles or client-facing responses. Severity: High. CWE: CWE-200.
- [ ] SC-PY-265: Missing secrets rotation — API keys and credentials used indefinitely without rotation policy increasing exposure window. Severity: Medium. CWE: CWE-324.
- [ ] SC-PY-266: Insecure default admin credentials — Default admin accounts with well-known passwords not forced to change on first use. Severity: High. CWE: CWE-1188.
- [ ] SC-PY-267: Verbose server headers — HTTP server headers revealing Python version, framework, and server software. Severity: Low. CWE: CWE-200.
- [ ] SC-PY-268: Exposed management endpoints — Admin panels, health checks, or debug endpoints accessible without authentication. Severity: High. CWE: CWE-749.
- [ ] SC-PY-269: Configuration file injection — Loading configuration from user-controllable paths or environment variables pointing to malicious config. Severity: High. CWE: CWE-15.
- [ ] SC-PY-270: Insecure feature flag defaults — Feature flags defaulting to enabled state, accidentally exposing incomplete or untested features. Severity: Medium. CWE: CWE-276.
- [ ] SC-PY-271: Missing vault/secrets manager integration — Secrets managed manually instead of through HashiCorp Vault, AWS Secrets Manager, or similar. Severity: Medium. CWE: CWE-522.
- [ ] SC-PY-272: Overly permissive ALLOWED_HOSTS — Django `ALLOWED_HOSTS = ['*']` or empty list in production allows host header attacks. Severity: Medium. CWE: CWE-644.
- [ ] SC-PY-273: Database credentials in settings.py — Database passwords directly in Django `settings.py` committed to version control. Severity: High. CWE: CWE-798.
- [ ] SC-PY-274: Exposed Celery broker credentials — RabbitMQ/Redis credentials for Celery broker hardcoded in task configuration. Severity: High. CWE: CWE-798.
- [ ] SC-PY-275: Missing configuration validation on startup — Application starting with invalid or insecure configuration without validation checks. Severity: Medium. CWE: CWE-1188.

---

### 14. Memory & Type Safety (15 items)

- [ ] SC-PY-276: Buffer overflow in C extensions — Python C extensions with buffer overflows in string or array handling. Severity: Critical. CWE: CWE-120.
- [ ] SC-PY-277: ctypes pointer misuse — Using `ctypes` with incorrect pointer types or sizes causing memory corruption. Severity: High. CWE: CWE-119.
- [ ] SC-PY-278: Memory leak in long-running processes — Objects not garbage collected due to reference cycles or C extension leaks causing OOM. Severity: Medium. CWE: CWE-401.
- [ ] SC-PY-279: Integer overflow in C extensions — Integer overflow in Python C extensions leading to heap corruption or incorrect buffer allocation. Severity: High. CWE: CWE-190.
- [ ] SC-PY-280: Unsafe cffi foreign function calls — Calling C functions via `cffi` with unchecked buffer sizes or types. Severity: High. CWE: CWE-119.
- [ ] SC-PY-281: Use-after-free in C extensions — C extension code using Python objects after their reference count reaches zero. Severity: Critical. CWE: CWE-416.
- [ ] SC-PY-282: Uncontrolled memory allocation — User-controlled input determining allocation size (e.g., `bytearray(user_size)`) without limits. Severity: Medium. CWE: CWE-789.
- [ ] SC-PY-283: Sensitive data in Python object __dict__ — Secrets accessible through object introspection and `__dict__` attribute inspection. Severity: Low. CWE: CWE-200.
- [ ] SC-PY-284: Type confusion in dynamic dispatch — Using `isinstance()` checks that can be bypassed with metaclass manipulation or `__class__` assignment. Severity: Medium. CWE: CWE-843.
- [ ] SC-PY-285: Missing resource limits — No `resource.setrlimit()` or container memory limits for Python processes allowing memory exhaustion. Severity: Medium. CWE: CWE-770.
- [ ] SC-PY-286: Numpy array buffer overread — Accessing numpy arrays with incorrect dtypes or shapes leading to out-of-bounds reads. Severity: Medium. CWE: CWE-125.
- [ ] SC-PY-287: String interning security implications — Relying on string identity (`is`) instead of equality (`==`) for security comparisons. Severity: Low. CWE: CWE-595.
- [ ] SC-PY-288: mmap without bounds checking — Memory-mapped files accessed without proper bounds validation. Severity: Medium. CWE: CWE-119.
- [ ] SC-PY-289: Shared memory segment exposure — Using `multiprocessing.shared_memory` without access controls exposing data to other processes. Severity: Medium. CWE: CWE-732.
- [ ] SC-PY-290: Struct pack/unpack with user-controlled format — Using `struct.pack()` or `struct.unpack()` with user-controlled format strings causing crashes. Severity: Medium. CWE: CWE-134.

---

### 15. Python-Specific Patterns (25 items)

- [ ] SC-PY-291: Dangerous __import__() usage — Using `__import__()` with user-controlled module names allows importing arbitrary modules. Severity: Critical. CWE: CWE-95.
- [ ] SC-PY-292: Unsafe compile() and code objects — Using `compile()` with user input to create code objects that can be executed. Severity: Critical. CWE: CWE-95.
- [ ] SC-PY-293: Unsafe getattr() with user input — Using `getattr(obj, user_input)` allows accessing any attribute including private or dangerous methods. Severity: High. CWE: CWE-470.
- [ ] SC-PY-294: Unsafe setattr() with user input — Using `setattr(obj, user_input, value)` allows modifying any object attribute including security controls. Severity: High. CWE: CWE-915.
- [ ] SC-PY-295: Metaclass manipulation — Custom metaclasses that can be exploited to modify class behavior at creation time. Severity: Medium. CWE: CWE-913.
- [ ] SC-PY-296: __del__ finalizer abuse — Relying on `__del__` for security cleanup is unreliable as it may not be called deterministically. Severity: Low. CWE: CWE-459.
- [ ] SC-PY-297: Unsafe globals()/locals() access — Passing `globals()` or `locals()` to template engines or eval contexts exposes all variables. Severity: High. CWE: CWE-200.
- [ ] SC-PY-298: Monkey-patching security functions — Runtime monkey-patching of security-related functions (auth checks, validators) by malicious code. Severity: High. CWE: CWE-913.
- [ ] SC-PY-299: Unsafe ast.literal_eval alternatives — Using `eval()` where `ast.literal_eval()` would safely handle literal expressions. Severity: High. CWE: CWE-95.
- [ ] SC-PY-300: Descriptors and properties bypassing access control — Python descriptors or properties that can be bypassed by direct `__dict__` access. Severity: Low. CWE: CWE-284.
- [ ] SC-PY-301: sys.modules manipulation — Modifying `sys.modules` to replace legitimate modules with malicious implementations. Severity: High. CWE: CWE-913.
- [ ] SC-PY-302: Unsafe use of __subclasses__() — Accessing `object.__subclasses__()` in sandboxed environments to escape restrictions. Severity: High. CWE: CWE-913.
- [ ] SC-PY-303: Weak __eq__ and __hash__ implementations — Inconsistent equality and hashing in objects used for security decisions (tokens, permissions). Severity: Low. CWE: CWE-697.
- [ ] SC-PY-304: importlib with untrusted input — Using `importlib.import_module()` with user-controlled strings to load arbitrary modules. Severity: High. CWE: CWE-470.
- [ ] SC-PY-305: os.environ mutation — Modifying `os.environ` at runtime affecting security-relevant configuration for concurrent requests. Severity: Medium. CWE: CWE-362.
- [ ] SC-PY-306: Unsafe decorator ordering — Security decorators applied in wrong order, allowing bypassed authentication or authorization. Severity: High. CWE: CWE-285.
- [ ] SC-PY-307: Mutable default arguments — Mutable default arguments (lists, dicts) shared across calls can lead to unintended data leakage. Severity: Low. CWE: CWE-463.
- [ ] SC-PY-308: Insecure __repr__ exposing secrets — `__repr__` methods that include sensitive attributes, leaking secrets in logs and debugger output. Severity: Medium. CWE: CWE-532.
- [ ] SC-PY-309: Unprotected __init_subclass__ — Missing validation in `__init_subclass__` allowing malicious subclass creation. Severity: Low. CWE: CWE-913.
- [ ] SC-PY-310: Insecure use of operator module — Using `operator.attrgetter()` or `operator.methodcaller()` with user-controlled attribute names. Severity: Medium. CWE: CWE-470.
- [ ] SC-PY-311: Python 2/3 compatibility security issues — Mixed Python 2/3 code with different string/bytes handling creating encoding vulnerabilities. Severity: Medium. CWE: CWE-176.
- [ ] SC-PY-312: Unvalidated __class__ assignment — Allowing `obj.__class__ = NewClass` to change object type at runtime, bypassing type checks. Severity: Medium. CWE: CWE-843.
- [ ] SC-PY-313: Insecure use of functools.reduce with untrusted data — Applying `reduce()` operations on user-controlled sequences without length limits causing DoS. Severity: Low. CWE: CWE-400.
- [ ] SC-PY-314: Context manager exit suppression — Using `__exit__` returning `True` to suppress exceptions that indicate security failures. Severity: Medium. CWE: CWE-755.
- [ ] SC-PY-315: Unrestricted generator/iterator consumption — User-controlled generators consumed without limits causing memory exhaustion. Severity: Medium. CWE: CWE-400.

---

### 16. Django-Specific (25 items)

- [ ] SC-PY-316: Django raw() SQL injection — Using `Model.objects.raw(query)` with string formatting instead of parameterized queries. Severity: Critical. CWE: CWE-89.
- [ ] SC-PY-317: Django mark_safe() on user input — Marking user-controlled content as safe with `mark_safe()` or `|safe` filter disables auto-escaping. Severity: High. CWE: CWE-79.
- [ ] SC-PY-318: Django CSRF exemption overuse — Applying `@csrf_exempt` broadly instead of only on endpoints that truly need it. Severity: Medium. CWE: CWE-352.
- [ ] SC-PY-319: Django DEBUG=True in production — Running Django with `DEBUG=True` exposes detailed error pages, settings, and SQL queries. Severity: Critical. CWE: CWE-489.
- [ ] SC-PY-320: Django ALLOWED_HOSTS misconfiguration — Empty `ALLOWED_HOSTS` with `DEBUG=False` or wildcard `['*']` allowing host header injection. Severity: Medium. CWE: CWE-644.
- [ ] SC-PY-321: Django session serializer using pickle — Using `django.contrib.sessions.serializers.PickleSerializer` allows RCE via session manipulation. Severity: High. CWE: CWE-502.
- [ ] SC-PY-322: Missing Django security middleware — Not including `SecurityMiddleware`, `XFrameOptionsMiddleware`, or `CsrfViewMiddleware`. Severity: Medium. CWE: CWE-16.
- [ ] SC-PY-323: Django model field exposure via serializers — Django REST Framework serializers exposing all model fields with `fields = '__all__'`. Severity: Medium. CWE: CWE-200.
- [ ] SC-PY-324: Insecure Django file upload handling — Custom upload handlers or storage backends without proper validation or path sanitization. Severity: High. CWE: CWE-434.
- [ ] SC-PY-325: Django ORM extra() injection — Using `.extra(where=[...])` or `.extra(select={...})` with unsanitized user input. Severity: High. CWE: CWE-89.
- [ ] SC-PY-326: Missing Django password validators — Not configuring `AUTH_PASSWORD_VALIDATORS` allowing users to set trivial passwords. Severity: Medium. CWE: CWE-521.
- [ ] SC-PY-327: Django admin exposed without IP restriction — Django admin interface accessible from all IPs without IP-based access restrictions. Severity: Medium. CWE: CWE-749.
- [ ] SC-PY-328: Django clickjacking via X-Frame-Options — Missing `X_FRAME_OPTIONS = 'DENY'` or `django.middleware.clickjacking.XFrameOptionsMiddleware`. Severity: Medium. CWE: CWE-1021.
- [ ] SC-PY-329: Django mass assignment via ModelForm — `ModelForm` with `exclude` instead of explicit `fields` allowing unintended field modification. Severity: High. CWE: CWE-915.
- [ ] SC-PY-330: Django SECURE_SSL_REDIRECT disabled — Not setting `SECURE_SSL_REDIRECT = True` allows HTTP access to the application. Severity: Medium. CWE: CWE-319.
- [ ] SC-PY-331: Django SECURE_HSTS_SECONDS not set — Missing HTTP Strict Transport Security header configuration in Django settings. Severity: Medium. CWE: CWE-319.
- [ ] SC-PY-332: Django Queryset.update() without filtering — Calling `.update()` or `.delete()` on unfiltered querysets accidentally affecting all records. Severity: Medium. CWE: CWE-862.
- [ ] SC-PY-333: Django template injection via variable template names — Using user input to select template names enabling template injection attacks. Severity: High. CWE: CWE-1336.
- [ ] SC-PY-334: Django login_required missing on views — Views handling sensitive data or operations without `@login_required` decorator. Severity: High. CWE: CWE-862.
- [ ] SC-PY-335: Django REST Framework missing authentication — DRF views with `authentication_classes = []` or missing default authentication in settings. Severity: High. CWE: CWE-306.
- [ ] SC-PY-336: Django REST Framework throttling disabled — Missing rate limiting on DRF views allowing API abuse and resource exhaustion. Severity: Medium. CWE: CWE-770.
- [ ] SC-PY-337: Django SECURE_BROWSER_XSS_FILTER deprecation — Relying on deprecated browser XSS filters instead of Content-Security-Policy. Severity: Low. CWE: CWE-79.
- [ ] SC-PY-338: Django CONN_MAX_AGE misconfiguration — Persistent database connections without health checks serving stale or broken connections. Severity: Low. CWE: CWE-404.
- [ ] SC-PY-339: Django signals with security side effects — Using Django signals for security-critical actions (permission changes) that can be silently disconnected. Severity: Medium. CWE: CWE-284.
- [ ] SC-PY-340: Django JSON field SQL injection — Using `__contains` or `__has_key` lookups on JSONField with unsanitized keys in older Django versions. Severity: Medium. CWE: CWE-89.

---

### 17. Flask/FastAPI-Specific (25 items)

- [ ] SC-PY-341: Flask SSTI via Jinja2 — Rendering user input through `render_template_string()` allows server-side template injection and RCE. Severity: Critical. CWE: CWE-1336.
- [ ] SC-PY-342: Flask debug mode in production — Running Flask with `app.run(debug=True)` exposes the Werkzeug debugger with code execution capability. Severity: Critical. CWE: CWE-489.
- [ ] SC-PY-343: Flask session cookie without signing — Not setting `app.secret_key` or using a weak key allows session cookie tampering. Severity: High. CWE: CWE-565.
- [ ] SC-PY-344: Flask send_file path traversal — Using `flask.send_file()` with user-controlled paths without `safe_join()` validation. Severity: High. CWE: CWE-22.
- [ ] SC-PY-345: Flask missing CSRF protection — Flask applications without Flask-WTF or similar CSRF protection on state-changing forms. Severity: High. CWE: CWE-352.
- [ ] SC-PY-346: FastAPI missing input validation — FastAPI endpoints accepting raw `dict` or `Any` types instead of Pydantic models for validation. Severity: Medium. CWE: CWE-20.
- [ ] SC-PY-347: FastAPI dependency injection bypass — Custom FastAPI dependencies that can be bypassed by providing specific parameter combinations. Severity: High. CWE: CWE-285.
- [ ] SC-PY-348: FastAPI OAuth2 misconfiguration — Incorrectly configured OAuth2PasswordBearer or OAuth2AuthorizationCodeBearer allowing token bypass. Severity: High. CWE: CWE-287.
- [ ] SC-PY-349: Pydantic model permissive parsing — Pydantic models with `model_config = {"extra": "allow"}` accepting and storing unexpected fields. Severity: Medium. CWE: CWE-915.
- [ ] SC-PY-350: Flask blueprint missing authentication — Flask blueprints registered without `before_request` authentication hooks. Severity: High. CWE: CWE-306.
- [ ] SC-PY-351: FastAPI response model exposing internals — FastAPI endpoints without `response_model` returning entire ORM objects including sensitive fields. Severity: Medium. CWE: CWE-200.
- [ ] SC-PY-352: Flask unsafe redirect — Using `flask.redirect(request.args.get('next'))` without validating the URL is relative/trusted. Severity: Medium. CWE: CWE-601.
- [ ] SC-PY-353: FastAPI CORS misconfiguration — Setting `allow_origins=["*"]` with `allow_credentials=True` in FastAPI CORS middleware. Severity: High. CWE: CWE-942.
- [ ] SC-PY-354: Flask Werkzeug debugger PIN exposure — Werkzeug debugger PIN predictable from system information allowing unauthorized code execution. Severity: High. CWE: CWE-489.
- [ ] SC-PY-355: FastAPI WebSocket authentication — WebSocket endpoints without authentication middleware allowing unauthenticated connections. Severity: Medium. CWE: CWE-306.
- [ ] SC-PY-356: Flask session data in cookies — Flask default client-side sessions storing sensitive data visible to users (only signed, not encrypted). Severity: Medium. CWE: CWE-315.
- [ ] SC-PY-357: FastAPI missing rate limiting — FastAPI endpoints without rate limiting middleware (slowapi) allowing abuse. Severity: Medium. CWE: CWE-770.
- [ ] SC-PY-358: Flask Jinja2 autoescape disabled — Jinja2 environment configured with `autoescape=False` disabling XSS protection. Severity: High. CWE: CWE-79.
- [ ] SC-PY-359: FastAPI background task security — Background tasks running without the authentication context of the triggering request. Severity: Medium. CWE: CWE-285.
- [ ] SC-PY-360: Flask request.data parsing vulnerabilities — Accessing `request.data` or `request.json` without Content-Type validation. Severity: Low. CWE: CWE-20.
- [ ] SC-PY-361: FastAPI Pydantic validators with side effects — Pydantic validators performing database queries or external calls on untrusted input. Severity: Medium. CWE: CWE-20.
- [ ] SC-PY-362: Flask static file serving in production — Using Flask's built-in static file server in production instead of a proper web server. Severity: Low. CWE: CWE-16.
- [ ] SC-PY-363: FastAPI OpenAPI schema exposure — OpenAPI/Swagger documentation exposed in production revealing all endpoints and schemas. Severity: Low. CWE: CWE-200.
- [ ] SC-PY-364: Flask secret key from environment without default — Using `os.environ.get('SECRET_KEY', 'default')` with an insecure fallback value. Severity: High. CWE: CWE-798.
- [ ] SC-PY-365: FastAPI path operation decorator ordering — Security dependencies in wrong order allowing execution before authentication completes. Severity: Medium. CWE: CWE-285.

---

### 18. API Security (20 items)

- [ ] SC-PY-366: Missing API authentication — API endpoints accessible without any authentication mechanism. Severity: Critical. CWE: CWE-306.
- [ ] SC-PY-367: API key in URL query parameters — API keys passed as URL parameters visible in server logs, browser history, and referrer headers. Severity: Medium. CWE: CWE-598.
- [ ] SC-PY-368: Missing API rate limiting — API endpoints without rate limiting allowing resource exhaustion and brute-force attacks. Severity: Medium. CWE: CWE-770.
- [ ] SC-PY-369: Excessive API data exposure — API responses returning more data than the client needs, exposing sensitive fields. Severity: Medium. CWE: CWE-200.
- [ ] SC-PY-370: Missing API input validation — API endpoints accepting and processing requests without schema validation. Severity: Medium. CWE: CWE-20.
- [ ] SC-PY-371: Broken object-level authorization in API — API endpoints allowing access to other users' objects by changing resource IDs. Severity: High. CWE: CWE-639.
- [ ] SC-PY-372: API versioning security gaps — Older API versions maintained without security patches creating exploitable legacy endpoints. Severity: Medium. CWE: CWE-1104.
- [ ] SC-PY-373: Missing API request size limits — No maximum payload size allowing oversized requests causing memory exhaustion. Severity: Medium. CWE: CWE-770.
- [ ] SC-PY-374: GraphQL batching abuse — GraphQL supporting unlimited batch queries allowing authentication bypass or DoS. Severity: Medium. CWE: CWE-400.
- [ ] SC-PY-375: Missing API pagination limits — API list endpoints without maximum page size allowing extraction of entire datasets. Severity: Medium. CWE: CWE-770.
- [ ] SC-PY-376: API endpoint enumeration — Predictable API endpoint patterns allowing automated discovery of hidden resources. Severity: Low. CWE: CWE-200.
- [ ] SC-PY-377: Missing Content-Type validation in API — API accepting any Content-Type without validation allowing parser confusion attacks. Severity: Medium. CWE: CWE-20.
- [ ] SC-PY-378: JWT none algorithm accepted — API accepting JWTs with `"alg": "none"` effectively disabling signature verification. Severity: Critical. CWE: CWE-327.
- [ ] SC-PY-379: API response caching sensitive data — API responses with sensitive data cached by CDNs or intermediate proxies without cache-control headers. Severity: Medium. CWE: CWE-524.
- [ ] SC-PY-380: Insecure API webhook delivery — Webhook payloads sent without HMAC signatures allowing spoofed webhook requests. Severity: Medium. CWE: CWE-345.
- [ ] SC-PY-381: Missing API audit logging — API operations not logged with sufficient detail for security monitoring and incident response. Severity: Medium. CWE: CWE-778.
- [ ] SC-PY-382: GraphQL introspection in production — GraphQL introspection queries enabled in production exposing entire schema to attackers. Severity: Medium. CWE: CWE-200.
- [ ] SC-PY-383: Missing API error standardization — Inconsistent error formats leaking different levels of internal details per endpoint. Severity: Low. CWE: CWE-209.
- [ ] SC-PY-384: Unsafe API file upload — API file upload endpoints without malware scanning, type validation, or size limits. Severity: High. CWE: CWE-434.
- [ ] SC-PY-385: API mass assignment via request body — API endpoints blindly accepting and applying all fields from request body to database models. Severity: High. CWE: CWE-915.

---

### 19. Testing & CI/CD Security (15 items)

- [ ] SC-PY-386: Secrets in test fixtures — Real API keys, passwords, or tokens in test fixture files committed to version control. Severity: High. CWE: CWE-798.
- [ ] SC-PY-387: Missing security tests — No test cases for authentication, authorization, input validation, or injection vulnerabilities. Severity: Medium. CWE: CWE-1053.
- [ ] SC-PY-388: Test code in production — Test utilities, mock endpoints, or debug routes deployed to production. Severity: Medium. CWE: CWE-489.
- [ ] SC-PY-389: CI/CD pipeline secrets exposure — Secrets printed in CI/CD logs, stored in unencrypted variables, or accessible to forked repos. Severity: High. CWE: CWE-532.
- [ ] SC-PY-390: Missing SAST in CI/CD — No static application security testing (Bandit, Semgrep) integrated in the build pipeline. Severity: Medium. CWE: CWE-1053.
- [ ] SC-PY-391: Missing dependency scanning in CI/CD — No automated vulnerability scanning for Python dependencies in the build pipeline. Severity: Medium. CWE: CWE-1035.
- [ ] SC-PY-392: Insecure CI/CD artifact storage — Build artifacts stored without integrity verification or access controls. Severity: Medium. CWE: CWE-345.
- [ ] SC-PY-393: Production database access from CI/CD — CI/CD pipelines with credentials to access production databases for testing. Severity: High. CWE: CWE-250.
- [ ] SC-PY-394: Missing code review enforcement — No branch protection rules requiring security review before merge to main branches. Severity: Medium. CWE: CWE-1053.
- [ ] SC-PY-395: Unsafe test data generation — Using production data for testing without anonymization or using `random` for test security values. Severity: Medium. CWE: CWE-200.
- [ ] SC-PY-396: Missing container image scanning — Docker images not scanned for vulnerabilities before deployment. Severity: Medium. CWE: CWE-1035.
- [ ] SC-PY-397: CI/CD script injection — CI/CD pipelines that execute untrusted input from pull request titles, branch names, or commit messages. Severity: High. CWE: CWE-78.
- [ ] SC-PY-398: Missing fuzz testing — No fuzzing of input parsing, deserialization, or protocol handling code. Severity: Low. CWE: CWE-1053.
- [ ] SC-PY-399: Test bypassing security middleware — Tests that mock or bypass security middleware not catching integration issues. Severity: Medium. CWE: CWE-1053.
- [ ] SC-PY-400: Unprotected CI/CD webhook triggers — CI/CD webhooks without signature verification allowing unauthorized build triggering. Severity: Medium. CWE: CWE-345.

---

### 20. Third-Party Integration Security (15 items)

- [ ] SC-PY-401: Unvalidated third-party API responses — Trusting and processing third-party API responses without schema validation or sanitization. Severity: Medium. CWE: CWE-20.
- [ ] SC-PY-402: Third-party SDK credential exposure — Initializing third-party SDKs with credentials that get logged or sent to telemetry endpoints. Severity: High. CWE: CWE-532.
- [ ] SC-PY-403: Insecure OAuth callback handling — OAuth callback endpoints not validating state parameter or redirect URI allowing token theft. Severity: High. CWE: CWE-352.
- [ ] SC-PY-404: Missing TLS for third-party connections — Connecting to third-party services over HTTP or with disabled certificate verification. Severity: High. CWE: CWE-295.
- [ ] SC-PY-405: Third-party JavaScript inclusion — Including JavaScript from third-party CDNs without Subresource Integrity (SRI) hashes. Severity: Medium. CWE: CWE-829.
- [ ] SC-PY-406: Stripe/payment webhook signature bypass — Not verifying Stripe or payment provider webhook signatures allowing forged payment events. Severity: Critical. CWE: CWE-345.
- [ ] SC-PY-407: AWS credential misconfiguration — AWS credentials with overly broad IAM permissions or hardcoded access keys. Severity: High. CWE: CWE-250.
- [ ] SC-PY-408: Email service injection — Using user input in email templates without sanitization enabling content or header injection. Severity: Medium. CWE: CWE-93.
- [ ] SC-PY-409: Cloud storage misconfiguration — S3 buckets or GCS objects with public read/write access or overly permissive policies. Severity: High. CWE: CWE-732.
- [ ] SC-PY-410: Unencrypted third-party data storage — Storing data received from third parties without encryption, violating data processing agreements. Severity: Medium. CWE: CWE-311.
- [ ] SC-PY-411: Third-party service SSRF — Third-party integrations that accept URLs and fetch them server-side without SSRF protections. Severity: High. CWE: CWE-918.
- [ ] SC-PY-412: Missing third-party rate limit handling — Not handling HTTP 429 responses from third-party APIs leading to account lockouts or bans. Severity: Low. CWE: CWE-770.
- [ ] SC-PY-413: Celery task deserialization — Celery task messages deserialized with pickle when using insecure message serializer settings. Severity: High. CWE: CWE-502.
- [ ] SC-PY-414: Insecure message broker connection — Connecting to RabbitMQ, Redis, or Kafka without TLS or authentication. Severity: Medium. CWE: CWE-319.
- [ ] SC-PY-415: Third-party library telemetry/analytics — Third-party libraries sending application data to external telemetry services without opt-in consent. Severity: Low. CWE: CWE-359.
