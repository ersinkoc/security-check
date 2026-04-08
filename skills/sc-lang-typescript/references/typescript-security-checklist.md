# TypeScript/JavaScript Security Checklist

> 415+ security checks for TypeScript and JavaScript applications.
> Used by security-check sc-lang-typescript skill as reference.

## How to Use
This checklist is automatically referenced by the sc-lang-typescript skill during security scans. It can also be used manually during code review.

## Categories

### 1. Input Validation & Sanitization (25 items)
- [ ] SC-TS-001: Unsanitized user input in HTML rendering — User-controlled data inserted into HTML without escaping enables cross-site scripting (XSS). Severity: Critical. CWE: CWE-79.
- [ ] SC-TS-002: Missing input length validation — Accepting arbitrarily long strings without length limits can lead to denial of service or buffer-related issues. Severity: Medium. CWE: CWE-20.
- [ ] SC-TS-003: Missing allowlist validation for enum-like inputs — Accepting arbitrary string values where only a fixed set is valid allows unexpected behavior. Severity: Medium. CWE: CWE-20.
- [ ] SC-TS-004: Inadequate URL validation — Accepting user-supplied URLs without scheme validation can lead to javascript: or data: protocol injection. Severity: High. CWE: CWE-79.
- [ ] SC-TS-005: Missing numeric range validation — Failing to validate numeric inputs against expected ranges can cause integer overflow or logic errors. Severity: Medium. CWE: CWE-190.
- [ ] SC-TS-006: Regex-based input validation bypass — Using improperly anchored regular expressions for validation allows attackers to bypass checks with newlines or extra characters. Severity: High. CWE: CWE-185.
- [ ] SC-TS-007: Server-side reliance on client-side validation — Trusting client-side validation without server-side re-validation allows attackers to bypass all input checks. Severity: High. CWE: CWE-602.
- [ ] SC-TS-008: ReDoS in input validation patterns — Using vulnerable regular expressions with catastrophic backtracking on user input causes denial of service. Severity: High. CWE: CWE-1333.
- [ ] SC-TS-009: Missing content-type validation on file uploads — Accepting uploaded files without validating MIME type and file extension allows malicious file uploads. Severity: High. CWE: CWE-434.
- [ ] SC-TS-010: Insufficient email validation — Using weak regex for email validation that can be bypassed or causes ReDoS. Severity: Medium. CWE: CWE-20.
- [ ] SC-TS-011: Unvalidated redirect targets — Using user-supplied values in redirect URLs without validation enables open redirect attacks. Severity: Medium. CWE: CWE-601.
- [ ] SC-TS-012: HTML injection via template literals — Constructing HTML strings using template literals with unsanitized variables allows injection. Severity: High. CWE: CWE-79.
- [ ] SC-TS-013: Missing array input bounds checking — Accepting arrays from user input without length limits can cause excessive memory consumption. Severity: Medium. CWE: CWE-400.
- [ ] SC-TS-014: Path traversal in user-supplied filenames — Using user-controlled file paths without normalizing and validating against a base directory allows directory traversal. Severity: Critical. CWE: CWE-22.
- [ ] SC-TS-015: Unvalidated JSON schema — Parsing JSON from untrusted sources without schema validation allows unexpected data structures. Severity: Medium. CWE: CWE-20.
- [ ] SC-TS-016: DOM-based XSS via document.location — Reading from document.location and inserting into the DOM without sanitization enables XSS. Severity: High. CWE: CWE-79.
- [ ] SC-TS-017: XSS via innerHTML assignment — Setting innerHTML with user-controlled data executes embedded scripts. Severity: Critical. CWE: CWE-79.
- [ ] SC-TS-018: Missing validation of nested object properties — Deeply nested user input objects not validated at each level can carry malicious payloads. Severity: Medium. CWE: CWE-20.
- [ ] SC-TS-019: Unicode normalization bypass — Failing to normalize Unicode input before validation allows homoglyph and encoding attacks. Severity: Medium. CWE: CWE-176.
- [ ] SC-TS-020: Null byte injection in input strings — Accepting null bytes in strings can truncate validation logic in downstream C-based libraries. Severity: High. CWE: CWE-158.
- [ ] SC-TS-021: SSRF via user-supplied URLs — Passing user-controlled URLs to server-side HTTP requests without validating against internal networks enables SSRF. Severity: Critical. CWE: CWE-918.
- [ ] SC-TS-022: Unvalidated query parameter types — Trusting query parameter types without explicit coercion can cause type confusion (e.g., arrays instead of strings). Severity: Medium. CWE: CWE-20.
- [ ] SC-TS-023: DOM clobbering via user-controlled HTML IDs — Allowing user input in HTML id attributes can override JavaScript globals via DOM clobbering. Severity: High. CWE: CWE-79.
- [ ] SC-TS-024: Header injection via user input — Including unsanitized user data in HTTP response headers enables header injection or response splitting. Severity: High. CWE: CWE-113.
- [ ] SC-TS-025: Missing validation of base64-encoded input — Decoding and using base64-encoded user input without validating the decoded content allows smuggling of malicious payloads. Severity: Medium. CWE: CWE-20.

### 2. Authentication & Session Management (20 items)
- [ ] SC-TS-026: Storing passwords in plaintext — Saving user passwords without hashing allows mass credential compromise on data breach. Severity: Critical. CWE: CWE-256.
- [ ] SC-TS-027: Using weak hashing algorithms for passwords — Employing MD5 or SHA-1 for password hashing instead of bcrypt/scrypt/argon2 enables brute-force attacks. Severity: Critical. CWE: CWE-328.
- [ ] SC-TS-028: Missing rate limiting on authentication endpoints — Not throttling login attempts allows credential brute-forcing. Severity: High. CWE: CWE-307.
- [ ] SC-TS-029: Session fixation vulnerability — Not regenerating session IDs after successful authentication allows session fixation attacks. Severity: High. CWE: CWE-384.
- [ ] SC-TS-030: JWT stored in localStorage — Storing JWTs in localStorage makes them accessible to XSS attacks instead of using httpOnly cookies. Severity: High. CWE: CWE-922.
- [ ] SC-TS-031: JWT signature not verified — Accepting JWTs without verifying the signature allows token forgery. Severity: Critical. CWE: CWE-347.
- [ ] SC-TS-032: JWT algorithm confusion attack — Not restricting allowed JWT algorithms enables attackers to switch from RS256 to HS256 using the public key as secret. Severity: Critical. CWE: CWE-327.
- [ ] SC-TS-033: Missing session expiration — Sessions that never expire allow indefinite access from stolen session tokens. Severity: High. CWE: CWE-613.
- [ ] SC-TS-034: Insecure session cookie flags — Session cookies missing Secure, HttpOnly, or SameSite flags are vulnerable to interception and XSS. Severity: High. CWE: CWE-614.
- [ ] SC-TS-035: Credential exposure in URL parameters — Passing authentication tokens or passwords as URL query parameters causes them to appear in logs and referer headers. Severity: High. CWE: CWE-598.
- [ ] SC-TS-036: Missing multi-factor authentication for sensitive actions — Not requiring MFA for critical operations allows account takeover from single-factor compromise. Severity: Medium. CWE: CWE-308.
- [ ] SC-TS-037: Predictable session tokens — Generating session identifiers with insufficient randomness enables session prediction attacks. Severity: Critical. CWE: CWE-330.
- [ ] SC-TS-038: Missing account lockout mechanism — Not locking accounts after repeated failed attempts allows unlimited credential guessing. Severity: Medium. CWE: CWE-307.
- [ ] SC-TS-039: Username enumeration via error messages — Different error messages for invalid usernames vs. invalid passwords reveals valid accounts. Severity: Medium. CWE: CWE-203.
- [ ] SC-TS-040: Insecure password reset flow — Password reset tokens that are predictable, don't expire, or lack single-use enforcement allow unauthorized resets. Severity: High. CWE: CWE-640.
- [ ] SC-TS-041: Missing session invalidation on logout — Not destroying server-side sessions on logout allows continued use of stolen session tokens. Severity: Medium. CWE: CWE-613.
- [ ] SC-TS-042: OAuth state parameter missing — Not using the state parameter in OAuth flows enables CSRF-based account linking attacks. Severity: High. CWE: CWE-352.
- [ ] SC-TS-043: Refresh token rotation not implemented — Reusing refresh tokens without rotation fails to detect token theft. Severity: Medium. CWE: CWE-613.
- [ ] SC-TS-044: JWT with none algorithm accepted — Accepting JWTs signed with the "none" algorithm allows any user to forge tokens. Severity: Critical. CWE: CWE-327.
- [ ] SC-TS-045: Sensitive data in JWT payload without encryption — Storing PII or secrets in JWT claims without JWE encryption exposes data to anyone possessing the token. Severity: Medium. CWE: CWE-311.

### 3. Authorization & Access Control (20 items)
- [ ] SC-TS-046: Missing authorization checks on API endpoints — Endpoints that lack authorization middleware allow unauthorized access to protected resources. Severity: Critical. CWE: CWE-862.
- [ ] SC-TS-047: Insecure direct object reference (IDOR) — Using user-supplied IDs to access resources without verifying ownership allows horizontal privilege escalation. Severity: High. CWE: CWE-639.
- [ ] SC-TS-048: Broken function-level authorization — Not checking roles or permissions at the function level allows vertical privilege escalation. Severity: Critical. CWE: CWE-285.
- [ ] SC-TS-049: Client-side authorization checks only — Performing authorization only in the frontend without backend enforcement allows bypass via API calls. Severity: Critical. CWE: CWE-602.
- [ ] SC-TS-050: Privilege escalation via mass assignment — Accepting user-controlled fields like role or isAdmin without allowlisting allows privilege escalation. Severity: Critical. CWE: CWE-915.
- [ ] SC-TS-051: Missing row-level security in database queries — Querying data without filtering by the authenticated user's scope leaks data from other tenants. Severity: High. CWE: CWE-863.
- [ ] SC-TS-052: Path-based authorization bypass — Inconsistent path normalization in authorization middleware allows bypass via encoded slashes or dot segments. Severity: High. CWE: CWE-22.
- [ ] SC-TS-053: CORS misconfiguration allowing unauthorized origins — Setting Access-Control-Allow-Origin to wildcard or reflecting arbitrary origins with credentials enabled leaks data cross-origin. Severity: High. CWE: CWE-942.
- [ ] SC-TS-054: Missing re-authentication for sensitive operations — Not requiring password confirmation for critical actions (password change, deletion) allows unauthorized modifications. Severity: Medium. CWE: CWE-306.
- [ ] SC-TS-055: Horizontal privilege escalation via API parameter tampering — Allowing users to specify other users' identifiers in API requests without ownership verification. Severity: High. CWE: CWE-639.
- [ ] SC-TS-056: Overly permissive default roles — Granting new users excessive permissions by default violates the principle of least privilege. Severity: Medium. CWE: CWE-276.
- [ ] SC-TS-057: GraphQL authorization bypass — Missing authorization checks on individual GraphQL resolvers allows data access through nested queries. Severity: High. CWE: CWE-862.
- [ ] SC-TS-058: Directory listing enabled — Serving directory listings from static file servers exposes internal file structure. Severity: Medium. CWE: CWE-548.
- [ ] SC-TS-059: Missing CSRF protection — Mutable operations without CSRF tokens or SameSite cookies allow cross-site request forgery. Severity: High. CWE: CWE-352.
- [ ] SC-TS-060: WebSocket authorization bypass — Not re-validating authorization on each WebSocket message after initial handshake allows unauthorized actions. Severity: High. CWE: CWE-862.
- [ ] SC-TS-061: Tenant isolation failure in multi-tenant apps — Not scoping all database queries and file operations to the current tenant leaks cross-tenant data. Severity: Critical. CWE: CWE-863.
- [ ] SC-TS-062: Feature flag authorization bypass — Not authorizing feature flag access allows users to enable restricted features by manipulating requests. Severity: Medium. CWE: CWE-862.
- [ ] SC-TS-063: Admin panel accessible without additional authentication — Admin interfaces reachable without enhanced authentication or network restrictions. Severity: High. CWE: CWE-306.
- [ ] SC-TS-064: Missing HTTP method restriction — Allowing unintended HTTP methods (PUT, DELETE) on endpoints that only expect GET/POST. Severity: Medium. CWE: CWE-749.
- [ ] SC-TS-065: Inconsistent authorization between REST and GraphQL — Different authorization logic for the same resources across different API interfaces. Severity: High. CWE: CWE-863.

### 4. Cryptography (20 items)
- [ ] SC-TS-066: Using Math.random for security-sensitive operations — Math.random is not cryptographically secure and must not be used for tokens, secrets, or nonces. Severity: Critical. CWE: CWE-338.
- [ ] SC-TS-067: Hardcoded encryption keys — Embedding encryption keys directly in source code makes them extractable and unrotatable. Severity: Critical. CWE: CWE-321.
- [ ] SC-TS-068: Use of deprecated cryptographic algorithms — Using DES, RC4, MD5, or SHA-1 for cryptographic purposes provides inadequate security. Severity: High. CWE: CWE-327.
- [ ] SC-TS-069: Missing IV/nonce in symmetric encryption — Reusing or omitting initialization vectors in AES-CBC or nonces in AES-GCM breaks confidentiality. Severity: High. CWE: CWE-329.
- [ ] SC-TS-070: ECB mode used for block cipher — Using ECB mode reveals patterns in encrypted data due to identical plaintext blocks producing identical ciphertext. Severity: High. CWE: CWE-327.
- [ ] SC-TS-071: Insufficient key length — Using encryption keys shorter than recommended minimums (e.g., 128-bit AES, 2048-bit RSA) weakens protection. Severity: High. CWE: CWE-326.
- [ ] SC-TS-072: Missing HMAC or authenticated encryption — Encrypting without authentication (e.g., AES-CBC without HMAC) allows ciphertext tampering. Severity: High. CWE: CWE-353.
- [ ] SC-TS-073: Timing attack in comparison operations — Using === for comparing secrets, tokens, or hashes leaks information via timing differences; use crypto.timingSafeEqual. Severity: Medium. CWE: CWE-208.
- [ ] SC-TS-074: Private keys in source control — Committing private keys, certificates, or PEM files to version control exposes them to all repository viewers. Severity: Critical. CWE: CWE-312.
- [ ] SC-TS-075: Insufficient password hashing work factor — Using bcrypt/scrypt/argon2 with too-low cost parameters allows faster brute-force attacks. Severity: Medium. CWE: CWE-916.
- [ ] SC-TS-076: Predictable salt for password hashing — Using static or predictable salts defeats the purpose of salting and enables rainbow table attacks. Severity: High. CWE: CWE-760.
- [ ] SC-TS-077: Using Web Crypto API incorrectly — Misusing SubtleCrypto methods with wrong parameters or ignoring returned Promises leads to weak cryptography. Severity: High. CWE: CWE-327.
- [ ] SC-TS-078: TLS certificate validation disabled — Setting rejectUnauthorized to false in HTTPS requests disables certificate verification and enables MITM. Severity: Critical. CWE: CWE-295.
- [ ] SC-TS-079: Weak random token generation — Generating password reset or verification tokens with insufficient entropy allows prediction. Severity: High. CWE: CWE-330.
- [ ] SC-TS-080: Missing encryption for data at rest — Storing sensitive data (PII, financial records) without encryption violates data protection requirements. Severity: High. CWE: CWE-311.
- [ ] SC-TS-081: Exposed cryptographic error details — Returning detailed cryptographic error messages helps attackers craft padding oracle or other attacks. Severity: Medium. CWE: CWE-209.
- [ ] SC-TS-082: Key derivation without proper KDF — Deriving encryption keys from passwords without PBKDF2, scrypt, or argon2 produces weak keys. Severity: High. CWE: CWE-916.
- [ ] SC-TS-083: Nonce reuse in stream ciphers — Reusing nonces with ChaCha20 or AES-CTR completely breaks confidentiality. Severity: Critical. CWE: CWE-323.
- [ ] SC-TS-084: Using custom cryptographic implementations — Writing custom encryption algorithms instead of using established libraries introduces vulnerabilities. Severity: High. CWE: CWE-327.
- [ ] SC-TS-085: Symmetric key transmitted alongside encrypted data — Sending the encryption key with the ciphertext renders encryption useless. Severity: Critical. CWE: CWE-312.

### 5. Error Handling & Logging (20 items)
- [ ] SC-TS-086: Stack traces exposed to users — Returning stack traces in API responses reveals internal paths, library versions, and code structure. Severity: Medium. CWE: CWE-209.
- [ ] SC-TS-087: Sensitive data in error messages — Including database queries, credentials, or PII in error responses leaks confidential information. Severity: High. CWE: CWE-209.
- [ ] SC-TS-088: Missing global error handler — Unhandled exceptions crashing the process without cleanup can cause data corruption and downtime. Severity: Medium. CWE: CWE-755.
- [ ] SC-TS-089: Logging sensitive data — Writing passwords, tokens, credit card numbers, or PII to log files creates additional exposure surfaces. Severity: High. CWE: CWE-532.
- [ ] SC-TS-090: Missing error handling on async operations — Unhandled Promise rejections can crash Node.js processes or leave resources in inconsistent states. Severity: Medium. CWE: CWE-755.
- [ ] SC-TS-091: Verbose error messages in production — Detailed error messages in production mode help attackers understand application internals. Severity: Medium. CWE: CWE-209.
- [ ] SC-TS-092: Log injection — User input included in log entries without sanitization allows log forging and SIEM evasion. Severity: Medium. CWE: CWE-117.
- [ ] SC-TS-093: Missing audit logging for security events — Not logging authentication failures, authorization denials, and privilege changes hinders incident response. Severity: Medium. CWE: CWE-778.
- [ ] SC-TS-094: Error handling reveals database schema — Database error messages exposing table names, column names, or query structure aid SQL injection attacks. Severity: Medium. CWE: CWE-209.
- [ ] SC-TS-095: Catching and silencing all errors — Blanket catch blocks that swallow exceptions hide security-relevant failures. Severity: Medium. CWE: CWE-390.
- [ ] SC-TS-096: Missing request ID in logs — Not correlating logs with unique request identifiers makes tracing security incidents difficult. Severity: Low. CWE: CWE-778.
- [ ] SC-TS-097: Unhandled process signals — Not handling SIGTERM/SIGINT properly can leave connections open or data uncommitted during shutdown. Severity: Low. CWE: CWE-755.
- [ ] SC-TS-098: Exception-based information disclosure in APIs — Different exception types producing different HTTP status codes reveals internal logic to attackers. Severity: Low. CWE: CWE-203.
- [ ] SC-TS-099: Log files without access controls — Log files readable by unauthorized users expose sensitive operational data. Severity: Medium. CWE: CWE-532.
- [ ] SC-TS-100: Missing rate limiting on error-triggering endpoints — Endpoints that produce costly errors without throttling allow resource exhaustion attacks. Severity: Medium. CWE: CWE-400.
- [ ] SC-TS-101: Uncaught exception in Express middleware — Synchronous exceptions in Express middleware without try-catch crash the process. Severity: Medium. CWE: CWE-755.
- [ ] SC-TS-102: console.log used for production logging — Using console.log instead of a structured logging library prevents proper log management and can leak data. Severity: Low. CWE: CWE-532.
- [ ] SC-TS-103: Missing log rotation — Unbounded log growth can fill disk and cause denial of service. Severity: Low. CWE: CWE-400.
- [ ] SC-TS-104: Error object serialization leaking internal details — JSON.stringify on Error objects may include stack, message, and custom properties in API responses. Severity: Medium. CWE: CWE-209.
- [ ] SC-TS-105: Missing centralized error handling middleware — Scattered error handling logic leads to inconsistent security posture across endpoints. Severity: Low. CWE: CWE-755.

### 6. Data Protection & Privacy (20 items)
- [ ] SC-TS-106: PII stored without encryption — Personal identifiable information stored in plaintext in databases or files violates data protection regulations. Severity: High. CWE: CWE-312.
- [ ] SC-TS-107: Sensitive data in client-side storage — Storing secrets, tokens, or PII in localStorage or sessionStorage exposes them to XSS attacks. Severity: High. CWE: CWE-922.
- [ ] SC-TS-108: Missing data classification — Not categorizing data by sensitivity level leads to inadequate protection of critical information. Severity: Medium. CWE: CWE-200.
- [ ] SC-TS-109: Data leakage via browser autocomplete — Not disabling autocomplete on sensitive form fields allows browsers to cache credentials and PII. Severity: Low. CWE: CWE-200.
- [ ] SC-TS-110: Sensitive data in URL parameters — Including PII or secrets in URLs causes them to be logged in server logs, browser history, and analytics. Severity: High. CWE: CWE-598.
- [ ] SC-TS-111: Missing data retention policies — Retaining user data indefinitely without cleanup violates privacy regulations and increases breach impact. Severity: Medium. CWE: CWE-212.
- [ ] SC-TS-112: Exposing internal IDs to clients — Using auto-increment database IDs in APIs reveals record counts and allows enumeration. Severity: Low. CWE: CWE-200.
- [ ] SC-TS-113: Cache poisoning with sensitive data — Caching responses containing user-specific sensitive data in shared caches exposes them to other users. Severity: High. CWE: CWE-524.
- [ ] SC-TS-114: Missing Content-Security-Policy header — Absence of CSP allows unrestricted script execution, increasing XSS impact. Severity: Medium. CWE: CWE-1021.
- [ ] SC-TS-115: Cross-origin data leakage via postMessage — Using postMessage without verifying targetOrigin or event.origin enables data theft across origins. Severity: High. CWE: CWE-346.
- [ ] SC-TS-116: Clipboard data exposure — Automatically copying sensitive data to the clipboard makes it accessible to other applications. Severity: Low. CWE: CWE-200.
- [ ] SC-TS-117: Missing data masking in logs and displays — Showing full credit card numbers, SSNs, or phone numbers instead of masked versions. Severity: Medium. CWE: CWE-200.
- [ ] SC-TS-118: Unencrypted data in transit — Transmitting sensitive data over HTTP instead of HTTPS allows network interception. Severity: High. CWE: CWE-319.
- [ ] SC-TS-119: Service worker caching sensitive responses — Caching API responses containing sensitive data in service workers persists them on disk. Severity: Medium. CWE: CWE-524.
- [ ] SC-TS-120: Missing Referrer-Policy header — Sending full URL in Referer header to external sites can leak sensitive path information. Severity: Low. CWE: CWE-200.
- [ ] SC-TS-121: Sensitive data in browser performance entries — Performance API entries may expose sensitive URL patterns and timing information. Severity: Low. CWE: CWE-200.
- [ ] SC-TS-122: Client-side data not cleared on logout — Not clearing localStorage, sessionStorage, IndexedDB, and cookies on logout leaves data accessible. Severity: Medium. CWE: CWE-212.
- [ ] SC-TS-123: Excessive data returned by APIs — Returning full database records instead of the minimal required fields exposes unnecessary sensitive data. Severity: Medium. CWE: CWE-200.
- [ ] SC-TS-124: Missing data anonymization for analytics — Sending identifiable user data to analytics services without anonymization violates privacy. Severity: Medium. CWE: CWE-359.
- [ ] SC-TS-125: Memory not cleared after processing secrets — Sensitive values remaining in memory after use can be extracted via heap dumps or core dumps. Severity: Low. CWE: CWE-316.

### 7. SQL/NoSQL/ORM Security (20 items)
- [ ] SC-TS-126: SQL injection via string concatenation — Building SQL queries by concatenating user input enables arbitrary SQL execution. Severity: Critical. CWE: CWE-89.
- [ ] SC-TS-127: NoSQL injection in MongoDB queries — Passing user-controlled objects directly to MongoDB query operators ($gt, $ne, $where) allows query manipulation. Severity: Critical. CWE: CWE-943.
- [ ] SC-TS-128: Prisma raw query injection — Using Prisma.$queryRawUnsafe or $executeRawUnsafe with string concatenation enables SQL injection. Severity: Critical. CWE: CWE-89.
- [ ] SC-TS-129: Drizzle ORM raw SQL injection — Using sql.raw() in Drizzle with unsanitized user input creates injection vulnerabilities. Severity: Critical. CWE: CWE-89.
- [ ] SC-TS-130: TypeORM query builder injection — Using TypeORM's createQueryBuilder with string interpolation in where clauses enables SQL injection. Severity: Critical. CWE: CWE-89.
- [ ] SC-TS-131: Sequelize literal injection — Using Sequelize.literal() with user-supplied data allows arbitrary SQL execution. Severity: Critical. CWE: CWE-89.
- [ ] SC-TS-132: Knex raw query injection — Using knex.raw() with string concatenation instead of parameterized bindings enables SQL injection. Severity: Critical. CWE: CWE-89.
- [ ] SC-TS-133: MongoDB $where operator with user input — Passing user-controlled strings to the $where operator enables server-side JavaScript injection. Severity: Critical. CWE: CWE-943.
- [ ] SC-TS-134: GraphQL query depth not limited — Allowing deeply nested GraphQL queries without depth limiting enables denial of service via resource exhaustion. Severity: High. CWE: CWE-400.
- [ ] SC-TS-135: Missing database connection encryption — Connecting to databases without TLS encryption exposes credentials and data in transit. Severity: High. CWE: CWE-319.
- [ ] SC-TS-136: Database credentials in source code — Hardcoding database connection strings with credentials in application code. Severity: Critical. CWE: CWE-798.
- [ ] SC-TS-137: Missing parameterized queries — Using template literals or string concatenation instead of parameterized queries in any database driver. Severity: Critical. CWE: CWE-89.
- [ ] SC-TS-138: ORM mass assignment vulnerability — Passing user request body directly to ORM create/update methods allows setting unintended fields. Severity: High. CWE: CWE-915.
- [ ] SC-TS-139: Second-order SQL injection — Storing user input in the database and later using it unsanitized in a SQL query. Severity: High. CWE: CWE-89.
- [ ] SC-TS-140: Missing database query timeout — Queries without timeouts can be abused for denial of service by triggering long-running operations. Severity: Medium. CWE: CWE-400.
- [ ] SC-TS-141: Excessive database permissions — Application database user having DDL or admin privileges beyond what is required. Severity: Medium. CWE: CWE-250.
- [ ] SC-TS-142: Redis injection via unsanitized input — Constructing Redis commands with user input allows injection of arbitrary Redis operations. Severity: High. CWE: CWE-77.
- [ ] SC-TS-143: Elasticsearch query injection — Passing user input directly into Elasticsearch query DSL allows query manipulation and data extraction. Severity: High. CWE: CWE-943.
- [ ] SC-TS-144: Unescaped LIKE/SIMILAR TO wildcards — Not escaping % and _ characters in SQL LIKE clauses with user input allows pattern injection. Severity: Low. CWE: CWE-89.
- [ ] SC-TS-145: Missing connection pool limits — Not setting maximum connection pool sizes allows connection exhaustion DoS. Severity: Medium. CWE: CWE-400.

### 8. File Operations (20 items)
- [ ] SC-TS-146: Path traversal via user-controlled file paths — Using user input in fs.readFile/writeFile paths without validation allows reading/writing arbitrary files. Severity: Critical. CWE: CWE-22.
- [ ] SC-TS-147: Unrestricted file upload size — Accepting arbitrarily large file uploads without size limits causes disk exhaustion or memory overflow. Severity: High. CWE: CWE-400.
- [ ] SC-TS-148: File type validation by extension only — Checking only the file extension without validating file content (magic bytes) allows extension spoofing. Severity: Medium. CWE: CWE-434.
- [ ] SC-TS-149: Symlink following vulnerability — Following symbolic links during file operations allows access to files outside the intended directory. Severity: High. CWE: CWE-59.
- [ ] SC-TS-150: Uploaded file stored with original filename — Using user-supplied filenames without sanitization can lead to path traversal or file overwriting. Severity: High. CWE: CWE-22.
- [ ] SC-TS-151: Temporary file created with predictable name — Creating temp files with predictable names in shared directories enables symlink attacks. Severity: Medium. CWE: CWE-377.
- [ ] SC-TS-152: Missing file permission restrictions — Creating files with world-readable permissions exposes sensitive content to other system users. Severity: Medium. CWE: CWE-732.
- [ ] SC-TS-153: ZIP extraction path traversal (Zip Slip) — Extracting ZIP archives without validating entry paths allows writing files outside the target directory. Severity: Critical. CWE: CWE-22.
- [ ] SC-TS-154: Server-side file inclusion via user input — Using user-controlled paths in require() or dynamic import() enables arbitrary code execution. Severity: Critical. CWE: CWE-98.
- [ ] SC-TS-155: Uploaded executable files served to users — Not preventing upload or serving of .exe, .sh, .bat, or other executable formats. Severity: High. CWE: CWE-434.
- [ ] SC-TS-156: Static file directory escape — Misconfigured static file serving middleware that allows access outside the designated public directory. Severity: High. CWE: CWE-22.
- [ ] SC-TS-157: SVG file upload XSS — Accepting SVG uploads without sanitization allows embedded JavaScript execution when served inline. Severity: High. CWE: CWE-79.
- [ ] SC-TS-158: File deletion via user-controlled path — Allowing user input to determine file deletion targets without authorization and path validation. Severity: High. CWE: CWE-22.
- [ ] SC-TS-159: Race condition in file existence check — Using fs.existsSync followed by fs.readFile creates a TOCTOU race condition. Severity: Medium. CWE: CWE-367.
- [ ] SC-TS-160: Uploaded files stored in webroot — Placing uploaded files in publicly accessible directories without access controls. Severity: High. CWE: CWE-434.
- [ ] SC-TS-161: Missing antivirus scanning on uploads — Not scanning uploaded files for malware before processing or storing them. Severity: Medium. CWE: CWE-434.
- [ ] SC-TS-162: Resource exhaustion via file watcher — Creating unlimited file watchers (fs.watch) based on user input causes file descriptor exhaustion. Severity: Medium. CWE: CWE-400.
- [ ] SC-TS-163: Unvalidated file stream piping — Piping user-uploaded file streams directly into processing without size guards or timeout. Severity: Medium. CWE: CWE-400.
- [ ] SC-TS-164: Serving files with incorrect Content-Type — Setting wrong MIME types for served files can cause browsers to execute file content. Severity: Medium. CWE: CWE-430.
- [ ] SC-TS-165: Image processing library vulnerabilities — Processing user-uploaded images with unpatched libraries (sharp, jimp) that have known CVEs. Severity: High. CWE: CWE-676.

### 9. Network & HTTP Security (25 items)
- [ ] SC-TS-166: Missing HTTPS enforcement — Not redirecting HTTP to HTTPS or lacking HSTS headers allows man-in-the-middle attacks. Severity: High. CWE: CWE-319.
- [ ] SC-TS-167: Missing Strict-Transport-Security header — Without HSTS, browsers may connect over HTTP on subsequent visits despite initial HTTPS. Severity: Medium. CWE: CWE-319.
- [ ] SC-TS-168: Wildcard CORS configuration — Setting Access-Control-Allow-Origin to * with credentials allows cross-origin data theft. Severity: High. CWE: CWE-942.
- [ ] SC-TS-169: Missing X-Content-Type-Options header — Without nosniff, browsers may MIME-sniff responses into executable content types. Severity: Low. CWE: CWE-16.
- [ ] SC-TS-170: Missing X-Frame-Options header — Without frame restrictions, pages can be embedded in iframes for clickjacking attacks. Severity: Medium. CWE: CWE-1021.
- [ ] SC-TS-171: WebSocket connection without origin validation — Accepting WebSocket upgrades without checking the Origin header allows cross-site WebSocket hijacking. Severity: High. CWE: CWE-346.
- [ ] SC-TS-172: HTTP request smuggling — Inconsistent handling of Content-Length and Transfer-Encoding headers between proxy and application. Severity: High. CWE: CWE-444.
- [ ] SC-TS-173: DNS rebinding vulnerability — Not validating Host header allows DNS rebinding attacks against internal services. Severity: High. CWE: CWE-350.
- [ ] SC-TS-174: Missing request body size limit — Accepting arbitrarily large request bodies causes memory exhaustion denial of service. Severity: High. CWE: CWE-400.
- [ ] SC-TS-175: Server-side request forgery via HTTP client — Using user-controlled URLs in server-side HTTP requests (axios, fetch, got) without validation. Severity: Critical. CWE: CWE-918.
- [ ] SC-TS-176: Proxy header trust without validation — Trusting X-Forwarded-For, X-Forwarded-Proto without configuring trusted proxy allows IP spoofing. Severity: Medium. CWE: CWE-346.
- [ ] SC-TS-177: Missing rate limiting — Endpoints without rate limiting are vulnerable to abuse, scraping, and denial of service. Severity: Medium. CWE: CWE-770.
- [ ] SC-TS-178: Insecure HTTP redirect — Following redirects from HTTPS to HTTP in server-side requests leaks headers and credentials. Severity: Medium. CWE: CWE-319.
- [ ] SC-TS-179: WebSocket message size not limited — Accepting WebSocket frames of arbitrary size allows memory exhaustion attacks. Severity: Medium. CWE: CWE-400.
- [ ] SC-TS-180: Missing HTTP method override protection — Allowing X-HTTP-Method-Override header bypasses method-based access controls. Severity: Medium. CWE: CWE-749.
- [ ] SC-TS-181: Insecure cookie scope — Cookies with overly broad domain or path scope are sent to unintended subdomains or paths. Severity: Medium. CWE: CWE-1275.
- [ ] SC-TS-182: Missing Permissions-Policy header — Not restricting browser features (camera, microphone, geolocation) via Permissions-Policy. Severity: Low. CWE: CWE-16.
- [ ] SC-TS-183: Server banner information disclosure — HTTP response headers revealing server software, version, and framework details. Severity: Low. CWE: CWE-200.
- [ ] SC-TS-184: Exposed GraphQL introspection in production — Leaving GraphQL introspection enabled in production reveals the entire API schema. Severity: Medium. CWE: CWE-200.
- [ ] SC-TS-185: Missing timeout on outbound HTTP requests — Server-side HTTP requests without timeout can be used to exhaust connection pools and threads. Severity: Medium. CWE: CWE-400.
- [ ] SC-TS-186: DNS lookup for user-supplied hostnames — Resolving user-controlled hostnames without restricting to external IPs enables SSRF to internal services. Severity: High. CWE: CWE-918.
- [ ] SC-TS-187: WebSocket flooding — No rate limiting on WebSocket messages allows a single client to overwhelm the server. Severity: Medium. CWE: CWE-400.
- [ ] SC-TS-188: HTTP response header injection — User input in response headers without CRLF sanitization enables response splitting. Severity: High. CWE: CWE-113.
- [ ] SC-TS-189: Missing subresource integrity (SRI) — Loading external scripts and styles without SRI hashes allows CDN compromise to inject malicious code. Severity: Medium. CWE: CWE-353.
- [ ] SC-TS-190: Exposed internal service endpoints — Internal microservice endpoints accessible from external network without gateway filtering. Severity: High. CWE: CWE-668.

### 10. Serialization & Deserialization (15 items)
- [ ] SC-TS-191: Unsafe JSON.parse on untrusted data — Parsing large or deeply nested JSON from untrusted sources without limits can cause DoS. Severity: Medium. CWE: CWE-400.
- [ ] SC-TS-192: Prototype pollution via JSON.parse — Parsing JSON containing __proto__ or constructor properties can pollute Object.prototype. Severity: High. CWE: CWE-1321.
- [ ] SC-TS-193: Deserialization of untrusted YAML — Using yaml.load (js-yaml) on untrusted YAML with unsafe schema can execute arbitrary JavaScript. Severity: Critical. CWE: CWE-502.
- [ ] SC-TS-194: XML external entity (XXE) injection — Parsing XML from untrusted sources without disabling external entities allows file reading and SSRF. Severity: High. CWE: CWE-611.
- [ ] SC-TS-195: Unsafe use of eval for deserialization — Using eval(), new Function(), or vm.runInNewContext to deserialize data allows code execution. Severity: Critical. CWE: CWE-502.
- [ ] SC-TS-196: Buffer deserialization overflow — Deserializing binary data from untrusted sources without validating length fields can cause buffer overflows. Severity: High. CWE: CWE-120.
- [ ] SC-TS-197: MessagePack/BSON deserialization of untrusted data — Deserializing binary formats without schema validation can lead to type confusion or injection. Severity: Medium. CWE: CWE-502.
- [ ] SC-TS-198: CSV injection in exported data — Including user-controlled data in CSV exports without escaping formula characters (=, +, -, @) enables formula injection. Severity: Medium. CWE: CWE-1236.
- [ ] SC-TS-199: JSON schema validation bypass — Using permissive JSON schema with additionalProperties allowed leaks unintended fields through. Severity: Medium. CWE: CWE-20.
- [ ] SC-TS-200: Insecure object serialization for caching — Serializing complex objects to cache without integrity checks allows cache poisoning. Severity: Medium. CWE: CWE-502.
- [ ] SC-TS-201: Prototype pollution via query string parsing — Query string parsers (qs) that create nested objects from dot-notation can inject __proto__ properties. Severity: High. CWE: CWE-1321.
- [ ] SC-TS-202: Unsafe structured clone — Using structuredClone on objects with untrusted prototypes may carry prototype pollution through. Severity: Medium. CWE: CWE-1321.
- [ ] SC-TS-203: GraphQL input coercion vulnerabilities — GraphQL type coercion of user input may produce unexpected values that bypass validation. Severity: Medium. CWE: CWE-20.
- [ ] SC-TS-204: Cookie deserialization injection — Parsing cookie values containing serialized data (JSON, base64-encoded objects) without validation. Severity: Medium. CWE: CWE-502.
- [ ] SC-TS-205: TOML/INI parsing code execution — Parsing configuration files from untrusted sources with parsers that support code execution directives. Severity: High. CWE: CWE-502.

### 11. Concurrency & Race Conditions (15 items)
- [ ] SC-TS-206: TOCTOU race in file operations — Checking file existence or permissions then operating on the file allows race condition exploits. Severity: Medium. CWE: CWE-367.
- [ ] SC-TS-207: Race condition in balance/inventory operations — Non-atomic read-modify-write operations on shared resources allow double-spending or overselling. Severity: High. CWE: CWE-362.
- [ ] SC-TS-208: Missing database transaction isolation — Concurrent requests modifying same records without proper transaction isolation cause data corruption. Severity: High. CWE: CWE-362.
- [ ] SC-TS-209: Race condition in session handling — Concurrent requests using the same session can cause session data corruption or privilege escalation. Severity: High. CWE: CWE-362.
- [ ] SC-TS-210: Non-atomic counter increments — Incrementing counters (rate limits, quotas) without atomic operations allows bypass under concurrent load. Severity: Medium. CWE: CWE-362.
- [ ] SC-TS-211: Worker thread shared memory race — SharedArrayBuffer access from multiple workers without Atomics causes data races. Severity: Medium. CWE: CWE-362.
- [ ] SC-TS-212: Race condition in cache invalidation — Stale cache entries served between invalidation and refresh can serve outdated security decisions. Severity: Medium. CWE: CWE-362.
- [ ] SC-TS-213: Concurrent file writes without locking — Multiple processes writing to the same file without advisory locking causes data corruption. Severity: Medium. CWE: CWE-362.
- [ ] SC-TS-214: Race condition in token refresh — Multiple concurrent requests triggering token refresh can cause token invalidation and auth failures. Severity: Medium. CWE: CWE-362.
- [ ] SC-TS-215: Idempotency key not enforced — Missing idempotency checks on payment or state-changing endpoints allows duplicate processing on retry. Severity: High. CWE: CWE-362.
- [ ] SC-TS-216: Race condition in distributed locks — Improper implementation of distributed locking (Redis SETNX without expiry) causes deadlocks or lock bypass. Severity: High. CWE: CWE-362.
- [ ] SC-TS-217: Promise.all partial failure handling — Not handling partial failures in Promise.all can leave systems in inconsistent states. Severity: Medium. CWE: CWE-755.
- [ ] SC-TS-218: Event loop starvation — Long-running synchronous operations blocking the Node.js event loop delay security-critical timers and checks. Severity: Medium. CWE: CWE-400.
- [ ] SC-TS-219: Race condition in feature flag evaluation — Feature flags evaluated inconsistently during config reload can cause security policy bypass. Severity: Medium. CWE: CWE-362.
- [ ] SC-TS-220: Concurrent signup race condition — Multiple concurrent registrations with the same email bypassing unique constraint checks. Severity: Medium. CWE: CWE-362.

### 12. Dependency & Supply Chain (25 items)
- [ ] SC-TS-221: Known vulnerabilities in dependencies — Using npm packages with published CVEs that are not patched or upgraded. Severity: High. CWE: CWE-1395.
- [ ] SC-TS-222: Typosquatting attack via misspelled packages — Installing packages with names similar to popular packages that contain malicious code. Severity: Critical. CWE: CWE-427.
- [ ] SC-TS-223: Missing package-lock.json or lockfile — Not committing lockfiles allows non-deterministic installs that may pull in compromised versions. Severity: Medium. CWE: CWE-1395.
- [ ] SC-TS-224: Postinstall script execution — npm packages running arbitrary scripts during install that can compromise the development environment. Severity: High. CWE: CWE-426.
- [ ] SC-TS-225: Unpinned dependency versions — Using caret or tilde ranges in package.json allows automatic pulling of potentially compromised versions. Severity: Medium. CWE: CWE-1395.
- [ ] SC-TS-226: Excessive transitive dependencies — Large dependency trees increase the attack surface for supply chain compromises. Severity: Medium. CWE: CWE-1395.
- [ ] SC-TS-227: Missing npm audit in CI pipeline — Not running automated vulnerability scanning of dependencies in continuous integration. Severity: Medium. CWE: CWE-1395.
- [ ] SC-TS-228: Using deprecated or unmaintained packages — Dependencies that are no longer maintained will not receive security patches. Severity: Medium. CWE: CWE-1395.
- [ ] SC-TS-229: Private npm registry misconfiguration — Misconfigured .npmrc allowing fallback to public registry for private package names enables dependency confusion. Severity: Critical. CWE: CWE-427.
- [ ] SC-TS-230: Dependency confusion attack — Attacker publishing a higher-version package with an internal package name to public registry. Severity: Critical. CWE: CWE-427.
- [ ] SC-TS-231: CDN-hosted JavaScript without SRI — Loading JavaScript from CDNs without Subresource Integrity hashes allows CDN-based code injection. Severity: High. CWE: CWE-353.
- [ ] SC-TS-232: Prototype pollution in dependencies — Using libraries known to have prototype pollution vulnerabilities (lodash.merge, deep-extend). Severity: High. CWE: CWE-1321.
- [ ] SC-TS-233: Missing SBOM generation — Not generating Software Bill of Materials makes it impossible to quickly assess impact of new CVEs. Severity: Low. CWE: CWE-1395.
- [ ] SC-TS-234: Git-based dependency without commit pinning — Installing packages from Git URLs without specifying a commit hash allows silent code changes. Severity: High. CWE: CWE-829.
- [ ] SC-TS-235: Bundled polyfills from untrusted sources — Loading polyfill.io or similar services that have been compromised to serve malicious code. Severity: Critical. CWE: CWE-829.
- [ ] SC-TS-236: Missing npm provenance verification — Not verifying npm package provenance attestation fails to ensure packages were built from claimed source. Severity: Medium. CWE: CWE-353.
- [ ] SC-TS-237: Overriding core Node.js modules — Installing npm packages that shadow built-in Node.js modules can intercept all calls. Severity: High. CWE: CWE-427.
- [ ] SC-TS-238: Unrestricted use of eval in dependencies — Dependencies using eval or new Function internally expand the attack surface. Severity: Medium. CWE: CWE-95.
- [ ] SC-TS-239: Missing dependency license review — Using packages with restrictive or unknown licenses can create legal and compliance risks. Severity: Low. CWE: CWE-1395.
- [ ] SC-TS-240: Using packages with excessive permissions — Dependencies requesting filesystem, network, or OS access beyond their stated purpose. Severity: Medium. CWE: CWE-250.
- [ ] SC-TS-241: Registry token in .npmrc committed to source — Publishing or install tokens in .npmrc files checked into version control. Severity: Critical. CWE: CWE-798.
- [ ] SC-TS-242: Missing Snyk/Dependabot automated scanning — Not using automated dependency vulnerability scanning tools for continuous monitoring. Severity: Medium. CWE: CWE-1395.
- [ ] SC-TS-243: Pre/post scripts overriding expected behavior — Lifecycle scripts in dependencies that execute unexpected commands during npm install. Severity: High. CWE: CWE-426.
- [ ] SC-TS-244: Importing from user-controlled module specifiers — Dynamic import() or require() with user-controlled paths enables loading arbitrary modules. Severity: Critical. CWE: CWE-94.
- [ ] SC-TS-245: Missing integrity verification for downloaded binaries — Not verifying checksums of binaries downloaded by postinstall scripts. Severity: High. CWE: CWE-353.

### 13. Configuration & Secrets Management (20 items)
- [ ] SC-TS-246: Secrets hardcoded in source code — API keys, passwords, or tokens embedded directly in JavaScript/TypeScript files. Severity: Critical. CWE: CWE-798.
- [ ] SC-TS-247: Environment variables exposed to client-side — Server environment variables leaked to browser bundles via improper build configuration. Severity: Critical. CWE: CWE-200.
- [ ] SC-TS-248: .env file committed to version control — Committing .env files containing secrets to Git repositories exposes them in history. Severity: Critical. CWE: CWE-312.
- [ ] SC-TS-249: Debug mode enabled in production — Running with NODE_ENV=development or debug flags in production exposes verbose error information. Severity: Medium. CWE: CWE-489.
- [ ] SC-TS-250: Default credentials not changed — Shipping applications with default admin passwords or API keys that are not rotated. Severity: Critical. CWE: CWE-798.
- [ ] SC-TS-251: Missing .gitignore for sensitive files — Not ignoring .env, *.pem, *.key, node_modules, and other sensitive paths in .gitignore. Severity: High. CWE: CWE-312.
- [ ] SC-TS-252: Secrets in Docker images — Including .env files, credentials, or keys in Docker image layers. Severity: High. CWE: CWE-312.
- [ ] SC-TS-253: Source maps deployed to production — Publishing source maps to production allows reverse-engineering of obfuscated code and reveals original source. Severity: Medium. CWE: CWE-540.
- [ ] SC-TS-254: Insecure default CORS configuration — Using permissive CORS defaults that allow all origins in production deployments. Severity: High. CWE: CWE-942.
- [ ] SC-TS-255: Missing secrets rotation policy — Never rotating API keys, tokens, or certificates after initial deployment. Severity: Medium. CWE: CWE-798.
- [ ] SC-TS-256: Configuration files with excessive permissions — Config files readable by all users on the system expose sensitive settings. Severity: Medium. CWE: CWE-732.
- [ ] SC-TS-257: Secrets passed via command-line arguments — Passing secrets as CLI args exposes them in process listings and shell history. Severity: High. CWE: CWE-214.
- [ ] SC-TS-258: Missing environment-specific security configuration — Using the same security settings (CORS, CSP, debug) across dev, staging, and production. Severity: Medium. CWE: CWE-16.
- [ ] SC-TS-259: Webpack DefinePlugin leaking secrets — Using DefinePlugin to inject environment variables without filtering can bundle secrets into client code. Severity: Critical. CWE: CWE-200.
- [ ] SC-TS-260: Next.js NEXT_PUBLIC_ prefix misuse — Accidentally prefixing sensitive env vars with NEXT_PUBLIC_ exposes them to the browser. Severity: Critical. CWE: CWE-200.
- [ ] SC-TS-261: Exposed Swagger/OpenAPI documentation — Leaving API documentation endpoints publicly accessible reveals the full API attack surface. Severity: Medium. CWE: CWE-200.
- [ ] SC-TS-262: Insecure default session configuration — Using default session secrets, cookie names, or durations from framework examples. Severity: High. CWE: CWE-1188.
- [ ] SC-TS-263: Vite env variable exposure — Vite variables prefixed with VITE_ are embedded in client bundles and should never contain secrets. Severity: Critical. CWE: CWE-200.
- [ ] SC-TS-264: Missing Content-Security-Policy configuration — Not configuring CSP headers allows unrestricted script execution and data exfiltration. Severity: Medium. CWE: CWE-1021.
- [ ] SC-TS-265: Secrets stored in browser cookies without encryption — Storing sensitive tokens in cookies without encryption exposes them on the client. Severity: Medium. CWE: CWE-312.

### 14. Prototype & Type Safety (20 items)
- [ ] SC-TS-266: Prototype pollution via Object.assign — Using Object.assign with user-controlled source objects allows __proto__ injection. Severity: High. CWE: CWE-1321.
- [ ] SC-TS-267: Prototype pollution via spread operator — Spreading user-controlled objects into new objects propagates __proto__ or constructor properties. Severity: High. CWE: CWE-1321.
- [ ] SC-TS-268: Prototype pollution via recursive merge — Deep merge utilities that don't skip __proto__, constructor, and prototype keys enable pollution. Severity: High. CWE: CWE-1321.
- [ ] SC-TS-269: Using `as any` to bypass type checking — Casting to any disables TypeScript's type system and hides type-related security bugs. Severity: Medium. CWE: CWE-704.
- [ ] SC-TS-270: Excessive @ts-ignore usage — Suppressing TypeScript errors with @ts-ignore masks potential security issues in type-checked code. Severity: Medium. CWE: CWE-704.
- [ ] SC-TS-271: Missing strict TypeScript configuration — Not enabling strict mode, strictNullChecks, or noImplicitAny weakens type safety guarantees. Severity: Medium. CWE: CWE-704.
- [ ] SC-TS-272: Type assertion instead of validation at runtime — Using `as Type` assertions on external data without runtime validation trusts untrusted input. Severity: High. CWE: CWE-20.
- [ ] SC-TS-273: Missing runtime type validation at boundaries — Not using zod, io-ts, or similar for runtime validation of API inputs and external data. Severity: High. CWE: CWE-20.
- [ ] SC-TS-274: Property access on potentially undefined values — Accessing properties without null checks can cause runtime crashes exploitable for DoS. Severity: Low. CWE: CWE-476.
- [ ] SC-TS-275: hasOwnProperty check missing — Iterating object properties with for...in without hasOwnProperty check includes inherited prototype properties. Severity: Medium. CWE: CWE-1321.
- [ ] SC-TS-276: Constructor pollution via object merge — Merging user objects that contain constructor.prototype properties pollutes all instances. Severity: High. CWE: CWE-1321.
- [ ] SC-TS-277: Unsafe type narrowing with user-controlled discriminants — Using user-supplied type discriminators to narrow union types without validation. Severity: Medium. CWE: CWE-704.
- [ ] SC-TS-278: Object.create(null) not used for dictionaries — Using plain objects as dictionaries inherits Object.prototype methods that can be exploited. Severity: Low. CWE: CWE-1321.
- [ ] SC-TS-279: Frozen prototypes not enforced — Not freezing Object.prototype in sensitive applications allows runtime prototype pollution. Severity: Medium. CWE: CWE-1321.
- [ ] SC-TS-280: Type coercion vulnerabilities — Implicit type coercion in comparisons (== instead of ===) can bypass security checks. Severity: Medium. CWE: CWE-843.
- [ ] SC-TS-281: Indexed access without type guard — Accessing typed object properties via bracket notation with user-controlled keys bypasses type checking. Severity: Medium. CWE: CWE-704.
- [ ] SC-TS-282: Generic type parameter exploitation — Overly permissive generic types that accept any allowing unsafe operations on the type parameter. Severity: Low. CWE: CWE-704.
- [ ] SC-TS-283: Declaration merging abuse — TypeScript declaration merging can unintentionally extend interfaces with unsafe properties. Severity: Low. CWE: CWE-704.
- [ ] SC-TS-284: Proxy object security bypass — Using JavaScript Proxy objects to intercept and modify property access can bypass security invariants. Severity: Medium. CWE: CWE-693.
- [ ] SC-TS-285: Symbol.toPrimitive override — Overriding Symbol.toPrimitive on user-controlled objects can subvert type coercion checks. Severity: Medium. CWE: CWE-843.

### 15. TypeScript/JavaScript-Specific Patterns (25 items)
- [ ] SC-TS-286: eval() with user input — Calling eval() with any user-controlled data enables arbitrary code execution. Severity: Critical. CWE: CWE-95.
- [ ] SC-TS-287: new Function() with user input — Constructing functions from user-supplied strings is equivalent to eval. Severity: Critical. CWE: CWE-95.
- [ ] SC-TS-288: setTimeout/setInterval with string arguments — Passing strings to setTimeout/setInterval invokes eval on the string. Severity: High. CWE: CWE-95.
- [ ] SC-TS-289: Child process command injection — Using child_process.exec with user input without proper escaping enables shell command injection. Severity: Critical. CWE: CWE-78.
- [ ] SC-TS-290: vm module sandbox escape — Using Node.js vm module as a security sandbox is unsafe as it can be escaped to access the parent context. Severity: Critical. CWE: CWE-265.
- [ ] SC-TS-291: Unhandled Promise rejection crash — Unhandled Promise rejections terminate the Node.js process in newer versions, enabling DoS. Severity: Medium. CWE: CWE-755.
- [ ] SC-TS-292: Global variable pollution — Assigning to undeclared variables without let/const/var creates globals that can be modified by other code. Severity: Medium. CWE: CWE-1321.
- [ ] SC-TS-293: Async iterator resource leak — Not properly closing async iterators (for await...of) can leak file handles and connections. Severity: Low. CWE: CWE-404.
- [ ] SC-TS-294: Dynamic require with user-controlled path — Using require() with user-provided module paths enables loading arbitrary local modules. Severity: Critical. CWE: CWE-94.
- [ ] SC-TS-295: WeakRef/FinalizationRegistry misuse — Relying on garbage collection timing for security-critical cleanup is non-deterministic and unsafe. Severity: Low. CWE: CWE-404.
- [ ] SC-TS-296: Template literal tag function injection — Custom template tag functions processing user input without sanitization enable injection attacks. Severity: High. CWE: CWE-94.
- [ ] SC-TS-297: with statement scope manipulation — Using the with statement allows user-controlled objects to shadow local variables. Severity: High. CWE: CWE-94.
- [ ] SC-TS-298: Getter/setter side effects — Object getters and setters with side effects can be triggered unexpectedly during property access. Severity: Medium. CWE: CWE-502.
- [ ] SC-TS-299: arguments object leaking — Passing the arguments object to other functions can leak private variables from closures. Severity: Low. CWE: CWE-200.
- [ ] SC-TS-300: RegExp lastIndex manipulation — Stateful RegExp objects (with /g flag) sharing lastIndex state across calls can cause validation bypass. Severity: Medium. CWE: CWE-185.
- [ ] SC-TS-301: Import assertion missing for JSON modules — Not using import assertions for JSON imports allows non-JSON content to be treated as JSON. Severity: Low. CWE: CWE-20.
- [ ] SC-TS-302: Unsafe Reflect.apply/Reflect.construct — Using Reflect methods with user-controlled arguments can invoke arbitrary functions. Severity: High. CWE: CWE-470.
- [ ] SC-TS-303: process.env mutation — Modifying process.env at runtime can alter behavior of dependent code in unexpected ways. Severity: Medium. CWE: CWE-471.
- [ ] SC-TS-304: Buffer.allocUnsafe exposure — Using Buffer.allocUnsafe without filling exposes uninitialized heap memory contents. Severity: Medium. CWE: CWE-200.
- [ ] SC-TS-305: String.prototype.replace callback injection — Using user input as the replacement string in replace() with special patterns ($`, $') leaks string content. Severity: Medium. CWE: CWE-200.
- [ ] SC-TS-306: ArrayBuffer detachment — Transferring ArrayBuffers to workers then accessing them causes undefined behavior. Severity: Low. CWE: CWE-416.
- [ ] SC-TS-307: JSON.stringify replacer bypass — Not considering that JSON.stringify with a replacer function may still expose sensitive toJSON methods. Severity: Low. CWE: CWE-200.
- [ ] SC-TS-308: Async context loss in error handling — Losing async context (e.g., user identity) when handling errors in async callbacks can cause authorization failures. Severity: Medium. CWE: CWE-362.
- [ ] SC-TS-309: Worker thread message injection — Passing unsanitized data to worker threads via postMessage without validation allows payload injection. Severity: Medium. CWE: CWE-20.
- [ ] SC-TS-310: Intl API locale-based attacks — User-controlled locale strings in Intl formatting APIs can cause unexpected output or crashes. Severity: Low. CWE: CWE-20.

### 16. Framework-Specific: React/Next.js (25 items)
- [ ] SC-TS-311: dangerouslySetInnerHTML with user input — Using dangerouslySetInnerHTML with unsanitized user data enables XSS in React components. Severity: Critical. CWE: CWE-79.
- [ ] SC-TS-312: XSS via href="javascript:" — Rendering user-controlled URLs in href attributes allows javascript: protocol XSS. Severity: High. CWE: CWE-79.
- [ ] SC-TS-313: Server component data leakage in Next.js — Returning sensitive data from server components that gets serialized into the client-side HTML. Severity: High. CWE: CWE-200.
- [ ] SC-TS-314: Next.js Server Action without authentication — Server Actions that don't validate the caller's identity allow unauthenticated server-side execution. Severity: Critical. CWE: CWE-862.
- [ ] SC-TS-315: Unsafe use of useEffect for authorization — Performing authorization checks in useEffect allows brief rendering of unauthorized content. Severity: Medium. CWE: CWE-862.
- [ ] SC-TS-316: React state containing sensitive data — Storing secrets or tokens in React state makes them inspectable via React DevTools. Severity: Medium. CWE: CWE-200.
- [ ] SC-TS-317: Missing key prop security in lists — Predictable or user-controlled React list keys can cause state retention across re-renders. Severity: Low. CWE: CWE-20.
- [ ] SC-TS-318: Unvalidated props in component rendering — Rendering user-controlled props without validation can lead to injection via component composition. Severity: Medium. CWE: CWE-79.
- [ ] SC-TS-319: Next.js middleware bypass via _next paths — Middleware that doesn't handle _next/static or _next/data paths may be bypassable. Severity: High. CWE: CWE-863.
- [ ] SC-TS-320: Exposed API routes in Next.js pages directory — API routes in the pages/api directory accessible without authentication in production. Severity: High. CWE: CWE-862.
- [ ] SC-TS-321: Ref forwarding exposing DOM manipulation — Forwarded refs allowing consumers to directly manipulate internal DOM elements. Severity: Low. CWE: CWE-668.
- [ ] SC-TS-322: SSR hydration mismatch exploitation — Server-client HTML mismatches during hydration can lead to XSS if server-rendered content differs. Severity: Medium. CWE: CWE-79.
- [ ] SC-TS-323: React context leaking sensitive data — Providing sensitive data through React Context makes it accessible to all descendant components. Severity: Medium. CWE: CWE-200.
- [ ] SC-TS-324: Next.js getServerSideProps data exposure — Returning excessive data from getServerSideProps that gets embedded in the page's __NEXT_DATA__ script. Severity: High. CWE: CWE-200.
- [ ] SC-TS-325: Missing CSP for inline scripts in Next.js — Next.js inline scripts without proper nonce-based CSP configuration. Severity: Medium. CWE: CWE-1021.
- [ ] SC-TS-326: React error boundary information disclosure — Error boundaries displaying detailed error information to users in production. Severity: Medium. CWE: CWE-209.
- [ ] SC-TS-327: Next.js image optimization SSRF — Using user-controlled URLs in the Next.js Image component's loader without allowlisting domains. Severity: High. CWE: CWE-918.
- [ ] SC-TS-328: Client-side routing bypass of server checks — React Router or Next.js client-side navigation skipping server-side middleware security checks. Severity: High. CWE: CWE-862.
- [ ] SC-TS-329: Unsafe use of React.createElement with user types — Using user-controlled strings as the component type in createElement enables rendering arbitrary components. Severity: High. CWE: CWE-94.
- [ ] SC-TS-330: Next.js revalidation endpoint abuse — Exposing on-demand revalidation endpoints without authentication allows cache invalidation attacks. Severity: Medium. CWE: CWE-862.
- [ ] SC-TS-331: React form action without CSRF protection — Forms submitted without CSRF tokens in React applications allow cross-site request forgery. Severity: High. CWE: CWE-352.
- [ ] SC-TS-332: Uncontrolled redirects in Next.js — Using user input in next/router.push or redirect() without validation enables open redirects. Severity: Medium. CWE: CWE-601.
- [ ] SC-TS-333: Exposed Next.js build output — .next directory or build artifacts accessible publicly revealing server-side code and configurations. Severity: High. CWE: CWE-540.
- [ ] SC-TS-334: RSC (React Server Components) serialization boundary leak — Passing non-serializable or sensitive data across the RSC serialization boundary. Severity: Medium. CWE: CWE-200.
- [ ] SC-TS-335: Next.js dynamic route parameter injection — Not validating dynamic route parameters (e.g., [slug]) allows path traversal or injection in server logic. Severity: High. CWE: CWE-20.

### 17. Framework-Specific: Express/Fastify/Node.js (25 items)
- [ ] SC-TS-336: Express.js body parser size limit not set — Default body-parser settings accept large payloads causing memory exhaustion. Severity: High. CWE: CWE-400.
- [ ] SC-TS-337: Missing Helmet.js security headers — Not using Helmet or equivalent to set security headers leaves multiple header-based protections missing. Severity: Medium. CWE: CWE-16.
- [ ] SC-TS-338: Express static directory traversal — Misconfigured express.static middleware allowing path traversal outside the public directory. Severity: High. CWE: CWE-22.
- [ ] SC-TS-339: Trust proxy misconfiguration — Setting trust proxy to true without specifying trusted proxies trusts all X-Forwarded headers. Severity: Medium. CWE: CWE-346.
- [ ] SC-TS-340: Express regex route ReDoS — Using vulnerable regular expressions in Express route definitions allows request-level DoS. Severity: High. CWE: CWE-1333.
- [ ] SC-TS-341: Missing express-rate-limit — Not implementing rate limiting on Express endpoints allows brute-force and DoS attacks. Severity: Medium. CWE: CWE-770.
- [ ] SC-TS-342: Fastify schema validation bypass — Using removeAdditional option without coerceTypes can allow unexpected type coercion in Fastify. Severity: Medium. CWE: CWE-20.
- [ ] SC-TS-343: Express session secret weakness — Using a short or predictable session secret in express-session allows session forgery. Severity: High. CWE: CWE-330.
- [ ] SC-TS-344: Node.js cluster worker isolation — Cluster workers sharing memory via IPC without validation can be exploited for privilege escalation. Severity: Medium. CWE: CWE-668.
- [ ] SC-TS-345: Missing CORS middleware configuration — Not configuring CORS middleware or using overly permissive defaults in Express/Fastify. Severity: High. CWE: CWE-942.
- [ ] SC-TS-346: Express middleware ordering vulnerability — Security middleware placed after route handlers fails to protect those routes. Severity: High. CWE: CWE-862.
- [ ] SC-TS-347: Fastify encapsulation bypass — Plugin encapsulation in Fastify broken by incorrect use of fastify-plugin, exposing decorators globally. Severity: Medium. CWE: CWE-668.
- [ ] SC-TS-348: Unvalidated Express route parameters — Express req.params used directly in database queries or file operations without validation. Severity: High. CWE: CWE-20.
- [ ] SC-TS-349: Missing request timeout in Node.js HTTP server — Not setting server.timeout allows slowloris and slow-read DoS attacks. Severity: Medium. CWE: CWE-400.
- [ ] SC-TS-350: Express error handler not placed last — Error-handling middleware not at the end of the middleware chain fails to catch all errors. Severity: Medium. CWE: CWE-755.
- [ ] SC-TS-351: Socket.io without authentication — Establishing socket.io connections without verifying authentication tokens. Severity: High. CWE: CWE-306.
- [ ] SC-TS-352: Node.js child_process.exec with user input — Using exec instead of execFile or spawn with user-controlled arguments enables command injection. Severity: Critical. CWE: CWE-78.
- [ ] SC-TS-353: Express response.redirect with user input — Passing user-controlled URLs to res.redirect without validation creates open redirect vulnerability. Severity: Medium. CWE: CWE-601.
- [ ] SC-TS-354: Missing Node.js security flags — Not using --disallow-code-generation-from-strings or --policy flags for hardened environments. Severity: Low. CWE: CWE-95.
- [ ] SC-TS-355: Express req.query type assumption — Assuming req.query values are strings when Express parses them as strings, arrays, or objects. Severity: Medium. CWE: CWE-843.
- [ ] SC-TS-356: Koa/Express ctx.state mutation — Uncontrolled mutation of shared request state objects across middleware layers. Severity: Medium. CWE: CWE-471.
- [ ] SC-TS-357: Missing graceful shutdown — Not draining connections on SIGTERM causes in-flight requests to fail or data to be lost. Severity: Low. CWE: CWE-404.
- [ ] SC-TS-358: Fastify reply.raw bypassing serialization — Using reply.raw to send responses bypasses Fastify's serialization and validation layer. Severity: Medium. CWE: CWE-20.
- [ ] SC-TS-359: Node.js permission model not used — Not leveraging Node.js experimental permission model (--permission) for filesystem and network restrictions. Severity: Low. CWE: CWE-250.
- [ ] SC-TS-360: Express multer misconfiguration — Multer file upload without size limits, file count limits, or filename sanitization. Severity: High. CWE: CWE-434.

### 18. API Security (20 items)
- [ ] SC-TS-361: Missing API authentication — API endpoints accessible without any authentication mechanism. Severity: Critical. CWE: CWE-306.
- [ ] SC-TS-362: API key exposed in frontend code — Embedding API keys in client-side JavaScript bundles where they can be extracted. Severity: High. CWE: CWE-312.
- [ ] SC-TS-363: Missing API versioning — Not versioning APIs prevents deprecation of insecure endpoints without breaking clients. Severity: Low. CWE: CWE-16.
- [ ] SC-TS-364: GraphQL batching attack — Allowing unlimited query batching in GraphQL enables brute-force attacks in a single HTTP request. Severity: High. CWE: CWE-770.
- [ ] SC-TS-365: Over-fetching in REST APIs — Returning all fields from database records when clients need only a subset exposes unnecessary data. Severity: Medium. CWE: CWE-200.
- [ ] SC-TS-366: Missing pagination limits — Allowing clients to request unlimited page sizes causes memory and database exhaustion. Severity: Medium. CWE: CWE-400.
- [ ] SC-TS-367: API response caching with sensitive data — Caching API responses that contain user-specific sensitive data in shared caches. Severity: High. CWE: CWE-524.
- [ ] SC-TS-368: Missing request validation middleware — Not validating request schema (params, query, body) before processing allows unexpected payloads. Severity: Medium. CWE: CWE-20.
- [ ] SC-TS-369: Broken object-level authorization in REST — API endpoints not checking that the authenticated user has access to the specific resource. Severity: High. CWE: CWE-639.
- [ ] SC-TS-370: Missing API request/response logging — Not logging API requests and responses hampers security monitoring and incident investigation. Severity: Low. CWE: CWE-778.
- [ ] SC-TS-371: GraphQL query complexity not limited — Allowing complex queries with many joins and nested fields enables resource exhaustion. Severity: High. CWE: CWE-400.
- [ ] SC-TS-372: Missing API throttling per user — Rate limiting only by IP instead of per-user allows authenticated users to abuse shared IPs. Severity: Medium. CWE: CWE-770.
- [ ] SC-TS-373: BOLA in batch/bulk endpoints — Batch operations that accept arrays of IDs without verifying access to each ID individually. Severity: High. CWE: CWE-639.
- [ ] SC-TS-374: Missing response schema validation — Not validating outbound API responses against a schema risks leaking unintended fields. Severity: Medium. CWE: CWE-200.
- [ ] SC-TS-375: Webhook endpoint without signature verification — Accepting webhook payloads from third parties without verifying HMAC signatures allows forgery. Severity: High. CWE: CWE-347.
- [ ] SC-TS-376: REST API mass assignment — Accepting and applying all fields from request body to database updates without field allowlisting. Severity: High. CWE: CWE-915.
- [ ] SC-TS-377: Missing idempotency for POST requests — Not supporting idempotency keys on state-changing POST endpoints leads to duplicate processing. Severity: Medium. CWE: CWE-400.
- [ ] SC-TS-378: GraphQL field-level authorization missing — Not checking permissions on individual GraphQL fields allows accessing restricted data via queries. Severity: High. CWE: CWE-862.
- [ ] SC-TS-379: API endpoint enumeration — Predictable API endpoint naming conventions that allow discovery of undocumented endpoints. Severity: Low. CWE: CWE-200.
- [ ] SC-TS-380: Missing API response compression bomb protection — Not limiting decompression size of API responses when using gzip/brotli allows zip bomb attacks. Severity: Medium. CWE: CWE-400.

### 19. Testing & CI/CD Security (15 items)
- [ ] SC-TS-381: Secrets in CI/CD pipeline logs — CI/CD configurations that echo or log environment variables containing secrets. Severity: High. CWE: CWE-532.
- [ ] SC-TS-382: Missing security tests — No automated tests for authentication, authorization, and input validation security controls. Severity: Medium. CWE: CWE-1053.
- [ ] SC-TS-383: Test fixtures with real credentials — Using actual API keys or passwords in test data instead of mock values. Severity: High. CWE: CWE-798.
- [ ] SC-TS-384: CI pipeline running untrusted code — CI/CD running code from pull requests without sandboxing allows pipeline compromise. Severity: High. CWE: CWE-94.
- [ ] SC-TS-385: Missing SAST in CI pipeline — Not running static application security testing tools (ESLint security rules, semgrep) in CI. Severity: Medium. CWE: CWE-1053.
- [ ] SC-TS-386: Missing DAST in CI pipeline — Not running dynamic security testing against staging deployments in the CI pipeline. Severity: Medium. CWE: CWE-1053.
- [ ] SC-TS-387: Production database access from CI — CI/CD pipelines with credentials to access production databases create exposure risk. Severity: High. CWE: CWE-250.
- [ ] SC-TS-388: Unpinned CI/CD action versions — Using GitHub Actions or other CI plugins at major version tags instead of specific SHAs. Severity: High. CWE: CWE-829.
- [ ] SC-TS-389: Missing container image scanning — Not scanning Docker images for vulnerabilities before deployment. Severity: Medium. CWE: CWE-1395.
- [ ] SC-TS-390: Test environment matching production security — Test environments not replicating production security controls lead to false confidence. Severity: Medium. CWE: CWE-1053.
- [ ] SC-TS-391: Missing secret detection in pre-commit hooks — Not using tools like gitleaks or detect-secrets to prevent accidental secret commits. Severity: Medium. CWE: CWE-798.
- [ ] SC-TS-392: Artifact registry without access controls — NPM or Docker registries accessible without authentication allowing unauthorized reads or writes. Severity: High. CWE: CWE-862.
- [ ] SC-TS-393: Missing branch protection rules — Not requiring pull request reviews and status checks on main branches allows direct unsafe pushes. Severity: Medium. CWE: CWE-284.
- [ ] SC-TS-394: Snapshot testing masking security changes — Jest/Vitest snapshot tests auto-updating and masking security-relevant changes in generated output. Severity: Low. CWE: CWE-1053.
- [ ] SC-TS-395: Missing infrastructure-as-code security scanning — Not scanning Terraform, CloudFormation, or Kubernetes manifests for misconfigurations. Severity: Medium. CWE: CWE-16.

### 20. Third-Party Integration Security (20 items)
- [ ] SC-TS-396: OAuth token stored insecurely — Storing OAuth access and refresh tokens in localStorage or unencrypted storage. Severity: High. CWE: CWE-922.
- [ ] SC-TS-397: Missing webhook signature verification — Accepting webhooks from services (Stripe, GitHub) without HMAC signature validation. Severity: High. CWE: CWE-347.
- [ ] SC-TS-398: Third-party script injection — Loading third-party scripts that can access the full DOM and cookies of the hosting page. Severity: High. CWE: CWE-829.
- [ ] SC-TS-399: Insecure iframe embedding — Embedding third-party content in iframes without sandbox attribute restricting capabilities. Severity: Medium. CWE: CWE-1021.
- [ ] SC-TS-400: Payment integration without server-side verification — Trusting client-side payment confirmation without server-side verification with the payment provider. Severity: Critical. CWE: CWE-345.
- [ ] SC-TS-401: Missing SSRF protection in third-party callbacks — Third-party services sending callbacks to user-configured URLs without internal IP filtering. Severity: High. CWE: CWE-918.
- [ ] SC-TS-402: Insufficient OAuth scope limitation — Requesting broader OAuth scopes than necessary from third-party providers. Severity: Medium. CWE: CWE-250.
- [ ] SC-TS-403: Third-party SDK version not pinned — Using third-party SDKs at latest version without pinning allows silent introduction of vulnerabilities. Severity: Medium. CWE: CWE-829.
- [ ] SC-TS-404: Unvalidated SSO/SAML assertions — Not properly validating SAML response signatures and assertions from identity providers. Severity: Critical. CWE: CWE-347.
- [ ] SC-TS-405: Missing Content-Security-Policy for third-party scripts — Not restricting third-party script sources in CSP allows loading from any origin. Severity: Medium. CWE: CWE-1021.
- [ ] SC-TS-406: Cloud storage bucket misconfiguration — S3 or GCS buckets with public access containing sensitive application data. Severity: Critical. CWE: CWE-732.
- [ ] SC-TS-407: Missing API gateway rate limiting — Not configuring rate limits on API gateways (AWS API Gateway, Kong) for third-party integrations. Severity: Medium. CWE: CWE-770.
- [ ] SC-TS-408: Insecure message queue configuration — Message queues (RabbitMQ, SQS) without encryption or authentication for message transmission. Severity: High. CWE: CWE-319.
- [ ] SC-TS-409: Third-party analytics data leakage — Sending sensitive user data to analytics providers (Google Analytics, Mixpanel) without anonymization. Severity: Medium. CWE: CWE-359.
- [ ] SC-TS-410: Missing OpenID Connect nonce validation — Not verifying the nonce claim in OIDC ID tokens allows replay attacks. Severity: High. CWE: CWE-294.
- [ ] SC-TS-411: Exposed third-party admin panels — Third-party service admin panels (database admin, cache admin) accessible without authentication. Severity: High. CWE: CWE-306.
- [ ] SC-TS-412: Email service injection — Using user input in email headers or body sent via third-party email services (SendGrid, SES) without sanitization. Severity: High. CWE: CWE-93.
- [ ] SC-TS-413: SMS/notification injection — User-controlled content in SMS or push notification messages sent via third-party APIs. Severity: Medium. CWE: CWE-74.
- [ ] SC-TS-414: Missing certificate pinning for mobile API calls — Not pinning TLS certificates in mobile hybrid apps using JavaScript bridges. Severity: Medium. CWE: CWE-295.
- [ ] SC-TS-415: Third-party service credential rotation not implemented — Using static credentials for third-party APIs without scheduled rotation. Severity: Medium. CWE: CWE-798.
