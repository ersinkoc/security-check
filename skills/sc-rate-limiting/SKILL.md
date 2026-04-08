---
name: sc-rate-limiting
description: Missing rate limiting and application-level DoS vector detection — ReDoS, query complexity, resource exhaustion
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Rate Limiting & DoS Vectors

## Purpose

Detects missing rate limiting on sensitive endpoints and application-level denial-of-service vectors including ReDoS patterns, GraphQL complexity attacks, large payload attacks, pagination abuse, connection pool exhaustion, and resource-intensive operations without throttling.

## Activation

Called by sc-orchestrator during Phase 2. Runs against all web applications and APIs.

## Phase 1: Discovery

### Keyword Patterns to Search
```
"rateLimit", "rate_limit", "throttle", "RateLimiter",
"express-rate-limit", "slowapi", "throttle_classes",
"@Throttle", "bucket", "leaky", "sliding_window"
```

### Checks

**1. Missing Rate Limiting on Sensitive Endpoints:**
- Login/authentication endpoints
- Password reset
- Registration/signup
- OTP/verification code sending
- Email sending endpoints
- API key generation
- File upload
- Search/query endpoints

**2. ReDoS (Regular Expression Denial of Service):**
```javascript
// VULNERABLE: Catastrophic backtracking
const emailRegex = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
// Input: "aaaaaaaaaaaaaaaaaaaaaaaa!" causes exponential backtracking

// SAFE: Non-backtracking regex or use validator library
const { isEmail } = require('validator');
```

**3. Pagination Abuse:**
```javascript
// VULNERABLE: No upper bound on limit
app.get('/api/users', (req, res) => {
  const limit = parseInt(req.query.limit) || 10;
  // limit=999999 returns entire database!
});

// SAFE: Cap the limit
const limit = Math.min(parseInt(req.query.limit) || 10, 100);
```

**4. Request Size Limits:**
```javascript
// VULNERABLE: No body size limit
app.use(express.json());  // Default: 100kb, but should be explicitly set

// SAFE: Explicit limit
app.use(express.json({ limit: '1mb' }));
```

## Severity Classification

- **Critical:** ReDoS causing server hang, missing rate limit on auth allowing brute force
- **High:** Missing rate limits on financial operations, unbounded queries
- **Medium:** Missing rate limits on non-critical endpoints, large payload acceptance
- **Low:** Minor DoS vectors requiring sustained attack, informational

## Output Format

### Finding: RATE-{NNN}
- **Title:** {Missing Rate Limiting | ReDoS | Resource Exhaustion} in {location}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-770 (Allocation Without Limits) | CWE-799 (Improper Control of Interaction Frequency) | CWE-1333 (ReDoS)
- **Description:** {What was found}
- **Impact:** Service unavailability, brute force attacks, resource exhaustion.
- **Remediation:** Add rate limiting middleware, fix regex patterns, set request size limits.
- **References:** https://cwe.mitre.org/data/definitions/770.html

## Common False Positives

1. **Rate limiting at infrastructure level** — API gateway, CDN, or WAF rate limiting
2. **Internal/admin endpoints** — internal tools with network-level access control
3. **Safe regex patterns** — regex without nested quantifiers or alternation
