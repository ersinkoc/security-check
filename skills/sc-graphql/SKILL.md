---
name: sc-graphql
description: GraphQL injection, introspection abuse, query complexity attacks, and authorization bypass detection
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: GraphQL Security

## Purpose

Detects GraphQL-specific security vulnerabilities including query injection, introspection information disclosure, batching abuse, nested query denial-of-service, field-level authorization bypass, and subscription hijacking. Covers Apollo Server, graphql-yoga, Strawberry, Graphene, gqlgen, and HotChocolate.

## Activation

Called by sc-orchestrator during Phase 2 when GraphQL schema files, resolvers, or GraphQL dependencies are detected.

## Phase 1: Discovery

### File Patterns to Search
```
**/*.graphql, **/*.gql, **/schema.*, **/typeDefs.*, **/resolvers.*,
**/*resolver*, **/*schema*, **/*graphql*, **/mutations/*, **/queries/*,
**/subscriptions/*, **/directives/*
```

### Keyword Patterns to Search
```
"typeDefs", "resolvers", "ApolloServer", "graphql-yoga", "makeExecutableSchema",
"buildSchema", "@Query", "@Mutation", "@Resolver", "GraphQLObjectType",
"introspection", "depthLimit", "costAnalysis", "complexityLimit",
"__schema", "__type", "subscription", "directive"
```

### Security Checks

**1. Introspection Enabled in Production**
- Check if introspection is explicitly disabled in production config
- Search for: `introspection: true`, missing introspection config, `NODE_ENV` checks

**2. Query Depth/Complexity Limits Missing**
- Check for depth limiting middleware: `graphql-depth-limit`, `depthLimit`, `@complexity`
- Check for query cost analysis: `graphql-query-complexity`, `costAnalysis`
- Absence of both = vulnerable to nested query DoS

**3. Batching Without Limits**
- Check if query batching is enabled without limits
- Search for: `allowBatchedHttpRequests`, batch query handler, array query acceptance

**4. Field-Level Authorization**
- Check if resolver functions verify user permissions
- Search for missing auth checks in mutation resolvers
- Check directive-based auth: `@auth`, `@hasRole`, `@authenticated`

**5. SQL/NoSQL Injection in Resolvers**
- Trace GraphQL arguments through resolver to database queries
- Check if arguments are used in raw queries without parameterization

**6. Information Disclosure via Error Messages**
- Check if detailed error messages are returned to clients
- Search for: `formatError`, `debug: true`, stack trace exposure

**7. Subscription Authorization**
- Check WebSocket subscription handlers for auth validation
- Verify subscription filters don't leak data to unauthorized users

## Phase 2: Verification

### Nested Query DoS Example
```graphql
# Attack: Deeply nested query (no depth limit)
query {
  user(id: 1) {
    posts {
      author {
        posts {
          author {
            posts { # ...repeating to depth 50+
              title
            }
          }
        }
      }
    }
  }
}
```

```javascript
// VULNERABLE: No depth or complexity limits
const server = new ApolloServer({
  typeDefs,
  resolvers,
});

// SAFE: With depth and complexity limits
import depthLimit from 'graphql-depth-limit';
import { createComplexityLimitRule } from 'graphql-validation-complexity';

const server = new ApolloServer({
  typeDefs,
  resolvers,
  validationRules: [
    depthLimit(10),
    createComplexityLimitRule(1000),
  ],
  introspection: process.env.NODE_ENV !== 'production',
});
```

### Authorization Bypass Example
```javascript
// VULNERABLE: No auth check in resolver
const resolvers = {
  Mutation: {
    deleteUser: async (_, { id }, context) => {
      return await User.findByIdAndDelete(id); // Anyone can delete any user
    }
  }
};

// SAFE: Auth check in resolver
const resolvers = {
  Mutation: {
    deleteUser: async (_, { id }, context) => {
      if (!context.user || context.user.role !== 'admin') {
        throw new ForbiddenError('Not authorized');
      }
      return await User.findByIdAndDelete(id);
    }
  }
};
```

## Severity Classification

- **Critical:** SQL/NoSQL injection through GraphQL arguments, authentication bypass in mutations
- **High:** Missing field-level authorization on sensitive mutations, introspection enabled exposing internal schema in production
- **Medium:** Missing query depth/complexity limits (DoS risk), batching abuse, subscription data leaks
- **Low:** Verbose error messages, introspection enabled in staging, missing rate limiting on queries

## Output Format

### Finding: GQL-{NNN}
- **Title:** {GraphQL vulnerability type}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-89 (Injection) | CWE-200 (Information Disclosure) | CWE-862 (Missing Authorization) | CWE-770 (Resource Exhaustion)
- **Description:** {What was found}
- **Proof of Concept:** {Example query demonstrating the issue}
- **Impact:** {What happens if exploited}
- **Remediation:** {How to fix with code example}
- **References:** https://cheatsheetseries.owasp.org/cheatsheets/GraphQL_Cheat_Sheet.html

## Common False Positives

1. **Introspection in development** — introspection is expected in dev/staging environments
2. **Public queries without auth** — some queries are intentionally public (e.g., product listings)
3. **Depth limits in gateway** — depth limiting may be enforced at the API gateway level, not in the GraphQL server
4. **Schema-first codegen** — generated resolvers may appear to lack auth but are wrapped by middleware
5. **Federated schemas** — auth may be handled by the gateway in a federated GraphQL architecture
