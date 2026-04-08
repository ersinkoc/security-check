
import pathlib

target = pathlib.Path(r"d:/Codebox/security-check/scan-target/.claude/skills/sc-lang-typescript.md")

# Build content in parts to avoid shell escaping issues
parts = []

parts.append("""---
name: sc-lang-typescript
description: TypeScript/JavaScript-specific security deep scan
---

# SC: TypeScript/JavaScript Security Deep Scan

## Purpose

Detects TypeScript/JavaScript-specific security anti-patterns and language-idiomatic attack vectors across both browser and Node.js environments. This skill covers frontend frameworks (React, Next.js, Angular, Vue), backend frameworks (Express, Fastify, Koa, Nest), ORMs (Prisma, Drizzle, TypeORM, Sequelize), and the broader npm ecosystem.

## Activation

Activates when TypeScript or JavaScript is detected in the project. Detection signals include:
- Files with , , , , ,  extensions
- , , , or  presence
- Node.js runtime markers (, , )

## Checklist Reference

References .
""")

print(f"Script created, {len(parts)} parts")
print("Use the full writer script instead")
