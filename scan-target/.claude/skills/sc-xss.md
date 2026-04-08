---
name: sc-xss
description: Cross-Site Scripting detection for Reflected, Stored, and DOM-based XSS across all frameworks
---

# SC: Cross-Site Scripting (XSS)

## Purpose

Detects Cross-Site Scripting vulnerabilities across three categories: Reflected XSS (input reflected in response), Stored XSS (input persisted and rendered to other users), and DOM-based XSS (client-side JavaScript manipulation). Covers all major frontend frameworks and template engines, identifying cases where auto-escaping is bypassed.

## Activation

Called by sc-orchestrator during Phase 2. Runs against all web applications and APIs returning HTML.

## Phase 1: Discovery

### File Patterns to Search
```
**/*.html, **/*.htm, **/*.ejs, **/*.hbs, **/*.pug, **/*.jade,
**/*.tsx, **/*.jsx, **/*.vue, **/*.svelte, **/*.php, **/*.blade.php,
**/*.erb, **/*.haml, **/*.jinja2, **/*.twig, **/*.cshtml, **/*.razor,
**/*.thymeleaf, **/*.ftl, **/templates/*, **/views/*,
**/*.ts, **/*.js (for DOM-based XSS)
```

### Keyword Patterns to Search
```
# DOM-based XSS sinks
"innerHTML", "outerHTML", "document.write(", "document.writeln(",
"insertAdjacentHTML", ".html(", "$.html(",
"eval(", "setTimeout(.*,.*string", "setInterval(.*,.*string",
"location.href =", "location.assign(", "location.replace(",
"window.open(", "document.cookie"

# Framework-specific unsafe rendering
"dangerouslySetInnerHTML"                    # React
"v-html"                                     # Vue
"[innerHTML]", "bypassSecurityTrust"         # Angular
"{@html"                                     # Svelte
"{!! !!}"                                    # Laravel Blade (unescaped)
"| safe", "{% autoescape off %}", "mark_safe"  # Django/Jinja2
"<%= %>"                                     # ERB (unescaped)
"Html.Raw("                                  # ASP.NET Razor
"th:utext"                                   # Thymeleaf (unescaped)

# Server-side reflected output
"res.send(", "res.write(", "response.write("
"echo ", "print ", "Response.Write("
```

### Data Flow Tracing

**Sources (user input reaching client):**
- URL parameters → reflected in HTML response
- Form data → stored in database → rendered in views
- `document.location`, `document.URL`, `document.referrer` (DOM sources)
- `window.name`, `postMessage` data
- URL hash (`location.hash`)

**Sinks (unsafe rendering):**
- `innerHTML`, `outerHTML`, `document.write()`
- `dangerouslySetInnerHTML` (React)
- `v-html` (Vue), `[innerHTML]` (Angular)
- Template engine unescaped output
- `eval()`, `setTimeout(string)`, `Function()`

## Phase 2: Verification

### Sanitization Check
1. Is output HTML-encoded before rendering? (`&lt;`, `&gt;`, `&amp;`, `&quot;`)
2. Is a sanitization library used? (DOMPurify, bleach, HtmlSanitizer)
3. Is Content-Security-Policy header set to block inline scripts?
4. Is the framework's auto-escaping mechanism active?

### Framework Auto-Escaping
- **React JSX:** Auto-escapes by default. Only `dangerouslySetInnerHTML` is unsafe.
- **Vue:** `{{ }}` auto-escapes. `v-html` is unsafe.
- **Angular:** Auto-sanitizes by default. `bypassSecurityTrustHtml()` is unsafe.
- **Django:** `{{ }}` auto-escapes. `{{ var|safe }}`, `{% autoescape off %}`, `mark_safe()` are unsafe.
- **Laravel Blade:** `{{ }}` auto-escapes. `{!! !!}` is unsafe.
- **Jinja2:** Auto-escapes when configured. `{{ var|safe }}` is unsafe.
- **Go html/template:** Auto-escapes. `text/template` does NOT auto-escape.
- **Thymeleaf:** `th:text` escapes. `th:utext` is unsafe.
- **Razor:** `@Html.Encode()` escapes. `@Html.Raw()` is unsafe.

### Reflected XSS Example
```javascript
// VULNERABLE: Express reflecting input without encoding
app.get('/search', (req, res) => {
  res.send(`<h1>Results for: ${req.query.q}</h1>`);
});

// SAFE: Using a template engine with auto-escaping
app.get('/search', (req, res) => {
  res.render('search', { query: req.query.q }); // Template auto-escapes
});
```

### DOM-based XSS Example
```javascript
// VULNERABLE: Using innerHTML with URL parameter
const params = new URLSearchParams(window.location.search);
document.getElementById('output').innerHTML = params.get('name');

// SAFE: Using textContent instead
document.getElementById('output').textContent = params.get('name');
```

### Stored XSS Example
```python
# VULNERABLE: Rendering user-supplied HTML from database
@app.route('/profile/<user_id>')
def profile(user_id):
    user = User.query.get(user_id)
    return render_template('profile.html', bio=Markup(user.bio))  # mark_safe!

# SAFE: Let template auto-escape
@app.route('/profile/<user_id>')
def profile(user_id):
    user = User.query.get(user_id)
    return render_template('profile.html', bio=user.bio)  # Auto-escaped
```

## Severity Classification

- **Critical:** Stored XSS that executes for all users visiting a page, or XSS in authentication flows
- **High:** Reflected XSS with no CSP, or DOM-based XSS via commonly-used URL parameters
- **Medium:** Reflected XSS mitigated by CSP but still exploitable, or XSS in less-visited areas
- **Low:** Self-XSS (user can only attack themselves), or XSS with strong CSP blocking execution

## Output Format

### Finding: XSS-{NNN}
- **Title:** {Reflected|Stored|DOM-based} XSS in {location}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-79 (Cross-site Scripting)
- **Description:** User input from {source} is rendered without encoding via {sink}.
- **Proof of Concept:** Injecting `<img src=x onerror=alert(1)>` as the {parameter} would execute JavaScript in the victim's browser.
- **Impact:** Session hijacking, cookie theft, keylogging, phishing, defacement, malware distribution.
- **Remediation:** {Use framework auto-escaping / Apply DOMPurify / Set CSP header}
- **References:** https://cwe.mitre.org/data/definitions/79.html, https://owasp.org/Top10/A03_2021-Injection/

## Common False Positives

1. **React JSX expressions** — `{variable}` in JSX is auto-escaped, NOT vulnerable
2. **Vue template interpolation** — `{{ variable }}` is auto-escaped
3. **Angular binding** — `{{ }}` and `[property]` are auto-sanitized
4. **Content-Type: application/json** — JSON API responses are not rendered as HTML
5. **Admin panels rendering own content** — admin creating content for themselves is not XSS
6. **Markdown rendering** — if rendered through a safe markdown parser that strips HTML
7. **SVG/image generation** — server-side SVG generation without browser rendering context
