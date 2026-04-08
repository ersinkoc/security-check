---
name: sc-header-injection
description: HTTP Header Injection and Response Splitting detection via CRLF injection in headers
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: HTTP Header Injection / Response Splitting

## Purpose

Detects HTTP header injection vulnerabilities where user-controlled input is placed into HTTP response headers without CRLF character sanitization, enabling response splitting, cookie injection, cache poisoning, and XSS via injected headers. Also covers Host header injection used in password reset poisoning.

## Activation

Called by sc-orchestrator during Phase 2 when HTTP response handling is detected.

## Phase 1: Discovery

### File Patterns to Search
```
**/*.py, **/*.js, **/*.ts, **/*.go, **/*.php, **/*.java, **/*.cs,
**/controllers/*, **/routes/*, **/handlers/*, **/middleware/*,
**/*redirect*, **/*header*, **/*cookie*, **/*response*
```

### Keyword Patterns to Search
```
# Setting response headers with potential user input
"res.setHeader(", "res.header(", "response.addHeader(",
"response.setHeader(", "w.Header().Set(", "header(",
"Response.Headers.Add(", "Response.Cookies.Append(",
"Set-Cookie", "Location:", "Content-Disposition",

# Redirect with user input
"res.redirect(", "response.sendRedirect(", "redirect(",
"HttpResponse(.*status=302", "http.Redirect(",
"Response.Redirect("

# Host header usage
"request.getHeader(\"Host\")", "req.headers.host", "req.Host",
"$_SERVER['HTTP_HOST']", "request.META['HTTP_HOST']"
```

### Vulnerability Pattern: CRLF in Headers
```javascript
// VULNERABLE: User input in Set-Cookie header
app.get('/lang', (req, res) => {
  res.setHeader('Set-Cookie', `lang=${req.query.lang}`);
  // Attack: ?lang=en%0d%0aSet-Cookie:%20admin=true
  // Injects additional header
});

// SAFE: Validate/encode header values
app.get('/lang', (req, res) => {
  const lang = req.query.lang.replace(/[\r\n]/g, '');
  res.setHeader('Set-Cookie', `lang=${encodeURIComponent(lang)}`);
});
```

### Host Header Injection
```python
# VULNERABLE: Using Host header for password reset URL
def password_reset(request):
    host = request.META['HTTP_HOST']  # Attacker-controlled!
    reset_url = f"https://{host}/reset?token={token}"
    send_email(user.email, f"Reset here: {reset_url}")

# SAFE: Use configured server name
def password_reset(request):
    reset_url = f"https://{settings.ALLOWED_HOSTS[0]}/reset?token={token}"
```

### Content-Disposition Injection
```go
// VULNERABLE: User filename in Content-Disposition
func download(w http.ResponseWriter, r *http.Request) {
    filename := r.URL.Query().Get("file")
    w.Header().Set("Content-Disposition", fmt.Sprintf("attachment; filename=%s", filename))
    // Attack: ?file=test%0d%0aContent-Type:%20text/html%0d%0a%0d%0a<script>alert(1)</script>
}

// SAFE: Sanitize filename
filename = strings.Map(func(r rune) rune {
    if r == '\r' || r == '\n' || r == '"' { return -1 }
    return r
}, filename)
w.Header().Set("Content-Disposition", fmt.Sprintf(`attachment; filename="%s"`, filename))
```

## Phase 2: Verification

### Modern Framework Protections
Most modern HTTP libraries and frameworks reject CRLF characters in header values:
- **Node.js (v14+):** `http.ServerResponse` throws on CRLF in header values
- **Go net/http:** Rejects headers containing `\r` or `\n`
- **Python/Django:** WSGI servers typically strip CRLF
- **Java Servlet (Tomcat 7+):** Rejects CRLF in response headers
- **ASP.NET Core:** Rejects CRLF in header values

**However:** Some configurations, proxies, or older versions may not enforce this.

### Sanitization Check
1. Are `\r` and `\n` stripped from user input before header insertion?
2. Is the value URL-encoded or otherwise escaped?
3. Does the HTTP framework/server reject CRLF in headers?

## Severity Classification

- **Critical:** Response splitting enabling XSS or cache poisoning on shared caches
- **High:** Host header injection in password reset leading to token theft
- **Medium:** Cookie injection via CRLF, or header injection in less-sensitive headers
- **Low:** Header injection in modern framework that auto-rejects CRLF (informational)

## Output Format

### Finding: HDR-{NNN}
- **Title:** {CRLF Header Injection | Host Header Injection | Response Splitting} in {endpoint}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-113 (HTTP Response Splitting)
- **Description:** User input from {source} is placed into HTTP {header name} without CRLF sanitization.
- **Proof of Concept:** Injecting `%0d%0a` sequences could add arbitrary headers to the response.
- **Impact:** {Cache poisoning / XSS / session fixation / password reset poisoning}
- **Remediation:** Strip CR/LF characters from user input. Use framework-provided safe header methods. For Host header: use server configuration instead of request Host header.
- **References:** https://cwe.mitre.org/data/definitions/113.html

## Common False Positives

1. **Modern frameworks** — Node.js 14+, Go, ASP.NET Core, Tomcat 7+ reject CRLF automatically
2. **Static header values** — headers set from constants or configuration, not user input
3. **Content-Type headers** — typically set by framework based on response type, not user input
4. **Framework redirect methods** — `res.redirect()` in Express URL-encodes the location
5. **Reverse proxy normalization** — nginx/Apache strip malformed headers before they reach the app
