---
name: sc-data-exposure
description: Sensitive data exposure detection — PII leaks, verbose errors, debug mode, and information disclosure
---

# SC: Sensitive Data Exposure

## Purpose

Detects sensitive data exposure including PII in logs, stack traces in production responses, debug mode enabled in production, sensitive data in URLs, source maps deployed to production, exposed .git directories, backup files, and excessive data in API responses. Focuses on data leaving the application boundary unintentionally.

## Activation

Called by sc-orchestrator during Phase 2. Always runs.

## Phase 1: Discovery

### Keyword Patterns to Search
```
# Debug/verbose modes
"DEBUG = True", "debug: true", "NODE_ENV.*development",
"FLASK_DEBUG", "APP_DEBUG", "RAILS_ENV.*development",
"stackTrace", "stack_trace", "printStackTrace"

# PII in logs
"logger.*email", "log.*password", "console.log.*token",
"logging.*credit", "log.*ssn", "print.*secret"

# Sensitive data in URLs
"?token=", "?api_key=", "?password=", "?secret=",
"?access_token=", "?session="

# Information disclosure
".git/", "phpinfo()", "server_info", "X-Powered-By",
".env", "wp-config.php", "web.config", "application.properties"

# Source maps
".map", "sourceMappingURL", "//# sourceMappingURL"

# Verbose error responses
"res.status(500).send(err)", "return error.message",
"traceback.format_exc()", "e.getMessage()"
```

### Vulnerability Patterns

**1. Stack Trace in Production:**
```javascript
// VULNERABLE: Raw error sent to client
app.use((err, req, res, next) => {
  res.status(500).json({ error: err.stack });
});

// SAFE: Generic error in production
app.use((err, req, res, next) => {
  console.error(err.stack);  // Log internally
  res.status(500).json({ error: 'Internal server error' });
});
```

**2. PII in Logs:**
```python
# VULNERABLE: Logging sensitive data
logger.info(f"User login: email={email}, password={password}")
logger.debug(f"Payment: card={card_number}, cvv={cvv}")

# SAFE: Redact sensitive fields
logger.info(f"User login: email={mask_email(email)}")
logger.debug(f"Payment: card=****{card_number[-4:]}")
```

**3. Debug Mode in Production:**
```python
# VULNERABLE: Django debug mode
# settings.py
DEBUG = True  # Exposes full stack traces, SQL queries, template context

# SAFE
DEBUG = os.environ.get('DEBUG', 'False') == 'True'
```

**4. Excessive Data in API Response:**
```javascript
// VULNERABLE: Returning full user object including sensitive fields
app.get('/api/users/:id', async (req, res) => {
  const user = await User.findById(req.params.id);
  res.json(user);  // Includes password hash, internal IDs, etc.
});

// SAFE: Select only needed fields
app.get('/api/users/:id', async (req, res) => {
  const user = await User.findById(req.params.id)
    .select('name email avatar');
  res.json(user);
});
```

## Severity Classification

- **Critical:** Production credentials in logs, PII bulk exposure, debug mode in production
- **High:** Stack traces revealing internals, .git exposure, sensitive API response data
- **Medium:** Source maps in production, verbose error messages, sensitive data in URLs
- **Low:** Server version headers, minor information disclosure

## Output Format

### Finding: EXPOSE-{NNN}
- **Title:** {Data exposure type}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-200 (Information Disclosure) | CWE-209 (Error Message Information Leak) | CWE-532 (Log File Information Disclosure)
- **Description:** {What sensitive data is exposed and through what channel}
- **Impact:** Privacy violation, credential theft, attack surface mapping.
- **Remediation:** {Redact sensitive data, disable debug mode, remove source maps, configure error handling}
- **References:** https://cwe.mitre.org/data/definitions/200.html

## Common False Positives

1. **Debug mode with env check** — `DEBUG = os.getenv('DEBUG')` properly controlled by environment
2. **Log redaction in place** — logging library configured to redact sensitive fields
3. **Development-only config** — debug settings in files clearly scoped to development
4. **Test logging** — verbose logging in test files
5. **Error handling middleware** — custom error handler that catches and redacts before responding
