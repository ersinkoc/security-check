---
name: sc-report
description: Final consolidated security assessment report generator with CVSS severity and remediation roadmap
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Report Generator — Final Security Assessment

## Purpose

Generates the final consolidated security assessment report from verified findings. Produces an executive summary, detailed findings with CVSS v3.1-style severity ratings, scan statistics, and a prioritized remediation roadmap. This is the primary deliverable of the security-check pipeline.

## Activation

Runs in Phase 4 of the pipeline, after sc-verifier has completed.

## Input

- `security-report/verified-findings.md`
- `security-report/findings.json`
- `security-report/coverage-ledger.md`
- `security-report/architecture.md`
- `security-report/dependency-audit.md`

## Output

File: `security-report/SECURITY-REPORT.md`

## Report Generation Process

### 1. Data Collection

Read all input files and extract:
- Verified findings list with confidence scores and severity
- Architecture summary (languages, frameworks, app type)
- Dependency audit summary
- Total files scanned and lines of code (from architecture.md)
- Skills executed and their individual result counts
- Final verdicts, explicit coverage gaps, validation limits, and run completeness

Only `confirmed` records may appear in severity sections or risk-score arithmetic. Put `needs_validation` records in a separate unscored section, rejected records in an optional decision appendix, and missing defense-in-depth in hardening notes.

### 2. CVSS v3.1-Style Severity Mapping

Map each finding to a CVSS-aligned severity level:

**Critical (CVSS 9.0-10.0):**
- Remote Code Execution with no authentication required
- SQL Injection allowing full database access
- Hardcoded admin credentials or private keys
- Deserialization RCE with network-reachable endpoint
- Authentication bypass allowing full account takeover

**High (CVSS 7.0-8.9):**
- SQL Injection with limited scope
- Stored XSS affecting all users
- SSRF with access to internal services
- Broken access control (IDOR) exposing sensitive data
- Weak cryptography protecting sensitive data
- Privilege escalation from user to admin

**Medium (CVSS 4.0-6.9):**
- Reflected XSS requiring user interaction
- CSRF on state-changing operations
- Missing rate limiting on sensitive endpoints
- Information disclosure (stack traces, debug info)
- Session management weaknesses
- Open redirect

**Low (CVSS 0.1-3.9):**
- Demonstrated UI redress or header-related boundary failures with narrow impact
- Error responses that expose limited non-secret internal data to a lower-trust actor
- Reachable dependency flaws with demonstrated narrow impact
- Demonstrated narrow-impact boundary failures under restrictive conditions

Items with no demonstrated security impact, positive controls, and defense-in-depth recommendations belong in the unscored hardening section rather than the vulnerability severity table.

### 3. Risk Score Calculation

Calculate an overall project risk score (0-10) from confirmed findings only:

```
risk_score = sum(confirmed finding weights)

Base score from findings:
- Each Critical finding: +2.0
- Each High finding: +1.0
- Each Medium finding: +0.3
- Each Low finding: +0.1

Clamp to range 0-10. Put missing controls, positive controls, and test coverage in
the narrative; do not convert them into risk points without a confirmed boundary failure.
```

### 4. Report Structure

Generate the report with the following sections:

---

#### Section 1: Executive Summary

```markdown
# Security Assessment Report

**Project:** {project name from architecture.md}
**Date:** {scan date}
**Scanner:** security-check v1.2.0
**Risk Score:** {score}/10 ({Critical|High|Medium|Low|Minimal} Risk)

## Executive Summary

A security assessment was performed on {project description} using {N} automated
security skills across {N} vulnerability categories. The scan analyzed {N} files
containing approximately {N} lines of code across {languages}.

### Key Metrics
| Metric | Value |
|--------|-------|
| Total Findings | {N} |
| Critical | {N} |
| High | {N} |
| Medium | {N} |
| Low | {N} |

### Top Risks
1. {Most critical finding summary}
2. {Second most critical finding summary}
3. {Third most critical finding summary}
```

#### Section 2: Scan Statistics

```markdown
## Scan Statistics

| Statistic | Value |
|-----------|-------|
| Files Scanned | {N} |
| Lines of Code | {N} |
| Languages Detected | {list} |
| Frameworks Detected | {list} |
| Skills Executed | {N} |
| Findings Before Verification | {N} |
| False Positives Eliminated | {N} |
| Final Verified Findings | {N} |

### Finding Distribution

| Vulnerability Category | Critical | High | Medium | Low |
|-----------------------|----------|------|--------|-----|
| Injection | | | | |
| Authentication | | | | |
| Authorization | | | | |
| Data Exposure | | | | |
| Cryptography | | | | |
| Infrastructure | | | | |
| Dependencies | | | | |
| ... | | | | |
```

#### Section 3: Critical Findings

For each critical finding, provide full detail:

```markdown
## Critical Findings

### VULN-001: {Title}

**Severity:** Critical
**Confidence:** {score}/100
**CWE:** CWE-{XXX} — {CWE Name}
**OWASP:** {OWASP Top 10 category}

**Location:** `{file_path}:{line_number}`

**Description:**
{Detailed explanation of the vulnerability}

**Vulnerable Code:**
```{language}
{The vulnerable code snippet}
```

**Proof of Concept:**
{Conceptual explanation of how this could be exploited — no actual exploit payloads}

**Impact:**
{What an attacker could achieve by exploiting this vulnerability}

**Remediation:**
{Step-by-step fix with code example}

```{language}
{The fixed code snippet}
```

**References:**
- {CWE link}
- {OWASP link}
- {Framework-specific documentation link}
```

#### Sections 4-6: High, Medium, Low Findings

Same format as Critical but grouped by severity level. For Medium and Low findings, the description can be more concise.

#### Section 7: Hardening and Positive Controls

Brief unscored list of defense-in-depth improvements and positive security observations.

#### Section 8: Remediation Roadmap

```markdown
## Remediation Roadmap

### Phase 1: Immediate (1-3 days)
Address all Critical findings. These represent immediate security risks.

| # | Finding | Effort | Impact |
|---|---------|--------|--------|
| 1 | VULN-001: {title} | {Low/Medium/High} | {Critical} |
| ... | | | |

### Phase 2: Short-Term (1-2 weeks)
Address High findings and any quick-win Medium findings.

| # | Finding | Effort | Impact |
|---|---------|--------|--------|
| ... | | | |

### Phase 3: Medium-Term (1-2 months)
Address remaining Medium findings and dependency updates.

| # | Finding | Effort | Impact |
|---|---------|--------|--------|
| ... | | | |

### Phase 4: Hardening (Ongoing)
Address Low findings and implement defense-in-depth measures.

| # | Recommendation | Effort | Impact |
|---|---------------|--------|--------|
| ... | | | |
```

#### Section 9: Needs Validation, Hardening, and Coverage

Report three distinct groups:

1. `NEEDS VALIDATION`: title, source trace, exact blocker, and bounded owner check; no severity.
2. Hardening and positive controls: improvements that do not represent a demonstrated boundary failure.
3. Coverage: covered, candidate, blocked, deferred, not-applicable, and out-of-scope totals with important gaps and the coverage-critic result.

If the scan was scoped, budget-limited, interrupted, lacked independent verification, or could not safely execute target code, state that prominently. Zero confirmed findings is not a clean bill of health.

#### Section 10: Methodology

```markdown
## Methodology

This assessment was performed using security-check, an AI-powered static analysis
tool that uses large language model reasoning to detect security vulnerabilities.

### Pipeline Phases
1. **Reconnaissance** — Automated codebase architecture mapping and technology detection
2. **Vulnerability Hunting** — {N} specialized skills scanned for {N} vulnerability categories
3. **Verification** — False positive elimination with confidence scoring (0-100)
4. **Reporting** — CVSS-aligned severity classification and remediation prioritization

### Limitations
- Static analysis only — no runtime testing or dynamic analysis performed
- AI-based reasoning may miss vulnerabilities requiring deep domain knowledge
- Confidence scores are estimates, not guarantees
- Custom business logic flaws may require manual review
```

#### Section 11: Disclaimer

```markdown
## Disclaimer

This security assessment was performed using automated AI-powered static analysis.
It does not constitute a comprehensive penetration test or security audit. The findings
represent potential vulnerabilities identified through code pattern analysis and LLM
reasoning. False positives and false negatives are possible.

This report should be used as a starting point for security remediation, not as a
definitive statement of the application's security posture. A professional security
audit by qualified security engineers is recommended for production applications
handling sensitive data.

Generated by security-check — github.com/ersinkoc/security-check
```

## Formatting Guidelines

- Use clean, consistent markdown formatting
- Include code snippets with proper syntax highlighting
- Use tables for structured data presentation
- Keep descriptions concise but technically accurate
- Reference file paths with line numbers for easy navigation
- Link CWE and OWASP references where applicable

## Edge Cases

- **Zero findings:** Generate a report noting the clean scan with recommendations for defense-in-depth
- **Zero confirmed findings:** Say "no confirmed findings in reviewed coverage" and list remaining coverage and validation limits
- **Verifier incomplete:** Never promote raw candidates; mark the run incomplete
- **Only hardening notes:** Generate a report with an evidence-calibrated posture summary and the coverage limits
- **Hundreds of findings:** Limit detailed descriptions to top 20 critical/high findings; summarize the rest in tables
- **Missing architecture data:** Note that reconnaissance was incomplete and findings may lack context
