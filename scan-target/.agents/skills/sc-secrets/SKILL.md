---
name: sc-secrets
description: Hardcoded secrets, API keys, tokens, credentials, and private key detection in source code
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Hardcoded Secrets & Credentials

## Purpose

Detects hardcoded secrets, API keys, tokens, passwords, private keys, and credentials embedded in source code, configuration files, and environment files committed to version control. Uses pattern matching for known key formats, entropy analysis for unknown formats, and context analysis to distinguish test keys from production secrets.

## Activation

Called by sc-orchestrator during Phase 2. Always runs regardless of detected languages.

## Phase 1: Discovery

### File Patterns to Search
```
**/*.ts, **/*.js, **/*.py, **/*.go, **/*.php, **/*.java, **/*.cs,
**/*.rb, **/*.yaml, **/*.yml, **/*.json, **/*.xml, **/*.toml,
**/*.env, **/*.env.*, **/*.cfg, **/*.conf, **/*.ini, **/*.properties,
**/*.config, **/config/*, **/settings/*, **/.env*, **/docker-compose*,
**/*.sh, **/*.bash, **/Dockerfile*, **/.github/workflows/*
```

### Known API Key Patterns

| Service | Pattern | Example Prefix |
|---------|---------|----------------|
| AWS Access Key | `AKIA[0-9A-Z]{16}` | `AKIA...` |
| AWS Secret Key | 40-char base64 after `aws_secret_access_key` | |
| GitHub Token | `ghp_[A-Za-z0-9]{36}` | `ghp_...` |
| GitHub App Token | `ghs_[A-Za-z0-9]{36}` | `ghs_...` |
| GitLab Token | `glpat-[A-Za-z0-9\-]{20}` | `glpat-...` |
| Stripe Live Key | `sk_live_[A-Za-z0-9]{24,}` | `sk_live_...` |
| Stripe Publishable | `pk_live_[A-Za-z0-9]{24,}` | `pk_live_...` |
| Twilio | `SK[0-9a-fA-F]{32}` | `SK...` |
| SendGrid | `SG\.[A-Za-z0-9\-_]{22}\.[A-Za-z0-9\-_]{43}` | `SG....` |
| Slack Token | `xox[baprs]-[A-Za-z0-9\-]{10,}` | `xoxb-...` |
| Google API Key | `AIza[A-Za-z0-9\-_]{35}` | `AIza...` |
| Firebase Key | `AAAA[A-Za-z0-9_-]{7}:[A-Za-z0-9_-]{140}` | |
| Heroku API Key | `[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-...-[0-9a-fA-F]{12}` | UUID format |
| npm Token | `npm_[A-Za-z0-9]{36}` | `npm_...` |
| PyPI Token | `pypi-[A-Za-z0-9\-_]{16,}` | `pypi-...` |

### Private Key Detection
```
"-----BEGIN RSA PRIVATE KEY-----"
"-----BEGIN EC PRIVATE KEY-----"
"-----BEGIN OPENSSH PRIVATE KEY-----"
"-----BEGIN PGP PRIVATE KEY BLOCK-----"
"-----BEGIN DSA PRIVATE KEY-----"
"-----BEGIN PRIVATE KEY-----"
```

### Generic Secret Patterns
```
# Assignment patterns
"password\s*[=:]\s*[\"'][^\"']{8,}"
"secret\s*[=:]\s*[\"'][^\"']{8,}"
"api_key\s*[=:]\s*[\"'][^\"']{8,}"
"token\s*[=:]\s*[\"'][^\"']{8,}"
"private_key\s*[=:]\s*[\"'][^\"']{8,}"
"auth.*[=:]\s*[\"'][^\"']{8,}"
"credential.*[=:]\s*[\"'][^\"']{8,}"

# Connection strings with embedded passwords
"mongodb://.*:.*@"
"postgres://.*:.*@"
"mysql://.*:.*@"
"redis://.*:.*@"
"amqp://.*:.*@"
```

### High-Entropy String Detection
Flag strings with Shannon entropy > 4.5 in security-sensitive variable assignments.

## Phase 2: Verification

### Test vs Production Key Distinction
1. Does the key match a known test/example prefix? (e.g., `sk_test_`, `pk_test_`, `AKIAIOSFODNN7EXAMPLE`)
2. Is the file in a test directory?
3. Is the value `"changeme"`, `"placeholder"`, `"xxx"`, `"your-key-here"`?
4. Is the value loaded from an environment variable at runtime? (`os.getenv()`, `process.env`)
5. Is the `.env` file in `.gitignore`?

### Context Analysis
```python
# FALSE POSITIVE: Environment variable read (not hardcoded)
API_KEY = os.environ.get('API_KEY')

# TRUE POSITIVE: Hardcoded secret
API_KEY = "sk_live_EXAMPLE_KEY_REPLACE_ME"

# FALSE POSITIVE: Test key
STRIPE_KEY = "sk_test_EXAMPLE_KEY"

# TRUE POSITIVE: Production key in code
STRIPE_KEY = "sk_live_EXAMPLE_PROD_KEY"
```

## Severity Classification

- **Critical:** Production API keys (AWS, Stripe live, database passwords), private keys, JWT signing secrets
- **High:** Service tokens (GitHub, GitLab, Slack, SendGrid) that grant significant access
- **Medium:** API keys with limited scope, internal service credentials, publishable keys misidentified as secret
- **Low:** Test/sandbox keys, example/placeholder values, keys in documentation

## Output Format

### Finding: SECRET-{NNN}
- **Title:** Hardcoded {key type} in {file}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-798 (Hardcoded Credentials) | CWE-321 (Hard-coded Cryptographic Key)
- **Description:** {Service} {key type} found hardcoded in source code.
- **Impact:** Unauthorized access to {service}, data breach, financial loss, account compromise.
- **Remediation:** Move secret to environment variable or secrets manager. Rotate the exposed key immediately.
- **References:** https://cwe.mitre.org/data/definitions/798.html

## Common False Positives

1. **Environment variable reads** — `os.getenv("KEY")`, `process.env.KEY` are runtime reads, not hardcoded
2. **Test/sandbox keys** — `sk_test_`, `pk_test_`, keys containing "test", "example", "demo"
3. **Placeholder values** — `"changeme"`, `"your-api-key"`, `"xxx"`, `"TODO"`
4. **Public keys** — SSH public keys, JWT public keys, certificate public keys are not secrets
5. **Hash outputs** — bcrypt hashes, SHA hashes in migration files are not secrets
6. **Base64-encoded non-secrets** — base64 strings that are UI assets, not credentials
7. **Configuration templates** — `.env.example` files with placeholder values
