# security-check

> Your AI Becomes a Security Team. Every Language. Every Layer. Zero Tools.

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/ersinkoc/security-check)](https://github.com/ersinkoc/security-check/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/ersinkoc/security-check)](https://github.com/ersinkoc/security-check/network/members)
[![Platforms](https://img.shields.io/badge/platforms-Claude%20Code%20%7C%20Codex%20%7C%20Cursor%20%7C%20Opencode%20%7C%20Windsurf%20%7C%20Gemini%20CLI-green)]()

## What is security-check?

security-check is a collection of agent skills that transforms your LLM-based AI coding assistant into a comprehensive security scanning team. It works entirely through natural language prompts — no binaries, no dependencies, no CI pipeline changes. Just install the skills into your project and tell your AI to "run security check."

It is **not** a traditional SAST tool. It does not parse ASTs or run regex rules. Instead, it leverages the reasoning capabilities of large language models to understand code context, trace data flows, and identify vulnerabilities that pattern-matching tools miss.

## Why Not Traditional SAST?

Traditional static analysis tools rely on hardcoded rules and pattern matching. They produce mountains of false positives, struggle with framework-specific patterns, and cannot reason about business logic. security-check takes a fundamentally different approach: it uses LLM reasoning to understand what your code actually does, trace data from source to sink across function boundaries, and evaluate whether framework-level protections are in place. The result is fewer false positives, deeper analysis, and vulnerability detection that adapts to any codebase without configuration.

## Features

- **40+ vulnerability detection skills** covering OWASP Top 10 and beyond
- **7 language-specific deep security scanners** (Go, TypeScript, Python, PHP, Rust, Java, C#)
- **400+ item security checklists** per language for exhaustive coverage
- **4-phase pipeline:** Recon → Hunt → Verify → Report
- **Confidence scoring** (0-100) with CVSS v3.1-style severity ratings
- **Supply chain & dependency analysis** — not just source code
- **Infrastructure-as-Code scanning** — Dockerfile, Kubernetes, Terraform, GitHub Actions
- **Diff mode** for PR-level incremental scans
- **Zero external tools required** — runs entirely within your AI assistant
- **Multi-platform support** — Claude Code, Codex, Cursor, Opencode, Windsurf, Gemini CLI

## Quick Start

### Option 1: Automated Installation

**macOS / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/ersinkoc/security-check/main/install.sh | bash
```

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/ersinkoc/security-check/main/install.ps1 | iex
```

### Option 2: Manual Installation

**macOS / Linux:**
```bash
git clone https://github.com/ersinkoc/security-check.git
cp -r security-check/scan-target/* /path/to/your/project/
cp -r security-check/scan-target/.claude /path/to/your/project/
cp -r security-check/scan-target/.agents /path/to/your/project/
cp -r security-check/checklists /path/to/your/project/
```

**Windows (PowerShell):**
```powershell
git clone https://github.com/ersinkoc/security-check.git
Copy-Item -Recurse security-check\scan-target\* \path\to\your\project\
Copy-Item -Recurse security-check\scan-target\.claude \path\to\your\project\
Copy-Item -Recurse security-check\scan-target\.agents \path\to\your\project\
Copy-Item -Recurse security-check\checklists \path\to\your\project\
```

### Option 3: Direct Copy

1. Copy the `scan-target/` contents into your project root
2. Copy the `checklists/` folder into your project root
3. Open your AI assistant and say: **"run security check"**

## Supported Vulnerability Classes

| Category | Skills | Detects |
|----------|--------|---------|
| **Injection** | sc-sqli, sc-nosqli, sc-graphql, sc-xss, sc-ssti, sc-xxe, sc-ldap, sc-cmdi, sc-header-injection | SQL/NoSQL/GraphQL injection, XSS (reflected/stored/DOM), template injection, XXE, LDAP injection, OS command injection, HTTP header injection |
| **Code Execution** | sc-rce, sc-deserialization | Remote code execution via eval/exec, insecure deserialization (all formats) |
| **Access Control** | sc-auth, sc-authz, sc-privilege-escalation, sc-session | Broken authentication, IDOR, broken access control, privilege escalation, session fixation/hijacking |
| **Data Exposure** | sc-secrets, sc-data-exposure, sc-crypto | Hardcoded secrets/keys/tokens, PII leaks, verbose errors, weak cryptography, ECB mode, IV reuse |
| **Server-Side** | sc-ssrf, sc-path-traversal, sc-file-upload, sc-open-redirect | SSRF, directory traversal, LFI/RFI, unrestricted file upload, open redirects |
| **Client-Side** | sc-csrf, sc-cors, sc-clickjacking, sc-websocket | CSRF, CORS misconfiguration, clickjacking, WebSocket hijacking |
| **Logic & Design** | sc-business-logic, sc-race-condition, sc-mass-assignment | Business logic flaws, TOCTOU, race conditions, mass assignment |
| **API Security** | sc-api-security, sc-rate-limiting, sc-jwt | REST/GraphQL/gRPC security, missing rate limiting, JWT flaws (alg:none, weak secrets) |
| **Infrastructure** | sc-iac, sc-docker, sc-ci-cd | IaC misconfigurations, Docker security, CI/CD pipeline vulnerabilities |

## Language-Specific Security Scanners

Each language scanner uses a dedicated 400+ item checklist and detects language-idiomatic vulnerabilities that generic skills cannot catch.

| Language | Skill | Key Focus Areas |
|----------|-------|----------------|
| **Go** | sc-lang-go | unsafe package, goroutine leaks, race conditions, crypto/rand misuse, template XSS |
| **TypeScript/JS** | sc-lang-typescript | Prototype pollution, eval injection, DOM XSS, npm supply chain, Next.js-specific flaws |
| **Python** | sc-lang-python | pickle RCE, SSTI, subprocess injection, Django/Flask/FastAPI-specific patterns |
| **PHP** | sc-lang-php | unserialize gadgets, phar deserialization, type juggling, Laravel/WordPress patterns |
| **Rust** | sc-lang-rust | unsafe blocks, FFI validation, integer overflow, Send/Sync misuse, serde bombs |
| **Java/Kotlin** | sc-lang-java | Java deserialization, JNDI injection, Spring SpEL, HQL injection, XML XXE |
| **C#/.NET** | sc-lang-csharp | BinaryFormatter RCE, model binding abuse, EF raw SQL, Blazor JS interop, SignalR bypass |

## Security Checklists

The `checklists/` directory contains exhaustive security checklists for each supported language:

| Checklist | Items | Description |
|-----------|-------|-------------|
| `go-security-checklist.md` | 400+ | Go-specific security patterns including concurrency, crypto, and module supply chain |
| `typescript-security-checklist.md` | 400+ | TypeScript/JavaScript covering Node.js, React, Next.js, and npm ecosystem |
| `python-security-checklist.md` | 400+ | Python covering Django, Flask, FastAPI, and Python packaging |
| `php-security-checklist.md` | 400+ | PHP covering Laravel, WordPress, Composer, and PHP 8.x features |
| `rust-security-checklist.md` | 400+ | Rust covering unsafe code, FFI, async, and cargo supply chain |
| `java-security-checklist.md` | 400+ | Java/Kotlin covering Spring Boot, Hibernate, and Gradle/Maven |
| `csharp-security-checklist.md` | 400+ | C#/.NET covering ASP.NET, Entity Framework, Blazor, and NuGet |
| `api-security-checklist.md` | 200+ | REST, GraphQL, and gRPC API security patterns |
| `docker-security-checklist.md` | 150+ | Docker and container security best practices |
| `cicd-security-checklist.md` | 150+ | CI/CD pipeline security for GitHub Actions, GitLab CI, etc. |

## How It Works

```
┌─────────────────────────────────────────────────────────────────────┐
│                        SECURITY-CHECK PIPELINE                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  PHASE 1: RECONNAISSANCE                                           │
│  ┌─────────────┐  ┌──────────────────┐                             │
│  │  sc-recon    │  │ sc-dependency-   │                             │
│  │             │  │ audit            │                              │
│  │ • Languages │  │ • Lock files     │                             │
│  │ • Framework │  │ • CVE database   │                             │
│  │ • Endpoints │  │ • Supply chain   │                             │
│  │ • Data flow │  │ • License risks  │                             │
│  └──────┬──────┘  └────────┬─────────┘                             │
│         │                  │                                        │
│         └────────┬─────────┘                                        │
│                  ▼                                                   │
│  PHASE 2: VULNERABILITY HUNTING (parallel)                         │
│  ┌────────┐┌────────┐┌────────┐┌────────┐┌──────────┐             │
│  │sc-sqli ││sc-xss  ││sc-rce  ││sc-auth ││sc-lang-* │ ...40+     │
│  │        ││        ││        ││        ││          │  skills     │
│  └───┬────┘└───┬────┘└───┬────┘└───┬────┘└────┬─────┘             │
│      │         │         │         │          │                     │
│      └────┬────┴────┬────┴────┬────┴────┬─────┘                    │
│           ▼         ▼         ▼         ▼                           │
│  PHASE 3: VERIFICATION                                             │
│  ┌─────────────────────────────────────────────┐                   │
│  │              sc-verifier                     │                   │
│  │  • Reachability analysis                    │                   │
│  │  • Sanitization check                       │                   │
│  │  • Framework protection check               │                   │
│  │  • False positive elimination               │                   │
│  │  • Confidence scoring (0-100)               │                   │
│  │  • Duplicate merging                        │                   │
│  └──────────────────┬──────────────────────────┘                   │
│                     ▼                                               │
│  PHASE 4: REPORTING                                                │
│  ┌─────────────────────────────────────────────┐                   │
│  │              sc-report                       │                   │
│  │  • Executive summary                        │                   │
│  │  • CVSS severity classification             │                   │
│  │  • Finding details + remediation            │                   │
│  │  • Remediation roadmap                      │                   │
│  └─────────────────────────────────────────────┘                   │
│                                                                     │
│  OUTPUT: security-report/SECURITY-REPORT.md                        │
└─────────────────────────────────────────────────────────────────────┘
```

## Output

After a scan completes, the `security-report/` directory contains:

| File | Description |
|------|-------------|
| `architecture.md` | Codebase architecture map from reconnaissance phase |
| `dependency-audit.md` | Supply chain and dependency analysis results |
| `*-results.md` | Raw findings from each vulnerability skill |
| `verified-findings.md` | Findings after false positive elimination and confidence scoring |
| `SECURITY-REPORT.md` | Final consolidated security assessment report |

## Diff Mode (PR Scanning)

For incremental scanning of only changed files:

```
"scan diff"
"scan changes"
"PR scan"
```

This uses `git diff` to identify changed files and runs targeted scans against only those files, producing a `security-report/diff-report.md`.

## Adding Custom Skills

Use the templates in the `templates/` directory to create new skills:

1. **New vulnerability skill:** Copy `templates/SKILL_TEMPLATE.md`
2. **New language skill:** Copy `templates/LANG_SKILL_TEMPLATE.md` and create a matching checklist from `templates/CHECKLIST_TEMPLATE.md`

See `docs/SKILL_DEVELOPMENT_GUIDE.md` for detailed instructions.

## Supported Platforms

| Platform | Setup | Skills Location |
|----------|-------|----------------|
| **Claude Code** | Copy `CLAUDE.md` + `.claude/skills/` | `.claude/skills/` |
| **Codex** | Copy `AGENTS.md` + `.agents/skills/` | `.agents/skills/` |
| **Cursor** | Copy `AGENTS.md` + `.agents/skills/` | `.agents/skills/` |
| **Opencode** | Copy `AGENTS.md` + `.agents/skills/` | `.agents/skills/` |
| **Windsurf** | Copy `AGENTS.md` + `.agents/skills/` | `.agents/skills/` |
| **Gemini CLI** | Copy `AGENTS.md` + `.agents/skills/` | `.agents/skills/` |

See `docs/SUPPORTED_PLATFORMS.md` for detailed setup instructions per platform.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on adding new skills, languages, and checklists.

## License

MIT License — see [LICENSE](LICENSE) for details.

## Author

**Ersin Koc** — [ECOSTACK TECHNOLOGY OU](https://ecostack.ee) — ecostack.ee
