# {Language} Security Checklist

> {N}+ security checks for {Language} applications.
> Used by security-check `sc-lang-{language}` skill as reference.

---

## How to Use

This checklist is automatically referenced by the `sc-lang-{language}` skill during Phase 2 of the security-check pipeline. It can also be used manually during code reviews, security audits, or as a training reference.

**Automated usage:** When the `sc-lang-{language}` skill runs, it systematically scans the codebase against each category below, looking for violations. Each violated item is reported as a finding in `security-report/sc-lang-{language}-results.md` with the item's ID referenced.

**Manual usage:** Use this checklist during code reviews by checking each applicable item. Items marked with `- [ ]` are unchecked (not yet verified). Mark them as `- [x]` when verified as safe.

**Item format:**
```
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Critical|High|Medium|Low}. CWE: CWE-{NNN}.
```

- `SC-{LANG}-{NNN}` -- Unique identifier (SC = Security Check, {LANG} = language abbreviation, {NNN} = sequential number)
- `{Title}` -- Short name for the security check
- `{Description}` -- One-sentence explanation of what to verify
- `Severity` -- Impact level if the check fails (Critical, High, Medium, or Low)
- `CWE` -- Common Weakness Enumeration reference

---

## Categories

### 1. Input Validation and Sanitization ({N} items)

{Items in this category verify that all external input is validated, sanitized, and constrained before use. This includes HTTP request parameters, headers, cookies, file uploads, environment variables, and data from external services.}

- [ ] SC-{LANG}-001: {Title} — {Verify that all user input from HTTP request parameters is validated against expected types and ranges before processing}. Severity: High. CWE: CWE-20.
- [ ] SC-{LANG}-002: {Title} — {Verify that input length limits are enforced on all string inputs to prevent buffer overflows and denial of service}. Severity: Medium. CWE: CWE-120.
- [ ] SC-{LANG}-003: {Title} — {Verify that allow-list validation is used instead of deny-list validation for input that determines control flow}. Severity: High. CWE: CWE-184.
{Continue with items specific to {Language} input handling...}

### 2. Authentication and Session Management ({N} items)

{Items in this category verify that authentication mechanisms are implemented securely, sessions are managed correctly, and credential storage follows best practices.}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
{Continue with items specific to {Language} auth patterns...}

### 3. Authorization and Access Control ({N} items)

{Items in this category verify that authorization checks are present and correctly implemented, including role-based access control, resource-level authorization, and horizontal/vertical privilege boundaries.}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
{Continue...}

### 4. Cryptography ({N} items)

{Items in this category verify that cryptographic operations use strong algorithms, correct modes of operation, proper key management, and secure random number generation.}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
{Continue...}

### 5. Error Handling and Logging ({N} items)

{Items in this category verify that errors are handled without exposing sensitive information, that exceptions do not reveal internal state, and that error messages are appropriate for the audience (end users vs. developers).}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
{Continue...}

### 6. Data Protection and Privacy ({N} items)

{Items in this category verify that sensitive data (PII, credentials, financial data) is protected at rest and in transit, that data minimization principles are followed, and that data retention policies are enforced.}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
{Continue...}

### 7. SQL/NoSQL/ORM Security ({N} items)

{Items in this category verify that database interactions are safe from injection attacks, that ORM usage does not bypass parameterization, and that database permissions follow the principle of least privilege.}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
{Continue...}

### 8. File Operations ({N} items)

{Items in this category verify that file operations are safe from path traversal, that file uploads are validated and stored securely, and that temporary files are handled correctly.}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
{Continue...}

### 9. Network and HTTP Security ({N} items)

{Items in this category verify that HTTP security headers are set, that TLS is configured correctly, that CORS policies are restrictive, and that outbound requests are not vulnerable to SSRF.}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
{Continue...}

### 10. Serialization and Deserialization ({N} items)

{Items in this category verify that deserialization of untrusted data is avoided or performed safely, that format-specific risks are mitigated, and that schema validation is enforced.}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
{Continue...}

### 11. Concurrency and Race Conditions ({N} items)

{Items in this category verify that shared state is properly synchronized, that TOCTOU vulnerabilities are avoided, and that concurrency primitives are used correctly.}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
{Continue...}

### 12. Dependency and Supply Chain ({N} items)

{Items in this category verify that dependencies are from trusted sources, that lock files are committed and reviewed, that known-vulnerable packages are updated, and that build-time code execution risks are mitigated.}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
{Continue...}

### 13. Configuration and Secrets Management ({N} items)

{Items in this category verify that secrets are not hardcoded, that configuration is environment-aware, that debug modes are disabled in production, and that default credentials are changed.}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
{Continue...}

### 14. Memory Safety ({N} items)

{For languages with manual memory management (C, C++, Rust unsafe blocks): verify that memory is allocated and freed correctly, that buffer boundaries are checked, and that use-after-free is prevented.}

{For memory-safe languages (Python, Java, Go, TypeScript): focus on resource exhaustion, unbounded allocations, and denial-of-service patterns.}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
{Continue...}

### 15. {Language}-Specific Patterns ({N} items)

{Items in this category cover security patterns that are unique to {Language} and do not fit into the generic categories above. These are idioms, runtime behaviors, and ecosystem conventions that have security implications.}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
{Continue...}

### 16. Framework-Specific Checks ({N} items)

{Items in this category verify security configurations and patterns specific to popular {Language} frameworks. Organize subsections by framework (e.g., Django, Flask, FastAPI for Python).}

#### {Framework 1}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.

#### {Framework 2}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.

#### {Framework 3}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
{Continue...}

### 17. API Security ({N} items)

{Items in this category verify that APIs built with {Language} follow security best practices, including input validation on all endpoints, authentication on protected routes, rate limiting, and response data filtering.}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
{Continue...}

### 18. Testing and CI/CD Security ({N} items)

{Items in this category verify that test code does not contain hardcoded production credentials, that CI/CD pipelines do not expose secrets, and that security tests are included in the test suite.}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
{Continue...}

### 19. Logging and Monitoring Security ({N} items)

{Items in this category verify that logging does not capture sensitive data, that log injection is prevented, that security-relevant events are logged, and that monitoring alerts are configured for anomalous activity.}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
{Continue...}

### 20. Third-Party Integration Security ({N} items)

{Items in this category verify that integrations with external services (payment gateways, OAuth providers, webhooks, cloud APIs) are implemented securely, that webhook signatures are validated, and that API keys for third-party services are stored securely.}

- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
- [ ] SC-{LANG}-{NNN}: {Title} — {Description}. Severity: {Level}. CWE: CWE-{NNN}.
{Continue...}

---

## Instructions for Completing This Template

1. **Replace all `{placeholder}` values** with content specific to your target language.
2. **Use the correct language abbreviation** for the `SC-{LANG}` prefix:
   - Go: `SC-GO`
   - TypeScript/JavaScript: `SC-TS`
   - Python: `SC-PY`
   - PHP: `SC-PHP`
   - Rust: `SC-RS`
   - Java/Kotlin: `SC-JAVA`
   - C#/.NET: `SC-CS`
   - For new languages, use a 2-4 character uppercase abbreviation.
3. **Number items sequentially** starting at 001 and continuing without gaps through all categories.
4. **Minimum 400 items** across all categories. Target at least 15-25 items per category, with more items in categories that are especially relevant to the language.
5. **Every item must be unique** -- do not duplicate the same check with different wording.
6. **CWE references must be accurate** -- verify each CWE number at https://cwe.mitre.org/.
7. **Severity must reflect real-world impact** -- Critical means remote code execution or full data breach; Low means informational or defense-in-depth.
8. **Add categories as needed** -- If the language has specific patterns that deserve their own category (e.g., "Goroutine Safety" for Go, "Prototype Pollution" for JavaScript), add additional categories beyond the 20 listed above.
9. **Include framework-specific items** -- The Framework-Specific Checks category (16) should have subsections for each major framework in the language's ecosystem.
10. **Delete this instructions section** after completing the checklist.
