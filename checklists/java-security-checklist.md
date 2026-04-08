# Java/Kotlin Security Checklist

> 400+ security checks for Java and Kotlin applications.
> Used by security-check sc-lang-java skill as reference.

## How to Use
This checklist is automatically referenced by the sc-lang-java skill during security scans. It can also be used manually during code review.

## Categories

### 1. Input Validation & Sanitization (25 items)

- [ ] SC-JAVA-001: Missing input length validation — User-supplied strings are not checked for maximum length before processing, enabling buffer-related DoS or overflow attacks. Severity: High. CWE: CWE-20.
- [ ] SC-JAVA-002: Unvalidated redirect URL — User-controlled input is used in HTTP redirects without validation against an allowlist of trusted destinations. Severity: High. CWE: CWE-601.
- [ ] SC-JAVA-003: Regex denial of service (ReDoS) — User input is matched against a complex regular expression with catastrophic backtracking potential. Severity: Medium. CWE: CWE-1333.
- [ ] SC-JAVA-004: Missing null-byte injection check — Input containing null bytes (%00) is passed to file or native operations without sanitization. Severity: High. CWE: CWE-626.
- [ ] SC-JAVA-005: Unvalidated email address format — Email addresses from user input are used without RFC 5322 format validation, enabling header injection. Severity: Medium. CWE: CWE-20.
- [ ] SC-JAVA-006: CRLF injection in HTTP headers — User input containing CR/LF characters is inserted into HTTP response headers without stripping. Severity: High. CWE: CWE-113.
- [ ] SC-JAVA-007: HTML injection via unescaped output — User-supplied data is rendered in HTML responses without entity encoding. Severity: High. CWE: CWE-79.
- [ ] SC-JAVA-008: Missing content-type validation on uploads — File uploads are accepted without validating the MIME type against an allowlist. Severity: Medium. CWE: CWE-434.
- [ ] SC-JAVA-009: Integer overflow from untrusted input — Numeric input from users is parsed and used in arithmetic without overflow checking. Severity: Medium. CWE: CWE-190.
- [ ] SC-JAVA-010: Unicode normalization bypass — Input is validated before Unicode normalization, allowing attackers to bypass filters with equivalent characters. Severity: Medium. CWE: CWE-176.
- [ ] SC-JAVA-011: Server-side request forgery via user URL — A user-supplied URL is fetched server-side without restricting the scheme, host, or port. Severity: Critical. CWE: CWE-918.
- [ ] SC-JAVA-012: XPath injection — User input is concatenated into XPath queries without parameterization or escaping. Severity: High. CWE: CWE-643.
- [ ] SC-JAVA-013: LDAP injection — User input is embedded in LDAP search filters without proper escaping of special characters. Severity: High. CWE: CWE-90.
- [ ] SC-JAVA-014: Log injection via unsanitized input — User-controllable data is written to logs without stripping newline and control characters. Severity: Medium. CWE: CWE-117.
- [ ] SC-JAVA-015: Template injection (SSTI) — User input is embedded directly into a server-side template engine expression without sandboxing. Severity: Critical. CWE: CWE-1336.
- [ ] SC-JAVA-016: Expression Language injection — User input is evaluated as an EL expression in a JSP or JSF context. Severity: Critical. CWE: CWE-917.
- [ ] SC-JAVA-017: Missing allowlist for file extensions — Uploaded file extensions are validated using a denylist rather than a strict allowlist. Severity: Medium. CWE: CWE-434.
- [ ] SC-JAVA-018: Unvalidated JSON schema — Incoming JSON payloads are deserialized without schema validation, allowing unexpected fields or types. Severity: Medium. CWE: CWE-20.
- [ ] SC-JAVA-019: HTTP parameter pollution — Multiple values for the same parameter are accepted without disambiguation, allowing filter bypasses. Severity: Medium. CWE: CWE-235.
- [ ] SC-JAVA-020: Missing hostname validation in URLs — URLs are parsed and fetched without verifying the hostname against an allowlist, enabling SSRF. Severity: High. CWE: CWE-918.
- [ ] SC-JAVA-021: XML injection in SOAP messages — User input is interpolated into SOAP XML bodies without escaping, altering message structure. Severity: High. CWE: CWE-91.
- [ ] SC-JAVA-022: Command argument injection — User input is passed as arguments to OS commands without proper escaping or allowlisting. Severity: Critical. CWE: CWE-88.
- [ ] SC-JAVA-023: Path traversal via filename — User-supplied filenames containing ../ sequences are used to construct file paths. Severity: High. CWE: CWE-22.
- [ ] SC-JAVA-024: Unvalidated array index — An index from user input is used to access an array without bounds checking. Severity: Medium. CWE: CWE-129.
- [ ] SC-JAVA-025: Double encoding bypass — Input validation is performed on single-decoded input, but the value is decoded again downstream, enabling filter bypass. Severity: Medium. CWE: CWE-174.

### 2. Authentication & Session Management (25 items)

- [ ] SC-JAVA-026: Hardcoded credentials in source — Passwords, API keys, or tokens are embedded directly in Java/Kotlin source files. Severity: Critical. CWE: CWE-798.
- [ ] SC-JAVA-027: Plaintext password storage — User passwords are stored in a database without hashing or with a weak hash like MD5/SHA-1. Severity: Critical. CWE: CWE-256.
- [ ] SC-JAVA-028: Missing bcrypt/scrypt/argon2 for passwords — Password hashing uses a non-adaptive algorithm instead of bcrypt, scrypt, or Argon2. Severity: High. CWE: CWE-916.
- [ ] SC-JAVA-029: Session fixation vulnerability — The session ID is not regenerated after successful authentication, enabling session fixation attacks. Severity: High. CWE: CWE-384.
- [ ] SC-JAVA-030: Missing session timeout — HTTP sessions do not have an idle or absolute timeout configured. Severity: Medium. CWE: CWE-613.
- [ ] SC-JAVA-031: Session ID in URL — The session identifier is transmitted in URL query parameters rather than in a cookie. Severity: High. CWE: CWE-384.
- [ ] SC-JAVA-032: Missing Secure flag on session cookie — The session cookie is set without the Secure flag, allowing transmission over unencrypted HTTP. Severity: Medium. CWE: CWE-614.
- [ ] SC-JAVA-033: Missing HttpOnly flag on session cookie — The session cookie lacks the HttpOnly flag, making it accessible to client-side JavaScript. Severity: Medium. CWE: CWE-1004.
- [ ] SC-JAVA-034: Missing SameSite attribute on session cookie — The session cookie lacks a SameSite attribute, increasing susceptibility to CSRF attacks. Severity: Medium. CWE: CWE-1275.
- [ ] SC-JAVA-035: Weak session ID generation — Session identifiers are generated using predictable algorithms such as java.util.Random. Severity: High. CWE: CWE-330.
- [ ] SC-JAVA-036: Missing brute-force protection on login — The authentication endpoint lacks rate limiting or account lockout after repeated failures. Severity: High. CWE: CWE-307.
- [ ] SC-JAVA-037: Credential exposure in logs — Usernames, passwords, or tokens are written to application log files. Severity: High. CWE: CWE-532.
- [ ] SC-JAVA-038: Missing multi-factor authentication — Critical operations or admin accounts do not enforce multi-factor authentication. Severity: Medium. CWE: CWE-308.
- [ ] SC-JAVA-039: Insecure password reset flow — The password reset mechanism uses predictable tokens or does not expire reset links. Severity: High. CWE: CWE-640.
- [ ] SC-JAVA-040: Username enumeration via error messages — Login error messages differentiate between invalid usernames and invalid passwords. Severity: Medium. CWE: CWE-203.
- [ ] SC-JAVA-041: JWT secret in source code — The JWT signing secret or private key is hardcoded in the application source. Severity: Critical. CWE: CWE-798.
- [ ] SC-JAVA-042: JWT none algorithm accepted — The JWT validation logic does not reject tokens signed with the "none" algorithm. Severity: Critical. CWE: CWE-327.
- [ ] SC-JAVA-043: JWT algorithm confusion — The JWT verification allows switching between symmetric and asymmetric algorithms, enabling key confusion attacks. Severity: Critical. CWE: CWE-327.
- [ ] SC-JAVA-044: Missing JWT expiration validation — JWT tokens are accepted without verifying the exp claim, allowing use of expired tokens. Severity: High. CWE: CWE-613.
- [ ] SC-JAVA-045: Missing JWT issuer/audience validation — JWT tokens are accepted without verifying iss and aud claims. Severity: Medium. CWE: CWE-287.
- [ ] SC-JAVA-046: OAuth2 state parameter missing — The OAuth2 authorization flow does not validate the state parameter, enabling CSRF. Severity: High. CWE: CWE-352.
- [ ] SC-JAVA-047: Insecure remember-me implementation — The remember-me token is a predictable value or is not tied to a specific user session. Severity: High. CWE: CWE-640.
- [ ] SC-JAVA-048: Missing password complexity requirements — The registration or password change endpoint does not enforce minimum password complexity rules. Severity: Medium. CWE: CWE-521.
- [ ] SC-JAVA-049: Concurrent session control missing — A user can maintain unlimited simultaneous sessions without invalidation of prior sessions. Severity: Low. CWE: CWE-613.
- [ ] SC-JAVA-050: Insecure token storage on client — Authentication tokens are stored in localStorage instead of HttpOnly cookies, exposing them to XSS. Severity: Medium. CWE: CWE-922.

### 3. Authorization & Access Control (20 items)

- [ ] SC-JAVA-051: Missing authorization check on endpoint — A controller method or servlet endpoint processes requests without verifying caller permissions. Severity: Critical. CWE: CWE-862.
- [ ] SC-JAVA-052: Insecure direct object reference — Object identifiers from user input are used to retrieve resources without verifying ownership. Severity: High. CWE: CWE-639.
- [ ] SC-JAVA-053: Horizontal privilege escalation — A user can access or modify another user's resources by manipulating an identifier parameter. Severity: High. CWE: CWE-639.
- [ ] SC-JAVA-054: Vertical privilege escalation — A non-admin user can access admin functionality due to missing role checks. Severity: Critical. CWE: CWE-269.
- [ ] SC-JAVA-055: Missing function-level access control — Backend business logic functions do not enforce role-based access independently of the UI. Severity: High. CWE: CWE-862.
- [ ] SC-JAVA-056: Broken access control on file download — File download endpoints serve arbitrary files without checking the requester's authorization. Severity: High. CWE: CWE-862.
- [ ] SC-JAVA-057: Permissive CORS configuration — The Access-Control-Allow-Origin header is set to wildcard or reflects untrusted origins with credentials. Severity: High. CWE: CWE-942.
- [ ] SC-JAVA-058: Missing CSRF protection — State-changing operations do not require a CSRF token or equivalent protection. Severity: High. CWE: CWE-352.
- [ ] SC-JAVA-059: Role check using string comparison — Authorization logic compares role names using plain string equality without case normalization. Severity: Medium. CWE: CWE-863.
- [ ] SC-JAVA-060: Overly permissive default role — New users are assigned an overly privileged default role. Severity: Medium. CWE: CWE-269.
- [ ] SC-JAVA-061: Missing access control on admin API — Administrative API endpoints are accessible without requiring an admin role or IP restriction. Severity: Critical. CWE: CWE-862.
- [ ] SC-JAVA-062: Inconsistent authorization enforcement — Some code paths enforce authorization while equivalent paths for the same resource do not. Severity: High. CWE: CWE-863.
- [ ] SC-JAVA-063: Authorization bypass via HTTP method — Access control is enforced on GET but not on POST (or vice versa) for the same resource. Severity: High. CWE: CWE-863.
- [ ] SC-JAVA-064: Missing tenant isolation in multi-tenant app — Queries do not filter by tenant ID, allowing one tenant to access another tenant's data. Severity: Critical. CWE: CWE-639.
- [ ] SC-JAVA-065: Client-side authorization only — Access control decisions are made in client-side JavaScript without server-side enforcement. Severity: Critical. CWE: CWE-602.
- [ ] SC-JAVA-066: Privilege escalation via mass assignment — Object binding allows users to set privileged fields (e.g., isAdmin) through request parameters. Severity: High. CWE: CWE-915.
- [ ] SC-JAVA-067: Missing rate limiting on sensitive operations — Sensitive endpoints such as password change or fund transfer lack rate limiting. Severity: Medium. CWE: CWE-770.
- [ ] SC-JAVA-068: Unrestricted GraphQL introspection — GraphQL introspection is enabled in production, exposing the full API schema to attackers. Severity: Medium. CWE: CWE-200.
- [ ] SC-JAVA-069: Missing row-level security — Database queries return all rows without filtering by the authenticated user's scope. Severity: High. CWE: CWE-862.
- [ ] SC-JAVA-070: Broken access control on batch operations — Batch or bulk API endpoints do not verify authorization for each individual item in the batch. Severity: High. CWE: CWE-862.

### 4. Cryptography (25 items)

- [ ] SC-JAVA-071: Use of java.util.Random for security — java.util.Random is used to generate tokens, keys, or nonces instead of java.security.SecureRandom. Severity: High. CWE: CWE-330.
- [ ] SC-JAVA-072: Use of Math.random() for security — Math.random() or Kotlin's Random.nextInt() is used for cryptographic purposes. Severity: High. CWE: CWE-330.
- [ ] SC-JAVA-073: DES or 3DES encryption — The obsolete DES or Triple DES algorithm is used instead of AES-256. Severity: High. CWE: CWE-327.
- [ ] SC-JAVA-074: ECB mode of operation — AES is used with ECB mode, which does not provide semantic security for multi-block messages. Severity: High. CWE: CWE-327.
- [ ] SC-JAVA-075: Static or hardcoded initialization vector — The IV for symmetric encryption is hardcoded or reused across encryptions. Severity: High. CWE: CWE-329.
- [ ] SC-JAVA-076: Hardcoded encryption key — The symmetric encryption key is embedded directly in the source code. Severity: Critical. CWE: CWE-321.
- [ ] SC-JAVA-077: Missing HMAC or AEAD for ciphertext integrity — Ciphertext is not authenticated, enabling padding oracle or bit-flipping attacks. Severity: High. CWE: CWE-353.
- [ ] SC-JAVA-078: RSA without OAEP padding — RSA encryption uses PKCS#1 v1.5 padding instead of OAEP, enabling Bleichenbacher attacks. Severity: High. CWE: CWE-780.
- [ ] SC-JAVA-079: Insufficient RSA key size — RSA keys are generated with fewer than 2048 bits. Severity: High. CWE: CWE-326.
- [ ] SC-JAVA-080: MD5 used for integrity verification — MD5 is used for checksums or integrity verification where collision resistance is needed. Severity: Medium. CWE: CWE-328.
- [ ] SC-JAVA-081: SHA-1 used for digital signatures — SHA-1 is used in a digital signature scheme despite known collision attacks. Severity: High. CWE: CWE-328.
- [ ] SC-JAVA-082: Missing certificate validation — TLS certificate validation is disabled or a custom TrustManager accepts all certificates. Severity: Critical. CWE: CWE-295.
- [ ] SC-JAVA-083: Missing hostname verification — SSL/TLS hostname verification is disabled, allowing man-in-the-middle attacks. Severity: Critical. CWE: CWE-297.
- [ ] SC-JAVA-084: Use of deprecated SSL/TLS versions — Connections use SSLv3 or TLS 1.0/1.1 instead of TLS 1.2 or later. Severity: High. CWE: CWE-326.
- [ ] SC-JAVA-085: Weak cipher suites enabled — TLS configuration includes weak cipher suites such as RC4 or NULL ciphers. Severity: High. CWE: CWE-326.
- [ ] SC-JAVA-086: Custom cryptographic implementation — A custom encryption or hashing algorithm is implemented instead of using a vetted library. Severity: High. CWE: CWE-327.
- [ ] SC-JAVA-087: Key material in heap memory too long — Cryptographic key bytes are stored in a String instead of a char[] or byte[] that can be explicitly zeroed. Severity: Medium. CWE: CWE-316.
- [ ] SC-JAVA-088: Insecure key derivation function — Keys are derived using simple hashing instead of PBKDF2, HKDF, or scrypt. Severity: High. CWE: CWE-916.
- [ ] SC-JAVA-089: Predictable salt for password hashing — A static or predictable salt is used for password hashing. Severity: High. CWE: CWE-760.
- [ ] SC-JAVA-090: Missing forward secrecy — TLS cipher suite configuration does not prioritize ECDHE or DHE key exchange for forward secrecy. Severity: Medium. CWE: CWE-326.
- [ ] SC-JAVA-091: Insufficient PBKDF2 iterations — PBKDF2 is configured with fewer than 600,000 iterations for SHA-256 as recommended by OWASP. Severity: Medium. CWE: CWE-916.
- [ ] SC-JAVA-092: Insecure random seed — SecureRandom is seeded with a predictable value, undermining its randomness guarantees. Severity: High. CWE: CWE-335.
- [ ] SC-JAVA-093: Encryption key stored alongside ciphertext — The encryption key is stored in the same database or file as the encrypted data. Severity: High. CWE: CWE-312.
- [ ] SC-JAVA-094: Missing certificate pinning — The application does not pin server certificates or public keys, allowing CA compromise attacks. Severity: Medium. CWE: CWE-295.
- [ ] SC-JAVA-095: AES-CBC without constant-time MAC check — MAC verification before decryption is not performed in constant time, enabling timing attacks. Severity: Medium. CWE: CWE-385.

### 5. Error Handling & Logging (20 items)

- [ ] SC-JAVA-096: Stack trace exposed to user — Java exception stack traces are returned in HTTP responses, leaking internal class names and paths. Severity: Medium. CWE: CWE-209.
- [ ] SC-JAVA-097: Database error details exposed — SQL error messages including query text or schema details are shown to end users. Severity: Medium. CWE: CWE-209.
- [ ] SC-JAVA-098: Catch block swallows exception silently — An empty catch block discards the exception without logging, masking potential security failures. Severity: Medium. CWE: CWE-390.
- [ ] SC-JAVA-099: Sensitive data in exception messages — Exception messages include passwords, tokens, or PII that may be logged or displayed. Severity: High. CWE: CWE-209.
- [ ] SC-JAVA-100: Missing centralized exception handler — The application lacks a global exception handler, causing inconsistent error responses. Severity: Medium. CWE: CWE-755.
- [ ] SC-JAVA-101: Verbose error messages in production — Debug-level error details are enabled in production configuration. Severity: Medium. CWE: CWE-209.
- [ ] SC-JAVA-102: Missing security event logging — Authentication failures, authorization violations, and other security events are not logged. Severity: Medium. CWE: CWE-778.
- [ ] SC-JAVA-103: Log injection vulnerability — User-controlled data is logged without sanitizing newline and format characters. Severity: Medium. CWE: CWE-117.
- [ ] SC-JAVA-104: Excessive logging of sensitive data — PII, credentials, or financial data are written to log files in cleartext. Severity: High. CWE: CWE-532.
- [ ] SC-JAVA-105: Missing log integrity protection — Log files are not protected against tampering or deletion by attackers with system access. Severity: Low. CWE: CWE-779.
- [ ] SC-JAVA-106: Uncaught runtime exceptions — RuntimeExceptions can propagate unhandled, causing 500 errors with stack traces. Severity: Medium. CWE: CWE-248.
- [ ] SC-JAVA-107: Missing audit trail for admin actions — Administrative operations like user deletion or configuration changes are not logged. Severity: Medium. CWE: CWE-778.
- [ ] SC-JAVA-108: Error message reveals technology stack — Error pages expose the web server, framework version, or JDK version. Severity: Low. CWE: CWE-200.
- [ ] SC-JAVA-109: Missing structured logging — Logs use unstructured text making it difficult to detect and correlate security events. Severity: Low. CWE: CWE-778.
- [ ] SC-JAVA-110: Logging PII without consent — Personal data is logged without complying with data protection regulations. Severity: Medium. CWE: CWE-532.
- [ ] SC-JAVA-111: Log file permissions too permissive — Log files are readable by all users on the system rather than restricted to the application user. Severity: Medium. CWE: CWE-276.
- [ ] SC-JAVA-112: Fail-open error handling — Security checks that throw exceptions default to allowing access instead of denying. Severity: High. CWE: CWE-636.
- [ ] SC-JAVA-113: Missing error handling on cryptographic operations — Failures in encryption or decryption are not caught, potentially processing data insecurely. Severity: High. CWE: CWE-755.
- [ ] SC-JAVA-114: Exception information leakage in REST API — REST API error responses include Java exception class names and internal details. Severity: Medium. CWE: CWE-209.
- [ ] SC-JAVA-115: Missing log rotation and retention policy — Log files grow unbounded, potentially filling disk and enabling DoS. Severity: Low. CWE: CWE-779.

### 6. Data Protection & Privacy (20 items)

- [ ] SC-JAVA-116: PII stored in plaintext — Personally identifiable information is stored unencrypted in the database. Severity: High. CWE: CWE-312.
- [ ] SC-JAVA-117: Sensitive data in HTTP GET parameters — Sensitive data such as tokens or SSNs is passed in URL query strings and may be logged. Severity: Medium. CWE: CWE-598.
- [ ] SC-JAVA-118: Missing data-at-rest encryption — Database columns or files containing sensitive data are not encrypted at rest. Severity: High. CWE: CWE-311.
- [ ] SC-JAVA-119: Sensitive data in browser cache — Responses containing sensitive data lack Cache-Control: no-store headers. Severity: Medium. CWE: CWE-524.
- [ ] SC-JAVA-120: Missing data masking in logs — Full credit card numbers, SSNs, or other sensitive values appear unmasked in logs. Severity: High. CWE: CWE-532.
- [ ] SC-JAVA-121: Insecure data deletion — Sensitive data is deleted with a simple DELETE without ensuring physical removal from storage. Severity: Medium. CWE: CWE-226.
- [ ] SC-JAVA-122: Sensitive data in Java heap dumps — Heap dumps are enabled in production and may contain passwords, keys, or PII. Severity: Medium. CWE: CWE-316.
- [ ] SC-JAVA-123: Missing encryption for data in transit — Sensitive data is transmitted over unencrypted HTTP instead of HTTPS. Severity: High. CWE: CWE-319.
- [ ] SC-JAVA-124: Sensitive data in auto-complete fields — Form fields containing sensitive data do not disable browser auto-complete. Severity: Low. CWE: CWE-524.
- [ ] SC-JAVA-125: Missing data retention policy — The application retains sensitive data indefinitely without a defined deletion schedule. Severity: Medium. CWE: CWE-404.
- [ ] SC-JAVA-126: Credit card data stored in violation of PCI DSS — Full credit card numbers or CVVs are stored without PCI DSS compliance controls. Severity: Critical. CWE: CWE-312.
- [ ] SC-JAVA-127: Clipboard exposure of sensitive data — Sensitive fields do not prevent copy/paste, allowing clipboard sniffing of credentials. Severity: Low. CWE: CWE-200.
- [ ] SC-JAVA-128: Missing data classification — The application does not classify data sensitivity levels, leading to inconsistent protection. Severity: Low. CWE: CWE-200.
- [ ] SC-JAVA-129: Backup files contain unencrypted secrets — Database or application backups are stored without encrypting sensitive contents. Severity: High. CWE: CWE-312.
- [ ] SC-JAVA-130: Temporary files with sensitive data not cleaned — Temp files created during processing contain sensitive data and are not deleted on completion. Severity: Medium. CWE: CWE-459.
- [ ] SC-JAVA-131: Missing Referrer-Policy header — The Referrer-Policy header is not set, potentially leaking sensitive URL paths to third parties. Severity: Low. CWE: CWE-200.
- [ ] SC-JAVA-132: Sensitive data in toString() output — Domain objects with sensitive fields include them in toString() which may appear in logs. Severity: Medium. CWE: CWE-532.
- [ ] SC-JAVA-133: Missing right to erasure implementation — The application has no mechanism to delete all personal data for a given user on request. Severity: Medium. CWE: CWE-404.
- [ ] SC-JAVA-134: Insecure cross-origin data sharing — Sensitive data is shared with third-party origins via postMessage without target origin validation. Severity: High. CWE: CWE-346.
- [ ] SC-JAVA-135: Excessive data collection — The application collects more personal data than is necessary for its stated purpose. Severity: Medium. CWE: CWE-250.

### 7. SQL/NoSQL/ORM Security (25 items)

- [ ] SC-JAVA-136: SQL injection via string concatenation — SQL queries are built by concatenating user input instead of using parameterized queries. Severity: Critical. CWE: CWE-89.
- [ ] SC-JAVA-137: SQL injection in JDBC PreparedStatement misuse — PreparedStatement is used but user input is still concatenated into the SQL string. Severity: Critical. CWE: CWE-89.
- [ ] SC-JAVA-138: HQL injection in Hibernate — User input is concatenated into HQL/JPQL queries instead of using named parameters. Severity: Critical. CWE: CWE-89.
- [ ] SC-JAVA-139: Criteria API misuse — Dynamic Hibernate Criteria queries include unvalidated user input in restrictions. Severity: High. CWE: CWE-89.
- [ ] SC-JAVA-140: Native SQL query injection — EntityManager.createNativeQuery() uses string concatenation with user input. Severity: Critical. CWE: CWE-89.
- [ ] SC-JAVA-141: NoSQL injection in MongoDB — User input is embedded in MongoDB query objects without sanitization, enabling operator injection. Severity: High. CWE: CWE-943.
- [ ] SC-JAVA-142: Second-order SQL injection — Data previously stored from user input is later used in SQL queries without parameterization. Severity: High. CWE: CWE-89.
- [ ] SC-JAVA-143: SQL injection in ORDER BY clause — User input controls the ORDER BY column name without allowlist validation since it cannot be parameterized. Severity: High. CWE: CWE-89.
- [ ] SC-JAVA-144: SQL injection in LIKE pattern — The LIKE pattern uses unescaped user input allowing wildcard abuse for DoS or data extraction. Severity: Medium. CWE: CWE-89.
- [ ] SC-JAVA-145: Missing database connection encryption — JDBC connections to the database do not use SSL/TLS, transmitting data in cleartext. Severity: High. CWE: CWE-319.
- [ ] SC-JAVA-146: Excessive database privileges — The application's database user has DBA or DDL privileges beyond what is needed. Severity: High. CWE: CWE-250.
- [ ] SC-JAVA-147: Blind SQL injection — The application's differing responses to true/false SQL conditions enable blind data extraction. Severity: High. CWE: CWE-89.
- [ ] SC-JAVA-148: ORM lazy-loading N+1 DoS — Uncontrolled lazy loading of entity relationships can be triggered to cause excessive database queries. Severity: Medium. CWE: CWE-400.
- [ ] SC-JAVA-149: JPA specification injection — JPA Specification or CriteriaBuilder objects are constructed from unvalidated user input. Severity: High. CWE: CWE-89.
- [ ] SC-JAVA-150: Missing query timeout — Database queries do not have a timeout configured, allowing long-running queries to cause DoS. Severity: Medium. CWE: CWE-400.
- [ ] SC-JAVA-151: Database credentials in application.properties — Database username and password are stored in plaintext in configuration files committed to VCS. Severity: Critical. CWE: CWE-798.
- [ ] SC-JAVA-152: Stored procedure injection — User input is concatenated into dynamic SQL inside stored procedures invoked from Java code. Severity: High. CWE: CWE-89.
- [ ] SC-JAVA-153: Missing connection pool limits — Database connection pool has no maximum size, allowing resource exhaustion under load. Severity: Medium. CWE: CWE-770.
- [ ] SC-JAVA-154: SQL injection via MyBatis ${ } interpolation — MyBatis mapper XML uses ${} syntax instead of #{} for user input, enabling SQL injection. Severity: Critical. CWE: CWE-89.
- [ ] SC-JAVA-155: Elasticsearch injection — User input is embedded in Elasticsearch query DSL without proper escaping. Severity: High. CWE: CWE-943.
- [ ] SC-JAVA-156: Redis command injection — User input is concatenated into Redis commands executed via Jedis or Lettuce. Severity: High. CWE: CWE-77.
- [ ] SC-JAVA-157: JOOQ raw SQL injection — JOOQ's DSL.raw() or plain SQL methods are used with unsanitized user input. Severity: High. CWE: CWE-89.
- [ ] SC-JAVA-158: Missing database audit logging — The database does not log data access or modification events for security auditing. Severity: Medium. CWE: CWE-778.
- [ ] SC-JAVA-159: Cassandra CQL injection — User input is concatenated into Cassandra CQL queries instead of using bound parameters. Severity: High. CWE: CWE-943.
- [ ] SC-JAVA-160: Missing prepared statement caching — Prepared statements are created per-request rather than cached, increasing overhead and potential for injection if fallback occurs. Severity: Low. CWE: CWE-400.

### 8. File Operations (20 items)

- [ ] SC-JAVA-161: Path traversal in file operations — User-supplied file paths are used without canonicalization, allowing directory traversal attacks. Severity: High. CWE: CWE-22.
- [ ] SC-JAVA-162: Unrestricted file upload size — File uploads have no size limit, enabling denial of service through disk exhaustion. Severity: Medium. CWE: CWE-400.
- [ ] SC-JAVA-163: Zip Slip vulnerability — Archives are extracted without validating that entry paths do not escape the target directory. Severity: High. CWE: CWE-22.
- [ ] SC-JAVA-164: Zip bomb denial of service — Compressed files are extracted without checking the decompressed size ratio. Severity: Medium. CWE: CWE-409.
- [ ] SC-JAVA-165: Symlink following in file operations — File operations follow symbolic links, allowing access to files outside the intended directory. Severity: High. CWE: CWE-59.
- [ ] SC-JAVA-166: World-writable file permissions — Files are created with overly permissive permissions (e.g., 0777) on the filesystem. Severity: Medium. CWE: CWE-276.
- [ ] SC-JAVA-167: Temporary file created in shared directory — Temp files with sensitive data are created in /tmp without restrictive permissions. Severity: Medium. CWE: CWE-377.
- [ ] SC-JAVA-168: Missing file type validation by content — File type is determined solely by extension rather than inspecting the file's magic bytes. Severity: Medium. CWE: CWE-434.
- [ ] SC-JAVA-169: Arbitrary file deletion — User input controls the path passed to File.delete() without authorization checks. Severity: High. CWE: CWE-73.
- [ ] SC-JAVA-170: Resource leak on file handles — File streams or channels are not closed in a finally block or try-with-resources. Severity: Medium. CWE: CWE-404.
- [ ] SC-JAVA-171: Race condition in file check-then-use — A file's existence or permissions are checked, then used in a separate operation, creating a TOCTOU race. Severity: Medium. CWE: CWE-367.
- [ ] SC-JAVA-172: Executable file upload — The application allows uploading files with executable extensions (.jsp, .jar, .sh) without restriction. Severity: Critical. CWE: CWE-434.
- [ ] SC-JAVA-173: Missing antivirus scanning on uploads — Uploaded files are stored and served without malware scanning. Severity: Medium. CWE: CWE-434.
- [ ] SC-JAVA-174: File inclusion vulnerability — User input is used to include or load files dynamically via class loaders or include mechanisms. Severity: High. CWE: CWE-98.
- [ ] SC-JAVA-175: Insecure file download Content-Disposition — Downloaded files lack a Content-Disposition header, enabling browser MIME-sniffing attacks. Severity: Medium. CWE: CWE-430.
- [ ] SC-JAVA-176: XML external entity via file parsing — XML files are parsed from uploads without disabling external entity resolution. Severity: High. CWE: CWE-611.
- [ ] SC-JAVA-177: Missing Content-Type on file responses — Files are served without a correct Content-Type header, enabling MIME confusion. Severity: Medium. CWE: CWE-430.
- [ ] SC-JAVA-178: Log file stored in web-accessible directory — Application log files are stored under the web root and can be downloaded by attackers. Severity: High. CWE: CWE-538.
- [ ] SC-JAVA-179: Missing X-Content-Type-Options header on file responses — File downloads lack the X-Content-Type-Options: nosniff header. Severity: Low. CWE: CWE-430.
- [ ] SC-JAVA-180: Unsafe NIO file operations — java.nio.file operations with user input do not use Path.normalize() or restrict to a base directory. Severity: High. CWE: CWE-22.

### 9. Network & HTTP Security (20 items)

- [ ] SC-JAVA-181: Missing HTTPS enforcement — The application accepts HTTP connections without redirecting to HTTPS. Severity: High. CWE: CWE-319.
- [ ] SC-JAVA-182: Missing HSTS header — The Strict-Transport-Security header is absent, allowing SSL stripping attacks. Severity: Medium. CWE: CWE-523.
- [ ] SC-JAVA-183: Missing Content-Security-Policy header — No CSP header is set, increasing risk of XSS and data injection attacks. Severity: Medium. CWE: CWE-1021.
- [ ] SC-JAVA-184: Missing X-Frame-Options header — The X-Frame-Options header is not set, enabling clickjacking attacks. Severity: Medium. CWE: CWE-1021.
- [ ] SC-JAVA-185: Missing X-Content-Type-Options header — The X-Content-Type-Options: nosniff header is absent, enabling MIME-type sniffing. Severity: Low. CWE: CWE-430.
- [ ] SC-JAVA-186: Open redirect vulnerability — User-controlled input determines redirect targets without validation. Severity: Medium. CWE: CWE-601.
- [ ] SC-JAVA-187: DNS rebinding vulnerability — The server does not validate the Host header, allowing DNS rebinding attacks. Severity: Medium. CWE: CWE-350.
- [ ] SC-JAVA-188: Insecure WebSocket connection — WebSocket connections use ws:// instead of wss://, transmitting data in cleartext. Severity: High. CWE: CWE-319.
- [ ] SC-JAVA-189: Missing WebSocket origin validation — WebSocket upgrade requests do not verify the Origin header. Severity: High. CWE: CWE-346.
- [ ] SC-JAVA-190: HTTP response splitting — User input containing CRLF characters is reflected in HTTP response headers. Severity: High. CWE: CWE-113.
- [ ] SC-JAVA-191: Server banner information disclosure — The HTTP Server header reveals detailed version information about the server and framework. Severity: Low. CWE: CWE-200.
- [ ] SC-JAVA-192: Unencrypted cookie transmission — Cookies containing sensitive data are sent without the Secure flag over HTTP. Severity: Medium. CWE: CWE-614.
- [ ] SC-JAVA-193: Missing request size limits — No maximum request body size is configured, allowing large payload DoS. Severity: Medium. CWE: CWE-770.
- [ ] SC-JAVA-194: HTTP method override abuse — The X-HTTP-Method-Override header is accepted and can bypass method-based access controls. Severity: Medium. CWE: CWE-863.
- [ ] SC-JAVA-195: Insecure proxy configuration — Reverse proxy headers (X-Forwarded-For) are trusted without verifying the source. Severity: Medium. CWE: CWE-345.
- [ ] SC-JAVA-196: Missing connection timeout — HTTP client connections have no timeout configured, enabling Slowloris-style DoS. Severity: Medium. CWE: CWE-400.
- [ ] SC-JAVA-197: Insecure TLS renegotiation — TLS renegotiation is enabled without secure renegotiation indication. Severity: Medium. CWE: CWE-326.
- [ ] SC-JAVA-198: Missing rate limiting — API endpoints lack rate limiting, enabling abuse and denial of service. Severity: Medium. CWE: CWE-770.
- [ ] SC-JAVA-199: Cross-origin WebSocket hijacking — WebSocket endpoints accept connections from any origin, enabling cross-site hijacking. Severity: High. CWE: CWE-346.
- [ ] SC-JAVA-200: Insecure HTTP client follows redirects to different protocols — HttpClient follows redirects from HTTPS to HTTP, potentially leaking data. Severity: Medium. CWE: CWE-319.

### 10. Serialization & Deserialization (30 items)

- [ ] SC-JAVA-201: Unsafe ObjectInputStream deserialization — Untrusted data is deserialized using ObjectInputStream without an allowlist of permitted classes. Severity: Critical. CWE: CWE-502.
- [ ] SC-JAVA-202: Apache Commons Collections gadget chain — The classpath includes Apache Commons Collections versions vulnerable to deserialization exploits. Severity: Critical. CWE: CWE-502.
- [ ] SC-JAVA-203: Apache Commons BeanUtils gadget chain — Apache Commons BeanUtils is on the classpath and can be used in deserialization chains. Severity: Critical. CWE: CWE-502.
- [ ] SC-JAVA-204: Spring Framework gadget chain — Spring beans on the classpath can be leveraged as deserialization gadgets. Severity: Critical. CWE: CWE-502.
- [ ] SC-JAVA-205: C3P0 JNDI deserialization gadget — C3P0 connection pool library on the classpath enables JNDI-based deserialization attacks. Severity: Critical. CWE: CWE-502.
- [ ] SC-JAVA-206: Jackson polymorphic deserialization — Jackson ObjectMapper is configured with default typing enabled, allowing arbitrary class instantiation. Severity: Critical. CWE: CWE-502.
- [ ] SC-JAVA-207: Jackson missing type allowlist — Jackson @JsonTypeInfo annotation uses Id.CLASS or Id.MINIMAL_CLASS without a custom type validator. Severity: Critical. CWE: CWE-502.
- [ ] SC-JAVA-208: Fastjson autoType deserialization — Fastjson with autoType enabled deserializes arbitrary classes from untrusted JSON. Severity: Critical. CWE: CWE-502.
- [ ] SC-JAVA-209: Fastjson outdated version — Fastjson version is older than 1.2.83 and vulnerable to known autoType bypasses. Severity: Critical. CWE: CWE-502.
- [ ] SC-JAVA-210: XStream deserialization vulnerability — XStream is used to deserialize untrusted XML without configuring security permissions. Severity: Critical. CWE: CWE-502.
- [ ] SC-JAVA-211: SnakeYAML unsafe load — SnakeYAML's Yaml.load() is used on untrusted input instead of Yaml.safeLoad(). Severity: Critical. CWE: CWE-502.
- [ ] SC-JAVA-212: Java RMI deserialization — Java RMI endpoints accept serialized objects from untrusted clients. Severity: Critical. CWE: CWE-502.
- [ ] SC-JAVA-213: JMX deserialization exposure — JMX ports are exposed to untrusted networks, allowing deserialization attacks. Severity: High. CWE: CWE-502.
- [ ] SC-JAVA-214: JNDI injection via user input — User-controlled input is passed to InitialContext.lookup(), enabling remote class loading. Severity: Critical. CWE: CWE-74.
- [ ] SC-JAVA-215: Log4Shell (Log4j JNDI) — Log4j 2.x before 2.17.0 processes JNDI lookup strings in log messages from untrusted sources. Severity: Critical. CWE: CWE-917.
- [ ] SC-JAVA-216: Missing serialization filter (JEP 290) — Java 9+ serialization filters are not configured to restrict deserializable classes. Severity: High. CWE: CWE-502.
- [ ] SC-JAVA-217: Kryo unsafe deserialization — Kryo is used to deserialize untrusted data without registration-required mode. Severity: High. CWE: CWE-502.
- [ ] SC-JAVA-218: Hessian deserialization vulnerability — Hessian/Burlap protocol deserializes untrusted objects without class filtering. Severity: High. CWE: CWE-502.
- [ ] SC-JAVA-219: AMF deserialization vulnerability — BlazeDS or similar AMF frameworks deserialize untrusted ActionScript objects. Severity: High. CWE: CWE-502.
- [ ] SC-JAVA-220: Serializable interface on sensitive classes — Classes containing sensitive data implement Serializable unnecessarily. Severity: Medium. CWE: CWE-499.
- [ ] SC-JAVA-221: Missing readObject/readResolve validation — Custom readObject() does not validate deserialized field values for consistency. Severity: Medium. CWE: CWE-502.
- [ ] SC-JAVA-222: Serialized data in cookies — Java serialized objects are stored in cookies, exposing them to client-side tampering. Severity: High. CWE: CWE-502.
- [ ] SC-JAVA-223: Gson type adapter bypass — Custom Gson TypeAdapter does not validate or restrict the types it deserializes. Severity: Medium. CWE: CWE-502.
- [ ] SC-JAVA-224: Protocol Buffers unvalidated field access — Protobuf messages are used without checking has*() methods, leading to default value misinterpretation. Severity: Low. CWE: CWE-20.
- [ ] SC-JAVA-225: MessagePack deserialization of unknown types — MessagePack deserializes objects from untrusted sources without type restrictions. Severity: High. CWE: CWE-502.
- [ ] SC-JAVA-226: Java serialization in HTTP sessions — HTTP sessions store objects as serialized Java, enabling gadget attacks if session data is tampered with. Severity: High. CWE: CWE-502.
- [ ] SC-JAVA-227: Missing ObjectInputFilter in Java 17+ — Applications running on Java 17+ do not set a process-wide or per-stream deserialization filter. Severity: Medium. CWE: CWE-502.
- [ ] SC-JAVA-228: XMLDecoder on untrusted input — java.beans.XMLDecoder is used to parse untrusted XML, enabling arbitrary code execution. Severity: Critical. CWE: CWE-502.
- [ ] SC-JAVA-229: JSON-B polymorphic deserialization — JSON-B with @JsonbTypeDeserializer allows arbitrary type instantiation from untrusted input. Severity: High. CWE: CWE-502.
- [ ] SC-JAVA-230: Apache Dubbo deserialization — Dubbo RPC endpoints use Java serialization by default, enabling deserialization attacks. Severity: Critical. CWE: CWE-502.

### 11. Concurrency & Race Conditions (20 items)

- [ ] SC-JAVA-231: TOCTOU race condition — A check-then-act pattern on shared state is not atomic, enabling race conditions. Severity: Medium. CWE: CWE-367.
- [ ] SC-JAVA-232: Non-atomic compound operation — Multiple operations on a shared variable are not synchronized, causing data races. Severity: Medium. CWE: CWE-362.
- [ ] SC-JAVA-233: Unsynchronized lazy initialization — Singleton or shared object lazy initialization is not thread-safe (missing volatile + DCL). Severity: Medium. CWE: CWE-362.
- [ ] SC-JAVA-234: Race condition in authentication check — Authorization state is checked and then used in a non-atomic sequence, allowing bypass. Severity: High. CWE: CWE-362.
- [ ] SC-JAVA-235: Thread-unsafe HashMap — A java.util.HashMap is shared between threads without synchronization, causing data corruption. Severity: Medium. CWE: CWE-362.
- [ ] SC-JAVA-236: Thread-unsafe SimpleDateFormat — SimpleDateFormat is shared across threads without synchronization, producing corrupt dates. Severity: Medium. CWE: CWE-362.
- [ ] SC-JAVA-237: Missing volatile on shared flag — A boolean flag used to communicate between threads is not declared volatile. Severity: Medium. CWE: CWE-362.
- [ ] SC-JAVA-238: Deadlock potential — Locks are acquired in inconsistent order across different code paths, risking deadlock. Severity: Medium. CWE: CWE-833.
- [ ] SC-JAVA-239: Unbounded thread pool — An ExecutorService uses an unbounded thread pool that can exhaust system resources under load. Severity: Medium. CWE: CWE-770.
- [ ] SC-JAVA-240: Race condition in file operations — File existence checks and subsequent file operations are not atomic, enabling TOCTOU attacks. Severity: Medium. CWE: CWE-367.
- [ ] SC-JAVA-241: Unsafe publication of mutable objects — A mutable object is shared between threads without proper synchronization or safe publication. Severity: Medium. CWE: CWE-362.
- [ ] SC-JAVA-242: ConcurrentModificationException risk — A collection is modified while being iterated without using a concurrent collection or synchronization. Severity: Low. CWE: CWE-362.
- [ ] SC-JAVA-243: Missing synchronization on servlet instance variables — Servlet instance fields are accessed concurrently without synchronization. Severity: High. CWE: CWE-362.
- [ ] SC-JAVA-244: Race condition in account balance update — Financial balance operations are not atomic, enabling double-spend attacks. Severity: Critical. CWE: CWE-362.
- [ ] SC-JAVA-245: Thread pool task queue unbounded — The task queue for an executor has no capacity limit, enabling memory exhaustion. Severity: Medium. CWE: CWE-770.
- [ ] SC-JAVA-246: Unsafe double-checked locking — Double-checked locking pattern is used without volatile, which is broken on the Java Memory Model. Severity: Medium. CWE: CWE-362.
- [ ] SC-JAVA-247: Race condition in session attribute access — Session attributes are read and modified without synchronization in concurrent requests. Severity: Medium. CWE: CWE-362.
- [ ] SC-JAVA-248: Missing atomic operations for counters — Counter or sequence operations use non-atomic read-modify-write instead of AtomicLong. Severity: Low. CWE: CWE-362.
- [ ] SC-JAVA-249: Kotlin coroutine shared mutable state — Mutable state is accessed from multiple coroutines without confinement or a Mutex. Severity: Medium. CWE: CWE-362.
- [ ] SC-JAVA-250: Thread safety of @Lazy Spring beans — Lazy-initialized Spring beans may be created multiple times in concurrent access without @Synchronized. Severity: Low. CWE: CWE-362.

### 12. Dependency & Supply Chain (20 items)

- [ ] SC-JAVA-251: Known vulnerable dependency — A direct dependency has known CVEs and has not been updated to a patched version. Severity: High. CWE: CWE-1395.
- [ ] SC-JAVA-252: Transitive vulnerable dependency — A transitive dependency has known security vulnerabilities. Severity: High. CWE: CWE-1395.
- [ ] SC-JAVA-253: Missing dependency vulnerability scanning — The build pipeline does not include automated dependency vulnerability scanning (e.g., OWASP Dependency-Check). Severity: Medium. CWE: CWE-1395.
- [ ] SC-JAVA-254: Dependency confusion attack — The build fetches dependencies from a public repository before a private one, enabling package substitution. Severity: High. CWE: CWE-427.
- [ ] SC-JAVA-255: Unsigned or unverified dependencies — Dependencies are downloaded without verifying checksums or signatures. Severity: Medium. CWE: CWE-494.
- [ ] SC-JAVA-256: Gradle/Maven plugin from untrusted source — Build plugins are loaded from untrusted third-party repositories without verification. Severity: High. CWE: CWE-494.
- [ ] SC-JAVA-257: Snapshot dependencies in production — SNAPSHOT versions are used in production builds, which can change without notice. Severity: Medium. CWE: CWE-829.
- [ ] SC-JAVA-258: Missing Gradle dependency locking — Gradle does not use dependency locking, allowing silent version changes between builds. Severity: Medium. CWE: CWE-829.
- [ ] SC-JAVA-259: Outdated Spring Boot version — The Spring Boot version is no longer receiving security patches. Severity: High. CWE: CWE-1395.
- [ ] SC-JAVA-260: Outdated Log4j version — Log4j version is before 2.17.1, potentially vulnerable to Log4Shell or related exploits. Severity: Critical. CWE: CWE-917.
- [ ] SC-JAVA-261: Abandoned dependency — A dependency has not received updates in over two years and may contain unpatched vulnerabilities. Severity: Medium. CWE: CWE-1395.
- [ ] SC-JAVA-262: Maven repository over HTTP — Maven dependencies are fetched over unencrypted HTTP, enabling man-in-the-middle tampering. Severity: High. CWE: CWE-319.
- [ ] SC-JAVA-263: Missing Software Bill of Materials (SBOM) — No SBOM is generated for the application, hindering vulnerability tracking. Severity: Low. CWE: CWE-1395.
- [ ] SC-JAVA-264: Excessive dependency scope — Test or development dependencies are included in production scope. Severity: Low. CWE: CWE-1395.
- [ ] SC-JAVA-265: Typosquatting risk — Dependencies have names similar to popular packages, suggesting potential typosquatting. Severity: Medium. CWE: CWE-427.
- [ ] SC-JAVA-266: Custom repository without authentication — Private Maven/Gradle repository is accessible without authentication credentials. Severity: Medium. CWE: CWE-306.
- [ ] SC-JAVA-267: Missing reproducible builds — Build output is not deterministic, making it difficult to verify that binaries match source code. Severity: Low. CWE: CWE-353.
- [ ] SC-JAVA-268: Build script injection — Build scripts (build.gradle, pom.xml) execute dynamic code or interpolate environment variables unsafely. Severity: High. CWE: CWE-94.
- [ ] SC-JAVA-269: Gradle buildSrc code execution — Code in buildSrc/ or included builds can execute arbitrary logic during the configuration phase. Severity: Medium. CWE: CWE-94.
- [ ] SC-JAVA-270: Missing dependency license compliance — Dependencies include licenses incompatible with the project's license or usage terms. Severity: Low. CWE: CWE-829.

### 13. Configuration & Secrets Management (20 items)

- [ ] SC-JAVA-271: Secrets in application.properties/yml — Passwords, API keys, or tokens are hardcoded in configuration files. Severity: Critical. CWE: CWE-798.
- [ ] SC-JAVA-272: Secrets committed to version control — Configuration files containing secrets are tracked in Git history. Severity: Critical. CWE: CWE-798.
- [ ] SC-JAVA-273: Debug mode enabled in production — Application runs with debug=true or trace logging in production. Severity: Medium. CWE: CWE-489.
- [ ] SC-JAVA-274: Default credentials not changed — Default admin credentials shipped with the application or framework are not changed. Severity: Critical. CWE: CWE-1392.
- [ ] SC-JAVA-275: Missing environment-specific configuration — Production and development configurations are not separated, risking debug settings in production. Severity: Medium. CWE: CWE-489.
- [ ] SC-JAVA-276: Insecure feature flags — Feature flags controlling security features can be toggled without authentication. Severity: Medium. CWE: CWE-863.
- [ ] SC-JAVA-277: Spring DevTools in production — Spring Boot DevTools dependency is included in production builds, enabling remote code execution. Severity: Critical. CWE: CWE-489.
- [ ] SC-JAVA-278: Missing secrets rotation — Secrets and API keys are never rotated, increasing exposure window if compromised. Severity: Medium. CWE: CWE-798.
- [ ] SC-JAVA-279: Unencrypted configuration server — Configuration is fetched from Spring Cloud Config Server over unencrypted HTTP. Severity: High. CWE: CWE-319.
- [ ] SC-JAVA-280: Missing vault integration — Secrets are stored in environment variables or files instead of a dedicated secrets manager. Severity: Medium. CWE: CWE-522.
- [ ] SC-JAVA-281: Permissive file permissions on config files — Configuration files containing secrets are world-readable on the filesystem. Severity: High. CWE: CWE-276.
- [ ] SC-JAVA-282: System properties exposing secrets — Secrets passed as JVM system properties (-D flags) are visible in process listings. Severity: High. CWE: CWE-214.
- [ ] SC-JAVA-283: JNDI data source password in plaintext — JNDI DataSource configuration stores the database password in cleartext in server.xml or context.xml. Severity: High. CWE: CWE-312.
- [ ] SC-JAVA-284: Missing .gitignore for secrets — Configuration files containing secrets are not listed in .gitignore. Severity: Medium. CWE: CWE-798.
- [ ] SC-JAVA-285: Insecure Jasypt encryption — Jasypt-encrypted properties use a weak password or default algorithm. Severity: Medium. CWE: CWE-327.
- [ ] SC-JAVA-286: Spring profiles leaking in responses — Active Spring profiles are exposed in HTTP responses or error pages. Severity: Low. CWE: CWE-200.
- [ ] SC-JAVA-287: Docker secrets in Dockerfile — Secrets are embedded in Dockerfiles or passed as build arguments, persisting in image layers. Severity: High. CWE: CWE-798.
- [ ] SC-JAVA-288: Missing RBAC for configuration management — Configuration changes can be made without role-based access control. Severity: Medium. CWE: CWE-862.
- [ ] SC-JAVA-289: Insecure default configuration — The application ships with permissive default settings that must be manually hardened. Severity: Medium. CWE: CWE-276.
- [ ] SC-JAVA-290: Environment variable injection — Untrusted input can influence environment variable resolution in configuration. Severity: High. CWE: CWE-74.

### 14. Memory & Type Safety (15 items)

- [ ] SC-JAVA-291: Unbounded collection growth — A collection (List, Map, Set) grows without limit from untrusted input, causing OutOfMemoryError. Severity: Medium. CWE: CWE-770.
- [ ] SC-JAVA-292: String pool pollution — Untrusted strings are interned via String.intern(), polluting the JVM string pool. Severity: Medium. CWE: CWE-400.
- [ ] SC-JAVA-293: JNI buffer overflow — Native code called via JNI does not perform bounds checking on buffers passed from Java. Severity: Critical. CWE: CWE-120.
- [ ] SC-JAVA-294: Direct ByteBuffer leak — Directly allocated ByteBuffers are not explicitly freed, causing native memory exhaustion. Severity: Medium. CWE: CWE-401.
- [ ] SC-JAVA-295: Unsafe sun.misc.Unsafe usage — sun.misc.Unsafe is used for direct memory manipulation, bypassing Java safety guarantees. Severity: High. CWE: CWE-787.
- [ ] SC-JAVA-296: ThreadLocal memory leak — ThreadLocal values are not removed after use, leaking memory in thread-pool environments. Severity: Medium. CWE: CWE-401.
- [ ] SC-JAVA-297: ClassLoader leak — Custom ClassLoaders hold references preventing garbage collection, causing PermGen/Metaspace exhaustion. Severity: Medium. CWE: CWE-401.
- [ ] SC-JAVA-298: Unchecked type casting — Unsafe type casts without instanceof checks can cause ClassCastException or security bypass. Severity: Medium. CWE: CWE-704.
- [ ] SC-JAVA-299: Integer overflow in array allocation — An integer overflow in size calculation leads to undersized array allocation. Severity: High. CWE: CWE-190.
- [ ] SC-JAVA-300: Kotlin null pointer on Java interop — Kotlin code calls a Java method that returns null on a non-nullable Kotlin type, causing NPE. Severity: Medium. CWE: CWE-476.
- [ ] SC-JAVA-301: Finalizer resource leak — Resources in finalize() may not be released timely due to unpredictable GC scheduling. Severity: Low. CWE: CWE-404.
- [ ] SC-JAVA-302: Soft/weak reference security bypass — Security-critical data stored in SoftReference or WeakReference can be garbage collected prematurely. Severity: Medium. CWE: CWE-404.
- [ ] SC-JAVA-303: XML parser entity expansion DoS — XML parsing without entity expansion limits enables billion-laughs memory exhaustion. Severity: High. CWE: CWE-776.
- [ ] SC-JAVA-304: Regex stack overflow — Complex regex patterns cause StackOverflowError on deeply nested input. Severity: Medium. CWE: CWE-674.
- [ ] SC-JAVA-305: Uncontrolled recursion — Recursive functions processing untrusted input have no depth limit, causing StackOverflowError. Severity: Medium. CWE: CWE-674.

### 15. Java/Kotlin-Specific Patterns (20 items)

- [ ] SC-JAVA-306: Runtime.exec command injection — User input is passed to Runtime.exec() or ProcessBuilder without sanitization. Severity: Critical. CWE: CWE-78.
- [ ] SC-JAVA-307: ProcessBuilder shell injection — ProcessBuilder is invoked with a shell (cmd.exe, /bin/sh -c) and user-controlled arguments. Severity: Critical. CWE: CWE-78.
- [ ] SC-JAVA-308: Reflection access to private fields — Reflection is used to access or modify private fields, bypassing encapsulation and security checks. Severity: High. CWE: CWE-470.
- [ ] SC-JAVA-309: MethodHandle security bypass — MethodHandles.lookup() is used to bypass access controls on private methods. Severity: High. CWE: CWE-470.
- [ ] SC-JAVA-310: System.exit() denial of service — Untrusted code can call System.exit() to terminate the JVM. Severity: High. CWE: CWE-382.
- [ ] SC-JAVA-311: XXE via DocumentBuilder — DocumentBuilderFactory does not disable external entities, enabling XXE attacks. Severity: High. CWE: CWE-611.
- [ ] SC-JAVA-312: XXE via SAXParser — SAXParserFactory does not disable external entities and DTDs. Severity: High. CWE: CWE-611.
- [ ] SC-JAVA-313: XXE via XMLReader — XMLReader is not configured to disable external entity resolution. Severity: High. CWE: CWE-611.
- [ ] SC-JAVA-314: XXE via StAX XMLInputFactory — XMLInputFactory does not disable external entities for StAX parsing. Severity: High. CWE: CWE-611.
- [ ] SC-JAVA-315: XXE via TransformerFactory — TransformerFactory processes untrusted XSLT without disabling external entities. Severity: High. CWE: CWE-611.
- [ ] SC-JAVA-316: XXE via SchemaFactory — SchemaFactory is used to validate XML against untrusted schemas without disabling external entities. Severity: High. CWE: CWE-611.
- [ ] SC-JAVA-317: Insecure ScriptEngine evaluation — javax.script.ScriptEngine evaluates user-controlled code (JavaScript, Groovy) without sandboxing. Severity: Critical. CWE: CWE-94.
- [ ] SC-JAVA-318: Unsafe class loading via forName — Class.forName() is called with user-controlled class names, enabling arbitrary class instantiation. Severity: Critical. CWE: CWE-470.
- [ ] SC-JAVA-319: Insecure ServiceLoader usage — ServiceLoader discovers and loads services from untrusted JARs on the classpath. Severity: High. CWE: CWE-470.
- [ ] SC-JAVA-320: Missing clone protection on mutable objects — Sensitive mutable objects implement Cloneable without defensive copying, enabling unauthorized modification. Severity: Medium. CWE: CWE-374.
- [ ] SC-JAVA-321: Kotlin data class with sensitive fields — Kotlin data classes auto-generate toString(), hashCode(), and copy() that may expose sensitive data. Severity: Medium. CWE: CWE-200.
- [ ] SC-JAVA-322: Kotlin sealed class incomplete when — A when expression over a sealed class is missing branches, potentially bypassing security checks. Severity: Medium. CWE: CWE-478.
- [ ] SC-JAVA-323: Kotlin scope function misuse — Kotlin scope functions (let, apply, run) with nullable receivers may execute code paths unexpectedly. Severity: Low. CWE: CWE-476.
- [ ] SC-JAVA-324: Java SecurityManager bypass — Code relies on the deprecated SecurityManager for sandboxing, which has known bypass techniques. Severity: High. CWE: CWE-266.
- [ ] SC-JAVA-325: Annotation processor code execution — Custom annotation processors execute arbitrary code at compile time without sandboxing. Severity: Medium. CWE: CWE-94.

### 16. Spring Boot-Specific (25 items)

- [ ] SC-JAVA-326: Spring Actuator endpoints exposed — Spring Boot Actuator management endpoints are accessible without authentication. Severity: Critical. CWE: CWE-200.
- [ ] SC-JAVA-327: Spring Actuator env endpoint leaks secrets — The /actuator/env endpoint exposes environment variables containing secrets. Severity: Critical. CWE: CWE-200.
- [ ] SC-JAVA-328: Spring Actuator heapdump exposed — The /actuator/heapdump endpoint is accessible, allowing memory dump extraction. Severity: Critical. CWE: CWE-200.
- [ ] SC-JAVA-329: Spring Actuator shutdown enabled — The /actuator/shutdown endpoint is enabled, allowing remote application termination. Severity: High. CWE: CWE-400.
- [ ] SC-JAVA-330: Spring SpEL injection — User input is evaluated as a Spring Expression Language expression, enabling RCE. Severity: Critical. CWE: CWE-917.
- [ ] SC-JAVA-331: Spring Data REST over-exposure — Spring Data REST exposes all repository methods as REST endpoints without explicit configuration. Severity: High. CWE: CWE-862.
- [ ] SC-JAVA-332: Spring Security misconfigured filter chain — The security filter chain has ordering issues or gaps allowing request bypass. Severity: High. CWE: CWE-863.
- [ ] SC-JAVA-333: Spring Security permitAll on sensitive endpoint — A sensitive endpoint is configured with permitAll() instead of requiring authentication. Severity: High. CWE: CWE-862.
- [ ] SC-JAVA-334: Missing @Validated on request body — Request body DTOs are not annotated with @Validated, skipping Bean Validation constraints. Severity: Medium. CWE: CWE-20.
- [ ] SC-JAVA-335: Spring mass assignment via @ModelAttribute — @ModelAttribute binding allows setting unintended fields on domain objects. Severity: High. CWE: CWE-915.
- [ ] SC-JAVA-336: Spring CSRF disabled globally — CSRF protection is disabled in Spring Security configuration without adequate justification. Severity: High. CWE: CWE-352.
- [ ] SC-JAVA-337: Spring Security debug mode in production — Spring Security debug mode (EnableWebSecurity(debug=true)) is active in production. Severity: Medium. CWE: CWE-489.
- [ ] SC-JAVA-338: Spring Boot error page information disclosure — The default Whitelabel error page exposes stack traces and internal details. Severity: Medium. CWE: CWE-209.
- [ ] SC-JAVA-339: Insecure Spring Cloud Config — Spring Cloud Config Server serves configuration without encryption or authentication. Severity: High. CWE: CWE-319.
- [ ] SC-JAVA-340: Spring OAuth2 Resource Server misconfiguration — JWT validation in Spring Security OAuth2 does not verify issuer, audience, or expiration. Severity: High. CWE: CWE-287.
- [ ] SC-JAVA-341: Spring @RequestParam injection — User input from @RequestParam is used directly in business logic without validation. Severity: Medium. CWE: CWE-20.
- [ ] SC-JAVA-342: Spring Boot admin console exposed — Spring Boot Admin console is accessible without authentication in production. Severity: High. CWE: CWE-306.
- [ ] SC-JAVA-343: Missing method-level security — Spring @PreAuthorize or @Secured annotations are not used on service layer methods. Severity: Medium. CWE: CWE-862.
- [ ] SC-JAVA-344: Spring WebFlux security bypass — Reactive security filters are incorrectly configured, allowing bypass in WebFlux applications. Severity: High. CWE: CWE-863.
- [ ] SC-JAVA-345: Spring H2 console exposed — The H2 database console is enabled and accessible in production, allowing SQL execution. Severity: Critical. CWE: CWE-489.
- [ ] SC-JAVA-346: Spring Security rememberMe weak key — The rememberMe key is a simple string or default value rather than a cryptographically random key. Severity: Medium. CWE: CWE-330.
- [ ] SC-JAVA-347: Spring Data JPA @Query injection — Spring Data @Query annotations use SpEL expressions with user-controlled input. Severity: High. CWE: CWE-89.
- [ ] SC-JAVA-348: Missing Spring Security headers configuration — Spring Security default security headers are disabled or overridden with weaker settings. Severity: Medium. CWE: CWE-693.
- [ ] SC-JAVA-349: Spring Batch job parameter injection — Job parameters from untrusted sources are used without validation in batch processing. Severity: Medium. CWE: CWE-20.
- [ ] SC-JAVA-350: Spring Gateway SSRF — Spring Cloud Gateway routes allow user-controlled upstream URLs, enabling SSRF. Severity: High. CWE: CWE-918.

### 17. Servlet & JSP-Specific (20 items)

- [ ] SC-JAVA-351: XSS in JSP via unescaped expression — JSP expressions (<%= %>) output user input without HTML encoding. Severity: High. CWE: CWE-79.
- [ ] SC-JAVA-352: Missing JSP auto-escaping — JSTL <c:out> or fn:escapeXml() is not used to render user-supplied data in JSP pages. Severity: High. CWE: CWE-79.
- [ ] SC-JAVA-353: Servlet parameter tampering — Servlet request parameters are used directly without validation in business logic. Severity: Medium. CWE: CWE-20.
- [ ] SC-JAVA-354: Servlet path traversal — HttpServletRequest.getPathInfo() is used to construct file paths without sanitization. Severity: High. CWE: CWE-22.
- [ ] SC-JAVA-355: Missing HttpOnly on custom cookies — Custom cookies set via HttpServletResponse.addCookie() lack the HttpOnly flag. Severity: Medium. CWE: CWE-1004.
- [ ] SC-JAVA-356: Servlet URL-based session tracking — Session tracking mode includes URL rewriting (encodeURL), embedding session IDs in links. Severity: Medium. CWE: CWE-384.
- [ ] SC-JAVA-357: JSP source exposure — JSP files are accessible via alternate URLs or casing tricks, exposing source code. Severity: High. CWE: CWE-538.
- [ ] SC-JAVA-358: Servlet HTTP method override — doGet() calls doPost() or vice versa, enabling method-based access control bypass. Severity: Medium. CWE: CWE-863.
- [ ] SC-JAVA-359: Missing Content-Type on servlet response — Servlet responses lack an explicit Content-Type header, enabling MIME confusion attacks. Severity: Medium. CWE: CWE-430.
- [ ] SC-JAVA-360: Filter chain ordering issue — Security filters are registered in the wrong order, allowing requests to bypass checks. Severity: High. CWE: CWE-863.
- [ ] SC-JAVA-361: Servlet multipart handling without limits — Multipart request parsing has no file count or total size limit configured. Severity: Medium. CWE: CWE-770.
- [ ] SC-JAVA-362: JSP include injection — User input controls the page attribute of <jsp:include>, enabling local file inclusion. Severity: High. CWE: CWE-98.
- [ ] SC-JAVA-363: Missing servlet security constraints in web.xml — web.xml does not define <security-constraint> elements for protected resources. Severity: Medium. CWE: CWE-862.
- [ ] SC-JAVA-364: Servlet cookie without path restriction — Cookies are set without a Path attribute, making them sent to all application paths. Severity: Low. CWE: CWE-614.
- [ ] SC-JAVA-365: JSP scriptlet SQL query — SQL queries are executed directly in JSP scriptlets rather than in service/DAO layers. Severity: High. CWE: CWE-89.
- [ ] SC-JAVA-366: Servlet response splitting — Servlet response headers include user input without CRLF stripping. Severity: High. CWE: CWE-113.
- [ ] SC-JAVA-367: Missing web.xml transport guarantee — The <transport-guarantee> is not set to CONFIDENTIAL, allowing HTTP access to protected resources. Severity: Medium. CWE: CWE-319.
- [ ] SC-JAVA-368: Servlet async context security bypass — Async servlet processing does not propagate security context to async threads. Severity: High. CWE: CWE-862.
- [ ] SC-JAVA-369: JSP tag library code injection — Custom JSP tag libraries execute dynamic code based on user-controlled attributes. Severity: High. CWE: CWE-94.
- [ ] SC-JAVA-370: Servlet request dispatcher path traversal — RequestDispatcher.forward() or include() uses user input to determine the target path. Severity: High. CWE: CWE-22.

### 18. API Security (20 items)

- [ ] SC-JAVA-371: Missing API authentication — API endpoints are accessible without any authentication mechanism. Severity: Critical. CWE: CWE-306.
- [ ] SC-JAVA-372: API key transmitted in URL — API keys are passed in query string parameters where they appear in logs and browser history. Severity: Medium. CWE: CWE-598.
- [ ] SC-JAVA-373: Missing API rate limiting — API endpoints lack throttling, enabling abuse and resource exhaustion. Severity: Medium. CWE: CWE-770.
- [ ] SC-JAVA-374: GraphQL query depth not limited — GraphQL API does not restrict query depth, enabling expensive recursive queries. Severity: Medium. CWE: CWE-400.
- [ ] SC-JAVA-375: GraphQL batch query abuse — GraphQL allows unbounded batched queries that can exhaust server resources. Severity: Medium. CWE: CWE-400.
- [ ] SC-JAVA-376: Missing API input validation — API request payloads are not validated against a schema before processing. Severity: Medium. CWE: CWE-20.
- [ ] SC-JAVA-377: Excessive data in API response — API responses include more fields than the client needs, exposing sensitive internal data. Severity: Medium. CWE: CWE-200.
- [ ] SC-JAVA-378: Missing API versioning — No API version strategy is in place, making it difficult to deprecate insecure endpoints. Severity: Low. CWE: CWE-693.
- [ ] SC-JAVA-379: Swagger/OpenAPI exposed in production — API documentation endpoints (Swagger UI) are accessible in production without authentication. Severity: Medium. CWE: CWE-200.
- [ ] SC-JAVA-380: Missing request body size limit on API — API endpoints accept arbitrarily large request bodies. Severity: Medium. CWE: CWE-770.
- [ ] SC-JAVA-381: Insecure gRPC channel — gRPC channels use plaintext instead of TLS. Severity: High. CWE: CWE-319.
- [ ] SC-JAVA-382: Missing gRPC authentication — gRPC services lack interceptors for authentication and authorization. Severity: High. CWE: CWE-306.
- [ ] SC-JAVA-383: REST API mass assignment — REST API endpoints bind request bodies directly to entity objects, allowing field manipulation. Severity: High. CWE: CWE-915.
- [ ] SC-JAVA-384: Missing pagination on list endpoints — API list endpoints return unbounded result sets, enabling DoS through large data retrieval. Severity: Medium. CWE: CWE-770.
- [ ] SC-JAVA-385: API IDOR vulnerability — API endpoints use sequential or predictable IDs without verifying the caller's ownership. Severity: High. CWE: CWE-639.
- [ ] SC-JAVA-386: Missing API response security headers — API responses lack security headers such as X-Content-Type-Options and Cache-Control. Severity: Low. CWE: CWE-693.
- [ ] SC-JAVA-387: Insecure API webhook validation — Incoming webhooks are processed without verifying the sender's signature. Severity: High. CWE: CWE-345.
- [ ] SC-JAVA-388: API token in logs — API authentication tokens are logged in request or debug logs. Severity: High. CWE: CWE-532.
- [ ] SC-JAVA-389: Missing HATEOAS link validation — Hypermedia links in API responses point to untrusted or user-controlled URLs. Severity: Medium. CWE: CWE-601.
- [ ] SC-JAVA-390: Insecure API error responses — API error responses include internal details, stack traces, or database error messages. Severity: Medium. CWE: CWE-209.

### 19. Testing & CI/CD Security (15 items)

- [ ] SC-JAVA-391: Test credentials in source code — Hard-coded test credentials exist that could be used against production systems. Severity: High. CWE: CWE-798.
- [ ] SC-JAVA-392: Missing SAST in CI pipeline — The CI/CD pipeline does not include static application security testing. Severity: Medium. CWE: CWE-693.
- [ ] SC-JAVA-393: Missing DAST in CI pipeline — No dynamic security testing is performed against deployed test environments. Severity: Medium. CWE: CWE-693.
- [ ] SC-JAVA-394: Test code in production build — Test classes or test utilities are included in production artifacts. Severity: Medium. CWE: CWE-489.
- [ ] SC-JAVA-395: Insecure CI/CD pipeline secrets — CI/CD pipeline secrets are stored in plaintext configuration rather than secret management. Severity: High. CWE: CWE-798.
- [ ] SC-JAVA-396: Missing container image scanning — Docker images are not scanned for vulnerabilities before deployment. Severity: Medium. CWE: CWE-1395.
- [ ] SC-JAVA-397: Privileged Docker container — The application container runs as root or with elevated privileges. Severity: High. CWE: CWE-250.
- [ ] SC-JAVA-398: Missing security regression tests — There are no automated tests to verify security controls against known vulnerability patterns. Severity: Medium. CWE: CWE-693.
- [ ] SC-JAVA-399: Unsigned build artifacts — Built JAR/WAR artifacts are not signed, allowing post-build tampering. Severity: Medium. CWE: CWE-353.
- [ ] SC-JAVA-400: Missing infrastructure as code scanning — Terraform, CloudFormation, or Kubernetes manifests are not scanned for security issues. Severity: Medium. CWE: CWE-1395.
- [ ] SC-JAVA-401: CI/CD pipeline code injection — Pipeline configuration files allow injection through unescaped variables or user-controlled inputs. Severity: High. CWE: CWE-94.
- [ ] SC-JAVA-402: Missing branch protection — The main branch does not require code review or passing CI before merge. Severity: Medium. CWE: CWE-693.
- [ ] SC-JAVA-403: Test database with production data — Test environments use copies of production data without anonymization. Severity: High. CWE: CWE-200.
- [ ] SC-JAVA-404: Insecure artifact repository — Build artifacts are published to a repository accessible without authentication. Severity: Medium. CWE: CWE-306.
- [ ] SC-JAVA-405: Missing code signing for releases — Release artifacts are not digitally signed, making integrity verification impossible. Severity: Medium. CWE: CWE-353.

### 20. Third-Party Integration Security (15 items)

- [ ] SC-JAVA-406: Third-party API key hardcoded — API keys for external services are embedded in source code. Severity: Critical. CWE: CWE-798.
- [ ] SC-JAVA-407: Missing TLS on third-party API calls — Calls to external services use HTTP instead of HTTPS. Severity: High. CWE: CWE-319.
- [ ] SC-JAVA-408: Unvalidated third-party response — Data received from external APIs is used without validation or sanitization. Severity: Medium. CWE: CWE-20.
- [ ] SC-JAVA-409: Missing timeout on third-party calls — HTTP clients for external services have no connection or read timeout. Severity: Medium. CWE: CWE-400.
- [ ] SC-JAVA-410: Missing circuit breaker for external services — No circuit breaker pattern is used, allowing cascading failures from external service outages. Severity: Medium. CWE: CWE-400.
- [ ] SC-JAVA-411: Third-party JavaScript included without SRI — External JavaScript resources are loaded without Subresource Integrity hashes. Severity: Medium. CWE: CWE-353.
- [ ] SC-JAVA-412: OAuth2 token stored insecurely — Third-party OAuth2 tokens are stored in plaintext in the database or in client-side storage. Severity: High. CWE: CWE-312.
- [ ] SC-JAVA-413: Missing third-party webhook signature validation — Webhooks from external services are accepted without verifying HMAC signatures. Severity: High. CWE: CWE-345.
- [ ] SC-JAVA-414: Insecure SMTP configuration — Email is sent via SMTP without TLS (STARTTLS), transmitting content in cleartext. Severity: Medium. CWE: CWE-319.
- [ ] SC-JAVA-415: Missing email injection prevention — User input in email headers (To, CC, BCC, Subject) is not sanitized against header injection. Severity: Medium. CWE: CWE-93.
- [ ] SC-JAVA-416: Third-party SDK outdated — An external SDK dependency has known vulnerabilities and is not updated. Severity: High. CWE: CWE-1395.
- [ ] SC-JAVA-417: Insecure SSO integration — Single Sign-On integration does not validate SAML assertions or JWT tokens properly. Severity: High. CWE: CWE-287.
- [ ] SC-JAVA-418: Payment gateway data exposure — Sensitive payment data is logged or stored during third-party payment processing. Severity: Critical. CWE: CWE-312.
- [ ] SC-JAVA-419: Cloud storage bucket misconfiguration — Cloud storage integration uses publicly accessible buckets for sensitive data. Severity: Critical. CWE: CWE-276.
- [ ] SC-JAVA-420: Missing third-party API error handling — Errors from external API calls are not handled gracefully, leaking internal details or causing crashes. Severity: Medium. CWE: CWE-755.
