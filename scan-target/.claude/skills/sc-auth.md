---
name: sc-auth
description: Authentication flaw detection — weak passwords, broken auth, credential stuffing, and bypass vectors
---

# SC: Authentication Flaws

## Purpose

Detects authentication vulnerabilities including weak password policies, missing brute force protection, insecure password storage, authentication bypass, hardcoded credentials, insecure password reset flows, and missing multi-factor authentication. Covers session-based, JWT, OAuth, and API key authentication models.

## Activation

Called by sc-orchestrator during Phase 2. Runs against all web applications and APIs.

## Phase 1: Discovery

### File Patterns to Search
```
**/*auth*, **/*login*, **/*signin*, **/*signup*, **/*register*,
**/*password*, **/*credential*, **/*token*, **/*session*,
**/*oauth*, **/*mfa*, **/*2fa*, **/middleware/*, **/guards/*
```

### Keyword Patterns to Search
```
# Password hashing
"md5(", "sha1(", "sha256(", "hashlib.md5", "hashlib.sha1",
"MessageDigest.getInstance(\"MD5\"", "MessageDigest.getInstance(\"SHA-1\"",
"bcrypt", "argon2", "scrypt", "pbkdf2", "password_hash(",
"crypto.createHash("

# Authentication logic
"password ==", "password ===", "password.equals(",
"authenticate(", "login(", "verify_password(", "check_password(",
"compareSync(", "compare("

# Hardcoded credentials
"password = \"", "password = '", "passwd", "secret",
"api_key = \"", "token = \"", "admin:admin", "root:root"

# Brute force protection
"rate_limit", "throttle", "max_attempts", "lockout",
"login_attempts", "failed_attempts"
```

### Vulnerability Categories

**1. Weak Password Hashing:**
```python
# VULNERABLE: MD5/SHA for password storage
password_hash = hashlib.md5(password.encode()).hexdigest()

# SAFE: bcrypt with appropriate cost factor
password_hash = bcrypt.hashpw(password.encode(), bcrypt.gensalt(rounds=12))
```

**2. Missing Brute Force Protection:**
```javascript
// VULNERABLE: No rate limiting on login
app.post('/login', async (req, res) => {
  const user = await User.findOne({ email: req.body.email });
  if (user && await bcrypt.compare(req.body.password, user.password)) {
    return res.json({ token: generateToken(user) });
  }
  return res.status(401).json({ error: 'Invalid credentials' });
});

// SAFE: With rate limiting
const loginLimiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 5 });
app.post('/login', loginLimiter, async (req, res) => { /* ... */ });
```

**3. Timing-Safe Comparison:**
```go
// VULNERABLE: Non-constant-time comparison
if token == expectedToken { /* ... */ }

// SAFE: Constant-time comparison
if subtle.ConstantTimeCompare([]byte(token), []byte(expectedToken)) == 1 { /* ... */ }
```

**4. Account Enumeration:**
```python
# VULNERABLE: Different responses reveal account existence
if not user_exists(email):
    return error("User not found")
if not check_password(password):
    return error("Wrong password")

# SAFE: Generic error message
if not user_exists(email) or not check_password(email, password):
    return error("Invalid email or password")
```

## Phase 2: Verification

### Sanitization Check
1. Are passwords hashed with bcrypt/argon2/scrypt (adaptive cost)?
2. Is brute force protection implemented on login endpoints?
3. Are password reset tokens time-limited and single-use?
4. Is timing-safe comparison used for secrets/tokens?

## Severity Classification

- **Critical:** Hardcoded admin credentials, authentication bypass, plaintext password storage
- **High:** MD5/SHA1 password hashing, missing brute force protection on public login
- **Medium:** Account enumeration, weak password policy, missing MFA on sensitive operations
- **Low:** Non-constant-time token comparison, verbose authentication error messages

## Output Format

### Finding: AUTH-{NNN}
- **Title:** {Authentication vulnerability type}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-287 (Improper Authentication) | CWE-798 (Hardcoded Credentials) | CWE-916 (Weak Password Hash)
- **Description:** {What was found}
- **Impact:** {Account takeover, credential theft, unauthorized access}
- **Remediation:** {Specific fix}
- **References:** https://cwe.mitre.org/data/definitions/287.html

## Common False Positives

1. **Test/fixture credentials** — hardcoded passwords in test files for test accounts
2. **Password hashing in migration** — hashing algorithm in migration code for legacy compatibility
3. **Hash functions for non-security purposes** — MD5/SHA used for checksums, cache keys, not passwords
4. **Environment variable reads** — `os.getenv("SECRET")` reads at runtime, not hardcoded
5. **OAuth provider configuration** — OAuth client IDs (public) vs client secrets (should be env var)
