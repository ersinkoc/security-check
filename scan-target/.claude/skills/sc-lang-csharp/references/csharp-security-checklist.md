# C#/.NET Security Checklist

> 420+ security checks for C# and .NET applications.
> Used by security-check sc-lang-csharp skill as reference.

## How to Use
This checklist is automatically referenced by the sc-lang-csharp skill during security scans. It can also be used manually during code review.

## Categories

### 1. Input Validation & Sanitization (25 items)

- [ ] SC-CS-001: Unvalidated user input in controller actions — Ensure all user-supplied data from query strings, form fields, headers, and route parameters is validated before use. Severity: High. CWE: CWE-20.
- [ ] SC-CS-002: Missing model validation attributes — Verify that data annotation attributes such as `[Required]`, `[StringLength]`, `[Range]`, and `[RegularExpression]` are applied to model properties that accept user input. Severity: Medium. CWE: CWE-20.
- [ ] SC-CS-003: ModelState.IsValid not checked — Ensure every controller action that accepts model-bound input checks `ModelState.IsValid` before processing. Severity: High. CWE: CWE-20.
- [ ] SC-CS-004: Regex denial of service (ReDoS) — Verify that `System.Text.RegularExpressions.Regex` patterns do not contain nested quantifiers or overlapping alternations that cause catastrophic backtracking. Severity: High. CWE: CWE-1333.
- [ ] SC-CS-005: Missing Regex timeout — Ensure all `Regex` instantiations specify a `matchTimeout` parameter or use `RegexOptions.NonBacktracking` (.NET 7+) to prevent ReDoS. Severity: High. CWE: CWE-1333.
- [ ] SC-CS-006: HTML injection via unencoded output — Verify that all user-supplied data rendered in HTML is encoded using `HtmlEncoder.Default.Encode()` or Razor's automatic encoding. Severity: High. CWE: CWE-79.
- [ ] SC-CS-007: XSS via Html.Raw() — Audit all uses of `Html.Raw()` in Razor views to confirm they do not render unsanitized user input. Severity: Critical. CWE: CWE-79.
- [ ] SC-CS-008: JavaScript injection via inline scripts — Verify that user data embedded in `<script>` blocks uses `JavaScriptEncoder.Default.Encode()` rather than plain string interpolation. Severity: Critical. CWE: CWE-79.
- [ ] SC-CS-009: URL redirect injection — Ensure redirect targets from user input are validated with `Url.IsLocalUrl()` or a whitelist before calling `Redirect()`. Severity: Medium. CWE: CWE-601.
- [ ] SC-CS-010: Header injection via user input — Verify that user-supplied values placed into HTTP response headers are sanitized to prevent CRLF injection. Severity: High. CWE: CWE-113.
- [ ] SC-CS-011: LDAP injection — Ensure user input used in LDAP queries is escaped using proper LDAP encoding before constructing directory search filters. Severity: High. CWE: CWE-90.
- [ ] SC-CS-012: XPath injection — Verify that user input used in XPath expressions is parameterized or properly escaped. Severity: High. CWE: CWE-643.
- [ ] SC-CS-013: Command injection via Process.Start — Ensure user-supplied data is never passed directly to `Process.Start()` or `ProcessStartInfo.Arguments` without strict validation and escaping. Severity: Critical. CWE: CWE-78.
- [ ] SC-CS-014: Argument injection in Process.Start — Verify that when using `Process.Start`, the `FileName` and `Arguments` are set separately and arguments are individually escaped to prevent argument injection. Severity: Critical. CWE: CWE-88.
- [ ] SC-CS-015: Email header injection — Ensure user input placed into email headers (To, CC, Subject) is validated to prevent SMTP header injection via newline characters. Severity: Medium. CWE: CWE-93.
- [ ] SC-CS-016: Template injection in Razor — Verify that user input is never used to dynamically construct Razor template strings that are then compiled and executed. Severity: Critical. CWE: CWE-1336.
- [ ] SC-CS-017: Insufficient input length validation — Ensure all string inputs have maximum length constraints to prevent buffer abuse and denial of service. Severity: Medium. CWE: CWE-20.
- [ ] SC-CS-018: Integer overflow in input parsing — Verify that numeric inputs are parsed with overflow checking or use `checked` context to prevent silent integer overflow. Severity: Medium. CWE: CWE-190.
- [ ] SC-CS-019: Unicode normalization bypass — Ensure input validation is performed after Unicode normalization to prevent bypasses using homoglyphs or equivalent Unicode sequences. Severity: Medium. CWE: CWE-176.
- [ ] SC-CS-020: Null byte injection — Verify that input validation accounts for null bytes (`\0`) which can truncate strings in native interop scenarios. Severity: Medium. CWE: CWE-158.
- [ ] SC-CS-021: Double encoding bypass — Ensure input is decoded exactly once and validation is applied after decoding to prevent double-encoding attacks. Severity: Medium. CWE: CWE-174.
- [ ] SC-CS-022: Mass assignment via over-posting — Verify that model binding uses `[Bind]` attribute, view models, or `[BindNever]`/`[JsonIgnore]` to prevent attackers from setting unintended properties. Severity: High. CWE: CWE-915.
- [ ] SC-CS-023: Unvalidated file name input — Ensure file names from user input are stripped of path separators and validated against an allowlist of characters. Severity: High. CWE: CWE-22.
- [ ] SC-CS-024: Content-Type validation missing — Verify that endpoints validate the Content-Type header matches expected media types before processing request bodies. Severity: Medium. CWE: CWE-20.
- [ ] SC-CS-025: Dangerous type converters — Ensure custom `TypeConverter` implementations do not perform unsafe operations such as deserialization or file access during conversion. Severity: Medium. CWE: CWE-20.

### 2. Authentication & Session Management (25 items)

- [ ] SC-CS-026: Plaintext password storage — Verify that passwords are hashed using `PasswordHasher<T>` (ASP.NET Identity) or a strong adaptive algorithm like bcrypt/scrypt/Argon2 and never stored in plaintext. Severity: Critical. CWE: CWE-256.
- [ ] SC-CS-027: Weak password hashing algorithm — Ensure passwords are not hashed with MD5, SHA-1, or unsalted SHA-256; use ASP.NET Identity's PBKDF2 or Argon2id instead. Severity: Critical. CWE: CWE-328.
- [ ] SC-CS-028: Missing password complexity requirements — Verify that `IdentityOptions.Password` enforces minimum length, complexity, and prevents common passwords. Severity: Medium. CWE: CWE-521.
- [ ] SC-CS-029: Missing account lockout — Ensure `IdentityOptions.Lockout` is configured with `MaxFailedAccessAttempts` and `DefaultLockoutTimeSpan` to mitigate brute-force attacks. Severity: Medium. CWE: CWE-307.
- [ ] SC-CS-030: Authentication bypass via missing [Authorize] — Verify that all endpoints requiring authentication have the `[Authorize]` attribute or are covered by a global authorization policy. Severity: Critical. CWE: CWE-306.
- [ ] SC-CS-031: JWT token not validated — Ensure JWT bearer authentication validates issuer, audience, lifetime, and signing key via `TokenValidationParameters`. Severity: Critical. CWE: CWE-345.
- [ ] SC-CS-032: JWT algorithm confusion — Verify that `TokenValidationParameters.ValidAlgorithms` is explicitly set to prevent algorithm switching attacks (e.g., RS256 to HS256). Severity: Critical. CWE: CWE-327.
- [ ] SC-CS-033: JWT secret key too short — Ensure HMAC signing keys for JWT are at least 256 bits and RSA keys are at least 2048 bits. Severity: High. CWE: CWE-326.
- [ ] SC-CS-034: Missing token expiration — Verify that JWT tokens and authentication cookies have reasonable expiration times configured. Severity: Medium. CWE: CWE-613.
- [ ] SC-CS-035: Session fixation — Ensure session identifiers are regenerated after successful authentication by using `HttpContext.SignInAsync()` which creates new auth tickets. Severity: High. CWE: CWE-384.
- [ ] SC-CS-036: Cookie not marked Secure — Verify that authentication cookies have `CookieOptions.Secure = true` to prevent transmission over unencrypted connections. Severity: High. CWE: CWE-614.
- [ ] SC-CS-037: Cookie not marked HttpOnly — Ensure authentication cookies have `CookieOptions.HttpOnly = true` to prevent JavaScript access. Severity: High. CWE: CWE-1004.
- [ ] SC-CS-038: Missing SameSite cookie attribute — Verify that authentication cookies set `SameSite = SameSiteMode.Strict` or `Lax` to mitigate CSRF. Severity: Medium. CWE: CWE-1275.
- [ ] SC-CS-039: Missing anti-forgery token validation — Ensure state-changing endpoints validate anti-forgery tokens via `[ValidateAntiForgeryToken]` or `[AutoValidateAntiforgeryToken]`. Severity: High. CWE: CWE-352.
- [ ] SC-CS-040: CSRF protection not applied globally — Verify that `AutoValidateAntiforgeryTokenAttribute` is added as a global filter or applied via convention for all POST/PUT/DELETE actions. Severity: High. CWE: CWE-352.
- [ ] SC-CS-041: Insecure "Remember Me" implementation — Ensure persistent authentication tokens are securely generated, stored, and can be individually revoked. Severity: Medium. CWE: CWE-613.
- [ ] SC-CS-042: Missing multi-factor authentication for sensitive operations — Verify that high-privilege operations require step-up authentication or MFA verification. Severity: Medium. CWE: CWE-308.
- [ ] SC-CS-043: User enumeration via login responses — Ensure authentication error messages do not reveal whether a username exists (use generic "invalid credentials" message). Severity: Low. CWE: CWE-203.
- [ ] SC-CS-044: User enumeration via registration — Verify that the registration flow does not reveal existing email addresses through error messages or timing differences. Severity: Low. CWE: CWE-203.
- [ ] SC-CS-045: Insecure password reset flow — Ensure password reset tokens are cryptographically random, time-limited, single-use, and transmitted over HTTPS only. Severity: High. CWE: CWE-640.
- [ ] SC-CS-046: OAuth state parameter not validated — Verify that the `state` parameter in OAuth flows is validated to prevent CSRF attacks on the callback endpoint. Severity: High. CWE: CWE-352.
- [ ] SC-CS-047: OpenID Connect nonce not validated — Ensure the `nonce` claim in ID tokens is validated to prevent replay attacks. Severity: Medium. CWE: CWE-345.
- [ ] SC-CS-048: Hardcoded credentials in source code — Verify that no usernames, passwords, API keys, or connection strings with credentials are hardcoded in source files. Severity: Critical. CWE: CWE-798.
- [ ] SC-CS-049: Insecure external identity provider configuration — Ensure external authentication providers (Google, Azure AD, etc.) are configured with proper scopes and token validation. Severity: High. CWE: CWE-287.
- [ ] SC-CS-050: Missing sliding expiration management — Verify that session sliding expiration is configured appropriately and absolute expiration is also set to limit maximum session lifetime. Severity: Low. CWE: CWE-613.

### 3. Authorization & Access Control (20 items)

- [ ] SC-CS-051: Missing role-based access control — Verify that endpoints use `[Authorize(Roles = "...")]` or policy-based authorization to restrict access based on user roles. Severity: High. CWE: CWE-862.
- [ ] SC-CS-052: Insecure direct object reference (IDOR) — Ensure that data access operations verify the authenticated user has permission to access the requested resource, not just that the ID is valid. Severity: High. CWE: CWE-639.
- [ ] SC-CS-053: Missing resource-based authorization — Verify that `IAuthorizationService.AuthorizeAsync()` is used for resource-level authorization checks rather than relying solely on role checks. Severity: High. CWE: CWE-863.
- [ ] SC-CS-054: Privilege escalation via role manipulation — Ensure that role assignment and modification endpoints are restricted to administrators and validate against privilege escalation. Severity: Critical. CWE: CWE-269.
- [ ] SC-CS-055: Authorization logic in client-side code only — Verify that all authorization decisions are enforced server-side, not solely in JavaScript or Blazor WASM client code. Severity: Critical. CWE: CWE-602.
- [ ] SC-CS-056: Missing authorization policy for default routes — Ensure that fallback authorization policies are configured so new endpoints are secure by default. Severity: High. CWE: CWE-862.
- [ ] SC-CS-057: Overly permissive CORS policy — Verify that CORS is not configured with `AllowAnyOrigin()` combined with `AllowCredentials()`, and that allowed origins are explicitly whitelisted. Severity: High. CWE: CWE-942.
- [ ] SC-CS-058: Claims not validated after transformation — Ensure that custom `IClaimsTransformation` implementations do not introduce unauthorized claims or skip validation of external claims. Severity: Medium. CWE: CWE-863.
- [ ] SC-CS-059: Authorization handler bypassed via exception — Verify that `AuthorizationHandler<T>` implementations do not call `context.Succeed()` in catch blocks or on error paths. Severity: High. CWE: CWE-755.
- [ ] SC-CS-060: Horizontal privilege escalation — Ensure that users cannot access other users' data by modifying tenant IDs, user IDs, or similar identifiers in requests. Severity: High. CWE: CWE-639.
- [ ] SC-CS-061: Missing tenant isolation in multi-tenant apps — Verify that data queries always include tenant context filtering and that cross-tenant data access is prevented. Severity: Critical. CWE: CWE-668.
- [ ] SC-CS-062: Excessive API scope grants — Ensure OAuth scopes and API permissions follow the principle of least privilege. Severity: Medium. CWE: CWE-250.
- [ ] SC-CS-063: Method-level authorization inconsistency — Verify that when both class-level and method-level `[Authorize]` attributes are used, the most restrictive policy applies. Severity: Medium. CWE: CWE-862.
- [ ] SC-CS-064: AllowAnonymous on sensitive endpoints — Audit all uses of `[AllowAnonymous]` to ensure they do not inadvertently expose sensitive functionality. Severity: High. CWE: CWE-862.
- [ ] SC-CS-065: Insecure global authorization filter ordering — Verify that authorization filters run before any action filters that may have side effects. Severity: Medium. CWE: CWE-862.
- [ ] SC-CS-066: Missing authorization on SignalR hub methods — Ensure SignalR hub methods that perform sensitive operations have `[Authorize]` attributes applied. Severity: High. CWE: CWE-862.
- [ ] SC-CS-067: Missing authorization on gRPC service methods — Verify that gRPC service implementations use `[Authorize]` on methods requiring access control. Severity: High. CWE: CWE-862.
- [ ] SC-CS-068: Broken function-level authorization — Ensure administrative and privileged API endpoints are not accessible to unprivileged users even if the URL is known. Severity: High. CWE: CWE-285.
- [ ] SC-CS-069: Data filtering in UI only — Verify that authorization-based data filtering is applied at the query/repository level, not just in the view/controller. Severity: High. CWE: CWE-602.
- [ ] SC-CS-070: Insufficient permission granularity — Ensure permissions are fine-grained enough to support least privilege; avoid single "admin" flag for all operations. Severity: Medium. CWE: CWE-732.

### 4. Cryptography (25 items)

- [ ] SC-CS-071: Use of obsolete cryptographic algorithms — Verify that DES, 3DES, RC2, RC4, MD5, and SHA-1 are not used for security-sensitive operations; use AES-256 and SHA-256/SHA-384/SHA-512 instead. Severity: High. CWE: CWE-327.
- [ ] SC-CS-072: Hardcoded cryptographic keys — Ensure encryption keys and initialization vectors are not hardcoded in source code but loaded from secure key management. Severity: Critical. CWE: CWE-321.
- [ ] SC-CS-073: ECB mode encryption — Verify that `CipherMode.ECB` is not used; prefer `CipherMode.CBC` with random IV or use authenticated encryption (AES-GCM). Severity: High. CWE: CWE-327.
- [ ] SC-CS-074: Missing authenticated encryption — Ensure encryption uses authenticated modes like AES-GCM or combines AES-CBC with HMAC to prevent ciphertext tampering. Severity: High. CWE: CWE-353.
- [ ] SC-CS-075: Static or predictable initialization vector — Verify that IVs are generated using `RandomNumberGenerator` and are unique per encryption operation. Severity: High. CWE: CWE-329.
- [ ] SC-CS-076: Insecure random number generation — Ensure `System.Random` is not used for security-sensitive values; use `RandomNumberGenerator` instead. Severity: High. CWE: CWE-338.
- [ ] SC-CS-077: Weak key derivation — Verify that key derivation uses `Rfc2898DeriveBytes` with SHA-256+ and at least 600,000 iterations (OWASP 2023) or use Argon2id. Severity: High. CWE: CWE-916.
- [ ] SC-CS-078: Insufficient key length — Ensure AES keys are 256 bits, RSA keys are at least 2048 bits, and ECDSA uses P-256 or stronger curves. Severity: High. CWE: CWE-326.
- [ ] SC-CS-079: Key material not cleared from memory — Verify that `CryptographicOperations.ZeroMemory()` or `Array.Clear()` is used to wipe key material from byte arrays after use. Severity: Medium. CWE: CWE-316.
- [ ] SC-CS-080: Data Protection API keys not persisted — Ensure ASP.NET Core Data Protection keys are persisted to a durable store and protected with a key encryption key in production. Severity: High. CWE: CWE-321.
- [ ] SC-CS-081: Data Protection key rotation not configured — Verify that Data Protection key lifetime and automatic rotation are configured appropriately. Severity: Medium. CWE: CWE-324.
- [ ] SC-CS-082: Timing side-channel in comparison — Ensure cryptographic token comparisons use `CryptographicOperations.FixedTimeEquals()` to prevent timing attacks. Severity: High. CWE: CWE-208.
- [ ] SC-CS-083: TLS version below 1.2 — Verify that `ServicePointManager.SecurityProtocol` or HttpClient configuration enforces TLS 1.2 or higher. Severity: High. CWE: CWE-326.
- [ ] SC-CS-084: Certificate validation disabled — Ensure `ServerCertificateCustomValidationCallback` does not unconditionally return `true`, disabling certificate verification. Severity: Critical. CWE: CWE-295.
- [ ] SC-CS-085: Self-signed certificates in production — Verify that production environments use certificates from trusted CAs, not self-signed certificates. Severity: High. CWE: CWE-295.
- [ ] SC-CS-086: Insecure certificate pinning — Ensure certificate pinning implementations validate the full chain and handle rotation gracefully. Severity: Medium. CWE: CWE-295.
- [ ] SC-CS-087: RSA without OAEP padding — Verify that RSA encryption uses OAEP padding (`RSAEncryptionPadding.OaepSHA256`), not PKCS#1 v1.5. Severity: High. CWE: CWE-780.
- [ ] SC-CS-088: Digital signature not verified — Ensure all digital signatures and MACs are verified before trusting signed data. Severity: High. CWE: CWE-347.
- [ ] SC-CS-089: Predictable salt values — Verify that salts are generated using `RandomNumberGenerator` and are at least 16 bytes long. Severity: Medium. CWE: CWE-760.
- [ ] SC-CS-090: Encryption key stored alongside encrypted data — Ensure encryption keys are stored separately from the data they protect, ideally in Azure Key Vault, AWS KMS, or an HSM. Severity: High. CWE: CWE-312.
- [ ] SC-CS-091: Custom cryptographic implementation — Verify that cryptographic algorithms are not implemented from scratch; use well-tested libraries like `System.Security.Cryptography`. Severity: Critical. CWE: CWE-327.
- [ ] SC-CS-092: GCM nonce reuse — Ensure AES-GCM nonces are never reused with the same key; use a counter or random 12-byte nonce per operation. Severity: Critical. CWE: CWE-323.
- [ ] SC-CS-093: Missing HSTS header — Verify that `UseHsts()` middleware is enabled in production to enforce HTTPS via the Strict-Transport-Security header. Severity: Medium. CWE: CWE-319.
- [ ] SC-CS-094: Missing HTTPS redirection — Ensure `UseHttpsRedirection()` middleware is configured to redirect all HTTP traffic to HTTPS. Severity: Medium. CWE: CWE-319.
- [ ] SC-CS-095: Weak PBKDF2 iteration count — Verify that `Rfc2898DeriveBytes` uses at least 600,000 iterations with SHA-256 as recommended by OWASP. Severity: High. CWE: CWE-916.

### 5. Error Handling & Logging (20 items)

- [ ] SC-CS-096: Stack traces exposed to users — Verify that `UseDeveloperExceptionPage()` is not enabled in production; use `UseExceptionHandler()` with a custom error page instead. Severity: High. CWE: CWE-209.
- [ ] SC-CS-097: Detailed error messages in API responses — Ensure API error responses do not include stack traces, internal paths, or database error details. Severity: High. CWE: CWE-209.
- [ ] SC-CS-098: Exception details in custom error pages — Verify that custom error pages do not render `Exception.Message` or `Exception.StackTrace` to end users. Severity: Medium. CWE: CWE-209.
- [ ] SC-CS-099: Unhandled exceptions crash the process — Ensure global exception handling middleware catches all unhandled exceptions and returns appropriate error responses. Severity: Medium. CWE: CWE-755.
- [ ] SC-CS-100: Sensitive data in log messages — Verify that PII, passwords, tokens, credit card numbers, and other sensitive data are not written to logs. Severity: High. CWE: CWE-532.
- [ ] SC-CS-101: Missing structured logging — Ensure the application uses structured logging (e.g., Serilog, NLog with structured templates) to prevent log injection. Severity: Medium. CWE: CWE-117.
- [ ] SC-CS-102: Log injection via user input — Verify that user-supplied data in log messages is parameterized (e.g., `_logger.LogInformation("User {User} logged in", username)`) and not concatenated. Severity: Medium. CWE: CWE-117.
- [ ] SC-CS-103: Missing security event logging — Ensure authentication successes, failures, authorization denials, and privilege changes are logged for audit purposes. Severity: Medium. CWE: CWE-778.
- [ ] SC-CS-104: Log files accessible via web — Verify that log files are stored outside the web root and are not accessible via HTTP requests. Severity: High. CWE: CWE-532.
- [ ] SC-CS-105: Missing log integrity protection — Ensure audit logs are protected against tampering via write-once storage, digital signatures, or centralized log aggregation. Severity: Medium. CWE: CWE-117.
- [ ] SC-CS-106: Catching generic Exception type — Verify that catch blocks handle specific exception types rather than catching `Exception` or `SystemException` broadly, which may mask critical errors. Severity: Medium. CWE: CWE-396.
- [ ] SC-CS-107: Empty catch blocks — Ensure catch blocks do not silently swallow exceptions; at minimum, log the exception details. Severity: Medium. CWE: CWE-390.
- [ ] SC-CS-108: Exception used for flow control — Verify that exceptions are not used for normal control flow, which can mask real errors and degrade performance. Severity: Low. CWE: CWE-755.
- [ ] SC-CS-109: Sensitive data in exception messages — Ensure custom exception messages do not include credentials, connection strings, or other secrets. Severity: High. CWE: CWE-209.
- [ ] SC-CS-110: Missing error handling in async code — Verify that `async` methods properly await tasks and handle exceptions rather than fire-and-forget patterns that lose errors. Severity: Medium. CWE: CWE-755.
- [ ] SC-CS-111: Insecure error handling in middleware — Ensure custom middleware catches and handles exceptions properly without leaking internal details. Severity: Medium. CWE: CWE-209.
- [ ] SC-CS-112: Missing correlation IDs for error tracking — Verify that errors include correlation IDs for tracing without exposing internal system details to end users. Severity: Low. CWE: CWE-778.
- [ ] SC-CS-113: Log level misconfiguration in production — Ensure production logging is configured at Warning level or higher and does not emit Debug/Trace level logs containing sensitive details. Severity: Medium. CWE: CWE-532.
- [ ] SC-CS-114: Failure to log deserialization errors — Verify that deserialization failures are logged with sufficient context to detect attacks while not logging the malicious payload verbatim. Severity: Medium. CWE: CWE-778.
- [ ] SC-CS-115: Database error details exposed — Ensure `DbException` and `SqlException` details are caught and replaced with generic error messages before returning to clients. Severity: High. CWE: CWE-209.

### 6. Data Protection & Privacy (20 items)

- [ ] SC-CS-116: Sensitive data in connection strings — Verify that connection strings use integrated authentication or reference credentials from secure vaults rather than embedding passwords. Severity: High. CWE: CWE-312.
- [ ] SC-CS-117: PII stored without encryption — Ensure personally identifiable information is encrypted at rest using column-level encryption, Always Encrypted, or application-level encryption. Severity: High. CWE: CWE-311.
- [ ] SC-CS-118: Missing Data Protection API for sensitive cookies — Verify that sensitive cookie values are protected using `IDataProtector.Protect()` before being set. Severity: Medium. CWE: CWE-311.
- [ ] SC-CS-119: Sensitive data in query strings — Ensure sensitive information such as tokens, passwords, and PII is not transmitted via URL query parameters where it may be logged. Severity: Medium. CWE: CWE-598.
- [ ] SC-CS-120: Sensitive data in ViewState — Verify that ASP.NET WebForms ViewState does not contain sensitive data, and that ViewState MAC validation is enabled. Severity: High. CWE: CWE-642.
- [ ] SC-CS-121: Sensitive data cached insecurely — Ensure distributed cache entries containing sensitive data are encrypted and have appropriate expiration. Severity: Medium. CWE: CWE-524.
- [ ] SC-CS-122: Sensitive data in TempData — Verify that ASP.NET `TempData` does not store sensitive information as it may be persisted in cookies or session state. Severity: Medium. CWE: CWE-312.
- [ ] SC-CS-123: Missing response caching restrictions — Ensure responses containing sensitive data set `Cache-Control: no-store` and `Pragma: no-cache` headers. Severity: Medium. CWE: CWE-524.
- [ ] SC-CS-124: Sensitive data in client-side storage — Verify that Blazor WASM applications do not store secrets, tokens, or PII in browser localStorage or sessionStorage without encryption. Severity: High. CWE: CWE-922.
- [ ] SC-CS-125: PII in application insights telemetry — Ensure telemetry and APM data does not inadvertently capture PII from request bodies, headers, or user context. Severity: Medium. CWE: CWE-532.
- [ ] SC-CS-126: Missing data classification — Verify that data models have clear classification of sensitive fields using attributes or documentation to guide protection requirements. Severity: Low. CWE: CWE-312.
- [ ] SC-CS-127: GDPR right-to-erasure not implemented — Ensure the application supports data deletion workflows for GDPR compliance when handling EU user data. Severity: Medium. CWE: CWE-359.
- [ ] SC-CS-128: Missing data retention policies — Verify that automated data retention and purge mechanisms exist for temporary, session, and personal data. Severity: Low. CWE: CWE-359.
- [ ] SC-CS-129: Secrets in appsettings.json committed to repository — Ensure `appsettings.json` and environment-specific configuration files do not contain production secrets and are not committed to version control. Severity: Critical. CWE: CWE-312.
- [ ] SC-CS-130: Memory dump exposes sensitive data — Verify that sensitive objects implement `IDisposable` and clear sensitive fields, and consider using `SecureString` for high-sensitivity values where applicable. Severity: Medium. CWE: CWE-316.
- [ ] SC-CS-131: Clipboard data leakage — Ensure applications do not place sensitive data on the system clipboard where other applications can access it. Severity: Low. CWE: CWE-316.
- [ ] SC-CS-132: Debug endpoints expose data in production — Verify that health check, diagnostic, and debug endpoints do not expose sensitive configuration or data in production. Severity: High. CWE: CWE-215.
- [ ] SC-CS-133: Insecure data export functionality — Ensure data export features enforce authorization and do not allow bulk extraction of sensitive records. Severity: High. CWE: CWE-359.
- [ ] SC-CS-134: Missing field-level encryption for high-sensitivity data — Verify that highly sensitive fields (SSN, payment info) use field-level encryption independent of transport and storage encryption. Severity: High. CWE: CWE-311.
- [ ] SC-CS-135: Response contains unnecessary sensitive fields — Ensure API responses use DTOs/projections that exclude sensitive fields not needed by the client. Severity: Medium. CWE: CWE-359.

### 7. SQL/NoSQL/ORM Security (25 items)

- [ ] SC-CS-136: Raw SQL injection via string concatenation — Verify that SQL queries are not constructed using string concatenation or interpolation with user input; use parameterized queries. Severity: Critical. CWE: CWE-89.
- [ ] SC-CS-137: Entity Framework FromSqlRaw injection — Ensure `FromSqlRaw()` and `ExecuteSqlRaw()` use parameterized queries and never interpolate user input directly. Severity: Critical. CWE: CWE-89.
- [ ] SC-CS-138: Entity Framework FromSqlInterpolated misuse — Verify that `FromSqlInterpolated()` is used correctly with interpolated strings and that raw user strings are not embedded without parameterization. Severity: High. CWE: CWE-89.
- [ ] SC-CS-139: LINQ injection via dynamic expressions — Ensure that dynamic LINQ libraries (e.g., System.Linq.Dynamic.Core) are not used with unsanitized user input for query construction. Severity: High. CWE: CWE-89.
- [ ] SC-CS-140: Stored procedure injection — Verify that stored procedure parameters are passed using `SqlParameter` objects and not concatenated into command text. Severity: Critical. CWE: CWE-89.
- [ ] SC-CS-141: SQL injection in ORDER BY clauses — Ensure dynamic sort column names are validated against an allowlist rather than passed directly into SQL ORDER BY clauses. Severity: High. CWE: CWE-89.
- [ ] SC-CS-142: SQL injection in LIKE patterns — Verify that user input used in LIKE clauses properly escapes wildcard characters (`%`, `_`, `[`). Severity: Medium. CWE: CWE-89.
- [ ] SC-CS-143: NoSQL injection in MongoDB queries — Ensure MongoDB query construction does not allow user input to modify query operators or structure via `BsonDocument` manipulation. Severity: High. CWE: CWE-943.
- [ ] SC-CS-144: Cosmos DB SQL injection — Verify that Azure Cosmos DB queries use parameterized `QueryDefinition` objects and not string-concatenated SQL. Severity: High. CWE: CWE-89.
- [ ] SC-CS-145: Database connection string injection — Ensure connection string components are not constructed from user input that could alter the connection target or credentials. Severity: High. CWE: CWE-89.
- [ ] SC-CS-146: Missing query timeout — Verify that database commands have appropriate `CommandTimeout` values to prevent long-running query denial of service. Severity: Medium. CWE: CWE-400.
- [ ] SC-CS-147: Excessive data retrieval — Ensure database queries use pagination and projection to limit the amount of data returned, preventing information disclosure and DoS. Severity: Medium. CWE: CWE-400.
- [ ] SC-CS-148: EF Core global query filters bypassed — Verify that `IgnoreQueryFilters()` is not used inappropriately, especially for soft-delete or tenant isolation filters. Severity: High. CWE: CWE-863.
- [ ] SC-CS-149: Missing database connection encryption — Ensure connection strings include `Encrypt=True` and `TrustServerCertificate=False` for SQL Server to enforce encrypted connections. Severity: High. CWE: CWE-319.
- [ ] SC-CS-150: SQL injection in table/column names — Verify that dynamic table and column names are validated against known schema elements and properly quoted using bracket notation. Severity: High. CWE: CWE-89.
- [ ] SC-CS-151: Dapper raw SQL injection — Ensure Dapper queries use parameterized SQL with `@paramName` syntax and `DynamicParameters` rather than string interpolation. Severity: Critical. CWE: CWE-89.
- [ ] SC-CS-152: ADO.NET command injection — Verify that `SqlCommand.CommandText` uses parameter placeholders and `SqlCommand.Parameters.AddWithValue()` for all user input. Severity: Critical. CWE: CWE-89.
- [ ] SC-CS-153: Database user has excessive privileges — Ensure the database connection uses a least-privilege account that does not have DBA or schema modification rights. Severity: High. CWE: CWE-250.
- [ ] SC-CS-154: Missing database audit logging — Verify that sensitive database operations (data access, schema changes) are logged for security auditing. Severity: Medium. CWE: CWE-778.
- [ ] SC-CS-155: Batch SQL injection — Ensure that batch operations constructing multiple SQL statements do not allow injection through list parameters. Severity: High. CWE: CWE-89.
- [ ] SC-CS-156: ORM lazy loading information disclosure — Verify that navigation property lazy loading does not inadvertently expose related entities beyond authorization boundaries. Severity: Medium. CWE: CWE-200.
- [ ] SC-CS-157: Second-order SQL injection — Ensure data read from the database is treated as untrusted when used to construct subsequent queries. Severity: High. CWE: CWE-89.
- [ ] SC-CS-158: Unparameterized EF Core string search — Verify that `EF.Functions.Like()` and `Contains()`/`StartsWith()` with user input are properly handled by the ORM's parameterization. Severity: Medium. CWE: CWE-89.
- [ ] SC-CS-159: Redis command injection — Ensure user input used in Redis commands via StackExchange.Redis is properly sanitized to prevent command injection. Severity: High. CWE: CWE-77.
- [ ] SC-CS-160: Missing database migration security review — Verify that EF Core migrations do not introduce security regressions such as removing encryption, dropping audit tables, or weakening constraints. Severity: Medium. CWE: CWE-1284.

### 8. File Operations (20 items)

- [ ] SC-CS-161: Path traversal via Path.Combine — Verify that `Path.Combine()` results are validated since an absolute path in the second argument ignores the first; use `Path.GetFullPath()` and validate the result is within the expected directory. Severity: Critical. CWE: CWE-22.
- [ ] SC-CS-162: Directory traversal via user-supplied file names — Ensure file names from user input are sanitized using `Path.GetFileName()` and do not contain `..`, `/`, or `\` sequences. Severity: Critical. CWE: CWE-22.
- [ ] SC-CS-163: Unrestricted file upload type — Verify that file upload endpoints validate file types using both extension allowlists and content-type/magic-byte verification. Severity: High. CWE: CWE-434.
- [ ] SC-CS-164: File upload size not limited — Ensure `IFormFile` uploads are constrained by `RequestSizeLimit`, `MultipartBodyLengthLimit`, and application-level validation. Severity: Medium. CWE: CWE-400.
- [ ] SC-CS-165: Uploaded files stored in web root — Verify that uploaded files are stored outside the web-accessible directory or in blob storage, not in `wwwroot`. Severity: High. CWE: CWE-434.
- [ ] SC-CS-166: Uploaded file executed as code — Ensure that the upload directory does not allow script execution and uploaded files are served with `Content-Disposition: attachment`. Severity: Critical. CWE: CWE-434.
- [ ] SC-CS-167: File inclusion via user input — Verify that user input does not control file paths used in `File.ReadAllText()`, `StreamReader`, or similar file reading operations without strict validation. Severity: High. CWE: CWE-73.
- [ ] SC-CS-168: Temporary file race condition — Ensure temporary files are created with unique names using `Path.GetTempFileName()` or `Path.GetRandomFileName()` and appropriate access permissions. Severity: Medium. CWE: CWE-377.
- [ ] SC-CS-169: Symbolic link following — Verify that file operations do not follow symbolic links (symlinks) that could redirect access to sensitive files outside the intended directory. Severity: High. CWE: CWE-59.
- [ ] SC-CS-170: File locking denial of service — Ensure file operations use appropriate `FileShare` modes and release locks promptly to prevent denial of service. Severity: Medium. CWE: CWE-667.
- [ ] SC-CS-171: Insecure file permissions — Verify that created files and directories have restrictive ACLs/permissions and do not grant world-readable or world-writable access. Severity: Medium. CWE: CWE-732.
- [ ] SC-CS-172: ZIP slip vulnerability — Ensure that extracting ZIP archives validates that entry paths do not escape the target directory using path traversal. Severity: High. CWE: CWE-22.
- [ ] SC-CS-173: ZIP bomb denial of service — Verify that ZIP extraction checks the decompressed size against limits before extracting to prevent resource exhaustion. Severity: Medium. CWE: CWE-400.
- [ ] SC-CS-174: Insecure file deletion — Ensure that file deletion operations verify the file is within the expected directory and the user is authorized to delete it. Severity: High. CWE: CWE-22.
- [ ] SC-CS-175: File name collision attack — Verify that uploaded files are renamed to random identifiers rather than using user-supplied file names to prevent overwriting. Severity: Medium. CWE: CWE-434.
- [ ] SC-CS-176: Static file middleware serves sensitive files — Ensure `UseStaticFiles()` is configured with restricted file extensions and does not serve `.config`, `.json`, or `.env` files. Severity: High. CWE: CWE-538.
- [ ] SC-CS-177: Missing antivirus scanning for uploads — Verify that uploaded files are scanned for malware before being stored or served to other users. Severity: Medium. CWE: CWE-434.
- [ ] SC-CS-178: Image processing denial of service — Ensure image processing libraries handle decompression bombs by validating image dimensions and pixel counts before processing. Severity: Medium. CWE: CWE-400.
- [ ] SC-CS-179: Sensitive file content in memory after read — Verify that byte arrays containing sensitive file content are zeroed after use to prevent memory dump exposure. Severity: Low. CWE: CWE-316.
- [ ] SC-CS-180: Insecure file download via Content-Disposition — Ensure `Content-Disposition` headers use properly encoded file names and the `attachment` disposition to prevent browser rendering. Severity: Medium. CWE: CWE-116.

### 9. Network & HTTP Security (20 items)

- [ ] SC-CS-181: SSRF via HttpClient — Verify that URLs passed to `HttpClient` are validated against an allowlist to prevent server-side request forgery targeting internal services. Severity: High. CWE: CWE-918.
- [ ] SC-CS-182: SSRF via WebClient or HttpWebRequest — Ensure legacy `WebClient` and `HttpWebRequest` usage validates destination URLs to prevent SSRF. Severity: High. CWE: CWE-918.
- [ ] SC-CS-183: DNS rebinding attack — Verify that DNS resolution results are validated before establishing connections to prevent DNS rebinding that bypasses URL allowlists. Severity: Medium. CWE: CWE-350.
- [ ] SC-CS-184: Missing Content-Security-Policy header — Ensure the Content-Security-Policy header is set with appropriate directives to prevent XSS and data injection. Severity: Medium. CWE: CWE-693.
- [ ] SC-CS-185: Missing X-Content-Type-Options header — Verify that `X-Content-Type-Options: nosniff` header is set to prevent MIME type sniffing. Severity: Low. CWE: CWE-693.
- [ ] SC-CS-186: Missing X-Frame-Options header — Ensure the `X-Frame-Options` header is set to `DENY` or `SAMEORIGIN` to prevent clickjacking attacks. Severity: Medium. CWE: CWE-1021.
- [ ] SC-CS-187: Missing Referrer-Policy header — Verify that `Referrer-Policy` header is configured to prevent leaking sensitive URL information to third parties. Severity: Low. CWE: CWE-200.
- [ ] SC-CS-188: Missing Permissions-Policy header — Ensure `Permissions-Policy` header restricts access to browser APIs (camera, microphone, geolocation) as needed. Severity: Low. CWE: CWE-693.
- [ ] SC-CS-189: HttpClient not using IHttpClientFactory — Verify that `HttpClient` instances are created via `IHttpClientFactory` to prevent socket exhaustion and enable centralized configuration. Severity: Medium. CWE: CWE-400.
- [ ] SC-CS-190: HTTP request smuggling — Ensure that reverse proxy configurations align with Kestrel's HTTP parsing behavior to prevent request smuggling. Severity: High. CWE: CWE-444.
- [ ] SC-CS-191: WebSocket connection not authenticated — Verify that WebSocket upgrade requests are authenticated and authorized before the connection is established. Severity: High. CWE: CWE-306.
- [ ] SC-CS-192: Missing rate limiting — Ensure rate limiting middleware is configured to prevent brute-force, enumeration, and denial-of-service attacks on sensitive endpoints. Severity: Medium. CWE: CWE-770.
- [ ] SC-CS-193: Insecure proxy header trust — Verify that `ForwardedHeaders` middleware only trusts known proxies and load balancers, not arbitrary clients. Severity: High. CWE: CWE-345.
- [ ] SC-CS-194: Host header injection — Ensure the application validates the Host header against known values and does not use it for URL generation without validation. Severity: Medium. CWE: CWE-644.
- [ ] SC-CS-195: Insecure redirect after login — Verify that post-login redirect URLs are validated to prevent open redirect attacks that steal credentials. Severity: Medium. CWE: CWE-601.
- [ ] SC-CS-196: Missing request size limits — Ensure Kestrel and/or reverse proxy configuration limits maximum request body size to prevent resource exhaustion. Severity: Medium. CWE: CWE-400.
- [ ] SC-CS-197: Kestrel exposed directly to internet — Verify that Kestrel is behind a reverse proxy (nginx, IIS, YARP) in production for proper HTTP handling and security. Severity: Medium. CWE: CWE-668.
- [ ] SC-CS-198: Missing CORS preflight handling — Ensure CORS preflight requests are handled correctly and do not expose overly permissive access control headers. Severity: Medium. CWE: CWE-942.
- [ ] SC-CS-199: HTTP/2 rapid reset DoS — Verify that the server is patched against CVE-2023-44487 (HTTP/2 Rapid Reset) and has connection-level limits configured. Severity: High. CWE: CWE-400.
- [ ] SC-CS-200: Insecure gRPC channel credentials — Ensure gRPC channels use `SslCredentials` or `ChannelCredentials` and not `ChannelCredentials.Insecure` in production. Severity: High. CWE: CWE-319.

### 10. Serialization & Deserialization (25 items)

- [ ] SC-CS-201: BinaryFormatter deserialization RCE — Verify that `BinaryFormatter` is not used anywhere in the codebase; it is inherently insecure and deprecated with no safe usage pattern. Severity: Critical. CWE: CWE-502.
- [ ] SC-CS-202: NetDataContractSerializer deserialization — Ensure `NetDataContractSerializer` is not used as it allows arbitrary type instantiation during deserialization. Severity: Critical. CWE: CWE-502.
- [ ] SC-CS-203: SoapFormatter deserialization — Verify that `SoapFormatter` is not used as it is vulnerable to the same deserialization attacks as `BinaryFormatter`. Severity: Critical. CWE: CWE-502.
- [ ] SC-CS-204: ObjectStateFormatter deserialization — Ensure `ObjectStateFormatter` (used internally by ViewState) is not used directly and ViewState MAC is enabled. Severity: Critical. CWE: CWE-502.
- [ ] SC-CS-205: LosFormatter deserialization — Verify that `LosFormatter` is not used as it inherits `BinaryFormatter` vulnerabilities. Severity: Critical. CWE: CWE-502.
- [ ] SC-CS-206: Newtonsoft.Json TypeNameHandling — Ensure `JsonSerializerSettings.TypeNameHandling` is set to `None` (default) and never to `All`, `Auto`, or `Objects` when deserializing untrusted input. Severity: Critical. CWE: CWE-502.
- [ ] SC-CS-207: Newtonsoft.Json missing SerializationBinder — Verify that when `TypeNameHandling` is necessary, a custom `ISerializationBinder` restricts allowed types to a strict allowlist. Severity: Critical. CWE: CWE-502.
- [ ] SC-CS-208: System.Text.Json polymorphic deserialization — Ensure `System.Text.Json` polymorphic deserialization uses `[JsonDerivedType]` with explicit type discriminators rather than accepting arbitrary type information. Severity: High. CWE: CWE-502.
- [ ] SC-CS-209: XmlSerializer with user-controlled type — Verify that the `Type` parameter of `XmlSerializer` constructor is not derived from user input, which enables arbitrary type instantiation. Severity: High. CWE: CWE-502.
- [ ] SC-CS-210: DataContractSerializer with untrusted types — Ensure `DataContractSerializer` known types are explicitly specified and not derived from untrusted input. Severity: High. CWE: CWE-502.
- [ ] SC-CS-211: XML External Entity (XXE) injection — Verify that `XmlReader`, `XmlDocument`, and `XDocument` disable DTD processing via `XmlReaderSettings.DtdProcessing = DtdProcessing.Prohibit`. Severity: Critical. CWE: CWE-611.
- [ ] SC-CS-212: XmlDocument XXE via XmlResolver — Ensure `XmlDocument.XmlResolver` is set to `null` to prevent external entity resolution. Severity: Critical. CWE: CWE-611.
- [ ] SC-CS-213: XslCompiledTransform injection — Verify that `XslCompiledTransform` does not enable `XsltSettings.EnableScript` when processing untrusted XSLT stylesheets. Severity: High. CWE: CWE-611.
- [ ] SC-CS-214: YAML deserialization RCE — Ensure YamlDotNet or other YAML libraries use safe deserialization modes that do not allow arbitrary type instantiation. Severity: Critical. CWE: CWE-502.
- [ ] SC-CS-215: MessagePack deserialization unsafe mode — Verify that MessagePack-CSharp uses `MessagePackSerializerOptions.Standard` with `Security.TrustedData` only for genuinely trusted data. Severity: High. CWE: CWE-502.
- [ ] SC-CS-216: Protobuf-net deserialization with RuntimeTypeModel — Ensure `protobuf-net` `RuntimeTypeModel` does not allow deserialization of arbitrary types from untrusted input. Severity: High. CWE: CWE-502.
- [ ] SC-CS-217: ViewState deserialization without MAC — Verify that ASP.NET Web Forms ViewState MAC validation (`EnableViewStateMac`) is enabled to prevent deserialization tampering. Severity: Critical. CWE: CWE-642.
- [ ] SC-CS-218: Custom deserialization via ISerializable — Ensure `ISerializable.GetObjectData()` and deserialization constructors do not expose sensitive data or allow type confusion. Severity: Medium. CWE: CWE-502.
- [ ] SC-CS-219: JSON deserialization denial of service — Verify that JSON deserialization has limits on maximum depth (`JsonSerializerOptions.MaxDepth`) to prevent stack overflow from deeply nested input. Severity: Medium. CWE: CWE-400.
- [ ] SC-CS-220: XML bomb (Billion Laughs) — Ensure XML parsing has limits on entity expansion to prevent exponential entity expansion attacks. Severity: High. CWE: CWE-776.
- [ ] SC-CS-221: Insecure deserialization in caching — Verify that cached objects are serialized/deserialized safely and that cache poisoning cannot trigger deserialization attacks. Severity: High. CWE: CWE-502.
- [ ] SC-CS-222: Type confusion via polymorphic deserialization — Ensure deserialization type resolution does not allow substitution of dangerous types (e.g., `System.Windows.Data.ObjectDataProvider`). Severity: Critical. CWE: CWE-502.
- [ ] SC-CS-223: Insecure deserialization in message queues — Verify that messages from RabbitMQ, Azure Service Bus, or other queues are deserialized safely with type restrictions. Severity: High. CWE: CWE-502.
- [ ] SC-CS-224: CSV injection via serialization — Ensure that data exported to CSV escapes formulas (cells starting with `=`, `+`, `-`, `@`) to prevent injection when opened in spreadsheets. Severity: Medium. CWE: CWE-1236.
- [ ] SC-CS-225: Deserialization of untrusted data in SignalR — Verify that custom SignalR message protocols deserialize with type restrictions and do not allow arbitrary type instantiation. Severity: High. CWE: CWE-502.

### 11. Concurrency & Race Conditions (15 items)

- [ ] SC-CS-226: TOCTOU race condition in file access — Verify that file existence checks and subsequent file operations are atomic or use file locking to prevent time-of-check-time-of-use vulnerabilities. Severity: Medium. CWE: CWE-367.
- [ ] SC-CS-227: TOCTOU in authorization checks — Ensure authorization state does not change between the check and the privileged operation, especially in async code. Severity: High. CWE: CWE-367.
- [ ] SC-CS-228: Race condition in singleton initialization — Verify that singleton services use `Lazy<T>`, `Interlocked`, or `lock` for thread-safe initialization. Severity: Medium. CWE: CWE-362.
- [ ] SC-CS-229: Shared mutable state in request handlers — Ensure that static fields and shared objects in controllers or services are thread-safe or request-scoped. Severity: High. CWE: CWE-362.
- [ ] SC-CS-230: Double-checked locking implementation errors — Verify that double-checked locking patterns use `volatile` keyword or `Lazy<T>` to prevent reading partially constructed objects. Severity: Medium. CWE: CWE-362.
- [ ] SC-CS-231: ConcurrentDictionary compound operations — Ensure that check-then-act patterns on `ConcurrentDictionary` use atomic methods like `GetOrAdd()` or `AddOrUpdate()`. Severity: Medium. CWE: CWE-362.
- [ ] SC-CS-232: Async race condition in ASP.NET context — Verify that `async`/`await` patterns do not introduce race conditions when accessing shared state between continuations. Severity: Medium. CWE: CWE-362.
- [ ] SC-CS-233: Race condition in distributed systems — Ensure distributed operations use optimistic concurrency (ETags, row versions) or distributed locks to prevent data corruption. Severity: High. CWE: CWE-362.
- [ ] SC-CS-234: Deadlock in async code — Verify that `.Result` or `.Wait()` is not called on async tasks from synchronous context, which can cause deadlocks in ASP.NET. Severity: Medium. CWE: CWE-833.
- [ ] SC-CS-235: Insufficient lock scope — Ensure critical sections protected by locks encompass all related state changes to maintain consistency. Severity: Medium. CWE: CWE-362.
- [ ] SC-CS-236: Race condition in token refresh — Verify that concurrent authentication token refresh operations are synchronized to prevent token reuse or invalidation races. Severity: Medium. CWE: CWE-362.
- [ ] SC-CS-237: Missing database transaction isolation — Ensure database operations that require consistency use appropriate transaction isolation levels to prevent dirty reads or phantom reads. Severity: Medium. CWE: CWE-362.
- [ ] SC-CS-238: Atomic file write not used — Verify that file writes that must be atomic use write-to-temp-then-rename patterns to prevent corruption from concurrent access. Severity: Medium. CWE: CWE-362.
- [ ] SC-CS-239: Race condition in rate limiting — Ensure rate limiting counters use atomic operations or distributed locks to prevent bypass through concurrent requests. Severity: Medium. CWE: CWE-362.
- [ ] SC-CS-240: Event handler race condition — Verify that event subscriptions and invocations use the null-conditional pattern (`handler?.Invoke()`) and consider thread safety of event state. Severity: Low. CWE: CWE-362.

### 12. Dependency & Supply Chain (20 items)

- [ ] SC-CS-241: Known vulnerabilities in NuGet packages — Verify that all NuGet package dependencies are scanned for known CVEs using `dotnet list package --vulnerable` or tools like Dependabot. Severity: High. CWE: CWE-1395.
- [ ] SC-CS-242: Outdated NuGet packages — Ensure dependencies are kept up to date using `dotnet list package --outdated` and that security patches are applied promptly. Severity: Medium. CWE: CWE-1395.
- [ ] SC-CS-243: Typosquatting NuGet packages — Verify package names are correct and from expected publishers to prevent typosquatting attacks (e.g., `Newtonsoft.Json` vs `NewtonSoft.Json`). Severity: High. CWE: CWE-427.
- [ ] SC-CS-244: Missing NuGet package signature verification — Ensure that NuGet is configured to require signed packages from trusted signers in `nuget.config`. Severity: Medium. CWE: CWE-494.
- [ ] SC-CS-245: Unrestricted NuGet package sources — Verify that `nuget.config` specifies only trusted package sources and does not include uncontrolled public feeds in enterprise environments. Severity: Medium. CWE: CWE-494.
- [ ] SC-CS-246: Dependency confusion attack — Ensure private NuGet feed configuration prevents packages with the same name on public feeds from being installed instead of internal packages. Severity: High. CWE: CWE-427.
- [ ] SC-CS-247: Transitive dependency vulnerabilities — Verify that transitive (indirect) dependencies are also scanned for vulnerabilities, not just direct dependencies. Severity: Medium. CWE: CWE-1395.
- [ ] SC-CS-248: Deprecated packages still in use — Ensure deprecated NuGet packages are identified and replaced with maintained alternatives. Severity: Low. CWE: CWE-1395.
- [ ] SC-CS-249: Build script injection — Verify that `.csproj`, `Directory.Build.props`, and `Directory.Build.targets` files do not execute untrusted scripts or download content during build. Severity: High. CWE: CWE-829.
- [ ] SC-CS-250: Global tools from untrusted sources — Ensure `dotnet tool install --global` only installs tools from trusted, verified sources. Severity: Medium. CWE: CWE-494.
- [ ] SC-CS-251: Missing lock file for reproducible builds — Verify that `packages.lock.json` is used and committed to ensure deterministic dependency resolution across builds. Severity: Medium. CWE: CWE-494.
- [ ] SC-CS-252: Runtime assembly loading from untrusted source — Ensure `Assembly.LoadFrom()` and `Assembly.Load()` do not load assemblies from user-controlled or network paths. Severity: Critical. CWE: CWE-494.
- [ ] SC-CS-253: MEF/plugin loading without validation — Verify that Managed Extensibility Framework (MEF) or custom plugin architectures validate and restrict loaded assemblies. Severity: High. CWE: CWE-494.
- [ ] SC-CS-254: Source generator supply chain risk — Ensure Roslyn source generators and analyzers in NuGet packages are from trusted publishers as they execute during compilation. Severity: High. CWE: CWE-494.
- [ ] SC-CS-255: Missing Software Bill of Materials (SBOM) — Verify that builds generate an SBOM for dependency tracking and vulnerability response. Severity: Low. CWE: CWE-1395.
- [ ] SC-CS-256: Native library dependency vulnerability — Ensure native DLL dependencies loaded via P/Invoke are also tracked and scanned for vulnerabilities. Severity: Medium. CWE: CWE-1395.
- [ ] SC-CS-257: Insecure NuGet package restore over HTTP — Verify that all NuGet package source URLs use HTTPS, not HTTP. Severity: High. CWE: CWE-494.
- [ ] SC-CS-258: Build-time code execution in packages — Ensure NuGet packages with build-time targets and props files are reviewed for malicious build-time code execution. Severity: High. CWE: CWE-829.
- [ ] SC-CS-259: Abandoned dependency with no maintainer — Verify that critical dependencies have active maintainers and are not archived or abandoned projects. Severity: Medium. CWE: CWE-1395.
- [ ] SC-CS-260: Excessive dependency scope — Ensure packages are referenced with the minimum required scope; avoid including development-only packages in production deployments. Severity: Low. CWE: CWE-1395.

### 13. Configuration & Secrets Management (20 items)

- [ ] SC-CS-261: Secrets in appsettings.json — Verify that production secrets (connection strings, API keys, passwords) are not stored in `appsettings.json` but use User Secrets, environment variables, or vault services. Severity: Critical. CWE: CWE-312.
- [ ] SC-CS-262: Missing User Secrets for development — Ensure `dotnet user-secrets` is used for local development instead of committing secrets to `appsettings.Development.json`. Severity: Medium. CWE: CWE-312.
- [ ] SC-CS-263: Azure Key Vault not used for production secrets — Verify that production deployments use Azure Key Vault, AWS Secrets Manager, or HashiCorp Vault for secret storage. Severity: High. CWE: CWE-312.
- [ ] SC-CS-264: Environment variables contain unprotected secrets — Ensure sensitive environment variables are limited in scope and access, and consider using encrypted configuration providers. Severity: Medium. CWE: CWE-312.
- [ ] SC-CS-265: Debug mode enabled in production — Verify that `ASPNETCORE_ENVIRONMENT` is not set to `Development` in production and that debug features are disabled. Severity: High. CWE: CWE-489.
- [ ] SC-CS-266: Swagger/OpenAPI exposed in production — Ensure Swagger UI and OpenAPI endpoints are disabled or restricted in production environments. Severity: Medium. CWE: CWE-215.
- [ ] SC-CS-267: Detailed error page in production — Verify that `app.UseDeveloperExceptionPage()` is only called in the development environment. Severity: High. CWE: CWE-209.
- [ ] SC-CS-268: Default credentials not changed — Ensure all default passwords, API keys, and admin accounts are changed before deployment to production. Severity: Critical. CWE: CWE-1393.
- [ ] SC-CS-269: Configuration file permissions too permissive — Verify that configuration files containing sensitive data have restricted file system permissions. Severity: Medium. CWE: CWE-732.
- [ ] SC-CS-270: Missing configuration validation — Ensure `IOptions<T>` configuration classes use `ValidateDataAnnotations()` or `Validate()` to catch misconfigurations at startup. Severity: Medium. CWE: CWE-1188.
- [ ] SC-CS-271: Feature flags expose unreleased features — Verify that feature flags for unreleased functionality cannot be toggled by end users. Severity: Medium. CWE: CWE-863.
- [ ] SC-CS-272: Insecure Kestrel configuration — Ensure Kestrel server limits (max request body size, header size, connection limits) are appropriately configured for production. Severity: Medium. CWE: CWE-400.
- [ ] SC-CS-273: Missing security headers in production — Verify that security headers middleware is not conditionally disabled in production via misconfigured feature flags. Severity: Medium. CWE: CWE-693.
- [ ] SC-CS-274: Database migration auto-applied in production — Ensure `context.Database.Migrate()` is not called automatically in production; use controlled migration processes. Severity: Medium. CWE: CWE-1188.
- [ ] SC-CS-275: Insecure default CORS configuration — Verify that CORS policy defaults do not allow all origins, headers, and methods in production. Severity: High. CWE: CWE-942.
- [ ] SC-CS-276: Secrets logged during startup — Ensure configuration validation and logging during application startup does not output secret values. Severity: High. CWE: CWE-532.
- [ ] SC-CS-277: Missing Content-Security-Policy in configuration — Verify that CSP headers are configured in the application pipeline and not accidentally removed by middleware ordering. Severity: Medium. CWE: CWE-693.
- [ ] SC-CS-278: IIS web.config exposes configuration — Ensure `web.config` does not contain sensitive information and that directory browsing is disabled. Severity: Medium. CWE: CWE-538.
- [ ] SC-CS-279: Missing encryption for configuration sections — Verify that sensitive configuration sections are encrypted using protected configuration providers when stored on disk. Severity: Medium. CWE: CWE-312.
- [ ] SC-CS-280: Service account credentials in source control — Ensure service account keys, certificates, and credentials are not committed to source control repositories. Severity: Critical. CWE: CWE-798.

### 14. Memory Safety & Unsafe Code (20 items)

- [ ] SC-CS-281: Buffer overflow in unsafe code — Verify that `unsafe` code blocks with pointer arithmetic include bounds checking to prevent buffer overflows. Severity: Critical. CWE: CWE-120.
- [ ] SC-CS-282: Use-after-free in unsafe code — Ensure that pointers in `unsafe` blocks do not reference memory that has been freed or garbage collected. Severity: Critical. CWE: CWE-416.
- [ ] SC-CS-283: Stack overflow via stackalloc — Verify that `stackalloc` sizes are bounded and validated to prevent stack overflow from large allocations. Severity: High. CWE: CWE-770.
- [ ] SC-CS-284: Span<T> and Memory<T> out-of-bounds access — Ensure `Span<T>` and `Memory<T>` slicing operations validate indices to prevent out-of-bounds memory access. Severity: High. CWE: CWE-125.
- [ ] SC-CS-285: Unsafe fixed buffer without bounds checking — Verify that `fixed` size buffers in structs include manual bounds checking for all access operations. Severity: High. CWE: CWE-120.
- [ ] SC-CS-286: P/Invoke buffer overflow — Ensure platform invoke (P/Invoke) calls correctly marshal buffer sizes and validate string lengths to prevent native buffer overflows. Severity: Critical. CWE: CWE-120.
- [ ] SC-CS-287: P/Invoke DLL hijacking — Verify that P/Invoke declarations use fully qualified DLL paths or the DLL is in a trusted location to prevent DLL preloading attacks. Severity: High. CWE: CWE-426.
- [ ] SC-CS-288: Unmanaged memory leak — Ensure `Marshal.AllocHGlobal()` and `Marshal.AllocCoTaskMem()` allocations are always freed in `finally` blocks or via `IDisposable`. Severity: Medium. CWE: CWE-401.
- [ ] SC-CS-289: GCHandle leak — Verify that `GCHandle.Alloc()` handles are freed with `GCHandle.Free()` to prevent memory leaks and GC interference. Severity: Medium. CWE: CWE-401.
- [ ] SC-CS-290: NativeMemory usage without bounds checking — Ensure `NativeMemory.Alloc()` (.NET 6+) allocations include proper size validation and are freed in all code paths. Severity: High. CWE: CWE-120.
- [ ] SC-CS-291: Incorrect struct layout for interop — Verify that `StructLayout` attributes correctly define field offsets and sizes for native interop to prevent memory corruption. Severity: High. CWE: CWE-131.
- [ ] SC-CS-292: Unsafe type casting via Unsafe.As<T> — Ensure `Unsafe.As<TFrom, TTo>()` and `Unsafe.AsRef<T>()` casts are validated to prevent type confusion and memory corruption. Severity: High. CWE: CWE-843.
- [ ] SC-CS-293: Missing SafeHandle for OS handles — Verify that OS handles (file handles, process handles, etc.) use `SafeHandle` derived types instead of raw `IntPtr` to ensure proper cleanup. Severity: Medium. CWE: CWE-404.
- [ ] SC-CS-294: Integer overflow in buffer size calculation — Ensure buffer size calculations in unsafe code use `checked` context or explicit overflow checks. Severity: High. CWE: CWE-190.
- [ ] SC-CS-295: Uninitialized stack memory via stackalloc — Verify that `stackalloc` memory is initialized (use `stackalloc byte[n]` which zero-initializes in C# since it is guaranteed, or explicitly clear). Severity: Medium. CWE: CWE-908.
- [ ] SC-CS-296: Ref returns to stack-allocated memory — Ensure `ref` returns do not reference stack-allocated (`stackalloc`) memory that will be invalid after the method returns. Severity: Critical. CWE: CWE-562.
- [ ] SC-CS-297: Memory<T> pinning issues — Verify that `Memory<T>` used with unmanaged code is properly pinned via `MemoryHandle` for the duration of the native operation. Severity: High. CWE: CWE-416.
- [ ] SC-CS-298: ArrayPool<T> buffer not cleared — Ensure buffers rented from `ArrayPool<T>` are cleared before return if they contained sensitive data, as they may be reused. Severity: Medium. CWE: CWE-316.
- [ ] SC-CS-299: COM interop memory corruption — Verify that COM interop marshaling correctly handles reference counting and memory ownership to prevent corruption. Severity: High. CWE: CWE-120.
- [ ] SC-CS-300: AllowUnsafeBlocks enabled without justification — Ensure `<AllowUnsafeBlocks>true</AllowUnsafeBlocks>` in `.csproj` is justified and unsafe code is minimized and thoroughly reviewed. Severity: Medium. CWE: CWE-676.

### 15. C#/.NET-Specific Patterns (25 items)

- [ ] SC-CS-301: Dispose not called on IDisposable — Verify that all `IDisposable` objects are disposed using `using` statements or `using` declarations to prevent resource leaks. Severity: Medium. CWE: CWE-404.
- [ ] SC-CS-302: Finalizer resurrection attack — Ensure finalizers do not re-root objects in a way that allows security checks to be bypassed during resurrection. Severity: Medium. CWE: CWE-568.
- [ ] SC-CS-303: Dynamic code generation via Reflection.Emit — Verify that `Reflection.Emit` usage does not incorporate untrusted input into generated IL code. Severity: High. CWE: CWE-94.
- [ ] SC-CS-304: CSharpScript.EvaluateAsync with user input — Ensure Roslyn scripting APIs (`CSharpScript`) do not evaluate user-controlled code strings, which enables arbitrary code execution. Severity: Critical. CWE: CWE-94.
- [ ] SC-CS-305: Activator.CreateInstance with untrusted type — Verify that `Activator.CreateInstance()` does not receive type names from untrusted input, which can instantiate dangerous types. Severity: Critical. CWE: CWE-470.
- [ ] SC-CS-306: Type.GetType with untrusted input — Ensure `Type.GetType()` does not resolve type names from user input, which enables type instantiation attacks. Severity: High. CWE: CWE-470.
- [ ] SC-CS-307: Assembly.Load with untrusted input — Verify that `Assembly.Load()` and `Assembly.LoadFrom()` do not load assemblies specified by untrusted input. Severity: Critical. CWE: CWE-494.
- [ ] SC-CS-308: Dynamic method invocation via reflection — Ensure `MethodInfo.Invoke()` with user-controlled method names is restricted to an allowlist of safe methods. Severity: High. CWE: CWE-470.
- [ ] SC-CS-309: Expression tree injection — Verify that LINQ expression trees constructed from user input are validated and do not allow arbitrary method calls. Severity: High. CWE: CWE-94.
- [ ] SC-CS-310: Insecure code in static constructors — Ensure static constructors do not perform security-sensitive operations that could be triggered at unexpected times. Severity: Medium. CWE: CWE-665.
- [ ] SC-CS-311: Thread-unsafe static state — Verify that static fields accessed from multiple threads use thread-safe patterns (`Interlocked`, `lock`, `ConcurrentDictionary`, etc.). Severity: Medium. CWE: CWE-362.
- [ ] SC-CS-312: String.Format injection — Ensure format strings passed to `String.Format()` are not user-controlled, which can cause format string information disclosure. Severity: Medium. CWE: CWE-134.
- [ ] SC-CS-313: Dangerous implicit conversion operators — Verify that custom implicit conversion operators do not silently lose data or bypass validation. Severity: Low. CWE: CWE-681.
- [ ] SC-CS-314: Equality comparison bypass — Ensure security-relevant equality comparisons override both `Equals()` and `GetHashCode()` consistently to prevent bypass via hash collisions. Severity: Medium. CWE: CWE-697.
- [ ] SC-CS-315: Enum validation with Enum.IsDefined — Verify that enum values from user input are validated using `Enum.IsDefined()` to prevent use of undefined enum values. Severity: Low. CWE: CWE-20.
- [ ] SC-CS-316: Delegate injection — Ensure delegates and `Action<T>`/`Func<T>` instances are not constructed from untrusted method references. Severity: High. CWE: CWE-470.
- [ ] SC-CS-317: Source generator security — Verify that Roslyn source generators do not introduce security vulnerabilities in generated code. Severity: Medium. CWE: CWE-94.
- [ ] SC-CS-318: Insecure AppDomain configuration — Ensure `AppDomain` creation (in .NET Framework) restricts permissions and does not grant full trust to untrusted code. Severity: High. CWE: CWE-269.
- [ ] SC-CS-319: Weak equality in security checks — Verify that security comparisons (password reset tokens, CSRF tokens) use constant-time comparison, not `==` or `String.Equals()`. Severity: High. CWE: CWE-208.
- [ ] SC-CS-320: ConfigureAwait(false) in security context — Ensure that `ConfigureAwait(false)` does not cause loss of security context (HttpContext, user claims) in ASP.NET applications. Severity: Medium. CWE: CWE-362.
- [ ] SC-CS-321: Null reference in security check — Verify that null checks are performed before security-relevant operations to prevent null reference exceptions that may bypass authorization. Severity: Medium. CWE: CWE-476.
- [ ] SC-CS-322: Record type equality bypass — Ensure security-critical comparisons using record types account for reference equality vs. value equality semantics. Severity: Low. CWE: CWE-697.
- [ ] SC-CS-323: ImmutableArray misuse — Verify that `ImmutableArray<T>.Default` (which is null-like) is not used where an empty array is expected, as it can cause `NullReferenceException`. Severity: Low. CWE: CWE-476.
- [ ] SC-CS-324: Regex compiled mode memory leak — Ensure `RegexOptions.Compiled` regexes are cached (static/singleton) as each compilation creates a new assembly that cannot be unloaded. Severity: Low. CWE: CWE-400.
- [ ] SC-CS-325: Task.Run exception swallowing — Verify that exceptions in `Task.Run` are observed; unobserved task exceptions can crash the process or be silently ignored depending on configuration. Severity: Medium. CWE: CWE-755.

### 16. ASP.NET Core-Specific (25 items)

- [ ] SC-CS-326: Missing middleware ordering — Verify that security middleware is ordered correctly: `UseAuthentication()` before `UseAuthorization()`, and `UseCors()` before `UseResponseCaching()`. Severity: High. CWE: CWE-862.
- [ ] SC-CS-327: UseStaticFiles before UseAuthorization — Ensure `UseStaticFiles()` placement does not bypass authentication/authorization for files that should be protected. Severity: High. CWE: CWE-862.
- [ ] SC-CS-328: Request body read multiple times without buffering — Verify that `EnableBuffering()` is called when the request body needs to be read multiple times to prevent data loss in validation. Severity: Medium. CWE: CWE-20.
- [ ] SC-CS-329: Model binding over-posting in Minimal APIs — Ensure Minimal API endpoints use specific parameter types and do not bind to entire request objects without validation. Severity: High. CWE: CWE-915.
- [ ] SC-CS-330: Endpoint filter bypass — Verify that endpoint filters (`IEndpointFilter`) for security checks cannot be bypassed by routing to unfiltered endpoints. Severity: High. CWE: CWE-862.
- [ ] SC-CS-331: Missing output caching security — Ensure `OutputCache` does not cache responses containing user-specific sensitive data that could be served to other users. Severity: High. CWE: CWE-524.
- [ ] SC-CS-332: Response compression oracle attack — Verify that response compression is not applied to responses containing secrets, as compression ratio can leak information (BREACH attack). Severity: Medium. CWE: CWE-200.
- [ ] SC-CS-333: Insecure health check endpoint — Ensure health check endpoints (`/health`) do not expose sensitive infrastructure details and are appropriately secured. Severity: Medium. CWE: CWE-215.
- [ ] SC-CS-334: Missing request validation in Razor Pages — Verify that Razor Pages use `[BindProperty]` with explicit property selection and validate `ModelState`. Severity: High. CWE: CWE-915.
- [ ] SC-CS-335: Insecure Razor Pages handler method — Ensure Razor Pages handler methods (`OnPost`, `OnGet`) validate anti-forgery tokens and authorization. Severity: High. CWE: CWE-352.
- [ ] SC-CS-336: Tag Helper XSS — Verify that custom Tag Helpers properly encode output to prevent XSS when rendering user-supplied attributes or content. Severity: High. CWE: CWE-79.
- [ ] SC-CS-337: View Component information disclosure — Ensure View Components do not expose sensitive data and respect authorization boundaries. Severity: Medium. CWE: CWE-200.
- [ ] SC-CS-338: Insecure data protection purpose strings — Verify that `IDataProtector.CreateProtector()` uses unique, application-specific purpose strings to prevent cross-application token reuse. Severity: Medium. CWE: CWE-327.
- [ ] SC-CS-339: Missing anti-forgery in AJAX requests — Ensure AJAX POST requests include the anti-forgery token in headers or form data when using cookie authentication. Severity: High. CWE: CWE-352.
- [ ] SC-CS-340: Insecure session state provider — Verify that session state is stored securely (encrypted, server-side) and not in client-accessible cookies without protection. Severity: Medium. CWE: CWE-311.
- [ ] SC-CS-341: Open redirect via Razor Pages redirect — Ensure `RedirectToPage()` and `Redirect()` in Razor Pages validate redirect targets against an allowlist. Severity: Medium. CWE: CWE-601.
- [ ] SC-CS-342: Routing constraint bypass — Verify that route constraints are not the sole security mechanism; apply authorization in addition to routing constraints. Severity: Medium. CWE: CWE-862.
- [ ] SC-CS-343: Background service running as privileged user — Ensure `IHostedService` and `BackgroundService` implementations do not run with elevated privileges unnecessarily. Severity: Medium. CWE: CWE-250.
- [ ] SC-CS-344: Insecure distributed cache configuration — Verify that distributed cache (Redis, SQL Server) connections are encrypted and authenticated. Severity: High. CWE: CWE-319.
- [ ] SC-CS-345: Missing X-Forwarded-For validation — Ensure `ForwardedHeadersOptions.KnownProxies` or `KnownNetworks` is configured when using `UseForwardedHeaders()`. Severity: High. CWE: CWE-345.
- [ ] SC-CS-346: Insecure cookie policy — Verify that `UseCookiePolicy()` enforces secure, HttpOnly, and SameSite requirements for all cookies. Severity: Medium. CWE: CWE-614.
- [ ] SC-CS-347: Missing request logging middleware — Ensure HTTP request logging captures sufficient information for security monitoring without logging sensitive request bodies. Severity: Low. CWE: CWE-778.
- [ ] SC-CS-348: Insecure Kestrel endpoint configuration — Verify that Kestrel HTTPS endpoints use strong TLS configurations and do not allow weak cipher suites. Severity: High. CWE: CWE-326.
- [ ] SC-CS-349: Missing Content-Length validation — Ensure `MaxRequestBodySize` is configured to prevent extremely large request bodies from causing resource exhaustion. Severity: Medium. CWE: CWE-400.
- [ ] SC-CS-350: Insecure YARP reverse proxy configuration — Verify that YARP (Yet Another Reverse Proxy) configuration does not allow forwarding to unintended backend services. Severity: High. CWE: CWE-918.

### 17. Blazor & SignalR-Specific (20 items)

- [ ] SC-CS-351: Blazor WASM secrets exposure — Verify that Blazor WebAssembly applications do not contain secrets, API keys, or connection strings as they are fully accessible to the client. Severity: Critical. CWE: CWE-312.
- [ ] SC-CS-352: Blazor JS interop injection — Ensure `IJSRuntime.InvokeAsync()` calls do not pass unsanitized user input as JavaScript code strings. Severity: High. CWE: CWE-79.
- [ ] SC-CS-353: Blazor Server circuit state manipulation — Verify that Blazor Server components validate all state changes server-side and do not trust client-originated state. Severity: High. CWE: CWE-602.
- [ ] SC-CS-354: SignalR hub method authorization — Ensure all SignalR hub methods that perform sensitive operations are decorated with `[Authorize]` or verify user authorization programmatically. Severity: High. CWE: CWE-862.
- [ ] SC-CS-355: SignalR message size limits — Verify that `MaximumReceiveMessageSize` is configured to prevent denial of service through oversized messages. Severity: Medium. CWE: CWE-400.
- [ ] SC-CS-356: SignalR connection rate limiting — Ensure connection rate limiting is applied to prevent SignalR connection exhaustion attacks. Severity: Medium. CWE: CWE-770.
- [ ] SC-CS-357: Blazor render XSS via MarkupString — Verify that `MarkupString` (equivalent to `Html.Raw()`) is not used with unsanitized user input in Blazor components. Severity: Critical. CWE: CWE-79.
- [ ] SC-CS-358: Blazor WASM authentication bypass — Ensure authentication state in Blazor WASM is validated server-side on every API call, not just client-side via `AuthenticationStateProvider`. Severity: Critical. CWE: CWE-602.
- [ ] SC-CS-359: SignalR cross-site WebSocket hijacking — Verify that SignalR validates the `Origin` header on WebSocket connections to prevent cross-site hijacking. Severity: High. CWE: CWE-346.
- [ ] SC-CS-360: Blazor component parameter tampering — Ensure Blazor components validate `[Parameter]` values as they can be set by parent components or URL routing. Severity: Medium. CWE: CWE-20.
- [ ] SC-CS-361: SignalR group membership not validated — Verify that adding users to SignalR groups validates authorization to prevent unauthorized access to group messages. Severity: High. CWE: CWE-862.
- [ ] SC-CS-362: Blazor Server reconnection token theft — Ensure Blazor Server circuit tokens are not exposed in logs or error messages that could allow session hijacking. Severity: High. CWE: CWE-200.
- [ ] SC-CS-363: Blazor WASM assembly decompilation — Verify that no security logic depends on Blazor WASM code remaining secret; treat all client-side code as public. Severity: Medium. CWE: CWE-602.
- [ ] SC-CS-364: SignalR streaming data authorization — Ensure `IAsyncEnumerable<T>` streaming hub methods validate authorization for the duration of the stream, not just at connection time. Severity: Medium. CWE: CWE-862.
- [ ] SC-CS-365: Blazor EditForm without validation — Verify that all Blazor `EditForm` components include `DataAnnotationsValidator` and validate input server-side. Severity: Medium. CWE: CWE-20.
- [ ] SC-CS-366: SignalR hub method parameter injection — Ensure SignalR hub method parameters are validated and do not accept complex types that could be exploited. Severity: Medium. CWE: CWE-20.
- [ ] SC-CS-367: Blazor NavigationManager open redirect — Verify that `NavigationManager.NavigateTo()` with user-controlled URLs validates the destination to prevent open redirects. Severity: Medium. CWE: CWE-601.
- [ ] SC-CS-368: SignalR transport downgrade — Ensure SignalR is configured to prefer secure transports (WebSockets with TLS) and does not fall back to insecure long polling without encryption. Severity: Medium. CWE: CWE-319.
- [ ] SC-CS-369: Blazor prerendering data exposure — Verify that Blazor Server prerendering does not expose data in the HTML that the user should not see before authentication. Severity: Medium. CWE: CWE-200.
- [ ] SC-CS-370: Blazor WASM HTTP interceptor bypass — Ensure that authentication token injection in Blazor WASM HTTP interceptors cannot be bypassed by direct `HttpClient` usage. Severity: Medium. CWE: CWE-306.

### 18. API Security (20 items)

- [ ] SC-CS-371: Missing API authentication — Verify that all API endpoints require authentication unless explicitly designed to be public. Severity: Critical. CWE: CWE-306.
- [ ] SC-CS-372: API key exposed in URL — Ensure API keys are sent via headers (e.g., `X-API-Key`) not in query strings where they may be logged. Severity: Medium. CWE: CWE-598.
- [ ] SC-CS-373: Missing API versioning security — Verify that deprecated API versions are decommissioned and do not remain accessible with known vulnerabilities. Severity: Medium. CWE: CWE-1059.
- [ ] SC-CS-374: GraphQL introspection enabled in production — Ensure GraphQL introspection is disabled in production to prevent schema discovery. Severity: Medium. CWE: CWE-215.
- [ ] SC-CS-375: GraphQL query depth attack — Verify that GraphQL endpoints have query depth, complexity, and breadth limits to prevent denial of service. Severity: High. CWE: CWE-400.
- [ ] SC-CS-376: GraphQL batching attack — Ensure GraphQL batching limits are set to prevent brute-force authentication or data enumeration via batched queries. Severity: Medium. CWE: CWE-307.
- [ ] SC-CS-377: Missing API rate limiting — Verify that API endpoints have rate limiting configured per client/IP to prevent abuse and denial of service. Severity: Medium. CWE: CWE-770.
- [ ] SC-CS-378: API response exposes internal IDs — Ensure API responses use opaque identifiers or UUIDs rather than sequential integer IDs that enable enumeration. Severity: Low. CWE: CWE-200.
- [ ] SC-CS-379: Missing pagination limits — Verify that list/search API endpoints enforce maximum page size limits to prevent excessive data retrieval. Severity: Medium. CWE: CWE-400.
- [ ] SC-CS-380: BOLA (Broken Object-Level Authorization) — Ensure every API endpoint that accesses resources by ID verifies the authenticated user's authorization to access that specific resource. Severity: High. CWE: CWE-639.
- [ ] SC-CS-381: Mass assignment via API request body — Verify that API DTOs expose only the fields intended for update and do not bind to internal-only properties. Severity: High. CWE: CWE-915.
- [ ] SC-CS-382: Missing Content-Type validation on API — Ensure API endpoints reject requests with unexpected Content-Type headers to prevent content-type confusion attacks. Severity: Medium. CWE: CWE-436.
- [ ] SC-CS-383: API response missing security headers — Verify that API responses include appropriate security headers (X-Content-Type-Options, Cache-Control for sensitive data). Severity: Low. CWE: CWE-693.
- [ ] SC-CS-384: Insecure API gateway configuration — Ensure API gateway or reverse proxy does not bypass backend authentication or authorization checks. Severity: High. CWE: CWE-306.
- [ ] SC-CS-385: JWT token reuse across APIs — Verify that JWT tokens include audience claims that restrict their use to specific APIs. Severity: Medium. CWE: CWE-345.
- [ ] SC-CS-386: Missing request ID for audit trail — Ensure all API requests generate unique request IDs logged for security audit and incident response. Severity: Low. CWE: CWE-778.
- [ ] SC-CS-387: Excessive data in error responses — Verify that API error responses follow a consistent schema and do not leak implementation details. Severity: Medium. CWE: CWE-209.
- [ ] SC-CS-388: OData query injection — Ensure OData-enabled endpoints restrict `$filter`, `$expand`, and `$select` to prevent unauthorized data access and injection. Severity: High. CWE: CWE-89.
- [ ] SC-CS-389: Webhook endpoint without signature verification — Verify that incoming webhook endpoints validate request signatures (HMAC, etc.) to prevent spoofed callbacks. Severity: High. CWE: CWE-345.
- [ ] SC-CS-390: Missing API throttling for expensive operations — Ensure computationally expensive API operations (reports, exports, searches) have stricter rate limits. Severity: Medium. CWE: CWE-400.

### 19. Testing & CI/CD Security (15 items)

- [ ] SC-CS-391: Test credentials in committed test code — Verify that test code does not contain real credentials, API keys, or connection strings that could be used against production systems. Severity: High. CWE: CWE-798.
- [ ] SC-CS-392: Missing security tests — Ensure the test suite includes specific security test cases for authentication, authorization, input validation, and injection prevention. Severity: Medium. CWE: CWE-1053.
- [ ] SC-CS-393: Test environment accessible from production — Verify that test environments are network-isolated from production to prevent test data leakage and cross-environment attacks. Severity: High. CWE: CWE-668.
- [ ] SC-CS-394: CI/CD pipeline secrets in logs — Ensure CI/CD pipelines mask secrets in build logs and do not echo environment variables containing credentials. Severity: High. CWE: CWE-532.
- [ ] SC-CS-395: Missing SAST in CI/CD pipeline — Verify that static application security testing (SAST) tools run in the CI/CD pipeline for every pull request. Severity: Medium. CWE: CWE-1053.
- [ ] SC-CS-396: Missing dependency scanning in CI/CD — Ensure the CI/CD pipeline includes `dotnet list package --vulnerable` or equivalent vulnerability scanning. Severity: Medium. CWE: CWE-1395.
- [ ] SC-CS-397: Test database contains production data — Verify that test databases use synthetic data and do not contain copies of production PII. Severity: High. CWE: CWE-359.
- [ ] SC-CS-398: Debug code left in production — Ensure debugging utilities, test backdoors, and development-only endpoints are not deployed to production. Severity: High. CWE: CWE-489.
- [ ] SC-CS-399: Missing code signing for published artifacts — Verify that published NuGet packages, executables, and DLLs are code-signed to ensure integrity. Severity: Medium. CWE: CWE-494.
- [ ] SC-CS-400: CI/CD pipeline allows unsigned commits — Ensure the CI/CD pipeline validates commit signatures or protected branch rules to prevent unauthorized code changes. Severity: Medium. CWE: CWE-345.
- [ ] SC-CS-401: Insecure artifact storage — Verify that build artifacts are stored in access-controlled repositories and are not publicly accessible. Severity: Medium. CWE: CWE-668.
- [ ] SC-CS-402: Missing container image scanning — Ensure Docker images used in deployment are scanned for vulnerabilities and use minimal base images. Severity: Medium. CWE: CWE-1395.
- [ ] SC-CS-403: Test mock bypassing security — Verify that security-critical services are not mocked in integration tests in ways that mask real vulnerabilities. Severity: Medium. CWE: CWE-1053.
- [ ] SC-CS-404: Secrets in Dockerfile or docker-compose — Ensure Docker configuration files do not contain embedded secrets; use Docker secrets or environment variable injection. Severity: High. CWE: CWE-312.
- [ ] SC-CS-405: Missing penetration testing — Verify that regular penetration testing is performed against the application to identify vulnerabilities not caught by automated tools. Severity: Medium. CWE: CWE-1053.

### 20. Third-Party Integration Security (15 items)

- [ ] SC-CS-406: OAuth token storage insecurity — Verify that OAuth access tokens and refresh tokens from third-party providers are stored encrypted and with appropriate access controls. Severity: High. CWE: CWE-312.
- [ ] SC-CS-407: Missing webhook payload validation — Ensure all incoming webhooks from third-party services validate payload signatures using the provider's documented verification method. Severity: High. CWE: CWE-345.
- [ ] SC-CS-408: Third-party SDK with excessive permissions — Verify that third-party SDKs and libraries do not request or use permissions beyond what is necessary for their functionality. Severity: Medium. CWE: CWE-250.
- [ ] SC-CS-409: Payment gateway integration insecurity — Ensure payment processing uses server-side tokenization and does not handle raw credit card data unless PCI DSS compliant. Severity: Critical. CWE: CWE-311.
- [ ] SC-CS-410: Email service injection — Verify that email sending via third-party APIs (SendGrid, Mailgun) sanitizes inputs to prevent email content injection. Severity: Medium. CWE: CWE-93.
- [ ] SC-CS-411: Cloud storage misconfiguration — Ensure Azure Blob Storage, AWS S3, or GCP Cloud Storage containers are not publicly accessible unless explicitly required. Severity: High. CWE: CWE-732.
- [ ] SC-CS-412: Third-party JavaScript loaded insecurely — Verify that third-party JavaScript resources use Subresource Integrity (SRI) hashes and are loaded over HTTPS. Severity: Medium. CWE: CWE-494.
- [ ] SC-CS-413: SSO integration misconfiguration — Ensure SAML and OpenID Connect integrations validate assertions, signatures, and audience restrictions correctly. Severity: High. CWE: CWE-287.
- [ ] SC-CS-414: Missing third-party API error handling — Verify that failures in third-party API calls are handled gracefully without exposing internal details or entering insecure states. Severity: Medium. CWE: CWE-755.
- [ ] SC-CS-415: Third-party callback URL not validated — Ensure callback URLs for third-party integrations (OAuth, payment) are validated against an allowlist to prevent redirection attacks. Severity: High. CWE: CWE-601.
- [ ] SC-CS-416: Insecure third-party message queue connection — Verify that connections to external message brokers (RabbitMQ, Azure Service Bus) use TLS and authentication. Severity: High. CWE: CWE-319.
- [ ] SC-CS-417: Third-party library phone-home behavior — Ensure third-party libraries do not transmit telemetry or usage data that includes sensitive application information. Severity: Medium. CWE: CWE-359.
- [ ] SC-CS-418: MAUI/Xamarin insecure data storage — Verify that .NET MAUI and Xamarin applications use platform-specific secure storage (Keychain, Keystore) for sensitive data rather than `Preferences`. Severity: High. CWE: CWE-922.
- [ ] SC-CS-419: MAUI/Xamarin WebView injection — Ensure `WebView` components in MAUI/Xamarin do not load untrusted content or enable JavaScript bridges that expose native APIs. Severity: High. CWE: CWE-79.
- [ ] SC-CS-420: Missing vendor security assessment — Verify that third-party service providers undergo security assessment and that their security posture is periodically reviewed. Severity: Low. CWE: CWE-1059.
