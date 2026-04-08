---
name: sc-ldap
description: LDAP Injection detection in search filters, DN construction, and bind operations
---

# SC: LDAP Injection

## Purpose

Detects LDAP injection vulnerabilities where user input is incorporated into LDAP search filters or Distinguished Name (DN) strings without proper escaping, allowing authentication bypass, unauthorized data access, and directory information disclosure.

## Activation

Called by sc-orchestrator during Phase 2 when LDAP library usage is detected.

## Phase 1: Discovery

### File Patterns to Search
```
**/*.java, **/*.py, **/*.php, **/*.cs, **/*.go, **/*.ts, **/*.js,
**/*ldap*, **/*auth*, **/*login*, **/*directory*, **/*ad_*
```

### Keyword Patterns to Search
```
"ldap_search", "ldap_bind", "ldap_connect", "ldap_modify",
"LdapConnection", "DirContext", "InitialDirContext", "SearchControls",
"ldap3", "python-ldap", "ldap.search", "DirectorySearcher",
"SearchRequest", "(&(", "(|(", "objectClass="
```

### LDAP Filter Injection Example
```java
// VULNERABLE: String concatenation in LDAP filter
String filter = "(&(uid=" + username + ")(userPassword=" + password + "))";
NamingEnumeration results = ctx.search("ou=users,dc=example,dc=com", filter, controls);
// Attack: username = "admin)(|(uid=*" → filter becomes (&(uid=admin)(|(uid=*)(userPassword=anything))
// This matches ALL users, bypassing password check

// SAFE: Escape special LDAP characters
String safeUsername = LdapEncoder.filterEncode(username);
String safePassword = LdapEncoder.filterEncode(password);
String filter = "(&(uid=" + safeUsername + ")(userPassword=" + safePassword + "))";
```

```python
# VULNERABLE
search_filter = f"(&(uid={username})(userPassword={password}))"
conn.search('ou=users,dc=example,dc=com', search_filter)

# SAFE: Use ldap3 escape function
from ldap3.utils.conv import escape_filter_chars
safe_user = escape_filter_chars(username)
safe_pass = escape_filter_chars(password)
search_filter = f"(&(uid={safe_user})(userPassword={safe_pass}))"
```

```php
// VULNERABLE
$filter = "(&(uid=$username)(userPassword=$password))";
$result = ldap_search($conn, "ou=users,dc=example,dc=com", $filter);

// SAFE
$safe_user = ldap_escape($username, '', LDAP_ESCAPE_FILTER);
$safe_pass = ldap_escape($password, '', LDAP_ESCAPE_FILTER);
$filter = "(&(uid=$safe_user)(userPassword=$safe_pass))";
```

```csharp
// VULNERABLE
var searcher = new DirectorySearcher();
searcher.Filter = $"(&(uid={username})(userPassword={password}))";

// SAFE: Use proper encoding
var safeUser = username.Replace("\\", "\\5c").Replace("*", "\\2a")
    .Replace("(", "\\28").Replace(")", "\\29").Replace("\0", "\\00");
```

## Phase 2: Verification

### LDAP Special Characters
Characters requiring escaping in search filters: `*`, `(`, `)`, `\`, `NUL`
Characters requiring escaping in DNs: `,`, `+`, `"`, `\`, `<`, `>`, `;`

### Sanitization Check
1. Is input escaped using language-specific LDAP escape function?
2. Is input validated against expected format (username pattern)?
3. Is a parameterized LDAP search API used (some libraries support this)?

## Severity Classification

- **Critical:** Authentication bypass via LDAP filter injection in login functionality
- **High:** Unauthorized directory enumeration or data access
- **Medium:** LDAP injection with limited scope (e.g., filter manipulation in search)
- **Low:** LDAP injection in admin-only or internal tools

## Output Format

### Finding: LDAP-{NNN}
- **Title:** LDAP Injection in {function/endpoint}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-90 (LDAP Injection)
- **Description:** User input from {source} is concatenated into LDAP {filter|DN} without escaping.
- **Proof of Concept:** Supplying `*)(uid=*))(|(uid=*` as username would modify the LDAP filter to match all entries.
- **Impact:** Authentication bypass, unauthorized directory access, information disclosure.
- **Remediation:** Use language-specific LDAP escape functions for all user input in filters and DNs.
- **References:** https://cwe.mitre.org/data/definitions/90.html

## Common False Positives

1. **Hardcoded LDAP filters** — filters built entirely from constants
2. **LDAP connection setup** — connection configuration without user-controlled filter values
3. **Schema queries** — querying LDAP schema with fixed filters
4. **Input validated as UUID/email** — strict input validation preventing special characters
