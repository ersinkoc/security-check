# PHP Security Checklist

> 400+ security checks for PHP applications.
> Used by security-check sc-lang-php skill as reference.

## How to Use
This checklist is automatically referenced by the sc-lang-php skill during security scans. It can also be used manually during code review.

## Categories

---

### 1. Input Validation & Sanitization (25 items)

- [ ] SC-PHP-001: Unvalidated user input in function arguments — User-controlled data passed directly to sensitive functions (eval, system, include) without validation. Severity: Critical. CWE: CWE-20.
- [ ] SC-PHP-002: Missing input length validation — User input accepted without maximum length constraints, enabling buffer-related issues or denial of service. Severity: Medium. CWE: CWE-20.
- [ ] SC-PHP-003: Improper use of filter_var() — Using filter_var() with FILTER_SANITIZE_STRING (deprecated in PHP 8.1) or incorrect filter flags leading to incomplete sanitization. Severity: Medium. CWE: CWE-20.
- [ ] SC-PHP-004: Missing FILTER_VALIDATE_EMAIL bypass awareness — Relying solely on filter_var(FILTER_VALIDATE_EMAIL) without additional checks, as it permits payloads like `"attacker"@evil.com`. Severity: Medium. CWE: CWE-20.
- [ ] SC-PHP-005: Regex injection via user input in preg_match — User-controlled data used as part of a regex pattern without escaping via preg_quote(). Severity: High. CWE: CWE-625.
- [ ] SC-PHP-006: ReDoS via complex regex patterns — Using user-influenced regex patterns with catastrophic backtracking potential in preg_match or preg_replace. Severity: Medium. CWE: CWE-1333.
- [ ] SC-PHP-007: Missing mb_string usage for multibyte input — Using strlen/substr instead of mb_strlen/mb_substr on multibyte (UTF-8) input, allowing truncation-based bypasses. Severity: Medium. CWE: CWE-20.
- [ ] SC-PHP-008: Null byte injection in input — Failing to strip or reject null bytes (\0) in user input, which can truncate strings in older PHP versions. Severity: High. CWE: CWE-626.
- [ ] SC-PHP-009: CRLF injection in headers — User input containing \r\n passed into HTTP header functions like header() without sanitization. Severity: High. CWE: CWE-93.
- [ ] SC-PHP-010: HTML injection via unescaped output — Outputting user data in HTML context without htmlspecialchars() or equivalent encoding. Severity: High. CWE: CWE-79.
- [ ] SC-PHP-011: Reflected XSS via $_GET/$_POST — Directly echoing request parameters into HTML response without output encoding. Severity: High. CWE: CWE-79.
- [ ] SC-PHP-012: Stored XSS via database content — User input stored in database and rendered in HTML without contextual output encoding. Severity: High. CWE: CWE-79.
- [ ] SC-PHP-013: DOM-based XSS via PHP-rendered JavaScript — PHP variables interpolated into inline JavaScript blocks without proper JS encoding (json_encode with JSON_HEX_TAG). Severity: High. CWE: CWE-79.
- [ ] SC-PHP-014: XSS in HTML attribute context — User data placed in HTML attributes without attribute-specific encoding, allowing event handler injection. Severity: High. CWE: CWE-79.
- [ ] SC-PHP-015: XSS in URL context — User data placed in href or src attributes without URL encoding and scheme validation. Severity: High. CWE: CWE-79.
- [ ] SC-PHP-016: Missing Content-Type header for JSON responses — Returning JSON data with text/html Content-Type, enabling XSS via content sniffing. Severity: Medium. CWE: CWE-79.
- [ ] SC-PHP-017: Insufficient htmlspecialchars flags — Using htmlspecialchars() without ENT_QUOTES or ENT_SUBSTITUTE, leaving single-quote or malformed encoding attacks possible. Severity: Medium. CWE: CWE-79.
- [ ] SC-PHP-018: Command injection via unsanitized input — User input passed to shell_exec(), exec(), system(), passthru(), or backtick operator without escapeshellarg()/escapeshellcmd(). Severity: Critical. CWE: CWE-78.
- [ ] SC-PHP-019: Improper use of escapeshellcmd vs escapeshellarg — Using escapeshellcmd() when escapeshellarg() is required, allowing argument injection. Severity: High. CWE: CWE-78.
- [ ] SC-PHP-020: LDAP injection via unsanitized input — User input used in ldap_search() filter strings without proper escaping via ldap_escape(). Severity: High. CWE: CWE-90.
- [ ] SC-PHP-021: XPath injection via unsanitized input — User input used in DOMXPath::query() without parameterization or escaping. Severity: High. CWE: CWE-643.
- [ ] SC-PHP-022: XML injection via user-controlled data — User data embedded into XML documents without proper encoding, enabling structure manipulation. Severity: High. CWE: CWE-91.
- [ ] SC-PHP-023: Template injection in user-controlled strings — User input passed into Twig/Blade/Smarty template rendering engine as a template string rather than a variable. Severity: Critical. CWE: CWE-1336.
- [ ] SC-PHP-024: Header injection via user-controlled mail headers — User input used in additional_headers parameter of mail() without sanitization. Severity: High. CWE: CWE-93.
- [ ] SC-PHP-025: Integer overflow/truncation on 32-bit systems — Relying on PHP integer behavior without checking PHP_INT_SIZE, leading to unexpected overflow on 32-bit platforms. Severity: Medium. CWE: CWE-190.

---

### 2. Authentication & Session Management (25 items)

- [ ] SC-PHP-026: Plaintext password storage — Storing user passwords in plaintext or with reversible encryption instead of password_hash(). Severity: Critical. CWE: CWE-256.
- [ ] SC-PHP-027: Weak hashing algorithm for passwords — Using MD5, SHA1, or SHA256 for password hashing instead of bcrypt/argon2 via password_hash(). Severity: Critical. CWE: CWE-328.
- [ ] SC-PHP-028: Missing password_verify() usage — Comparing password hashes with == or strcmp() instead of password_verify(), enabling timing attacks. Severity: High. CWE: CWE-208.
- [ ] SC-PHP-029: Hardcoded password cost factor too low — Using password_hash() with a cost factor below 10 for bcrypt, making brute force feasible. Severity: Medium. CWE: CWE-916.
- [ ] SC-PHP-030: Missing password rehash check — Not using password_needs_rehash() to upgrade stored hashes when algorithm or cost parameters change. Severity: Low. CWE: CWE-916.
- [ ] SC-PHP-031: Session fixation vulnerability — Not calling session_regenerate_id(true) after successful authentication, allowing session fixation attacks. Severity: High. CWE: CWE-384.
- [ ] SC-PHP-032: Missing session.cookie_httponly — Session cookie configured without HttpOnly flag, allowing JavaScript access to session ID. Severity: Medium. CWE: CWE-1004.
- [ ] SC-PHP-033: Missing session.cookie_secure — Session cookie transmitted over HTTP when HTTPS is available, exposing session ID to network interception. Severity: Medium. CWE: CWE-614.
- [ ] SC-PHP-034: Missing session.cookie_samesite — Session cookie without SameSite attribute, enabling CSRF via cross-site requests. Severity: Medium. CWE: CWE-352.
- [ ] SC-PHP-035: Predictable session ID generation — Using custom session ID generation without sufficient entropy instead of PHP's built-in session handler. Severity: High. CWE: CWE-330.
- [ ] SC-PHP-036: Session data stored in world-readable directory — PHP session files stored in /tmp with default permissions, allowing local users to read session data. Severity: Medium. CWE: CWE-732.
- [ ] SC-PHP-037: Missing session timeout — No session expiration mechanism configured via session.gc_maxlifetime or application-level timeout. Severity: Medium. CWE: CWE-613.
- [ ] SC-PHP-038: Missing idle session timeout — No server-side check for session inactivity period, allowing indefinite session reuse. Severity: Medium. CWE: CWE-613.
- [ ] SC-PHP-039: Session ID exposed in URL — Using session.use_trans_sid or manually appending session ID to URLs, leaking session via Referer header. Severity: High. CWE: CWE-598.
- [ ] SC-PHP-040: Insecure "Remember Me" implementation — Remember-me tokens stored as simple user ID or predictable value rather than cryptographically random token. Severity: High. CWE: CWE-640.
- [ ] SC-PHP-041: Missing brute force protection on login — No rate limiting, account lockout, or CAPTCHA on authentication endpoints. Severity: High. CWE: CWE-307.
- [ ] SC-PHP-042: Username enumeration via error messages — Login form reveals whether the username or password was incorrect, enabling user enumeration. Severity: Medium. CWE: CWE-203.
- [ ] SC-PHP-043: Username enumeration via timing — Authentication process takes measurably different time for valid vs invalid usernames. Severity: Medium. CWE: CWE-208.
- [ ] SC-PHP-044: Missing multi-factor authentication for privileged accounts — Administrative accounts lack MFA enforcement. Severity: Medium. CWE: CWE-308.
- [ ] SC-PHP-045: Insecure password reset mechanism — Password reset uses predictable tokens, lacks expiration, or does not invalidate previous tokens. Severity: High. CWE: CWE-640.
- [ ] SC-PHP-046: Password reset token leakage via Referer — Password reset page contains external links that leak the reset token through HTTP Referer header. Severity: Medium. CWE: CWE-200.
- [ ] SC-PHP-047: Missing CSRF token on login form — Login form lacks CSRF protection, enabling login CSRF attacks that authenticate victims under attacker's account. Severity: Medium. CWE: CWE-352.
- [ ] SC-PHP-048: Insecure session deserialization handler — Using php or php_serialize session serialization handler inconsistently, enabling injection attacks. Severity: High. CWE: CWE-502.
- [ ] SC-PHP-049: Missing session.use_strict_mode — Session strict mode disabled, allowing server to accept uninitialized session IDs. Severity: Medium. CWE: CWE-384.
- [ ] SC-PHP-050: Concurrent session not limited — No mechanism to limit the number of active sessions per user, enabling undetected session hijacking. Severity: Low. CWE: CWE-613.

---

### 3. Authorization & Access Control (20 items)

- [ ] SC-PHP-051: Missing authorization check on sensitive endpoints — Controller actions or routes lack proper authorization verification before executing privileged operations. Severity: Critical. CWE: CWE-862.
- [ ] SC-PHP-052: Insecure Direct Object Reference (IDOR) — User-supplied IDs used to access resources without verifying the authenticated user owns or has access to the resource. Severity: High. CWE: CWE-639.
- [ ] SC-PHP-053: Horizontal privilege escalation — Users can access other users' data by manipulating request parameters without ownership checks. Severity: High. CWE: CWE-639.
- [ ] SC-PHP-054: Vertical privilege escalation — Regular users can access admin functionality due to missing role-based access control checks. Severity: Critical. CWE: CWE-269.
- [ ] SC-PHP-055: Missing function-level access control — API endpoints rely on client-side UI hiding rather than server-side authorization enforcement. Severity: High. CWE: CWE-285.
- [ ] SC-PHP-056: Path traversal in file access — User-controlled file paths not validated against directory traversal sequences (../) before file operations. Severity: High. CWE: CWE-22.
- [ ] SC-PHP-057: Forced browsing to unprotected resources — Static files or admin pages accessible by guessing URLs without authentication checks. Severity: Medium. CWE: CWE-425.
- [ ] SC-PHP-058: Missing re-authentication for critical operations — Sensitive actions (password change, email change, payment) do not require re-entering current password. Severity: Medium. CWE: CWE-306.
- [ ] SC-PHP-059: Relying on client-side role checking — Authorization decisions made in JavaScript/client-side rather than enforced server-side. Severity: High. CWE: CWE-602.
- [ ] SC-PHP-060: Mass assignment via unfiltered request data — Using $_POST or request data directly to set model attributes, allowing users to modify protected fields like is_admin. Severity: High. CWE: CWE-915.
- [ ] SC-PHP-061: Broken access control on file uploads — Uploaded files accessible without authentication, allowing unauthorized access to sensitive documents. Severity: Medium. CWE: CWE-862.
- [ ] SC-PHP-062: Missing access control on API documentation — Swagger/OpenAPI documentation exposed in production without authentication. Severity: Low. CWE: CWE-200.
- [ ] SC-PHP-063: Privilege escalation via parameter tampering — Role or permission parameters accepted from client request instead of determined server-side. Severity: Critical. CWE: CWE-269.
- [ ] SC-PHP-064: Missing CORS access control — Cross-Origin Resource Sharing configured with wildcard (*) or overly permissive origins on authenticated endpoints. Severity: Medium. CWE: CWE-346.
- [ ] SC-PHP-065: Directory listing enabled — Web server configured to display directory contents when index file is missing, exposing file structure. Severity: Medium. CWE: CWE-548.
- [ ] SC-PHP-066: Missing rate limiting on sensitive operations — No throttling on password reset, OTP verification, or other security-sensitive operations. Severity: Medium. CWE: CWE-770.
- [ ] SC-PHP-067: Insecure use of $_SERVER['PHP_AUTH_USER'] — Relying on HTTP Basic Auth without HTTPS or without proper credential validation. Severity: High. CWE: CWE-522.
- [ ] SC-PHP-068: JWT authorization bypass via algorithm none — JWT validation accepts "none" algorithm, allowing forged tokens. Severity: Critical. CWE: CWE-345.
- [ ] SC-PHP-069: JWT secret key brute-forceable — JWT signed with weak or short symmetric key that can be brute-forced offline. Severity: High. CWE: CWE-326.
- [ ] SC-PHP-070: Missing scope validation in OAuth implementation — OAuth token scopes not validated before granting access to resources. Severity: High. CWE: CWE-285.

---

### 4. Cryptography (20 items)

- [ ] SC-PHP-071: Use of deprecated mcrypt extension — Using mcrypt functions (removed in PHP 7.2) instead of openssl_encrypt or sodium functions. Severity: High. CWE: CWE-327.
- [ ] SC-PHP-072: Use of ECB mode for encryption — Using AES-ECB or other block cipher in ECB mode, which does not provide semantic security. Severity: High. CWE: CWE-327.
- [ ] SC-PHP-073: Static or predictable initialization vector — Using a fixed or zero IV for CBC/CTR/GCM encryption instead of a random IV per encryption operation. Severity: High. CWE: CWE-329.
- [ ] SC-PHP-074: Missing HMAC on ciphertext — Encrypting data without authenticated encryption (GCM/CCM) or Encrypt-then-MAC, allowing ciphertext tampering. Severity: High. CWE: CWE-353.
- [ ] SC-PHP-075: Weak random number generation — Using rand(), mt_rand(), or uniqid() for security-sensitive purposes instead of random_bytes() or random_int(). Severity: Critical. CWE: CWE-338.
- [ ] SC-PHP-076: Hardcoded encryption key — Encryption keys embedded directly in source code rather than loaded from secure configuration or key management service. Severity: Critical. CWE: CWE-321.
- [ ] SC-PHP-077: Insufficient key length — Using AES-128 or RSA keys shorter than 2048 bits where stronger key sizes are warranted. Severity: Medium. CWE: CWE-326.
- [ ] SC-PHP-078: Use of MD5 for integrity checking — Using md5() for file integrity, token generation, or HMAC where collision resistance is required. Severity: Medium. CWE: CWE-328.
- [ ] SC-PHP-079: Use of SHA1 for security purposes — Using sha1() for signatures or integrity where collision resistance is required. Severity: Medium. CWE: CWE-328.
- [ ] SC-PHP-080: Missing timing-safe comparison for secrets — Using == or strcmp() to compare HMAC digests, tokens, or API keys instead of hash_equals(). Severity: High. CWE: CWE-208.
- [ ] SC-PHP-081: Insecure key derivation — Deriving encryption keys from passwords using MD5/SHA instead of PBKDF2, bcrypt, or Argon2. Severity: High. CWE: CWE-916.
- [ ] SC-PHP-082: Deprecated openssl_seal usage — Using openssl_seal() with default RC4 cipher instead of specifying a modern cipher. Severity: Medium. CWE: CWE-327.
- [ ] SC-PHP-083: Missing certificate validation in SSL context — Setting verify_peer to false or verify_peer_name to false in stream context options for HTTPS. Severity: High. CWE: CWE-295.
- [ ] SC-PHP-084: Insecure TLS version — Allowing TLS 1.0 or 1.1 in stream_context_create crypto_method option. Severity: Medium. CWE: CWE-326.
- [ ] SC-PHP-085: Predictable token generation — Generating password reset tokens, CSRF tokens, or API keys using time-based or sequential values. Severity: High. CWE: CWE-330.
- [ ] SC-PHP-086: Missing sodium_memzero for sensitive data — Not clearing sensitive cryptographic material from memory after use when using libsodium. Severity: Low. CWE: CWE-244.
- [ ] SC-PHP-087: Improper RSA padding scheme — Using RSA with PKCS1v1.5 padding for encryption instead of OAEP, vulnerable to padding oracle attacks. Severity: Medium. CWE: CWE-780.
- [ ] SC-PHP-088: Reuse of nonce in authenticated encryption — Reusing nonce/IV values with the same key in AES-GCM or sodium_crypto_secretbox, breaking confidentiality. Severity: Critical. CWE: CWE-323.
- [ ] SC-PHP-089: Insecure random seed — Calling mt_srand() or srand() with predictable seed values, making subsequent random output predictable. Severity: High. CWE: CWE-335.
- [ ] SC-PHP-090: Encryption key logged or exposed in error — Encryption keys appearing in log files, error messages, or debug output. Severity: Critical. CWE: CWE-532.

---

### 5. Error Handling & Logging (20 items)

- [ ] SC-PHP-091: display_errors enabled in production — PHP configured with display_errors=On in production, leaking internal paths, database details, and stack traces to users. Severity: High. CWE: CWE-209.
- [ ] SC-PHP-092: Detailed error messages exposed to users — Exception messages containing SQL queries, file paths, or stack traces returned in HTTP responses. Severity: Medium. CWE: CWE-209.
- [ ] SC-PHP-093: Missing custom error handler — No set_error_handler() or set_exception_handler() configured, relying on default PHP error display. Severity: Medium. CWE: CWE-209.
- [ ] SC-PHP-094: Sensitive data in error logs — Passwords, tokens, credit card numbers, or PII written to application logs via error messages. Severity: High. CWE: CWE-532.
- [ ] SC-PHP-095: Missing error logging — Errors silenced with @ operator or caught exceptions discarded without logging, hiding security incidents. Severity: Medium. CWE: CWE-390.
- [ ] SC-PHP-096: Excessive use of error suppression operator — Widespread use of @ operator masking errors that could indicate security issues or data corruption. Severity: Medium. CWE: CWE-390.
- [ ] SC-PHP-097: Log injection via user input — User-controlled data written to logs without sanitization, allowing log forgery or log injection attacks. Severity: Medium. CWE: CWE-117.
- [ ] SC-PHP-098: Missing log integrity protection — Log files stored without write protection or integrity verification, allowing attacker tampering. Severity: Medium. CWE: CWE-117.
- [ ] SC-PHP-099: Insufficient security event logging — Authentication failures, authorization violations, and input validation failures not logged for security monitoring. Severity: Medium. CWE: CWE-778.
- [ ] SC-PHP-100: Log files accessible via web — Log files stored in web-accessible directory without access restrictions. Severity: High. CWE: CWE-532.
- [ ] SC-PHP-101: phpinfo() accessible in production — phpinfo() page exposed in production revealing PHP configuration, extensions, environment variables, and server details. Severity: High. CWE: CWE-200.
- [ ] SC-PHP-102: Stack trace in API error responses — API endpoints returning full stack traces in JSON/XML error responses. Severity: Medium. CWE: CWE-209.
- [ ] SC-PHP-103: Database connection errors leaking credentials — Database connection failure messages containing hostname, username, or connection string details. Severity: High. CWE: CWE-209.
- [ ] SC-PHP-104: Missing rate limiting on error-triggering endpoints — Endpoints that trigger errors not rate-limited, enabling information gathering via error messages. Severity: Low. CWE: CWE-770.
- [ ] SC-PHP-105: Error-based information disclosure via type juggling — Different error responses for different input types revealing internal logic or data existence. Severity: Medium. CWE: CWE-203.
- [ ] SC-PHP-106: Unhandled exception causing information disclosure — Uncaught exceptions in production displaying framework-specific debug pages (Whoops, Symfony Debug). Severity: High. CWE: CWE-209.
- [ ] SC-PHP-107: Log files without rotation or size limits — Unrestricted log growth enabling disk exhaustion denial of service. Severity: Low. CWE: CWE-400.
- [ ] SC-PHP-108: Debug mode enabled in production — Framework debug mode (APP_DEBUG=true, Xdebug) active in production environment. Severity: High. CWE: CWE-489.
- [ ] SC-PHP-109: Missing centralized exception handling — Inconsistent error handling across the application with some paths leaking details and others not. Severity: Medium. CWE: CWE-755.
- [ ] SC-PHP-110: Exposing internal IP addresses in error responses — Error messages or headers revealing internal network topology through IP addresses or hostnames. Severity: Low. CWE: CWE-200.

---

### 6. Data Protection & Privacy (20 items)

- [ ] SC-PHP-111: Sensitive data stored in plain text — PII, financial data, or health records stored unencrypted in database. Severity: High. CWE: CWE-312.
- [ ] SC-PHP-112: Sensitive data in URL parameters — Passwords, tokens, or PII passed as GET parameters, logged in server access logs and browser history. Severity: High. CWE: CWE-598.
- [ ] SC-PHP-113: Missing encryption for data in transit — Sensitive data transmitted over HTTP instead of HTTPS between services or to clients. Severity: High. CWE: CWE-319.
- [ ] SC-PHP-114: Sensitive data in cookies without encryption — PII or access tokens stored in cookies without encryption, readable by client-side scripts. Severity: Medium. CWE: CWE-315.
- [ ] SC-PHP-115: Cache headers exposing sensitive data — Responses containing sensitive data without Cache-Control: no-store, cached by proxies or browsers. Severity: Medium. CWE: CWE-524.
- [ ] SC-PHP-116: Autocomplete enabled on sensitive fields — HTML forms with sensitive fields (credit card, SSN) missing autocomplete="off" attribute. Severity: Low. CWE: CWE-524.
- [ ] SC-PHP-117: Missing data masking in logs — Full credit card numbers, SSNs, or passwords appearing in application logs instead of masked versions. Severity: High. CWE: CWE-532.
- [ ] SC-PHP-118: Backup files accessible via web — Database dumps, .sql files, or .bak files stored in web-accessible directories. Severity: High. CWE: CWE-530.
- [ ] SC-PHP-119: Session data containing excessive PII — Storing unnecessary sensitive data in session variables, increasing impact of session hijacking. Severity: Medium. CWE: CWE-312.
- [ ] SC-PHP-120: Missing data retention policy enforcement — Sensitive data retained indefinitely without automatic deletion per data retention policies. Severity: Medium. CWE: CWE-463.
- [ ] SC-PHP-121: Sensitive data in browser localStorage — Storing tokens, PII, or sensitive data in localStorage via PHP-rendered JavaScript, accessible to XSS. Severity: Medium. CWE: CWE-922.
- [ ] SC-PHP-122: Missing Referrer-Policy header — Sensitive URLs leaked through Referer header to third-party sites without Referrer-Policy: no-referrer. Severity: Low. CWE: CWE-200.
- [ ] SC-PHP-123: Sensitive data in error messages to users — Validation errors revealing database field names, internal IDs, or data patterns. Severity: Medium. CWE: CWE-209.
- [ ] SC-PHP-124: Hard-coded PII or test data in source code — Real customer data, email addresses, or phone numbers embedded in source code or test fixtures. Severity: Medium. CWE: CWE-540.
- [ ] SC-PHP-125: Missing field-level encryption for highly sensitive data — Data requiring field-level encryption (SSN, health data) stored with only database-level or disk-level encryption. Severity: Medium. CWE: CWE-311.
- [ ] SC-PHP-126: Export functionality lacking access control — Data export features (CSV, PDF) not enforcing same authorization as UI views, enabling bulk data exfiltration. Severity: High. CWE: CWE-862.
- [ ] SC-PHP-127: Sensitive data in HTTP response headers — Custom headers or Server header leaking internal software versions, paths, or environment details. Severity: Low. CWE: CWE-200.
- [ ] SC-PHP-128: Missing secure deletion of sensitive temporary files — Temporary files containing sensitive data not securely deleted after processing. Severity: Medium. CWE: CWE-459.
- [ ] SC-PHP-129: Sensitive data in version control — Credentials, keys, or PII committed to git repository in current or historical commits. Severity: High. CWE: CWE-540.
- [ ] SC-PHP-130: Cross-user data leakage via shared caching — Application cache (APCu, Memcached, Redis) returning cached data belonging to a different user due to improper cache key design. Severity: High. CWE: CWE-200.

---

### 7. SQL/NoSQL/ORM Security (25 items)

- [ ] SC-PHP-131: SQL injection via string concatenation — User input concatenated directly into SQL query strings instead of using parameterized queries. Severity: Critical. CWE: CWE-89.
- [ ] SC-PHP-132: SQL injection in ORDER BY clause — User-controlled column names or sort directions interpolated into ORDER BY without whitelist validation. Severity: High. CWE: CWE-89.
- [ ] SC-PHP-133: SQL injection in LIMIT/OFFSET — User-controlled values used in LIMIT/OFFSET clauses without integer casting or parameterization. Severity: Medium. CWE: CWE-89.
- [ ] SC-PHP-134: SQL injection in table or column names — Dynamic table/column names from user input inserted into queries without whitelist validation (identifiers cannot be parameterized). Severity: High. CWE: CWE-89.
- [ ] SC-PHP-135: SQL injection via LIKE pattern — User input used in LIKE clauses without escaping % and _ wildcard characters. Severity: Medium. CWE: CWE-89.
- [ ] SC-PHP-136: Second-order SQL injection — Data stored in database from one input used unsafely in a subsequent query without re-parameterization. Severity: High. CWE: CWE-89.
- [ ] SC-PHP-137: PDO emulated prepared statements — Using PDO with ATTR_EMULATE_PREPARES=true (default), which does not fully protect against multi-byte charset SQL injection. Severity: Medium. CWE: CWE-89.
- [ ] SC-PHP-138: Missing PDO error mode configuration — PDO not configured with ERRMODE_EXCEPTION, silently failing on SQL errors and hiding injection attempts. Severity: Medium. CWE: CWE-89.
- [ ] SC-PHP-139: MySQLi without prepared statements — Using mysqli_query() with concatenated user input instead of mysqli_prepare() with bound parameters. Severity: Critical. CWE: CWE-89.
- [ ] SC-PHP-140: Stacked queries enabling multi-statement injection — Database connection allowing multi-statement execution (mysqli_multi_query), amplifying SQL injection impact. Severity: High. CWE: CWE-89.
- [ ] SC-PHP-141: ORM raw query injection — Using raw/unsanitized expressions in Eloquent (DB::raw(), whereRaw()), Doctrine (createQuery with DQL concatenation), or other ORMs. Severity: High. CWE: CWE-89.
- [ ] SC-PHP-142: NoSQL injection in MongoDB queries — User input used in MongoDB query operators ($where, $gt, $regex) without type validation, enabling NoSQL injection. Severity: High. CWE: CWE-943.
- [ ] SC-PHP-143: NoSQL injection via JSON/array manipulation — User-supplied arrays passed directly to MongoDB find/update operations, allowing operator injection. Severity: High. CWE: CWE-943.
- [ ] SC-PHP-144: Excessive database privileges — Application database user granted unnecessary privileges (DROP, GRANT, FILE) beyond SELECT/INSERT/UPDATE/DELETE. Severity: Medium. CWE: CWE-250.
- [ ] SC-PHP-145: Database credentials in connection string — Database username and password hardcoded in PHP source files rather than environment variables. Severity: High. CWE: CWE-798.
- [ ] SC-PHP-146: Missing query timeout — No statement_timeout or max_execution_time for database queries, enabling DoS via slow query injection. Severity: Medium. CWE: CWE-400.
- [ ] SC-PHP-147: Blind SQL injection via boolean responses — Application behavior differs based on SQL query truth value, enabling blind SQL injection data extraction. Severity: High. CWE: CWE-89.
- [ ] SC-PHP-148: Time-based blind SQL injection — Application vulnerable to SLEEP() or BENCHMARK()-based timing attacks for data extraction. Severity: High. CWE: CWE-89.
- [ ] SC-PHP-149: SQL injection in stored procedure calls — User input passed to stored procedure parameters without proper parameterization. Severity: High. CWE: CWE-89.
- [ ] SC-PHP-150: Schema information disclosure via SQL errors — SQL error messages revealing table names, column names, and database structure. Severity: Medium. CWE: CWE-209.
- [ ] SC-PHP-151: Charset mismatch SQL injection — Database connection charset not matching application charset, enabling multi-byte escape sequence attacks. Severity: High. CWE: CWE-89.
- [ ] SC-PHP-152: Redis injection via unsanitized input — User input passed to Redis commands without validation, enabling command injection in Redis protocol. Severity: High. CWE: CWE-943.
- [ ] SC-PHP-153: Memcached injection via unsanitized keys — User-controlled cache keys containing \r\n enabling Memcached protocol injection. Severity: Medium. CWE: CWE-93.
- [ ] SC-PHP-154: ORM mass assignment in query builder — Passing unfiltered user input arrays to ORM create/update methods, allowing modification of protected fields. Severity: High. CWE: CWE-915.
- [ ] SC-PHP-155: Unsafe use of PDO::quote() instead of prepared statements — Relying on PDO::quote() for escaping instead of proper parameterized queries. Severity: Medium. CWE: CWE-89.

---

### 8. File Operations (25 items)

- [ ] SC-PHP-156: Local file inclusion (LFI) — User-controlled input in include/require/include_once/require_once allowing arbitrary local file inclusion. Severity: Critical. CWE: CWE-98.
- [ ] SC-PHP-157: Remote file inclusion (RFI) — User-controlled input in include() with allow_url_include enabled, allowing remote code execution. Severity: Critical. CWE: CWE-98.
- [ ] SC-PHP-158: Path traversal in file read — User-controlled filename passed to file_get_contents(), fopen(), or readfile() without path validation. Severity: High. CWE: CWE-22.
- [ ] SC-PHP-159: Path traversal in file write — User-controlled path used in file_put_contents() or fwrite() allowing arbitrary file overwrite. Severity: Critical. CWE: CWE-22.
- [ ] SC-PHP-160: Unrestricted file upload type — File upload validation relying on client-provided Content-Type or file extension without server-side content inspection. Severity: High. CWE: CWE-434.
- [ ] SC-PHP-161: Uploaded file executed as PHP — Uploaded files stored in web-accessible directory with .php extension or in location where PHP handler processes them. Severity: Critical. CWE: CWE-434.
- [ ] SC-PHP-162: Double extension bypass in upload — Upload filter checking only last extension, allowing files like shell.php.jpg to be executed by misconfigured servers. Severity: High. CWE: CWE-434.
- [ ] SC-PHP-163: Null byte in filename — Filename containing null byte (%00) used to truncate extension checks in older PHP versions (pre-5.3.4). Severity: High. CWE: CWE-626.
- [ ] SC-PHP-164: PHAR deserialization via file operations — User-controlled input with phar:// wrapper in file operations (file_exists, file_get_contents, is_dir) triggering deserialization. Severity: Critical. CWE: CWE-502.
- [ ] SC-PHP-165: Zip slip vulnerability — Extracting ZIP/archive files without validating entry paths, allowing files to be written outside target directory. Severity: High. CWE: CWE-22.
- [ ] SC-PHP-166: Symlink race condition — TOCTOU vulnerability where file is checked and then accessed, with symlink substitution between check and use. Severity: Medium. CWE: CWE-367.
- [ ] SC-PHP-167: Insecure temporary file creation — Using tempnam() or tmpfile() in predictable location without exclusive creation, enabling symlink attacks. Severity: Medium. CWE: CWE-377.
- [ ] SC-PHP-168: File upload size not limited — Missing MAX_FILE_SIZE, upload_max_filesize, or application-level file size validation, enabling DoS. Severity: Medium. CWE: CWE-400.
- [ ] SC-PHP-169: Uploaded file stored with original filename — Using user-provided filename for storage without renaming, enabling directory traversal or name collision attacks. Severity: High. CWE: CWE-22.
- [ ] SC-PHP-170: Missing antivirus scan on uploads — File uploads not scanned for malware before storage or processing. Severity: Medium. CWE: CWE-434.
- [ ] SC-PHP-171: SVG upload allowing XSS — SVG files uploaded and served with image/svg+xml content type, executing embedded JavaScript. Severity: Medium. CWE: CWE-79.
- [ ] SC-PHP-172: Image processing library vulnerabilities — User-uploaded images processed by GD or ImageMagick without size/dimension limits, enabling memory exhaustion or known CVE exploitation. Severity: Medium. CWE: CWE-400.
- [ ] SC-PHP-173: PHP wrapper exploitation via file functions — User input used in file functions allowing php://input, php://filter, data://, or expect:// wrappers. Severity: High. CWE: CWE-73.
- [ ] SC-PHP-174: Log file poisoning for LFI — Injecting PHP code into log files and then including them via LFI vulnerability. Severity: High. CWE: CWE-94.
- [ ] SC-PHP-175: Insecure file permissions on created files — Files created with overly permissive permissions (0777) using chmod() or umask(). Severity: Medium. CWE: CWE-732.
- [ ] SC-PHP-176: XML External Entity (XXE) via file parsing — XML file uploads parsed with external entity processing enabled (libxml_disable_entity_loader not called in PHP < 8.0, or LIBXML_NOENT flag used). Severity: High. CWE: CWE-611.
- [ ] SC-PHP-177: CSV injection in exported files — User data included in CSV exports without sanitizing formula-triggering characters (=, +, -, @). Severity: Medium. CWE: CWE-1236.
- [ ] SC-PHP-178: File metadata leakage — Uploaded files served without stripping EXIF data containing GPS coordinates, device info, or other metadata. Severity: Low. CWE: CWE-200.
- [ ] SC-PHP-179: Race condition in file upload validation — File validated then moved in separate steps, allowing replacement between check and use. Severity: Medium. CWE: CWE-367.
- [ ] SC-PHP-180: Unrestricted file deletion — User-controlled path passed to unlink() without authorization and path validation. Severity: High. CWE: CWE-22.

---

### 9. Network & HTTP Security (20 items)

- [ ] SC-PHP-181: SSRF via file_get_contents — User-controlled URLs passed to file_get_contents(), cURL, or Guzzle allowing access to internal services (169.254.169.254, localhost). Severity: High. CWE: CWE-918.
- [ ] SC-PHP-182: SSRF via DNS rebinding — SSRF protection checking IP at resolution time but connecting after DNS TTL change points to internal address. Severity: High. CWE: CWE-918.
- [ ] SC-PHP-183: Missing HTTPS enforcement — Application accessible over HTTP without redirect to HTTPS or HSTS header. Severity: Medium. CWE: CWE-319.
- [ ] SC-PHP-184: Missing Strict-Transport-Security header — HSTS header not set, allowing SSL stripping attacks on first visit. Severity: Medium. CWE: CWE-319.
- [ ] SC-PHP-185: Missing Content-Security-Policy header — No CSP header configured, allowing inline scripts and external resource loading for XSS exploitation. Severity: Medium. CWE: CWE-693.
- [ ] SC-PHP-186: Missing X-Content-Type-Options header — X-Content-Type-Options: nosniff not set, allowing MIME type sniffing attacks. Severity: Low. CWE: CWE-693.
- [ ] SC-PHP-187: Missing X-Frame-Options header — No X-Frame-Options or frame-ancestors CSP directive, enabling clickjacking attacks. Severity: Medium. CWE: CWE-1021.
- [ ] SC-PHP-188: Open redirect vulnerability — User-controlled input used in header('Location: ...') redirect without validating the destination domain. Severity: Medium. CWE: CWE-601.
- [ ] SC-PHP-189: CSRF protection missing — State-changing operations (POST, PUT, DELETE) lacking CSRF token validation. Severity: High. CWE: CWE-352.
- [ ] SC-PHP-190: CORS misconfiguration reflecting Origin — Access-Control-Allow-Origin dynamically set to the value of Origin header without whitelist validation. Severity: High. CWE: CWE-346.
- [ ] SC-PHP-191: Missing Permissions-Policy header — No Permissions-Policy header restricting access to browser features (camera, microphone, geolocation). Severity: Low. CWE: CWE-693.
- [ ] SC-PHP-192: HTTP request smuggling — Inconsistent handling of Transfer-Encoding and Content-Length headers between PHP and reverse proxy. Severity: High. CWE: CWE-444.
- [ ] SC-PHP-193: Host header injection — Application using $_SERVER['HTTP_HOST'] without validation for generating URLs or routing decisions. Severity: Medium. CWE: CWE-644.
- [ ] SC-PHP-194: Unvalidated webhook callbacks — Incoming webhook payloads processed without signature verification, allowing spoofed events. Severity: High. CWE: CWE-345.
- [ ] SC-PHP-195: DNS lookup for access control bypass — IP-based access control using gethostbyname() on user-supplied hostname, vulnerable to DNS rebinding. Severity: Medium. CWE: CWE-350.
- [ ] SC-PHP-196: Missing rate limiting on public endpoints — No request rate limiting on registration, contact forms, or public API endpoints, enabling abuse. Severity: Medium. CWE: CWE-770.
- [ ] SC-PHP-197: Insecure cookie domain scope — Cookies set with overly broad domain scope, accessible by sibling subdomains. Severity: Medium. CWE: CWE-1275.
- [ ] SC-PHP-198: Server version disclosure — Server header or X-Powered-By header revealing PHP version and web server version. Severity: Low. CWE: CWE-200.
- [ ] SC-PHP-199: Missing subresource integrity for CDN assets — External JavaScript/CSS loaded from CDNs without SRI hash attributes, enabling supply-chain attacks. Severity: Medium. CWE: CWE-353.
- [ ] SC-PHP-200: HTTP method override abuse — Accepting X-HTTP-Method-Override header without restriction, allowing GET requests to perform state-changing operations. Severity: Medium. CWE: CWE-436.

---

### 10. Serialization & Deserialization (25 items)

- [ ] SC-PHP-201: Unsafe unserialize on user input — Using unserialize() on data controlled by users without allowed_classes restriction. Severity: Critical. CWE: CWE-502.
- [ ] SC-PHP-202: POP chain exploitation via unserialize — Deserialization triggering Property-Oriented Programming chains through __wakeup, __destruct, or __toString magic methods. Severity: Critical. CWE: CWE-502.
- [ ] SC-PHP-203: Missing allowed_classes in unserialize — Using unserialize() without the second parameter ['allowed_classes' => false] or a specific whitelist. Severity: High. CWE: CWE-502.
- [ ] SC-PHP-204: PHAR deserialization attack — Crafted PHAR archive triggering object deserialization when processed by file functions with phar:// wrapper. Severity: Critical. CWE: CWE-502.
- [ ] SC-PHP-205: PHAR polyglot file upload — Uploading a file that is simultaneously valid as PHAR and another format (JPEG, TAR), bypassing upload filters. Severity: High. CWE: CWE-502.
- [ ] SC-PHP-206: Insecure JSON deserialization to objects — Using json_decode() with assoc=false creating stdClass objects used unsafely in type-sensitive operations. Severity: Medium. CWE: CWE-502.
- [ ] SC-PHP-207: Unsafe YAML parsing — Using yaml_parse() or Symfony YAML component with object deserialization enabled (!!php/object tag). Severity: Critical. CWE: CWE-502.
- [ ] SC-PHP-208: Serialized data in cookies — Storing serialized PHP objects in cookies, allowing client-side tampering and deserialization attacks. Severity: High. CWE: CWE-502.
- [ ] SC-PHP-209: Serialized data in database without integrity check — Storing serialized objects in database without MAC/signature, allowing modification via SQL injection. Severity: Medium. CWE: CWE-502.
- [ ] SC-PHP-210: Session handler using PHP serialization — Session data serialized with PHP serialize handler vulnerable to injection when mixed with php_serialize handler. Severity: High. CWE: CWE-502.
- [ ] SC-PHP-211: XML deserialization leading to object injection — Using SimpleXML or DOMDocument to parse XML that influences object instantiation. Severity: Medium. CWE: CWE-502.
- [ ] SC-PHP-212: Gadget chain in common libraries — Vulnerable POP gadget chains present in installed libraries (Guzzle, Monolog, Doctrine, Swift Mailer). Severity: High. CWE: CWE-502.
- [ ] SC-PHP-213: Insecure igbinary_unserialize — Using igbinary_unserialize() on untrusted data, which can trigger arbitrary object instantiation. Severity: High. CWE: CWE-502.
- [ ] SC-PHP-214: MessagePack deserialization of untrusted data — Using msgpack_unpack() on user-controlled data without validation. Severity: Medium. CWE: CWE-502.
- [ ] SC-PHP-215: Unsafe var_export/include pattern — Using var_export() to generate PHP files that are later included, enabling code injection via crafted values. Severity: High. CWE: CWE-94.
- [ ] SC-PHP-216: Wddx deserialization (pre-7.4) — Using wddx_deserialize() on untrusted data in PHP versions before 7.4 where the extension was removed. Severity: High. CWE: CWE-502.
- [ ] SC-PHP-217: Unserialize in cache backends — Cache implementations using unserialize() on cached data that could be tampered with via cache poisoning. Severity: High. CWE: CWE-502.
- [ ] SC-PHP-218: Serialized data in hidden form fields — Passing serialized PHP data through hidden HTML form fields, allowing client modification. Severity: High. CWE: CWE-502.
- [ ] SC-PHP-219: __wakeup bypass (CVE-2016-7124) — PHP versions before 5.6.25/7.0.10 where __wakeup() can be bypassed by manipulating object property count. Severity: High. CWE: CWE-502.
- [ ] SC-PHP-220: Deserialization of objects from external APIs — Deserializing PHP-serialized data received from external services without validation or allowed_classes. Severity: High. CWE: CWE-502.
- [ ] SC-PHP-221: Unsafe XML-RPC deserialization — Using PHP XML-RPC extension (removed in PHP 8.0) which internally deserializes to PHP objects. Severity: Medium. CWE: CWE-502.
- [ ] SC-PHP-222: Custom unserialize handler without validation — Implementing Serializable interface with unserialize() method that doesn't validate input data. Severity: Medium. CWE: CWE-502.
- [ ] SC-PHP-223: JSON-LD processing with object injection — Processing JSON-LD data that maps to PHP objects without type validation. Severity: Medium. CWE: CWE-502.
- [ ] SC-PHP-224: Protocol buffer deserialization without schema validation — Deserializing protobuf messages without strict schema validation, allowing unexpected field types. Severity: Medium. CWE: CWE-502.
- [ ] SC-PHP-225: Serialization format confusion attacks — Application accepting multiple serialization formats (JSON, XML, PHP serialize) without enforcing a single format, enabling parser differential attacks. Severity: Medium. CWE: CWE-436.

---

### 11. Concurrency & Race Conditions (10 items)

- [ ] SC-PHP-226: TOCTOU race in file operations — Checking file existence/permissions and then operating on the file in separate steps, allowing race condition exploitation. Severity: Medium. CWE: CWE-367.
- [ ] SC-PHP-227: Race condition in coupon/voucher redemption — Coupon or voucher validation and redemption not atomic, allowing multiple uses via concurrent requests. Severity: High. CWE: CWE-362.
- [ ] SC-PHP-228: Race condition in balance/inventory update — Financial balance or inventory count read and updated non-atomically, allowing double-spend via concurrent requests. Severity: High. CWE: CWE-362.
- [ ] SC-PHP-229: Race condition in user registration — Unique constraint checks performed at application level rather than database level, allowing duplicate accounts. Severity: Medium. CWE: CWE-362.
- [ ] SC-PHP-230: Missing file locking for concurrent writes — Multiple processes writing to the same file without flock(), causing data corruption or race conditions. Severity: Medium. CWE: CWE-362.
- [ ] SC-PHP-231: Session race condition — Concurrent requests modifying the same session data without proper locking, causing session data corruption. Severity: Medium. CWE: CWE-362.
- [ ] SC-PHP-232: Race condition in token generation — Token uniqueness check and generation not atomic, potentially issuing duplicate tokens under load. Severity: Medium. CWE: CWE-362.
- [ ] SC-PHP-233: Database transaction isolation level insufficient — Using READ UNCOMMITTED isolation level for security-sensitive operations, allowing dirty reads. Severity: Medium. CWE: CWE-362.
- [ ] SC-PHP-234: Rate limit bypass via race condition — Rate limiting implementation vulnerable to concurrent requests arriving before counter is incremented. Severity: Medium. CWE: CWE-362.
- [ ] SC-PHP-235: Atomic operation missing in cache-based locks — Using non-atomic read-then-write cache operations for distributed locking, allowing concurrent execution. Severity: Medium. CWE: CWE-362.

---

### 12. Dependency & Supply Chain (20 items)

- [ ] SC-PHP-236: Known vulnerable Composer dependencies — Composer packages with known CVEs not updated, identifiable via composer audit or Roave Security Advisories. Severity: High. CWE: CWE-1035.
- [ ] SC-PHP-237: Unpinned Composer dependency versions — Using wildcard (*) or overly broad version constraints in composer.json allowing unexpected major updates. Severity: Medium. CWE: CWE-1035.
- [ ] SC-PHP-238: Missing composer.lock in version control — composer.lock not committed to repository, leading to inconsistent dependency versions across environments. Severity: Medium. CWE: CWE-1035.
- [ ] SC-PHP-239: Composer scripts executing arbitrary code — Post-install or post-update Composer scripts running untrusted code from dependencies. Severity: High. CWE: CWE-829.
- [ ] SC-PHP-240: Typosquatting in Composer packages — Dependencies with names similar to popular packages that could be malicious typosquats. Severity: High. CWE: CWE-829.
- [ ] SC-PHP-241: Abandoned Composer packages — Using packages that are no longer maintained and may contain unpatched vulnerabilities. Severity: Medium. CWE: CWE-1104.
- [ ] SC-PHP-242: Dev dependencies in production — Development-only packages (debug bars, test tools) deployed to production via composer install without --no-dev. Severity: Medium. CWE: CWE-489.
- [ ] SC-PHP-243: Unverified package integrity — Not using Composer's hash verification or missing composer.lock integrity checks in CI/CD. Severity: Medium. CWE: CWE-353.
- [ ] SC-PHP-244: Private Packagist misconfiguration — Private Packagist or Satis repository accessible without authentication, leaking proprietary packages. Severity: Medium. CWE: CWE-306.
- [ ] SC-PHP-245: Composer plugins with elevated privileges — Composer plugins running with full system access during install/update operations. Severity: Medium. CWE: CWE-250.
- [ ] SC-PHP-246: Outdated PHP runtime version — Running PHP version that is past end-of-life and no longer receiving security patches. Severity: High. CWE: CWE-1104.
- [ ] SC-PHP-247: Vulnerable PHP extensions — Using PHP extensions (e.g., libxml, openssl, curl) with known vulnerabilities due to outdated system libraries. Severity: High. CWE: CWE-1035.
- [ ] SC-PHP-248: Dependency confusion attack — Package manager resolving internal package names from public Packagist instead of private repository. Severity: High. CWE: CWE-427.
- [ ] SC-PHP-249: Missing automated dependency scanning — No automated tool (Dependabot, Snyk, composer audit) configured for continuous dependency vulnerability monitoring. Severity: Medium. CWE: CWE-1035.
- [ ] SC-PHP-250: Forked dependencies without upstream tracking — Using forked packages that diverge from upstream and miss security patches. Severity: Medium. CWE: CWE-1104.
- [ ] SC-PHP-251: Composer allow-plugins not restricted — Composer 2.2+ allow-plugins configuration not set, allowing any plugin to execute. Severity: Medium. CWE: CWE-829.
- [ ] SC-PHP-252: PEAR/PECL package risks — Using PEAR or PECL packages without verifying package signatures or author identity. Severity: Medium. CWE: CWE-829.
- [ ] SC-PHP-253: Vendored dependencies not updated — Manually vendored (copied) libraries not tracked for updates, falling behind on security patches. Severity: Medium. CWE: CWE-1104.
- [ ] SC-PHP-254: JavaScript dependencies in PHP projects — npm/yarn dependencies in PHP project (for frontend assets) with known vulnerabilities not audited. Severity: Medium. CWE: CWE-1035.
- [ ] SC-PHP-255: Untrusted Composer repository source — Composer configured to use HTTP (non-HTTPS) repository sources, allowing man-in-the-middle package substitution. Severity: High. CWE: CWE-829.

---

### 13. Configuration & Secrets Management (20 items)

- [ ] SC-PHP-256: Hardcoded credentials in source code — Database passwords, API keys, or secrets directly embedded in PHP files. Severity: Critical. CWE: CWE-798.
- [ ] SC-PHP-257: .env file accessible via web — Environment file containing secrets accessible through web server (e.g., https://example.com/.env). Severity: Critical. CWE: CWE-200.
- [ ] SC-PHP-258: .env file committed to version control — Environment file with production secrets committed to git repository. Severity: Critical. CWE: CWE-540.
- [ ] SC-PHP-259: allow_url_fopen enabled unnecessarily — PHP directive allow_url_fopen=On when not required, increasing attack surface for SSRF. Severity: Medium. CWE: CWE-16.
- [ ] SC-PHP-260: allow_url_include enabled — PHP directive allow_url_include=On enabling remote file inclusion attacks via include/require. Severity: Critical. CWE: CWE-16.
- [ ] SC-PHP-261: register_globals legacy risk — Application designed for register_globals behavior, creating variable injection risks even if directive is removed in modern PHP. Severity: High. CWE: CWE-621.
- [ ] SC-PHP-262: open_basedir not configured — Missing open_basedir restriction, allowing PHP scripts to access files anywhere on the filesystem. Severity: Medium. CWE: CWE-16.
- [ ] SC-PHP-263: disable_functions not configured — Dangerous functions (exec, system, passthru, shell_exec, proc_open, popen) not disabled in php.ini. Severity: Medium. CWE: CWE-16.
- [ ] SC-PHP-264: expose_php enabled — PHP version exposed via X-Powered-By header due to expose_php=On in php.ini. Severity: Low. CWE: CWE-200.
- [ ] SC-PHP-265: Default session save path — Session files stored in default /tmp directory shared with other applications. Severity: Medium. CWE: CWE-732.
- [ ] SC-PHP-266: Unsafe file upload directory configuration — Upload directory inside web root without .htaccess or nginx rules to prevent PHP execution. Severity: High. CWE: CWE-434.
- [ ] SC-PHP-267: Missing security headers in web server config — Web server (Apache/Nginx) configuration lacking security headers that PHP application doesn't set. Severity: Medium. CWE: CWE-693.
- [ ] SC-PHP-268: PHP-FPM misconfiguration — PHP-FPM pool running as root or with overly permissive socket/TCP permissions. Severity: High. CWE: CWE-250.
- [ ] SC-PHP-269: OPcache exposed — OPcache status page or opcache_get_status() output accessible to unauthorized users, revealing code structure. Severity: Medium. CWE: CWE-200.
- [ ] SC-PHP-270: Xdebug enabled in production — Xdebug extension active in production environment, enabling remote debugging and code execution. Severity: Critical. CWE: CWE-489.
- [ ] SC-PHP-271: Default database credentials — Using default credentials (root with no password) for database connections in production. Severity: Critical. CWE: CWE-798.
- [ ] SC-PHP-272: Missing environment-specific configuration — Single configuration file used across all environments without environment-specific overrides for security settings. Severity: Medium. CWE: CWE-16.
- [ ] SC-PHP-273: Secrets in php.ini comments — API keys or passwords noted in php.ini comments, readable by anyone with config access. Severity: Medium. CWE: CWE-615.
- [ ] SC-PHP-274: Mail server credentials exposed — SMTP credentials hardcoded in application code or accessible configuration file. Severity: High. CWE: CWE-798.
- [ ] SC-PHP-275: Missing Content-Security-Policy for admin panels — Administrative interfaces lacking CSP headers, increasing XSS impact on privileged sessions. Severity: Medium. CWE: CWE-693.

---

### 14. Type Safety & Comparison (20 items)

- [ ] SC-PHP-276: Loose comparison type juggling — Using == instead of === for security-critical comparisons, allowing type juggling bypasses (e.g., "0e123" == "0e456" evaluates to true). Severity: High. CWE: CWE-843.
- [ ] SC-PHP-277: strcmp() bypass with array input — Using strcmp() for password/token comparison where passing an array returns null/0, bypassing checks with loose comparison. Severity: High. CWE: CWE-843.
- [ ] SC-PHP-278: in_array() without strict mode — Using in_array() without third parameter strict=true, allowing type coercion matches (in_array("0", ["abc"]) returns true in some contexts). Severity: Medium. CWE: CWE-843.
- [ ] SC-PHP-279: array_search() without strict mode — Using array_search() without strict parameter, returning incorrect matches due to type coercion. Severity: Medium. CWE: CWE-843.
- [ ] SC-PHP-280: switch statement loose comparison — Using switch/case for security decisions where PHP uses loose comparison, allowing type juggling bypasses. Severity: Medium. CWE: CWE-843.
- [ ] SC-PHP-281: Loose comparison with null — Security checks comparing against null with == where empty string, 0, and false all match. Severity: Medium. CWE: CWE-843.
- [ ] SC-PHP-282: JSON decoded integer vs string comparison — json_decode() returning integers for numeric strings, causing unexpected == comparisons with string values. Severity: Medium. CWE: CWE-843.
- [ ] SC-PHP-283: is_numeric() permitting hex and scientific notation — Using is_numeric() for validation where hex (0x...) or scientific notation (0e...) values pass but are undesirable. Severity: Medium. CWE: CWE-843.
- [ ] SC-PHP-284: intval() parsing inconsistency — Using intval() which stops at first non-numeric character, allowing trailing injection (intval("123 OR 1=1") returns 123). Severity: Medium. CWE: CWE-704.
- [ ] SC-PHP-285: Boolean type coercion in conditions — Non-obvious PHP boolean coercion rules causing security-relevant conditions to evaluate incorrectly (e.g., "0" is falsy). Severity: Medium. CWE: CWE-843.
- [ ] SC-PHP-286: Numeric string comparison as numbers — PHP comparing numeric strings as numbers with == ("0e123" == "0"), potentially bypassing hash comparisons. Severity: High. CWE: CWE-843.
- [ ] SC-PHP-287: PHP 8 stricter comparison changes — Code relying on PHP 7 loose comparison behavior (0 == "foo" was true) breaking security assumptions in PHP 8 (now false). Severity: Medium. CWE: CWE-843.
- [ ] SC-PHP-288: isset() vs array_key_exists() — Using isset() which returns false for null values, potentially skipping validation for explicitly null values. Severity: Low. CWE: CWE-843.
- [ ] SC-PHP-289: empty() overly broad truthiness — Using empty() for security checks where 0, "0", empty string, null, and empty array all evaluate as empty. Severity: Medium. CWE: CWE-843.
- [ ] SC-PHP-290: Floating point comparison for financial values — Using float equality comparison for monetary calculations, leading to rounding errors that could be exploited. Severity: Medium. CWE: CWE-682.
- [ ] SC-PHP-291: Mixed type function return values — Functions returning false on error and a valid value on success, where loose comparison conflates the two. Severity: Medium. CWE: CWE-843.
- [ ] SC-PHP-292: Implicit integer to string conversion in hashing — Hash values starting with "0e" followed by digits being treated as zero in numeric context. Severity: High. CWE: CWE-843.
- [ ] SC-PHP-293: Spaceship operator misuse in security context — Using <=> operator for security comparisons where timing-safe comparison is required. Severity: Low. CWE: CWE-208.
- [ ] SC-PHP-294: Null coalescing operator masking missing checks — Using ?? operator that treats null and undefined the same, potentially masking missing array keys in security checks. Severity: Low. CWE: CWE-843.
- [ ] SC-PHP-295: Match expression fallthrough — In PHP 8 match expressions, missing default case causing UnhandledMatchError instead of proper security response. Severity: Low. CWE: CWE-478.

---

### 15. PHP-Specific Patterns (25 items)

- [ ] SC-PHP-296: eval() with user input — Using eval() to execute strings containing user-controlled data, enabling arbitrary code execution. Severity: Critical. CWE: CWE-95.
- [ ] SC-PHP-297: preg_replace with /e modifier — Using deprecated /e modifier in preg_replace() (removed in PHP 7) that evaluates replacement string as PHP code. Severity: Critical. CWE: CWE-95.
- [ ] SC-PHP-298: assert() with string argument — Using assert() with a string argument (deprecated in PHP 7.2), which evaluates the string as PHP code. Severity: Critical. CWE: CWE-95.
- [ ] SC-PHP-299: Dynamic function calls via variable — Using $variable() or call_user_func() with user-controlled function names, enabling arbitrary function execution. Severity: Critical. CWE: CWE-95.
- [ ] SC-PHP-300: extract() on user input — Using extract() on $_GET, $_POST, $_REQUEST, or other user-controlled arrays, enabling variable overwrite attacks. Severity: High. CWE: CWE-621.
- [ ] SC-PHP-301: parse_str() without second parameter — Using parse_str($string) without specifying result array, creating variables in current scope (PHP 7 behavior, error in PHP 8). Severity: High. CWE: CWE-621.
- [ ] SC-PHP-302: Variable variables ($$var) with user input — Using variable variables where the variable name is user-controlled, enabling arbitrary variable access/modification. Severity: High. CWE: CWE-621.
- [ ] SC-PHP-303: create_function() usage — Using deprecated create_function() (removed in PHP 8) which internally uses eval(). Severity: High. CWE: CWE-95.
- [ ] SC-PHP-304: Unsafe use of compact() with user input — Using compact() with user-controlled variable names, potentially leaking sensitive variables. Severity: Medium. CWE: CWE-200.
- [ ] SC-PHP-305: PHP object injection via __construct parameters — Classes with dangerous __construct parameters that can be exploited when instantiated with user-controlled arguments. Severity: High. CWE: CWE-502.
- [ ] SC-PHP-306: Magic method abuse (__toString, __call, __get) — Magic methods performing dangerous operations (file access, SQL queries, command execution) that can be triggered via deserialization chains. Severity: High. CWE: CWE-502.
- [ ] SC-PHP-307: Dangerous destructor side effects — __destruct() methods performing file deletion, database operations, or other dangerous actions triggered during garbage collection. Severity: Medium. CWE: CWE-502.
- [ ] SC-PHP-308: Information disclosure via Reflection API — Using ReflectionClass/ReflectionMethod on user-specified class names, revealing internal code structure. Severity: Medium. CWE: CWE-200.
- [ ] SC-PHP-309: Autoloader exploitation — Custom autoloader that includes files based on user-controlled class names, enabling arbitrary file inclusion. Severity: High. CWE: CWE-98.
- [ ] SC-PHP-310: Insecure use of list()/array destructuring — Using list() or [] destructuring with user-controlled array keys, allowing unexpected variable assignment. Severity: Low. CWE: CWE-20.
- [ ] SC-PHP-311: Output buffering security issues — Using ob_start() with callback that processes user content unsafely, or buffer contents leaked on error. Severity: Medium. CWE: CWE-200.
- [ ] SC-PHP-312: Glob pattern injection — User-controlled patterns passed to glob() function, potentially listing sensitive files outside intended directory. Severity: Medium. CWE: CWE-22.
- [ ] SC-PHP-313: Unsafe backtick operator usage — Using backtick operator (`command`) which executes shell commands, equivalent to shell_exec(). Severity: High. CWE: CWE-78.
- [ ] SC-PHP-314: php://input read without content type validation — Reading php://input without verifying Content-Type, potentially processing unexpected data formats. Severity: Medium. CWE: CWE-20.
- [ ] SC-PHP-315: Generator information leakage — Generator functions yielding sensitive data that remains accessible through generator object after partial iteration. Severity: Low. CWE: CWE-200.
- [ ] SC-PHP-316: Fibers (PHP 8.1) exception handling — Fiber execution not properly handling exceptions, potentially leaving shared state in inconsistent condition. Severity: Low. CWE: CWE-755.
- [ ] SC-PHP-317: Enum serialization issues in PHP 8.1 — Relying on enum case serialization across different PHP versions or application boundaries without validation. Severity: Low. CWE: CWE-502.
- [ ] SC-PHP-318: Named arguments enabling parameter injection — PHP 8 named arguments allowing external input to target specific function parameters by name. Severity: Medium. CWE: CWE-88.
- [ ] SC-PHP-319: Readonly property bypass in PHP 8.1+ — Attempting to modify readonly properties via reflection or deserialization, or relying on readonly for security invariants that can be bypassed. Severity: Low. CWE: CWE-471.
- [ ] SC-PHP-320: Unsafe usage of php://filter — User input influencing php://filter specification, allowing base64 encoding/decoding of arbitrary files for LFI exploitation. Severity: High. CWE: CWE-73.

---

### 16. Laravel-Specific (25 items)

- [ ] SC-PHP-321: Laravel debug mode in production — APP_DEBUG=true in production .env, exposing Ignition error pages with full stack traces and environment variables. Severity: Critical. CWE: CWE-209.
- [ ] SC-PHP-322: Mass assignment vulnerability — Model lacking $fillable or $guarded properties, allowing users to set any model attribute via request input. Severity: High. CWE: CWE-915.
- [ ] SC-PHP-323: Unescaped Blade output — Using {!! !!} syntax with user-controlled data instead of {{ }} which auto-escapes HTML. Severity: High. CWE: CWE-79.
- [ ] SC-PHP-324: SQL injection in Eloquent raw methods — Using DB::raw(), whereRaw(), selectRaw(), orderByRaw() with unsanitized user input. Severity: High. CWE: CWE-89.
- [ ] SC-PHP-325: Missing CSRF token verification — Routes handling state changes not protected by VerifyCsrfToken middleware or using incorrect exemptions. Severity: High. CWE: CWE-352.
- [ ] SC-PHP-326: Overly broad CSRF exclusion — Too many routes added to VerifyCsrfToken $except array, reducing CSRF protection coverage. Severity: Medium. CWE: CWE-352.
- [ ] SC-PHP-327: Laravel APP_KEY exposure — Application key exposed in logs, error pages, or version control, compromising all encrypted data and signed cookies. Severity: Critical. CWE: CWE-321.
- [ ] SC-PHP-328: Insecure default APP_KEY — Using default or weak APP_KEY, making encryption and cookie signing predictable. Severity: Critical. CWE: CWE-321.
- [ ] SC-PHP-329: Authorization policy bypass — Missing or incorrectly implemented Gate/Policy checks, allowing unauthorized access to resources. Severity: High. CWE: CWE-862.
- [ ] SC-PHP-330: Route model binding without authorization — Using implicit route model binding without additional authorization checks, enabling IDOR. Severity: High. CWE: CWE-639.
- [ ] SC-PHP-331: Middleware ordering issues — Security middleware applied in wrong order, allowing requests to bypass authentication or authorization. Severity: High. CWE: CWE-862.
- [ ] SC-PHP-332: Exposed storage links — Storage symbolic links exposing private files without access control checks. Severity: Medium. CWE: CWE-200.
- [ ] SC-PHP-333: Insecure queue serialization — Laravel queue jobs using PHP serialization vulnerable to deserialization attacks if queue backend is compromised. Severity: Medium. CWE: CWE-502.
- [ ] SC-PHP-334: Broadcast channel authorization missing — Laravel Echo broadcast channels without proper authorization callbacks, leaking real-time data. Severity: Medium. CWE: CWE-862.
- [ ] SC-PHP-335: Exposed Telescope or Horizon in production — Laravel Telescope/Horizon dashboards accessible without authentication in production. Severity: High. CWE: CWE-200.
- [ ] SC-PHP-336: Validation bypass via array input — Laravel validation rules not accounting for array input where string rules are expected, enabling bypass. Severity: Medium. CWE: CWE-20.
- [ ] SC-PHP-337: File upload validation bypass — Using mimes rule which checks extension only, not actual file content; missing mimetypes rule. Severity: Medium. CWE: CWE-434.
- [ ] SC-PHP-338: Insecure signed URL implementation — Signed URLs with overly long or missing expiration, allowing indefinite access to protected resources. Severity: Medium. CWE: CWE-613.
- [ ] SC-PHP-339: Laravel Sanctum misconfiguration — SPA authentication with incorrect CORS or session domain configuration, enabling token theft. Severity: High. CWE: CWE-346.
- [ ] SC-PHP-340: Unsafe use of Request::merge() — Merging user input into request without validation, potentially injecting unexpected parameters. Severity: Medium. CWE: CWE-20.
- [ ] SC-PHP-341: Eloquent query scope bypass — Global scopes (soft deletes, tenant isolation) bypassed via withoutGlobalScope() in user-accessible code paths. Severity: High. CWE: CWE-862.
- [ ] SC-PHP-342: Event listener information leakage — Event broadcasts transmitting more model data than intended due to missing $hidden or toArray() overrides. Severity: Medium. CWE: CWE-200.
- [ ] SC-PHP-343: Artisan command injection — Artisan commands accepting user input and passing it to shell operations without sanitization. Severity: High. CWE: CWE-78.
- [ ] SC-PHP-344: Task scheduling without output protection — Scheduled task output written to publicly accessible log files. Severity: Low. CWE: CWE-532.
- [ ] SC-PHP-345: Laravel Ignition RCE (CVE-2021-3129) — Unpatched Ignition package allowing remote code execution via debug mode file operations. Severity: Critical. CWE: CWE-94.

---

### 17. WordPress-Specific (25 items)

- [ ] SC-PHP-346: Missing nonce verification — WordPress form handlers not calling wp_verify_nonce() or check_admin_referer(), enabling CSRF. Severity: High. CWE: CWE-352.
- [ ] SC-PHP-347: Direct file access without ABSPATH check — Plugin/theme PHP files executable directly without checking defined('ABSPATH'). Severity: Medium. CWE: CWE-284.
- [ ] SC-PHP-348: SQL injection via $wpdb without prepare — Using $wpdb->query() or $wpdb->get_results() with string concatenation instead of $wpdb->prepare(). Severity: Critical. CWE: CWE-89.
- [ ] SC-PHP-349: XSS via unescaped output — Using echo instead of esc_html(), esc_attr(), esc_url(), or wp_kses() for user-controlled output. Severity: High. CWE: CWE-79.
- [ ] SC-PHP-350: Missing capability check — WordPress actions/handlers not verifying current_user_can() before executing privileged operations. Severity: High. CWE: CWE-862.
- [ ] SC-PHP-351: Insecure use of update_option/add_option — Storing sensitive data with WordPress options API without encryption, readable via SQL or export. Severity: Medium. CWE: CWE-312.
- [ ] SC-PHP-352: File upload vulnerability in media handler — Custom upload handlers not using wp_check_filetype_and_ext() for proper file type validation. Severity: High. CWE: CWE-434.
- [ ] SC-PHP-353: REST API endpoint without permission callback — Custom REST API routes registered without permission_callback, defaulting to public access. Severity: High. CWE: CWE-862.
- [ ] SC-PHP-354: AJAX handler without authentication — wp_ajax_nopriv_ handlers performing sensitive operations without additional authentication checks. Severity: High. CWE: CWE-306.
- [ ] SC-PHP-355: User enumeration via REST API — WordPress REST API /wp-json/wp/v2/users endpoint exposing usernames without authentication. Severity: Medium. CWE: CWE-200.
- [ ] SC-PHP-356: XML-RPC enabled and exposed — XML-RPC endpoint (xmlrpc.php) enabled, allowing brute force amplification and pingback attacks. Severity: Medium. CWE: CWE-16.
- [ ] SC-PHP-357: Outdated WordPress core — Running WordPress version with known security vulnerabilities, missing security patches. Severity: High. CWE: CWE-1104.
- [ ] SC-PHP-358: Vulnerable or abandoned plugins — Using plugins with known vulnerabilities or that are no longer maintained. Severity: High. CWE: CWE-1104.
- [ ] SC-PHP-359: Theme file editor enabled — WordPress file editor (Appearance > Editor) enabled, allowing PHP code modification via admin panel. Severity: Medium. CWE: CWE-94.
- [ ] SC-PHP-360: Missing DISALLOW_FILE_EDIT constant — wp-config.php lacking define('DISALLOW_FILE_EDIT', true) to prevent admin panel code editing. Severity: Medium. CWE: CWE-94.
- [ ] SC-PHP-361: Weak WordPress salts and keys — Default or weak AUTH_KEY, SECURE_AUTH_KEY, LOGGED_IN_KEY, NONCE_KEY values in wp-config.php. Severity: High. CWE: CWE-330.
- [ ] SC-PHP-362: WordPress debug logging in production — WP_DEBUG_LOG=true in production, writing debug information to /wp-content/debug.log. Severity: Medium. CWE: CWE-532.
- [ ] SC-PHP-363: Directory listing in wp-content — Web server allowing directory listing of wp-content/uploads or wp-content/plugins. Severity: Medium. CWE: CWE-548.
- [ ] SC-PHP-364: Unsafe use of $_REQUEST in WordPress — Using $_REQUEST which combines GET, POST, and COOKIE data, potentially allowing parameter override from unexpected sources. Severity: Medium. CWE: CWE-20.
- [ ] SC-PHP-365: Object injection in WordPress metadata — Unserialize() called on post/user metadata containing user-controlled serialized data. Severity: High. CWE: CWE-502.
- [ ] SC-PHP-366: Missing sanitize_callback in register_setting — WordPress settings registered without sanitize_callback, storing unsanitized user input in options. Severity: Medium. CWE: CWE-20.
- [ ] SC-PHP-367: Insecure WordPress cron implementation — wp-cron.php accessible publicly and triggerable by external requests without verification. Severity: Low. CWE: CWE-16.
- [ ] SC-PHP-368: Database table prefix disclosure — Using default 'wp_' table prefix, making SQL injection exploitation easier with predictable table names. Severity: Low. CWE: CWE-200.
- [ ] SC-PHP-369: Multisite privilege escalation — WordPress multisite installation allowing users to escalate privileges across sites via shared cookie domain. Severity: High. CWE: CWE-269.
- [ ] SC-PHP-370: Shortcode attribute injection — WordPress shortcode attributes not escaped when output, enabling XSS via crafted shortcode parameters. Severity: Medium. CWE: CWE-79.

---

### 18. API Security (15 items)

- [ ] SC-PHP-371: Missing API authentication — API endpoints accessible without any authentication mechanism (API key, OAuth, JWT). Severity: Critical. CWE: CWE-306.
- [ ] SC-PHP-372: API key transmitted in URL — API keys passed as query parameters instead of headers, logged in server access logs. Severity: Medium. CWE: CWE-598.
- [ ] SC-PHP-373: Missing API rate limiting — No throttling on API endpoints, enabling brute force, enumeration, and DoS attacks. Severity: Medium. CWE: CWE-770.
- [ ] SC-PHP-374: API response over-exposure — API returning more fields than necessary (full user objects including hashed passwords, internal IDs). Severity: Medium. CWE: CWE-200.
- [ ] SC-PHP-375: GraphQL introspection in production — GraphQL schema introspection enabled in production, revealing entire API schema to attackers. Severity: Medium. CWE: CWE-200.
- [ ] SC-PHP-376: GraphQL query depth/complexity not limited — No limits on query depth or complexity, enabling denial of service via deeply nested queries. Severity: Medium. CWE: CWE-400.
- [ ] SC-PHP-377: Missing request body size limit — API not enforcing maximum request body size, enabling memory exhaustion attacks with large payloads. Severity: Medium. CWE: CWE-400.
- [ ] SC-PHP-378: Insecure API versioning — Old API versions with known vulnerabilities still accessible alongside newer patched versions. Severity: Medium. CWE: CWE-1104.
- [ ] SC-PHP-379: JWT algorithm confusion attack — JWT library accepting both symmetric (HS256) and asymmetric (RS256) algorithms, allowing public key to be used as HMAC secret. Severity: Critical. CWE: CWE-327.
- [ ] SC-PHP-380: Missing JWT expiration validation — JWT tokens accepted without checking exp claim, allowing indefinite token reuse. Severity: High. CWE: CWE-613.
- [ ] SC-PHP-381: JWT token stored insecurely on client — API documentation recommending localStorage for JWT storage, accessible to XSS attacks. Severity: Medium. CWE: CWE-922.
- [ ] SC-PHP-382: Broken Object Level Authorization in REST API — REST API endpoints not checking if authenticated user owns the requested resource. Severity: High. CWE: CWE-639.
- [ ] SC-PHP-383: Missing input validation on API parameters — API accepting and processing parameters without type/format/range validation. Severity: Medium. CWE: CWE-20.
- [ ] SC-PHP-384: API error responses leaking internal details — API error responses containing stack traces, SQL queries, or internal service names. Severity: Medium. CWE: CWE-209.
- [ ] SC-PHP-385: Batch API endpoint abuse — Batch/bulk API endpoints without per-request authorization checks, enabling authorization bypass at scale. Severity: High. CWE: CWE-862.

---

### 19. Testing & CI/CD Security (10 items)

- [ ] SC-PHP-386: Test credentials in production code — Test usernames, passwords, or API keys present in production source code or configuration. Severity: High. CWE: CWE-798.
- [ ] SC-PHP-387: Missing security testing in CI/CD — No automated security scanning (SAST, DAST, dependency audit) in continuous integration pipeline. Severity: Medium. CWE: CWE-1053.
- [ ] SC-PHP-388: PHPUnit exposed in production — PHPUnit or other test frameworks deployed to production, accessible via web (e.g., CVE-2017-9841 phpunit eval-stdin.php). Severity: Critical. CWE: CWE-489.
- [ ] SC-PHP-389: CI/CD secrets in logs — CI/CD pipeline printing environment variables or secrets in build logs. Severity: High. CWE: CWE-532.
- [ ] SC-PHP-390: Insecure CI/CD artifact storage — Build artifacts containing secrets stored without access control in CI/CD system. Severity: Medium. CWE: CWE-312.
- [ ] SC-PHP-391: Missing container image scanning — Docker images used for PHP deployment not scanned for vulnerabilities. Severity: Medium. CWE: CWE-1035.
- [ ] SC-PHP-392: Test database with production data — Test environments using copies of production data without anonymization. Severity: High. CWE: CWE-200.
- [ ] SC-PHP-393: Deployment scripts with hardcoded credentials — Deployment automation scripts containing hardcoded server credentials or API keys. Severity: High. CWE: CWE-798.
- [ ] SC-PHP-394: Missing integrity check on deployment artifacts — Deployed PHP code not verified for integrity (checksums, signatures) before execution. Severity: Medium. CWE: CWE-353.
- [ ] SC-PHP-395: CI/CD pipeline vulnerable to injection — CI/CD workflow files using untrusted input (PR titles, branch names) in shell commands without sanitization. Severity: High. CWE: CWE-78.

---

### 20. Third-Party Integration Security (10 items)

- [ ] SC-PHP-396: OAuth state parameter missing — OAuth authentication flow not using state parameter to prevent CSRF attacks. Severity: High. CWE: CWE-352.
- [ ] SC-PHP-397: Payment integration amount tampering — Payment amount sent from client-side rather than calculated server-side, enabling price manipulation. Severity: Critical. CWE: CWE-20.
- [ ] SC-PHP-398: Webhook signature validation missing — Incoming webhooks from payment providers (Stripe, PayPal) processed without verifying cryptographic signatures. Severity: High. CWE: CWE-345.
- [ ] SC-PHP-399: Third-party SDK with excessive permissions — SDK requiring overly broad OAuth scopes or file system access beyond what the integration needs. Severity: Medium. CWE: CWE-250.
- [ ] SC-PHP-400: SMTP injection via mail function — User input in email headers or body enabling injection of additional recipients or SMTP commands via mail() or PHPMailer. Severity: High. CWE: CWE-93.
- [ ] SC-PHP-401: OAuth redirect URI validation bypass — OAuth implementation accepting open redirect URIs or subdomain matching that can be bypassed. Severity: High. CWE: CWE-601.
- [ ] SC-PHP-402: Payment callback race condition — Payment success callback processing order/fulfillment before payment is fully confirmed, enabling fraud. Severity: High. CWE: CWE-362.
- [ ] SC-PHP-403: Third-party API key rotation not supported — Integration with third-party services using static API keys without rotation mechanism or key management. Severity: Medium. CWE: CWE-320.
- [ ] SC-PHP-404: Insecure SSO implementation — Single Sign-On integration not validating SAML assertions properly or accepting unsigned responses. Severity: High. CWE: CWE-345.
- [ ] SC-PHP-405: External service credential leakage in logs — API keys or tokens for third-party services (AWS, Stripe, Twilio) appearing in application or error logs. Severity: High. CWE: CWE-532.

---

## Summary

| # | Category | Count |
|---|----------|-------|
| 1 | Input Validation & Sanitization | 25 |
| 2 | Authentication & Session Management | 25 |
| 3 | Authorization & Access Control | 20 |
| 4 | Cryptography | 20 |
| 5 | Error Handling & Logging | 20 |
| 6 | Data Protection & Privacy | 20 |
| 7 | SQL/NoSQL/ORM Security | 25 |
| 8 | File Operations | 25 |
| 9 | Network & HTTP Security | 20 |
| 10 | Serialization & Deserialization | 25 |
| 11 | Concurrency & Race Conditions | 10 |
| 12 | Dependency & Supply Chain | 20 |
| 13 | Configuration & Secrets Management | 20 |
| 14 | Type Safety & Comparison | 20 |
| 15 | PHP-Specific Patterns | 25 |
| 16 | Laravel-Specific | 25 |
| 17 | WordPress-Specific | 25 |
| 18 | API Security | 15 |
| 19 | Testing & CI/CD Security | 10 |
| 20 | Third-Party Integration Security | 10 |
| | **Total** | **405** |
