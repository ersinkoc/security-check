---
name: sc-verifier
description: False positive elimination and confidence scoring for all security findings
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Verifier — False Positive Elimination & Confidence Scoring

## Purpose

The verifier skill processes all raw candidates from Phase 2, tries to disprove them, merges duplicate root causes, and assigns explicit final verdicts. This is the quality gate that prevents suspicious patterns, missing hardening, and unresolved deployment assumptions from being presented as vulnerabilities.

Apply the evidence contract in `sc-orchestrator`. When the host supports independent agents, the final verifier must not be the hunter that proposed the candidate. Otherwise use a fresh, separate verification pass and disclose the limitation.

## Activation

Runs in Phase 3 of the pipeline, after all Phase 2 vulnerability skills have completed.

## Input

- All files matching `security-report/findings/*.json`
- `security-report/architecture.md`
- `security-report/coverage-ledger.md`

## Output

- `security-report/findings.json` — structured final verdicts
- `security-report/verified-findings.md` — human-readable verification record

## Verdict Gate

Every candidate receives exactly one verdict:

- `confirmed`: complete source trace plus safe bounded evidence establish a meaningful trust-boundary failure. Severity is required.
- `needs_validation`: a specific runtime, provider, identity, OS, broker, or deployment fact remains decisive. Severity is forbidden; include the exact blocker and safe next check.
- `rejected`: reachability, controls, authority, context, or reproduction disproves the claim. Severity is forbidden; include the rejection reason.

Confidence may prioritize review but cannot fill a missing evidence field or promote a lead.

## Verification Process

### Step 1: Finding Collection

1. Read all candidate JSON files from `security-report/findings/`
2. Parse each finding into a structured format (title, severity, confidence, file, line, type, description)
3. Skip files containing "No issues found"
4. Create a unified finding list with source skill attribution
5. Reject malformed candidates that do not identify an attacker, affected principal/resource, ordered source trace, control analysis, sink, result, and conditions

### Step 2: Reachability Analysis

For each finding, determine if the vulnerable code is actually reachable:

**Check if code is in an executable path:**
- Is the file imported/included by any other file?
- Is the function called from an entry point (HTTP handler, CLI command, etc.)?
- Is the file part of the build output (not excluded by build config)?
- Trace the call chain from entry point to vulnerable code

**Reachability scoring:**
- Directly reachable from HTTP handler: +30 confidence
- Reachable through 1-2 function calls: +20 confidence
- Reachable through 3+ function calls: +10 confidence
- No clear call path found: -20 confidence
- Dead code (no imports/calls): -40 confidence

### Step 3: Sanitization Check

For each finding involving user input, check if input is sanitized:

**Sanitization indicators:**
- Input passes through validation library (Zod, Joi, Pydantic, Bean Validation)
- Input is parameterized (prepared statements, ORM methods)
- Input passes through encoding/escaping function (htmlspecialchars, html/template, DOMPurify)
- Input is type-cast to safe type (parseInt, strconv.Atoi)

**Sanitization scoring:**
- No sanitization found: +0 (no change)
- Partial sanitization (some paths sanitized, others not): -10 confidence
- Full sanitization before reaching sink: -40 confidence
- Framework auto-sanitization active: -30 confidence

### Step 4: Framework Protection Check

Check if the framework provides automatic protection against the reported vulnerability:

| Vulnerability | Framework Protection |
|--------------|---------------------|
| XSS | React JSX auto-escaping, Angular sanitization, Django template auto-escaping, Blade {{ }} escaping |
| SQL Injection | ORM parameterized queries (Prisma, GORM, Hibernate, EF), prepared statement wrappers |
| CSRF | Django CSRF middleware, Spring Security CSRF, Laravel VerifyCsrfToken, Express csurf |
| SSTI | Jinja2 sandbox mode, restricted template engines |
| Path Traversal | Framework static file servers with built-in path validation |
| Header Injection | Modern HTTP libraries that reject newlines in headers |

**Framework protection scoring:**
- Framework auto-protection confirmed active: -30 confidence
- Framework protection exists but may be bypassed: -10 confidence
- No framework protection for this vulnerability type: +0

### Step 5: Configuration Override Check

Check if configuration-level protections mitigate the finding:

- **CSP headers** mitigating XSS findings
- **CORS strict configuration** mitigating cross-origin findings
- **WAF rules** potentially blocking exploitation
- **Network segmentation** limiting SSRF impact
- **File system permissions** limiting path traversal impact

**Configuration scoring:**
- Strong configuration mitigation: -20 confidence
- Partial configuration mitigation: -10 confidence
- No configuration-level mitigation: +0

### Step 6: Context Analysis

Determine the context of the vulnerable code:

**Test code:**
- File is in `test/`, `tests/`, `__tests__/`, `spec/`, `*_test.go`, `*_test.py`, `*.test.ts`
- File name contains `test`, `spec`, `mock`, `fixture`
- Finding in test code: -50 confidence (retain a non-production pattern only as an unscored hardening note)

**Dead code:**
- Function is never called from any reachable path
- File is not imported anywhere
- Code is commented out
- Finding in dead code: -40 confidence

**Example/Documentation code:**
- File is in `examples/`, `docs/`, `demo/`, `sample/`
- Finding in example code: -50 confidence

**Generated code:**
- File is in `generated/`, `gen/`, `__generated__/`
- File has `// Code generated` or `@Generated` annotation
- Finding in generated code: -30 confidence (flag for upstream fix)

**Vendor/third-party code:**
- File is in `vendor/`, `node_modules/`, `third_party/`
- Finding in vendored code: -40 confidence (should be covered by sc-dependency-audit)

### Step 7: Duplicate Detection & Merging

Identify and merge findings that share the same root cause:

**Duplicate criteria:**
- Same file + same line number → merge, keep highest severity
- Same vulnerability type + same source variable → merge if same data flow
- Same vulnerability pattern across multiple files → group as one finding with multiple locations
- Findings from different skills about the same code → merge, note both perspectives

**Merge rules:**
- Keep the highest severity rating
- Keep the highest confidence score
- Combine descriptions from multiple skills
- List all affected files/lines

### Step 8: Final Confidence Scoring

Calculate final confidence score for each finding:

**Base confidence from the reporting skill:** 0-100
**Apply modifiers from steps 2-6:**

```
final_confidence = base_confidence
    + reachability_modifier    (-40 to +30)
    + sanitization_modifier    (-40 to +0)
    + framework_modifier       (-30 to +0)
    + configuration_modifier   (-20 to +0)
    + context_modifier         (-50 to +0)
```

**Clamp to 0-100 range.**

**Confidence classification:**
- 90-100: **Very High** — Strong evidence, still subject to the verdict gate
- 70-89: **High Probability** — Very likely vulnerable, minor conditions may apply
- 50-69: **Probable** — Likely vulnerable, additional manual verification recommended
- 30-49: **Possible** — May be a false positive, requires manual review
- 0-29: **Low Confidence** — Reject or retain as an unscored validation lead

### Step 9: Severity Recalculation

After confidence scoring, recalculate severity only for records that pass the `confirmed` verdict gate:

- Findings with confidence < 30: move to `needs_validation` or `rejected`; do not assign severity
- Findings with confidence 30-49: cap severity at "Medium"
- Findings with confidence 50-69: cap severity at "High"
- Findings with confidence 70+: keep original severity

### Step 10: Adversarial Disposition

For every surviving candidate, answer these questions from current evidence:

1. Can the claimed lower-trust actor reach the entry point under stated conditions?
2. Does the exact attacker-controlled value or state reach the final sensitive sink?
3. Do framework, middleware, operating-system, deployment, or provider controls stop it?
4. Is authorization bound to the final principal, action, and resource?
5. Does the actor already possess equivalent authority by design?
6. Is there a meaningful confidentiality, integrity, availability, or operator-cost result?
7. Was any local validation bounded, credential-free, isolated, and non-destructive?

Then assign `confirmed`, `needs_validation`, or `rejected`. Deduplicate by root cause and boundary, not merely CWE, title, or nearby line numbers.

## Output Format

```markdown
# Verified Security Findings

## Summary
- Total raw findings from Phase 2: {N}
- After duplicate merging: {N}
- After false positive elimination: {N}
- Final verified findings: {N}

## Confidence Distribution
- Very High (90-100): {N}
- High Probability (70-89): {N}
- Probable (50-69): {N}
- Possible (30-49): {N}
- Low Confidence (0-29): {N}

## Verified Findings

### VULN-001: {Title}
- **Severity:** Critical | High | Medium | Low (confirmed only)
- **Confidence:** {score}/100 ({classification})
- **Original Skill:** {skill-name}
- **Vulnerability Type:** CWE-XXX
- **File:** file/path:line
- **Reachability:** Direct | Indirect | Unknown
- **Sanitization:** None | Partial | Full
- **Framework Protection:** None | Partial | Active
- **Description:** Verified description
- **Verification Notes:** What was checked, why this is/isn't a false positive
- **Remediation:** How to fix

## Eliminated Findings (False Positives)
Brief list of eliminated findings with reason for elimination.
```

Also write `findings.json`:

```json
{
  "run_status": "complete",
  "confirmed": [],
  "needs_validation": [],
  "rejected": [],
  "hardening": [],
  "coverage_summary": {
    "covered": 0,
    "candidate": 0,
    "blocked": 0,
    "deferred": 0,
    "out_of_scope": 0
  }
}
```

Set `run_status` to `incomplete` when mandatory coverage or candidate validation remains unresolved. A `needs_validation` record is a valid final disposition, but an unreviewed candidate is not.

## Common False Positive Patterns

1. **ORM methods flagged as SQL injection** — ORMs auto-parameterize; only `raw()` or `RawSQL` methods are risky
2. **Template auto-escaping not recognized** — React JSX, Django `{{ }}`, Blade `{{ }}` auto-escape by default
3. **Test fixtures flagged as hardcoded secrets** — test API keys, mock tokens are expected in test code
4. **Localhost URLs flagged as SSRF** — development URLs (localhost:3000) in config are not exploitable
5. **Error messages in development config** — debug=True in dev config, not in production
6. **Type-safe languages reducing injection risk** — Go's strconv, Rust's type system prevent many injection types
7. **Environment variable reads flagged as secrets** — `os.Getenv("SECRET")` reads at runtime, not hardcoded
