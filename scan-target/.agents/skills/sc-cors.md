---
name: sc-cors
description: CORS misconfiguration detection — wildcard origin, reflected origin, null origin, and credential leaks
---

# SC: CORS Misconfiguration

## Purpose

Detects Cross-Origin Resource Sharing misconfigurations that allow unauthorized cross-origin access to sensitive APIs. Covers wildcard origins with credentials, reflected origin without validation, null origin allowance, overly permissive regex matching, and subdomain matching bypasses.

## Activation

Called by sc-orchestrator during Phase 2 when HTTP APIs are detected.

## Phase 1: Discovery

### Keyword Patterns to Search
```
"Access-Control-Allow-Origin", "cors(", "CORS(",
"allowOrigin", "allow_origin", "AllowOrigin",
"Access-Control-Allow-Credentials",
"corsOptions", "cors_allowed_origins"
```

### Vulnerability Patterns

**1. Wildcard with Credentials:**
```javascript
// VULNERABLE: Wildcard + credentials (browsers block this but misconfiguration indicates intent)
app.use(cors({
  origin: '*',
  credentials: true  // This combination is a security anti-pattern
}));
```

**2. Reflected Origin:**
```javascript
// VULNERABLE: Reflects any origin
app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', req.headers.origin);
  res.setHeader('Access-Control-Allow-Credentials', 'true');
  next();
});

// SAFE: Allowlist
const ALLOWED_ORIGINS = ['https://app.example.com', 'https://admin.example.com'];
app.use(cors({
  origin: (origin, callback) => {
    if (!origin || ALLOWED_ORIGINS.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('CORS not allowed'));
    }
  },
  credentials: true
}));
```

**3. Null Origin Allowed:**
```python
# VULNERABLE: Allows null origin (exploitable via sandboxed iframe)
CORS_ALLOWED_ORIGINS = ['null']  # Attackers can send Origin: null
```

**4. Regex Bypass:**
```javascript
// VULNERABLE: Weak regex allows subdomain takeover attack
origin: /\.example\.com$/  // Matches evil-example.com too!

// SAFE: Anchor regex properly
origin: /^https:\/\/([a-z]+\.)?example\.com$/
```

## Severity Classification

- **Critical:** Reflected origin + credentials on endpoints with sensitive data
- **High:** Null origin allowed + credentials, regex bypass allowing attacker domains
- **Medium:** Wildcard origin on non-credential endpoints with sensitive data
- **Low:** Overly permissive CORS on public data endpoints

## Output Format

### Finding: CORS-{NNN}
- **Title:** CORS Misconfiguration — {type}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-942 (Permissive Cross-domain Policy)
- **Description:** {CORS configuration allows unauthorized cross-origin access.}
- **Impact:** Cross-origin data theft, account takeover via CSRF-like attacks.
- **Remediation:** Implement strict origin allowlist. Never reflect origin without validation.
- **References:** https://cwe.mitre.org/data/definitions/942.html

## Common False Positives

1. **Public APIs** — APIs serving public data may intentionally use `*`
2. **CDN/static assets** — CORS `*` on static files is standard practice
3. **Development configuration** — `localhost` origins in dev config
4. **API gateways** — CORS may be configured at the gateway level, not application level
