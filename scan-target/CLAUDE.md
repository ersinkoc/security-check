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

### Step 1: Reconnaissance

Run these skills sequentially, as later skills depend on recon output:

1. **sc-recon** (`.claude/skills/sc-recon/SKILL.md`)
   - Discovers technology stack, architecture, entry points, data flows
   - Produces: `security-report/architecture.md`
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
| JavaScript/TypeScript | sc-lang-js | `.claude/skills/sc-lang-js/SKILL.md` |
| Python | sc-lang-python | `.claude/skills/sc-lang-python/SKILL.md` |
| Go | sc-lang-go | `.claude/skills/sc-lang-go/SKILL.md` |
| Rust | sc-lang-rust | `.claude/skills/sc-lang-rust/SKILL.md` |
| Java/Kotlin | sc-lang-java | `.claude/skills/sc-lang-java/SKILL.md` |
| C/C++ | sc-lang-c | `.claude/skills/sc-lang-c/SKILL.md` |
| PHP | sc-lang-php | `.claude/skills/sc-lang-php/SKILL.md` |
| Ruby | sc-lang-ruby | `.claude/skills/sc-lang-ruby/SKILL.md` |
| C#/.NET | sc-lang-csharp | `.claude/skills/sc-lang-csharp/SKILL.md` |
| Swift | sc-lang-swift | `.claude/skills/sc-lang-swift/SKILL.md` |

#### Category Skills (always run relevant ones):

| Category | Skill | File |
|----------|-------|------|
| Web Security | sc-web | `.claude/skills/sc-web/SKILL.md` |
| API Security | sc-api | `.claude/skills/sc-api/SKILL.md` |
| Authentication | sc-auth | `.claude/skills/sc-auth/SKILL.md` |
| Cryptography | sc-crypto | `.claude/skills/sc-crypto/SKILL.md` |
| Infrastructure | sc-infra | `.claude/skills/sc-infra/SKILL.md` |
| Secrets Detection | sc-secrets | `.claude/skills/sc-secrets/SKILL.md` |
| Configuration | sc-config | `.claude/skills/sc-config/SKILL.md` |
| Input Validation | sc-input-validation | `.claude/skills/sc-input-validation/SKILL.md` |
| Access Control | sc-access-control | `.claude/skills/sc-access-control/SKILL.md` |
| Data Protection | sc-data-protection | `.claude/skills/sc-data-protection/SKILL.md` |

Each skill produces a findings file: `security-report/findings/<skill-name>.json`

Findings JSON schema:
```json
{
  "skill": "<skill-name>",
  "scan_duration_ms": 0,
  "findings": [
    {
      "id": "<skill>-<NNN>",
      "title": "...",
      "severity": "critical|high|medium|low|info",
      "category": "...",
      "file": "...",
      "line": 0,
      "code_snippet": "...",
      "description": "...",
      "impact": "...",
      "remediation": "...",
      "references": ["..."],
      "cwe": "CWE-XXX",
      "confidence": 0
    }
  ]
}
```

### Step 3: Verification

After all Step 2 skills complete:

1. **sc-verifier** (`.claude/skills/sc-verifier/SKILL.md`)
   - Reads all findings from `security-report/findings/`
   - Eliminates false positives via reachability analysis
   - Checks for framework protections and sanitization
   - Deduplicates findings with same root cause
   - Assigns confidence scores (0-100)
   - Produces: `security-report/verified-findings.md`

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

## Available Skills - Complete Catalog

### Core Pipeline Skills
- `sc-orchestrator` - Master coordination and state management
- `sc-recon` - Codebase reconnaissance and architecture mapping
- `sc-dependency-audit` - Supply chain and dependency analysis
- `sc-verifier` - False positive elimination and confidence scoring
- `sc-report` - Final comprehensive report generation
- `sc-diff-report` - Incremental/PR diff security report

### Language-Specific Vulnerability Skills
- `sc-lang-js` - JavaScript/TypeScript (XSS, prototype pollution, ReDoS, eval injection)
- `sc-lang-python` - Python (injection, deserialization, SSTI, path traversal)
- `sc-lang-go` - Go (goroutine leaks, unsafe pointer, race conditions)
- `sc-lang-rust` - Rust (unsafe blocks, FFI boundaries, panic in libs)
- `sc-lang-java` - Java/Kotlin (deserialization, JNDI, XXE, expression injection)
- `sc-lang-c` - C/C++ (buffer overflow, format string, use-after-free, integer overflow)
- `sc-lang-php` - PHP (type juggling, object injection, file inclusion, RCE)
- `sc-lang-ruby` - Ruby (mass assignment, ERB injection, open redirect, YAML deserialization)
- `sc-lang-csharp` - C#/.NET (ViewState, LINQ injection, insecure deserialization)
- `sc-lang-swift` - Swift (keychain misuse, ATS bypass, insecure crypto)

### Category Vulnerability Skills
- `sc-web` - Web application security (OWASP Top 10)
- `sc-api` - API security (broken auth, mass assignment, rate limiting)
- `sc-auth` - Authentication and session management
- `sc-crypto` - Cryptographic implementation review
- `sc-infra` - Infrastructure and deployment security (Docker, K8s, Terraform)
- `sc-secrets` - Hardcoded secrets, API keys, credentials detection
- `sc-config` - Security configuration review (headers, CORS, CSP)
- `sc-input-validation` - Input validation and injection prevention
- `sc-access-control` - Authorization, RBAC, privilege escalation
- `sc-data-protection` - PII handling, encryption at rest, data leakage

---

## Output Structure

After a full scan, the `security-report/` folder contains:

```
security-report/
  .scan-state.json          # Scan metadata and progress
  architecture.md           # From sc-recon
  dependency-audit.md       # From sc-dependency-audit
  verified-findings.md      # From sc-verifier
  SECURITY-REPORT.md        # Final report from sc-report
  findings/                 # Raw findings from each skill
    sc-lang-js.json
    sc-web.json
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
- Respect .gitignore patterns for vendor/third-party code but flag if node_modules or similar contain suspicious files.
