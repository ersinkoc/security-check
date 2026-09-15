# Evidence and Coverage Model

security-check reports security boundary failures, not suspicious patterns alone. This document defines the shared evidence contract used by reconnaissance, hunters, verification, and reporting.

## Verdicts

Every candidate ends in exactly one state:

| Verdict | Meaning | Severity allowed? |
|---|---|---|
| `confirmed` | A complete source trace and safe, bounded evidence establish a meaningful boundary failure. | Yes |
| `needs_validation` | Source supports a concrete lead, but one decisive runtime, deployment, identity, or provider fact is unavailable. | No |
| `rejected` | A control, unreachable path, incorrect premise, or failed reproduction disproves the candidate. | No |

Missing defense in depth is a hardening note when another effective layer prevents the claimed attack. It is not promoted to a vulnerability.

## Candidate Contract

A candidate must identify:

1. the lower-trust actor and their starting capability;
2. the entry point and attacker-controlled value or state;
3. the ordered repository-relative source trace;
4. the security control encountered and why it is insufficient;
5. the sensitive sink, protected resource, or privileged action;
6. the affected principal or security invariant;
7. a meaningful observed or source-proven result;
8. conditions, limitations, and the smallest safe next validation step.

If any required element is unknown, keep the item as `needs_validation` or reject it. Confidence percentages do not substitute for missing evidence.

## Coverage Ledger

Full audits create `security-report/coverage-ledger.md` before hunting. Use one row for each material combination of entry surface, trust boundary, subsystem, and attack class.

```markdown
| Coverage ID | Surface | Boundary | Subsystem | Attack class | Starting paths | Status | Evidence | Gap |
|---|---|---|---|---|---|---|---|---|
| API-OWNER-001 | PATCH /users/:id | caller -> resource owner | api/users | authorization | src/routes/users.ts | planned | | |
```

Allowed states are `planned`, `in_progress`, `covered`, `candidate`, `blocked`, `deferred`, `not_applicable`, and `out_of_scope`.

- `covered` requires reviewed paths and at least one concrete source or bounded local check.
- `candidate` requires the same evidence plus one or more candidate IDs.
- `blocked`, `deferred`, and `out_of_scope` require an explicit gap or reason.
- A generic statement such as "authentication reviewed" is not coverage evidence.
- Keep prior-run units visible. Revalidate changed source; do not assume an old clean result still applies.
- Run a final coverage-critic pass that searches for unlisted entry surfaces, alternate paths, lifecycle paths, and category gaps.

A partial, scoped, time-limited, or interrupted run must say so. Zero confirmed findings never means the target is secure.

## Independent Validation

The final verifier must approach every candidate adversarially and try to disprove it. When the platform supports separate agents, the final verifier must not be the hunter that proposed the candidate. Otherwise, use a separate pass with fresh context and explicitly disclose that agent independence was unavailable.

The verifier checks:

- reachability from a realistic lower-trust entry point;
- the full transformation from source to sink;
- framework, middleware, deployment, and operating-system controls;
- authorization against the final principal, action, and resource;
- exploit preconditions and whether the actor already has equivalent authority;
- whether the result has confidentiality, integrity, availability, or operator-cost impact;
- duplicates by root cause rather than matching titles or lines.

## Safe Local Validation

Source inspection is read-only. Do not run target-controlled builds, tests, processes, browsers, emulators, parsers, or fuzzers unless the environment can enforce all of the following:

- no external network, with isolated loopback only when needed;
- an empty or explicit allowlisted environment with no ambient credentials;
- writes confined to a disposable scratch directory;
- no access to production data, shared services, control planes, or other users;
- bounded wall time, CPU, memory, process count, file size, and disk use;
- dummy principals, fixtures, resources, and secrets;
- termination after the minimum harmless effect proves or disproves the invariant.

Do not install dependencies, publish artifacts, send webhooks, consume paid quota, test live availability, or mutate shared infrastructure as part of validation. If required controls are unavailable, retain a source-grounded lead as `needs_validation` and give the owner a safe, precise check.

## Reporting Contract

The final report has separate sections for:

- confirmed findings, with severity based on demonstrated impact and conditions;
- needs-validation leads, without severity;
- rejected candidates, summarized only when useful to explain a decision;
- hardening notes and positive controls;
- covered, blocked, deferred, and out-of-scope ledger units;
- validation commands actually executed and their constraints.

Prose is derived from final verdicts. Reporting must not upgrade a lead, change a severity, or imply coverage that the ledger does not support.

## Acknowledgement

This evidence model was informed by Cloudflare's open-source
[`security-audit-skill`](https://github.com/cloudflare/security-audit-skill), especially its coverage-led hunting, distinct verdicts, independent verification, and sandboxed validation principles. The implementation here is adapted to security-check's multi-skill four-phase architecture.
