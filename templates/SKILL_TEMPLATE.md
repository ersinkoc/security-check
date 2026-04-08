---
name: sc-{skill-name}
description: {One-line description of what this skill detects}
---

# SC: {Skill Full Name}

## Purpose

{2-3 sentences explaining what this skill does, what vulnerability class it targets, and why it matters. Be specific about the attack vectors detected.}

Example:
> Detects SQL injection vulnerabilities across all variants including classic injection, blind injection (boolean-based and time-based), second-order injection, and ORM bypass patterns. Traces data flow from user input sources (HTTP parameters, headers, cookies, file uploads) through the application to SQL execution sinks, identifying cases where input reaches a query without proper parameterization.

## Activation

This skill activates during Phase 2 (Vulnerability Hunting) of the security-check pipeline. It is called by the orchestrator after Phase 1 (Reconnaissance) completes and `security-report/architecture.md` is available.

{Describe any conditions that must be true for this skill to run. For example, a database skill might only activate if a database technology is detected in architecture.md.}

## Phase 1: Discovery

To find candidate code sections that may contain {vulnerability type}:

### File Patterns

Search the following file patterns for candidate code:

- `**/*.{ext1}` -- {Language} source files
- `**/*.{ext2}` -- {Language} source files
- `**/routes/**`, `**/controllers/**` -- Route and controller directories
- `**/models/**` -- Data model files
- `**/{relevant-directory}/**` -- {Description of relevant directory}

Exclude these paths from scanning:
- `**/node_modules/**`
- `**/vendor/**`
- `**/.git/**`
- `**/dist/**`, `**/build/**`

### Keyword Patterns

Within matched files, search for these indicators:

**Primary Indicators (high likelihood of vulnerability):**
- `{dangerous_function_1}(` -- {Why this is dangerous}
- `{dangerous_function_2}(` -- {Why this is dangerous}
- `{string_pattern_1}` -- {Why this indicates a vulnerability}

**Secondary Indicators (moderate likelihood):**
- `{function_3}(` -- {Dangerous when combined with user input}
- `{pattern_2}` -- {Dangerous in certain contexts}

**Framework-Specific Indicators:**
- {Framework 1}: `{function}(`, `{method}(` -- {Context}
- {Framework 2}: `{function}(`, `{method}(` -- {Context}
- {Framework 3}: `{function}(`, `{method}(` -- {Context}

### Semantic Patterns

Look for these higher-level patterns that require code comprehension:

1. **Source-to-Sink Data Flow:** Trace user input ({list specific sources: request parameters, headers, cookies, form data, URL segments, file contents}) through the code to identify where it reaches a {dangerous operation} without passing through {sanitization/validation function}.

2. **Dynamic Construction:** Identify any location where {vulnerable construct} is built using string concatenation, template literals, or format strings with variables that originate from outside the function scope.

3. **Bypass Patterns:** Look for usage of {framework/library} that falls back to {unsafe operation}, particularly when {unsafe operation} includes interpolated variables rather than {safe alternative}.

4. **Indirect Paths:** Check for user input that is stored (in a database, file, or cache) and later retrieved and used in a {dangerous operation} without sanitization at the point of use (second-order {vulnerability type}).

## Phase 2: Verification

For each candidate identified in Phase 1, evaluate the following:

### Exploitability Assessment

- [ ] Can an attacker control the input that reaches the vulnerable sink?
- [ ] Is the input from an external source (HTTP request, file upload, database record originally from user input, environment variable set by an attacker)?
- [ ] Does the input reach the sink without passing through a {sanitization/validation} function?
- [ ] Is the code in a reachable execution path (not dead code, not commented out, not behind a feature flag that is disabled)?
- [ ] Can the attacker observe the result of exploitation (direct output, error messages, timing differences, side effects)?
- [ ] {Additional exploitability question specific to this vulnerability type}

### Sanitization Check

Check whether any of these mitigations exist between the input source and the vulnerable sink:

1. **{Primary mitigation}:** {Description of the correct mitigation and how to verify it is properly applied}
2. **Input Validation:** Input is validated against a whitelist, regex pattern, or type check that prevents malicious payloads
3. **{Secondary mitigation}:** {Description of an alternative mitigation}
4. **{Framework-level mitigation}:** {Description of framework-provided protection}

If any of these mitigations are present AND correctly applied (no bypass possible), reduce the confidence score by 30-50 points.

### Framework Protection Check

Verify whether the application's framework provides automatic protection:

- **{Framework 1}:** {What it protects by default and what bypass patterns to flag}
- **{Framework 2}:** {What it protects by default and what bypass patterns to flag}
- **{Framework 3}:** {What it protects by default and what bypass patterns to flag}
- **{Framework 4}:** {What it protects by default and what bypass patterns to flag}

### False Positive Elimination

Do NOT flag the following scenarios:

1. **{False positive scenario 1}:** {Description of why this looks like a vulnerability but is not}
2. **{False positive scenario 2}:** {Description}
3. **{False positive scenario 3}:** {Description}
4. **Test code:** Code in test directories (`**/test/**`, `**/tests/**`, `**/__tests__/**`, `**/spec/**`) using hardcoded test data
5. **Documentation:** Code in README files, comments, or documentation directories
6. **Generated code:** Auto-generated files (ORM migrations, API client stubs, protobuf output) where the vulnerable-looking pattern is generated safely

## Severity Classification

- **Critical:** {Exact conditions that make this vulnerability critical — e.g., "Unauthenticated remote code execution via user-controlled input reaching eval() without any sanitization, in a publicly accessible endpoint"}
- **High:** {Exact conditions for high severity — e.g., "Authenticated SQL injection with data exfiltration capability in an endpoint accessible to regular users"}
- **Medium:** {Exact conditions for medium severity — e.g., "Reflected XSS requiring user interaction (clicking a crafted link) with session cookie access limited by HttpOnly flag"}
- **Low:** {Exact conditions for low severity — e.g., "Potential SQL injection in an admin-only endpoint where parameterized queries are used inconsistently but the endpoint requires multi-factor authentication"}

## Language-Specific Notes

### Go
- {Dangerous function/pattern specific to Go}
- {Framework-specific note for Go (e.g., Gin, Echo, Fiber)}
- {Safe alternative in Go}

### TypeScript / JavaScript
- {Dangerous function/pattern specific to TS/JS}
- {Framework-specific note (e.g., Express, Next.js, Fastify)}
- {Safe alternative in TS/JS}

### Python
- {Dangerous function/pattern specific to Python}
- {Framework-specific note (e.g., Django, Flask, FastAPI)}
- {Safe alternative in Python}

### PHP
- {Dangerous function/pattern specific to PHP}
- {Framework-specific note (e.g., Laravel, WordPress, Symfony)}
- {Safe alternative in PHP}

### Rust
- {Dangerous function/pattern specific to Rust}
- {Framework-specific note (e.g., Actix-web, Axum, Rocket)}
- {Safe alternative in Rust}

### Java / Kotlin
- {Dangerous function/pattern specific to Java/Kotlin}
- {Framework-specific note (e.g., Spring Boot, Jakarta EE)}
- {Safe alternative in Java/Kotlin}

### C# / .NET
- {Dangerous function/pattern specific to C#/.NET}
- {Framework-specific note (e.g., ASP.NET Core, Entity Framework)}
- {Safe alternative in C#/.NET}

## Output Format

Each finding is reported in this format:

### Finding: {SKILL-ID}-{NNN}
- **Title:** {Short descriptive title — max 80 characters}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** {0-100}
- **File:** {relative/path/to/file.ext}:{line_number}
- **Vulnerability Type:** CWE-{NNN} — {CWE Title}
- **Description:** {2-4 sentences explaining what was found, where the user input originates, how it reaches the dangerous sink, and why existing protections (if any) are insufficient}
- **Proof of Concept:** {Conceptual description of how an attacker could exploit this — describe the attack vector, not an actual exploit payload}
- **Impact:** {What happens if this vulnerability is exploited — data breach, RCE, privilege escalation, denial of service, etc.}
- **Remediation:** {Specific steps to fix the vulnerability, including code examples showing the vulnerable pattern and the safe alternative}

  Vulnerable:
  ```{language}
  // Vulnerable code example
  ```

  Safe:
  ```{language}
  // Safe code example
  ```
- **References:**
  - https://cwe.mitre.org/data/definitions/{NNN}.html
  - {OWASP reference URL}
  - {Additional relevant documentation}

## Common False Positives

The following scenarios commonly trigger false detections for {vulnerability type}. The verification phase should eliminate these, but they are documented here for awareness:

1. **{False positive title 1}:** {Detailed description of the scenario and why it is not a real vulnerability. Example: "Static SQL queries with no external input — queries like `SELECT * FROM config WHERE key = 'timeout'` use only string literals and cannot be injected."}

2. **{False positive title 2}:** {Detailed description. Example: "ORM query builder methods — Django QuerySet filters like `User.objects.filter(name=request.GET['name'])` auto-parameterize the input. Only flag .raw(), .extra(), and cursor.execute()."}

3. **{False positive title 3}:** {Detailed description. Example: "Schema migration files — SQL in migration scripts runs at deploy time with hardcoded values, not at request time with user input."}

4. **{False positive title 4}:** {Detailed description. Example: "Stored procedures called with parameterized inputs — if the application passes user input as a parameter to a stored procedure and the stored procedure does not construct dynamic SQL, this is safe."}

5. **{False positive title 5}:** {Detailed description. Example: "Logging statements — SQL-like strings in log messages (e.g., logging the query template for debugging) are not executable and cannot be injected."}
