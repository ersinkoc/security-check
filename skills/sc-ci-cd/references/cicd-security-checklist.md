# CI/CD Pipeline Security Checklist

> 150+ security checks for CI/CD pipelines.
> Used by security-check sc-ci-cd skill as reference.

## How to Use
This checklist is automatically referenced by the sc-ci-cd skill during security scans.
Each item follows the format: `SC-CICD-{NNN}: Title — Description. Severity: Critical|High|Medium|Low. CWE: CWE-XXX.`

---

## Categories

### 1. GitHub Actions Security (30 items)

- [ ] SC-CICD-001: Pin GitHub Actions to commit SHA — Reference third-party actions by full commit SHA instead of mutable tags. Severity: Critical. CWE: CWE-829.
- [ ] SC-CICD-002: Restrict GITHUB_TOKEN permissions — Set minimum required permissions using the permissions key at workflow or job level. Severity: High. CWE: CWE-269.
- [ ] SC-CICD-003: Prevent script injection in workflows — Never use ${{ github.event }} context directly in run steps; use environment variables instead. Severity: Critical. CWE: CWE-78.
- [ ] SC-CICD-004: Restrict workflow_dispatch inputs — Validate and sanitize all inputs from manually triggered workflows. Severity: High. CWE: CWE-20.
- [ ] SC-CICD-005: Avoid pull_request_target with checkout of PR code — Never check out PR head ref in pull_request_target workflows as it runs with write access. Severity: Critical. CWE: CWE-863.
- [ ] SC-CICD-006: Use environments for deployment protection — Configure GitHub environments with required reviewers and wait timers for production deploys. Severity: High. CWE: CWE-285.
- [ ] SC-CICD-007: Restrict secrets to specific environments — Scope repository secrets to deployment environments rather than making them globally available. Severity: High. CWE: CWE-312.
- [ ] SC-CICD-008: Enable required status checks — Configure branch protection rules requiring specific CI checks to pass before merge. Severity: High. CWE: CWE-693.
- [ ] SC-CICD-009: Audit third-party Actions before use — Review the source code and permissions of all third-party Actions before adoption. Severity: High. CWE: CWE-829.
- [ ] SC-CICD-010: Use OIDC for cloud authentication — Use GitHub's OIDC provider for federated authentication to AWS, Azure, and GCP instead of long-lived secrets. Severity: High. CWE: CWE-798.
- [ ] SC-CICD-011: Restrict workflow concurrency — Use concurrency groups to prevent parallel runs that could cause race conditions. Severity: Medium. CWE: CWE-362.
- [ ] SC-CICD-012: Mask sensitive outputs — Use ::add-mask:: to redact sensitive values from workflow logs. Severity: Medium. CWE: CWE-532.
- [ ] SC-CICD-013: Do not use self-hosted runners for public repos — Self-hosted runners on public repositories allow arbitrary code execution by any contributor. Severity: Critical. CWE: CWE-250.
- [ ] SC-CICD-014: Validate GitHub webhook payloads — Verify webhook signatures to prevent forged event triggers. Severity: High. CWE: CWE-345.
- [ ] SC-CICD-015: Restrict workflow triggers to specific branches — Limit push and pull_request triggers to protected branches only. Severity: Medium. CWE: CWE-284.
- [ ] SC-CICD-016: Use reusable workflows for standardized security — Centralize security scanning in reusable workflow templates. Severity: Medium. CWE: CWE-693.
- [ ] SC-CICD-017: Prevent secret exfiltration via artifacts — Ensure workflow artifacts do not contain secrets or sensitive data. Severity: High. CWE: CWE-312.
- [ ] SC-CICD-018: Restrict Actions to allow-listed actions — Use the allowed actions policy to restrict which Actions can be used in the organization. Severity: High. CWE: CWE-829.
- [ ] SC-CICD-019: Monitor for workflow file modifications — Alert on changes to .github/workflows/ files that could introduce malicious steps. Severity: High. CWE: CWE-778.
- [ ] SC-CICD-020: Use job-level permissions — Set permissions at the job level rather than workflow level for finer-grained control. Severity: Medium. CWE: CWE-269.
- [ ] SC-CICD-021: Prevent cache poisoning attacks — Validate cache keys and restrict cache access to trusted branches. Severity: High. CWE: CWE-345.
- [ ] SC-CICD-022: Secure composite actions — Apply the same security controls to composite actions as to regular workflows. Severity: Medium. CWE: CWE-829.
- [ ] SC-CICD-023: Use step-level timeouts — Set timeout-minutes on individual steps to prevent hanging or runaway processes. Severity: Medium. CWE: CWE-400.
- [ ] SC-CICD-024: Restrict issue_comment triggers — Use author association checks before executing workflows triggered by issue comments. Severity: High. CWE: CWE-284.
- [ ] SC-CICD-025: Validate context expressions — Check for unsafe interpolation of github context in all workflow files. Severity: High. CWE: CWE-94.
- [ ] SC-CICD-026: Use environment protection rules — Require manual approval for workflows deploying to sensitive environments. Severity: High. CWE: CWE-285.
- [ ] SC-CICD-027: Restrict Actions fork pull request access — Limit secrets access for workflows triggered by pull requests from forks. Severity: Critical. CWE: CWE-312.
- [ ] SC-CICD-028: Audit GITHUB_TOKEN usage across workflows — Review all workflows using GITHUB_TOKEN to ensure minimal permission scope. Severity: Medium. CWE: CWE-269.
- [ ] SC-CICD-029: Prevent workflow re-run abuse — Restrict who can re-run failed workflows, especially those with secrets access. Severity: Medium. CWE: CWE-284.
- [ ] SC-CICD-030: Enable workflow run logging and retention — Configure appropriate log retention policies for audit and compliance. Severity: Low. CWE: CWE-778.

### 2. GitLab CI Security (20 items)

- [ ] SC-CICD-031: Protect CI/CD variables — Mark sensitive variables as protected and masked in GitLab CI settings. Severity: High. CWE: CWE-312.
- [ ] SC-CICD-032: Restrict variable access to protected branches — Limit CI/CD variable exposure to protected branches and tags only. Severity: High. CWE: CWE-312.
- [ ] SC-CICD-033: Use GitLab vault integration — Integrate with HashiCorp Vault for dynamic secret injection in pipelines. Severity: High. CWE: CWE-312.
- [ ] SC-CICD-034: Validate .gitlab-ci.yml includes — Audit all included CI templates for security issues before adoption. Severity: High. CWE: CWE-829.
- [ ] SC-CICD-035: Restrict runner registration tokens — Protect and rotate runner registration tokens; revoke compromised tokens immediately. Severity: Critical. CWE: CWE-798.
- [ ] SC-CICD-036: Use protected runners for sensitive jobs — Configure runners as protected so they only run jobs from protected branches. Severity: High. CWE: CWE-285.
- [ ] SC-CICD-037: Enable pipeline security scanning — Use GitLab SAST, DAST, dependency scanning, and container scanning in pipelines. Severity: High. CWE: CWE-1104.
- [ ] SC-CICD-038: Restrict merge request pipeline access — Limit pipeline execution for merge requests from forks to prevent secret exposure. Severity: High. CWE: CWE-312.
- [ ] SC-CICD-039: Implement merge request approvals for CI changes — Require code review approval for changes to .gitlab-ci.yml and CI templates. Severity: High. CWE: CWE-284.
- [ ] SC-CICD-040: Use CI_JOB_TOKEN with minimal scope — Restrict CI_JOB_TOKEN permissions to only required projects and registries. Severity: Medium. CWE: CWE-269.
- [ ] SC-CICD-041: Configure pipeline schedules securely — Restrict who can create and modify pipeline schedules to prevent unauthorized execution. Severity: Medium. CWE: CWE-284.
- [ ] SC-CICD-042: Use environment-specific deployments — Define GitLab environments with manual approval gates for production deployments. Severity: High. CWE: CWE-285.
- [ ] SC-CICD-043: Audit child and downstream pipelines — Review trigger configurations and variable passing between parent-child and multi-project pipelines. Severity: Medium. CWE: CWE-829.
- [ ] SC-CICD-044: Prevent trigger token abuse — Rotate pipeline trigger tokens regularly and restrict their scope. Severity: High. CWE: CWE-798.
- [ ] SC-CICD-045: Enable pipeline artifact expiry — Set artifact expiration to prevent indefinite storage of potentially sensitive build outputs. Severity: Medium. CWE: CWE-459.
- [ ] SC-CICD-046: Restrict tag creation for deployments — Limit who can create tags that trigger deployment pipelines. Severity: Medium. CWE: CWE-284.
- [ ] SC-CICD-047: Use GitLab compliance frameworks — Apply compliance pipeline configurations to enforce security policies across projects. Severity: Medium. CWE: CWE-693.
- [ ] SC-CICD-048: Validate Docker-in-Docker configurations — Secure DinD usage with TLS and restrict privileged mode to necessary jobs. Severity: High. CWE: CWE-250.
- [ ] SC-CICD-049: Monitor runner health and security — Track runner versions, configurations, and patch levels for security compliance. Severity: Medium. CWE: CWE-1104.
- [ ] SC-CICD-050: Implement pipeline-level RBAC — Use GitLab roles to control who can trigger, retry, and cancel pipelines. Severity: Medium. CWE: CWE-285.

### 3. General Pipeline Security (20 items)

- [ ] SC-CICD-051: Implement pipeline-as-code — Store all pipeline definitions in version control alongside application code. Severity: Medium. CWE: CWE-693.
- [ ] SC-CICD-052: Require code review for pipeline changes — Treat CI/CD configuration changes as code requiring peer review. Severity: High. CWE: CWE-284.
- [ ] SC-CICD-053: Implement least privilege for pipeline service accounts — Grant pipeline service accounts only the permissions required for their tasks. Severity: High. CWE: CWE-269.
- [ ] SC-CICD-054: Isolate pipeline stages — Run build, test, and deploy stages in separate isolated environments. Severity: Medium. CWE: CWE-668.
- [ ] SC-CICD-055: Implement mandatory security gates — Block pipeline progression unless security scans pass defined thresholds. Severity: High. CWE: CWE-693.
- [ ] SC-CICD-056: Validate pipeline inputs from external triggers — Sanitize all inputs from webhooks, API calls, and manual triggers. Severity: High. CWE: CWE-20.
- [ ] SC-CICD-057: Implement pipeline idempotency — Ensure pipelines produce the same result when re-run to prevent state manipulation. Severity: Medium. CWE: CWE-362.
- [ ] SC-CICD-058: Enforce build reproducibility — Use locked dependencies and deterministic builds to ensure consistent outputs. Severity: Medium. CWE: CWE-829.
- [ ] SC-CICD-059: Prevent parallel pipeline interference — Implement locking mechanisms to prevent concurrent deployments to the same target. Severity: Medium. CWE: CWE-362.
- [ ] SC-CICD-060: Implement break-glass procedures — Define emergency procedures for bypassing security gates with full audit logging. Severity: Medium. CWE: CWE-693.
- [ ] SC-CICD-061: Validate all external tool integrations — Audit and approve all external tools and services called from pipelines. Severity: High. CWE: CWE-829.
- [ ] SC-CICD-062: Implement pipeline notifications for failures — Alert security teams on security scan failures and policy violations. Severity: Medium. CWE: CWE-778.
- [ ] SC-CICD-063: Use ephemeral build environments — Create fresh build environments for each pipeline run and destroy them after completion. Severity: High. CWE: CWE-459.
- [ ] SC-CICD-064: Sign pipeline configurations — Use cryptographic signatures to verify pipeline configuration integrity. Severity: Medium. CWE: CWE-345.
- [ ] SC-CICD-065: Implement approval workflows for production — Require human approval before deploying to production environments. Severity: High. CWE: CWE-285.
- [ ] SC-CICD-066: Prevent environment variable injection — Sanitize environment variables that could be injected through branch names or commit messages. Severity: High. CWE: CWE-78.
- [ ] SC-CICD-067: Implement pipeline timeout limits — Set maximum execution time for entire pipelines and individual stages. Severity: Medium. CWE: CWE-400.
- [ ] SC-CICD-068: Restrict pipeline network access — Limit outbound network access from pipeline environments to required endpoints only. Severity: Medium. CWE: CWE-668.
- [ ] SC-CICD-069: Implement canary deployments — Use gradual rollout strategies to detect issues before full deployment. Severity: Medium. CWE: CWE-693.
- [ ] SC-CICD-070: Maintain pipeline change audit trail — Log all modifications to pipeline configurations with full attribution. Severity: Medium. CWE: CWE-778.

### 4. Secrets Management (20 items)

- [ ] SC-CICD-071: Never hardcode secrets in pipeline files — Use secret management features instead of inline credentials in CI/CD configs. Severity: Critical. CWE: CWE-798.
- [ ] SC-CICD-072: Rotate pipeline secrets regularly — Implement automated rotation for all secrets used in CI/CD pipelines. Severity: High. CWE: CWE-798.
- [ ] SC-CICD-073: Use short-lived credentials — Prefer temporary credentials (OIDC, STS) over long-lived API keys and passwords. Severity: High. CWE: CWE-798.
- [ ] SC-CICD-074: Mask secrets in pipeline logs — Ensure all CI/CD platforms are configured to mask secret values in log output. Severity: High. CWE: CWE-532.
- [ ] SC-CICD-075: Restrict secret access by branch — Limit which branches can access sensitive secrets to prevent exposure through feature branches. Severity: High. CWE: CWE-312.
- [ ] SC-CICD-076: Scan for secrets in source code — Run secret scanning tools (gitleaks, detect-secrets, TruffleHog) in every pipeline. Severity: Critical. CWE: CWE-798.
- [ ] SC-CICD-077: Implement secret zero bootstrap securely — Securely provision the initial secret needed to access the secret management system. Severity: High. CWE: CWE-312.
- [ ] SC-CICD-078: Audit secret access in pipelines — Log every access to secrets with pipeline ID, job, and timestamp. Severity: Medium. CWE: CWE-778.
- [ ] SC-CICD-079: Use separate secrets per environment — Maintain distinct credentials for development, staging, and production pipelines. Severity: High. CWE: CWE-312.
- [ ] SC-CICD-080: Prevent secret leakage through artifacts — Scan build artifacts and outputs to ensure they do not contain embedded secrets. Severity: High. CWE: CWE-312.
- [ ] SC-CICD-081: Implement secret access notifications — Alert security teams when sensitive secrets are accessed outside normal patterns. Severity: Medium. CWE: CWE-778.
- [ ] SC-CICD-082: Use envelope encryption for stored secrets — Encrypt secrets with a key encryption key that is separately managed. Severity: Medium. CWE: CWE-311.
- [ ] SC-CICD-083: Revoke compromised secrets immediately — Implement automated secret revocation procedures triggered by leak detection. Severity: Critical. CWE: CWE-798.
- [ ] SC-CICD-084: Prevent secrets in Docker build args — Never pass secrets via --build-arg; use BuildKit secret mounts instead. Severity: High. CWE: CWE-312.
- [ ] SC-CICD-085: Validate secret manager connectivity — Ensure pipelines fail safely if the secret manager is unreachable rather than using fallback values. Severity: Medium. CWE: CWE-636.
- [ ] SC-CICD-086: Implement secret versioning — Track secret versions to support rollback and forensic analysis. Severity: Low. CWE: CWE-778.
- [ ] SC-CICD-087: Restrict who can modify pipeline secrets — Limit secret management permissions to security administrators. Severity: High. CWE: CWE-285.
- [ ] SC-CICD-088: Do not echo secrets in debug mode — Ensure debug/verbose pipeline modes do not expose secret values. Severity: High. CWE: CWE-532.
- [ ] SC-CICD-089: Use service-specific credentials — Create dedicated credentials for each service rather than sharing a single set across pipelines. Severity: Medium. CWE: CWE-269.
- [ ] SC-CICD-090: Implement secret expiration policies — Set TTLs on secrets to force regular rotation and reduce window of exposure. Severity: Medium. CWE: CWE-798.

### 5. Artifact Security (15 items)

- [ ] SC-CICD-091: Sign build artifacts — Digitally sign all build artifacts to verify integrity and provenance. Severity: High. CWE: CWE-345.
- [ ] SC-CICD-092: Verify artifact integrity before deployment — Check signatures or checksums of artifacts before deploying them. Severity: High. CWE: CWE-345.
- [ ] SC-CICD-093: Store artifacts in secure repositories — Use access-controlled artifact repositories with encryption at rest. Severity: High. CWE: CWE-311.
- [ ] SC-CICD-094: Implement artifact retention policies — Set expiration for build artifacts to prevent accumulation of vulnerable versions. Severity: Medium. CWE: CWE-459.
- [ ] SC-CICD-095: Scan artifacts for vulnerabilities — Run vulnerability scans on compiled artifacts, containers, and packages before publication. Severity: High. CWE: CWE-1104.
- [ ] SC-CICD-096: Implement artifact provenance tracking — Generate and store SLSA provenance attestations for all build artifacts. Severity: Medium. CWE: CWE-345.
- [ ] SC-CICD-097: Restrict artifact publication permissions — Limit who and which pipelines can publish artifacts to production repositories. Severity: High. CWE: CWE-285.
- [ ] SC-CICD-098: Prevent artifact tampering between stages — Ensure artifacts cannot be modified between build and deployment stages. Severity: High. CWE: CWE-345.
- [ ] SC-CICD-099: Generate SBOM for all artifacts — Create Software Bill of Materials for all published artifacts for supply chain transparency. Severity: Medium. CWE: CWE-1104.
- [ ] SC-CICD-100: Scan artifacts for embedded secrets — Check artifacts and container images for accidentally included credentials. Severity: High. CWE: CWE-798.
- [ ] SC-CICD-101: Implement artifact promotion workflow — Promote artifacts through environments (dev, staging, prod) rather than rebuilding. Severity: Medium. CWE: CWE-345.
- [ ] SC-CICD-102: Restrict artifact download access — Require authentication and authorization to download production artifacts. Severity: Medium. CWE: CWE-285.
- [ ] SC-CICD-103: Enable artifact audit logging — Log all artifact uploads, downloads, and deletions with full context. Severity: Medium. CWE: CWE-778.
- [ ] SC-CICD-104: Validate artifact naming conventions — Enforce naming standards to prevent path traversal or injection through artifact names. Severity: Medium. CWE: CWE-22.
- [ ] SC-CICD-105: Implement artifact quarantine — Hold newly built artifacts in quarantine until security scans complete successfully. Severity: Medium. CWE: CWE-693.

### 6. Dependency Security (15 items)

- [ ] SC-CICD-106: Scan dependencies for known vulnerabilities — Run SCA tools (Dependabot, Snyk, OWASP Dependency-Check) in every pipeline. Severity: Critical. CWE: CWE-1104.
- [ ] SC-CICD-107: Use lock files for deterministic builds — Commit and verify lock files (package-lock.json, Cargo.lock, go.sum) for all projects. Severity: High. CWE: CWE-829.
- [ ] SC-CICD-108: Verify dependency integrity — Check checksums and signatures of downloaded dependencies against lock files. Severity: High. CWE: CWE-345.
- [ ] SC-CICD-109: Use private dependency mirrors — Host dependencies in private mirrors or proxies to prevent supply chain attacks. Severity: High. CWE: CWE-829.
- [ ] SC-CICD-110: Prevent dependency confusion attacks — Configure package managers to prefer private registries and verify package scopes. Severity: Critical. CWE: CWE-427.
- [ ] SC-CICD-111: Monitor for typosquatting packages — Detect and block dependencies that are typosquatting variants of legitimate packages. Severity: High. CWE: CWE-829.
- [ ] SC-CICD-112: Enforce license compliance — Scan dependencies for license compliance and block unapproved licenses. Severity: Medium. CWE: CWE-1059.
- [ ] SC-CICD-113: Pin dependency versions — Use exact version pinning rather than ranges to prevent unexpected updates. Severity: Medium. CWE: CWE-829.
- [ ] SC-CICD-114: Implement dependency update review process — Require security review for dependency updates, especially major version changes. Severity: Medium. CWE: CWE-829.
- [ ] SC-CICD-115: Detect abandoned or unmaintained dependencies — Flag dependencies that have not been updated or maintained for extended periods. Severity: Medium. CWE: CWE-1104.
- [ ] SC-CICD-116: Verify dependency source repositories — Validate that dependencies are sourced from legitimate, verified repositories. Severity: High. CWE: CWE-829.
- [ ] SC-CICD-117: Implement dependency caching securely — Ensure cached dependencies are verified on restoration to prevent cache poisoning. Severity: Medium. CWE: CWE-345.
- [ ] SC-CICD-118: Block dependencies with known malicious versions — Maintain and enforce a blocklist of known-malicious package versions. Severity: Critical. CWE: CWE-506.
- [ ] SC-CICD-119: Generate dependency vulnerability reports — Produce reports of dependency vulnerabilities for each build with remediation guidance. Severity: Medium. CWE: CWE-1104.
- [ ] SC-CICD-120: Implement dependency firewall — Use package firewall services to block malicious or policy-violating packages at the registry level. Severity: High. CWE: CWE-829.

### 7. Branch Protection (10 items)

- [ ] SC-CICD-121: Enforce branch protection on main branches — Require pull requests and status checks before merging to main, master, and release branches. Severity: Critical. CWE: CWE-284.
- [ ] SC-CICD-122: Require code review approvals — Mandate a minimum number of approving reviews before merge. Severity: High. CWE: CWE-284.
- [ ] SC-CICD-123: Prevent force pushes to protected branches — Disable force push and branch deletion on critical branches. Severity: High. CWE: CWE-284.
- [ ] SC-CICD-124: Require signed commits — Enforce GPG or SSH commit signature verification on protected branches. Severity: Medium. CWE: CWE-345.
- [ ] SC-CICD-125: Dismiss stale reviews on new commits — Automatically dismiss approvals when new commits are pushed to a pull request. Severity: Medium. CWE: CWE-284.
- [ ] SC-CICD-126: Require CODEOWNERS review — Enforce approval from designated code owners for changes to sensitive files. Severity: High. CWE: CWE-284.
- [ ] SC-CICD-127: Restrict who can merge to protected branches — Limit merge permissions to specific teams or roles. Severity: High. CWE: CWE-284.
- [ ] SC-CICD-128: Require linear commit history — Enforce squash or rebase merges to maintain a clean, auditable commit history. Severity: Low. CWE: CWE-693.
- [ ] SC-CICD-129: Enforce status checks from required CI pipelines — Block merges when mandatory security and quality checks have not passed. Severity: High. CWE: CWE-693.
- [ ] SC-CICD-130: Restrict branch creation patterns — Limit who can create branches matching deployment patterns (release/*, hotfix/*). Severity: Medium. CWE: CWE-284.

### 8. Runner/Agent Security (10 items)

- [ ] SC-CICD-131: Harden runner operating systems — Apply CIS benchmarks and security hardening guides to all CI/CD runner hosts. Severity: High. CWE: CWE-16.
- [ ] SC-CICD-132: Use ephemeral runners — Create fresh runner instances for each job and destroy them after completion. Severity: High. CWE: CWE-459.
- [ ] SC-CICD-133: Isolate runners per security tier — Use separate runner pools for different trust levels (public, internal, production). Severity: High. CWE: CWE-668.
- [ ] SC-CICD-134: Keep runners patched and updated — Maintain current OS and runner software versions on all CI/CD agents. Severity: High. CWE: CWE-1104.
- [ ] SC-CICD-135: Restrict runner network access — Limit runner egress to only required endpoints using firewall rules. Severity: Medium. CWE: CWE-668.
- [ ] SC-CICD-136: Monitor runner resource usage — Track CPU, memory, and disk usage on runners to detect crypto-mining or abuse. Severity: Medium. CWE: CWE-400.
- [ ] SC-CICD-137: Disable unnecessary services on runners — Remove or disable services not required for CI/CD execution. Severity: Medium. CWE: CWE-1104.
- [ ] SC-CICD-138: Implement runner access controls — Restrict which projects and users can execute jobs on specific runners. Severity: High. CWE: CWE-285.
- [ ] SC-CICD-139: Encrypt runner-to-server communication — Ensure all communication between runners and CI/CD servers uses TLS. Severity: High. CWE: CWE-319.
- [ ] SC-CICD-140: Audit runner registration and deregistration — Log all runner lifecycle events including registration, updates, and removal. Severity: Medium. CWE: CWE-778.

### 9. Deployment Security (15 items)

- [ ] SC-CICD-141: Implement deployment approval gates — Require manual or automated approval before deploying to production. Severity: High. CWE: CWE-285.
- [ ] SC-CICD-142: Use immutable deployments — Deploy immutable artifacts rather than modifying running systems in place. Severity: Medium. CWE: CWE-345.
- [ ] SC-CICD-143: Implement deployment rollback capability — Ensure every deployment can be quickly rolled back to the previous version. Severity: Medium. CWE: CWE-693.
- [ ] SC-CICD-144: Validate deployment configurations — Check deployment manifests and configurations for security misconfigurations before applying. Severity: High. CWE: CWE-16.
- [ ] SC-CICD-145: Encrypt deployment credentials in transit — Use encrypted channels for all credentials transmitted during deployment. Severity: High. CWE: CWE-319.
- [ ] SC-CICD-146: Implement blue-green deployments — Use blue-green or canary strategies to minimize the blast radius of failed deployments. Severity: Medium. CWE: CWE-693.
- [ ] SC-CICD-147: Validate infrastructure-as-code templates — Scan Terraform, CloudFormation, and Pulumi templates for security issues before applying. Severity: High. CWE: CWE-16.
- [ ] SC-CICD-148: Restrict deployment target access — Limit which pipelines and service accounts can deploy to each environment. Severity: High. CWE: CWE-285.
- [ ] SC-CICD-149: Implement deployment drift detection — Detect and alert when deployed configurations drift from the desired state defined in code. Severity: Medium. CWE: CWE-693.
- [ ] SC-CICD-150: Log all deployment activities — Record who deployed what, when, and to which environment with full context. Severity: High. CWE: CWE-778.
- [ ] SC-CICD-151: Run smoke tests after deployment — Execute automated security and health checks immediately after each deployment. Severity: Medium. CWE: CWE-693.
- [ ] SC-CICD-152: Prevent deployment of unscanned artifacts — Block deployments of artifacts that have not passed security scanning. Severity: High. CWE: CWE-1104.
- [ ] SC-CICD-153: Implement deployment windows — Restrict production deployments to approved maintenance windows with exception procedures. Severity: Low. CWE: CWE-693.
- [ ] SC-CICD-154: Secure deployment webhook endpoints — Authenticate and validate all webhook-triggered deployments. Severity: High. CWE: CWE-345.
- [ ] SC-CICD-155: Implement deployment isolation between tenants — Ensure multi-tenant deployments maintain strict isolation during the deployment process. Severity: High. CWE: CWE-668.

---

**Total: 155 items across 9 categories.**
