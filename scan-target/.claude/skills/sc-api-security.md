---
name: sc-api-security
description: REST, GraphQL, and gRPC API security audit — authentication, authorization, data exposure, and configuration
---

# SC: API Security Audit

## Purpose

Performs a comprehensive security audit of API endpoints covering broken object-level authorization, broken function-level authorization, excessive data exposure, missing rate limiting, mass assignment, security misconfiguration, and injection via API parameters. Covers REST, GraphQL, and gRPC API patterns, aligned with the OWASP API Security Top 10.

## Activation

Called by sc-orchestrator during Phase 2 when APIs are detected in the architecture.

## Phase 1: Discovery

### Keyword Patterns to Search
```
# REST
"app.get(", "app.post(", "app.put(", "app.delete(", "app.patch(",
"router.get(", "@GetMapping", "@PostMapping", "@app.route(",
"[HttpGet]", "[HttpPost]", "r.GET(", "r.POST("

# GraphQL
"typeDefs", "resolvers", "Mutation", "Query", "Subscription"

# gRPC
".proto", "service ", "rpc ", "grpc.Server"

# API configuration
"swagger", "openapi", "api-docs", "Swashbuckle"
```

### OWASP API Security Top 10 Checks

**1. Broken Object Level Authorization (BOLA/IDOR):**
- API endpoints accepting resource IDs without ownership verification
- See sc-authz for detailed IDOR patterns

**2. Broken Authentication:**
- Missing auth on sensitive endpoints
- Weak token generation
- See sc-auth for details

**3. Broken Object Property Level Authorization:**
```javascript
// VULNERABLE: Returning all user fields including sensitive ones
app.get('/api/users/:id', async (req, res) => {
  const user = await User.findById(req.params.id);
  res.json(user);  // Includes passwordHash, internalId, role, etc.
});

// SAFE: Return only needed fields
app.get('/api/users/:id', async (req, res) => {
  const user = await User.findById(req.params.id).select('name email avatar');
  res.json(user);
});
```

**4. Unrestricted Resource Consumption:**
- Missing pagination limits (`?limit=999999`)
- No request size limits
- No rate limiting
- See sc-rate-limiting for details

**5. Broken Function Level Authorization:**
- Admin API endpoints without role checking middleware
- See sc-privilege-escalation for details

**6. Server-Side Request Forgery:**
- API endpoints making outbound requests based on user input
- See sc-ssrf for details

**7. Security Misconfiguration:**
```javascript
// Check for exposed API documentation in production
// /swagger, /api-docs, /graphql (introspection), /openapi.json
// Check for verbose error messages in API responses
// Check for missing security headers
```

**8. Lack of Protection from Automated Threats:**
- Missing CAPTCHA on registration/login APIs
- No bot detection
- Missing rate limiting

### REST-Specific Checks
- HTTP verb tampering (GET vs POST interchangeably)
- HTTP parameter pollution
- Content-type validation (accepting both form and JSON)
- Pagination without upper bound

### GraphQL-Specific Checks
- Introspection enabled in production
- No query depth/complexity limits
- Batching without limits
- See sc-graphql for details

### gRPC-Specific Checks
- Missing TLS on gRPC channels
- Missing authentication metadata
- Unvalidated protobuf fields
- Missing input validation on message fields

## Severity Classification

- **Critical:** Unauthenticated API endpoints exposing sensitive data or actions
- **High:** BOLA/IDOR, excessive data exposure, missing function-level auth
- **Medium:** Exposed API docs, missing rate limits, security misconfiguration
- **Low:** Missing pagination limits, verbose errors, minor header issues

## Output Format

### Finding: API-{NNN}
- **Title:** {API security issue}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-284 (Improper Access Control)
- **Description:** {What was found}
- **Impact:** Unauthorized data access, service abuse, data breach.
- **Remediation:** {Specific fix}
- **References:** https://owasp.org/API-Security/

## Common False Positives

1. **Public APIs** — intentionally open endpoints (health checks, public product listings)
2. **Gateway-level auth** — authentication enforced at API gateway, not application code
3. **Internal microservice APIs** — service-to-service communication with network-level security
