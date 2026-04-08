# Frequently Asked Questions

> Answers to common questions about security-check.

---

## General

### 1. What is security-check?

security-check is a collection of agent skills that transforms LLM-based AI coding assistants into a comprehensive security scanning team. It consists of 40+ vulnerability detection skills, 7 language-specific security scanners, and 400+ item security checklists per language. You install the skill files into your project and tell your AI assistant to "run security check." The AI then follows the structured instructions in each skill file to systematically discover, verify, and report security vulnerabilities.

### 2. How does it differ from traditional SAST tools like Semgrep, SonarQube, or CodeQL?

Traditional SAST tools use pattern matching, regex rules, and AST parsing to find vulnerabilities. They apply the same rules regardless of context, which produces many false positives and cannot reason about business logic, framework-specific protections, or complex data flows across function boundaries.

security-check leverages LLM reasoning to understand what your code actually does. It can trace data flow from user input to dangerous sinks across function boundaries, evaluate whether framework-level protections mitigate a finding, and reason about whether a pattern is genuinely exploitable in its specific context. The result is fewer false positives and detection of logic-level vulnerabilities that pattern-matching tools fundamentally cannot find.

The tradeoff is that security-check depends on LLM accuracy, which is probabilistic rather than deterministic. Traditional SAST tools are better for deterministic checks (e.g., "is this function call present?") while security-check excels at contextual reasoning (e.g., "is this SQL query actually exploitable given the surrounding validation?").

### 3. Is security-check free?

Yes. security-check is open source under the MIT License. The skill files themselves are free and always will be. However, running the scan consumes tokens from your AI coding assistant, which may have its own pricing.

### 4. Does security-check execute any code or install any binaries?

No. security-check contains no executable code whatsoever. It consists entirely of Markdown files that instruct your AI assistant on how to analyze code. The skill files are passive instructions -- they cannot execute on their own, access the network, or modify your system. All actions are performed by the AI assistant within its normal sandboxed capabilities.

### 5. What languages does security-check support?

security-check has two levels of language support:

**Deep support (dedicated language skill + 400+ item checklist):**
- Go
- TypeScript / JavaScript
- Python
- PHP
- Rust
- Java / Kotlin
- C# / .NET

**Generic support (covered by vulnerability-class skills):**
The 40+ vulnerability skills (sc-sqli, sc-xss, sc-rce, etc.) work across any language because they are based on conceptual vulnerability patterns rather than language-specific syntax. If your project uses Ruby, Swift, C++, or any other language, the generic skills will still detect common vulnerability patterns.

### 6. Which AI coding assistants are supported?

security-check works with:
- **Claude Code** (Anthropic) -- uses `.claude/skills/` directory
- **Codex** (OpenAI) -- uses `.agents/skills/` directory
- **Cursor** -- uses `.agents/skills/` directory
- **Opencode** -- uses `.agents/skills/` directory
- **Windsurf** (Codeium) -- uses `.agents/skills/` directory
- **Gemini CLI** (Google) -- uses `.agents/skills/` directory

See `docs/SUPPORTED_PLATFORMS.md` for detailed setup instructions for each platform.

---

## Scanning and Results

### 7. How long does a full scan take?

Scan duration depends on the project size, the number of languages detected, and the AI platform's processing speed. Rough estimates:

| Project Size | Approximate Duration |
|-------------|---------------------|
| Small (< 5,000 LOC) | 5-15 minutes |
| Medium (5,000-50,000 LOC) | 15-45 minutes |
| Large (50,000-200,000 LOC) | 45-120 minutes |
| Very large (> 200,000 LOC) | Use diff mode or scoped scanning |

These are estimates for a full scan with all phases. Diff mode scanning of changed files is significantly faster.

### 8. How do I handle false positives?

security-check includes a dedicated verification phase (Phase 3, `sc-verifier`) that eliminates false positives by checking:
- Reachability (is the code in an executable path?)
- Sanitization (is the input sanitized before reaching the sink?)
- Framework protections (does the framework automatically mitigate this?)
- Context (is this test code, dead code, or an example?)

Findings that survive verification receive a confidence score (0-100). Findings scored below 30 are marked as "Low Confidence" and placed in the Informational section of the report.

If you still encounter false positives:
1. Check the confidence score -- low scores indicate uncertain findings
2. Review the finding's verification notes for context
3. You can tell your AI assistant: "Finding XSS-003 is a false positive because [reason]. Please remove it and regenerate the report."

### 9. What does the confidence score mean?

| Score | Meaning |
|-------|---------|
| 90-100 | Confirmed vulnerability, directly exploitable |
| 70-89 | High probability, likely real but may need specific conditions |
| 50-69 | Probable vulnerability, recommend manual verification |
| 30-49 | Possible risk, significant chance of false positive |
| 0-29 | Low confidence, informational only |

### 10. Where are the scan results stored?

All scan results are written to a `security-report/` directory in your project root:

| File | Content |
|------|---------|
| `architecture.md` | Codebase architecture map from reconnaissance |
| `dependency-audit.md` | Supply chain and dependency analysis |
| `*-results.md` | Raw findings from each vulnerability skill |
| `verified-findings.md` | Findings after false positive elimination |
| `SECURITY-REPORT.md` | Final consolidated security report |
| `diff-report.md` | Incremental scan report (diff mode only) |

### 11. Can I scan only specific files or directories?

Yes. You can scope the scan in several ways:

- **Diff mode:** "scan diff" or "scan changes" scans only files changed since the last commit
- **Directory scoping:** "scan the src/api/ directory for vulnerabilities"
- **Skill-specific:** "run only sc-sqli and sc-xss against this project"
- **Language-specific:** "run the Python security scanner only"

### 12. What is diff mode and when should I use it?

Diff mode scans only files that have changed (using `git diff`). Use it for:
- PR reviews -- scan only the code being merged
- Incremental checks -- verify that new changes do not introduce vulnerabilities
- Large codebases -- where a full scan would take too long

Activate diff mode by saying: "scan diff", "scan changes", or "PR scan."

Diff mode produces a `security-report/diff-report.md` that shows new vulnerabilities introduced by the changes, vulnerabilities fixed by the changes, and an overall assessment of security posture change.

---

## Custom Skills and Extensibility

### 13. How do I add a custom vulnerability skill?

1. Copy `templates/SKILL_TEMPLATE.md` to `scan-target/.claude/skills/sc-{your-skill}.md`
2. Fill in all required sections (Purpose, Activation, Phase 1, Phase 2, Severity Classification, Language-Specific Notes, Output Format, Common False Positives)
3. Copy the same file to `scan-target/.agents/skills/sc-{your-skill}.md`
4. Update `scan-target/CLAUDE.md` and `scan-target/AGENTS.md` to include your skill in the pipeline

See `docs/SKILL_DEVELOPMENT_GUIDE.md` for detailed instructions and `templates/SKILL_TEMPLATE.md` for the file template.

### 14. How do I add support for a new programming language?

Adding a new language requires two files:

1. **Language skill:** Copy `templates/LANG_SKILL_TEMPLATE.md` to `scan-target/.claude/skills/sc-lang-{language}.md`. Define 15-25 categories of language-specific vulnerability patterns with dangerous functions, safe alternatives, and code examples.

2. **Security checklist:** Copy `templates/CHECKLIST_TEMPLATE.md` to `checklists/{language}-security-checklist.md`. Create at least 400 unique security check items organized into 20 categories, each with a unique ID, description, severity level, and CWE reference.

See `docs/SKILL_DEVELOPMENT_GUIDE.md` for complete instructions.

### 15. Can I modify the severity thresholds or confidence scoring?

Yes. The confidence scoring and severity classification are defined within the skill files themselves. You can modify:

- **Per-skill severity definitions:** Edit the `## Severity Classification` section of any skill file
- **Verifier thresholds:** Edit `sc-verifier.md` to change the confidence adjustment rules
- **Report thresholds:** Edit `sc-report.md` to change how findings are categorized in the report

Since everything is in Markdown, modifications require no code changes or recompilation.

---

## Performance and Tokens

### 16. How many tokens does a scan consume?

Token consumption varies based on project size, languages detected, and the AI platform:

| Scan Type | Approximate Token Usage |
|-----------|------------------------|
| Small project, full scan | 50,000 - 150,000 tokens |
| Medium project, full scan | 150,000 - 500,000 tokens |
| Large project, full scan | 500,000 - 2,000,000 tokens |
| Diff mode (10 changed files) | 20,000 - 80,000 tokens |

The skill files themselves consume tokens when loaded into context. The 40+ skills total approximately 15,000-25,000 tokens of instruction content. Each checklist adds approximately 5,000-8,000 tokens when referenced.

To minimize token usage:
- Use diff mode for incremental scans
- Run specific skills instead of the full pipeline
- Scope scans to specific directories

### 17. Can I run security-check in CI/CD?

security-check is designed as an interactive tool for AI coding assistants, not as a CI/CD pipeline step. However, you can integrate it into your workflow in these ways:

- **Pre-merge review:** Run "scan diff" in your AI assistant before merging a PR
- **Scheduled audits:** Run a full scan periodically (e.g., monthly) as part of your security review process
- **Automated with Claude Code:** Claude Code can be scripted via `claude --message "run security check"` in a CI pipeline, though this is experimental and consumes significant tokens

For CI/CD pipeline security scanning, see the `sc-ci-cd` skill which analyzes your CI/CD configuration files for security issues.

### 18. Does security-check work with monorepos?

Yes. The reconnaissance phase (sc-recon) maps the entire repository structure and detects multiple languages, frameworks, and services. For monorepos:

- All detected languages trigger their respective language skills
- Findings are reported with full paths relative to the repository root
- You can scope scans to specific services: "scan the services/auth/ directory"

For very large monorepos, consider running scoped scans per service rather than scanning the entire repository at once.

---

## Security and Trust

### 19. Can security-check itself introduce vulnerabilities into my code?

No. security-check only reads your source code and writes report files to the `security-report/` directory. It never modifies your source code, dependencies, or configuration. The skill files contain analysis instructions, not code that gets executed.

The remediation suggestions in the report are recommendations that you review and implement manually. The AI assistant does not automatically apply fixes unless you explicitly ask it to.

### 20. Is my code sent to external servers during scanning?

security-check itself does not send data anywhere. However, your AI coding assistant processes the code through its LLM backend. This means:

- **Claude Code:** Code is sent to Anthropic's API for processing
- **Codex:** Code is sent to OpenAI's API for processing
- **Cursor:** Code is processed by the configured LLM provider
- **Gemini CLI:** Code is sent to Google's API for processing

This is the same data processing that occurs during normal use of your AI coding assistant. security-check does not add any additional data transmission beyond what the assistant already does.

If you have data sensitivity concerns, consult your AI platform's privacy policy and consider using platforms that offer zero-retention policies or on-premise deployment.

### 21. How does security-check handle secrets found in the codebase?

The `sc-secrets` skill specifically scans for hardcoded secrets, API keys, tokens, passwords, and credentials. Findings are reported in the same format as other vulnerabilities, with:

- The file path and line number where the secret was found
- The type of secret identified (API key, database password, JWT secret, etc.)
- Remediation guidance (move to environment variables, use a secrets manager, etc.)

The report does not reproduce the actual secret values -- it identifies their location and type so you can rotate and remediate them.

---

## Comparison and Scope

### 22. Does security-check replace penetration testing?

No. security-check is a static analysis tool that examines source code without executing it. It cannot detect:

- Runtime-specific vulnerabilities that only manifest under certain server configurations
- Network-level vulnerabilities (open ports, TLS misconfigurations, firewall rules)
- Infrastructure vulnerabilities not described in code (e.g., unpatched OS packages)
- Social engineering vectors
- Physical security issues

security-check complements penetration testing by identifying code-level vulnerabilities early in the development process. Use it alongside, not instead of, regular penetration testing for production systems.

### 23. What vulnerability standards does security-check cover?

security-check's skill set covers:

- **OWASP Top 10 (2021):** All categories including Injection, Broken Access Control, Cryptographic Failures, Security Misconfiguration, and more
- **CWE Top 25 (2024):** Most Dangerous Software Weaknesses
- **OWASP API Security Top 10:** API-specific vulnerabilities
- **SANS Top 25:** Common programming errors

Each finding includes CWE references that map back to these standards.

### 24. Can security-check detect zero-day vulnerabilities?

security-check does not scan against a CVE database of known vulnerabilities (except for dependency analysis in `sc-dependency-audit`). However, it can detect vulnerability patterns that may constitute unknown or unreported vulnerabilities in your code. The LLM's reasoning ability means it can identify dangerous code patterns that no rule has been written for yet.

For known CVE detection in dependencies, `sc-dependency-audit` analyzes lock files and matches versions against known vulnerability databases.

### 25. How does security-check handle multi-service architectures?

The reconnaissance phase maps all services, APIs, and microservices in the codebase. security-check analyzes:

- Inter-service communication security (authenticated calls, TLS, token passing)
- Shared dependency versions across services
- API gateway and service mesh configurations
- Service-specific entry points and trust boundaries

For distributed systems where services live in separate repositories, run security-check in each repository independently.

---

## Troubleshooting

### 26. The scan started but did not complete. What happened?

Common causes:
1. **Context window limit:** The AI assistant ran out of context space. Try diff mode or scope the scan to a specific directory.
2. **Rate limiting:** The AI platform rate-limited the conversation. Wait and resume.
3. **Interruption:** The conversation was closed or timed out. The scan can be resumed -- say "continue security check" and the orchestrator will detect existing partial results in `security-report/`.

### 27. Some skills did not run. Why?

Language-specific skills (sc-lang-*) only run when their language is detected during reconnaissance. Check `security-report/architecture.md` to see which languages were detected. If a language is missing:

- Verify that source files with standard extensions exist in the project
- Check that files are not exclusively in ignored directories (e.g., `node_modules/`, `vendor/`)

You can also force a specific skill: "run sc-lang-python against this project."

### 28. The report contains duplicate findings. Is this a bug?

The verifier (Phase 3) is designed to merge duplicate findings that share the same root cause. If duplicates appear in the final report, it may mean:

- The findings are similar but technically distinct (different code paths leading to the same type of vulnerability)
- The verifier's duplicate detection missed a merge opportunity

You can tell the AI assistant: "Findings SQLI-003 and SQLI-007 appear to be the same issue. Please merge them and regenerate the report."

### 29. Can I resume a scan that was interrupted?

Yes. If a previous scan was interrupted, the `security-report/` directory will contain partial results. When you say "run security check" again, the orchestrator detects the existing directory and asks whether to rescan everything or continue from where it left off.

### 30. How do I completely reset and start a fresh scan?

Delete the `security-report/` directory and run the scan again:

```bash
rm -rf security-report/
```

Then tell your AI assistant: "run security check."
