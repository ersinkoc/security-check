# security-check

> Your AI Becomes a Security Team. Every Language. Every Layer. Zero Tools.

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/ersinkoc/security-check)](https://github.com/ersinkoc/security-check/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/ersinkoc/security-check)](https://github.com/ersinkoc/security-check/network/members)
[![Agent Skills](https://img.shields.io/badge/agentskills.io-compatible-blue)](https://agentskills.io)
[![skills.sh](https://img.shields.io/badge/skills.sh-install-orange)](https://skills.sh/ersinkoc/security-check)

## Install

```bash
npx skills add ersinkoc/security-check
```

That's it. Open your AI assistant and say **"run security check"**.


---

## ⚡ Sponsored by WrongStack

<div align="center">

### _Built on the wrong stack. Shipped anyway._

**[WrongStack](https://wrongstack.com)** is a terminal-native AI coding agent that reads your code, edits files, runs commands, and reasons through bugs — across a plain REPL, a full-screen TUI, and a browser UI. You keep your hand on every permission.

[![Website](https://img.shields.io/badge/%F0%9F%8C%90_Website-wrongstack.com-6E56CF?style=for-the-badge)](https://wrongstack.com)
&nbsp;
[![GitHub](https://img.shields.io/badge/GitHub-wrongstack%2Fwrongstack-181717?style=for-the-badge&logo=github)](https://github.com/wrongstack/wrongstack)

</div>

| | What you get |
|---|---|
| 🧠 **~110 LLM providers** | Anthropic, OpenAI, Google, and any OpenAI-compatible endpoint |
| 🛠️ **36 built-in tools** | Read, edit, search, test, and run shell — every call gated by per-tool permissions |
| 🖥️ **3 surfaces** | Plain readline REPL · Ink/React TUI (`--tui`) · standalone web UI |
| 🤖 **Fleet orchestration** | A **Director** coordinates subagents; `eternal` & `parallel` autonomous loops |
| 📋 **Spec-Driven Development** | Hand it a `PROMPT.md` and let it build the whole project, single-shot |
| 🔐 **Secure by default** | AES-256-GCM secret storage, per-tool policies, opt-in YOLO mode |

> **🧩 The perfect pairing:** Plan with **Project Architect**, then hand the generated `PROMPT.md` to **WrongStack** for spec-driven, single-shot execution. Architect the *what* and the *how* — WrongStack ships it.

<div align="center">

🔗 **[wrongstack.com](https://wrongstack.com)** &nbsp;·&nbsp; **[github.com/wrongstack/wrongstack](https://github.com/wrongstack/wrongstack)**

</div>

---

### Alternative Installation

<details>
<summary>Shell script (macOS/Linux)</summary>

```bash
curl -fsSL https://raw.githubusercontent.com/ersinkoc/security-check/main/skills.sh | bash
```

With options:
```bash
# Install only specific categories
curl -fsSL https://raw.githubusercontent.com/ersinkoc/security-check/main/skills.sh | bash -s -- --category injection server

# Install only specific languages
curl -fsSL https://raw.githubusercontent.com/ersinkoc/security-check/main/skills.sh | bash -s -- --lang go typescript python

# List all available categories
curl -fsSL https://raw.githubusercontent.com/ersinkoc/security-check/main/skills.sh | bash -s -- --list
```
</details>

<details>
<summary>PowerShell (Windows)</summary>

```powershell
irm https://raw.githubusercontent.com/ersinkoc/security-check/main/skills.ps1 | iex
```
</details>

<details>
<summary>Manual installation</summary>

```bash
git clone https://github.com/ersinkoc/security-check.git
cp security-check/scan-target/CLAUDE.md /path/to/your/project/
mkdir -p /path/to/your/project/.claude/skills
cp -r security-check/skills/sc-* /path/to/your/project/.claude/skills/
```
</details>

## What is security-check?

A collection of **51 agent skills** following the [agentskills.io](https://agentskills.io) standard that transforms your AI coding assistant into a comprehensive security scanning team. No binaries, no dependencies, no CI pipeline changes — just natural language prompts.

It is **not** a traditional SAST tool. It uses LLM reasoning to understand code context, trace data flows across function boundaries, and evaluate framework-level protections. The result: fewer false positives and deeper analysis than pattern-matching tools.

## Supported Platforms

| Platform | Install via skills.sh | Manual |
|----------|----------------------|--------|
| **Claude Code** | `npx skills add ersinkoc/security-check` | Copy `.claude/skills/` + `CLAUDE.md` |
| **Cursor** | `npx skills add ersinkoc/security-check` | Copy `.agents/skills/` + `AGENTS.md` |
| **Codex** | `npx skills add ersinkoc/security-check` | Copy `.agents/skills/` + `AGENTS.md` |
| **Gemini CLI** | `npx skills add ersinkoc/security-check` | Copy `.agents/skills/` + `AGENTS.md` |
| **OpenCode** | `npx skills add ersinkoc/security-check` | Copy `.agents/skills/` + `AGENTS.md` |
| **Windsurf** | `npx skills add ersinkoc/security-check` | Copy `.agents/skills/` + `AGENTS.md` |
| **Roo Code** | `npx skills add ersinkoc/security-check` | Copy `.agents/skills/` + `AGENTS.md` |
| **Amp** | `npx skills add ersinkoc/security-check` | Copy `.agents/skills/` + `AGENTS.md` |

See [docs/SUPPORTED_PLATFORMS.md](docs/SUPPORTED_PLATFORMS.md) for detailed platform-specific setup.

## Usage

After installation, tell your AI assistant:

| Command | What it does |
|---------|-------------|
| **"run security check"** | Full 4-phase security audit |
| **"scan diff"** or **"PR scan"** | Scan only changed files |
| **"scan for vulnerabilities"** | Full scan (alias) |
| **"check changes for security"** | Diff mode (alias) |

## 51 Skills Included

### Skill Structure (agentskills.io format)

Each skill follows the [Agent Skills specification](https://agentskills.io/specification):

```
sc-sqli/
├── SKILL.md          # Metadata + detection instructions
└── references/       # Checklists (for language skills)
```

### By Category

| Category | Skills | What it detects |
|----------|--------|----------------|
| **Core Pipeline** | sc-orchestrator, sc-recon, sc-dependency-audit, sc-verifier, sc-report, sc-diff-report | Pipeline orchestration, architecture mapping, supply chain, verification, reporting |
| **Injection** (9) | sc-sqli, sc-nosqli, sc-graphql, sc-xss, sc-ssti, sc-xxe, sc-ldap, sc-cmdi, sc-header-injection | SQL/NoSQL/GraphQL injection, XSS, SSTI, XXE, LDAP, command injection, CRLF |
| **Code Execution** (2) | sc-rce, sc-deserialization | eval/exec RCE, pickle/ObjectInputStream/unserialize/BinaryFormatter |
| **Access Control** (4) | sc-auth, sc-authz, sc-privilege-escalation, sc-session | Broken auth, IDOR, privilege escalation, session fixation |
| **Data Exposure** (3) | sc-secrets, sc-data-exposure, sc-crypto | Hardcoded secrets, PII leaks, weak cryptography |
| **Server-Side** (4) | sc-ssrf, sc-path-traversal, sc-file-upload, sc-open-redirect | SSRF, directory traversal, file upload, open redirect |
| **Client-Side** (4) | sc-csrf, sc-cors, sc-clickjacking, sc-websocket | CSRF, CORS misconfig, clickjacking, WebSocket hijacking |
| **Logic** (3) | sc-business-logic, sc-race-condition, sc-mass-assignment | Business logic flaws, TOCTOU, mass assignment |
| **API** (3) | sc-api-security, sc-rate-limiting, sc-jwt | OWASP API Top 10, rate limiting, JWT flaws |
| **Infrastructure** (3) | sc-iac, sc-docker, sc-ci-cd | IaC misconfig, Docker security, CI/CD pipeline vulns |
| **Languages** (7) | sc-lang-go, sc-lang-typescript, sc-lang-python, sc-lang-php, sc-lang-rust, sc-lang-java, sc-lang-csharp | Language-specific deep scanning with 400+ item checklists |
| **Specialized Surfaces** (3) | sc-ai-security, sc-protocol-security, sc-local-ipc | LLM/agent tools and memory, RPC/brokers/webhooks, desktop/mobile/local IPC |

### Language Scanners

Each language scanner uses a dedicated **400+ item checklist** with specific CWE references:

| Language | Skill | Key Focus Areas |
|----------|-------|----------------|
| **Go** | sc-lang-go | unsafe package, goroutine leaks, race conditions, crypto/rand, template XSS |
| **TypeScript/JS** | sc-lang-typescript | Prototype pollution, eval injection, DOM XSS, npm supply chain, Next.js |
| **Python** | sc-lang-python | pickle RCE, SSTI, subprocess injection, Django/Flask/FastAPI |
| **PHP** | sc-lang-php | unserialize gadgets, phar, type juggling, Laravel/WordPress |
| **Rust** | sc-lang-rust | unsafe blocks, FFI, integer overflow, Send/Sync, serde bombs |
| **Java/Kotlin** | sc-lang-java | Deserialization, JNDI injection, Spring SpEL, HQL, XXE |
| **C#/.NET** | sc-lang-csharp | BinaryFormatter RCE, EF raw SQL, Blazor JS interop, SignalR |

## How It Works

```
PHASE 1: RECON           Architecture mapping, tech stack detection, dependency audit
         │
         ▼
PHASE 2: HUNT            40+ vulnerability skills run in parallel
         │
         ▼
PHASE 3: VERIFY          False positive elimination, confidence scoring (0-100)
         │
         ▼
PHASE 4: REPORT          CVSS severity classification, remediation roadmap
         │
         ▼
OUTPUT:  security-report/SECURITY-REPORT.md
```

The four phases are evidence-led: reconnaissance seeds a coverage ledger, hunters
produce candidates, and a separate verification pass tries to disprove each candidate.
Only a demonstrated trust-boundary failure is `confirmed`; unresolved source-grounded
leads remain `needs_validation` without severity. See
[Evidence and Coverage Model](docs/EVIDENCE_MODEL.md).

## Output

After a scan, the `security-report/` directory contains:

| File | Description |
|------|-------------|
| `SECURITY-REPORT.md` | Final consolidated security assessment |
| `architecture.md` | Codebase architecture map |
| `dependency-audit.md` | Supply chain analysis |
| `verified-findings.md` | Findings after verification |
| `coverage-ledger.md` | Explicit covered, candidate, blocked, deferred, and excluded units |
| `findings.json` | Structured final verdicts: confirmed, needs_validation, rejected |
| `findings/*.json` | Raw findings from each skill |

## Adding Custom Skills

1. Copy `templates/SKILL_TEMPLATE.md` for vulnerability skills
2. Copy `templates/LANG_SKILL_TEMPLATE.md` for language skills
3. Follow the [agentskills.io specification](https://agentskills.io/specification)

See [docs/SKILL_DEVELOPMENT_GUIDE.md](docs/SKILL_DEVELOPMENT_GUIDE.md) for detailed instructions.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License — see [LICENSE](LICENSE) for details.

## Acknowledgements

The evidence and coverage model in v1.2 was informed by Cloudflare's MIT-licensed
[`security-audit-skill`](https://github.com/cloudflare/security-audit-skill) and
adapted to security-check's multi-skill four-phase pipeline.

## Author

**Ersin Koc** — [ECOSTACK TECHNOLOGY OU](https://ecostack.ee)
