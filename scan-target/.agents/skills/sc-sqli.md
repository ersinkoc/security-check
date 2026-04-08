---
name: sc-sqli
description: SQL Injection detection across all variants — classic, blind, time-based, second-order, and UNION-based
---

# SC: SQL Injection

## Purpose

Detects SQL injection vulnerabilities in all forms: classic (error-based), blind (boolean and time-based), UNION-based, second-order, and ORM bypass patterns. Traces user input from HTTP request parameters through application logic to database query construction, identifying points where unsanitized data enters SQL statements.

## Activation

Called by sc-orchestrator during Phase 2 (Vulnerability Hunting). Runs against all detected languages.

## Phase 1: Discovery

### File Patterns to Search
```
**/*.go, **/*.ts, **/*.js, **/*.py, **/*.php, **/*.java, **/*.kt, **/*.cs,
**/*.rb, **/routes/*, **/controllers/*, **/models/*, **/repositories/*,
**/dal/*, **/dao/*, **/*query*, **/*sql*, **/*database*, **/*db*
```

### Keyword Patterns to Search
```
# Direct SQL construction
"SELECT.*FROM"           # SQL SELECT statements
"INSERT INTO"            # SQL INSERT
"UPDATE.*SET"            # SQL UPDATE
"DELETE FROM"            # SQL DELETE
"EXEC ", "EXECUTE "      # Stored procedure execution

# String concatenation in queries
"+ .*query"              # String concat with query variable
`${.*}`.*SELECT          # Template literals in SQL
f"SELECT, f"INSERT       # Python f-strings in SQL
"WHERE.*=.*'" + "        # String concat in WHERE clause
".format(.*)".*SELECT    # str.format() in SQL

# Language-specific database calls
"db.Query(", "db.Exec("              # Go database/sql
"sequelize.query(", ".rawQuery("     # Node.js Sequelize
"cursor.execute(", "connection.execute("  # Python DB-API
"$wpdb->query(", "->whereRaw("      # PHP WordPress/Laravel
"createNativeQuery(", "createQuery(" # Java JPA
"FromSqlRaw(", "ExecuteSqlRaw("      # C# Entity Framework
```

### Semantic Patterns
1. **String concatenation** — any variable concatenated into a string that is later passed to a database query function
2. **Template literal interpolation** — variables embedded in SQL via template literals or f-strings
3. **ORM raw query methods** — framework ORM methods that accept raw SQL strings
4. **Stored procedure calls** — dynamic stored procedure name or parameter construction
5. **Query builder misuse** — using `.where()` with raw strings instead of parameterized objects

### Data Flow Tracing (Source → Sink)

**Sources (user input):**
- `req.query.*`, `req.params.*`, `req.body.*` (Express/Node)
- `request.GET`, `request.POST`, `request.data` (Django)
- `$_GET`, `$_POST`, `$_REQUEST`, `$_COOKIE` (PHP)
- `r.URL.Query()`, `r.FormValue()`, `r.PathValue()` (Go)
- `@RequestParam`, `@PathVariable`, `@RequestBody` (Spring)
- `[FromQuery]`, `[FromRoute]`, `[FromBody]` (ASP.NET)

**Sinks (database queries):**
- `db.Query()`, `db.Exec()`, `db.QueryRow()` (Go)
- `sequelize.query()`, `knex.raw()`, `prisma.$queryRaw()` (Node)
- `cursor.execute()`, `RawSQL()`, `.extra()`, `.raw()` (Python)
- `$pdo->query()`, `mysqli_query()`, `DB::select(DB::raw())` (PHP)
- `createNativeQuery()`, `session.createSQLQuery()` (Java)
- `.FromSqlRaw()`, `.ExecuteSqlRaw()` (C#)

## Phase 2: Verification

For each candidate finding:

### Exploitability Checklist
1. Can user-controlled input reach the SQL query without modification?
2. Is the input inserted into the SQL structure (not just values)?
3. Can the attacker control the position of quotes, operators, or keywords?
4. Is there a way to observe the result (error messages, data differences, timing)?

### Sanitization Check
1. Is input passed through a parameterized query / prepared statement?
2. Is input cast to a specific type (integer, UUID) before use?
3. Is input validated against an allowlist of expected values?
4. Is input escaped using a database-specific escape function?

### Framework Protection Check
- **Django ORM:** `.filter()`, `.get()`, `.exclude()` are safe. `.raw()`, `.extra()`, `RawSQL()` are not.
- **SQLAlchemy:** `session.query()` with model attributes is safe. `text()` with f-strings is not.
- **ActiveRecord:** `.where(hash)` is safe. `.where("string #{var}")` is not.
- **Prisma:** All standard methods are safe. `$queryRaw` with template literal (tagged) is safe. `$queryRawUnsafe` is not.
- **GORM:** `.Where(struct)` is safe. `.Where("name = " + input)` is not.
- **Entity Framework:** LINQ queries are safe. `.FromSqlRaw(interpolated)` is not.
- **Hibernate:** Criteria API is safe. HQL with concatenation is not.

### Context-Aware False Positive Elimination
1. Is the "query" actually a search query against a search engine (Elasticsearch), not SQL?
2. Is the variable a constant/enum, not user input?
3. Is the concatenation building a query that uses parameterized placeholders?
4. Is the code in a migration file, seed file, or schema definition (not runtime)?

## Severity Classification

- **Critical:** Direct SQL injection from HTTP parameter into database query with no sanitization, affecting authentication or data retrieval. User can read/write/delete arbitrary data.
- **High:** SQL injection that requires specific conditions (e.g., certain parameter values, authenticated user) or affects limited data scope.
- **Medium:** Second-order SQL injection (stored input used later in query), or injection in admin-only endpoints.
- **Low:** SQL injection in dead code, test code, or with strong compensating controls (WAF, input validation that limits exploitation).

## Language-Specific Notes

### Go
```go
// VULNERABLE: String concatenation in query
query := "SELECT * FROM users WHERE id = " + r.URL.Query().Get("id")
rows, err := db.Query(query)

// SAFE: Parameterized query
rows, err := db.Query("SELECT * FROM users WHERE id = $1", r.URL.Query().Get("id"))
```

### TypeScript/JavaScript
```typescript
// VULNERABLE: Template literal in raw query
const users = await prisma.$queryRawUnsafe(`SELECT * FROM users WHERE name = '${req.query.name}'`)

// SAFE: Tagged template (Prisma parameterizes these)
const users = await prisma.$queryRaw`SELECT * FROM users WHERE name = ${req.query.name}`
```

### Python
```python
# VULNERABLE: f-string in SQL
cursor.execute(f"SELECT * FROM users WHERE id = {request.GET['id']}")

# SAFE: Parameterized query
cursor.execute("SELECT * FROM users WHERE id = %s", [request.GET['id']])
```

### PHP
```php
// VULNERABLE: Direct interpolation
$result = $pdo->query("SELECT * FROM users WHERE id = " . $_GET['id']);

// SAFE: Prepared statement
$stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
$stmt->execute([$_GET['id']]);
```

### Java
```java
// VULNERABLE: String concatenation in JDBC
String query = "SELECT * FROM users WHERE id = " + request.getParameter("id");
ResultSet rs = stmt.executeQuery(query);

// SAFE: Prepared statement
PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
ps.setString(1, request.getParameter("id"));
ResultSet rs = ps.executeQuery();
```

### C#
```csharp
// VULNERABLE: String interpolation in raw SQL
var users = context.Users.FromSqlRaw($"SELECT * FROM Users WHERE Id = {id}").ToList();

// SAFE: Parameterized
var users = context.Users.FromSqlRaw("SELECT * FROM Users WHERE Id = {0}", id).ToList();
```

## Output Format

### Finding: SQLI-{NNN}
- **Title:** SQL Injection in {function/endpoint}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-89 (SQL Injection)
- **Description:** User input from {source} is concatenated into SQL query at {sink} without parameterization.
- **Proof of Concept:** An attacker could supply `' OR 1=1 --` as the {parameter} to bypass the WHERE clause and retrieve all records.
- **Impact:** Unauthorized data access, data modification, authentication bypass, potential remote code execution via database features (xp_cmdshell, LOAD_FILE).
- **Remediation:** Use parameterized queries or prepared statements. Replace string concatenation with query placeholders.
- **References:** https://cwe.mitre.org/data/definitions/89.html, https://owasp.org/Top10/A03_2021-Injection/

## Common False Positives

1. **ORM standard methods** — `.filter()`, `.findOne()`, LINQ queries are parameterized by default
2. **Prisma tagged templates** — `prisma.$queryRaw\`...\`` auto-parameterizes (but `$queryRawUnsafe` does not)
3. **Search engine queries** — Elasticsearch DSL, MongoDB queries are not SQL
4. **Schema/migration files** — DDL statements in migration files are not user-input-driven
5. **Constants in queries** — `"SELECT * FROM users WHERE role = 'admin'"` with no variable input
6. **Query builders with safe API** — `knex('users').where('id', input)` parameterizes automatically
7. **Type-safe inputs** — When input is guaranteed to be an integer via type casting before reaching query
