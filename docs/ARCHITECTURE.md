# security-check Architecture

> Detailed technical architecture of the security-check scanning pipeline.

---

## Overview

security-check is a collection of agent skills that transforms LLM-based AI coding assistants into a comprehensive security scanning team. It operates through a 4-phase pipeline that systematically discovers, analyzes, verifies, and reports security vulnerabilities in any codebase.

The system contains no executable code, no binaries, and no external dependencies. It consists entirely of structured Markdown skill files that instruct LLM agents on how to perform security analysis. The LLM's reasoning capabilities replace traditional AST parsing and regex matching, enabling deeper contextual understanding of code.

---

## 4-Phase Pipeline

The scanning pipeline consists of four sequential phases. Each phase builds on the output of the previous one, progressively refining results from broad discovery to actionable, verified findings.

```
┌──────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│   Phase 1: RECON           Phase 2: HUNT           Phase 3: VERIFY      │
│   ┌──────────────┐        ┌──────────────┐        ┌──────────────┐      │
│   │ sc-recon     │───────>│ 40+ skills   │───────>│ sc-verifier  │      │
│   │ sc-dep-audit │        │ (parallel)   │        │              │      │
│   └──────────────┘        └──────────────┘        └──────┬───────┘      │
│                                                          │              │
│                                                          v              │
│                                                   Phase 4: REPORT       │
│                                                   ┌──────────────┐      │
│                                                   │ sc-report    │      │
│                                                   └──────────────┘      │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

### Phase 1: Reconnaissance

**Skills:** `sc-recon`, `sc-dependency-audit`
**Output:** `security-report/architecture.md`, `security-report/dependency-audit.md`

The reconnaissance phase maps the entire codebase before any vulnerability hunting begins. This is critical because the architecture map determines which skills activate in Phase 2.

**sc-recon** produces `architecture.md` containing:

1. **Technology Stack** -- Languages detected, frameworks, build tools, package managers
2. **Application Type** -- Web application, REST API, CLI tool, library, microservice, monolith
3. **Entry Points** -- HTTP routes, CLI commands, message queue consumers, scheduled tasks, WebSocket endpoints
4. **Data Flow Map** -- User input sources, processing pipelines, storage locations, output channels
5. **Trust Boundaries** -- Authentication middleware, rate limiters, input validators, WAF configurations
6. **External Integrations** -- Databases, caches, message queues, third-party API calls
7. **Authentication Architecture** -- Session-based, JWT, OAuth 2.0, API key, mTLS
8. **File Structure Analysis** -- Sensitive file paths, configuration files, environment files, secret stores
9. **Detected Security Controls** -- CSP headers, CORS policies, CSRF tokens, rate limiters
10. **Detected Languages** -- This list directly controls which `sc-lang-*` skills activate in Phase 2
11. **Specialized Surfaces** -- AI/agent, protocol/messaging, and desktop/local IPC boundaries
12. **Coverage Ledger** -- Stable surface × boundary × subsystem × attack-class units with evidence and gaps

**sc-dependency-audit** produces `dependency-audit.md` containing:

1. Lock file analysis (package-lock.json, go.sum, Cargo.lock, composer.lock, etc.)
2. Known CVE matching against dependency versions
3. Supply chain risk indicators (typosquatting detection, maintainer changes, low-download packages)
4. License compliance risks
5. Transitive dependency depth analysis
6. Build-time dependency risks (postinstall scripts, build.rs execution, setup.py code)

### Phase 2: Vulnerability Hunting

**Skills:** 40+ vulnerability skills + 7 language-specific skills (executed in parallel)
**Output:** `security-report/findings/{skill-name}.json` per skill plus coverage-ledger evidence

This is the main scanning phase. All applicable vulnerability skills run in parallel as independent subagents. Each skill executes its own internal two-step process:

1. **Discovery** -- File pattern matching (glob), keyword searching (grep-level), semantic pattern recognition, and data flow tracing to identify candidate code sections
2. **Verification** -- For each candidate, the skill checks exploitability, sanitization, framework protections, and contextual factors to determine if the finding is genuine

**Skill categories activated:**

| Category | Skills |
|----------|--------|
| Injection | sc-sqli, sc-nosqli, sc-graphql, sc-xss, sc-ssti, sc-xxe, sc-ldap, sc-cmdi, sc-header-injection |
| Code Execution | sc-rce, sc-deserialization |
| Access Control | sc-auth, sc-authz, sc-privilege-escalation, sc-session |
| Data Exposure | sc-secrets, sc-data-exposure, sc-crypto |
| Server-Side | sc-ssrf, sc-path-traversal, sc-file-upload, sc-open-redirect |
| Client-Side | sc-csrf, sc-cors, sc-clickjacking, sc-websocket |
| Logic & Design | sc-business-logic, sc-race-condition, sc-mass-assignment |
| API Security | sc-api-security, sc-rate-limiting, sc-jwt |
| Infrastructure | sc-iac, sc-docker, sc-ci-cd |
| Specialized Surfaces | sc-ai-security, sc-protocol-security, sc-local-ipc |
| Language-Specific | sc-lang-go, sc-lang-typescript, sc-lang-python, sc-lang-php, sc-lang-rust, sc-lang-java, sc-lang-csharp |

Language-specific skills only activate when their language is detected in `architecture.md`. For example, `sc-lang-rust` only runs if Rust source files are found during reconnaissance.

Each skill writes candidates to `security-report/findings/{skill-name}.json`. A skill that finds no candidate still records reviewed paths and checks in `coverage-ledger.md`.

### Phase 3: Verification

**Skill:** `sc-verifier`
**Input:** All `findings/*.json` files from Phase 2 plus architecture and coverage artifacts
**Output:** `security-report/findings.json` and `security-report/verified-findings.md`

The verifier reads every finding from Phase 2 and applies six verification criteria:

1. **Reachability Analysis** -- Is this code in an executable path? Dead code, commented-out code, and unreachable branches are deprioritized.
2. **Sanitization Check** -- Is the user input sanitized, validated, or escaped at any point between source and sink?
3. **Framework Protection Check** -- Does the framework automatically mitigate this class of vulnerability? (e.g., Django ORM parameterizes queries by default, React escapes JSX output by default)
4. **Configuration Override Check** -- Is there a configuration-level control (WAF rule, CSP header, CORS policy) that blocks exploitation?
5. **Context Analysis** -- Is this code in a test file, example directory, documentation, or generated code?
6. **Duplicate Detection** -- Findings that share the same root cause are merged into a single entry with all affected locations listed.

After verification, each candidate receives a confidence score and exactly one verdict: `confirmed`, `needs_validation`, or `rejected`. Confidence never substitutes for missing boundary evidence.

### Phase 4: Reporting

**Skill:** `sc-report`
**Input:** `security-report/findings.json`, `verified-findings.md`, and `coverage-ledger.md`
**Output:** `security-report/SECURITY-REPORT.md`

The reporter transforms verified findings into a structured security assessment report:

1. **Executive Summary** -- Project name, scan date, total confirmed findings by severity, overall risk score (0-10)
2. **Scan Statistics** -- Files scanned, lines of code, languages detected, skills executed, finding distribution matrix
3. **Critical Findings** -- Detailed writeup of each critical-severity finding
4. **High Findings** -- Detailed writeup of each high-severity finding
5. **Medium Findings** -- Summary of medium-severity findings
6. **Low Findings** -- Summary of low-severity findings
7. **Hardening and Positive Controls** -- Unscored notes that do not represent demonstrated vulnerabilities
8. **Remediation Roadmap** -- Prioritized fix plan organized into phases:
   - Immediate: Critical findings
   - Short-term: High findings and quick wins
   - Medium-term: Medium findings
   - Hardening: Low findings and general improvements
9. **Methodology** -- Description of the 4-phase pipeline
10. **Disclaimer** -- AI-based analysis caveat

---

## Skill File Structure

Every skill file follows a standardized Markdown format with YAML frontmatter. This structure enables consistent behavior across all AI platforms.

```markdown
---
name: sc-{skill-name}
description: Short description (single line)
---

# SC: {Skill Full Name}

## Purpose
What this skill does and why it exists.

## Activation
When and how the orchestrator calls this skill.

## Phase 1: Discovery
1. File patterns to search (glob patterns)
2. Keywords and patterns to search (grep-level)
3. Semantic patterns to look for (AST-level reasoning)
4. Data flow tracing rules (source-to-sink mapping)

## Phase 2: Verification
1. Exploitability checklist
2. Sanitization and validation check
3. Framework-level protection check
4. Context-aware false positive elimination

## Severity Classification
- Critical: Definition for this vulnerability type
- High: Definition for this vulnerability type
- Medium: Definition for this vulnerability type
- Low: Definition for this vulnerability type

## Language-Specific Notes
Per-language detection and verification guidance.

## Output Format
Standardized finding template (see Output Format section below).

## Common False Positives
Scenarios that look like vulnerabilities but are not.
```

### Language-Specific Skills

Language skills (`sc-lang-*.md`) follow a specialized variant:

```markdown
---
name: sc-lang-{language}
description: {Language}-specific security deep scan
---

# SC: {Language} Security Deep Scan

## Purpose
## Activation
## Checklist Reference
## {Language}-Specific Vulnerability Patterns
### Category 1: {Title}
### Category 2: {Title}
... (15-25 categories)
## Output Format
```

Language skills reference their corresponding checklist file in `references/{language}-security-checklist.md` (relative to the skill folder) and systematically scan for each category defined in that checklist.

---

## Data Flow Between Phases

```
Phase 1 Output                    Phase 2 Input
─────────────────                 ──────────────
architecture.md      ──────────>  All skills read architecture.md to understand:
                                  - Which languages are present
                                  - Where entry points are
                                  - What frameworks are used
                                  - What security controls exist

dependency-audit.md  ──────────>  Skills use dependency info to check:
                                  - Known vulnerable library versions
                                  - Dangerous dependency configurations

Phase 2 Output                    Phase 3 Input
─────────────────                 ──────────────
findings/sc-sqli.json ─┐
findings/sc-xss.json  ─┤
findings/sc-rce.json  ─┼────────> sc-verifier reads ALL candidate files,
findings/sc-auth.json ─┤         challenges claims, merges root causes,
... skill JSON files ──┘         and assigns final verdicts

Phase 3 Output                    Phase 4 Input
─────────────────                 ──────────────
findings.json + ledger ────────>  sc-report reads final verdicts and coverage,
                                  classifies by CVSS severity,
                                  generates final report
```

### Cross-Skill Data Sharing

Skills do not communicate directly with each other during Phase 2. Each skill operates independently and writes its own results file. However, all skills share access to the Phase 1 output files:

- **architecture.md** provides the technology context that every skill uses to tailor its analysis
- **dependency-audit.md** provides dependency version information that skills like sc-deserialization and sc-crypto reference

This shared-nothing architecture during Phase 2 enables parallel execution without coordination overhead.

---

## Output File Structure

After a complete scan, the `security-report/` directory contains:

```
security-report/
├── architecture.md              # Phase 1: Codebase architecture map
├── coverage-ledger.md           # Phase 1-4: Coverage evidence and gaps
├── dependency-audit.md          # Phase 1: Supply chain analysis
├── findings/                    # Phase 2: One candidate JSON file per skill
├── findings.json                # Phase 3: Final structured verdicts
├── verified-findings.md         # Phase 3: Verified and scored findings
├── SECURITY-REPORT.md           # Phase 4: Final consolidated report
└── diff-report.md               # (Diff mode only) Incremental scan report
```

### Candidate File Format

Each Phase 2 candidate file follows a consistent structure:

```json
{
  "skill": "sc-name",
  "reviewed_paths": ["path/to/file.ext"],
  "checks": ["source trace or bounded local check"],
  "candidates": [{
    "id": "SC-NAME-001",
    "attacker": "lower-trust principal and starting capability",
    "affected_principal": "principal or protected resource",
    "source_trace": ["path/to/file.ext:line"],
    "control_analysis": "effective controls and gap",
    "sink": "security-sensitive operation or disclosure",
    "observed_result": "meaningful boundary result",
    "conditions": ["required condition"],
    "proposed_verdict": "confirmed|needs_validation|rejected",
    "confidence": 0
  }]
}
```

### Verified Findings Format

The `verified-findings.md` file adds verification metadata to each finding:

```markdown
### Finding: {SKILL}-001 [VERIFIED]
- **Original Confidence:** 85
- **Verified Confidence:** 92
- **Reachability:** Confirmed (called from route handler)
- **Sanitization:** None detected
- **Framework Protection:** Not applicable
- **Verification Notes:** Input flows directly from request parameter to SQL query
```

---

## Language Detection and Skill Activation

Language detection occurs during Phase 1 (sc-recon) and directly controls which language-specific skills run in Phase 2.

### Detection Method

sc-recon identifies languages by examining:

1. **File extensions** -- `.go`, `.ts`, `.tsx`, `.js`, `.jsx`, `.py`, `.php`, `.rs`, `.java`, `.kt`, `.cs`
2. **Configuration files** -- `go.mod`, `package.json`, `tsconfig.json`, `pyproject.toml`, `requirements.txt`, `composer.json`, `Cargo.toml`, `pom.xml`, `build.gradle`, `*.csproj`
3. **Lock files** -- `go.sum`, `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `Pipfile.lock`, `poetry.lock`, `composer.lock`, `Cargo.lock`
4. **Framework markers** -- `next.config.js`, `django/`, `flask/`, `laravel/`, `spring-boot/`, etc.

### Activation Rules

| Detected Language | Skill Activated | Checklist Referenced |
|-------------------|-----------------|----------------------|
| Go | sc-lang-go | references/go-security-checklist.md |
| TypeScript/JavaScript | sc-lang-typescript | references/typescript-security-checklist.md |
| Python | sc-lang-python | references/python-security-checklist.md |
| PHP | sc-lang-php | references/php-security-checklist.md |
| Rust | sc-lang-rust | references/rust-security-checklist.md |
| Java/Kotlin | sc-lang-java | references/java-security-checklist.md |
| C#/.NET | sc-lang-csharp | references/csharp-security-checklist.md |

Multiple language skills can activate simultaneously for polyglot projects. A project containing both Python and TypeScript will trigger both `sc-lang-python` and `sc-lang-typescript`.

### Infrastructure Skill Activation

Infrastructure skills activate based on file presence rather than language detection:

| File/Pattern | Skill Activated |
|-------------|-----------------|
| `Dockerfile`, `docker-compose.yml` | sc-docker |
| `*.tf`, `*.tfvars` | sc-iac |
| `k8s/`, `*.yaml` (with K8s schemas) | sc-iac |
| `.github/workflows/`, `.gitlab-ci.yml` | sc-ci-cd |

---

## Parallel Execution Model

Phase 2 uses parallel execution to maximize scanning throughput. The orchestrator (`sc-orchestrator` or the `CLAUDE.md`/`AGENTS.md` orchestration file) launches all applicable skills simultaneously.

### Execution Strategy

```
Orchestrator
    │
    ├──> sc-sqli           (parallel)
    ├──> sc-xss            (parallel)
    ├──> sc-rce            (parallel)
    ├──> sc-auth           (parallel)
    ├──> sc-secrets        (parallel)
    ├──> sc-lang-python    (parallel, if Python detected)
    ├──> sc-lang-go        (parallel, if Go detected)
    ├──> sc-docker         (parallel, if Dockerfile present)
    └──> ... all other applicable skills
    │
    ▼ (barrier: wait for all skills to complete)
    │
    sc-verifier (sequential — needs all results)
    │
    ▼
    sc-report (sequential — needs verified findings)
```

### Parallelism Constraints

- All Phase 2 skills run independently with no inter-skill communication
- Each skill reads only from Phase 1 outputs (architecture.md, dependency-audit.md) and source code
- Each skill writes only to its own results file
- Phase 3 (verification) cannot begin until all Phase 2 skills complete
- Phase 4 (reporting) cannot begin until Phase 3 completes

### Platform-Specific Parallel Execution

Different AI platforms handle parallelism differently:

- **Claude Code** -- Uses subagent spawning with the `Task` tool to run skills in parallel
- **Codex** -- Executes skills sequentially within a single context (parallelism is logical, not physical)
- **Cursor** -- Depends on agent mode; may execute sequentially
- **Gemini CLI** -- Executes skills sequentially within context

The skill files are written to work correctly regardless of whether execution is truly parallel or sequential. Each skill is self-contained and does not depend on timing or ordering relative to other Phase 2 skills.

---

## Confidence Scoring System

Every finding receives a confidence score from 0 to 100, assigned in two stages.

### Stage 1: Skill-Level Confidence (Phase 2)

During Phase 2, each skill assigns an initial confidence score based on:

| Factor | Score Impact |
|--------|-------------|
| Direct user input reaches dangerous sink without sanitization | +40 |
| Known-dangerous function/pattern detected | +20 |
| Data flow traced from source to sink | +20 |
| No framework protection detected | +10 |
| Multiple corroborating indicators | +10 |
| Input is sanitized but incompletely | -10 |
| Code is in test/example directory | -30 |
| Pattern matches but context is ambiguous | -20 |

### Stage 2: Verifier-Level Confidence (Phase 3)

The verifier adjusts the initial score based on cross-skill analysis:

| Verification Result | Adjustment |
|--------------------|------------|
| Reachability confirmed (called from entry point) | +5 to +15 |
| Reachability unconfirmed (no caller found) | -20 to -30 |
| Sanitization found between source and sink | -30 to -50 |
| Framework auto-protection active | -20 to -40 |
| Configuration-level mitigation present | -15 to -25 |
| Code is in test/mock/example context | -40 |
| Multiple skills flagged the same code path | +10 to +20 |
| Finding corroborated by dependency audit | +10 |

### Confidence Tiers

| Score Range | Classification | Meaning |
|-------------|---------------|---------|
| 90-100 | Very High | Strong evidence; still subject to the verdict gate |
| 70-89 | High Probability | Very likely a real vulnerability; may require specific conditions |
| 50-69 | Probable | Likely a vulnerability but needs manual verification |
| 30-49 | Possible | May be a real issue; significant chance of false positive |
| 0-29 | Low Confidence | Reject or retain as an unscored validation lead |

Confidence prioritizes review. It cannot promote an incomplete candidate or replace the required trust-boundary evidence.

---

## CVSS v3.1-Style Severity Classification

security-check uses a severity classification system inspired by CVSS v3.1 but adapted for static analysis context (no network-level metrics).

### Severity Levels

| Severity | CVSS Score Range | Color | Criteria |
|----------|-----------------|-------|----------|
| Critical | 9.0 - 10.0 | Red | Remote code execution, authentication bypass, SQL injection with data exfiltration, hardcoded production credentials |
| High | 7.0 - 8.9 | Orange | Stored XSS, SSRF to internal services, privilege escalation, insecure deserialization, path traversal to sensitive files |
| Medium | 4.0 - 6.9 | Yellow | Reflected XSS, CSRF, information disclosure, missing security headers, weak cryptography |
| Low | 0.1 - 3.9 | Blue | Verbose error messages, missing rate limiting on non-sensitive endpoints, minor configuration issues |

Observations and defense-in-depth recommendations are unscored hardening notes, not vulnerability severities.

### Severity Assignment Factors

Each skill defines its own severity criteria based on the specific vulnerability type. The general factors considered are:

1. **Exploitability** -- How easy is it to exploit? (Remote/unauthenticated = higher severity)
2. **Impact** -- What is the worst-case outcome? (RCE/data breach = Critical, information leak = Medium)
3. **Scope** -- Does exploitation affect other components? (Scope change = higher severity)
4. **Required Conditions** -- Does exploitation require special conditions? (None = higher severity)
5. **Existing Mitigations** -- Are there partial mitigations that reduce impact?

### Per-Skill Severity Definitions

Each skill file contains its own "Severity Classification" section that defines what Critical, High, Medium, and Low mean for that specific vulnerability type. For example:

**sc-sqli severity definitions:**
- Critical: SQL injection with data exfiltration or modification capability (UNION-based, stacked queries)
- High: Blind SQL injection (boolean-based or time-based) with confirmed data access
- Medium: SQL injection in authenticated-only endpoint with limited data scope
- Low: Potential SQL injection where parameterized queries are partially used but inconsistently

**sc-xss severity definitions:**
- Critical: Stored XSS in user-generated content visible to all users
- High: Reflected XSS in a widely-accessed endpoint with session cookie access
- Medium: DOM-based XSS requiring specific user interaction
- Low: XSS in an admin-only panel with existing CSP restrictions

---

## Diff Mode Architecture

Diff mode enables incremental scanning of only changed files, designed for PR-level security reviews.

### Activation

Diff mode activates when the user says "scan diff", "scan changes", or "PR scan".

### Workflow

1. Run `git diff --name-only` (or `git diff --name-only HEAD~1`) to identify changed files
2. Run sc-recon on changed files only (produces a partial architecture.md)
3. Determine which skills are relevant based on the changed file types
4. Run only the relevant subset of Phase 2 skills, scoping them to changed files
5. Run sc-verifier on the reduced set of findings
6. Produce `security-report/diff-report.md` using `sc-diff-report` skill

### Diff Report Structure

The diff report is a condensed version of the full report, optimized for PR review:

```markdown
# Security Diff Report

## Changed Files Analyzed
- file1.py (modified)
- file2.ts (added)
- file3.go (modified)

## New Vulnerabilities Introduced
Findings that exist in changed code but not in the base branch.

## Vulnerabilities Fixed
Findings that existed before but are resolved by the changes.

## Summary
Quick assessment of whether the PR improves or degrades security posture.
```

---

## Directory Layout Reference

```
project-root/
├── .claude/
│   └── skills/                  # Claude Code skill files (installed by skills.sh)
│       ├── sc-orchestrator/
│       │   └── SKILL.md         # Master orchestrator
│       ├── sc-recon/
│       │   └── SKILL.md         # Phase 1: Reconnaissance
│       ├── sc-sqli/
│       │   └── SKILL.md         # Phase 2: Vulnerability skills (40+)
│       ├── sc-lang-python/
│       │   ├── SKILL.md         # Phase 2: Language skills (7)
│       │   └── references/
│       │       └── python-security-checklist.md
│       ├── ...
│       ├── sc-verifier/
│       │   └── SKILL.md         # Phase 3: Verification
│       └── sc-report/
│           └── SKILL.md         # Phase 4: Reporting
│
├── .agents/
│   └── skills/                  # Mirror for other platforms (Codex, Cursor, etc.)
│       └── (identical structure)
│
├── security-report/             # Generated output (created during scan)
│   ├── architecture.md
│   ├── dependency-audit.md
│   ├── findings/
│   │   ├── sc-sqli.json
│   │   └── ...
│   ├── verified-findings.md
│   ├── SECURITY-REPORT.md
│   └── diff-report.md
│
├── CLAUDE.md                    # Claude Code orchestration entry point
└── AGENTS.md                    # Codex/Cursor/Opencode/Windsurf/Gemini orchestration
```

---

## Design Decisions

### Why Markdown Skills Instead of Code?

1. **Universal compatibility** -- Every AI coding assistant can read Markdown. No runtime, no compilation, no dependency installation.
2. **Transparent logic** -- Users can read and understand exactly what each skill does. No black-box analysis.
3. **Easy extensibility** -- Adding a new vulnerability check means writing a Markdown file, not learning an API or plugin system.
4. **LLM-native** -- The skills are instructions for an LLM, written in the format LLMs understand best: structured natural language.

### Why Separate Phases Instead of a Single Pass?

1. **Reconnaissance first** -- Understanding the architecture before scanning prevents wasted work (e.g., running PHP skills on a Go project).
2. **Independent verification** -- Separating detection from verification reduces confirmation bias. The verifier can objectively assess findings without the detection skill's assumptions.
3. **Structured output** -- Each phase produces a well-defined artifact, making the process auditable and debuggable.

### Why Per-Skill Result Files?

1. **Parallel safety** -- No write conflicts when skills run simultaneously.
2. **Incremental debugging** -- If one skill produces bad results, only that file needs inspection.
3. **Selective re-scanning** -- A single skill can be re-run without repeating the entire pipeline.

### Why 400+ Item Checklists?

Language-specific checklists provide exhaustive coverage that complements the vulnerability-class skills. While `sc-sqli` knows how to find SQL injection in any language, `sc-lang-python` knows about Python-specific patterns like Django ORM raw queries, SQLAlchemy text() calls, and f-string SQL construction that require language-idiomatic knowledge.

---

## Security of security-check Itself

security-check contains no executable code. The skill files are passive Markdown documents that instruct the AI assistant. They cannot:

- Execute arbitrary code on the host machine
- Access the network
- Modify files outside the `security-report/` directory
- Exfiltrate data

The AI assistant's existing sandboxing and permission model applies to all operations. security-check operates entirely within the assistant's normal capabilities and constraints.
