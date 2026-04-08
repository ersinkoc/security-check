---
name: sc-jwt
description: JWT implementation flaw detection — algorithm confusion, weak secrets, missing validation, and storage issues
---

# SC: JWT Implementation Flaws

## Purpose

Detects JWT (JSON Web Token) implementation vulnerabilities including algorithm confusion attacks (alg:none, RS256→HS256), weak signing secrets, missing expiration/audience/issuer validation, insecure client-side storage, JWK injection, and key ID (kid) manipulation.

## Activation

Called by sc-orchestrator during Phase 2 when JWT usage is detected.

## Phase 1: Discovery

### Keyword Patterns to Search
```
"jwt", "JWT", "jsonwebtoken", "jose", "PyJWT", "java-jwt",
"sign(", "verify(", "decode(", "encode(",
"alg", "HS256", "RS256", "ES256", "none",
"expiresIn", "exp", "iat", "aud", "iss", "sub",
"localStorage.*token", "sessionStorage.*token",
"Bearer", "Authorization"
```

### Vulnerability Patterns

**1. Algorithm Confusion (alg:none):**
```javascript
// VULNERABLE: Not specifying allowed algorithms
const payload = jwt.verify(token, secret);  // Accepts alg:none!

// SAFE: Specify algorithms explicitly
const payload = jwt.verify(token, secret, { algorithms: ['HS256'] });
```

**2. Weak Signing Secret:**
```javascript
// VULNERABLE: Short/predictable secret
const token = jwt.sign(payload, 'secret');
const token = jwt.sign(payload, 'password123');
const token = jwt.sign(payload, process.env.JWT_SECRET || 'default');

// SAFE: Strong random secret (256+ bits)
const token = jwt.sign(payload, process.env.JWT_SECRET);
// Where JWT_SECRET is a 64+ character random string
```

**3. Missing Expiration:**
```python
# VULNERABLE: No expiration
token = jwt.encode({"user_id": user.id}, SECRET_KEY, algorithm="HS256")

# SAFE: With expiration
token = jwt.encode({
    "user_id": user.id,
    "exp": datetime.utcnow() + timedelta(hours=1)
}, SECRET_KEY, algorithm="HS256")
```

**4. JWT in localStorage (XSS Theft):**
```javascript
// VULNERABLE: XSS can steal token
localStorage.setItem('token', jwtToken);

// SAFE: HttpOnly cookie
res.cookie('token', jwtToken, {
  httpOnly: true,
  secure: true,
  sameSite: 'strict'
});
```

**5. Missing Audience/Issuer Validation:**
```javascript
// VULNERABLE: No audience/issuer check
const payload = jwt.verify(token, secret, { algorithms: ['HS256'] });

// SAFE: Validate audience and issuer
const payload = jwt.verify(token, secret, {
  algorithms: ['HS256'],
  audience: 'https://api.example.com',
  issuer: 'https://auth.example.com'
});
```

**6. Kid Parameter Injection:**
```javascript
// VULNERABLE: kid used in SQL query or file path
const kid = header.kid;
const key = db.query(`SELECT key FROM keys WHERE id = '${kid}'`);  // SQL injection!
// Or: const key = fs.readFileSync(`/keys/${kid}`);  // Path traversal!
```

## Severity Classification

- **Critical:** Algorithm confusion allowing token forgery, SQL injection via kid
- **High:** Weak signing secret (guessable), missing algorithm validation
- **Medium:** JWT in localStorage (requires XSS), missing expiration
- **Low:** Missing audience/issuer validation, long expiration time

## Output Format

### Finding: JWT-{NNN}
- **Title:** JWT {vulnerability type}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-345 (Insufficient Verification of Data Authenticity) | CWE-347 (Improper Verification of Cryptographic Signature)
- **Description:** {What was found}
- **Impact:** Authentication bypass, token forgery, account takeover.
- **Remediation:** {Specify algorithms, use strong secrets, validate exp/aud/iss, store in httpOnly cookies}
- **References:** https://cwe.mitre.org/data/definitions/345.html

## Common False Positives

1. **JWT decode (not verify)** — `jwt.decode()` for reading payload (without verification) in non-auth contexts
2. **Test tokens** — hardcoded tokens in test files
3. **Public key operations** — RS256 verification with public key is safe (no secret needed)
4. **Token refresh logic** — legitimate token reissuance patterns
