# Docker/Container Security Checklist

> 150+ security checks for Docker and container deployments.
> Used by security-check sc-docker skill as reference.

## How to Use
This checklist is automatically referenced by the sc-docker skill during security scans.
Each item follows the format: `SC-DOCK-{NNN}: Title — Description. Severity: Critical|High|Medium|Low. CWE: CWE-XXX.`

---

## Categories

### 1. Image Security (20 items)

- [ ] SC-DOCK-001: Use minimal base images — Use distroless, Alpine, or scratch images to minimize the attack surface. Severity: High. CWE: CWE-1104.
- [ ] SC-DOCK-002: Scan images for known vulnerabilities — Run vulnerability scanners (Trivy, Grype, Snyk) on all images before deployment. Severity: Critical. CWE: CWE-1104.
- [ ] SC-DOCK-003: Pin image versions with digests — Reference images by SHA256 digest rather than mutable tags. Severity: High. CWE: CWE-829.
- [ ] SC-DOCK-004: Verify image signatures — Use Docker Content Trust or cosign to verify image integrity and provenance. Severity: High. CWE: CWE-345.
- [ ] SC-DOCK-005: Remove unnecessary packages from images — Strip out compilers, debug tools, and package managers from production images. Severity: Medium. CWE: CWE-1104.
- [ ] SC-DOCK-006: Audit image layers for sensitive data — Inspect all layers to ensure no secrets, credentials, or keys were embedded during build. Severity: Critical. CWE: CWE-312.
- [ ] SC-DOCK-007: Use trusted base images only — Pull base images only from verified publishers and official repositories. Severity: High. CWE: CWE-829.
- [ ] SC-DOCK-008: Rebuild images regularly — Rebuild images frequently to incorporate the latest security patches from base images. Severity: Medium. CWE: CWE-1104.
- [ ] SC-DOCK-009: Enforce image size limits — Set maximum image size policies to detect bloated or tampered images. Severity: Low. CWE: CWE-400.
- [ ] SC-DOCK-010: Use multi-stage builds — Separate build and runtime stages to exclude build dependencies from final images. Severity: Medium. CWE: CWE-1104.
- [ ] SC-DOCK-011: Track image provenance with SBOM — Generate Software Bill of Materials for all container images. Severity: Medium. CWE: CWE-1104.
- [ ] SC-DOCK-012: Prohibit images with known critical CVEs — Block deployment of images containing critical or high severity vulnerabilities. Severity: Critical. CWE: CWE-1104.
- [ ] SC-DOCK-013: Remove shell from production images — Exclude shell binaries (bash, sh) from production images where possible. Severity: Medium. CWE: CWE-78.
- [ ] SC-DOCK-014: Validate image labels and metadata — Ensure images carry required metadata labels for tracking and compliance. Severity: Low. CWE: CWE-1059.
- [ ] SC-DOCK-015: Avoid using latest tag — Always specify explicit version tags to ensure reproducible deployments. Severity: Medium. CWE: CWE-829.
- [ ] SC-DOCK-016: Check for malware in images — Scan images for embedded malware, crypto miners, and backdoors. Severity: Critical. CWE: CWE-506.
- [ ] SC-DOCK-017: Implement image allowlisting — Only permit deployment of images from an approved registry and repository list. Severity: High. CWE: CWE-829.
- [ ] SC-DOCK-018: Minimize image layer count — Reduce the number of layers to decrease attack surface and improve auditability. Severity: Low. CWE: CWE-1104.
- [ ] SC-DOCK-019: Remove setuid and setgid binaries — Strip setuid/setgid bits from all binaries in the container image. Severity: High. CWE: CWE-269.
- [ ] SC-DOCK-020: Use read-only root filesystem in images — Design images to operate with a read-only root filesystem. Severity: Medium. CWE: CWE-732.

### 2. Dockerfile Best Practices (25 items)

- [ ] SC-DOCK-021: Do not run containers as root — Use the USER directive to specify a non-root user. Severity: Critical. CWE: CWE-250.
- [ ] SC-DOCK-022: Do not hardcode secrets in Dockerfiles — Never embed passwords, API keys, or tokens in Dockerfile instructions. Severity: Critical. CWE: CWE-798.
- [ ] SC-DOCK-023: Use COPY instead of ADD — Prefer COPY over ADD to avoid unintended remote URL fetching and tar extraction. Severity: Medium. CWE: CWE-829.
- [ ] SC-DOCK-024: Set a health check — Define HEALTHCHECK instructions to enable container health monitoring. Severity: Low. CWE: CWE-693.
- [ ] SC-DOCK-025: Pin package versions in RUN commands — Specify exact versions for apt-get, apk, pip, and npm packages. Severity: Medium. CWE: CWE-829.
- [ ] SC-DOCK-026: Use .dockerignore file — Exclude sensitive files, build artifacts, and unnecessary files from the build context. Severity: High. CWE: CWE-200.
- [ ] SC-DOCK-027: Minimize RUN layer count — Combine related commands in single RUN instructions to reduce layers and cleanup in the same layer. Severity: Low. CWE: CWE-1104.
- [ ] SC-DOCK-028: Clean up package manager caches — Remove apt, apk, pip, and npm caches in the same RUN instruction as the install. Severity: Low. CWE: CWE-1104.
- [ ] SC-DOCK-029: Do not use sudo in containers — Avoid installing or using sudo; use gosu or su-exec if privilege changes are needed. Severity: Medium. CWE: CWE-250.
- [ ] SC-DOCK-030: Set explicit WORKDIR — Use WORKDIR instead of cd commands to establish the working directory. Severity: Low. CWE: CWE-426.
- [ ] SC-DOCK-031: Do not expose unnecessary ports — Only EXPOSE the ports that the application actually requires. Severity: Medium. CWE: CWE-668.
- [ ] SC-DOCK-032: Use ARG for build-time variables — Use ARG for non-sensitive build-time configuration; never for secrets. Severity: Medium. CWE: CWE-312.
- [ ] SC-DOCK-033: Set proper file permissions — Explicitly set file ownership and permissions using COPY --chown and RUN chmod. Severity: Medium. CWE: CWE-732.
- [ ] SC-DOCK-034: Do not install unnecessary development tools — Exclude gcc, make, gdb, and similar tools from production images. Severity: Medium. CWE: CWE-1104.
- [ ] SC-DOCK-035: Validate downloaded files — Verify checksums or signatures of files downloaded during the build process. Severity: High. CWE: CWE-345.
- [ ] SC-DOCK-036: Use specific base image versions — Specify exact major.minor.patch versions for base images, not just major or minor. Severity: Medium. CWE: CWE-829.
- [ ] SC-DOCK-037: Do not use curl or wget to install software — Avoid piping remote scripts into shell; download, verify, then execute. Severity: High. CWE: CWE-494.
- [ ] SC-DOCK-038: Set LABEL for maintainer information — Use LABEL maintainer instead of deprecated MAINTAINER instruction. Severity: Low. CWE: CWE-1059.
- [ ] SC-DOCK-039: Lint Dockerfiles with hadolint — Run hadolint or similar Dockerfile linters in CI to catch insecure patterns. Severity: Medium. CWE: CWE-693.
- [ ] SC-DOCK-040: Do not store temporary files in image — Clean up all temporary and intermediate files within the same build layer. Severity: Low. CWE: CWE-459.
- [ ] SC-DOCK-041: Use BuildKit secrets mount — Use --mount=type=secret for build-time secrets instead of COPY or ARG. Severity: High. CWE: CWE-312.
- [ ] SC-DOCK-042: Disable package manager confirmation prompts — Use -y or --no-confirm flags to prevent interactive prompts that may hang builds. Severity: Low. CWE: CWE-693.
- [ ] SC-DOCK-043: Set a non-root numeric UID — Use numeric UIDs in the USER directive to avoid ambiguity in user resolution. Severity: Medium. CWE: CWE-250.
- [ ] SC-DOCK-044: Avoid ENTRYPOINT with shell form — Use exec form (JSON array) for ENTRYPOINT and CMD to avoid shell injection risks. Severity: Medium. CWE: CWE-78.
- [ ] SC-DOCK-045: Implement multi-stage builds for compiled languages — Use builder stages for Go, Rust, and Java to exclude compilers from production images. Severity: Medium. CWE: CWE-1104.

### 3. Runtime Security (20 items)

- [ ] SC-DOCK-046: Drop all Linux capabilities — Start containers with --cap-drop=ALL and add only required capabilities. Severity: Critical. CWE: CWE-250.
- [ ] SC-DOCK-047: Enable read-only root filesystem — Run containers with --read-only to prevent filesystem modifications. Severity: High. CWE: CWE-732.
- [ ] SC-DOCK-048: Disable privilege escalation — Set --security-opt=no-new-privileges to prevent setuid and capability escalation. Severity: High. CWE: CWE-269.
- [ ] SC-DOCK-049: Use seccomp profiles — Apply seccomp profiles to restrict available system calls. Severity: High. CWE: CWE-250.
- [ ] SC-DOCK-050: Use AppArmor or SELinux profiles — Apply MAC profiles to further restrict container capabilities. Severity: High. CWE: CWE-250.
- [ ] SC-DOCK-051: Do not run containers in privileged mode — Never use --privileged flag in production deployments. Severity: Critical. CWE: CWE-250.
- [ ] SC-DOCK-052: Prevent container breakout via PID namespace — Use --pid=host only when absolutely necessary and with additional controls. Severity: High. CWE: CWE-668.
- [ ] SC-DOCK-053: Restrict /proc and /sys access — Mount /proc and /sys as read-only or use masks to limit information exposure. Severity: Medium. CWE: CWE-200.
- [ ] SC-DOCK-054: Use user namespaces — Enable user namespace remapping to map container root to an unprivileged host user. Severity: High. CWE: CWE-269.
- [ ] SC-DOCK-055: Set PID limits per container — Use --pids-limit to prevent fork bombs and process exhaustion. Severity: Medium. CWE: CWE-400.
- [ ] SC-DOCK-056: Disable inter-container communication by default — Set --icc=false on the Docker daemon and explicitly link containers that must communicate. Severity: Medium. CWE: CWE-668.
- [ ] SC-DOCK-057: Prevent mounting the Docker socket — Never bind-mount /var/run/docker.sock into containers. Severity: Critical. CWE: CWE-250.
- [ ] SC-DOCK-058: Implement runtime threat detection — Deploy runtime security tools (Falco, Sysdig) to detect anomalous container behavior. Severity: High. CWE: CWE-778.
- [ ] SC-DOCK-059: Restrict device access — Do not pass --device flags unless explicitly required; use cgroup device rules. Severity: Medium. CWE: CWE-668.
- [ ] SC-DOCK-060: Set restart policies appropriately — Use on-failure with max retry limits instead of always to prevent crash loops. Severity: Low. CWE: CWE-400.
- [ ] SC-DOCK-061: Isolate container tmpfs mounts — Use tmpfs mounts for temporary data with size limits and noexec options. Severity: Medium. CWE: CWE-400.
- [ ] SC-DOCK-062: Disable container root access via exec — Restrict docker exec with --user to prevent root shell access in running containers. Severity: High. CWE: CWE-250.
- [ ] SC-DOCK-063: Monitor container resource consumption — Track CPU, memory, and I/O usage to detect crypto-mining or abuse. Severity: Medium. CWE: CWE-400.
- [ ] SC-DOCK-064: Prevent ptrace between containers — Disable ptrace capabilities to prevent debugging and process injection attacks. Severity: Medium. CWE: CWE-250.
- [ ] SC-DOCK-065: Validate entrypoint scripts — Review and secure entrypoint scripts to prevent injection through environment variables. Severity: High. CWE: CWE-78.

### 4. Network Security (15 items)

- [ ] SC-DOCK-066: Use user-defined bridge networks — Create custom bridge networks instead of using the default bridge. Severity: Medium. CWE: CWE-668.
- [ ] SC-DOCK-067: Do not use host network mode — Avoid --network=host as it bypasses Docker network isolation. Severity: High. CWE: CWE-668.
- [ ] SC-DOCK-068: Encrypt overlay network traffic — Enable IPSec encryption for Docker overlay networks in swarm mode. Severity: High. CWE: CWE-319.
- [ ] SC-DOCK-069: Restrict published port bindings — Bind published ports to specific interfaces (e.g., 127.0.0.1:8080:80) rather than 0.0.0.0. Severity: High. CWE: CWE-668.
- [ ] SC-DOCK-070: Implement network segmentation — Use separate networks for frontend, backend, and database tiers. Severity: High. CWE: CWE-668.
- [ ] SC-DOCK-071: Use internal networks for backend services — Mark networks as internal to prevent outbound internet access from backend containers. Severity: Medium. CWE: CWE-668.
- [ ] SC-DOCK-072: Implement DNS request filtering — Restrict DNS resolution to prevent containers from resolving malicious domains. Severity: Medium. CWE: CWE-350.
- [ ] SC-DOCK-073: Enable TLS for Docker daemon API — Configure the Docker daemon to require TLS for remote API connections. Severity: Critical. CWE: CWE-319.
- [ ] SC-DOCK-074: Use network policies for container firewall rules — Implement iptables rules or network policy engines to control container traffic. Severity: High. CWE: CWE-668.
- [ ] SC-DOCK-075: Restrict outbound internet access — Limit container egress traffic to only required external endpoints. Severity: Medium. CWE: CWE-668.
- [ ] SC-DOCK-076: Implement service mesh for mTLS — Use a service mesh (Istio, Linkerd) to enforce mutual TLS between containers. Severity: High. CWE: CWE-295.
- [ ] SC-DOCK-077: Disable IPv6 if not needed — Disable IPv6 on Docker networks if not required to reduce the attack surface. Severity: Low. CWE: CWE-668.
- [ ] SC-DOCK-078: Monitor network traffic between containers — Capture and analyze inter-container traffic for anomalous patterns. Severity: Medium. CWE: CWE-778.
- [ ] SC-DOCK-079: Use DNS aliases instead of IP addresses — Reference services by DNS name to allow for network policy enforcement. Severity: Low. CWE: CWE-668.
- [ ] SC-DOCK-080: Prevent ARP spoofing between containers — Use network drivers and configurations that mitigate ARP spoofing risks. Severity: Medium. CWE: CWE-290.

### 5. Volume & Storage Security (15 items)

- [ ] SC-DOCK-081: Mount volumes as read-only — Use the :ro flag for volumes that containers only need to read. Severity: High. CWE: CWE-732.
- [ ] SC-DOCK-082: Do not mount host sensitive directories — Never mount /etc, /proc, /sys, /dev, or / into containers. Severity: Critical. CWE: CWE-250.
- [ ] SC-DOCK-083: Use named volumes over bind mounts — Prefer Docker-managed named volumes for better isolation and management. Severity: Medium. CWE: CWE-668.
- [ ] SC-DOCK-084: Encrypt volume data at rest — Use encrypted storage backends or filesystem-level encryption for volumes. Severity: High. CWE: CWE-311.
- [ ] SC-DOCK-085: Set proper ownership on volume mounts — Ensure volume contents have correct ownership matching the container user. Severity: Medium. CWE: CWE-732.
- [ ] SC-DOCK-086: Implement volume backup with encryption — Back up persistent volumes with encryption for disaster recovery. Severity: Medium. CWE: CWE-311.
- [ ] SC-DOCK-087: Limit tmpfs mount sizes — Set size limits on tmpfs mounts to prevent memory exhaustion. Severity: Medium. CWE: CWE-400.
- [ ] SC-DOCK-088: Use noexec on volume mounts — Mount volumes with noexec where execution of files is not required. Severity: Medium. CWE: CWE-732.
- [ ] SC-DOCK-089: Clean up orphaned volumes — Regularly remove unused volumes that may contain sensitive data. Severity: Medium. CWE: CWE-459.
- [ ] SC-DOCK-090: Restrict volume driver plugins — Only allow approved volume driver plugins in production environments. Severity: Medium. CWE: CWE-829.
- [ ] SC-DOCK-091: Prevent volume sharing between untrusted containers — Do not share volumes between containers with different trust levels. Severity: High. CWE: CWE-668.
- [ ] SC-DOCK-092: Validate volume mount paths — Ensure volume mount paths cannot be manipulated to escape the intended directory. Severity: High. CWE: CWE-22.
- [ ] SC-DOCK-093: Implement storage quotas — Set per-container storage quotas to prevent disk exhaustion attacks. Severity: Medium. CWE: CWE-400.
- [ ] SC-DOCK-094: Use nosuid on volume mounts — Mount volumes with nosuid to prevent setuid binary execution from volumes. Severity: Medium. CWE: CWE-269.
- [ ] SC-DOCK-095: Audit volume access patterns — Log and monitor volume read/write operations for sensitive data directories. Severity: Low. CWE: CWE-778.

### 6. Docker Compose Security (15 items)

- [ ] SC-DOCK-096: Do not store secrets in docker-compose.yml — Use external secret management instead of inline environment variable secrets. Severity: Critical. CWE: CWE-312.
- [ ] SC-DOCK-097: Pin image versions in compose files — Specify exact image tags or digests in all service definitions. Severity: Medium. CWE: CWE-829.
- [ ] SC-DOCK-098: Use env_file with proper permissions — Protect .env files with restrictive filesystem permissions (0600). Severity: High. CWE: CWE-732.
- [ ] SC-DOCK-099: Declare read-only service filesystems — Set read_only: true for services that do not need writable root filesystems. Severity: Medium. CWE: CWE-732.
- [ ] SC-DOCK-100: Define security_opt in compose — Apply security options like no-new-privileges and seccomp profiles in compose definitions. Severity: High. CWE: CWE-250.
- [ ] SC-DOCK-101: Specify cap_drop in compose — Drop all capabilities with cap_drop: ALL and add only required ones with cap_add. Severity: High. CWE: CWE-250.
- [ ] SC-DOCK-102: Define resource limits in compose — Set memory and CPU limits with deploy.resources to prevent resource abuse. Severity: Medium. CWE: CWE-400.
- [ ] SC-DOCK-103: Use depends_on with health checks — Combine depends_on with condition: service_healthy for proper startup ordering. Severity: Low. CWE: CWE-693.
- [ ] SC-DOCK-104: Isolate services with multiple networks — Define separate networks for different service tiers in compose. Severity: Medium. CWE: CWE-668.
- [ ] SC-DOCK-105: Restrict port exposure in compose — Only publish ports that must be externally accessible; use expose for internal ports. Severity: Medium. CWE: CWE-668.
- [ ] SC-DOCK-106: Version-control compose files — Track all compose file changes in version control for audit trails. Severity: Low. CWE: CWE-778.
- [ ] SC-DOCK-107: Validate compose files before deployment — Use docker compose config to validate syntax and detect misconfigurations. Severity: Medium. CWE: CWE-693.
- [ ] SC-DOCK-108: Use Docker Compose secrets feature — Leverage the secrets top-level element for secure secret injection. Severity: High. CWE: CWE-312.
- [ ] SC-DOCK-109: Set user in compose services — Specify user: "nonroot:nonroot" for each service definition. Severity: High. CWE: CWE-250.
- [ ] SC-DOCK-110: Avoid privileged mode in compose — Never set privileged: true in production compose files. Severity: Critical. CWE: CWE-250.

### 7. Registry Security (10 items)

- [ ] SC-DOCK-111: Use private registries — Host images in private registries with access control rather than public repositories. Severity: High. CWE: CWE-668.
- [ ] SC-DOCK-112: Enable registry access authentication — Require authentication for all registry push and pull operations. Severity: Critical. CWE: CWE-306.
- [ ] SC-DOCK-113: Encrypt registry traffic with TLS — Ensure all registry communications use TLS; never configure insecure-registries. Severity: High. CWE: CWE-319.
- [ ] SC-DOCK-114: Implement registry RBAC — Apply role-based access control for push, pull, and delete operations. Severity: High. CWE: CWE-285.
- [ ] SC-DOCK-115: Enable vulnerability scanning on push — Configure automatic vulnerability scanning when images are pushed to the registry. Severity: High. CWE: CWE-1104.
- [ ] SC-DOCK-116: Implement image retention policies — Automatically delete old and untagged images to reduce storage of vulnerable versions. Severity: Medium. CWE: CWE-1104.
- [ ] SC-DOCK-117: Enable registry audit logging — Log all registry operations including pulls, pushes, and deletions with user context. Severity: Medium. CWE: CWE-778.
- [ ] SC-DOCK-118: Implement registry webhook notifications — Configure webhooks to trigger security scans and policy checks on image events. Severity: Low. CWE: CWE-693.
- [ ] SC-DOCK-119: Restrict registry network access — Limit registry access to known CIDR ranges or VPN connections. Severity: Medium. CWE: CWE-668.
- [ ] SC-DOCK-120: Enable content trust on the registry — Configure Notary or cosign for image signing and verification at the registry level. Severity: High. CWE: CWE-345.

### 8. Secrets Management (15 items)

- [ ] SC-DOCK-121: Use Docker secrets for sensitive data — Use Docker Swarm secrets or Kubernetes secrets instead of environment variables for passwords. Severity: Critical. CWE: CWE-312.
- [ ] SC-DOCK-122: Do not pass secrets via environment variables — Avoid ENV and -e flags for sensitive data as they persist in image layers and process lists. Severity: High. CWE: CWE-526.
- [ ] SC-DOCK-123: Integrate external secret managers — Use HashiCorp Vault, AWS Secrets Manager, or Azure Key Vault for secret injection. Severity: High. CWE: CWE-312.
- [ ] SC-DOCK-124: Rotate secrets regularly — Implement automatic rotation of database passwords, API keys, and certificates. Severity: High. CWE: CWE-798.
- [ ] SC-DOCK-125: Encrypt secrets at rest — Ensure all secrets are encrypted when stored on disk or in orchestrator state. Severity: High. CWE: CWE-311.
- [ ] SC-DOCK-126: Restrict secret access by service — Grant secret access only to the specific services that require them. Severity: High. CWE: CWE-285.
- [ ] SC-DOCK-127: Audit secret access — Log all secret read and modification operations with user and service context. Severity: Medium. CWE: CWE-778.
- [ ] SC-DOCK-128: Use temporary credentials — Prefer short-lived, auto-rotating credentials over long-lived static secrets. Severity: Medium. CWE: CWE-798.
- [ ] SC-DOCK-129: Prevent secrets in Docker build cache — Use BuildKit secret mounts and ensure build cache does not retain sensitive data. Severity: High. CWE: CWE-312.
- [ ] SC-DOCK-130: Scan images and repos for leaked secrets — Run tools like TruffleHog, gitleaks, or detect-secrets on images and source repos. Severity: High. CWE: CWE-798.
- [ ] SC-DOCK-131: Mount secrets as files not environment variables — Inject secrets as files mounted into containers for better access control. Severity: Medium. CWE: CWE-312.
- [ ] SC-DOCK-132: Implement secret versioning — Track secret versions to enable rollback and audit of credential changes. Severity: Low. CWE: CWE-778.
- [ ] SC-DOCK-133: Clear secrets from memory after use — Overwrite sensitive values in memory after processing to prevent memory dump exposure. Severity: Medium. CWE: CWE-316.
- [ ] SC-DOCK-134: Do not log secrets — Ensure application and container logs do not contain secret values. Severity: High. CWE: CWE-532.
- [ ] SC-DOCK-135: Separate secrets per environment — Use distinct secrets for development, staging, and production environments. Severity: Medium. CWE: CWE-312.

### 9. Resource Limits (10 items)

- [ ] SC-DOCK-136: Set memory limits on all containers — Use --memory to prevent any single container from exhausting host memory. Severity: High. CWE: CWE-770.
- [ ] SC-DOCK-137: Set CPU limits on all containers — Use --cpus or --cpu-shares to limit CPU consumption per container. Severity: Medium. CWE: CWE-770.
- [ ] SC-DOCK-138: Set memory reservation — Configure --memory-reservation for soft memory limits to improve scheduling. Severity: Low. CWE: CWE-770.
- [ ] SC-DOCK-139: Limit container storage with storage-opt — Set --storage-opt size= to prevent containers from consuming excessive disk space. Severity: Medium. CWE: CWE-400.
- [ ] SC-DOCK-140: Set ulimits for containers — Configure --ulimit to restrict open files, processes, and other resource limits. Severity: Medium. CWE: CWE-770.
- [ ] SC-DOCK-141: Disable OOM kill override — Do not set --oom-kill-disable as it can cause host instability when memory is exhausted. Severity: High. CWE: CWE-400.
- [ ] SC-DOCK-142: Set kernel memory limits — Use --kernel-memory to limit kernel memory consumption by containers. Severity: Medium. CWE: CWE-770.
- [ ] SC-DOCK-143: Limit container log sizes — Configure --log-opt max-size and max-file to prevent log-based disk exhaustion. Severity: Medium. CWE: CWE-400.
- [ ] SC-DOCK-144: Set I/O rate limits — Use --device-read-bps and --device-write-bps to limit disk I/O rates. Severity: Low. CWE: CWE-770.
- [ ] SC-DOCK-145: Monitor and enforce resource quotas — Implement resource monitoring with alerts when containers approach their limits. Severity: Medium. CWE: CWE-770.

### 10. Logging & Monitoring (10 items)

- [ ] SC-DOCK-146: Configure centralized logging — Send container logs to a centralized logging system (ELK, Splunk, Fluentd). Severity: High. CWE: CWE-778.
- [ ] SC-DOCK-147: Enable Docker daemon audit logging — Configure auditd rules for Docker daemon activities and socket access. Severity: High. CWE: CWE-778.
- [ ] SC-DOCK-148: Monitor Docker daemon events — Subscribe to Docker events to detect container creation, deletion, and configuration changes. Severity: Medium. CWE: CWE-778.
- [ ] SC-DOCK-149: Log container lifecycle events — Capture start, stop, kill, and restart events for all containers. Severity: Medium. CWE: CWE-778.
- [ ] SC-DOCK-150: Implement container image audit trails — Track which images were deployed, when, and by whom across all environments. Severity: Medium. CWE: CWE-778.
- [ ] SC-DOCK-151: Monitor for privileged container creation — Alert immediately when privileged containers are started in production. Severity: Critical. CWE: CWE-250.
- [ ] SC-DOCK-152: Set up anomaly detection for container behavior — Baseline normal container behavior and alert on deviations. Severity: Medium. CWE: CWE-778.
- [ ] SC-DOCK-153: Monitor Docker API access — Log and alert on all Docker API calls, especially from remote clients. Severity: High. CWE: CWE-778.
- [ ] SC-DOCK-154: Enable container file integrity monitoring — Detect unauthorized file modifications within running containers. Severity: Medium. CWE: CWE-354.
- [ ] SC-DOCK-155: Retain container logs for compliance — Store container logs for the duration required by security policies and regulations. Severity: Medium. CWE: CWE-778.

---

**Total: 155 items across 10 categories.**
