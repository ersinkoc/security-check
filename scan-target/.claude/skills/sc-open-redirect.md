---
name: sc-open-redirect
description: Open redirect detection — unvalidated redirect URLs, protocol-relative bypasses, and URI scheme abuse
---

# SC: Open Redirect

## Purpose

Detects open redirect vulnerabilities where user-controlled input determines the destination of HTTP redirects, enabling phishing attacks, OAuth token theft, and SSRF chaining. Covers URL parameter redirects, protocol-relative URL bypasses, backslash tricks, and JavaScript/data URI schemes.

## Activation

Called by sc-orchestrator during Phase 2 when redirect functionality is detected.

## Phase 1: Discovery

### Keyword Patterns to Search
```
"redirect(", "res.redirect(", "response.sendRedirect(",
"http.Redirect(", "redirect_to(", "RedirectToAction(",
"Location:", "window.location", "document.location",
"return_url", "redirect_url", "next=", "callback=", "url=", "goto="
```

### Vulnerability Pattern
```javascript
// VULNERABLE: Unvalidated redirect
app.get('/redirect', (req, res) => {
  res.redirect(req.query.url);  // url=https://evil.com
});

// SAFE: Allowlist validation
const ALLOWED_HOSTS = ['example.com', 'app.example.com'];
app.get('/redirect', (req, res) => {
  const url = new URL(req.query.url, 'https://example.com');
  if (!ALLOWED_HOSTS.includes(url.hostname)) {
    return res.status(400).send('Invalid redirect');
  }
  res.redirect(url.toString());
});
```

### Bypass Techniques to Check
- Protocol-relative: `//evil.com`
- Backslash: `\/evil.com` or `\evil.com`
- URL encoding: `%2f%2fevil.com`
- Data URI: `data:text/html,<script>...`
- JavaScript URI: `javascript:alert(1)`
- `@` in URL: `https://example.com@evil.com`

## Severity Classification

- **Critical:** Open redirect in OAuth callback enabling token theft
- **High:** Open redirect on login/auth pages enabling credential phishing
- **Medium:** Open redirect on general pages, or redirect with URL visible to user
- **Low:** Open redirect requiring authentication, or in non-sensitive flows

## Output Format

### Finding: REDIR-{NNN}
- **Title:** Open Redirect in {endpoint}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-601 (Open Redirect)
- **Description:** Redirect destination from {parameter} is not validated against an allowlist.
- **Impact:** Phishing, OAuth token theft, reputation damage, SSRF chaining.
- **Remediation:** Validate redirect URL against domain allowlist. Use relative paths only.
- **References:** https://cwe.mitre.org/data/definitions/601.html

## Common False Positives

1. **Relative redirects** — `/dashboard` or `./profile` cannot redirect to external domains
2. **Hardcoded redirect URLs** — redirect to constant URLs
3. **Framework-safe redirects** — some frameworks validate redirect URLs by default
