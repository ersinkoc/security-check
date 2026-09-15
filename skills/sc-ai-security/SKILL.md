---
name: sc-ai-security
description: AI, LLM, agent, RAG, MCP, memory, and tool-calling security assessment
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: AI and Agent Security

## Purpose

Find trust-boundary failures in applications that assemble model context, retrieve untrusted content, persist memory, call tools, delegate to agents, expose MCP capabilities, or render model output. Prompt injection by itself is not a finding: prove an unauthorized action, cross-principal disclosure, integrity loss, or meaningful operator-cost impact.

## Activation

Run when reconnaissance finds an LLM SDK, prompt templates, RAG or embeddings, vector stores, tool/function calling, MCP clients or servers, autonomous agents, persistent conversation memory, model-generated code execution, or model output reaching an active sink.

## Phase 1: Discovery

### Context and instruction sources

Search for system/developer prompts, user content, retrieved documents, web results, file contents, tool results, memory summaries, examples, and model-generated context. Record precedence, delimiters, truncation, filtering, and which principal can write each source.

### Capability map

Inventory every model-visible tool, resource, prompt, subagent, shell, browser, filesystem, database, messaging, deployment, and external-service capability. For each capability record:

- execution identity and credential;
- deterministic allowlist or policy gate;
- argument schema and post-parse validation;
- confirmation or approval binding;
- tenant, user, workspace, and resource scope;
- retry, resume, queued, batch, and delegated variants.

### Memory and retrieval map

Trace who can write each conversation store, vector collection, cache, knowledge base, profile, preference, or durable memory record and which later principal reads it. Include ingestion pipelines, document updates, deletion, re-indexing, namespace selection, metadata filters, and fallback search paths.

### Output destinations

Find model output sent to HTML/Markdown renderers, URLs, commands, code evaluators, templates, SQL, logs, emails, issue trackers, MCP messages, or other models. Determine whether the destination interprets active content and which encoder or policy applies at the final sink.

## Phase 2: Vulnerability Hunting

### Instruction and data confusion

- Untrusted content is treated as policy, authorization, identity, or a capability grant.
- Retrieved text can override the user's explicit intent or hidden system policy.
- Control and data channels are concatenated without a deterministic action boundary.
- Summarization or truncation removes restrictions while retaining attacker instructions.
- One tenant can influence another tenant's prompt, cache, few-shot examples, or retrieval results.

### Tool and action binding

- The application executes a tool action not contained in the user's normalized request.
- Confirmation names one operation but the handler uses changed arguments, a different resource, or later model output.
- A generic tool dispatcher trusts tool names, URLs, paths, principals, or commands selected by the model without policy validation.
- Retried, resumed, queued, or delegated work bypasses the final authorization or approval gate.
- A tool result or model message can spoof the identity of another tool, server, agent, or pending request.

### RAG and persistent memory

- Attacker-controlled content is indexed into a namespace read by a more privileged principal.
- Metadata filters are optional, caller-controlled, fail-open, or applied after retrieval.
- Deleted, revoked, or reclassified content survives in embeddings, summaries, caches, or derived artifacts.
- Citations point to one item while the generated answer uses another tenant's or private content.
- Memory writes can change security policy, account identity, approval state, or future tool arguments.

### MCP and multi-agent trust

- Tool descriptions, prompt metadata, schemas, or completion hints grant authority rather than describe it.
- Multiple servers can claim the same tool or resource identity without authenticated namespacing.
- Request/response correlation can cross connections, tenants, sessions, or reconnects.
- A subagent receives broader credentials, filesystem scope, or tools than its assigned task requires.
- Parent agents accept security claims or artifacts without source evidence and ownership checks.

### Output handling and disclosure

- Model output reaches an executing renderer without sink-appropriate encoding or sanitization.
- Output can create auto-loaded network requests, command links, scriptable Markdown, or unsafe templates.
- Context contains credentials, private source, policy secrets, or cross-user data that output can expose.
- Logs, traces, evaluations, or feedback datasets retain sensitive prompts or tool results beyond intended scope.

### Cost and availability

- Untrusted work can trigger unbounded recursive agents, tool loops, retrieval fan-out, large context growth, or paid API usage.
- Cancellation, timeouts, token budgets, rate limits, and per-principal quotas do not propagate to delegated work.
- Retry or resume repeats side effects or bills the operator multiple times without idempotency.

## Phase 3: Verification

For every candidate, identify the attacker, affected principal, execution identity, selected capability, final normalized arguments, and unauthorized result. Then verify:

1. The attacker can influence the context, memory, metadata, tool result, or output being traced.
2. Deterministic application code—not model speculation—permits the data to reach the privileged decision or sink.
3. Authorization and confirmation are checked after arguments become final and before the side effect.
4. The attacker cannot already perform the same operation through intended product behavior.
5. Provider-side or deployment-only behavior is marked `needs_validation` unless locally established.
6. A bounded dummy fixture demonstrates only the minimum harmless effect when safe execution controls are available.

Reject generic claims that any prompt injection automatically yields compromise. Reject findings based only on a tool being powerful when deterministic policy and final resource authorization contain it.

## Severity Classification

- **Critical:** Unauthenticated or low-trust content reliably causes arbitrary privileged execution, cross-tenant secret extraction, or destructive control-plane action.
- **High:** A realistic attacker causes a significant unauthorized tool action, durable cross-principal memory poisoning, or sensitive data disclosure.
- **Medium:** Exploitation crosses a boundary with limited scope, requires authenticated placement, or causes bounded operator cost or workflow integrity loss.
- **Low:** Demonstrated low-impact disclosure or action with narrow conditions. Pure defense-in-depth gaps are hardening notes.

## Output Format

Write `security-report/findings/sc-ai-security.json` using the orchestrator's candidate contract. Include `attacker`, `affected_principal`, `execution_identity`, `source_trace`, `control_analysis`, `sink`, `observed_result`, `conditions`, and `verdict`. Use no severity for `needs_validation` or `rejected` records.

## Common False Positives

- A user makes the model produce unwanted text visible only to that same user.
- A prompt contains secrets in an isolated local demo with no lower-trust reader.
- Tool descriptions are untrusted but a deterministic allowlist and handler authorization remain authoritative.
- Retrieved content affects prose but cannot invoke actions or disclose protected data.
- A model hallucinates a tool call that the dispatcher rejects.
- A broad internal capability is reachable only by an equally privileged administrator.

## Coverage Completion

Mark this skill covered only after reviewing context writers/readers, every side-effecting tool path, memory lifecycle, MCP or agent identity, output sinks, and resource budgets. Record unavailable provider, deployment, or runtime facts as explicit coverage gaps.

## Minimum Review Checklist

- [ ] List every system, developer, user, retrieval, memory, and tool-result context source.
- [ ] Identify which principals can write each source.
- [ ] Verify tenant and workspace scoping before retrieval.
- [ ] Review ingestion, update, deletion, re-index, and cache invalidation paths.
- [ ] List every side-effecting tool and its execution identity.
- [ ] Verify deterministic tool allowlists independent of model text.
- [ ] Verify schemas constrain shape and handlers constrain authority.
- [ ] Bind authorization to the final user, action, and resource.
- [ ] Bind confirmation to normalized final arguments.
- [ ] Compare direct, queued, retry, resume, batch, and delegated tool paths.
- [ ] Verify cancellation and budgets propagate to child work.
- [ ] Namespace MCP tools and resources by authenticated server identity.
- [ ] Bind responses to connection, request, session, and tenant.
- [ ] Prevent metadata and descriptions from granting capability.
- [ ] Trace persistent memory writers to every later reader.
- [ ] Review summary and truncation behavior for lost restrictions.
- [ ] Trace model output to every active renderer or interpreter.
- [ ] Apply sink-specific encoding, sanitization, and navigation policy.
- [ ] Exclude ambient secrets and unrelated private data from context.
- [ ] Review logs, traces, evaluations, and feedback retention.
- [ ] Enforce per-principal token, tool, recursion, and spend limits.
- [ ] Confirm a meaningful boundary result for each reported finding.
- [ ] Separate provider-dependent leads as `needs_validation`.
- [ ] Record clean evidence and unresolved gaps in the coverage ledger.
