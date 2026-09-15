---
name: security-check
description: >
  Comprehensive AI-powered security scanning suite with 51 skills covering OWASP Top 10,
  7 language-specific deep scanners (Go, TypeScript, Python, PHP, Rust, Java, C#),
  supply chain analysis, infrastructure-as-code scanning, and 3000+ checklist items.
  Use when you need to run a security audit, find vulnerabilities, scan a PR for security issues,
  or perform an authorized penetration test on a codebase. Full audits use evidence-led
  coverage tracking and independent candidate verification. In Claude Code, invoke it directly
  as /security-check to open the native audit setup menu.
license: MIT
compatibility: Works with Claude Code, Cursor, Codex, Gemini CLI, OpenCode, Windsurf, Roo Code, Amp, and all agentskills.io compatible agents
metadata:
  author: ersinkoc
  organization: ECOSTACK TECHNOLOGY OU
  category: security
  version: "1.2.0"
  homepage: https://github.com/ersinkoc/security-check
  keywords: security vulnerability-scanning owasp sast code-review
---

# security-check

> Your AI Becomes a Security Team. Every Language. Every Layer. Zero Tools.

## What This Skill Does

security-check transforms your AI coding assistant into a comprehensive security scanning team.
It runs a 4-phase pipeline — **Recon → Hunt → Verify → Report** — entirely through natural language.
No binaries, no dependencies, no CI pipeline changes.

## Quick Start

After installation, open your AI assistant and say:

- **"run security check"** — Full security audit
- **"scan diff"** — PR/diff-level incremental scan
- **"scan for vulnerabilities"** — Same as full scan

In Claude Code, invoke **`/security-check`** from the `/` menu. For a full audit,
open the interactive setup before creating report files or launching workers.

For a full audit, load the detailed orchestrator before acting. Resolve it in this
order so both installation layouts work:

1. `skills/sc-orchestrator/SKILL.md` relative to this launcher when installed as a bundle.
2. `../sc-orchestrator/SKILL.md` when shell/manual installation placed skills as siblings.

Then load only the reconnaissance, hunting, verification, reporting, language, and
specialized skill files selected by that orchestrator. The launcher owns interactive
setup; do not ask the same setup questions again in the orchestrator.

## Interactive Audit Setup

Respect choices already stated in the user's request. Ask only for unresolved setup
values. When the host provides a structured question tool, use one grouped menu call;
in Claude Code, use `AskUserQuestion`. Do not print a fake numbered menu when the tool
is available.

Offer these choices:

1. **Profile**
   - `Standard (Recommended)` — full evidence-led audit with one coverage-critic pass.
   - `Quick` — bounded first pass; always report partial coverage.
   - `Deep` — finer subsystem/lifecycle coverage and repeated critic passes.
2. **Scope**
   - `Whole repository (Recommended)` — audit all source-visible surfaces.
   - `Changed files` — switch to `sc-diff-report` and preserve diff-mode limitations.
   - `Custom paths` — request the paths in one short follow-up.
3. **Validation**
   - `Source only (Recommended)` — read-only analysis; external facts become `needs_validation`.
   - `Sandboxed local checks` — run only when every safe-execution control is available.
4. **Previous report**, only when one exists
   - `Continue and revalidate (Recommended)` — reuse compatible evidence and recheck changed source.
   - `Archive and start new` — preserve the old directory under a dated unique name.
   - `Replace` — proceed only when this explicit selection authorizes replacement.

If the host has no structured question tool, infer non-destructive defaults: `standard`,
whole repository, source-only validation, and continue/revalidate prior evidence. Ask a
plain question only when a missing custom path or destructive choice blocks progress.
Record the resolved choices in scan state and echo a one-line summary before Phase 1.
Menu selection never authorizes live probing, external side effects, credential use,
dependency installation, publication, or shared-infrastructure mutation.

## What's Included

### 51 Security Skills

| Category | Count | Skills |
|----------|-------|--------|
| Core Pipeline | 6 | Orchestrator, Recon, Dependency Audit, Verifier, Report, Diff Report |
| Injection | 9 | SQLi, NoSQLi, GraphQL, XSS, SSTI, XXE, LDAP, CMDi, Header Injection |
| Code Execution | 2 | RCE, Deserialization |
| Access Control | 4 | Auth, AuthZ, Privilege Escalation, Session |
| Data Exposure | 3 | Secrets, Data Exposure, Crypto |
| Server-Side | 4 | SSRF, Path Traversal, File Upload, Open Redirect |
| Client-Side | 4 | CSRF, CORS, Clickjacking, WebSocket |
| Logic & Design | 3 | Business Logic, Race Conditions, Mass Assignment |
| API Security | 3 | API Security, Rate Limiting, JWT |
| Infrastructure | 3 | IaC, Docker, CI/CD |
| Language Scanners | 7 | Go, TypeScript, Python, PHP, Rust, Java, C# |
| Specialized Surfaces | 3 | AI & Agents, Protocols & Messaging, Desktop & Local IPC |

### 10 Security Checklists (3000+ items)

Each language scanner includes a 400+ item checklist with specific CWE references.

### 4-Phase Pipeline

```
Phase 1: RECON        → Architecture mapping, tech stack detection
Phase 2: HUNT         → 40+ vulnerability skills run in parallel
Phase 3: VERIFY       → False positive elimination, confidence scoring
Phase 4: REPORT       → CVSS severity, remediation roadmap
```

Every full audit also maintains a coverage ledger. A suspicious pattern is only a
candidate until a separate verification pass establishes a real trust-boundary failure
and meaningful impact. Unresolved runtime or deployment facts are reported as
`needs_validation` without severity; missing defense in depth is a hardening note.

Read [docs/EVIDENCE_MODEL.md](docs/EVIDENCE_MODEL.md) for the shared evidence,
coverage, safe-validation, and reporting contract.

## Output

After scanning, a `security-report/` directory is created containing:

- `SECURITY-REPORT.md` — Final consolidated report
- `architecture.md` — Codebase architecture map
- `dependency-audit.md` — Supply chain analysis
- `verified-findings.md` — Findings after false positive elimination
- `coverage-ledger.md` — Covered, candidate, blocked, deferred, and excluded audit units
- `findings.json` — Final `confirmed`, `needs_validation`, and `rejected` records

## More Information

- [Full documentation](https://github.com/ersinkoc/security-check)
- [Agent Skills Standard](https://agentskills.io)
- [skills.sh](https://skills.sh/ersinkoc/security-check)
