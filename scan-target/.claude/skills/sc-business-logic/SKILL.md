---
name: sc-business-logic
description: Business logic flaw detection — price manipulation, workflow bypass, race conditions, and abuse vectors
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Business Logic Flaws

## Purpose

Detects business logic vulnerabilities that arise from flawed application workflows rather than technical implementation errors. Covers price/quantity manipulation, coupon abuse, workflow step bypassing, negative value attacks, account enumeration, and reward system abuse. These vulnerabilities cannot be detected by pattern matching alone — they require understanding of the application's intended behavior.

## Activation

Called by sc-orchestrator during Phase 2. Runs against web applications with business workflows.

## Phase 1: Discovery

### Keyword Patterns to Search
```
"price", "amount", "quantity", "discount", "coupon",
"total", "balance", "credit", "transfer", "payment",
"checkout", "cart", "order", "refund", "reward",
"referral", "bonus", "limit", "quota", "threshold"
```

### Vulnerability Categories

**1. Price/Quantity Manipulation:**
```javascript
// VULNERABLE: Trusting client-side price
app.post('/checkout', (req, res) => {
  const total = req.body.items.reduce((sum, item) =>
    sum + item.price * item.quantity, 0  // Client sends price!
  );
  charge(req.user, total);
});

// SAFE: Server-side price lookup
app.post('/checkout', (req, res) => {
  const total = await Promise.all(req.body.items.map(async item => {
    const product = await Product.findById(item.productId);
    return product.price * item.quantity;
  })).then(prices => prices.reduce((a, b) => a + b, 0));
});
```

**2. Negative Quantity/Amount:**
```python
# VULNERABLE: No negative check
def transfer(request):
    amount = int(request.POST['amount'])  # amount = -1000
    sender.balance -= amount   # Adds 1000!
    receiver.balance += amount  # Subtracts 1000!

# SAFE
amount = int(request.POST['amount'])
if amount <= 0:
    raise ValidationError("Amount must be positive")
```

**3. Workflow Step Bypass:**
```javascript
// VULNERABLE: Can skip directly to confirmation without payment
app.post('/order/confirm', auth, (req, res) => {
  Order.update(req.body.orderId, { status: 'confirmed' });
});

// SAFE: Verify payment was completed
app.post('/order/confirm', auth, async (req, res) => {
  const order = await Order.findById(req.body.orderId);
  if (order.status !== 'paid') {
    return res.status(400).json({ error: 'Payment required' });
  }
  order.status = 'confirmed';
  await order.save();
});
```

**4. Coupon/Discount Abuse:**
Check for: single-use coupons applied multiple times, percentage discounts exceeding 100%, stacking multiple exclusive coupons, applying expired coupons.

**5. Account Enumeration:**
Different responses for "user not found" vs "wrong password" reveals account existence.

## Severity Classification

- **Critical:** Price manipulation allowing free purchases, negative amount enabling fund theft
- **High:** Workflow bypass skipping payment, unlimited coupon use
- **Medium:** Account enumeration, minor discount abuse
- **Low:** Referral gaming, cosmetic logic flaws

## Output Format

### Finding: BIZ-{NNN}
- **Title:** {Business logic flaw type}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-840 (Business Logic Errors)
- **Description:** {What was found and how it violates intended business rules}
- **Impact:** Financial loss, service abuse, competitive advantage.
- **Remediation:** {Server-side validation, workflow state machine, invariant checks}
- **References:** https://cwe.mitre.org/data/definitions/840.html

## Common False Positives

1. **Admin override capabilities** — admin users legitimately bypassing restrictions
2. **Internal tools** — backend tools with intentionally relaxed validation
3. **Test/staging environments** — relaxed limits for testing purposes
