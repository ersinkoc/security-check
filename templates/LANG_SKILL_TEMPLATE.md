---
name: sc-lang-{language}
description: {Language}-specific security deep scan
---

# SC: {Language} Security Deep Scan

## Purpose

Detects {Language}-specific security anti-patterns, common mistakes, and language-idiomatic attack vectors. Focuses on vulnerabilities that generic vulnerability skills (sc-sqli, sc-xss, sc-rce, etc.) cannot catch because they require knowledge of {Language}-specific runtime behavior, standard library pitfalls, framework conventions, and ecosystem-specific supply chain risks.

This skill complements the generic vulnerability skills by providing deep, language-aware analysis. It does not duplicate what the generic skills do -- instead it targets patterns that are unique to {Language} and would be missed by language-agnostic analysis.

## Activation

This skill activates automatically during Phase 2 (Vulnerability Hunting) when {Language} is detected in `security-report/architecture.md`. Detection is based on the presence of {Language} source files (`*.{ext}`), configuration files (`{config_file}`), and lock files (`{lock_file}`).

If {Language} is not detected during reconnaissance, this skill does not run.

## Checklist Reference

This skill references `references/{language}-security-checklist.md`. It systematically scans the codebase for each category in the checklist. When a checklist item is found to be violated, it is reported as a finding with the checklist item ID (e.g., SC-{LANG}-042) included in the finding title.

The checklist contains 400+ security check items organized into 20 categories. This skill does not need to check every item -- it prioritizes items that are detectable through static analysis and skips items that require runtime testing.

## {Language}-Specific Vulnerability Patterns

### Category 1: Input Validation and Sanitization

{Language}-specific input handling patterns that lead to injection vulnerabilities.

**Dangerous Patterns:**
- `{dangerous_function_1}()` -- {Why this is dangerous in {Language}}
- `{dangerous_function_2}()` -- {Why this is dangerous}
- {Description of a language-specific input handling pitfall}

**Safe Alternatives:**
- Use `{safe_function_1}()` instead of `{dangerous_function_1}()`
- {Description of the safe approach}

**Vulnerable Example:**
```{language}
// Vulnerable: {description of what makes this vulnerable}
{vulnerable code example}
```

**Safe Example:**
```{language}
// Safe: {description of what makes this safe}
{safe code example}
```

### Category 2: Authentication and Session Security

{Language}-specific authentication patterns and session management pitfalls.

**Dangerous Patterns:**
- {Pattern description}
- {Pattern description}

**Safe Alternatives:**
- {Safe approach}

**Vulnerable Example:**
```{language}
{vulnerable code example}
```

**Safe Example:**
```{language}
{safe code example}
```

### Category 3: Authorization and Access Control

{Language}-specific authorization bypass patterns.

**Dangerous Patterns:**
- {Pattern description}
- {Pattern description}

**Safe Alternatives:**
- {Safe approach}

**Vulnerable Example:**
```{language}
{vulnerable code example}
```

**Safe Example:**
```{language}
{safe code example}
```

### Category 4: Cryptography Misuse

{Language}-specific cryptography implementation errors.

**Dangerous Patterns:**
- {Weak PRNG usage in {Language}}
- {Weak hash function usage}
- {Key management errors specific to {Language}}

**Safe Alternatives:**
- {Correct PRNG in {Language}}
- {Correct hash function usage}

**Vulnerable Example:**
```{language}
{vulnerable code example}
```

**Safe Example:**
```{language}
{safe code example}
```

### Category 5: Error Handling and Information Disclosure

{Language}-specific error handling patterns that leak sensitive information.

**Dangerous Patterns:**
- {Pattern description}
- {Pattern description}

**Safe Alternatives:**
- {Safe approach}

**Vulnerable Example:**
```{language}
{vulnerable code example}
```

**Safe Example:**
```{language}
{safe code example}
```

### Category 6: Data Protection and Privacy

{Language}-specific patterns that expose sensitive data.

**Dangerous Patterns:**
- {Pattern description}
- {Pattern description}

**Safe Alternatives:**
- {Safe approach}

### Category 7: Database and ORM Security

{Language}-specific database interaction patterns and ORM pitfalls.

**Dangerous Patterns:**
- {ORM raw query bypass}
- {Database driver misuse}

**Safe Alternatives:**
- {Correct ORM usage}
- {Parameterized query pattern}

**Vulnerable Example:**
```{language}
{vulnerable code example}
```

**Safe Example:**
```{language}
{safe code example}
```

### Category 8: File System Operations

{Language}-specific file operation vulnerabilities.

**Dangerous Patterns:**
- {Path traversal pattern in {Language}}
- {Unsafe file read/write}

**Safe Alternatives:**
- {Safe path handling}

**Vulnerable Example:**
```{language}
{vulnerable code example}
```

**Safe Example:**
```{language}
{safe code example}
```

### Category 9: Network and HTTP Security

{Language}-specific network and HTTP handling vulnerabilities.

**Dangerous Patterns:**
- {SSRF pattern in {Language}}
- {TLS/SSL misconfiguration}
- {HTTP client pitfall}

**Safe Alternatives:**
- {Safe HTTP client configuration}

### Category 10: Serialization and Deserialization

{Language}-specific deserialization vulnerabilities.

**Dangerous Patterns:**
- {Insecure deserialization in {Language}}
- {Format-specific risks}

**Safe Alternatives:**
- {Safe deserialization approach}

**Vulnerable Example:**
```{language}
{vulnerable code example}
```

**Safe Example:**
```{language}
{safe code example}
```

### Category 11: Concurrency and Race Conditions

{Language}-specific concurrency vulnerabilities.

**Dangerous Patterns:**
- {Race condition pattern in {Language}}
- {Shared state mutation}
- {Concurrency primitive misuse}

**Safe Alternatives:**
- {Correct synchronization}

### Category 12: Dependency and Supply Chain

{Language}-specific package manager and dependency risks.

**Dangerous Patterns:**
- {Package manager attack vector}
- {Build-time code execution risk}
- {Typosquatting indicators}

**Safe Alternatives:**
- {Lock file best practices}
- {Dependency auditing approach}

### Category 13: Configuration and Secrets Management

{Language}-specific configuration handling pitfalls.

**Dangerous Patterns:**
- {Hardcoded secrets pattern in {Language}}
- {Debug mode in production}
- {Insecure default configuration}

**Safe Alternatives:**
- {Environment variable approach}
- {Secrets manager integration}

### Category 14: Memory Safety

{Applicable to languages with manual memory management or unsafe blocks. For memory-safe languages, focus on denial-of-service via resource exhaustion.}

**Dangerous Patterns:**
- {Memory safety issue or resource exhaustion pattern}
- {Buffer handling issue or unbounded allocation}

**Safe Alternatives:**
- {Safe memory/resource handling}

### Category 15: {Language}-Specific Runtime Patterns

Patterns unique to the {Language} runtime that have security implications.

**Dangerous Patterns:**
- {Runtime-specific vulnerability pattern 1}
- {Runtime-specific vulnerability pattern 2}
- {Runtime-specific vulnerability pattern 3}

**Safe Alternatives:**
- {Correct approach for each pattern}

**Vulnerable Example:**
```{language}
{vulnerable code example}
```

**Safe Example:**
```{language}
{safe code example}
```

### Category 16: {Primary Framework} Security

Security patterns specific to the most popular {Language} web framework.

**Dangerous Patterns:**
- {Framework-specific vulnerability 1}
- {Framework-specific vulnerability 2}
- {Framework-specific middleware/plugin risk}

**Safe Alternatives:**
- {Correct framework usage}

**Vulnerable Example:**
```{language}
{vulnerable code example}
```

**Safe Example:**
```{language}
{safe code example}
```

### Category 17: {Secondary Framework} Security

Security patterns specific to another popular {Language} framework.

**Dangerous Patterns:**
- {Framework-specific vulnerability 1}
- {Framework-specific vulnerability 2}

**Safe Alternatives:**
- {Correct framework usage}

### Category 18: API Security Patterns

{Language}-specific API security considerations.

**Dangerous Patterns:**
- {API input validation gap}
- {API authentication/authorization issue}
- {API response data exposure}

**Safe Alternatives:**
- {Correct API security pattern}

### Category 19: Logging and Monitoring Security

{Language}-specific logging pitfalls with security implications.

**Dangerous Patterns:**
- {Log injection in {Language}}
- {Sensitive data in logs}
- {Log forging pattern}

**Safe Alternatives:**
- {Structured logging approach}
- {Sensitive data redaction}

### Category 20: Third-Party Integration Security

Patterns related to integrating with external services from {Language} code.

**Dangerous Patterns:**
- {Unsafe webhook handling}
- {OAuth implementation pitfall}
- {Payment gateway integration risk}

**Safe Alternatives:**
- {Correct integration pattern}

{Add additional categories as needed. Language skills should have 15-25 categories total. Remove categories that are not applicable to the language and add language-specific categories as appropriate.}

## Output Format

Each finding is reported in this format:

### Finding: LANG-{LANG}-{NNN}
- **Title:** {Short descriptive title} (SC-{LANG}-{NNN})
- **Severity:** Critical | High | Medium | Low
- **Confidence:** {0-100}
- **File:** {relative/path/to/file.ext}:{line_number}
- **Vulnerability Type:** CWE-{NNN} — {CWE Title}
- **Checklist Item:** SC-{LANG}-{NNN} (if matching a specific checklist item)
- **Description:** {2-4 sentences explaining the {Language}-specific vulnerability, why it exists in this code, and what makes it exploitable}
- **Proof of Concept:** {Conceptual description of exploitation}
- **Impact:** {Consequences of exploitation}
- **Remediation:** {How to fix, with {Language}-specific code example}

  Vulnerable:
  ```{language}
  // Vulnerable code
  ```

  Safe:
  ```{language}
  // Safe code
  ```
- **References:**
  - https://cwe.mitre.org/data/definitions/{NNN}.html
  - {Language-specific documentation reference}
  - {Framework-specific security guide reference}

## Common False Positives

1. **{False positive scenario 1}:** {Description of a common {Language}-specific pattern that looks dangerous but is safe, and why.}

2. **{False positive scenario 2}:** {Description.}

3. **{False positive scenario 3}:** {Description.}

4. **Test code with intentionally unsafe patterns:** Test files that use dangerous functions for testing purposes (e.g., testing that input validation correctly rejects malicious input) should not be flagged.

5. **Generated code:** Auto-generated files ({Language}-specific examples: ORM migrations, protobuf stubs, API client code) may contain patterns that look unsafe but are generated correctly by trusted tooling.
