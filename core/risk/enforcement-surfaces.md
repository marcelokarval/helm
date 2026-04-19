# Enforcement Surfaces

## Purpose

This document is the native enforcement inventory for backend, frontend,
runtime, and governance work.

Use it when the question is:

- what is mandatory on this branch?
- what smells should be treated as workflow failure?
- what backend/frontend/runtime/governance obligations are live?

## Security And Integrity

- `IDOR / public_id` review on ownership-sensitive flows
- `public_id prefix discipline` on new backend models and identifiers
- `N+1 / query-shape proof` on backend-heavy or relational surfaces
- `anti-abuse` on auth, resend, export, upload, recovery, billing, and
  enumeration-sensitive flows
- `OWASP` review on relevant trust-boundary and user-input surfaces
- `race-condition audit` for critical Prisma write operations, mutable shared
  state, counters, balances, and concurrency-sensitive flows
- `secrets / config hygiene` for provider, env, and credential-bound surfaces
- `session auth posture` for browser-authenticated flows
- `CSRF / XSRF correctness` for web mutation surfaces
- `lockout / rate-limit / replay posture` where credentials, resend, or
  verification loops exist

## Backend Enforcement

- backend is source of truth
- service layer first
- use project base classes and inheritance stack
- prefer project mixins or model base classes over repetition
- after the second repetition, suggest mixin/heredity extraction explicitly
- review meaningful Prisma write operations for race or side-effect risk
- `soft delete discipline`
- `no direct cross-domain imports`
- `transaction boundary clarity` (Prisma `$transaction`)
- tasks should call services, not own business logic
- use canonical helpers and base abstractions
- `err()` structured backend error protocol
- `no backend-owned localized copy in props`
- `query count evidence` (Prisma query logging)
- N/A (SQLite) when execution-plan claims matter
- `cache truth / invalidation truth`
- `download / upload audit trail`
- `presigned / private / public storage boundary`
- distinguish readonly/admin/operator surfaces explicitly
- frontend validation may exist for UX/protection, but backend validation is
  authoritative
- no narrative closure without backend validation stack when schema/runtime work
  happened
  - `bun run lint`
  - `bun run db:push`

## Frontend Enforcement

- Next.js App Router patterns by default
- DRY and shared/component reuse discipline
- use project compounds and enhanced components before inventing new ones
- mandatory source ladder for missing components:
  1. canonical primitives
  2. acceptable third-party source when justified
  3. only then custom construction from base components
- avoid `div soup`
- enforce modularization and import-boundary discipline
- mandatory i18n for user-facing text
- browser/runtime-sensitive structural work should use wireframes when needed
- `Wireframe Before UI` for structural UI uncertainty
- `real data readiness`
- `route-family / shell persistence` awareness
- frontend validation should also reduce invalid or hostile traffic reaching the
  backend when the branch calls for it

## Runtime And Proof Enforcement

- browser-proof intensity must be named
- `agent-browser` for interactive runtime truth
- N/A (use agent-browser) for persistent regression proof
- browser-proof comes before persistent automation when the flow is not yet
  understood
- every bounded batch requires self-review
- every bounded batch requires self-forensic review
- every subagent requires self-review and self-forensic review output
- frontend-bearing or TS contract-bearing slices require `bun run lint`
  (includes TypeScript checking)

## Multi-Agent Enforcement

- non-trivial work should evaluate bounded subagent spawning explicitly
- non-trivial work may stay root-owned when delegation has no honest fit or
  adds more integration cost than execution clarity; staying fully
  single-threaded still requires an explicit exception packet
- each subagent loads helm (via SKILL.md) first before layer-specific work
- each subagent stays bounded and leaves explicit output
- the master performs review-of-review and final integration closure

## Governance Enforcement

- issue stack is mandatory for mutating work (docs/TASKS.md)
- `worklog.md Stage Summary` before `Done`
- repo docs and workflow seeds are not exempt from governance
- stack-specific governance skills should be loaded when branch risk demands
- `Contract Correctness` when presenters, props, routes, identifiers, or action
  URLs are touched
- `shared props governance` when shell/page truth boundaries may drift
- `query ownership -> presenter ownership -> UI ownership` should stay explicit
  whenever data truth crosses backend and frontend boundaries

## Z.ai Adaptation Notes

Key substitutions applied from the original accelerate version:

| accelerate (Claude/Codex) | helm (Z.ai) |
|---|---|
| `Django query` / `save()` calls | `Prisma query` / Prisma write operations |
| `request.POST` in Inertia flows | Next.js App Router patterns |
| `named URLs` redirects | Next.js routing (removed) |
| `no duplicate Stripe truth outside dj-stripe` | removed (Z.ai-specific) |
| `manage.py check` | `bun run lint` |
| `makemigrations --check` | `bun run db:push` |
| `EXPLAIN` (PostgreSQL) | N/A (SQLite) |
| `type-check (npm)` | `bun run lint` (includes TS) |
| `Chrome DevTools` | `agent-browser` |
| `Playwright` | N/A (use agent-browser) |
| `Linear signal` | `docs/TASKS.md signal` |
| `AI Review Report` | `worklog.md Stage Summary` |
| `accelerate` | `helm` |
