---
name: sc-crypto
description: Cryptography misuse detection — weak algorithms, ECB mode, static IVs, weak PRNG, and key management flaws
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Cryptography Misuse

## Purpose

Detects cryptographic implementation errors including use of weak algorithms (MD5, SHA1 for security), insecure cipher modes (ECB), static or hardcoded initialization vectors, missing authentication (AES-CBC without HMAC), weak pseudo-random number generators for security purposes, insufficient key lengths, and disabled certificate validation.

## Activation

Called by sc-orchestrator during Phase 2. Always runs.

## Phase 1: Discovery

### Keyword Patterns to Search
```
# Weak algorithms
"MD5", "md5", "SHA1", "sha1", "DES", "3DES", "RC4", "RC2",
"Blowfish", "IDEA"

# Cipher modes
"ECB", "CBC", "AES/ECB", "AES/CBC", "Mode.ECB"

# Initialization vectors
"iv =", "IV =", "nonce =", "static.*iv", "hardcoded.*iv",
"bytes(16)", "b'\\x00' * 16"

# Weak PRNG
"Math.random(", "random.random(", "random.randint(",
"rand()", "srand(", "java.util.Random", "System.Random"

# Key management
"key =", "encryption_key", "secret_key",
"AES.new(", "Cipher.getInstance(", "crypto.createCipheriv("

# TLS/SSL
"verify=False", "verify_ssl=False", "rejectUnauthorized: false",
"InsecureSkipVerify", "TLSv1", "SSLv3",
"CERT_NONE", "CERT_OPTIONAL"
```

### Vulnerability Patterns

**1. Weak Hash for Security:**
```python
# VULNERABLE: MD5 for password hashing
password_hash = hashlib.md5(password.encode()).hexdigest()

# VULNERABLE: SHA1 for signature verification
signature = hashlib.sha1(data.encode()).hexdigest()

# SAFE: SHA-256+ for signatures, bcrypt/argon2 for passwords
password_hash = bcrypt.hashpw(password.encode(), bcrypt.gensalt())
signature = hashlib.sha256(data.encode()).hexdigest()
```

**2. ECB Mode:**
```java
// VULNERABLE: ECB mode reveals patterns in encrypted data
Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");

// SAFE: GCM mode (authenticated encryption)
Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
```

**3. Static IV:**
```javascript
// VULNERABLE: Hardcoded IV
const iv = Buffer.from('0000000000000000');
const cipher = crypto.createCipheriv('aes-256-cbc', key, iv);

// SAFE: Random IV per encryption
const iv = crypto.randomBytes(16);
const cipher = crypto.createCipheriv('aes-256-cbc', key, iv);
```

**4. Weak PRNG for Security:**
```javascript
// VULNERABLE: Math.random for security tokens
const token = Math.random().toString(36).substring(2);

// SAFE: Cryptographic random
const token = crypto.randomBytes(32).toString('hex');
```

**5. Disabled Certificate Validation:**
```python
# VULNERABLE: Disabling SSL verification
requests.get(url, verify=False)

# SAFE
requests.get(url, verify=True)  # Default
```

## Severity Classification

- **Critical:** Disabled certificate validation on auth endpoints, ECB mode for sensitive data, hardcoded encryption keys
- **High:** MD5/SHA1 for password hashing, static IVs, Math.random for security tokens
- **Medium:** AES-CBC without HMAC, weak key length, deprecated TLS versions
- **Low:** MD5/SHA1 for non-security checksums flagged as security issue, weak PRNG in non-security context

## Output Format

### Finding: CRYPTO-{NNN}
- **Title:** {Cryptography misuse type}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-327 (Broken Crypto) | CWE-328 (Weak Hash) | CWE-330 (Insufficient Randomness) | CWE-338 (Weak PRNG)
- **Description:** {What cryptographic weakness was found}
- **Impact:** Data decryption, signature forgery, token prediction, MitM attacks.
- **Remediation:** {Use AES-256-GCM, bcrypt/argon2, crypto.randomBytes, proper TLS}
- **References:** https://cwe.mitre.org/data/definitions/327.html

## Common False Positives

1. **MD5/SHA1 for checksums** — file integrity checks, cache keys, non-security hashing
2. **Math.random for UI** — random colors, shuffling non-sensitive lists
3. **Test certificates** — self-signed certs and verify=False in test environments
4. **Legacy compatibility** — documented legacy support with migration plan
5. **Content hashing** — git SHAs, ETag generation, deduplication hashes
