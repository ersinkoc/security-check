# API Security Checklist

> 200+ security checks for REST, GraphQL, and gRPC APIs.
> Used by security-check sc-api-security skill as reference.

## How to Use
This checklist is automatically referenced by the sc-api-security skill during security scans.
Each item follows the format: `SC-API-{NNN}: Title — Description. Severity: Critical|High|Medium|Low. CWE: CWE-XXX.`

---

## Categories

### 1. Authentication (20 items)

- [ ] SC-API-001: Enforce authentication on all endpoints — Every API endpoint must require authentication unless explicitly designated as public. Severity: Critical. CWE: CWE-306.
- [ ] SC-API-002: Use strong password hashing — Store passwords using bcrypt, scrypt, or Argon2id with appropriate work factors. Severity: Critical. CWE: CWE-916.
- [ ] SC-API-003: Implement multi-factor authentication — Provide MFA for sensitive operations and administrative endpoints. Severity: High. CWE: CWE-308.
- [ ] SC-API-004: Enforce account lockout after failed attempts — Lock accounts temporarily after a configurable number of failed login attempts. Severity: High. CWE: CWE-307.
- [ ] SC-API-005: Use secure session identifiers — Generate session tokens with sufficient entropy (at least 128 bits). Severity: High. CWE: CWE-330.
- [ ] SC-API-006: Invalidate sessions on logout — Destroy server-side session state when a user logs out. Severity: Medium. CWE: CWE-613.
- [ ] SC-API-007: Implement session expiration — Set absolute and idle timeout values for all sessions. Severity: Medium. CWE: CWE-613.
- [ ] SC-API-008: Prevent credential stuffing — Detect and block automated login attempts using known breached credential lists. Severity: High. CWE: CWE-521.
- [ ] SC-API-009: Validate redirect URIs in OAuth flows — Strictly validate redirect URIs against a whitelist to prevent open redirect attacks. Severity: High. CWE: CWE-601.
- [ ] SC-API-010: Enforce PKCE for OAuth public clients — Require Proof Key for Code Exchange for all public OAuth clients. Severity: High. CWE: CWE-345.
- [ ] SC-API-011: Rotate API keys periodically — Enforce automatic rotation of API keys on a defined schedule. Severity: Medium. CWE: CWE-798.
- [ ] SC-API-012: Do not expose credentials in URLs — Never pass tokens, API keys, or passwords as query parameters. Severity: High. CWE: CWE-598.
- [ ] SC-API-013: Implement secure password reset — Use time-limited, single-use tokens for password reset flows. Severity: High. CWE: CWE-640.
- [ ] SC-API-014: Validate authentication tokens on every request — Verify token integrity and expiration server-side for each API call. Severity: Critical. CWE: CWE-302.
- [ ] SC-API-015: Use constant-time comparison for secrets — Compare tokens, hashes, and secrets using constant-time algorithms to prevent timing attacks. Severity: Medium. CWE: CWE-208.
- [ ] SC-API-016: Disable default or demo credentials — Remove all default, demo, or test credentials before deployment. Severity: Critical. CWE: CWE-798.
- [ ] SC-API-017: Protect against username enumeration — Return identical responses for valid and invalid usernames during login and registration. Severity: Medium. CWE: CWE-203.
- [ ] SC-API-018: Secure OAuth state parameter — Use unpredictable, per-session state parameters in OAuth flows to prevent CSRF. Severity: High. CWE: CWE-352.
- [ ] SC-API-019: Restrict authentication to TLS only — Refuse authentication attempts over unencrypted connections. Severity: Critical. CWE: CWE-319.
- [ ] SC-API-020: Implement device fingerprinting for anomaly detection — Track device characteristics to detect suspicious authentication from unknown devices. Severity: Low. CWE: CWE-778.

### 2. Authorization (20 items)

- [ ] SC-API-021: Enforce principle of least privilege — Grant the minimum permissions necessary for each API consumer. Severity: High. CWE: CWE-269.
- [ ] SC-API-022: Implement role-based access control — Define and enforce roles with specific permission sets for all API endpoints. Severity: High. CWE: CWE-285.
- [ ] SC-API-023: Validate object-level authorization — Verify that the authenticated user has permission to access each specific resource. Severity: Critical. CWE: CWE-639.
- [ ] SC-API-024: Validate function-level authorization — Check that the user is authorized to perform the requested operation. Severity: Critical. CWE: CWE-285.
- [ ] SC-API-025: Prevent IDOR vulnerabilities — Ensure direct object references cannot be manipulated to access other users' data. Severity: Critical. CWE: CWE-639.
- [ ] SC-API-026: Enforce authorization on all nested resources — Check permissions on parent and child resources in hierarchical data models. Severity: High. CWE: CWE-863.
- [ ] SC-API-027: Deny access by default — Default to denying access unless an explicit allow rule exists. Severity: High. CWE: CWE-276.
- [ ] SC-API-028: Validate authorization server-side — Never rely on client-side authorization checks alone. Severity: Critical. CWE: CWE-602.
- [ ] SC-API-029: Implement attribute-based access control where needed — Use ABAC for fine-grained authorization decisions based on user, resource, and context attributes. Severity: Medium. CWE: CWE-285.
- [ ] SC-API-030: Prevent privilege escalation — Ensure users cannot elevate their own permissions through API calls. Severity: Critical. CWE: CWE-269.
- [ ] SC-API-031: Enforce tenant isolation in multi-tenant APIs — Verify that tenants cannot access or modify data belonging to other tenants. Severity: Critical. CWE: CWE-668.
- [ ] SC-API-032: Restrict administrative endpoints — Limit admin API access to specific IP ranges, networks, or VPNs. Severity: High. CWE: CWE-749.
- [ ] SC-API-033: Validate authorization for bulk operations — Ensure batch endpoints check permissions on every individual item. Severity: High. CWE: CWE-863.
- [ ] SC-API-034: Audit authorization policy changes — Log all modifications to access control rules with full context. Severity: Medium. CWE: CWE-778.
- [ ] SC-API-035: Implement scope validation for OAuth tokens — Verify that the OAuth token scope permits the requested operation. Severity: High. CWE: CWE-863.
- [ ] SC-API-036: Prevent horizontal privilege escalation — Ensure users cannot access resources of other users at the same privilege level. Severity: Critical. CWE: CWE-639.
- [ ] SC-API-037: Restrict mass assignment — Explicitly whitelist fields that can be set through API requests. Severity: High. CWE: CWE-915.
- [ ] SC-API-038: Enforce authorization on file and media endpoints — Verify permissions before serving uploaded files or media resources. Severity: High. CWE: CWE-862.
- [ ] SC-API-039: Implement time-based access restrictions — Support temporal access policies for sensitive operations. Severity: Low. CWE: CWE-285.
- [ ] SC-API-040: Validate delegation and impersonation tokens — Ensure delegated access tokens carry proper authorization constraints. Severity: High. CWE: CWE-863.

### 3. Input Validation (25 items)

- [ ] SC-API-041: Validate all input server-side — Perform input validation on the server regardless of client-side checks. Severity: Critical. CWE: CWE-20.
- [ ] SC-API-042: Sanitize input to prevent SQL injection — Use parameterized queries or ORM for all database operations. Severity: Critical. CWE: CWE-89.
- [ ] SC-API-043: Sanitize input to prevent NoSQL injection — Validate and sanitize query operators in NoSQL database calls. Severity: Critical. CWE: CWE-943.
- [ ] SC-API-044: Prevent command injection — Never pass unsanitized user input to OS command interpreters. Severity: Critical. CWE: CWE-78.
- [ ] SC-API-045: Prevent XSS via API responses — Encode output properly and set appropriate Content-Type headers. Severity: High. CWE: CWE-79.
- [ ] SC-API-046: Validate Content-Type headers — Reject requests with unexpected or mismatched Content-Type headers. Severity: Medium. CWE: CWE-436.
- [ ] SC-API-047: Enforce request body size limits — Reject payloads exceeding the maximum allowed size. Severity: Medium. CWE: CWE-400.
- [ ] SC-API-048: Validate JSON schema — Validate request bodies against predefined JSON schemas. Severity: Medium. CWE: CWE-20.
- [ ] SC-API-049: Sanitize file uploads — Validate file type, size, and content; store uploads outside webroot. Severity: High. CWE: CWE-434.
- [ ] SC-API-050: Prevent XML External Entity attacks — Disable DTD processing and external entity resolution in XML parsers. Severity: Critical. CWE: CWE-611.
- [ ] SC-API-051: Validate URL parameters — Reject URL parameters containing unexpected characters or patterns. Severity: Medium. CWE: CWE-20.
- [ ] SC-API-052: Prevent LDAP injection — Sanitize user input used in LDAP queries. Severity: High. CWE: CWE-90.
- [ ] SC-API-053: Prevent XPath injection — Sanitize user input used in XPath expressions. Severity: High. CWE: CWE-643.
- [ ] SC-API-054: Validate email addresses — Use strict validation for email inputs to prevent header injection. Severity: Medium. CWE: CWE-93.
- [ ] SC-API-055: Prevent HTTP header injection — Sanitize user input included in HTTP response headers. Severity: High. CWE: CWE-113.
- [ ] SC-API-056: Validate numeric input ranges — Enforce minimum and maximum values for numeric parameters. Severity: Medium. CWE: CWE-190.
- [ ] SC-API-057: Prevent SSRF attacks — Validate and restrict URLs fetched based on user input. Severity: Critical. CWE: CWE-918.
- [ ] SC-API-058: Validate array and collection sizes — Limit the number of elements in array inputs to prevent resource exhaustion. Severity: Medium. CWE: CWE-400.
- [ ] SC-API-059: Sanitize input for template injection — Prevent user input from being interpreted as template directives. Severity: High. CWE: CWE-1336.
- [ ] SC-API-060: Validate Unicode and encoding — Normalize and validate Unicode input to prevent encoding-based bypasses. Severity: Medium. CWE: CWE-176.
- [ ] SC-API-061: Reject null bytes in input — Strip or reject null byte characters that could truncate strings. Severity: Medium. CWE: CWE-626.
- [ ] SC-API-062: Validate path traversal in file parameters — Reject input containing path traversal sequences like ../ or encoded variants. Severity: Critical. CWE: CWE-22.
- [ ] SC-API-063: Prevent prototype pollution — Validate JSON keys to prevent __proto__, constructor, or prototype manipulation. Severity: High. CWE: CWE-1321.
- [ ] SC-API-064: Validate regular expression input — Reject or sanitize user-supplied regex to prevent ReDoS attacks. Severity: Medium. CWE: CWE-1333.
- [ ] SC-API-065: Implement input allow-lists over deny-lists — Prefer whitelisting valid input patterns over blacklisting known-bad patterns. Severity: Medium. CWE: CWE-184.

### 4. Rate Limiting & DoS Prevention (15 items)

- [ ] SC-API-066: Implement rate limiting on all endpoints — Apply request rate limits per user, IP, or API key. Severity: High. CWE: CWE-770.
- [ ] SC-API-067: Rate limit authentication endpoints aggressively — Apply stricter rate limits to login, registration, and password reset endpoints. Severity: High. CWE: CWE-307.
- [ ] SC-API-068: Implement exponential backoff for retries — Require clients to use exponential backoff when retrying failed requests. Severity: Medium. CWE: CWE-770.
- [ ] SC-API-069: Set request timeout limits — Terminate long-running requests to prevent thread or connection exhaustion. Severity: High. CWE: CWE-400.
- [ ] SC-API-070: Protect against Slowloris attacks — Configure web servers to detect and close slow HTTP connections. Severity: Medium. CWE: CWE-400.
- [ ] SC-API-071: Limit concurrent connections per client — Restrict the number of simultaneous connections from a single source. Severity: Medium. CWE: CWE-770.
- [ ] SC-API-072: Implement pagination limits — Enforce maximum page sizes and prevent unbounded list queries. Severity: Medium. CWE: CWE-400.
- [ ] SC-API-073: Rate limit by operation cost — Apply rate limits based on the computational cost of operations, not just request count. Severity: Medium. CWE: CWE-770.
- [ ] SC-API-074: Protect against ZIP bomb uploads — Validate decompressed sizes of uploaded compressed files. Severity: High. CWE: CWE-409.
- [ ] SC-API-075: Implement circuit breakers for downstream services — Prevent cascading failures by stopping requests to unhealthy downstream services. Severity: Medium. CWE: CWE-400.
- [ ] SC-API-076: Set connection pool limits — Configure maximum connection pool sizes for databases and external services. Severity: Medium. CWE: CWE-770.
- [ ] SC-API-077: Limit query depth and complexity — Restrict recursive or deeply nested queries to prevent resource exhaustion. Severity: High. CWE: CWE-400.
- [ ] SC-API-078: Implement request queuing — Use queues to manage burst traffic and protect backend services. Severity: Medium. CWE: CWE-770.
- [ ] SC-API-079: Return rate limit headers — Include X-RateLimit-Limit, X-RateLimit-Remaining, and Retry-After headers. Severity: Low. CWE: CWE-770.
- [ ] SC-API-080: Protect webhook endpoints from abuse — Rate limit and validate incoming webhook requests to prevent DoS. Severity: Medium. CWE: CWE-400.

### 5. Data Exposure (20 items)

- [ ] SC-API-081: Minimize data in API responses — Return only the fields required by the client, not full database records. Severity: High. CWE: CWE-200.
- [ ] SC-API-082: Never expose stack traces in production — Suppress detailed error information and stack traces in production responses. Severity: High. CWE: CWE-209.
- [ ] SC-API-083: Redact sensitive data in logs — Mask passwords, tokens, credit card numbers, and PII in log entries. Severity: High. CWE: CWE-532.
- [ ] SC-API-084: Prevent internal IP disclosure — Ensure API responses do not leak internal IP addresses or hostnames. Severity: Medium. CWE: CWE-200.
- [ ] SC-API-085: Remove server version headers — Strip Server, X-Powered-By, and similar technology-revealing headers. Severity: Low. CWE: CWE-200.
- [ ] SC-API-086: Encrypt sensitive data at rest — Encrypt PII, credentials, and sensitive business data in storage. Severity: High. CWE: CWE-311.
- [ ] SC-API-087: Encrypt data in transit with TLS 1.2+ — Enforce TLS 1.2 or higher for all API communications. Severity: Critical. CWE: CWE-319.
- [ ] SC-API-088: Implement field-level encryption for sensitive data — Apply additional encryption for highly sensitive fields beyond transport encryption. Severity: Medium. CWE: CWE-311.
- [ ] SC-API-089: Prevent data leakage through caching — Set Cache-Control: no-store for responses containing sensitive data. Severity: Medium. CWE: CWE-524.
- [ ] SC-API-090: Sanitize debug information from responses — Remove debug metadata, SQL queries, and internal state from production responses. Severity: High. CWE: CWE-215.
- [ ] SC-API-091: Implement response filtering by user role — Return different response schemas based on the requester's authorization level. Severity: Medium. CWE: CWE-200.
- [ ] SC-API-092: Prevent enumeration of resources — Use non-sequential, unpredictable identifiers for resources. Severity: Medium. CWE: CWE-330.
- [ ] SC-API-093: Mask sensitive query parameters in logs — Ensure URL query strings containing tokens or secrets are not logged. Severity: High. CWE: CWE-532.
- [ ] SC-API-094: Prevent data exposure through error messages — Use generic error messages that do not reveal schema or data details. Severity: Medium. CWE: CWE-209.
- [ ] SC-API-095: Enforce data classification policies — Tag and handle data according to its classification level (public, internal, confidential, restricted). Severity: Medium. CWE: CWE-200.
- [ ] SC-API-096: Implement proper data anonymization — Anonymize or pseudonymize personal data in non-production environments. Severity: Medium. CWE: CWE-359.
- [ ] SC-API-097: Prevent metadata leakage in file responses — Strip EXIF, GPS, and other metadata from served images and documents. Severity: Medium. CWE: CWE-200.
- [ ] SC-API-098: Control data exposure in error pages — Ensure custom error pages do not expose system information. Severity: Low. CWE: CWE-209.
- [ ] SC-API-099: Prevent timing-based data exposure — Ensure response times do not vary based on the existence of resources. Severity: Medium. CWE: CWE-208.
- [ ] SC-API-100: Restrict export and download functionality — Apply authorization and rate limiting to bulk data export endpoints. Severity: High. CWE: CWE-359.

### 6. REST-Specific Security (20 items)

- [ ] SC-API-101: Use proper HTTP methods — Map CRUD operations to correct HTTP verbs and reject unsupported methods. Severity: Medium. CWE: CWE-749.
- [ ] SC-API-102: Implement CSRF protection for cookie-based auth — Use anti-CSRF tokens or SameSite cookies for state-changing operations. Severity: High. CWE: CWE-352.
- [ ] SC-API-103: Validate Accept headers — Return responses only in expected content types. Severity: Low. CWE: CWE-436.
- [ ] SC-API-104: Enforce idempotency for unsafe methods — Use idempotency keys for PUT, POST, and DELETE operations to prevent duplicate processing. Severity: Medium. CWE: CWE-841.
- [ ] SC-API-105: Prevent HTTP method override abuse — Restrict or disable X-HTTP-Method-Override header usage. Severity: Medium. CWE: CWE-749.
- [ ] SC-API-106: Implement HATEOAS securely — Ensure hypermedia links in responses do not expose unauthorized endpoints. Severity: Low. CWE: CWE-200.
- [ ] SC-API-107: Validate and limit query string parameters — Reject unknown query parameters and enforce length limits. Severity: Medium. CWE: CWE-20.
- [ ] SC-API-108: Secure RESTful file upload endpoints — Validate MIME types, scan for malware, and limit file sizes on upload endpoints. Severity: High. CWE: CWE-434.
- [ ] SC-API-109: Prevent HTTP parameter pollution — Reject requests with duplicate parameter names. Severity: Medium. CWE: CWE-235.
- [ ] SC-API-110: Implement proper HTTP status codes — Return accurate status codes to avoid leaking information through incorrect codes. Severity: Low. CWE: CWE-209.
- [ ] SC-API-111: Disable TRACE and TRACK methods — Disable HTTP TRACE and TRACK to prevent cross-site tracing attacks. Severity: Medium. CWE: CWE-693.
- [ ] SC-API-112: Enforce HTTPS redirects — Redirect all HTTP requests to HTTPS with 301 status codes. Severity: High. CWE: CWE-319.
- [ ] SC-API-113: Validate ETag and conditional request headers — Properly implement ETags to prevent cache poisoning or stale data attacks. Severity: Low. CWE: CWE-436.
- [ ] SC-API-114: Secure PATCH operations — Validate partial update payloads against the resource schema. Severity: Medium. CWE: CWE-20.
- [ ] SC-API-115: Implement request signing for critical endpoints — Require HMAC or digital signatures for high-value operations. Severity: High. CWE: CWE-345.
- [ ] SC-API-116: Prevent HTTP response splitting — Sanitize user input included in response headers to prevent CRLF injection. Severity: High. CWE: CWE-113.
- [ ] SC-API-117: Secure content negotiation — Validate and limit supported media types to prevent content-type attacks. Severity: Medium. CWE: CWE-436.
- [ ] SC-API-118: Implement proper OPTIONS response — Return accurate CORS preflight responses without excessive permissions. Severity: Medium. CWE: CWE-942.
- [ ] SC-API-119: Validate resource relationships in requests — Ensure referenced resources exist and are accessible to the requester. Severity: Medium. CWE: CWE-639.
- [ ] SC-API-120: Enforce strict URL path validation — Reject requests with path anomalies such as double slashes or encoded separators. Severity: Medium. CWE: CWE-22.

### 7. GraphQL-Specific Security (25 items)

- [ ] SC-API-121: Limit query depth — Enforce a maximum query nesting depth to prevent deep recursion attacks. Severity: High. CWE: CWE-400.
- [ ] SC-API-122: Limit query complexity — Assign costs to fields and reject queries exceeding a complexity threshold. Severity: High. CWE: CWE-400.
- [ ] SC-API-123: Disable introspection in production — Turn off GraphQL schema introspection on production endpoints. Severity: High. CWE: CWE-200.
- [ ] SC-API-124: Implement query whitelisting — Allow only pre-approved persisted queries in production. Severity: High. CWE: CWE-400.
- [ ] SC-API-125: Prevent batch query abuse — Limit the number of queries allowed in a single batched request. Severity: Medium. CWE: CWE-400.
- [ ] SC-API-126: Implement field-level authorization — Check permissions on individual fields, not just types or root queries. Severity: Critical. CWE: CWE-863.
- [ ] SC-API-127: Prevent alias-based rate limit bypass — Count aliased fields toward rate limits to prevent abuse. Severity: Medium. CWE: CWE-770.
- [ ] SC-API-128: Validate and limit fragment usage — Restrict the number and depth of fragment definitions and spreads. Severity: Medium. CWE: CWE-400.
- [ ] SC-API-129: Protect against circular fragment references — Detect and reject queries with circular fragment definitions. Severity: High. CWE: CWE-674.
- [ ] SC-API-130: Implement resolver-level authorization — Enforce access control within each GraphQL resolver function. Severity: Critical. CWE: CWE-862.
- [ ] SC-API-131: Limit selection set size — Restrict the total number of fields that can be selected in a single query. Severity: Medium. CWE: CWE-400.
- [ ] SC-API-132: Prevent N+1 query attacks — Use DataLoader patterns and query analysis to prevent database overload. Severity: Medium. CWE: CWE-400.
- [ ] SC-API-133: Secure subscription endpoints — Apply authentication and authorization to WebSocket-based subscriptions. Severity: High. CWE: CWE-306.
- [ ] SC-API-134: Validate custom scalar types — Implement strict parsing and serialization for custom GraphQL scalars. Severity: Medium. CWE: CWE-20.
- [ ] SC-API-135: Prevent GraphQL injection in dynamic queries — Never construct GraphQL queries from unsanitized user input. Severity: Critical. CWE: CWE-94.
- [ ] SC-API-136: Implement query cost analysis — Calculate and enforce query cost limits before execution begins. Severity: High. CWE: CWE-400.
- [ ] SC-API-137: Secure GraphQL playground and IDE tools — Disable GraphQL Playground, GraphiQL, and similar tools in production. Severity: Medium. CWE: CWE-200.
- [ ] SC-API-138: Implement cursor-based pagination — Use opaque cursors instead of offset-based pagination to prevent data scraping. Severity: Medium. CWE: CWE-200.
- [ ] SC-API-139: Validate mutation input types — Enforce strict input type validation for all mutation arguments. Severity: High. CWE: CWE-20.
- [ ] SC-API-140: Prevent directive abuse — Validate and restrict the use of custom and built-in directives. Severity: Medium. CWE: CWE-20.
- [ ] SC-API-141: Rate limit by query complexity — Apply rate limits based on computed query cost rather than request count. Severity: Medium. CWE: CWE-770.
- [ ] SC-API-142: Protect against field suggestion leakage — Disable or customize "Did you mean" suggestions that reveal schema details. Severity: Low. CWE: CWE-200.
- [ ] SC-API-143: Implement timeout per query execution — Cancel queries that exceed a maximum execution time. Severity: Medium. CWE: CWE-400.
- [ ] SC-API-144: Secure federated GraphQL gateways — Validate and authorize requests across federated subgraphs. Severity: High. CWE: CWE-863.
- [ ] SC-API-145: Prevent schema definition language injection — Sanitize any user input that could influence SDL parsing. Severity: High. CWE: CWE-94.

### 8. gRPC-Specific Security (15 items)

- [ ] SC-API-146: Enforce TLS for all gRPC channels — Use TLS for all gRPC connections; never allow insecure plaintext channels in production. Severity: Critical. CWE: CWE-319.
- [ ] SC-API-147: Implement per-RPC authentication — Attach and validate credentials for each individual RPC call. Severity: High. CWE: CWE-306.
- [ ] SC-API-148: Validate Protobuf message sizes — Set maximum receive and send message size limits on gRPC channels. Severity: Medium. CWE: CWE-400.
- [ ] SC-API-149: Implement gRPC interceptors for authorization — Use server interceptors to enforce access control on all RPCs. Severity: High. CWE: CWE-862.
- [ ] SC-API-150: Validate Protobuf field values — Enforce validation rules on all Protobuf message fields beyond basic type checking. Severity: Medium. CWE: CWE-20.
- [ ] SC-API-151: Implement deadline propagation — Set and propagate deadlines to prevent hung or long-running RPCs. Severity: Medium. CWE: CWE-400.
- [ ] SC-API-152: Secure gRPC reflection services — Disable server reflection in production or restrict it to authorized clients. Severity: Medium. CWE: CWE-200.
- [ ] SC-API-153: Implement gRPC health checking securely — Ensure health check endpoints do not expose internal service details. Severity: Low. CWE: CWE-200.
- [ ] SC-API-154: Validate metadata headers in gRPC — Sanitize and validate custom metadata attached to gRPC calls. Severity: Medium. CWE: CWE-20.
- [ ] SC-API-155: Prevent gRPC stream abuse — Limit the number of messages and duration of streaming RPCs. Severity: Medium. CWE: CWE-400.
- [ ] SC-API-156: Implement mutual TLS for service-to-service gRPC — Use mTLS to authenticate both client and server in internal gRPC communications. Severity: High. CWE: CWE-295.
- [ ] SC-API-157: Secure gRPC-Web proxy configurations — Validate CORS and authentication settings on gRPC-Web proxy endpoints. Severity: Medium. CWE: CWE-942.
- [ ] SC-API-158: Handle gRPC error codes securely — Return appropriate gRPC status codes without leaking internal details. Severity: Medium. CWE: CWE-209.
- [ ] SC-API-159: Validate oneof and repeated fields — Enforce constraints on oneof selections and repeated field cardinality. Severity: Medium. CWE: CWE-20.
- [ ] SC-API-160: Implement channel-level rate limiting for gRPC — Apply rate limits at the gRPC channel or service level to prevent abuse. Severity: High. CWE: CWE-770.

### 9. JWT & Token Security (20 items)

- [ ] SC-API-161: Validate JWT signature algorithm — Explicitly specify and enforce the expected signing algorithm; reject none and unexpected algorithms. Severity: Critical. CWE: CWE-347.
- [ ] SC-API-162: Use strong JWT signing keys — Use RSA 2048+ or ECDSA P-256+ keys for asymmetric signing; 256+ bit keys for HMAC. Severity: Critical. CWE: CWE-326.
- [ ] SC-API-163: Validate JWT expiration claims — Always verify the exp claim and reject expired tokens. Severity: High. CWE: CWE-613.
- [ ] SC-API-164: Validate JWT issuer claim — Verify the iss claim against expected issuer values. Severity: High. CWE: CWE-345.
- [ ] SC-API-165: Validate JWT audience claim — Verify the aud claim matches the intended API audience. Severity: High. CWE: CWE-345.
- [ ] SC-API-166: Implement JWT token revocation — Maintain a token blacklist or use short-lived tokens with refresh token rotation. Severity: High. CWE: CWE-613.
- [ ] SC-API-167: Prevent JWT confusion attacks — Use distinct keys and algorithms for different token types (access vs. refresh). Severity: High. CWE: CWE-347.
- [ ] SC-API-168: Set short expiration for access tokens — Use access tokens with expiration of 15 minutes or less. Severity: Medium. CWE: CWE-613.
- [ ] SC-API-169: Implement secure refresh token rotation — Issue new refresh tokens on each use and invalidate the old one. Severity: High. CWE: CWE-384.
- [ ] SC-API-170: Store JWTs securely on clients — Use HttpOnly, Secure, SameSite cookies or secure storage rather than localStorage. Severity: High. CWE: CWE-922.
- [ ] SC-API-171: Include JTI claim for token tracking — Use unique JWT ID claims to enable revocation and prevent replay attacks. Severity: Medium. CWE: CWE-294.
- [ ] SC-API-172: Prevent JWT key confusion between RSA and HMAC — Ensure public keys cannot be used as HMAC secrets due to algorithm confusion. Severity: Critical. CWE: CWE-327.
- [ ] SC-API-173: Validate JWT not-before claim — Check the nbf claim to prevent premature token use. Severity: Low. CWE: CWE-345.
- [ ] SC-API-174: Limit JWT payload size — Keep JWT claims minimal to reduce parsing overhead and exposure risk. Severity: Low. CWE: CWE-400.
- [ ] SC-API-175: Encrypt sensitive JWT claims — Use JWE (JSON Web Encryption) for tokens containing sensitive data. Severity: Medium. CWE: CWE-311.
- [ ] SC-API-176: Implement token binding — Bind tokens to specific client characteristics to prevent theft and replay. Severity: Medium. CWE: CWE-294.
- [ ] SC-API-177: Rotate signing keys periodically — Implement key rotation with proper JWK Set (JWKS) endpoint support. Severity: Medium. CWE: CWE-320.
- [ ] SC-API-178: Validate JWT header parameters — Reject tokens with unexpected header parameters like jku or x5u that could redirect key resolution. Severity: High. CWE: CWE-347.
- [ ] SC-API-179: Prevent cross-service token reuse — Use audience-specific tokens that cannot be replayed against other services. Severity: High. CWE: CWE-294.
- [ ] SC-API-180: Implement token introspection for opaque tokens — Use RFC 7662 token introspection for server-side validation of opaque tokens. Severity: Medium. CWE: CWE-345.

### 10. CORS & Security Headers (15 items)

- [ ] SC-API-181: Configure CORS with explicit origins — Never use wildcard (*) for Access-Control-Allow-Origin with credentialed requests. Severity: High. CWE: CWE-942.
- [ ] SC-API-182: Restrict CORS allowed methods — Only permit the HTTP methods required by legitimate clients. Severity: Medium. CWE: CWE-942.
- [ ] SC-API-183: Restrict CORS allowed headers — Whitelist only the custom headers required by the API. Severity: Medium. CWE: CWE-942.
- [ ] SC-API-184: Set proper CORS max-age — Configure Access-Control-Max-Age to cache preflight responses appropriately. Severity: Low. CWE: CWE-942.
- [ ] SC-API-185: Implement Content-Security-Policy header — Set a strict CSP to prevent XSS and data injection for APIs serving HTML content. Severity: High. CWE: CWE-79.
- [ ] SC-API-186: Set X-Content-Type-Options: nosniff — Prevent browsers from MIME-type sniffing responses. Severity: Medium. CWE: CWE-16.
- [ ] SC-API-187: Implement Strict-Transport-Security header — Set HSTS with a long max-age and includeSubDomains directive. Severity: High. CWE: CWE-319.
- [ ] SC-API-188: Set X-Frame-Options header — Prevent clickjacking by setting DENY or SAMEORIGIN for responses that may render in browsers. Severity: Medium. CWE: CWE-1021.
- [ ] SC-API-189: Implement Referrer-Policy header — Set strict-origin-when-cross-origin or no-referrer to limit referrer information leakage. Severity: Low. CWE: CWE-200.
- [ ] SC-API-190: Set Permissions-Policy header — Restrict browser features like geolocation, camera, and microphone access. Severity: Low. CWE: CWE-16.
- [ ] SC-API-191: Validate Origin header for WebSocket connections — Check the Origin header against a whitelist before accepting WebSocket upgrades. Severity: High. CWE: CWE-346.
- [ ] SC-API-192: Do not reflect Origin in CORS responses — Validate Origin against a whitelist rather than echoing it back. Severity: High. CWE: CWE-942.
- [ ] SC-API-193: Restrict Access-Control-Expose-Headers — Only expose headers that clients legitimately need to read. Severity: Low. CWE: CWE-200.
- [ ] SC-API-194: Implement Cross-Origin-Resource-Policy — Set CORP header to same-origin or same-site to prevent cross-origin resource loading. Severity: Medium. CWE: CWE-346.
- [ ] SC-API-195: Implement Cross-Origin-Opener-Policy — Set COOP to same-origin to isolate browsing context. Severity: Medium. CWE: CWE-346.

### 11. Versioning & Deprecation (10 items)

- [ ] SC-API-196: Enforce API versioning — Require explicit version identifiers in all API requests. Severity: Medium. CWE: CWE-693.
- [ ] SC-API-197: Deprecate old API versions securely — Return deprecation warnings and sunset headers for outdated versions. Severity: Low. CWE: CWE-693.
- [ ] SC-API-198: Maintain security patches for supported versions — Apply security fixes to all currently supported API versions. Severity: High. CWE: CWE-1104.
- [ ] SC-API-199: Block requests to unsupported versions — Return clear errors for API versions that are no longer supported. Severity: Medium. CWE: CWE-693.
- [ ] SC-API-200: Prevent version downgrade attacks — Ensure clients cannot force the server to use an older, less secure API version. Severity: High. CWE: CWE-757.
- [ ] SC-API-201: Document security changes per version — Publish security-relevant changes in release notes for each API version. Severity: Low. CWE: CWE-1059.
- [ ] SC-API-202: Test security across all supported versions — Include all supported versions in security scanning and penetration testing. Severity: Medium. CWE: CWE-693.
- [ ] SC-API-203: Apply consistent authentication across versions — Ensure all API versions enforce the same authentication requirements. Severity: High. CWE: CWE-306.
- [ ] SC-API-204: Validate version parameter format — Reject malformed or unexpected version identifiers to prevent injection. Severity: Medium. CWE: CWE-20.
- [ ] SC-API-205: Avoid exposing internal version details — Do not reveal backend framework or library versions in API responses. Severity: Low. CWE: CWE-200.

### 12. Error Handling (10 items)

- [ ] SC-API-206: Implement global error handlers — Use centralized error handling to ensure consistent secure error responses. Severity: High. CWE: CWE-755.
- [ ] SC-API-207: Return generic error messages to clients — Provide user-friendly messages without internal implementation details. Severity: Medium. CWE: CWE-209.
- [ ] SC-API-208: Log detailed errors server-side only — Store full error details in server logs, never in client responses. Severity: Medium. CWE: CWE-209.
- [ ] SC-API-209: Handle unexpected exceptions gracefully — Catch all unhandled exceptions and return a safe 500 response. Severity: High. CWE: CWE-755.
- [ ] SC-API-210: Prevent error-based information disclosure — Ensure database errors, file paths, and system info are never in responses. Severity: High. CWE: CWE-209.
- [ ] SC-API-211: Implement consistent error response format — Use a standardized error schema (e.g., RFC 7807) across all endpoints. Severity: Low. CWE: CWE-755.
- [ ] SC-API-212: Handle serialization errors securely — Catch and sanitize errors from JSON/XML parsing before responding. Severity: Medium. CWE: CWE-209.
- [ ] SC-API-213: Prevent error message injection — Sanitize user input that might be included in error messages. Severity: Medium. CWE: CWE-79.
- [ ] SC-API-214: Handle resource exhaustion errors — Return 503 Service Unavailable with Retry-After when resources are exhausted. Severity: Medium. CWE: CWE-400.
- [ ] SC-API-215: Validate error handling in all code paths — Ensure both success and failure paths are tested for secure error handling. Severity: Medium. CWE: CWE-755.

### 13. Logging & Monitoring (10 items)

- [ ] SC-API-216: Log all authentication events — Record successful and failed login attempts with timestamps and source IPs. Severity: High. CWE: CWE-778.
- [ ] SC-API-217: Log all authorization failures — Record attempts to access unauthorized resources with full request context. Severity: High. CWE: CWE-778.
- [ ] SC-API-218: Implement tamper-proof logging — Write logs to append-only storage or use centralized logging with integrity verification. Severity: Medium. CWE: CWE-117.
- [ ] SC-API-219: Monitor for anomalous API usage patterns — Set up alerts for unusual request volumes, error rates, or access patterns. Severity: Medium. CWE: CWE-778.
- [ ] SC-API-220: Log API changes and deployments — Record all configuration changes and deployments with who, what, and when. Severity: Medium. CWE: CWE-778.
- [ ] SC-API-221: Implement request correlation IDs — Generate unique IDs for each request to enable distributed tracing across services. Severity: Low. CWE: CWE-778.
- [ ] SC-API-222: Prevent log injection attacks — Sanitize log entries to prevent attackers from injecting false log entries. Severity: Medium. CWE: CWE-117.
- [ ] SC-API-223: Set up real-time security alerting — Configure immediate alerts for critical security events like credential leaks or mass failures. Severity: High. CWE: CWE-778.
- [ ] SC-API-224: Retain logs for compliance periods — Keep security logs for the duration required by regulatory and compliance standards. Severity: Medium. CWE: CWE-778.
- [ ] SC-API-225: Monitor third-party API dependencies — Track the availability and security posture of external API dependencies. Severity: Low. CWE: CWE-1104.

---

**Total: 225 items across 13 categories.**
