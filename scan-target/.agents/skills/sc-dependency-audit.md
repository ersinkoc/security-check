---
name: sc-dependency-audit
description: Supply chain and dependency security analysis across all package ecosystems
---

# SC: Dependency Audit — Supply Chain & Dependency Security

## Purpose

Analyzes all project dependencies for known vulnerabilities, supply chain risks, typosquatting attempts, and dangerous build-time behaviors. Covers all major package ecosystems: npm, PyPI, crates.io, Maven Central, NuGet, Packagist, and Go modules.

## Activation

Runs as part of Phase 1 (Reconnaissance), immediately after sc-recon.

## Output

File: `security-report/dependency-audit.md`

## Phase 1: Discovery

### Lock File Detection

Search for dependency manifest and lock files:

| Ecosystem | Manifest | Lock File |
|-----------|----------|-----------|
| Node.js | `package.json` | `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml` |
| Python | `requirements.txt`, `pyproject.toml`, `Pipfile`, `setup.py`, `setup.cfg` | `Pipfile.lock`, `poetry.lock` |
| Go | `go.mod` | `go.sum` |
| Rust | `Cargo.toml` | `Cargo.lock` |
| Java | `pom.xml`, `build.gradle`, `build.gradle.kts` | `gradle.lockfile` |
| C# | `*.csproj`, `packages.config` | `packages.lock.json` |
| PHP | `composer.json` | `composer.lock` |
| Ruby | `Gemfile` | `Gemfile.lock` |

### Dependency Inventory

For each detected ecosystem:

1. **Parse manifest files** to list all direct dependencies with version constraints
2. **Parse lock files** to list all transitive dependencies with resolved versions
3. **Count total dependencies** (direct + transitive)
4. **Flag missing lock files** — if manifest exists but no lock file, flag as risk

### Known Vulnerability Scanning

For each dependency, check for known vulnerabilities by analyzing:

1. **Version age** — flag dependencies not updated in 2+ years
2. **Known CVE patterns** — check version ranges against known vulnerable version ranges
3. **Deprecated packages** — check for deprecation notices in manifest metadata
4. **Yanked/retracted versions** — detect usage of versions pulled from registries

Common vulnerable dependency patterns to flag:

**Node.js:**
- `lodash` < 4.17.21 (prototype pollution)
- `minimist` < 1.2.6 (prototype pollution)
- `json5` < 2.2.2 (prototype pollution)
- `node-fetch` < 2.6.7 (SSRF via redirect)
- `express` < 4.19.2 (open redirect)
- `jsonwebtoken` < 9.0.0 (algorithm confusion)
- Any dependency using `eval` or `Function()` in source

**Python:**
- `pyyaml` < 6.0 with `yaml.load()` usage
- `requests` < 2.31.0 (various)
- `urllib3` < 2.0.6 (header injection)
- `cryptography` < 41.0.0 (multiple CVEs)
- `django` version-specific CVEs
- `flask` with debug=True patterns

**Go:**
- Check `go.sum` for integrity
- Flag `replace` directives pointing to local paths or non-standard URLs
- Detect indirect dependencies with known issues

**Rust:**
- Cross-reference with RustSec advisory database patterns
- Flag `unsafe` crates with high usage
- Check `build.rs` presence in dependencies

**Java:**
- `log4j` < 2.17.1 (Log4Shell — CVE-2021-44228)
- `jackson-databind` polymorphic typing versions
- `spring-framework` < 5.3.18 (Spring4Shell)
- `commons-collections` deserialization gadgets
- `fastjson` < 1.2.83 (deserialization RCE)

**C#:**
- `System.Text.Json` < 6.0.0 (various)
- `Newtonsoft.Json` TypeNameHandling patterns
- `Microsoft.AspNetCore` version-specific CVEs

### Typosquatting Detection

For each dependency, check for typosquatting indicators:

1. **Name similarity** — compare against popular packages for character transposition, omission, addition
2. **Low download count** — flag packages with suspiciously low downloads for their name similarity to popular packages
3. **Recent publication** — flag very new packages that mirror names of established packages
4. **Author mismatch** — flag if package author doesn't match the expected maintainer of similarly-named packages

Common typosquatting patterns:
- Character swap: `lodash` → `lodassh`, `1odash`
- Scope confusion: `@types/react` → `types-react`
- Hyphen/underscore swap: `node-fetch` → `node_fetch`

### Dependency Confusion

Check for dependency confusion attack vectors:

1. **Private registry configuration** — verify `.npmrc`, `pip.conf`, `settings.xml` point to correct registries
2. **Scoped vs unscoped packages** — flag unscoped packages that could be claimed on public registry
3. **Internal package names on public registries** — check if internal package names exist on public registries
4. **Mixed registry sources** — flag configurations pulling from both public and private registries without priority rules

### Build Script Analysis

Inspect build-time scripts that execute during installation:

**npm:**
- `postinstall`, `preinstall`, `prepare` scripts in `package.json`
- Flag scripts that execute binaries, make network calls, or modify files outside node_modules

**Python:**
- `setup.py` with `os.system()`, `subprocess`, or network calls
- `pyproject.toml` build backend custom scripts

**Rust:**
- `build.rs` files in dependencies
- `proc-macro` crates that generate code at compile time

**Java:**
- Gradle/Maven plugins that execute arbitrary code
- Custom build phases with exec tasks

**Go:**
- `//go:generate` directives
- CGo compilation with external C libraries

### License Compliance

Check dependency licenses for:

1. **Copyleft licenses** (GPL, AGPL) in MIT/Apache-licensed projects
2. **No license specified** — flag dependencies without clear license
3. **License incompatibility** — flag conflicts between project license and dependency licenses
4. **Commercial/proprietary** — flag proprietary dependencies

## Phase 2: Verification

For each flagged dependency:

1. **Confirm version** — verify the flagged version is actually in use (not just in manifest)
2. **Check if vulnerability is reachable** — is the vulnerable function/module actually imported and called?
3. **Check for patches** — is there a patched version available?
4. **Assess real impact** — is the vulnerability exploitable in this project's context?

## Severity Classification

- **Critical:** Dependency with known RCE vulnerability in an actively used code path
- **High:** Dependency with known vulnerability that could lead to data breach or privilege escalation
- **Medium:** Dependency with known vulnerability that requires specific conditions to exploit, or typosquatting risk
- **Low:** Outdated dependency without known CVE, license concern, or informational finding

## Output Format

### Finding: DEP-{NNN}

- **Title:** Short title
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **Package:** package-name@version
- **Ecosystem:** npm | PyPI | crates.io | Maven | NuGet | Packagist | Go
- **Vulnerability Type:** Known CVE | Typosquatting | Dependency Confusion | Build Script Risk | License Issue | Outdated
- **CVE:** CVE-XXXX-XXXXX (if applicable)
- **CWE:** CWE-XXX
- **Description:** What was found
- **Impact:** What happens if exploited
- **Remediation:** Upgrade to version X.Y.Z / Replace with alternative
- **References:** CVE link, advisory link

## Summary Statistics

The output must include a summary section:

```markdown
## Dependency Audit Summary
- Total dependencies: {N} (direct: {D}, transitive: {T})
- Ecosystems scanned: {list}
- Known vulnerabilities found: {N} (Critical: {C}, High: {H}, Medium: {M}, Low: {L})
- Typosquatting risks: {N}
- Dependency confusion risks: {N}
- License concerns: {N}
- Outdated dependencies: {N}
```

## Common False Positives

- **Dev dependencies** flagged as production risks — verify if the dependency is dev-only
- **Transitive dependency vulnerabilities** that are not reachable from the project code
- **Version range false matches** — ensure the exact resolved version is vulnerable, not just the constraint range
- **Test/example dependencies** in monorepos that are not part of the deployed artifact
- **Fork references** that point to patched forks of vulnerable packages
