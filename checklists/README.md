# Security Checklists

> Exhaustive, language-based security checklists used by security-check skills during scanning.

## Overview

This directory contains comprehensive security checklists for each supported programming language and technology. These checklists are automatically referenced by the corresponding `sc-lang-*` skills during Phase 2 (Vulnerability Hunting) of the security-check pipeline.

## Checklist Files

| File | Target | Items | Referenced By |
|------|--------|-------|--------------|
| `go-security-checklist.md` | Go applications | 400+ | `sc-lang-go` |
| `typescript-security-checklist.md` | TypeScript/JavaScript applications | 400+ | `sc-lang-typescript` |
| `python-security-checklist.md` | Python applications | 400+ | `sc-lang-python` |
| `php-security-checklist.md` | PHP applications | 400+ | `sc-lang-php` |
| `rust-security-checklist.md` | Rust applications | 400+ | `sc-lang-rust` |
| `java-security-checklist.md` | Java/Kotlin applications | 400+ | `sc-lang-java` |
| `csharp-security-checklist.md` | C#/.NET applications | 400+ | `sc-lang-csharp` |
| `api-security-checklist.md` | REST, GraphQL, gRPC APIs | 200+ | `sc-api-security` |
| `docker-security-checklist.md` | Docker/Container deployments | 150+ | `sc-docker` |
| `cicd-security-checklist.md` | CI/CD pipelines | 150+ | `sc-ci-cd` |

## How Checklists Are Used

### Automatic Usage (During Scans)

When security-check runs, the `sc-recon` skill first identifies which languages are present in the codebase. Based on the detected languages, the corresponding `sc-lang-*` skills are activated. Each language skill references its checklist file and systematically scans the codebase for each category of vulnerabilities listed in the checklist.

```
sc-recon detects Go, TypeScript
    → sc-lang-go activates → references go-security-checklist.md
    → sc-lang-typescript activates → references typescript-security-checklist.md
    → sc-api-security activates → references api-security-checklist.md
    → sc-docker activates (if Dockerfiles found) → references docker-security-checklist.md
```

### Manual Usage (Code Review)

Checklists can also be used independently during manual code reviews. Each item includes:

- **Unique ID** (e.g., `SC-GO-042`) for tracking and reference
- **Short title** for quick identification
- **Description** explaining the security concern
- **Severity** rating (Critical, High, Medium, Low)
- **CWE reference** linking to the Common Weakness Enumeration

### Item Format

Every checklist item follows this standardized format:

```
- [ ] SC-{LANG}-{NNN}: {Short title} — {One-sentence description}. Severity: {Critical|High|Medium|Low}. CWE: CWE-{XXX}.
```

Example:
```
- [ ] SC-GO-001: Unsafe pointer dereference — Check for raw pointer dereference in unsafe blocks without nil validation. Severity: Critical. CWE: CWE-476.
```

## Checklist Categories

Each language checklist contains up to 20 categories covering:

1. **Input Validation & Sanitization** — User input handling and sanitization
2. **Authentication & Session Management** — Login, session, and identity verification
3. **Authorization & Access Control** — Permission and access control checks
4. **Cryptography** — Encryption, hashing, and random number generation
5. **Error Handling & Logging** — Error responses and logging practices
6. **Data Protection & Privacy** — PII handling and data storage
7. **SQL/NoSQL/ORM Security** — Database query safety
8. **File Operations** — File read/write and path handling
9. **Network & HTTP Security** — HTTP headers, TLS, and network calls
10. **Serialization & Deserialization** — Data serialization safety
11. **Concurrency & Race Conditions** — Thread safety and atomic operations
12. **Dependency & Supply Chain** — Third-party dependency risks
13. **Configuration & Secrets Management** — Configuration and secret storage
14. **Memory Safety** — Memory handling (language-dependent)
15. **Language-Specific Patterns** — Idioms and patterns unique to the language
16. **Framework-Specific Checks** — Checks for popular frameworks
17. **API Security** — API-specific security patterns
18. **Testing & CI/CD Security** — Test and pipeline security
19. **Logging & Monitoring Security** — Log safety and monitoring
20. **Third-Party Integration Security** — External service integration safety

## Adding a New Checklist

1. Copy `templates/CHECKLIST_TEMPLATE.md` to this directory
2. Rename to `{language}-security-checklist.md`
3. Fill in all 20 categories with language-specific items
4. Ensure at least 400 items for language checklists, 150+ for technology checklists
5. Each item must have a unique ID, accurate CWE reference, and severity rating
6. Create a corresponding `sc-lang-{language}` skill that references the checklist

## Severity Definitions

| Severity | Description |
|----------|-------------|
| **Critical** | Directly exploitable vulnerability that can lead to full system compromise, RCE, or complete data breach |
| **High** | Significant vulnerability that can lead to unauthorized access, data theft, or privilege escalation |
| **Medium** | Vulnerability that requires specific conditions to exploit or has limited impact |
| **Low** | Minor security concern, informational finding, or defense-in-depth recommendation |

## CWE References

All CWE (Common Weakness Enumeration) references link to real entries in the MITRE CWE database at https://cwe.mitre.org/. These references help teams understand the broader vulnerability class and find additional remediation guidance.
