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
- Missing security headers (clickjacking, CSP)
- Verbose error messages with limited information
- Outdated dependencies without known exploitable CVE
- Best practice violations
- Informational findings

**Info (CVSS 0.0):**
- Findings with confidence < 30
- Positive security observations
- Recommendations for defense-in-depth

### 3. Risk Score Calculation

Calculate an overall project risk score (1-10):

```
risk_score = base_from_findings + modifiers

Base score from findings:
- Each Critical finding: +2.0 (max 10)
- Each High finding: +1.0
- Each Medium finding: +0.3
- Each Low finding: +0.1

Modifiers:
- No authentication controls detected: +1.0
- No input validation framework: +0.5
- Outdated framework with known CVEs: +1.0
- Strong security controls in place: -1.0
- Good test coverage of security features: -0.5

Clamp to range 1-10.
```

### 4. Report Structure

Generate the report with the following sections:

---

#### Section 1: Executive Summary

```markdown
# Security Assessment Report

**Project:** {project name from architecture.md}
**Date:** {scan date}
**Scanner:** security-check v1.0.0
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
| Info | {N} |

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

| Vulnerability Category | Critical | High | Medium | Low | Info |
|-----------------------|----------|------|--------|-----|------|
| Injection | | | | | |
| Authentication | | | | | |
| Authorization | | | | | |
| Data Exposure | | | | | |
| Cryptography | | | | | |
| Infrastructure | | | | | |
| Dependencies | | | | | |
| ... | | | | | |
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

#### Section 7: Informational

Brief list of informational findings and positive security observations.

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

#### Section 9: Methodology

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

#### Section 10: Disclaimer

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
- **Only informational findings:** Generate a report with a positive security posture assessment
- **Hundreds of findings:** Limit detailed descriptions to top 20 critical/high findings; summarize the rest in tables
- **Missing architecture data:** Note that reconnaissance was incomplete and findings may lack context
