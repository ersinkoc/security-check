---
name: sc-session
description: Session management flaw detection — fixation, hijacking, cookie misconfiguration, and lifecycle issues
---

# SC: Session Management Flaws

## Purpose

Detects session management vulnerabilities including session fixation, predictable session tokens, insecure cookie attributes, missing session regeneration on privilege change, excessive session timeouts, and improper session invalidation. Covers cookie-based sessions, server-side sessions, and token-based session patterns.

## Activation

Called by sc-orchestrator during Phase 2 when session management is detected.

## Phase 1: Discovery

### Keyword Patterns to Search
```
"session", "cookie", "Set-Cookie", "httpOnly", "secure", "SameSite",
"session_start", "session_regenerate_id", "req.session",
"SESSION_COOKIE", "CSRF_COOKIE", "express-session", "cookie-session",
"maxAge", "expires", "session.save(", "session.destroy(",
"SessionCreationPolicy"
```

### Vulnerability Patterns

**1. Missing Cookie Security Attributes:**
```javascript
// VULNERABLE: Session cookie without security flags
app.use(session({
  secret: 'keyboard cat',
  cookie: { }  // No httpOnly, secure, or sameSite
}));

// SAFE: All security attributes set
app.use(session({
  secret: process.env.SESSION_SECRET,
  cookie: {
    httpOnly: true,
    secure: true,
    sameSite: 'strict',
    maxAge: 3600000  // 1 hour
  },
  resave: false,
  saveUninitialized: false
}));
```

**2. Missing Session Regeneration After Login:**
```python
# VULNERABLE: Same session ID before and after authentication
def login(request):
    user = authenticate(request.POST['username'], request.POST['password'])
    if user:
        request.session['user_id'] = user.id  # Session fixation!
        return redirect('/dashboard')

# SAFE: Regenerate session after login
def login(request):
    user = authenticate(request.POST['username'], request.POST['password'])
    if user:
        request.session.flush()  # Destroy old session
        request.session.cycle_key()  # New session ID
        request.session['user_id'] = user.id
        return redirect('/dashboard')
```

**3. Session Not Invalidated on Logout:**
```java
// VULNERABLE: Session data cleared but session ID persists
@PostMapping("/logout")
public void logout(HttpSession session) {
    session.removeAttribute("user");
}

// SAFE: Invalidate entire session
@PostMapping("/logout")
public void logout(HttpSession session) {
    session.invalidate();
}
```

**4. Session Token in URL:**
```php
// VULNERABLE: Session ID in URL parameter
session_start();
echo '<a href="page.php?PHPSESSID=' . session_id() . '">Link</a>';

// SAFE: Use cookie-only sessions
ini_set('session.use_only_cookies', 1);
ini_set('session.use_trans_sid', 0);
```

## Phase 2: Verification

### Cookie Attribute Checklist
- `HttpOnly`: Prevents JavaScript access (XSS protection)
- `Secure`: Only sent over HTTPS
- `SameSite`: Prevents CSRF (Strict or Lax)
- `Path`: Scoped to application path
- `Max-Age/Expires`: Reasonable session duration

### Framework-Specific Checks
- **Django:** `SESSION_COOKIE_HTTPONLY`, `SESSION_COOKIE_SECURE`, `SESSION_COOKIE_SAMESITE`, `SESSION_COOKIE_AGE`
- **Express:** `cookie.httpOnly`, `cookie.secure`, `cookie.sameSite`, `cookie.maxAge`
- **Laravel:** `session.http_only`, `session.secure`, `session.same_site`, `session.lifetime`
- **Spring:** `server.servlet.session.cookie.http-only`, `server.servlet.session.cookie.secure`
- **ASP.NET:** `CookieHttpOnly`, `CookieSecure`, `CookieSameSite`

## Severity Classification

- **Critical:** Predictable session tokens, session fixation in authentication flow
- **High:** Missing httpOnly flag (enables XSS-based session theft), no session regeneration on login
- **Medium:** Missing Secure flag, excessive session timeout (>24h), no invalidation on logout
- **Low:** Missing SameSite attribute, concurrent session not limited

## Output Format

### Finding: SESS-{NNN}
- **Title:** {Session vulnerability type}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-384 (Session Fixation) | CWE-614 (Sensitive Cookie Without Secure) | CWE-613 (Insufficient Session Expiration)
- **Description:** {What was found}
- **Impact:** Session hijacking, account takeover, CSRF.
- **Remediation:** {Specific fix with configuration example}
- **References:** https://cwe.mitre.org/data/definitions/384.html

## Common False Positives

1. **Development configuration** — `secure: false` in dev config with env-specific override for production
2. **API-only applications** — APIs using JWT/Bearer tokens may not need cookie security attributes
3. **Static sites** — sessions used for non-sensitive data (preferences, language)
4. **Proxy-terminated HTTPS** — `secure` flag may be set at the reverse proxy level
