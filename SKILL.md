---
name: security-check
description: >
  Comprehensive AI-powered security scanning suite with 48 skills covering OWASP Top 10,
  7 language-specific deep scanners (Go, TypeScript, Python, PHP, Rust, Java, C#),
  supply chain analysis, infrastructure-as-code scanning, and 3000+ checklist items.
  Use when you need to run a security audit, find vulnerabilities, scan a PR for security issues,
  or perform a penetration test on a codebase.
license: MIT
compatibility: Works with Claude Code, Cursor, Codex, Gemini CLI, OpenCode, Windsurf, and all agentskills.io compatible agents
metadata:
  author: ersinkoc
  organization: ECOSTACK TECHNOLOGY OU
  category: security
  version: "1.0.0"
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

## What's Included

### 48 Security Skills

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

### 10 Security Checklists (3000+ items)

Each language scanner includes a 400+ item checklist with specific CWE references.

### 4-Phase Pipeline

```
Phase 1: RECON        → Architecture mapping, tech stack detection
Phase 2: HUNT         → 40+ vulnerability skills run in parallel
Phase 3: VERIFY       → False positive elimination, confidence scoring
Phase 4: REPORT       → CVSS severity, remediation roadmap
```

## Output

After scanning, a `security-report/` directory is created containing:

- `SECURITY-REPORT.md` — Final consolidated report
- `architecture.md` — Codebase architecture map
- `dependency-audit.md` — Supply chain analysis
- `verified-findings.md` — Findings after false positive elimination

## More Information

- [Full documentation](https://github.com/ersinkoc/security-check)
- [Agent Skills Standard](https://agentskills.io)
- [skills.sh](https://skills.sh/ersinkoc/security-check)
