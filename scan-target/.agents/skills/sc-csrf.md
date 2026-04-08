---
name: sc-csrf
description: Cross-Site Request Forgery detection — missing tokens, SameSite misconfiguration, and CORS-CSRF interaction
---

# SC: Cross-Site Request Forgery (CSRF)

## Purpose

Detects CSRF vulnerabilities where state-changing operations (POST, PUT, DELETE) lack CSRF protection, enabling attackers to trick authenticated users into performing unintended actions. Covers missing CSRF tokens, SameSite cookie misconfiguration, token validation flaws, and JSON content-type bypass scenarios.

## Activation

Called by sc-orchestrator during Phase 2 when web applications with session-based auth are detected.

## Phase 1: Discovery

### Keyword Patterns to Search
```
"csrf", "CSRF", "csrftoken", "csrf_token", "_token",
"SameSite", "samesite", "X-CSRF-Token", "X-XSRF-TOKEN",
"@csrf", "csrf_exempt", "CsrfViewMiddleware",
"antiforgery", "ValidateAntiForgeryToken", "csurf"
```

### Vulnerability Patterns

**1. Missing CSRF Protection:**
```python
# VULNERABLE: State-changing endpoint without CSRF
@csrf_exempt  # Explicitly disabled!
def transfer_funds(request):
    amount = request.POST['amount']
    to_account = request.POST['to']
    # Transfer without CSRF verification
```

**2. SameSite Cookie Not Set:**
```javascript
// VULNERABLE: No SameSite attribute
app.use(session({
  cookie: { httpOnly: true, secure: true }
  // Missing: sameSite: 'strict' or 'lax'
}));
```

**3. JSON API Without Content-Type Validation:**
```javascript
// VULNERABLE: Accepts both form-encoded and JSON
app.post('/api/transfer', (req, res) => {
  // Attacker can submit via HTML form with content-type application/x-www-form-urlencoded
});

// SAFE: Require application/json content-type
app.post('/api/transfer', (req, res) => {
  if (req.headers['content-type'] !== 'application/json') {
    return res.status(415).send('Unsupported Media Type');
  }
});
```

### Framework CSRF Defaults
- **Django:** CSRF middleware enabled by default. Check for `@csrf_exempt`.
- **Laravel:** VerifyCsrfToken middleware. Check `$except` array.
- **Spring Security:** CSRF enabled by default. Check `.csrf().disable()`.
- **Express:** No built-in CSRF. Check for `csurf` or `csrf-csrf` middleware.
- **ASP.NET:** Check for `[ValidateAntiForgeryToken]` on POST actions.

## Severity Classification

- **Critical:** Missing CSRF on financial operations, password change, email change
- **High:** Missing CSRF on account settings, admin actions
- **Medium:** Missing CSRF on non-critical state changes, SameSite=None
- **Low:** Missing CSRF on preference changes, CSRF concerns mitigated by SameSite=Lax

## Output Format

### Finding: CSRF-{NNN}
- **Title:** Missing CSRF Protection on {endpoint}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-352 (Cross-Site Request Forgery)
- **Description:** {State-changing endpoint} lacks CSRF token validation.
- **Impact:** Unauthorized actions on behalf of authenticated users.
- **Remediation:** Enable CSRF tokens, set SameSite=Strict/Lax, validate Content-Type.
- **References:** https://cwe.mitre.org/data/definitions/352.html

## Common False Positives

1. **API-only with Bearer tokens** — APIs using Authorization header (not cookies) are CSRF-immune
2. **SameSite=Lax by default** — modern browsers default to Lax, mitigating most CSRF
3. **GraphQL mutations** — typically require application/json content-type (pre-flight check)
4. **CORS properly configured** — strict CORS blocks cross-origin form submissions with credentials
