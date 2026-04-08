---
name: sc-authz
description: Authorization flaw detection — IDOR, broken access control, horizontal and vertical privilege issues
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Authorization Flaws (IDOR / Broken Access Control)

## Purpose

Detects authorization vulnerabilities where authenticated users can access resources belonging to other users (IDOR/horizontal escalation), access admin functions without proper role checks (vertical escalation), or bypass access control through parameter manipulation. Traces from route handler to data access to verify that ownership or role checks are enforced.

## Activation

Called by sc-orchestrator during Phase 2. Runs against all web applications and APIs.

## Phase 1: Discovery

### File Patterns to Search
```
**/*controller*, **/*handler*, **/*route*, **/*endpoint*,
**/*service*, **/*repository*, **/*middleware*, **/*guard*,
**/*policy*, **/*permission*, **/*role*, **/*authorization*
```

### Keyword Patterns to Search
```
# Direct object references
"params.id", "params.userId", "req.params", "request.args",
"$_GET['id']", "PathVariable", "[FromRoute]",
"r.URL.Query().Get(", "mux.Vars("

# Data access without ownership check
"findById(", "findByPk(", "findOne({id:", "get_object_or_404(",
"User.find(", ".where(id:", "GetById(", "Find(&"

# Missing role checks
"isAdmin", "role ==", "hasRole(", "hasPermission(",
"@PreAuthorize", "@Secured", "[Authorize(",
"@login_required", "@permission_required"
```

### IDOR Detection Pattern

Trace from HTTP route parameter to database query and check if user ownership is verified:

```javascript
// VULNERABLE: No ownership check — any authenticated user can access any order
app.get('/api/orders/:id', auth, async (req, res) => {
  const order = await Order.findById(req.params.id);
  res.json(order);
});

// SAFE: Ownership check ensures user can only access their own orders
app.get('/api/orders/:id', auth, async (req, res) => {
  const order = await Order.findOne({
    _id: req.params.id,
    userId: req.user.id  // Ownership check
  });
  if (!order) return res.status(404).json({ error: 'Not found' });
  res.json(order);
});
```

```python
# VULNERABLE: Django view without ownership check
def order_detail(request, order_id):
    order = get_object_or_404(Order, pk=order_id)
    return JsonResponse(model_to_dict(order))

# SAFE: Filter by user
def order_detail(request, order_id):
    order = get_object_or_404(Order, pk=order_id, user=request.user)
    return JsonResponse(model_to_dict(order))
```

### Missing Function-Level Access Control
```java
// VULNERABLE: Admin endpoint without role check
@GetMapping("/api/admin/users")
public List<User> getAllUsers() {
    return userRepository.findAll();
}

// SAFE: Role-based access control
@GetMapping("/api/admin/users")
@PreAuthorize("hasRole('ADMIN')")
public List<User> getAllUsers() {
    return userRepository.findAll();
}
```

## Phase 2: Verification

### Verification Steps
1. Does the route handler accept a resource ID from the URL/body?
2. Is the resource fetched using only that ID (no user filter)?
3. Is the authenticated user's ID checked against the resource owner?
4. Are admin endpoints protected by role-checking middleware?
5. Is there middleware that automatically enforces ownership?

## Severity Classification

- **Critical:** IDOR allowing access to all users' data, or admin function without any auth check
- **High:** IDOR on sensitive resources (financial, medical, personal data), role bypass on admin endpoints
- **Medium:** IDOR on less sensitive resources, or missing checks on uncommon endpoints
- **Low:** IDOR that exposes minimal information, or in internal/admin tools

## Output Format

### Finding: AUTHZ-{NNN}
- **Title:** {IDOR | Missing Access Control | Role Bypass} in {endpoint}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-639 (IDOR) | CWE-862 (Missing Authorization) | CWE-863 (Incorrect Authorization)
- **Description:** {Endpoint} fetches {resource} using client-supplied ID without verifying ownership.
- **Impact:** Unauthorized access to other users' data, admin function access by regular users.
- **Remediation:** Add ownership check to database query. Use middleware-based authorization.
- **References:** https://cwe.mitre.org/data/definitions/639.html

## Common False Positives

1. **Public resources** — endpoints serving public data (product catalog, blog posts) don't need ownership checks
2. **Admin-scoped routes** — routes behind admin middleware may not need individual ownership checks
3. **Self-referencing endpoints** — `GET /api/me/profile` uses authenticated user's ID, not a URL parameter
4. **Multi-tenant middleware** — tenant isolation enforced at middleware/database level, not in each query
5. **GraphQL dataloaders** — authorization may be enforced in the dataloader layer, not the resolver
