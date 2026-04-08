# Skill Development Guide

> How to create new vulnerability detection skills, language-specific scanners, and security checklists for security-check.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Skill File Format](#skill-file-format)
3. [Phase 1: Discovery Patterns](#phase-1-discovery-patterns)
4. [Phase 2: Verification Logic](#phase-2-verification-logic)
5. [Severity Classification Guidelines](#severity-classification-guidelines)
6. [Output Format Specification](#output-format-specification)
7. [Language-Specific Skills](#language-specific-skills)
8. [Checklist Development](#checklist-development)
9. [Testing Your Skill](#testing-your-skill)
10. [Common Pitfalls](#common-pitfalls)

---

## Prerequisites

Before developing a new skill, you should understand:

- The 4-phase pipeline architecture (see `docs/ARCHITECTURE.md`)
- The vulnerability class your skill will detect (CWE reference, attack vectors, real-world examples)
- At least one programming language where this vulnerability commonly appears
- The difference between a vulnerability skill (e.g., sc-sqli) and a language skill (e.g., sc-lang-python)

### When to Create a New Skill

Create a **vulnerability skill** when:
- A vulnerability class is not covered by existing skills
- An existing skill is too broad and a specific sub-class deserves dedicated analysis (e.g., sc-deserialization was split from sc-rce for deeper coverage)

Create a **language skill** when:
- A new programming language needs support
- The language has unique security patterns that generic vulnerability skills cannot detect

### File Locations

Place your skill in the canonical `skills/` directory following the agentskills.io format:

```
skills/sc-{your-skill}/SKILL.md
```

The `skills.sh` installer copies skills to `.claude/skills/` or `.agents/skills/` in the target project during installation. You only need to maintain the single source in `skills/`.

---

## Skill File Format

Every skill file must follow the standardized structure below. This format is not optional -- deviating from it may cause the orchestrator to skip or misinterpret your skill.

### Frontmatter

The file must begin with YAML frontmatter enclosed in `---` delimiters:

```markdown
---
name: sc-{skill-name}
description: One-line description of what this skill detects
---
```

**Naming conventions:**
- Vulnerability skills: `sc-{vulnerability-type}` (e.g., `sc-sqli`, `sc-xss`, `sc-ssrf`)
- Language skills: `sc-lang-{language}` (e.g., `sc-lang-go`, `sc-lang-python`)
- Infrastructure skills: `sc-{infrastructure-type}` (e.g., `sc-docker`, `sc-ci-cd`)
- Core pipeline skills: `sc-{function}` (e.g., `sc-recon`, `sc-verifier`, `sc-report`)

**Description guidelines:**
- Maximum one sentence
- Start with a verb: "Detects...", "Identifies...", "Scans for..."
- Be specific: "Detects SQL injection in parameterized queries and raw SQL construction" is better than "Finds SQL issues"

### Required Sections

Every vulnerability skill must contain these sections in order:

```markdown
# SC: {Full Name of the Skill}

## Purpose
## Activation
## Phase 1: Discovery
## Phase 2: Verification
## Severity Classification
## Language-Specific Notes
## Output Format
## Common False Positives
```

---

## Phase 1: Discovery Patterns

The Discovery section tells the AI agent how to find candidate code locations that might contain the vulnerability. There are three types of discovery patterns.

### Glob Patterns (File Selection)

Specify which files are relevant to your skill. This narrows the search scope and prevents wasted analysis.

```markdown
## Phase 1: Discovery

### File Patterns
Search the following file patterns for candidate code:
- `**/*.py` — Python source files
- `**/*.js`, `**/*.ts` — JavaScript and TypeScript source files
- `**/routes/**`, `**/controllers/**` — Route and controller directories
- `**/models/**` — Database model files
- `**/queries/**`, `**/sql/**` — SQL-related directories
```

**Guidelines:**
- Be specific enough to avoid scanning irrelevant files (e.g., `**/*.css`)
- Be broad enough to catch all relevant code (e.g., include `.tsx` if you include `.ts`)
- Include framework-specific paths where applicable (e.g., `app/Http/Controllers/**` for Laravel)
- Exclude test directories only if your vulnerability is irrelevant in test contexts

### Grep Patterns (Keyword Search)

Specify text patterns that indicate potential vulnerability presence. These are string or regex patterns the AI agent searches for within the files matched by glob patterns.

```markdown
### Keyword Patterns
Within matched files, search for these indicators:

**SQL Construction Indicators:**
- `query(`, `execute(`, `raw(`, `rawQuery(`
- `SELECT `, `INSERT `, `UPDATE `, `DELETE ` followed by string concatenation
- Template literals containing SQL keywords: `` `SELECT * FROM ${`` 
- String formatting with SQL: `f"SELECT`, `"SELECT %s"`, `"SELECT " +`
- ORM raw query methods: `.raw(`, `.execute(`, `.textual(`

**Framework-Specific Indicators:**
- Django: `RawSQL(`, `extra(where=`, `cursor.execute(`
- SQLAlchemy: `text(`, `from_statement(`, `session.execute(`
- Sequelize: `sequelize.query(`, `literal(`
- Prisma: `$queryRaw`, `$executeRaw`
```

**Guidelines:**
- List concrete function names, method names, and API calls
- Include string patterns that indicate dynamic query construction
- Provide both generic patterns and framework-specific patterns
- Order from most-likely-vulnerable to least-likely

### Semantic Patterns (Contextual Analysis)

Specify higher-level patterns that require understanding code context, not just text matching.

```markdown
### Semantic Patterns
Look for these higher-level patterns that require code comprehension:

1. **Source-to-Sink Data Flow:** Trace user input (request parameters, form data,
   URL path segments, headers, cookies) through the code to identify where it
   reaches a SQL execution function without passing through a parameterization
   or escaping function.

2. **Dynamic Query Construction:** Identify any location where SQL query strings
   are built using string concatenation, template literals, or format strings
   with variables that originate from outside the function scope.

3. **ORM Bypass Patterns:** Look for ORM usage that falls back to raw SQL,
   particularly when the raw SQL includes interpolated variables rather than
   parameterized placeholders.

4. **Stored Procedure Calls:** Check whether stored procedure invocations pass
   unsanitized input as parameters, especially if the stored procedure itself
   constructs dynamic SQL.
```

**Guidelines:**
- Describe data flow patterns (source to sink)
- Identify the "dangerous operations" specific to your vulnerability
- Describe what makes a code pattern vulnerable vs. safe
- Think about indirect paths (input stored in database, later used unsafely)

---

## Phase 2: Verification Logic

The Verification section tells the AI agent how to evaluate each candidate found in Phase 1 to determine if it is a real vulnerability or a false positive.

### Exploitability Checklist

Provide a concrete checklist the agent evaluates for each candidate:

```markdown
## Phase 2: Verification

For each candidate identified in Phase 1, evaluate the following:

### Exploitability Assessment
- [ ] Can an attacker control the input that reaches the vulnerable sink?
- [ ] Is the input from an external source (HTTP request, file upload, database
      record originally from user input)?
- [ ] Does the input reach the sink without passing through a parameterization
      or escaping function?
- [ ] Is the code in a reachable execution path (not dead code, not commented out)?
- [ ] Can the attacker observe the result of their injection (error messages,
      data output, timing differences)?
```

### Sanitization Check

Describe how to verify if input is sanitized:

```markdown
### Sanitization Check
Check whether any of these mitigations exist between the input source and the
vulnerable sink:

1. **Parameterized Queries:** Input is passed as a parameter (`?`, `$1`, `:name`)
   rather than concatenated into the query string
2. **Input Validation:** Input is validated against a whitelist, regex pattern,
   or type check before reaching the query
3. **Escaping Functions:** Input passes through a database-specific escape
   function (e.g., `mysql_real_escape_string`, `pg_escape_literal`)
4. **ORM Abstraction:** Input is used exclusively through ORM query builder
   methods that auto-parameterize

If any of these mitigations are present and correctly applied, reduce the
confidence score by 30-50 points.
```

### Framework Protection Check

Document framework-level protections that may prevent exploitation:

```markdown
### Framework Protection Check
Verify whether the application's framework provides automatic protection:

- **Django ORM:** Parameterizes by default when using QuerySet methods.
  Only flag `.raw()`, `.extra()`, and `cursor.execute()` with string formatting.
- **Rails ActiveRecord:** Parameterizes by default. Only flag `.find_by_sql()`,
  `.execute()`, and `.where()` with string interpolation.
- **Spring Data JPA:** Parameterizes `@Query` with `:param` syntax by default.
  Flag `@Query` with string concatenation and `EntityManager.createNativeQuery()`
  with string formatting.
```

### Context-Aware False Positive Elimination

Define scenarios that look like vulnerabilities but are not:

```markdown
### False Positive Elimination
Do NOT flag the following scenarios:

1. **Static queries:** SQL queries constructed entirely from string literals
   with no external input (e.g., `query("SELECT * FROM users WHERE active = 1")`)
2. **Schema migrations:** SQL in database migration files that runs at deploy
   time, not at request time
3. **Test fixtures:** SQL in test setup/teardown that uses hardcoded test data
4. **ORM-generated SQL:** SQL visible in debug logs or query logging but
   actually generated by the ORM with proper parameterization
5. **Documentation examples:** SQL in README, comments, or documentation files
```

---

## Severity Classification Guidelines

Every skill must define what each severity level means for its specific vulnerability type. Follow these general principles:

### Critical (CVSS 9.0-10.0)

The vulnerability is remotely exploitable by an unauthenticated attacker and leads to one or more of:
- Remote code execution
- Full database access or exfiltration
- Authentication bypass (gaining admin access)
- Complete system compromise

**Characteristics:**
- No user interaction required
- No authentication required
- No special conditions or configuration required
- Direct and immediate impact

### High (CVSS 7.0-8.9)

The vulnerability is exploitable with minimal conditions and leads to significant impact:
- Data breach of sensitive information
- Privilege escalation from user to admin
- Server-side request forgery to internal services
- Stored cross-site scripting affecting all users

**Characteristics:**
- May require authentication but at a low-privilege level
- May require specific but common conditions
- Impact is significant but may not be complete system compromise

### Medium (CVSS 4.0-6.9)

The vulnerability requires specific conditions and has limited or contained impact:
- Reflected XSS requiring user to click a crafted link
- CSRF on non-critical actions
- Information disclosure of non-sensitive system details
- Weak cryptography on non-critical data

**Characteristics:**
- Requires user interaction or specific conditions
- Impact is real but contained to specific functionality
- Partial mitigations may be in place

### Low (CVSS 0.1-3.9)

The vulnerability has minimal exploitability or impact:
- Verbose error messages revealing stack traces
- Missing security headers on non-sensitive pages
- Weak session timeout values
- Information disclosure of version numbers

**Characteristics:**
- Difficult to exploit or requires chain of other vulnerabilities
- Impact is informational or has minimal direct security consequence
- Defense-in-depth recommendation rather than active vulnerability

### Writing Severity Definitions for Your Skill

In your skill file, define what each severity level means specifically for the vulnerability type you are detecting:

```markdown
## Severity Classification
- **Critical:** {Exact conditions that make this vulnerability critical for YOUR skill}
- **High:** {Exact conditions for high severity}
- **Medium:** {Exact conditions for medium severity}
- **Low:** {Exact conditions for low severity}
```

Be concrete and specific to your vulnerability type. Generic definitions like "Critical: very bad" are not acceptable.

---

## Output Format Specification

Every finding must use the standardized output format. This ensures consistency across all skills and enables the verifier and reporter to process findings uniformly.

### Finding Template

```markdown
### Finding: {SKILL-ID}-{NNN}
- **Title:** {Short, descriptive title — max 80 characters}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** {0-100}
- **File:** {relative/path/to/file.ext}:{line_number}
- **Vulnerability Type:** CWE-{NNN} — {CWE Title}
- **Description:** {2-4 sentences explaining what was found and why it is a vulnerability}
- **Proof of Concept:** {Conceptual description of how an attacker could exploit this — NOT an actual exploit payload}
- **Impact:** {What happens if this vulnerability is exploited — data breach, RCE, privilege escalation, etc.}
- **Remediation:** {Specific steps to fix, including a code example showing the safe alternative}
- **References:**
  - https://cwe.mitre.org/data/definitions/{NNN}.html
  - {Additional OWASP or documentation references}
```

### Field Guidelines

**SKILL-ID:** Use your skill's short name in uppercase (e.g., `SQLI`, `XSS`, `RCE`, `SSRF`).

**NNN:** Sequential number starting at 001 for each scan. Reset per scan, not globally unique.

**Confidence scoring factors** (use these when assigning your initial confidence):

| Factor | Points |
|--------|--------|
| User input reaches dangerous sink without sanitization | +40 |
| Known-dangerous function/pattern detected | +20 |
| Data flow traced from source to sink | +20 |
| No framework protection detected | +10 |
| Multiple corroborating indicators | +10 |
| Sanitization present but incomplete | -10 |
| Code is in test/example directory | -30 |
| Ambiguous context | -20 |

**CWE references:** Use accurate CWE identifiers. Common ones for reference:
- CWE-89: SQL Injection
- CWE-79: Cross-site Scripting
- CWE-78: OS Command Injection
- CWE-502: Deserialization of Untrusted Data
- CWE-918: Server-Side Request Forgery
- CWE-22: Path Traversal
- CWE-287: Improper Authentication
- CWE-862: Missing Authorization
- CWE-798: Hardcoded Credentials
- CWE-327: Use of Broken Crypto Algorithm

**Proof of Concept:** Describe the attack conceptually. Do NOT provide actual exploit payloads, shellcode, or weaponized examples. Example: "An attacker could submit a crafted username containing SQL metacharacters to extract all records from the users table" rather than providing the actual SQL injection string.

**Remediation code examples:** Always show both the vulnerable pattern and the safe alternative:

```markdown
- **Remediation:**
  Replace the string-concatenated query with a parameterized query:

  Vulnerable:
  ```python
  cursor.execute(f"SELECT * FROM users WHERE id = {user_id}")
  ```

  Safe:
  ```python
  cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))
  ```
```

---

## Language-Specific Skills

Language skills follow a specialized format. See `templates/LANG_SKILL_TEMPLATE.md` for the full template.

### Structure Differences from Vulnerability Skills

| Section | Vulnerability Skill | Language Skill |
|---------|-------------------|----------------|
| Discovery | Glob + grep + semantic patterns | Category-based systematic scan |
| Verification | Exploitability checklist | Pattern-specific verification |
| Checklist | None | References `references/{lang}-security-checklist.md` |
| Categories | Single vulnerability class | 15-25 vulnerability categories |

### Category Structure

Each language skill contains 15-25 categories of language-specific vulnerability patterns:

```markdown
## {Language}-Specific Vulnerability Patterns

### Category 1: Input Validation and Sanitization
- **Pattern:** Description of the vulnerable pattern
- **Dangerous Functions:** `func1()`, `func2()`, `func3()`
- **Safe Alternative:** Description of the safe approach
- **Vulnerable Example:**
  ```{language}
  // Vulnerable code
  ```
- **Safe Example:**
  ```{language}
  // Safe code
  ```

### Category 2: Authentication and Session Security
...
```

### Checklist Integration

Language skills must reference their corresponding checklist:

```markdown
## Checklist Reference
This skill references `references/{language}-security-checklist.md`.
It systematically scans the codebase for each category in the checklist.
When a checklist item is found to be violated, it is reported as a finding
with the checklist item ID (e.g., SC-PY-042) included in the finding title.
```

### Adding Language-Specific Notes to Existing Skills

If you are adding language notes to an existing vulnerability skill (not creating a new language skill), add entries to the existing `## Language-Specific Notes` section:

```markdown
## Language-Specific Notes

### Go
- Use `database/sql` with `?` placeholders; never use `fmt.Sprintf` for queries
- Check for `db.Query(fmt.Sprintf(...))` patterns
- GORM: flag `.Raw()` and `.Exec()` with string interpolation

### Python
- Django: `.raw()` and `.extra(where=[])` bypass ORM parameterization
- SQLAlchemy: `text()` with f-strings or `.format()` is dangerous
- psycopg2: use `%s` placeholders, never `%` string formatting
```

---

## Checklist Development

When creating a new language skill, you must also create a matching security checklist.

### Checklist Format

See `templates/CHECKLIST_TEMPLATE.md` for the full template. Each item follows this format:

```
- [ ] SC-{LANG}-{NNN}: {Short Title} — {One-sentence description}. Severity: {Critical|High|Medium|Low}. CWE: CWE-{NNN}.
```

### ID Scheme

- `SC` = Security Check (constant prefix)
- `{LANG}` = Language abbreviation (GO, TS, PY, PHP, RS, JAVA, CS)
- `{NNN}` = Three-digit sequential number, unique within the checklist

### Minimum Requirements

- At least 400 unique items per language checklist
- At least 20 categories
- Each item must have a unique, meaningful description
- Severity must be assigned based on real-world impact
- CWE reference must be accurate and verifiable

### Category Coverage

Every checklist must cover at minimum these categories:

1. Input Validation and Sanitization
2. Authentication and Session Management
3. Authorization and Access Control
4. Cryptography
5. Error Handling and Logging
6. Data Protection and Privacy
7. SQL/NoSQL/ORM Security
8. File Operations
9. Network and HTTP Security
10. Serialization and Deserialization
11. Concurrency and Race Conditions
12. Dependency and Supply Chain
13. Configuration and Secrets Management
14. Memory Safety (language-dependent)
15. Language-Specific Patterns
16. Framework-Specific Checks
17. API Security
18. Testing and CI/CD Security
19. Logging and Monitoring Security
20. Third-Party Integration Security

---

## Testing Your Skill

Before submitting a new skill, test it against real code to validate detection accuracy.

### Step 1: Create a Test Project

Create a small project containing intentionally vulnerable code for each pattern your skill detects. Include:

- At least 3 clearly vulnerable patterns (should be detected)
- At least 3 clearly safe patterns (should NOT be detected)
- At least 2 edge cases (borderline patterns that test false positive elimination)

### Step 2: Run Your Skill in Isolation

1. Place your skill file in `.claude/skills/` (or `.agents/skills/`)
2. Open your AI assistant
3. Say: "Run only the sc-{your-skill} skill against this codebase"
4. Review the output for:
   - **True positives:** Vulnerable code that was correctly flagged
   - **False negatives:** Vulnerable code that was missed
   - **False positives:** Safe code that was incorrectly flagged
   - **Severity accuracy:** Are severity levels appropriate?
   - **Confidence accuracy:** Do confidence scores reflect certainty?

### Step 3: Cross-Language Testing

If your skill supports multiple languages, test it against vulnerable code in each supported language. Verify that:
- Language-specific notes are applied correctly
- Framework-specific patterns are detected for each framework mentioned
- Glob patterns include all relevant file extensions

### Step 4: Integration Testing

Run a full security-check scan (all phases) to verify:
- Your skill is activated by the orchestrator
- Results integrate correctly with the verifier
- Findings appear in the final report with correct formatting

### Validation Checklist

Before submitting your skill:

- [ ] Frontmatter is valid YAML with `name` and `description` fields
- [ ] All required sections are present (Purpose, Activation, Phase 1, Phase 2, Severity, Language Notes, Output, False Positives)
- [ ] File is at least 150 lines
- [ ] At least 3 vulnerable code examples per supported language
- [ ] At least 3 safe code examples per supported language
- [ ] CWE references are accurate (verified against cwe.mitre.org)
- [ ] Severity definitions are specific to the vulnerability type
- [ ] Common false positives section has at least 3 entries
- [ ] Skill is placed in `skills/sc-{name}/SKILL.md` (agentskills.io format)
- [ ] CLAUDE.md and AGENTS.md reference the new skill (if adding a new skill to the pipeline)

---

## Common Pitfalls

### 1. Overly Broad Discovery Patterns

**Problem:** Glob patterns like `**/*` or grep patterns like `query` match too many files and produce excessive false positives.

**Solution:** Be specific. Use `**/*.py` instead of `**/*`. Use `cursor.execute(` instead of `execute`. Include framework-specific paths like `app/models/**/*.rb`.

### 2. Missing Framework-Specific Protections

**Problem:** Flagging ORM usage as SQL injection when the ORM parameterizes by default.

**Solution:** Document every major framework's built-in protections in your verification section. Only flag patterns that explicitly bypass those protections.

### 3. Ignoring Context

**Problem:** Flagging vulnerable-looking code in test files, migration scripts, or documentation.

**Solution:** Include explicit false positive elimination rules for test directories (`**/test/**`, `**/tests/**`, `**/__tests__/**`, `**/spec/**`), migration directories, and documentation files.

### 4. Generic Severity Levels

**Problem:** Using identical severity definitions across all vulnerability types.

**Solution:** Each skill must define severity levels specific to its vulnerability type. "Critical SQL injection" means something different from "Critical XSS" in terms of impact and exploitability.

### 5. Missing Source-to-Sink Tracing

**Problem:** Flagging a dangerous function call without verifying that user-controlled input actually reaches it.

**Solution:** Always include source-to-sink data flow tracing in your Phase 1 semantic patterns. A `cursor.execute()` call is only vulnerable if user input reaches it.

### 6. Incomplete Language Coverage

**Problem:** A vulnerability skill mentions "all languages" but only provides examples for Python and JavaScript.

**Solution:** Provide concrete detection patterns, dangerous function lists, and code examples for every language you claim to support. If your skill is language-agnostic, provide at least examples for the 7 supported languages (Go, TypeScript, Python, PHP, Rust, Java, C#).

### 7. Inaccurate CWE References

**Problem:** Using the wrong CWE number or inventing CWE IDs that do not exist.

**Solution:** Verify every CWE reference at https://cwe.mitre.org/. Use the most specific CWE available. For example, use CWE-89 (SQL Injection) not CWE-74 (Injection) when the vulnerability is specifically SQL injection.

### 8. No Safe Code Examples

**Problem:** Showing vulnerable code without demonstrating the correct, safe alternative.

**Solution:** Every vulnerable code example must be paired with a safe alternative. Developers need to know not just "what is wrong" but "how to fix it."

### 9. Overly Confident Scoring

**Problem:** Assigning confidence scores of 90+ to every finding, making the scores meaningless.

**Solution:** Use the confidence scoring factors table. A finding with ambiguous context and partial sanitization should score 40-60, not 90.

### 10. Not Testing Against Real Code

**Problem:** A skill that works in theory but produces excessive false positives or misses obvious vulnerabilities when run against a real codebase.

**Solution:** Always test against a realistic project before submitting. Ideally, test against an open-source project with known vulnerabilities (e.g., OWASP WebGoat, Damn Vulnerable Web App) to validate detection.

---

## Quick Reference: File Locations

| Item | Path |
|------|------|
| Vulnerability skill (source) | `skills/sc-{name}/SKILL.md` |
| Language skill (source) | `skills/sc-lang-{language}/SKILL.md` |
| Language checklist | `skills/sc-lang-{language}/references/{language}-security-checklist.md` |
| Vulnerability skill template | `templates/SKILL_TEMPLATE.md` |
| Language skill template | `templates/LANG_SKILL_TEMPLATE.md` |
| Checklist template | `templates/CHECKLIST_TEMPLATE.md` |
| Orchestration (Claude Code) | `scan-target/CLAUDE.md` |
| Orchestration (Agents) | `scan-target/AGENTS.md` |
