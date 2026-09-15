---
name: sc-orchestrator
description: Master orchestration skill that coordinates the entire 4-phase security scanning pipeline
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Security Check Orchestrator

## Purpose

The orchestrator is the central coordination skill for the security-check pipeline. It manages the execution of all scanning phases, dispatches vulnerability detection skills, tracks explicit coverage, aggregates results, and keeps incomplete work visible when individual skills encounter errors.

Apply this evidence contract throughout the pipeline: patterns create candidates, only independently verified trust-boundary failures become confirmed findings, and unavailable decisive facts remain `needs_validation` without severity. The source distribution includes the expanded rationale in `docs/EVIDENCE_MODEL.md`.

## Operating Modes

- **Guidance mode:** security questions, focused reviews, triage, and investigation use only relevant skills and do not automatically create the full report tree.
- **Full audit mode:** explicit repository audits, penetration tests, comprehensive reviews, or requested report artifacts run the complete four-phase pipeline.
- **Diff mode:** changed-file or PR requests delegate to `sc-diff-report` and disclose their partial scope.

## Activation

This skill activates when the user issues any of the following commands:
- "run security check"
- "scan for vulnerabilities"
- "security audit"
- "full security scan"

For diff/incremental mode, see `sc-diff-report`.

## Pre-Check (Phase 0)

Before starting a scan:

### Interactive Setup

Honor profile, scope, validation, and prior-report choices already present in the request.
For unresolved choices, use the host's structured question tool in one grouped call. In
Claude Code use `AskUserQuestion` so the choices render as native selection cards:

- **Profile:** Standard (recommended), Quick, Deep.
- **Scope:** Whole repository (recommended), Changed files, Custom paths.
- **Validation:** Source only (recommended), Sandboxed local checks.
- **Previous report, when present:** Continue and revalidate (recommended), Archive and start new, Replace.

Request a custom path only if that option is chosen. Selecting Changed files delegates to
`sc-diff-report`. Selecting Replace is the required explicit authorization to replace prior
artifacts; otherwise preserve them. If structured questions are unavailable, use standard,
whole-repository, source-only, and continue/revalidate defaults unless the user specified
otherwise. Do not ask again for facts already supplied.

Profiles control breadth and redundancy, not the evidence bar:

- `quick`: one bounded hunter wave and one coverage critic; report partial coverage.
- `standard`: complete applicable skill coverage and one final coverage critic.
- `deep`: finer subsystem/lifecycle units and repeat critics until clean or explicitly blocked.

The menu grants no authority for live probing, external side effects, dependency installation,
publication, credential use, paid services, or shared-infrastructure mutation.

1. Resolve the repository root, source ref, requested scope, scan profile, output directory, and any time or agent budget.
2. Check whether `security-report/` exists. Preserve prior artifacts by default; archive or replace them only with user authorization.
3. Read compatible prior coverage and findings. Revalidate changed source and carry forward only evidence whose relevant source and conditions still hold.
4. Create `security-report/`, `security-report/findings/`, and scan state only for a full audit.
5. Record start time, source ref, scope, execution limits, prior-run inputs, and status.

### Safe Execution Boundary

Source inspection is read-only. Target-controlled builds, tests, processes, parsers, browsers, emulators, or fuzzers may run only with no external network, an allowlisted credential-free environment, scratch-only writes, dummy data, and explicit resource/time limits. Never probe live services, publish artifacts, consume paid quota, or mutate shared infrastructure. If these controls are unavailable, continue source review and record the blocked runtime fact as `needs_validation`.

## Phase 1: Reconnaissance

Execute these skills sequentially:

### 1a. Architecture Mapping (sc-recon)
- Invoke the `sc-recon` skill
- Output: `security-report/architecture.md`
- Output: `security-report/coverage-ledger.md`
- Extract from output:
  - `detected_languages`: list of programming languages found
  - `detected_frameworks`: list of frameworks found
  - `application_type`: web app, API, CLI, library, etc.
  - `entry_points`: HTTP routes, CLI commands, etc.
  - `trust_boundaries`: lower-trust principals, protected resources, and controls
  - `coverage_units`: material surface × boundary × subsystem × attack-class combinations

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

Launch all applicable skills, in parallel when the host supports it. Each skill runs independently and writes only its own candidate JSON under `security-report/findings/`.

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

**Specialized surfaces (activate only when reconnaissance finds the boundary):**
- sc-ai-security — LLM context, RAG, memory, tools, MCP, and agent delegation
- sc-protocol-security — RPC, brokers, queues, webhooks, streaming, and message lifecycle
- sc-local-ipc — Desktop/mobile bridges, deep links, local IPC, helpers, installers, and updaters

### Subagent Execution Rules

1. Each subagent runs two internal phases: **Discovery** then **Verification**
2. Each hunter writes only its own `security-report/findings/{skill-name}.json`; the orchestrator alone updates shared scan state and the coverage ledger.
3. Each candidate identifies the attacker, entry, ordered source trace, control analysis, sink/resource, affected principal, meaningful result, conditions, and proposed verdict.
4. A clean skill result still records reviewed paths and concrete checks against its assigned coverage units.
5. If a skill encounters an error, log the error, mark its units blocked or deferred with reasons, and continue.
6. Maximum parallel subagents: limited by the host AI assistant's capability. Sequential execution is valid when delegation is unavailable.
7. Track completion only after its evidence is reflected in the coverage ledger.
8. After the first wave, run a coverage-critic pass for missed entry surfaces, alternate routes, lifecycle paths, wildcard issues, and uncovered units. Reassign material gaps when resources permit.

## Phase 3: Verification

After all Phase 2 skills complete:

1. Invoke the `sc-verifier` skill in a separate pass. When supported, use a verifier that did not produce the candidate.
2. Input: all `security-report/findings/*.json` files plus architecture and coverage artifacts
3. The verifier performs:
   - Reachability analysis
   - Sanitization verification
   - Framework protection check
   - Context analysis (test code, dead code, examples)
   - Duplicate detection and merging
   - Confidence scoring (0-100 per finding)
4. Require the verifier to try to disprove every candidate and assign one verdict: `confirmed`, `needs_validation`, or `rejected`.
5. Output: `security-report/findings.json` and `security-report/verified-findings.md`.
6. Severity is assigned only to `confirmed` findings and is based on demonstrated impact and conditions, not checklist deviation.

## Phase 4: Reporting

After verification completes:

1. Invoke the `sc-report` skill
2. Input: `security-report/findings.json`, `security-report/verified-findings.md`, and `security-report/coverage-ledger.md`
3. The report generator produces:
   - Executive summary with risk score
   - Scan statistics
   - Confirmed findings grouped by severity (Critical → High → Medium → Low)
   - Separate needs-validation leads without severity
   - Separate hardening notes and positive controls
   - Coverage totals and explicit blocked, deferred, and out-of-scope work
   - CVSS v3.1-style severity for each finding
   - Remediation roadmap (4 phases)
4. Output: `security-report/SECURITY-REPORT.md`

## Error Handling

- If `sc-recon` fails: abort scan, report error to user
- If `sc-dependency-audit` fails: continue without dependency data, note in report
- If any Phase 2 skill fails: log error, continue with remaining skills
- If `sc-verifier` fails: do not publish raw candidates as vulnerabilities; mark the run incomplete and retain them as unverified candidates
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
├── coverage-ledger.md           # Phase 1-4: Explicit coverage and gaps
├── dependency-audit.md          # Phase 1: Dependency analysis
├── findings/                    # Phase 2: Per-skill candidate JSON
│   ├── sc-sqli.json
│   ├── sc-xss.json
│   └── ...
├── findings.json                # Phase 3: Final structured verdicts
├── verified-findings.md         # Phase 3: Human-readable verification record
└── SECURITY-REPORT.md           # Phase 4: Final report
```
