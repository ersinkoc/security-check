---
name: sc-privilege-escalation
description: Privilege escalation vector detection — role manipulation, admin bypass, and RBAC circumvention
---

# SC: Privilege Escalation

## Purpose

Detects privilege escalation vulnerabilities where users can elevate their access level by manipulating role claims, accessing unprotected admin endpoints, tampering with JWT role fields, bypassing RBAC checks, or exploiting default/test admin accounts. Focuses on the boundary between user roles and the mechanisms that enforce them.

## Activation

Called by sc-orchestrator during Phase 2. Runs against applications with role-based access.

## Phase 1: Discovery

### File Patterns to Search
```
**/*auth*, **/*role*, **/*permission*, **/*admin*, **/*guard*,
**/*middleware*, **/*policy*, **/*rbac*, **/*acl*,
**/routes/*, **/controllers/*, **/*user*
```

### Keyword Patterns to Search
```
"role", "isAdmin", "is_admin", "is_superuser", "is_staff",
"hasRole", "hasPermission", "admin", "moderator", "superuser",
"role_id", "user_type", "privilege", "grant", "permission_level"
```

### Vulnerability Patterns

**1. Role Manipulation via Request Body:**
```javascript
// VULNERABLE: User can set their own role
app.post('/api/users', async (req, res) => {
  const user = await User.create(req.body);
  // If req.body = { name: "attacker", email: "...", role: "admin" }
  // The attacker becomes admin!
});

// SAFE: Ignore role from request
app.post('/api/users', async (req, res) => {
  const user = await User.create({
    name: req.body.name,
    email: req.body.email,
    role: 'user'  // Always set to default
  });
});
```

**2. JWT Role Claim Tampering:**
```python
# VULNERABLE: Trusting role from JWT without server-side verification
@app.route('/admin')
def admin_panel():
    token = decode_jwt(request.headers['Authorization'])
    if token['role'] == 'admin':  # Role stored in JWT, client can forge!
        return render_admin()

# SAFE: Check role from database, not JWT
@app.route('/admin')
@login_required
def admin_panel():
    user = User.query.get(current_user.id)
    if user.role != 'admin':
        abort(403)
    return render_admin()
```

**3. Admin Endpoint Without Auth Middleware:**
```go
// VULNERABLE: Admin route without auth middleware
r.GET("/admin/users", handlers.ListAllUsers)
r.GET("/admin/settings", handlers.GetSettings)

// SAFE: Admin routes behind auth + role middleware
admin := r.Group("/admin")
admin.Use(authMiddleware, requireRole("admin"))
admin.GET("/users", handlers.ListAllUsers)
admin.GET("/settings", handlers.GetSettings)
```

**4. Default Admin Accounts:**
```python
# VULNERABLE: Default admin in seed/migration
User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
```

## Phase 2: Verification

### Verification Steps
1. Can the user include role/privilege fields in registration or profile update requests?
2. Are admin endpoints protected by middleware that checks roles from the database?
3. Is the role stored only in JWT without server-side verification?
4. Are there default/test admin accounts in production configuration?
5. Is there path-based access control that can be bypassed (e.g., `/admin/../user`)?

## Severity Classification

- **Critical:** Any user can become admin via request body, unprotected admin endpoints
- **High:** JWT role tampering, default admin credentials in production
- **Medium:** Role escalation requiring authenticated access and specific conditions
- **Low:** Privilege escalation in internal tools, or with strong compensating controls

## Output Format

### Finding: PRIVESC-{NNN}
- **Title:** {Privilege escalation type} in {location}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-269 (Improper Privilege Management) | CWE-250 (Execution with Unnecessary Privileges)
- **Description:** {What was found and how privilege escalation is possible}
- **Impact:** Full administrative access, data breach, system compromise.
- **Remediation:** {Specific fix — enforce role from server side, add middleware, remove defaults}
- **References:** https://cwe.mitre.org/data/definitions/269.html

## Common False Positives

1. **Admin seed scripts** — default admin creation in dev/test environments (check if production-only)
2. **Role assignment by admin** — admin users legitimately setting roles for other users
3. **Internal microservices** — service-to-service calls with elevated privileges (by design)
4. **Test fixtures** — role assignments in test setup code
