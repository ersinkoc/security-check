---
name: sc-recon
description: Codebase discovery and architecture mapping for security analysis
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Reconnaissance — Codebase Discovery & Architecture Mapping

## Purpose

The reconnaissance skill is the foundation of the entire security-check pipeline. It maps the codebase architecture, identifies all technologies in use, traces data flow paths, and catalogs entry points and trust boundaries. Its output determines which subsequent skills are activated and provides critical context for accurate vulnerability detection.

## Activation

First skill executed in Phase 1 of the pipeline. Runs before all other skills.

## Output

File: `security-report/architecture.md`

## Discovery Process

### 1. Technology Stack Detection

Identify all technologies by examining:

**Languages:**
- File extensions: `.go`, `.ts`, `.tsx`, `.js`, `.jsx`, `.py`, `.php`, `.rs`, `.java`, `.kt`, `.cs`, `.rb`, `.swift`, `.c`, `.cpp`
- Count lines of code per language for relative weight
- Determine primary vs secondary languages

**Frameworks:**
- Go: look for `gin`, `echo`, `fiber`, `chi`, `gorilla/mux`, `net/http` in imports
- TypeScript/JS: check `package.json` for `react`, `next`, `express`, `fastify`, `nestjs`, `vue`, `angular`, `svelte`
- Python: check `requirements.txt`/`pyproject.toml` for `django`, `flask`, `fastapi`, `tornado`, `starlette`
- PHP: check `composer.json` for `laravel/framework`, `symfony`, `wordpress`
- Rust: check `Cargo.toml` for `actix-web`, `axum`, `rocket`, `warp`, `tokio`
- Java: check `pom.xml`/`build.gradle` for `spring-boot`, `quarkus`, `micronaut`, `jakarta`
- C#: check `.csproj` for `Microsoft.AspNetCore`, `Blazor`, `MAUI`

**Build Tools & Package Managers:**
- `package.json` / `pnpm-workspace.yaml` / `turbo.json` → Node.js ecosystem
- `go.mod` / `go.sum` → Go modules
- `Cargo.toml` / `Cargo.lock` → Rust/Cargo
- `requirements.txt` / `pyproject.toml` / `Pipfile` / `poetry.lock` → Python
- `composer.json` / `composer.lock` → PHP/Composer
- `pom.xml` / `build.gradle` / `build.gradle.kts` → Java/Maven/Gradle
- `*.csproj` / `*.sln` / `nuget.config` → .NET

**Databases:**
- Search for connection strings, ORM configs, migration files
- Detect: PostgreSQL, MySQL, MongoDB, Redis, SQLite, Elasticsearch, DynamoDB
- Check for ORMs: Prisma, Drizzle, GORM, SQLAlchemy, Hibernate, Entity Framework, Eloquent

### 2. Application Type Classification

Determine the application type based on detected patterns:

| Type | Indicators |
|------|-----------|
| Web Application | HTML templates, static assets, frontend framework, server-side rendering |
| REST API | Route definitions, JSON response handlers, OpenAPI/Swagger spec |
| GraphQL API | Schema definitions (`.graphql`), resolvers, Apollo/Yoga config |
| gRPC Service | `.proto` files, gRPC server setup |
| CLI Tool | Argument parsers (cobra, click, yargs), main entry without HTTP server |
| Library/Package | Public API exports, no main entry, published package config |
| Microservice | Small scope, message queue consumers, service mesh config |
| Monolith | Large codebase, multiple domains, shared database |
| Serverless | Lambda handlers, `serverless.yml`, CloudFormation templates |
| Desktop App | Electron, Tauri, .NET MAUI, WPF references |

### 3. Entry Points Mapping

Catalog all entry points where external input enters the system:

**HTTP Routes:**
- Search for route registration patterns per framework
- Map: method (GET/POST/PUT/DELETE), path, handler function, middleware chain
- Flag routes without authentication middleware

**CLI Commands:**
- Search for argument/flag definitions
- Map: command name, arguments, environment variable reads

**Message Consumers:**
- Search for queue/topic subscriptions (RabbitMQ, Kafka, SQS, NATS)
- Map: queue name, handler function, message format

**Scheduled Tasks:**
- Search for cron definitions, scheduled job registrations
- Map: schedule, handler function

**WebSocket Endpoints:**
- Search for WebSocket upgrade handlers
- Map: endpoint, message handlers

**File Watchers / Event Handlers:**
- Search for filesystem watchers, event emitters
- Map: event source, handler function

### 4. Data Flow Map

Trace the path of user input through the system:

**Source identification** — where external data enters:
- HTTP request body, query params, headers, cookies, URL path segments
- File uploads, form data
- WebSocket messages
- CLI arguments, stdin
- Environment variables, config files
- Database reads (if data was originally user-supplied)

**Processing identification** — how data is transformed:
- Validation functions, sanitization middleware
- ORM/query builder operations
- Serialization/deserialization steps
- Template rendering
- File system operations

**Sink identification** — where data is consumed in security-sensitive operations:
- Database queries (SQL, NoSQL)
- Command execution (shell, process spawn)
- File system operations (read, write, delete)
- HTTP responses (rendered HTML, JSON, headers)
- Outbound HTTP requests (URL, headers, body)
- Logging operations
- Email/notification sending

### 5. Trust Boundaries

Identify security control points:

**Authentication:**
- Auth middleware/guards in route definitions
- Session validation logic
- Token verification (JWT, API key, OAuth)
- Routes that bypass authentication (public endpoints)

**Rate Limiting:**
- Rate limiter middleware configuration
- Per-endpoint vs global rate limits
- Rate limit bypass conditions

**Input Validation:**
- Schema validation (Zod, Joi, Pydantic, Bean Validation)
- Custom validation functions
- Framework-level auto-validation

**CSRF Protection:**
- CSRF token middleware
- SameSite cookie configuration
- Endpoints excluded from CSRF

**CORS Configuration:**
- CORS middleware configuration
- Allowed origins, methods, headers
- Credentials policy

### 6. External Integrations

Map all external service connections:

- **Databases:** connection strings, pool configs, TLS settings
- **Caches:** Redis, Memcached connections and usage patterns
- **Message Queues:** RabbitMQ, Kafka, SQS connections
- **Third-Party APIs:** HTTP clients making outbound calls, API keys used
- **Email Services:** SMTP config, transactional email providers
- **Cloud Services:** AWS SDK, GCP client, Azure SDK usage
- **CDN/Storage:** S3, GCS, Azure Blob, CloudFront configuration
- **Monitoring:** APM agents, error tracking (Sentry, DataDog)

### 7. Authentication Architecture

Determine the authentication model:

| Pattern | Indicators |
|---------|-----------|
| Session-based | Session middleware, cookie config, session store |
| JWT | JWT library imports, token sign/verify calls |
| OAuth 2.0 | OAuth provider config, callback handlers, token exchange |
| API Key | Header/query param key extraction, key validation |
| mTLS | Certificate loading, TLS client auth config |
| Basic Auth | Base64 credential parsing, WWW-Authenticate header |
| SSO/SAML | SAML assertion processing, IdP configuration |

Document:
- Where tokens/sessions are stored
- Token lifetime and refresh logic
- Password hashing algorithm used
- MFA implementation (if any)
- Account lockout policy (if any)

### 8. File Structure Analysis

Identify security-sensitive files and paths:

**Configuration files:**
- `.env`, `.env.production`, `.env.local`
- `config.json`, `config.yaml`, `settings.py`, `application.properties`
- `appsettings.json`, `web.config`

**Sensitive paths:**
- `/admin`, `/debug`, `/metrics`, `/health`
- `/.git`, `/.env`, `/backup`
- API documentation endpoints (`/swagger`, `/graphql`, `/api-docs`)

**Deployment files:**
- `Dockerfile`, `docker-compose.yml`
- `kubernetes/`, `k8s/`, `helm/`
- `terraform/`, `*.tf`
- `.github/workflows/`, `.gitlab-ci.yml`

### 9. Detected Security Controls

Catalog existing security measures:

- **WAF/Firewall:** Cloudflare, AWS WAF references
- **CSP:** Content-Security-Policy header configuration
- **CORS:** Cross-Origin Resource Sharing config
- **Rate Limiter:** Rate limiting middleware
- **Input Sanitization:** DOMPurify, bleach, html/template usage
- **Helmet/Headers:** Security header middleware (helmet.js, secure-headers)
- **CSRF Tokens:** Anti-CSRF middleware
- **Encryption at Rest:** Data encryption configuration
- **Audit Logging:** Security event logging

### 10. Language Detection Summary

Produce a definitive list of detected languages that determines which `sc-lang-*` skills run in Phase 2:

```markdown
## Detected Languages
- Go (45% of codebase) → activates sc-lang-go
- TypeScript (35% of codebase) → activates sc-lang-typescript
- Python (20% of codebase, scripts/tools only) → activates sc-lang-python
```

## Output Format

The output file `security-report/architecture.md` must contain all 10 sections above with concrete findings specific to the scanned codebase. Each section should include file paths and line references where applicable.

## Common Challenges

- **Monorepos:** Scan all packages/services, note boundaries between them
- **Generated code:** Identify and flag generated files (protobuf, OpenAPI, codegen) to avoid false positives
- **Test files:** Identify test directories to provide context for Phase 3 verification
- **Vendor/node_modules:** Skip vendored dependencies, they are covered by sc-dependency-audit
- **Large codebases:** Prioritize entry points and data flow paths over exhaustive file listing
