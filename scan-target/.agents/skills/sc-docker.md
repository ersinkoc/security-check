---
name: sc-docker
description: Docker-specific security checks — image hardening, secrets in layers, compose security, and runtime configuration
---

# SC: Docker Security

## Purpose

Performs Docker-specific security analysis covering Dockerfile best practices, secrets exposure in image layers, docker-compose security configuration, runtime security settings, and container image hardening. Extends beyond general IaC scanning with deep Docker expertise.

## Activation

Called by sc-orchestrator during Phase 2 when Dockerfile or docker-compose files are detected.

## Phase 1: Discovery

### File Patterns
```
**/Dockerfile*, **/docker-compose*, **/.dockerignore,
**/docker/*, **/*.dockerfile
```

### Dockerfile Security Checks

**1. Running as Root:**
Check for missing `USER` directive after base image.

**2. Secrets in Build:**
```dockerfile
# VULNERABLE: Secret in ENV or ARG
ENV DATABASE_PASSWORD=mysecret
ARG API_KEY=sk_live_abc123
COPY .env /app/.env

# SAFE: Use build secrets (BuildKit)
RUN --mount=type=secret,id=db_password cat /run/secrets/db_password
```

**3. ADD vs COPY:**
```dockerfile
# RISKY: ADD can auto-extract and fetch URLs
ADD https://example.com/app.tar.gz /app/
ADD . /app/

# SAFE: COPY is explicit
COPY . /app/
```

**4. Missing .dockerignore:**
Without `.dockerignore`, sensitive files get copied into the image:
`.env`, `.git/`, `node_modules/`, `*.pem`, `*.key`

**5. Unverified Base Image:**
```dockerfile
# RISKY: Unverified image
FROM someuser/myimage:latest

# SAFE: Official image with digest
FROM node:18-alpine@sha256:abc123...
```

### Docker Compose Security
```yaml
# VULNERABLE patterns
services:
  app:
    privileged: true          # Full host access
    network_mode: host        # Shares host network
    pid: host                 # Shares host PID namespace
    volumes:
      - /:/host               # Mounts host root
    cap_add:
      - ALL                   # All capabilities
    env_file:
      - .env                  # Secrets in env file (check .gitignore)

# SAFE patterns
services:
  app:
    read_only: true
    security_opt:
      - no-new-privileges:true
    cap_drop:
      - ALL
    cap_add:
      - NET_BIND_SERVICE      # Only what's needed
    tmpfs:
      - /tmp
```

## Severity Classification

- **Critical:** Secrets in image layers, privileged mode, host root mount
- **High:** Running as root, host network/PID, missing .dockerignore with secrets
- **Medium:** Using latest tag, ADD instead of COPY, missing health check
- **Low:** Missing resource limits, non-optimal layer ordering

## Output Format

### Finding: DOCK-{NNN}
- **Title:** Docker {vulnerability type}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-250 (Excessive Privileges) | CWE-732 (Incorrect Permission)
- **Description:** {What was found}
- **Impact:** Container escape, secret exposure, host compromise.
- **Remediation:** {Specific Dockerfile/compose fix}
- **References:** https://docs.docker.com/develop/security-best-practices/

## Common False Positives

1. **Build-stage root** — multi-stage builds running as root in build stage but non-root in final
2. **CI/CD containers** — build containers with elevated privileges for CI tasks
3. **Development compose** — development overrides with relaxed security
