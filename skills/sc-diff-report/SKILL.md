---
name: sc-diff-report
description: Incremental security scan for changed files only — optimized for PR and commit-level reviews
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Diff Report — Incremental Security Scan

## Purpose

Performs a targeted security scan on only the files changed in a git diff, pull request, or recent commit. This enables fast, focused security feedback during code review without the overhead of a full codebase scan. Classifies findings as "new" (introduced by changes) vs "existing" (pre-existing in touched files).

## Activation

Activates when the user issues any of:
- "scan diff"
- "scan changes"
- "PR scan"
- "scan commit"
- "incremental scan"

## Output

File: `security-report/diff-report.md`

## Phase 1: Change Detection

### Git Diff Extraction

Determine the diff scope based on user context:

**PR Mode (most common):**
```bash
git diff main...HEAD --name-only
git diff main...HEAD
```

**Staged changes:**
```bash
git diff --cached --name-only
git diff --cached
```

**Last commit:**
```bash
git diff HEAD~1 --name-only
git diff HEAD~1
```

**Custom range:**
```bash
git diff {base}...{head} --name-only
git diff {base}...{head}
```

### Changed File Inventory

From the diff output, build an inventory:

1. **Added files** — entirely new files (highest priority)
2. **Modified files** — existing files with changes
3. **Deleted files** — removed files (check for orphaned references)
4. **Renamed files** — detect renames with content changes

For each changed file, record:
- File path
- Change type (added/modified/deleted/renamed)
- Lines added (line numbers)
- Lines removed (line numbers)
- Total change size (lines added + removed)

### Change Filtering

Filter out changes unlikely to have security impact:
- Documentation files (`.md`, `.txt`, `.rst`) — skip unless they contain config
- Test files — scan but mark as test context
- Generated files — skip (check for `generated` markers)
- Lock files — delegate to sc-dependency-audit pattern matching
- Static assets (images, fonts, CSS) — skip
- Configuration files — keep, high priority for security review

### Dependency Change Detection

If lock files or manifests changed:
- `package.json` / `package-lock.json` — extract added/removed/updated packages
- `go.mod` / `go.sum` — extract module changes
- `Cargo.toml` / `Cargo.lock` — extract crate changes
- `requirements.txt` / `poetry.lock` — extract package changes
- Flag newly added dependencies for supply chain review

## Phase 2: Targeted Vulnerability Scanning

### Skill Selection

Based on changed files, activate only relevant skills:

| Changed File Pattern | Skills to Activate |
|---------------------|-------------------|
| `*.go` | sc-lang-go, sc-sqli, sc-cmdi, sc-ssrf, sc-auth, sc-race-condition |
| `*.ts`, `*.tsx`, `*.js`, `*.jsx` | sc-lang-typescript, sc-xss, sc-sqli, sc-secrets, sc-auth |
| `*.py` | sc-lang-python, sc-sqli, sc-cmdi, sc-ssti, sc-deserialization |
| `*.php` | sc-lang-php, sc-sqli, sc-xss, sc-cmdi, sc-deserialization, sc-path-traversal |
| `*.rs` | sc-lang-rust, sc-cmdi, sc-race-condition |
| `*.java`, `*.kt` | sc-lang-java, sc-sqli, sc-deserialization, sc-xxe, sc-rce |
| `*.cs` | sc-lang-csharp, sc-sqli, sc-deserialization, sc-xxe |
| `Dockerfile*`, `docker-compose*` | sc-docker |
| `*.tf`, `*.tfvars` | sc-iac |
| `.github/workflows/*`, `.gitlab-ci.yml` | sc-ci-cd |
| `*.graphql`, `*resolver*`, `*schema*` | sc-graphql |
| `*.proto` | sc-api-security |
| `.env*`, `*config*`, `*secret*` | sc-secrets, sc-data-exposure |
| `*auth*`, `*login*`, `*session*` | sc-auth, sc-session, sc-jwt |
| `*upload*` | sc-file-upload |
| `*redirect*`, `*callback*` | sc-open-redirect |

### Focused Scanning

For each activated skill:
1. Provide the skill with ONLY the changed files and their full content
2. Also provide the diff hunks showing exactly what changed
3. Instruct the skill to focus on the changed lines but consider surrounding context
4. The skill runs its standard Phase 1 (Discovery) and Phase 2 (Verification) but scoped to changed files

### New vs Existing Classification

For each finding:

**New finding (introduced by this change):**
- The vulnerable code is in an added line (green in diff)
- A new file introduces a vulnerability pattern
- A modification removes a security control
- A configuration change weakens security

**Existing finding (pre-existing, found while scanning touched file):**
- The vulnerable code is in an unchanged line within a modified file
- The finding exists in surrounding context, not in the diff itself

**Regression (re-introduced):**
- A previously fixed vulnerability pattern reappears
- A security control that was present is now removed

## Phase 3: Quick Verification

Apply a lightweight version of sc-verifier logic:
1. Reachability: Is the changed code reachable from an entry point?
2. Sanitization: Is there sanitization in the data flow?
3. Framework protection: Does the framework auto-protect against this?
4. Context: Is this test code or production code?
5. Confidence scoring (same 0-100 scale)

## Output Format

```markdown
# Security Diff Report

**Branch:** {branch name}
**Base:** {base branch/commit}
**Date:** {scan date}
**Files Changed:** {N}
**Files Scanned:** {N} (after filtering)

## Summary

| Category | New | Existing | Total |
|----------|-----|----------|-------|
| Critical | {N} | {N} | {N} |
| High | {N} | {N} | {N} |
| Medium | {N} | {N} | {N} |
| Low | {N} | {N} | {N} |

## Verdict

{PASS | WARN | FAIL}

- **PASS**: No new Critical or High findings
- **WARN**: New Medium findings or existing High findings in touched files
- **FAIL**: New Critical or High findings introduced by this change

## New Findings (Introduced by This Change)

### DIFF-001: {Title}
- **Severity:** {severity}
- **Confidence:** {score}/100
- **Classification:** NEW
- **File:** {path}:{line}
- **Diff Context:**
```diff
{relevant diff hunk}
```
- **Description:** {what's wrong}
- **Remediation:** {how to fix before merging}

## Existing Findings (Pre-existing in Touched Files)

### DIFF-NNN: {Title}
- **Classification:** EXISTING
- **Note:** This finding predates this change but was discovered while scanning modified files.
{abbreviated finding details}

## Dependency Changes

| Package | Change | Risk |
|---------|--------|------|
| {name} | Added v{X} | {assessment} |
| {name} | Updated {old} → {new} | {assessment} |
| {name} | Removed | No risk |

## Changed Files Not Scanned
{List of filtered files with reason (docs, generated, assets)}
```

## PR Comment Format

For integration with PR workflows, also produce a concise summary suitable for a PR comment:

```markdown
## Security Scan Results

{PASS ✓ | WARN ⚠ | FAIL ✗}

**New findings:** {N} ({breakdown})
**Existing findings in touched files:** {N}

{If FAIL: list top 3 new critical/high findings with file:line}
{If WARN: brief note on what to review}
{If PASS: "No new security issues detected in this change."}
```

## Performance Considerations

- Diff mode should complete significantly faster than a full scan
- Only read changed files and their immediate imports
- Skip skills that are irrelevant to the changed file types
- Limit context expansion to 2 levels of function calls from changed code
- Target scan time: under 2 minutes for typical PRs (< 50 files changed)

## Common False Positives in Diff Mode

1. **Refactored code flagged as new vulnerability** — code was moved, not introduced
2. **Test additions** flagged — new tests often contain intentionally vulnerable patterns
3. **Configuration for development** — dev-only settings in changed config files
4. **Renamed variables** — security-sensitive variable renamed but same protection in place
5. **Import reordering** — framework imports moved but middleware still applied
