---
name: sc-clickjacking
description: Clickjacking and UI redressing detection — missing frame protection headers and CSP frame-ancestors
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Clickjacking / UI Redressing

## Purpose

Detects clickjacking vulnerabilities where applications can be embedded in iframes on malicious sites, tricking users into clicking hidden elements. Checks for missing X-Frame-Options header, missing Content-Security-Policy frame-ancestors directive, and framebusting bypass vulnerabilities.

## Activation

Called by sc-orchestrator during Phase 2 when web applications serving HTML are detected.

## Phase 1: Discovery

### Keyword Patterns to Search
```
"X-Frame-Options", "frame-ancestors", "DENY", "SAMEORIGIN",
"helmet", "frameguard", "X_FRAME_OPTIONS",
"SECURE_BROWSER_XSS_FILTER", "clickjack"
```

### Checks
1. Is `X-Frame-Options` header set? (DENY or SAMEORIGIN)
2. Is `Content-Security-Policy: frame-ancestors` set?
3. Are both missing? (Clickjacking possible)
4. Is there JavaScript-based framebusting that can be bypassed?

### Configuration Examples
```javascript
// VULNERABLE: No frame protection headers
app.get('/', (req, res) => {
  res.send('<html>...');  // Can be iframed by any site
});

// SAFE: Using helmet
const helmet = require('helmet');
app.use(helmet.frameguard({ action: 'deny' }));
// Or CSP
app.use(helmet.contentSecurityPolicy({
  directives: { frameAncestors: ["'self'"] }
}));
```

```python
# Django settings.py
X_FRAME_OPTIONS = 'DENY'  # SAFE
# If missing → VULNERABLE
```

```go
// SAFE: Set header in middleware
func securityHeaders(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("X-Frame-Options", "DENY")
        w.Header().Set("Content-Security-Policy", "frame-ancestors 'none'")
        next.ServeHTTP(w, r)
    })
}
```

## Severity Classification

- **Critical:** Missing frame protection on pages with sensitive actions (transfers, settings)
- **High:** Missing frame protection on authenticated pages
- **Medium:** Missing frame protection on public pages with forms
- **Low:** Missing CSP frame-ancestors when X-Frame-Options is set (defense in depth)

## Output Format

### Finding: CLICK-{NNN}
- **Title:** Missing Clickjacking Protection
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-1021 (Improper Restriction of Rendered UI Layers)
- **Description:** Application does not set X-Frame-Options or CSP frame-ancestors headers.
- **Impact:** Users tricked into clicking hidden buttons/links on attacker-controlled pages.
- **Remediation:** Set `X-Frame-Options: DENY` and `Content-Security-Policy: frame-ancestors 'none'`.
- **References:** https://cwe.mitre.org/data/definitions/1021.html

## Common False Positives

1. **Embeddable widgets** — applications designed to be embedded (maps, payment forms)
2. **API-only responses** — JSON APIs don't render UI elements
3. **Proxy-level headers** — frame protection set at nginx/Apache level, not in app code
