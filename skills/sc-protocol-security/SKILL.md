---
name: sc-protocol-security
description: RPC, messaging, webhook, broker, streaming, and protocol trust-boundary security
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Protocol, RPC, and Messaging Security

## Purpose

Assess security across gRPC, Protobuf, GraphQL transports, custom protocols, queues, brokers, pub/sub, webhooks, event buses, and streaming RPC. Schema-valid messages are not automatically authentic, authorized, current, ordered, or safe.

## Activation

Run when reconnaissance finds `.proto` or schema files, RPC registration, message consumers, publishers, webhook handlers, queues, topics, subscriptions, event envelopes, correlation IDs, acknowledgements, retry/dead-letter logic, or custom framing and decoding.

## Phase 1: Discovery

### Message lifecycle inventory

Draw producer -> transport or broker -> gateway -> consumer -> storage for every material message family. Record:

- producer and authenticated channel identity;
- envelope, headers, routing metadata, and payload schema;
- authoritative tenant, user, resource, and operation fields;
- parser versions and generated/custom decoders;
- interceptor, middleware, consumer, and per-resource authorization;
- acknowledgement, commit, retry, ordering, deduplication, and dead-letter behavior;
- callback, reply, cancellation, and correlation lifecycle.

### Registration and alternate paths

Compare unary and streaming RPCs, direct and gateway-transcoded routes, reflection and health services, normal and compatibility services, synchronous and queued operations, retries and replays, dead-letter consumers, administrative reprocessing, and migration paths.

### Deployment facts

Identify broker ACLs, service identities, mesh policies, topic attachments, webhook ingress controls, signature secrets, and runtime routing that are visible in source. Keep decisive external facts as validation blockers rather than assuming secure or insecure deployment.

## Phase 2: Vulnerability Hunting

### Parsing and interpretation

- Components disagree on duplicate fields, unknown fields, numeric width, normalization, compression, framing, or envelope/body precedence.
- Missing discriminators, unknown enum values, zero values, or compatibility defaults select privileged behavior.
- Multiple schema versions decode one wire representation into security-relevant different values.
- A parser accepts trailing, truncated, ambiguous, or recursively nested data that downstream code interprets differently.

### Identity and authorization

- An authenticated workload or broker connection can claim an arbitrary user, tenant, sender, or resource in message fields.
- Interceptors protect unary calls but omit streams, gateways, compatibility methods, reflection, or per-message checks.
- A batch, stream, or subscription is authorized once while later items select new resources or survive revocation.
- Envelope routing is trusted for authorization while the consumer acts on conflicting payload identity.

### Broker isolation

- Publishers or subscribers can select another tenant's topic, wildcard, consumer group, partition, reply queue, or dead-letter route.
- Application namespace construction permits separators, normalization ambiguity, wildcards, or collisions.
- Untrusted producers can label messages as administrative, provider, migration, replication, or control-plane events.
- Dead-letter queues, diagnostics, traces, or operator dashboards disclose secrets or cross-tenant payloads.

### Replay, ordering, and transactions

- Duplicate delivery repeats a non-idempotent security-sensitive side effect.
- Deduplication occurs after mutation or uses a key that collides across tenants, operations, or time windows.
- Old state, revoked authority, canceled work, or pre-step-up identity overwrites newer state.
- Acknowledgement before durable commit loses security work; commit before unreliable acknowledgement duplicates it.
- Multiple consumers implement one invariant without atomicity or safe compensation.

### Webhooks and callbacks

- Signatures omit method, path, account, timestamp, body encoding, or key identity required to bind the event.
- Replay windows, timestamp parsing, key rotation, or duplicate headers permit reuse or verification disagreement.
- Callback or correlation identifiers can satisfy another tenant's or caller's pending operation.
- Redirects, content decoding, proxies, or body reserialization cause signer/verifier disagreement.

### Availability

- Untrusted messages cause decompression bombs, parser recursion, fan-out, unbounded subscriptions, queue growth, redelivery storms, or expensive downstream calls.
- Per-message limits exist but cumulative stream, tenant, retry, and dead-letter budgets do not.
- Poison messages block partitions or repeatedly crash consumers without quarantine.

## Phase 3: Verification

1. Name the realistic producer or peer, authenticated channel identity, accepted message, affected principal/resource, and resulting unauthorized mutation, disclosure, or bounded availability impact.
2. Trace the exact message representation through every in-repo parser, gateway, converter, and consumer.
3. Verify interceptor, broker ACL, signature, routing, and consumer authorization layers visible in source.
4. For parser disagreement, establish both interpretations and the security-relevant divergent value.
5. For replay/order claims, establish actual delivery semantics and reproduce the invariant failure only with a bounded local or in-memory fixture.
6. Mark external broker, service-mesh, provider, or deployment facts as `needs_validation` when decisive.

## Severity Classification

- **Critical:** Untrusted messages cause unauthenticated privileged control-plane execution, broad cross-tenant compromise, or arbitrary code execution.
- **High:** Cross-tenant publish/consume, significant unauthorized mutation, replayed financial/security action, or sensitive dead-letter disclosure.
- **Medium:** Limited-scope authorization, ordering, idempotency, or webhook-binding failure with realistic impact.
- **Low:** Narrow demonstrated impact under unusual conditions. Missing redundant controls are hardening notes.

## Language and Framework Notes

- **gRPC/Protobuf:** inspect interceptors for unary and stream variants, unknown fields, oneof/default behavior, reflection, gateway mappings, and per-message authorization.
- **Kafka/Pulsar/NATS/RabbitMQ:** inspect topic or subject construction, wildcard ACLs, consumer groups, retries, DLQs, offset commits, and tenant-scoped idempotency.
- **SQS/SNS/EventBridge/Pub/Sub:** inspect resource policies, event-source binding, redrive, duplicate delivery, account/region binding, and message attribute trust.
- **Webhooks:** inspect raw-body preservation, constant-time MAC checks, timestamp/replay binding, duplicate signature headers, account/audience binding, and rotation.
- **GraphQL subscriptions:** inspect connection authentication, field/resolver authorization, subscription scope, revocation, and per-event filtering.

## Output Format

Write `security-report/findings/sc-protocol-security.json` using the shared candidate contract. Include the complete message lifecycle, authenticated identities, authoritative fields, delivery guarantees, source trace, control analysis, observed result, and conditions.

## Common False Positives

- At-least-once delivery reaches an operation that is naturally or transactionally idempotent.
- Caller-declared tenant data is verified against an authenticated channel before use.
- Reflection or health endpoints expose no sensitive data or privileged action.
- A suspected broker ACL gap is conclusively prevented by source-controlled deployment policy.
- Duplicate fields are rejected consistently by every reachable parser.
- Dead-letter content is accessible only to the same or more privileged operator boundary.

## Coverage Completion

Do not mark coverage complete until normal, streaming, retry, dead-letter, replay, compatibility, gateway, and administrative paths are accounted for or explicitly not applicable.

## Minimum Review Checklist

- [ ] Inventory every producer, transport, gateway, consumer, and store.
- [ ] Record authenticated peer identity at every hop.
- [ ] Identify authoritative tenant, user, resource, and operation fields.
- [ ] Compare envelope, header, route, and payload identity.
- [ ] Review all reachable schema versions and converters.
- [ ] Test duplicate, missing, unknown, boundary, and default fields safely.
- [ ] Compare unary, streaming, reflection, health, and gateway paths.
- [ ] Verify per-item authorization for batch and streaming calls.
- [ ] Verify subscriptions stop or rescope after revocation.
- [ ] Review topic, subject, routing-key, and consumer-group construction.
- [ ] Confirm broker ACL assumptions from source or mark them unresolved.
- [ ] Authenticate administrative, provider, and migration events.
- [ ] Review signatures over raw bytes and all security-relevant context.
- [ ] Enforce timestamps, replay windows, audiences, and account binding.
- [ ] Bind callbacks and replies to peer, tenant, request, and operation.
- [ ] Document ordering and delivery guarantees.
- [ ] Review idempotency before and after side effects.
- [ ] Review acknowledgement and durable commit ordering.
- [ ] Review retry, poison-message, and dead-letter behavior.
- [ ] Inspect diagnostics and traces for sensitive payloads.
- [ ] Enforce per-message and cumulative stream limits.
- [ ] Bound decompression, recursion, fan-out, queues, and redelivery.
- [ ] Confirm one meaningful boundary result per reported finding.
- [ ] Record alternate and unavailable paths in the coverage ledger.
