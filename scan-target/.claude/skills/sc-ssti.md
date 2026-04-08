---
name: sc-ssti
description: Server-Side Template Injection detection across all major template engines
---

# SC: Server-Side Template Injection (SSTI)

## Purpose

Detects server-side template injection vulnerabilities where user input is embedded into template strings before compilation/rendering, allowing attackers to execute arbitrary code on the server. Covers Jinja2, Twig, Freemarker, Velocity, Pug, Handlebars, ERB, Mako, Thymeleaf, and Go templates.

## Activation

Called by sc-orchestrator during Phase 2 when template engines are detected.

## Phase 1: Discovery

### File Patterns to Search
```
**/*.py, **/*.php, **/*.java, **/*.rb, **/*.js, **/*.ts, **/*.go,
**/templates/*, **/views/*, **/*template*, **/*render*, **/*view*
```

### Keyword Patterns to Search
```
# Python/Jinja2
"render_template_string(", "Template(", "Environment(",
"from_string(", "jinja2.Template("

# PHP/Twig
"$twig->createTemplate(", "Twig\\Template", "renderString("

# Java/Freemarker/Velocity/Thymeleaf
"new Template(", "freemarker", "VelocityEngine",
"templateEngine.process(", "StandardDialect"

# Ruby/ERB
"ERB.new(", "render inline:", "Erubis"

# JavaScript/Pug/Handlebars/EJS
"pug.render(", "pug.compile(", "Handlebars.compile(",
"ejs.render(", "nunjucks.renderString("

# Go
"template.New(", "text/template", "html/template",
".Parse(", "template.Must("
```

### Semantic Patterns
1. User input passed as the template STRING (not as template DATA)
2. String concatenation used to build template content before compilation
3. Template created from user-controlled source (database, HTTP parameter)
4. `render_template_string()` instead of `render_template()` in Flask

## Phase 2: Verification

### Key Distinction
The vulnerability occurs when user input becomes part of the TEMPLATE CODE, not the template DATA:

```python
# SAFE: User input as template data (parameterized)
render_template('hello.html', name=user_input)

# VULNERABLE: User input as template code
render_template_string(f"Hello {user_input}")
# If user_input = "{{7*7}}", the template engine evaluates it as 49
# If user_input = "{{config.items()}}", it leaks Flask config
```

### Template Engine Payloads (for understanding detection, not exploitation)

| Engine | Detection Probe | Code Execution |
|--------|----------------|----------------|
| Jinja2 | `{{7*7}}` → `49` | `{{config.__class__.__init__.__globals__['os'].popen('id').read()}}` |
| Twig | `{{7*7}}` → `49` | `{{_self.env.registerUndefinedFilterCallback("system")}}{{_self.env.getFilter("id")}}` |
| Freemarker | `${7*7}` → `49` | `<#assign ex="freemarker.template.utility.Execute"?new()>${ex("id")}` |
| Velocity | `$class.inspect("java.lang.Runtime")` | Via reflection chain |
| Pug | `#{7*7}` → `49` | Via code blocks |
| ERB | `<%= 7*7 %>` → `49` | `<%= system("id") %>` |
| Mako | `${7*7}` → `49` | `${__import__("os").popen("id").read()}` |
| Thymeleaf | `[[${7*7}]]` → `49` | Via SpEL: `${T(java.lang.Runtime).getRuntime().exec("id")}` |

### Jinja2 SSTI Example
```python
# VULNERABLE: User input in template string
@app.route('/greeting')
def greeting():
    template = f"Hello, {request.args.get('name', 'World')}!"
    return render_template_string(template)

# SAFE: User input as template variable
@app.route('/greeting')
def greeting():
    return render_template_string(
        "Hello, {{ name }}!",
        name=request.args.get('name', 'World')
    )
```

### Go text/template vs html/template
```go
// VULNERABLE: text/template with user input in template string
tmpl := fmt.Sprintf("Hello, %s!", userInput)
t, _ := template.New("").Parse(tmpl)  // text/template does not escape!

// SAFE: html/template with user input as data
t, _ := htmltemplate.New("").Parse("Hello, {{.Name}}!")
t.Execute(w, map[string]string{"Name": userInput})
```

## Severity Classification

- **Critical:** SSTI leading to Remote Code Execution (Jinja2, Twig, Freemarker, ERB, Mako)
- **High:** SSTI leading to sensitive data disclosure (config leaks, environment variables)
- **Medium:** SSTI in sandboxed template engine with limited execution capabilities
- **Low:** Template injection that only allows basic arithmetic or string manipulation

## Output Format

### Finding: SSTI-{NNN}
- **Title:** Server-Side Template Injection in {engine} at {endpoint}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-1336 (Improper Neutralization of Special Elements Used in a Template Engine)
- **Description:** User input from {source} is embedded into {engine} template string before rendering.
- **Proof of Concept:** Supplying `{{7*7}}` as input would render `49`, confirming template evaluation.
- **Impact:** Remote code execution, server compromise, data exfiltration, lateral movement.
- **Remediation:** Pass user input as template variables/context, never as part of the template string. Use `render_template()` instead of `render_template_string()`.
- **References:** https://cwe.mitre.org/data/definitions/1336.html, https://portswigger.net/web-security/server-side-template-injection

## Common False Positives

1. **Template rendering with variables** — `render_template('page.html', data=user_input)` is safe
2. **Static templates** — templates loaded from files with no user input in template code
3. **Client-side templating** — Handlebars/Mustache running in browser (not SSTI, may be client XSS)
4. **Template inheritance** — `{% extends %}` and `{% include %}` with static paths
5. **Admin template editors** — if only admin users can edit templates (still risky but different threat model)
