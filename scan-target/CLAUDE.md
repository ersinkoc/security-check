# Security Check - Master Orchestration for Claude Code

## Scan Triggers

When the user says any of the following, begin a full security scan:
- "run security check"
- "scan for vulnerabilities"
- "security audit"
- "security scan"
- "check security"
- "find vulnerabilities"
- "pentest this codebase"
- "threat analysis"
- "run all security skills"

When the user says any of the following, begin a diff-mode scan:
- "scan diff"
- "scan changes"
- "PR scan"
- "scan my PR"
- "check changes for security"
- "security review PR"
- "scan staged changes"
- "diff security check"

---

## Full Scan Pipeline (4 Phases)

Apply `.claude/skills/sc-orchestrator/SKILL.md` and its evidence contract. A pattern is a candidate, not a vulnerability. Confirm only a complete, meaningful trust-boundary failure after a separate adversarial verification pass. Use `needs_validation` without severity when a decisive runtime or deployment fact is unavailable. Record defense-in-depth gaps as hardening notes.

### Step 0: Pre-Check

Before starting any scan:

1. Check if a `security-report/` folder already exists in the project root.
2. If it exists, ask the user:
   - "A previous security report exists. Should I archive it (rename to security-report-YYYY-MM-DD/) and start fresh, or overwrite it?"
3. If it does not exist, create `security-report/` and proceed.
4. Create `security-report/.scan-state.json` to track progress:
   ```json
   {
     "scan_id": "<uuid>",
     "started_at": "<ISO-8601>",
     "status": "in-progress",
     "current_phase": 0,
     "completed_skills": [],
     "failed_skills": [],
     "detected_languages": [],
     "findings_count": 0
   }
   ```

Do not run target-controlled code against live services or shared infrastructure. Local execution requires no external network, a credential-free allowlisted environment, scratch-only writes, dummy data, and bounded resources. Otherwise perform source review and record the missing validation capability.

### Step 1: Reconnaissance

Run these skills sequentially, as later skills depend on recon output:

1. **sc-recon** (`.claude/skills/sc-recon/SKILL.md`)
   - Discovers technology stack, architecture, entry points, data flows
   - Produces: `security-report/architecture.md`
   - Produces: `security-report/coverage-ledger.md`
   - Extracts detected languages list for Step 2

2. **sc-dependency-audit** (`.claude/skills/sc-dependency-audit/SKILL.md`)
   - Analyzes lock files, supply chain risks, known CVE patterns
   - Produces: `security-report/dependency-audit.md`

After Step 1 completes, update `.scan-state.json` with detected languages and completed skills.

### Step 2: Vulnerability Hunting

Run vulnerability scanning skills **in parallel** based on detected languages and frameworks from Step 1.

#### Language-Specific Skills (run if language detected):

| Language | Skill | File |
|----------|-------|------|
| JavaScript/TypeScript | sc-lang-typescript | `.claude/skills/sc-lang-typescript/SKILL.md` |
| Python | sc-lang-python | `.claude/skills/sc-lang-python/SKILL.md` |
| Go | sc-lang-go | `.claude/skills/sc-lang-go/SKILL.md` |
| Rust | sc-lang-rust | `.claude/skills/sc-lang-rust/SKILL.md` |
| Java/Kotlin | sc-lang-java | `.claude/skills/sc-lang-java/SKILL.md` |
| PHP | sc-lang-php | `.claude/skills/sc-lang-php/SKILL.md` |
| C#/.NET | sc-lang-csharp | `.claude/skills/sc-lang-csharp/SKILL.md` |

#### Category Skills — Injection (always run):

| Category | Skill | File |
|----------|-------|------|
| SQL Injection | sc-sqli | `.claude/skills/sc-sqli/SKILL.md` |
| NoSQL Injection | sc-nosqli | `.claude/skills/sc-nosqli/SKILL.md` |
| GraphQL Injection | sc-graphql | `.claude/skills/sc-graphql/SKILL.md` |
| XSS | sc-xss | `.claude/skills/sc-xss/SKILL.md` |
| SSTI | sc-ssti | `.claude/skills/sc-ssti/SKILL.md` |
| XXE | sc-xxe | `.claude/skills/sc-xxe/SKILL.md` |
| LDAP Injection | sc-ldap | `.claude/skills/sc-ldap/SKILL.md` |
| Command Injection | sc-cmdi | `.claude/skills/sc-cmdi/SKILL.md` |
| Header Injection | sc-header-injection | `.claude/skills/sc-header-injection/SKILL.md` |

#### Category Skills — Code Execution:

| Category | Skill | File |
|----------|-------|------|
| Remote Code Execution | sc-rce | `.claude/skills/sc-rce/SKILL.md` |
| Deserialization | sc-deserialization | `.claude/skills/sc-deserialization/SKILL.md` |

#### Category Skills — Access Control:

| Category | Skill | File |
|----------|-------|------|
| Authentication | sc-auth | `.claude/skills/sc-auth/SKILL.md` |
| Authorization / IDOR | sc-authz | `.claude/skills/sc-authz/SKILL.md` |
| Privilege Escalation | sc-privilege-escalation | `.claude/skills/sc-privilege-escalation/SKILL.md` |
| Session Security | sc-session | `.claude/skills/sc-session/SKILL.md` |

#### Category Skills — Data Exposure:

| Category | Skill | File |
|----------|-------|------|
| Hardcoded Secrets | sc-secrets | `.claude/skills/sc-secrets/SKILL.md` |
| Data Exposure | sc-data-exposure | `.claude/skills/sc-data-exposure/SKILL.md` |
| Weak Cryptography | sc-crypto | `.claude/skills/sc-crypto/SKILL.md` |

#### Category Skills — Server-Side:

| Category | Skill | File |
|----------|-------|------|
| SSRF | sc-ssrf | `.claude/skills/sc-ssrf/SKILL.md` |
| Path Traversal | sc-path-traversal | `.claude/skills/sc-path-traversal/SKILL.md` |
| File Upload | sc-file-upload | `.claude/skills/sc-file-upload/SKILL.md` |
| Open Redirect | sc-open-redirect | `.claude/skills/sc-open-redirect/SKILL.md` |

#### Category Skills — Client-Side:

| Category | Skill | File |
|----------|-------|------|
| CSRF | sc-csrf | `.claude/skills/sc-csrf/SKILL.md` |
| CORS Misconfiguration | sc-cors | `.claude/skills/sc-cors/SKILL.md` |
| Clickjacking | sc-clickjacking | `.claude/skills/sc-clickjacking/SKILL.md` |
| WebSocket Security | sc-websocket | `.claude/skills/sc-websocket/SKILL.md` |

#### Category Skills — Logic & Design:

| Category | Skill | File |
|----------|-------|------|
| Business Logic | sc-business-logic | `.claude/skills/sc-business-logic/SKILL.md` |
| Race Conditions | sc-race-condition | `.claude/skills/sc-race-condition/SKILL.md` |
| Mass Assignment | sc-mass-assignment | `.claude/skills/sc-mass-assignment/SKILL.md` |

#### Category Skills — API & Infrastructure:

| Category | Skill | File |
|----------|-------|------|
| API Security | sc-api-security | `.claude/skills/sc-api-security/SKILL.md` |
| Rate Limiting | sc-rate-limiting | `.claude/skills/sc-rate-limiting/SKILL.md` |
| JWT Security | sc-jwt | `.claude/skills/sc-jwt/SKILL.md` |
| Infrastructure as Code | sc-iac | `.claude/skills/sc-iac/SKILL.md` |
| Docker Security | sc-docker | `.claude/skills/sc-docker/SKILL.md` |
| CI/CD Security | sc-ci-cd | `.claude/skills/sc-ci-cd/SKILL.md` |

#### Specialized Surface Skills — run when reconnaissance finds the boundary:

| Category | Skill | File |
|----------|-------|------|
| AI / LLM / Agents / MCP | sc-ai-security | `.claude/skills/sc-ai-security/SKILL.md` |
| Protocols / RPC / Messaging | sc-protocol-security | `.claude/skills/sc-protocol-security/SKILL.md` |
| Desktop / Mobile / Local IPC | sc-local-ipc | `.claude/skills/sc-local-ipc/SKILL.md` |

Each skill produces a candidate file: `security-report/findings/<skill-name>.json`. The orchestrator alone updates shared state and the coverage ledger. A clean result still records reviewed paths and concrete checks for its assigned coverage units.

Findings JSON schema:
```json
{
  "skill": "<skill-name>",
  "scan_duration_ms": 0,
  "findings": [
    {
      "id": "<skill>-<NNN>",
      "title": "...",
      "severity": "critical|high|medium|low|null",
      "category": "...",
      "file": "...",
      "line": 0,
      "code_snippet": "...",
      "description": "...",
      "impact": "...",
      "remediation": "...",
      "references": ["..."],
      "cwe": "CWE-XXX",
      "confidence": 0,
      "attacker": "...",
      "affected_principal": "...",
      "source_trace": ["path/to/file:line"],
      "control_analysis": "...",
      "sink": "...",
      "observed_result": "...",
      "conditions": ["..."],
      "proposed_verdict": "confirmed|needs_validation|rejected"
    }
  ]
}
```

Severity is null unless the candidate is independently confirmed in Step 3.

### Step 3: Verification

After all Step 2 skills complete:

1. **sc-verifier** (`.claude/skills/sc-verifier/SKILL.md`)
   - Reads all findings from `security-report/findings/`
   - Eliminates false positives via reachability analysis
   - Checks for framework protections and sanitization
   - Deduplicates findings with same root cause
   - Assigns confidence scores (0-100)
   - Produces: `security-report/verified-findings.md`
   - Produces: `security-report/findings.json` with separate `confirmed`, `needs_validation`, and `rejected` arrays
   - Assigns severity only to confirmed findings

### Step 4: Reporting

After verification completes:

1. **sc-report** (`.claude/skills/sc-report/SKILL.md`)
   - Reads verified findings and all intermediate artifacts
   - Produces: `security-report/SECURITY-REPORT.md`
   - Includes executive summary, detailed findings, remediation roadmap
   - Updates `.scan-state.json` with final status

---

## Diff Mode Pipeline

For diff/PR scans, use a streamlined pipeline:

1. **sc-diff-report** (`.claude/skills/sc-diff-report/SKILL.md`)
   - Extracts git diff (staged, unstaged, or between branches)
   - Filters changed files only
   - Runs targeted vulnerability skills on changed code
   - Classifies findings as "new" vs "existing"
   - Produces: `security-report/DIFF-REPORT.md`

---

## Available Skills - Complete Catalog (51 skills)

### Core Pipeline Skills (6)
- `sc-orchestrator` - Master coordination and state management
- `sc-recon` - Codebase reconnaissance and architecture mapping
- `sc-dependency-audit` - Supply chain and dependency analysis
- `sc-verifier` - False positive elimination and confidence scoring
- `sc-report` - Final comprehensive report generation
- `sc-diff-report` - Incremental/PR diff security report

### Language-Specific Vulnerability Skills (7)
- `sc-lang-typescript` - TypeScript/JavaScript (XSS, prototype pollution, ReDoS, eval injection, npm supply chain)
- `sc-lang-python` - Python (pickle RCE, SSTI, subprocess injection, Django/Flask/FastAPI)
- `sc-lang-go` - Go (goroutine leaks, unsafe pointer, race conditions, crypto/rand)
- `sc-lang-rust` - Rust (unsafe blocks, FFI boundaries, Send/Sync, serde bombs)
- `sc-lang-java` - Java/Kotlin (deserialization, JNDI, Spring SpEL, HQL injection, XXE)
- `sc-lang-php` - PHP (type juggling, unserialize gadgets, phar, Laravel/WordPress)
- `sc-lang-csharp` - C#/.NET (BinaryFormatter RCE, EF raw SQL, Blazor JS interop, SignalR)

### Injection Skills (9)
- `sc-sqli` - SQL injection (classic, blind, time-based, second-order, UNION)
- `sc-nosqli` - NoSQL injection (MongoDB, Redis, Elasticsearch)
- `sc-graphql` - GraphQL injection (introspection, depth attacks, field-level auth)
- `sc-xss` - Cross-site scripting (reflected, stored, DOM)
- `sc-ssti` - Server-side template injection (Jinja2, Twig, Freemarker, etc.)
- `sc-xxe` - XML external entity injection
- `sc-ldap` - LDAP injection (search filter, DN injection)
- `sc-cmdi` - OS command injection (shell metacharacters, argument injection)
- `sc-header-injection` - HTTP header injection (CRLF, Host header)

### Code Execution Skills (2)
- `sc-rce` - Remote code execution (eval/exec/Function across all languages)
- `sc-deserialization` - Insecure deserialization (pickle, ObjectInputStream, unserialize, BinaryFormatter)

### Access Control Skills (4)
- `sc-auth` - Authentication flaws (weak passwords, brute force, timing attacks)
- `sc-authz` - Authorization / IDOR (broken access control, object reference)
- `sc-privilege-escalation` - Privilege escalation (role manipulation, JWT claim tampering)
- `sc-session` - Session security (fixation, cookie attributes, regeneration)

### Data Exposure Skills (3)
- `sc-secrets` - Hardcoded secrets, API keys, credentials detection
- `sc-data-exposure` - PII in logs, stack traces, debug mode, source maps
- `sc-crypto` - Weak cryptography (ECB, static IVs, weak PRNG, disabled cert validation)

### Server-Side Skills (4)
- `sc-ssrf` - Server-side request forgery (URL fetching, cloud metadata)
- `sc-path-traversal` - Directory traversal (../, zip slip, symlink attacks)
- `sc-file-upload` - Unrestricted file upload (type validation, webroot upload)
- `sc-open-redirect` - Open redirects (URL parameter manipulation)

### Client-Side Skills (4)
- `sc-csrf` - Cross-site request forgery (missing tokens, SameSite)
- `sc-cors` - CORS misconfiguration (reflected origin, null origin)
- `sc-clickjacking` - Clickjacking (X-Frame-Options, CSP frame-ancestors)
- `sc-websocket` - WebSocket security (origin validation, auth on upgrade)

### Logic & Design Skills (3)
- `sc-business-logic` - Business logic flaws (price manipulation, workflow bypass)
- `sc-race-condition` - Race conditions (TOCTOU, double-spend, read-modify-write)
- `sc-mass-assignment` - Mass assignment (Express, Django, Laravel, Spring, ASP.NET)

### API & Infrastructure Skills (6)
- `sc-api-security` - API security (OWASP API Top 10, REST/GraphQL/gRPC)
- `sc-rate-limiting` - Missing rate limiting (ReDoS, pagination abuse)
- `sc-jwt` - JWT flaws (alg:none, weak secrets, missing validation, kid injection)
- `sc-iac` - Infrastructure as Code (Dockerfile, K8s, Terraform, GitHub Actions)
- `sc-docker` - Docker security (image hardening, secrets in layers)
- `sc-ci-cd` - CI/CD security (expression injection, pull_request_target, unpinned actions)

### Specialized Surface Skills (3)
- `sc-ai-security` - AI/LLM context, RAG, memory, tools, MCP, and agent delegation
- `sc-protocol-security` - RPC, brokers, queues, webhooks, streams, replay, and message lifecycle
- `sc-local-ipc` - Desktop/mobile bridges, deep links, local IPC, helpers, installers, and updaters

---

## Output Structure

After a full scan, the `security-report/` folder contains:

```
security-report/
  .scan-state.json          # Scan metadata and progress
  architecture.md           # From sc-recon
  coverage-ledger.md        # Explicit coverage units, evidence, and gaps
  dependency-audit.md       # From sc-dependency-audit
  verified-findings.md      # From sc-verifier
  findings.json             # Final confirmed/needs_validation/rejected verdicts
  SECURITY-REPORT.md        # Final report from sc-report
  findings/                 # Raw findings from each skill
    sc-sqli.json
    sc-xss.json
    sc-secrets.json
    ...
```

---

## Important Notes

- Never modify source code during a scan unless explicitly asked.
- All file paths in findings must be relative to project root.
- Treat test files, examples, and vendor directories with lower priority but still scan them.
- If a skill fails, log the failure in `.scan-state.json` and continue with remaining skills.
- The scan should be idempotent: running it twice produces the same results.
- Prior reports are inputs, not timeless truth: revalidate changed source and keep old gaps visible.
- A scoped, interrupted, or budget-limited scan must disclose partial coverage.
- Zero confirmed findings means only that reviewed coverage produced none; it is not proof that the repository is secure.
- Respect .gitignore patterns for vendor/third-party code but flag if node_modules or similar contain suspicious files.
