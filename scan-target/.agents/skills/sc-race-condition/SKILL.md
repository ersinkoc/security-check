---
name: sc-race-condition
description: Race condition and TOCTOU detection — database races, file system races, double-spend, and atomicity failures
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Race Conditions / TOCTOU

## Purpose

Detects race condition vulnerabilities where concurrent operations on shared state lead to inconsistent or exploitable behavior. Covers database read-modify-write races, file system time-of-check-to-time-of-use (TOCTOU), double-spend attacks, counter increment without atomicity, missing database transactions, and concurrent request exploitation.

## Activation

Called by sc-orchestrator during Phase 2. Runs against all applications with concurrent processing.

## Phase 1: Discovery

### Keyword Patterns to Search
```
"balance", "counter", "inventory", "stock", "quantity",
"increment", "decrement", "transfer", "withdraw",
"transaction", "BEGIN", "COMMIT", "ROLLBACK",
"Lock", "Mutex", "synchronized", "atomic",
"SELECT.*FOR UPDATE", "SERIALIZABLE"
```

### Vulnerability Patterns

**1. Database Read-Modify-Write Without Lock:**
```python
# VULNERABLE: Race condition on balance check
def withdraw(user_id, amount):
    user = User.objects.get(id=user_id)
    if user.balance >= amount:  # CHECK
        user.balance -= amount   # MODIFY
        user.save()              # WRITE
    # Two concurrent requests can both pass the check!

# SAFE: Atomic update with database-level lock
from django.db import transaction
from django.db.models import F

def withdraw(user_id, amount):
    with transaction.atomic():
        user = User.objects.select_for_update().get(id=user_id)
        if user.balance >= amount:
            user.balance = F('balance') - amount
            user.save()
```

**2. Non-Atomic Counter:**
```javascript
// VULNERABLE: Counter increment without atomicity
app.post('/like/:postId', async (req, res) => {
  const post = await Post.findById(req.params.postId);
  post.likes += 1;  // Lost update under concurrent requests
  await post.save();
});

// SAFE: Atomic increment
app.post('/like/:postId', async (req, res) => {
  await Post.findByIdAndUpdate(req.params.postId, { $inc: { likes: 1 } });
});
```

**3. File System TOCTOU:**
```go
// VULNERABLE: Check then use
if _, err := os.Stat(filepath); err == nil {  // CHECK
    data, _ := os.ReadFile(filepath)           // USE — file may have changed!
}

// SAFE: Just open and handle error
data, err := os.ReadFile(filepath)
if err != nil { /* handle */ }
```

**4. Coupon Double-Use:**
```python
# VULNERABLE: Check-then-mark race
def apply_coupon(coupon_code, order_id):
    coupon = Coupon.objects.get(code=coupon_code)
    if not coupon.used:     # Both requests see used=False
        apply_discount(order_id, coupon.discount)
        coupon.used = True
        coupon.save()

# SAFE: Atomic check-and-mark
def apply_coupon(coupon_code, order_id):
    with transaction.atomic():
        updated = Coupon.objects.filter(
            code=coupon_code, used=False
        ).update(used=True)
        if updated == 1:
            apply_discount(order_id, coupon.discount)
```

## Severity Classification

- **Critical:** Financial double-spend, balance manipulation through race conditions
- **High:** Inventory overselling, coupon double-use, privilege escalation via race
- **Medium:** Counter manipulation, file system TOCTOU in non-critical paths
- **Low:** Race conditions in logging, analytics, or non-critical counters

## Output Format

### Finding: RACE-{NNN}
- **Title:** {Race condition type} in {function}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-362 (Race Condition) | CWE-367 (TOCTOU)
- **Description:** {Read-modify-write on shared state without atomicity/locking}
- **Impact:** {Financial loss, data inconsistency, double-spending}
- **Remediation:** Use database transactions with SELECT FOR UPDATE, atomic operations, or mutex locks.
- **References:** https://cwe.mitre.org/data/definitions/362.html

## Common False Positives

1. **Read-only operations** — concurrent reads don't cause race conditions
2. **Idempotent operations** — operations that produce the same result regardless of repetition
3. **Single-instance applications** — no concurrent processing (but still risky under load)
4. **Database-level constraints** — unique constraints preventing double-insertion
