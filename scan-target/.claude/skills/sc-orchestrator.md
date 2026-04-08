---
name: sc-orchestrator
description: Master orchestration skill that coordinates the entire 4-phase security scanning pipeline
---

# SC: Security Check Orchestrator

## Purpose

The orchestrator is the central coordination skill for the security-check pipeline. It manages the execution of all scanning phases, dispatches vulnerability detection skills, tracks progress, aggregates results, and ensures the pipeline runs to completion even when individual skills encounter errors.

## Activation

This skill activates when the user issues any of the following commands:
- "run security check"
- "scan for vulnerabilities"
- "security audit"
- "full security scan"

For diff/incremental mode, see `sc-diff-report`.

## Pre-Check (Phase 0)

Before starting a scan:

1. Check if `security-report/` directory exists
2. If it exists, prompt the user:
   - **Rescan all**: Delete existing reports and run full scan
   - **Scan changed files only**: Use diff mode (delegates to `sc-diff-report`)
3. If it does not exist, create `security-report/` directory
4. Log scan start time

## Phase 1: Reconnaissance

Execute these skills sequentially:

### 1a. Architecture Mapping (sc-recon)
- Invoke the `sc-recon` skill
- Output: `security-report/architecture.md`
- Extract from output:
  - `detected_languages`: list of programming languages found
  - `detected_frameworks`: list of frameworks found
  - `application_type`: web app, API, CLI, library, etc.
  - `entry_points`: HTTP routes, CLI commands, etc.

### 1b. Dependency Audit (sc-dependency-audit)
- Invoke the `sc-dependency-audit` skill
- Output: `security-report/dependency-audit.md`
- Extract: known CVEs, risky dependencies, supply chain concerns

## Phase 2: Vulnerability Hunting

Based on `detected_languages` from Phase 1, activate the appropriate skills.

### Language-Specific Skills (activate based on detection)

| Detected Language | Skill to Activate |
|-------------------|-------------------|
| Go | sc-lang-go |
| TypeScript, JavaScript | sc-lang-typescript |
| Python | sc-lang-python |
| PHP | sc-lang-php |
| Rust | sc-lang-rust |
| Java, Kotlin | sc-lang-java |
| C#, F#, VB.NET | sc-lang-csharp |

### Universal Vulnerability Skills (always activate)

Launch ALL of the following skills as parallel subagents. Each skill runs independently and writes its results to `security-report/{skill-name}-results.md`.

**Injection Attacks:**
- sc-sqli — SQL Injection
- sc-nosqli — NoSQL Injection
- sc-graphql — GraphQL Injection & Abuse
- sc-xss — Cross-Site Scripting
- sc-ssti — Server-Side Template Injection
- sc-xxe — XML External Entity
- sc-ldap — LDAP Injection
- sc-cmdi — Command Injection
- sc-header-injection — HTTP Header Injection

**Code Execution:**
- sc-rce — Remote Code Execution
- sc-deserialization — Insecure Deserialization

**Access Control:**
- sc-auth — Authentication Flaws
- sc-authz — Authorization Flaws (IDOR)
- sc-privilege-escalation — Privilege Escalation
- sc-session — Session Management Flaws

**Data Exposure:**
- sc-secrets — Hardcoded Secrets & Credentials
- sc-data-exposure — Sensitive Data Exposure
- sc-crypto — Cryptography Misuse

**Server-Side:**
- sc-ssrf — Server-Side Request Forgery
- sc-path-traversal — Path Traversal & LFI/RFI
- sc-file-upload — Insecure File Upload
- sc-open-redirect — Open Redirect

**Client-Side:**
- sc-csrf — Cross-Site Request Forgery
- sc-cors — CORS Misconfiguration
- sc-clickjacking — Clickjacking
- sc-websocket — WebSocket Security

**Logic & Design:**
- sc-business-logic — Business Logic Flaws
- sc-race-condition — Race Conditions / TOCTOU
- sc-mass-assignment — Mass Assignment

**API Security:**
- sc-api-security — REST/GraphQL/gRPC Security
- sc-rate-limiting — Rate Limiting & DoS Vectors
- sc-jwt — JWT Implementation Flaws

**Infrastructure (activate if relevant files detected):**
- sc-iac — IaC Security (if Terraform/K8s manifests found)
- sc-docker — Docker Security (if Dockerfile/docker-compose found)
- sc-ci-cd — CI/CD Security (if .github/workflows or .gitlab-ci.yml found)

### Subagent Execution Rules

1. Each subagent runs two internal phases: **Discovery** then **Verification**
2. Each subagent writes results to `security-report/{skill-name}-results.md`
3. If a skill finds no issues, it writes a short file: `"No issues found by {skill-name}."`
4. If a skill encounters an error, log the error and continue with remaining skills
5. Maximum parallel subagents: limited by the host AI assistant's capability
6. Track completion: mark each skill as done when its result file is written

## Phase 3: Verification

After all Phase 2 skills complete:

1. Invoke the `sc-verifier` skill
2. Input: all `security-report/*-results.md` files
3. The verifier performs:
   - Reachability analysis
   - Sanitization verification
   - Framework protection check
   - Context analysis (test code, dead code, examples)
   - Duplicate detection and merging
   - Confidence scoring (0-100 per finding)
4. Output: `security-report/verified-findings.md`

## Phase 4: Reporting

After verification completes:

1. Invoke the `sc-report` skill
2. Input: `security-report/verified-findings.md`
3. The report generator produces:
   - Executive summary with risk score
   - Scan statistics
   - Findings grouped by severity (Critical → High → Medium → Low → Info)
   - CVSS v3.1-style severity for each finding
   - Remediation roadmap (4 phases)
4. Output: `security-report/SECURITY-REPORT.md`

## Error Handling

- If `sc-recon` fails: abort scan, report error to user
- If `sc-dependency-audit` fails: continue without dependency data, note in report
- If any Phase 2 skill fails: log error, continue with remaining skills
- If `sc-verifier` fails: skip verification, use raw findings in report (note: unverified)
- If `sc-report` fails: output raw verified-findings.md as the report

## Progress Reporting

During execution, report progress to the user at these milestones:
1. "Phase 1: Reconnaissance started..."
2. "Phase 1: Complete. Detected {N} languages, {M} entry points."
3. "Phase 2: Launching {N} vulnerability skills..."
4. "Phase 2: {completed}/{total} skills finished. {findings} potential findings so far."
5. "Phase 3: Verifying {N} findings..."
6. "Phase 3: Complete. {N} verified findings ({M} false positives eliminated)."
7. "Phase 4: Generating final report..."
8. "Scan complete. Report: security-report/SECURITY-REPORT.md"

## Output Structure

```
security-report/
├── architecture.md              # Phase 1: Codebase architecture map
├── dependency-audit.md          # Phase 1: Dependency analysis
├── sc-sqli-results.md           # Phase 2: Per-skill results
├── sc-xss-results.md            #   ...
├── sc-rce-results.md            #   ...
├── ...                          #   (one file per skill)
├── verified-findings.md         # Phase 3: Verified findings
└── SECURITY-REPORT.md           # Phase 4: Final report
```
