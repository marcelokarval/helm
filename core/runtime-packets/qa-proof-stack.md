# QA And Proof Stack

## Purpose

Use this module when the work needs explicit QA lane ownership instead of a
generic "tests/review later" posture.

## Rule

Truth moves through five distinct layers:

1. implementation proof
2. backend/frontend QA proof
3. browser truth
4. persistent regression proof
5. forensic closure

Do not collapse these into a single vague `tested` claim.

## Lane Ownership

- `Backend Tester`
  - service tests
  - query-shape proof
  - migration/runtime proof (`bun run db:push`)
  - ownership/auth proof
- `Frontend Tester`
  - `bun run lint` (includes TypeScript checking)
  - component state proof
  - i18n proof
  - route/view-model proof
- `Browser-Proof Auditor`
  - interactive truth via `agent-browser`
  - breadth and route-family audit
  - runtime console and UX drift detection
  - when exploratory browser QA and issue capture are the main need, `dogfood`
    is a valid lane companion
- `E2E Regression Engineer`
  - persistent `agent-browser` scenarios (note: Z.ai does not have a dedicated
    persistent E2E tool like Playwright; use agent-browser as the closest
    substitute)
  - regression protection after the flow is understood

## agent-browser: Discovery vs Persistence

Do not invert these roles.

- `agent-browser (discovery mode)`
  - discovery truth
  - runtime truth
  - broad sweep
  - route-family validation
- `agent-browser (validation mode)`
  - persistent regression
  - repeatable scenario proof
  - CI-friendly safety net

> **Note:** In the original accelerate platform, `Chrome DevTools` handled
> discovery truth and `Playwright` handled persistent regression. In Z.ai,
> `agent-browser` serves both roles. The distinction is operational, not
> tool-based: use discovery mode first to understand the flow, then switch to
> validation mode to automate repeatable checks.

If the flow is not yet understood, start in discovery mode.

Only persist to validation mode after the interactive truth is stable enough to
be worth automating.

## Browser-Proof Intensity Labels

Every browser-proof packet should classify its breadth as one of:

- `sampled`
- `targeted`
- `broad sweep`
- `full route-family audit`

## Named Failure Modes

Name the proof failure explicitly when it appears.

- `browser truth -> persistence inversion`
  - persistent regression was authored or used for closure before interactive
    browser truth via `agent-browser` stabilized the flow.
- `lane-collapse closure`
  - distinct proof lanes were compressed into a vague sentence such as
    `tested successfully`.
- `packetless proof`
  - evidence exists, but the lane did not leave an explicit `QA / Proof Packet`.

These are closure-relevant failures, not optional cleanup notes.

## Closure Blocking Rule

Closure must expose proof-lane status, not just accumulated confidence.

Before closure, make visible at least:

- `Backend QA=<present|missing|blocked>`
- `Frontend QA=<present|missing|blocked>`
- `Browser-Proof=<present|missing|blocked>`
- `Persistent E2E=<present|missing|blocked|out of order>`
- `blocking lane=<lane or none>`

If `Browser-Proof` is missing while `Persistent E2E` is already present for a
runtime-sensitive user flow, treat that as `browser truth -> persistence
inversion` and keep closure blocked.

Do not accept closure language that hides lane state behind a single generic
claim.

## Calibration Note

Self-service or abuse-sensitive flows may require `anti-abuse-review`, but that
lane is calibration-driven. Do not promote it to mandatory proof by default
unless the branch risk actually justifies it.

## Visual Proof Diagram

```text
╔════════════════════════════════════════════════════════════════════════════════════╗
║                           QA / PROOF STACK                                         ║
╠══════════════════════╦══════════════════════╦══════════════════════╦═══════════════╣
║ Backend Tester       ║ Frontend Tester      ║ Browser-Proof        ║ E2E Regression║
║ [service/query/auth] ║ [TS/i18n/states]     ║ Auditor              ║ Engineer       ║
║                      ║                      ║ [agent-browser]      ║ [agent-browser]║
╠══════════════════════╬══════════════════════╬══════════════════════╬═══════════════╣
║ query proof          ║ bun run lint         ║ targeted             ║ smoke          ║
║ migration proof      ║ component proof      ║ broad sweep          ║ regression     ║
║ ownership proof      ║ locale proof         ║ route-family audit   ║ persistence    ║
╚══════════════════════╩══════════════════════╩══════════════════════╩═══════════════╝
```

## Required Outputs

Each lane should leave a packet with:

- scope covered
- intensity or depth
- evidence used
- failures found
- residual gaps

The browser-proof lane and persistent regression lane should never be merged
into one vague sentence.

## Z.ai Adaptation Notes

| accelerate (Claude/Codex) | helm (Z.ai) |
|---|---|
| `Chrome DevTools` | `agent-browser` (discovery mode) |
| `Playwright` | `agent-browser` (validation mode) |
| `manage.py check` | `bun run lint` |
| `makemigrations` | `bun run db:push` |
| `type-check (npm)` | `bun run lint` (includes TS) |
| `EXPLAIN` (PostgreSQL) | N/A (SQLite) |

The 5-layer proof structure is fully preserved. The distinction between
discovery truth and persistent regression is now operational (same tool,
different mode) rather than tool-based.
