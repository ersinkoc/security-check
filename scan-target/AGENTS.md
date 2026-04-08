# Security Check - Agent Orchestration (Multi-Editor Compatible)

# Compatible with: Opencode, Cursor, Codex, and other AI coding assistants
# Skills are located in: .agents/skills/ (symlinked or copied from .claude/skills/)

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

1. **sc-recon** (`.agents/skills/sc-recon/SKILL.md`)
   - Discovers technology stack, architecture, entry points, data flows
   - Produces: `security-report/architecture.md`
   - Extracts detected languages list for Step 2

2. **sc-dependency-audit** (`.agents/skills/sc-dependency-audit/SKILL.md`)
   - Analyzes lock files, supply chain risks, known CVE patterns
   - Produces: `security-report/dependency-audit.md`

After Step 1 completes, update `.scan-state.json` with detected languages and completed skills.

### Step 2: Vulnerability Hunting

Run vulnerability scanning skills **in parallel** based on detected languages and frameworks from Step 1.

#### Language-Specific Skills (run if language detected):

| Language | Skill | File |
|----------|-------|------|
| JavaScript/TypeScript | sc-lang-js | `.agents/skills/sc-lang-js/SKILL.md` |
| Python | sc-lang-python | `.agents/skills/sc-lang-python/SKILL.md` |
| Go | sc-lang-go | `.agents/skills/sc-lang-go/SKILL.md` |
| Rust | sc-lang-rust | `.agents/skills/sc-lang-rust/SKILL.md` |
| Java/Kotlin | sc-lang-java | `.agents/skills/sc-lang-java/SKILL.md` |
| C/C++ | sc-lang-c | `.agents/skills/sc-lang-c/SKILL.md` |
| PHP | sc-lang-php | `.agents/skills/sc-lang-php/SKILL.md` |
| Ruby | sc-lang-ruby | `.agents/skills/sc-lang-ruby/SKILL.md` |
| C#/.NET | sc-lang-csharp | `.agents/skills/sc-lang-csharp/SKILL.md` |
| Swift | sc-lang-swift | `.agents/skills/sc-lang-swift/SKILL.md` |

#### Category Skills (always run relevant ones):

| Category | Skill | File |
|----------|-------|------|
| Web Security | sc-web | `.agents/skills/sc-web/SKILL.md` |
| API Security | sc-api | `.agents/skills/sc-api/SKILL.md` |
| Authentication | sc-auth | `.agents/skills/sc-auth/SKILL.md` |
| Cryptography | sc-crypto | `.agents/skills/sc-crypto/SKILL.md` |
| Infrastructure | sc-infra | `.agents/skills/sc-infra/SKILL.md` |
| Secrets Detection | sc-secrets | `.agents/skills/sc-secrets/SKILL.md` |
| Configuration | sc-config | `.agents/skills/sc-config/SKILL.md` |
| Input Validation | sc-input-validation | `.agents/skills/sc-input-validation/SKILL.md` |
| Access Control | sc-access-control | `.agents/skills/sc-access-control/SKILL.md` |
| Data Protection | sc-data-protection | `.agents/skills/sc-data-protection/SKILL.md` |

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

1. **sc-verifier** (`.agents/skills/sc-verifier/SKILL.md`)
   - Reads all findings from `security-report/findings/`
   - Eliminates false positives via reachability analysis
   - Checks for framework protections and sanitization
   - Deduplicates findings with same root cause
   - Assigns confidence scores (0-100)
   - Produces: `security-report/verified-findings.md`

### Step 4: Reporting

After verification completes:

1. **sc-report** (`.agents/skills/sc-report/SKILL.md`)
   - Reads verified findings and all intermediate artifacts
   - Produces: `security-report/SECURITY-REPORT.md`
   - Includes executive summary, detailed findings, remediation roadmap
   - Updates `.scan-state.json` with final status

---

## Diff Mode Pipeline

For diff/PR scans, use a streamlined pipeline:

1. **sc-diff-report** (`.agents/skills/sc-diff-report/SKILL.md`)
   - Extracts git diff (staged, unstaged, or between branches)
   - Filters changed files only
   - Runs targeted vulnerability skills on changed code
   - Classifies findings as "new" vs "existing"
   - Produces: `security-report/DIFF-REPORT.md`

---

## Available Skills - Complete Catalog

### Core Pipeline Skills
- `sc-orchestrator` - Master coordination and state management (`.agents/skills/sc-orchestrator/SKILL.md`)
- `sc-recon` - Codebase reconnaissance and architecture mapping (`.agents/skills/sc-recon/SKILL.md`)
- `sc-dependency-audit` - Supply chain and dependency analysis (`.agents/skills/sc-dependency-audit/SKILL.md`)
- `sc-verifier` - False positive elimination and confidence scoring (`.agents/skills/sc-verifier/SKILL.md`)
- `sc-report` - Final comprehensive report generation (`.agents/skills/sc-report/SKILL.md`)
- `sc-diff-report` - Incremental/PR diff security report (`.agents/skills/sc-diff-report/SKILL.md`)

### Language-Specific Vulnerability Skills
- `sc-lang-js` - JavaScript/TypeScript (`.agents/skills/sc-lang-js/SKILL.md`)
- `sc-lang-python` - Python (`.agents/skills/sc-lang-python/SKILL.md`)
- `sc-lang-go` - Go (`.agents/skills/sc-lang-go/SKILL.md`)
- `sc-lang-rust` - Rust (`.agents/skills/sc-lang-rust/SKILL.md`)
- `sc-lang-java` - Java/Kotlin (`.agents/skills/sc-lang-java/SKILL.md`)
- `sc-lang-c` - C/C++ (`.agents/skills/sc-lang-c/SKILL.md`)
- `sc-lang-php` - PHP (`.agents/skills/sc-lang-php/SKILL.md`)
- `sc-lang-ruby` - Ruby (`.agents/skills/sc-lang-ruby/SKILL.md`)
- `sc-lang-csharp` - C#/.NET (`.agents/skills/sc-lang-csharp/SKILL.md`)
- `sc-lang-swift` - Swift (`.agents/skills/sc-lang-swift/SKILL.md`)

### Category Vulnerability Skills
- `sc-web` - Web application security (`.agents/skills/sc-web/SKILL.md`)
- `sc-api` - API security (`.agents/skills/sc-api/SKILL.md`)
- `sc-auth` - Authentication and session management (`.agents/skills/sc-auth/SKILL.md`)
- `sc-crypto` - Cryptographic implementation review (`.agents/skills/sc-crypto/SKILL.md`)
- `sc-infra` - Infrastructure and deployment security (`.agents/skills/sc-infra/SKILL.md`)
- `sc-secrets` - Hardcoded secrets, API keys, credentials (`.agents/skills/sc-secrets/SKILL.md`)
- `sc-config` - Security configuration review (`.agents/skills/sc-config/SKILL.md`)
- `sc-input-validation` - Input validation and injection (`.agents/skills/sc-input-validation/SKILL.md`)
- `sc-access-control` - Authorization and privilege escalation (`.agents/skills/sc-access-control/SKILL.md`)
- `sc-data-protection` - PII handling and data leakage (`.agents/skills/sc-data-protection/SKILL.md`)

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

## Editor-Specific Notes

### Opencode
- Skills are read from `.agents/skills/` directory
- Use `@sc-recon` syntax to invoke individual skills
- The orchestrator skill manages the full pipeline

### Cursor
- Skills are loaded as context from `.agents/skills/`
- Use the orchestrator skill for full pipeline execution
- Individual skills can be referenced in chat

### Codex
- Skills are read from `.agents/skills/` directory
- The AGENTS.md file serves as the primary instruction set
- Skills are invoked by the orchestrator based on pipeline phase

---

## Important Notes

- Never modify source code during a scan unless explicitly asked.
- All file paths in findings must be relative to project root.
- Treat test files, examples, and vendor directories with lower priority but still scan them.
- If a skill fails, log the failure in `.scan-state.json` and continue with remaining skills.
- The scan should be idempotent: running it twice produces the same results.
- Respect .gitignore patterns for vendor/third-party code but flag if node_modules or similar contain suspicious files.
