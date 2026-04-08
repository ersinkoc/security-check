---
name: sc-nosqli
description: NoSQL Injection detection for MongoDB, Redis, CouchDB, and Elasticsearch
---

# SC: NoSQL Injection

## Purpose

Detects NoSQL injection vulnerabilities where user-controlled input manipulates NoSQL database queries. Unlike SQL injection, NoSQL injection exploits operator injection, JSON structure manipulation, and JavaScript execution within query contexts. Covers MongoDB, Redis, CouchDB, DynamoDB, and Elasticsearch.

## Activation

Called by sc-orchestrator during Phase 2. Runs when NoSQL databases are detected in the architecture.

## Phase 1: Discovery

### File Patterns to Search
```
**/*.ts, **/*.js, **/*.py, **/*.php, **/*.java, **/*.go, **/*.cs,
**/models/*, **/controllers/*, **/services/*, **/repositories/*,
**/*mongo*, **/*redis*, **/*elastic*, **/*couch*, **/*dynamo*
```

### Keyword Patterns to Search
```
# MongoDB
"find(", "findOne(", "findOneAndUpdate(", "findOneAndDelete(",
"aggregate(", "updateOne(", "updateMany(", "deleteOne(", "deleteMany(",
"$where", "$regex", "$gt", "$gte", "$lt", "$lte", "$ne", "$in", "$nin",
"$or", "$and", "$not", "$exists", "$expr",
"MongoClient", "mongoose.model", "collection.find"

# Redis
"redis.get(", "redis.set(", "redis.eval(", "redis.send_command(",
"EVAL ", "EVALSHA", "redis.call("

# Elasticsearch
"client.search(", "client.index(", "query_string",
"script_score", "painless", "elasticsearch"

# CouchDB
"_find", "mango", "cloudant"
```

### Data Flow Tracing

**Sources:** HTTP request body (JSON), query parameters, headers, cookies

**Sinks:**
- MongoDB: `collection.find()`, `collection.findOne()`, `Model.find()`, `aggregate()` — when query object is constructed from user input
- Redis: `EVAL` with user input in script, `redis.send_command()` with dynamic commands
- Elasticsearch: `query_string` query with user input, `script` fields with user input

## Phase 2: Verification

### Exploitability Checklist
1. Can the attacker inject MongoDB operators (`$gt`, `$ne`, `$regex`, `$where`) into the query?
2. Can the attacker modify the query structure by injecting JSON keys?
3. Can the attacker inject JavaScript code into `$where` or `$function` expressions?
4. Is the request body parsed as JSON and passed directly to the database driver?

### Sanitization Check
1. Is input validated against expected types (string, number, ObjectId)?
2. Are MongoDB operators stripped from user input?
3. Is input sanitized using a library like `mongo-sanitize` or `express-mongo-sanitize`?
4. Is Mongoose schema validation enforced before query execution?

### Framework Protection Check
- **Mongoose with schema:** Schema validation prevents type confusion but NOT operator injection in `.find()` with raw objects
- **Prisma (MongoDB):** Prisma abstracts queries and prevents operator injection
- **Spring Data MongoDB:** `MongoTemplate` with `Criteria` API is safe; raw query strings are not

### MongoDB Operator Injection Example

```javascript
// VULNERABLE: User input directly in query object
app.post('/login', async (req, res) => {
  const user = await User.findOne({
    username: req.body.username,
    password: req.body.password
  });
});
// Attack: POST {"username":"admin","password":{"$ne":""}}
// This returns any user where password is not empty — bypasses auth

// SAFE: Validate input types
app.post('/login', async (req, res) => {
  if (typeof req.body.username !== 'string' || typeof req.body.password !== 'string') {
    return res.status(400).json({ error: 'Invalid input' });
  }
  const user = await User.findOne({
    username: req.body.username,
    password: req.body.password
  });
});
```

### MongoDB $where Injection

```javascript
// VULNERABLE: User input in $where JavaScript expression
const results = await collection.find({
  $where: `this.category == '${req.query.category}'`
});
// Attack: ?category=' || true || '
// Executes arbitrary JavaScript on the server

// SAFE: Use standard query operators
const results = await collection.find({
  category: req.query.category
});
```

### Redis EVAL Injection

```python
# VULNERABLE: User input in Redis Lua script
script = f"return redis.call('get', '{user_input}')"
result = redis_client.eval(script, 0)

# SAFE: Use parameterized Redis commands
result = redis_client.get(user_input)
```

### Elasticsearch Query String Injection

```javascript
// VULNERABLE: User input in query_string
const results = await client.search({
  query: {
    query_string: {
      query: req.query.search  // User can inject Lucene syntax
    }
  }
});

// SAFE: Use match query instead
const results = await client.search({
  query: {
    match: {
      content: req.query.search
    }
  }
});
```

## Severity Classification

- **Critical:** Authentication bypass via operator injection, or JavaScript execution via `$where`/`$function` with user input
- **High:** Data exfiltration through query manipulation, unauthorized access to other users' data
- **Medium:** Query manipulation with limited impact (e.g., bypassing filter conditions)
- **Low:** Information disclosure through error messages revealing database structure

## Output Format

### Finding: NOSQLI-{NNN}
- **Title:** NoSQL Injection in {function/endpoint}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-943 (Improper Neutralization of Special Elements in Data Query Logic)
- **Description:** User input is passed directly into {database} query allowing operator injection.
- **Proof of Concept:** Attacker sends `{"$ne": ""}` as the {parameter} to bypass equality check.
- **Impact:** {Authentication bypass / data exfiltration / unauthorized data modification}
- **Remediation:** Validate input types, use `mongo-sanitize`, or use an ORM that prevents operator injection.
- **References:** https://cwe.mitre.org/data/definitions/943.html, https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/07-Input_Validation_Testing/05.6-Testing_for_NoSQL_Injection

## Common False Positives

1. **Prisma/Mongoose with strict schema** — typed models prevent operator injection when schema validation is enforced
2. **Hardcoded queries** — query objects built entirely from constants, not user input
3. **Internal service-to-service calls** — query parameters come from trusted internal services, not HTTP requests
4. **Admin/seed scripts** — database operations in setup scripts that don't handle user input
5. **Aggregation pipelines with static structure** — pipeline stages defined in code with only values from user input (parameterized)
