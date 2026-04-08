---
name: sc-ssrf
description: Server-Side Request Forgery detection — URL fetching with user input, DNS rebinding, cloud metadata access
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Server-Side Request Forgery (SSRF)

## Purpose

Detects SSRF vulnerabilities where user-controlled input influences server-side HTTP requests, enabling attackers to access internal services, cloud metadata endpoints, and private network resources. Covers direct SSRF, blind SSRF, DNS rebinding, and partial SSRF through header injection.

## Activation

Called by sc-orchestrator during Phase 2. Runs against all web applications and APIs.

## Phase 1: Discovery

### Keyword Patterns to Search
```
"requests.get(", "requests.post(", "urllib.request.urlopen(",
"http.Get(", "http.Post(", "http.NewRequest(",
"fetch(", "axios.get(", "axios.post(", "got(",
"curl_exec(", "file_get_contents(", "fopen(",
"HttpClient", "WebClient", "HttpWebRequest",
"RestTemplate", "WebClient.create(", "OkHttpClient"
```

### Data Flow: User Input → HTTP Request URL
```python
# VULNERABLE
url = request.GET['url']
response = requests.get(url)  # User controls entire URL

# VULNERABLE: Partial SSRF
host = request.GET['host']
response = requests.get(f"https://{host}/api/data")  # User controls host

# SAFE: URL allowlist
ALLOWED_HOSTS = ['api.example.com', 'cdn.example.com']
parsed = urlparse(request.GET['url'])
if parsed.hostname not in ALLOWED_HOSTS:
    return HttpResponseForbidden()
response = requests.get(request.GET['url'])
```

### Cloud Metadata Endpoints
Flag any request that could reach:
- AWS: `http://169.254.169.254/latest/meta-data/`
- GCP: `http://metadata.google.internal/`
- Azure: `http://169.254.169.254/metadata/instance`

### IP Bypass Techniques to Check
When blocklists are used, verify they catch:
- Decimal: `2130706433` (127.0.0.1)
- Hex: `0x7f000001`
- Octal: `0177.0.0.1`
- IPv6: `[::1]`, `[::ffff:127.0.0.1]`
- DNS rebinding: attacker domain resolving to internal IP

## Severity Classification

- **Critical:** SSRF accessing cloud metadata or internal admin services
- **High:** SSRF to arbitrary internal hosts, blind SSRF with out-of-band confirmation
- **Medium:** SSRF with limited impact (port scanning), partial URL control
- **Low:** SSRF with strong allowlist that may have minor bypass

## Output Format

### Finding: SSRF-{NNN}
- **Title:** Server-Side Request Forgery in {endpoint}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-918 (Server-Side Request Forgery)
- **Description:** User input from {source} controls the URL in {HTTP function}.
- **Impact:** Internal network access, cloud credential theft, port scanning.
- **Remediation:** Implement URL allowlist. Block internal/private IP ranges. Use DNS resolution verification.
- **References:** https://cwe.mitre.org/data/definitions/918.html

## Common False Positives

1. **Hardcoded URLs** — HTTP requests to constant/configured URLs
2. **Webhook delivery** — outbound webhooks with pre-registered URLs (by admin)
3. **CDN/proxy integration** — fetching from known CDN endpoints
4. **Internal microservice calls** — service-to-service with configured base URLs
5. **URL validation in place** — allowlist or scheme+host validation before request
