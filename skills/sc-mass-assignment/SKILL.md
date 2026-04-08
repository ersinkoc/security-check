---
name: sc-mass-assignment
description: Mass assignment and over-posting detection — unfiltered request body binding to data models
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Mass Assignment / Over-Posting

## Purpose

Detects mass assignment vulnerabilities where HTTP request body fields are bound directly to data models without field filtering, allowing attackers to set fields they should not have access to (e.g., isAdmin, role, price, verified). Covers framework-specific patterns across all major web frameworks.

## Activation

Called by sc-orchestrator during Phase 2 when web frameworks with model binding are detected.

## Phase 1: Discovery

### Keyword Patterns to Search
```
"req.body", "request.body", "request.POST", "request.data",
"@RequestBody", "[FromBody]", "$request->all()",
"Model.create(", "Model.update(", "Object.assign(",
"fillable", "guarded", "attr_accessible",
"ModelForm", "Serializer", "DTO"
```

### Vulnerability Patterns

**Node.js/Express:**
```javascript
// VULNERABLE: Spread all body fields into create
app.post('/users', async (req, res) => {
  const user = await User.create(req.body);
  // If body = { name: "hacker", email: "...", role: "admin" }
  // Attacker becomes admin!
});

// SAFE: Pick only allowed fields
app.post('/users', async (req, res) => {
  const user = await User.create({
    name: req.body.name,
    email: req.body.email
  });
});
```

**Django:**
```python
# VULNERABLE: ModelForm without fields restriction
class UserForm(ModelForm):
    class Meta:
        model = User
        fields = '__all__'  # Includes is_staff, is_superuser!

# SAFE: Explicit field list
class UserForm(ModelForm):
    class Meta:
        model = User
        fields = ['name', 'email', 'bio']
```

**Laravel:**
```php
// VULNERABLE: No $fillable or $guarded
class User extends Model {
    // All fields are mass-assignable!
}
$user = User::create($request->all());

// SAFE: Define fillable fields
class User extends Model {
    protected $fillable = ['name', 'email'];
}
```

**Spring Boot:**
```java
// VULNERABLE: Binding all request params to model
@PostMapping("/users")
public User createUser(@ModelAttribute User user) {
    return userRepository.save(user);
}

// SAFE: Use DTO
@PostMapping("/users")
public User createUser(@RequestBody CreateUserDTO dto) {
    User user = new User();
    user.setName(dto.getName());
    user.setEmail(dto.getEmail());
    return userRepository.save(user);
}
```

**ASP.NET:**
```csharp
// VULNERABLE: Binding all properties
[HttpPost]
public IActionResult Create([FromBody] User user) {
    _context.Users.Add(user);
}

// SAFE: Use [Bind] attribute or DTO
[HttpPost]
public IActionResult Create([Bind("Name,Email")] User user) {
    _context.Users.Add(user);
}
```

## Severity Classification

- **Critical:** Mass assignment allowing role escalation to admin
- **High:** Setting price, verified status, or permissions via mass assignment
- **Medium:** Setting non-critical but unintended fields (profile fields of other users)
- **Low:** Mass assignment in admin-only endpoints or internal tools

## Output Format

### Finding: MASS-{NNN}
- **Title:** Mass Assignment in {endpoint/model}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-915 (Improperly Controlled Modification of Dynamically-Determined Object Attributes)
- **Description:** Request body is bound to {model} without field filtering at {endpoint}.
- **Impact:** Privilege escalation, data manipulation, unauthorized field modification.
- **Remediation:** Use allowlist of permitted fields, DTOs, or framework-specific protection ($fillable, fields=[], [Bind]).
- **References:** https://cwe.mitre.org/data/definitions/915.html

## Common False Positives

1. **DTO/ViewModel patterns** — request bound to DTO that only has safe fields
2. **Admin endpoints** — admin users may legitimately set all fields
3. **$fillable properly set** — Laravel model with restrictive $fillable array
4. **Zod/Joi validation** — schema validation stripping unknown fields before model creation
