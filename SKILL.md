---
name: helm
description: >
  Engineering orchestration skill for production-quality code. MUST be activated before ANY
  implementation work (features, bugs, refactors, architecture). Classifies requests as trivial
  or non-trivial, selects the correct branch (product-critical, bug, full-stack, etc.), enforces
  mandatory skills per branch, delegates to appropriate subagents (full-stack-developer, Plan,
  Explore, frontend-styling-expert), runs the 5-layer proof stack (implementation → QA → browser
  → agent-browser → forensic closure), and blocks Done until all branch contracts are satisfied.
  Uses docs/TASKS.md for issue tracking and worklog.md for session handoff. Adapted from the
  accelerate methodology for the Z.ai platform.
metadata:
  category: orchestration
  origin: adapted-from-accelerate-for-zai
  version: 1.0.0
---
# Helm

Z.ai-native root orchestration skill for standalone engineering work.

Use `helm` as the entry control plane for any engineering run.

Its job is to decide how the work should run before implementation starts, then
stay responsible for the runtime shape until real closure.

This file is intentionally constitutional and compact.

- `skills/helm/AGENTS.md` sets the repo bootstrap laws
- `skills/helm/README.md` is the richer operating guide
- `core/` is the native method surface
- `references/` remains supporting inherited depth while rehoming continues

## Current Reality

This repository is in the `standalone pre-agents` phase.

That means:

- the root control plane must already work with zero subagent types selected
- issue topology, risk enforcement, proof ordering, and closure discipline are
  already native concerns
- planning docs and executive artifacts are the current workflow vehicle until
  a native workflow adapter exists

Subagent usage is optional. The platform is not waiting for delegation to become valid.

## Minimum Truth Stack

For a fresh engineering session, start with:

1. `skills/helm/AGENTS.md`
2. `skills/helm/SKILL.md`

When the run is non-trivial, architectural, or mutation-bearing, continue with:

3. `skills/helm/README.md`
4. `docs/architecture/pre-agents-baseline.md`
5. `docs/architecture/control-plane.md`

Then open the native surface that actually governs the branch, usually from:

- `core/control-plane/branch-enforcement-matrix.md`
- `core/control-plane/quick-invocation-map.md`
- `core/issue-topology/issue-driven-mutation-stack.md`
- `core/runtime-packets/qa-proof-stack.md`
- `core/workflows/operational-calibration.md`
- `core/review/product-critical-surfaces.md`
- `core/review/premium-interface-production.md`
- `core/risk/enforcement-surfaces.md`

## Root Laws

`helm` always owns:

- classification
- prompt-hardening decision
- issue topology
- lane opening order
- staffing / delegation budget
- risk enforcement
- proof ordering
- final AI review
- root closure mode
- `Done`

Bounded execution may implement or inspect a slice, but it does not inherit root
authority.

## Operating Model

Run `helm` in this order:

1. decide whether the task is actually engineering work
2. decide whether prompt hardening is mandatory
3. classify the run honestly
4. open the required branch, skills, gates, and artifacts
5. keep runtime state visible with explicit packets
6. enforce proof in the correct order
7. block closure until the branch contract is truly satisfied

Do not treat `helm` as a label. Treat it as the visible team operating
system for the run.

## Classification Contract

Every engineering run must be classified before execution continues.

The top-level outcomes are:

- conversational / no-op
- trivial bounded engineering work
- orchestrated non-trivial work

`prompt-hardening` is mandatory when the request is:

- long
- ambiguous
- multi-objective
- multi-phase
- architecture-heavy
- likely to drift without shaping

Do not skip hardening only because the task later turns out to be bounded.

## Branch Selection

Use the native branch matrix for exact routing.

The recurring branch families are:

- trivial bounded
- ambiguous / long / epic-like
- issue-driven delivery
- bug / failure / regression
- adversarial security / hostile-path review
- architecture / governance doubt
- runtime / product-heavy flow
- product-critical user surface
- premium interface
- untrusted ingress / upload / import / media ingestion
- persisted-modeling / contract-heavy review

When structural UI uncertainty exists, use wireframe / visual-contract
discipline before implementation.

## Runtime Visibility

Non-trivial runs should keep the active runtime state visible.

At minimum, runtime packets should expose:

- active branch
- active skills
- active references
- gate ledger
- phase / SDLC
- issue stack status
- QA / proof lane
- browser-proof status
- agent-browser validation status
- closure blockers
- `single-threaded exception` when non-trivial work stays root-only

Do not replace packeted runtime state with long opaque progress prose.

## Mutation Rule

If the run mutates:

- code
- docs
- workflow seeds
- runtime governance

then the issue stack is mandatory unless a narrow explicit no-issue exception
exists.

In the current pre-agents phase, that means:

- executive planning artifacts are the governing execution handoff
- do not invent a fake workflow adapter
- do not assume docs/TASKS.md or another backend is already the enforced runtime truth

## Proof Order

The proof order is:

1. implementation proof
2. backend/frontend QA proof
3. browser truth
4. agent-browser validation
5. forensic closure

Do not collapse these lanes into a vague "tested" claim.

Browser truth comes via agent-browser when the flow is not yet stabilized.

## Product-Critical And Premium Rule

Use `product-critical user surface` when backend truth and frontend product
quality are both closure-critical.

Escalate into `premium interface` when:

- perceived quality is part of the requested outcome
- an ascii-wireframe output is central
- technical correctness alone would still be unacceptable

These branches do not close on logic correctness alone.

## Agent Optionality

Subagent usage is optional.

`helm` must remain fully functional:

- with no subagent types selected
- when the user disables agent usage
- when delegation has no honest fit

If non-trivial work remains single-threaded, say so explicitly and give the
reason.

## Z.ai Constraints

The Z.ai platform has specific constraints that `helm` must respect:

### Available Subagent Types (via Task tool)

There are exactly 5 subagent types available for delegation:

1. **full-stack-developer** — equivalent to implementation worker + planner sidecar; best for bounded implementation, code changes, API routes, database schemas
2. **Plan** — equivalent to governance auditor + decomposition; best for architecture review, complex analysis, multi-step planning
3. **frontend-styling-expert** — equivalent to runtime/product reviewer; best for UI/UX refinement, CSS/Tailwind, visual QA
4. **Explore** — equivalent to verification sidecar; best for codebase exploration, search, analysis, evidence gathering
5. **general-purpose** — equivalent to research + multi-step exploration; best for cross-cutting tasks, research, documentation

### Available Skills (via Skill tool)

71 skills are available for skill invocation. Key skills include:

- `prompt-hardening` — specification gate (replaces Specification PM persona)
- `fullstack-dev` — full-stack development with Next.js/Prisma
- `ascii-wireframe` — wireframe and diagram generation
- `product-runtime-review` — product-critical surface review
- `forensic-review` — forensic evidence review
- `front-react-shadcn` — shadcn/ui component patterns
- `agent-browser` — headless browser automation
- `nextjs-best-practices` — Next.js engineering best practices
- `anti-abuse-review` — sensitive flow misuse resistance
- `acceptance-verification` — delivery acceptance and closure
- `test-driven-development` — TDD discipline
- `pdf`, `xlsx`, `docx`, `ppt` — document generation
- `web-search`, `web-reader` — web intelligence
- `LLM`, `VLM`, `TTS`, `ASR` — AI model capabilities
- `image-generation`, `video-generation`, `video-understand` — media AI
- `finance` — financial data and market analysis
- `claim-verification` — evidence-based claim checking
- `napkin-discipline` — execution discipline for messy requests
- `skill-creator`, `skill-vetter` — skill lifecycle management
- And 48 more specialized skills

### Cron Payload Kinds

There are 2 cron payload kinds that drive continuous work:

1. **agentTurn** — general-purpose agent turns; include explicit helm instructions in `payload.message`
2. **webDevReview** — web development review turns; include explicit helm instructions in `payload.message`

**CRITICAL:** The default system prompt for `webDevReview` includes dangerous autonomous instructions ("propose new requirements", "continue development autonomously"). These MUST be overridden with proper governance. See `adapters/runtime/cron-governance.md` for the mandatory rules and recommended `payload.message` templates.

The foundational rule: **a cron MUST NEVER create, propose, or invent requirements.** Work must come from `docs/TASKS.md` or explicit human instructions. When no tasks are pending, the cron MUST stop.

### No Orchestrator/AGENTS.md Concept

In the Z.ai platform, there is no separate orchestrator role. The master agent IS the orchestrator. There is no platform-level `AGENTS.md` file that the Z.ai runtime natively reads — the master agent reads `skills/helm/AGENTS.md` as a governed artifact, not as a platform-level agent configuration.

This means `helm` must be explicit in its instructions rather than relying on a platform-level always-on mechanism.

## Enforcement (3 Layers)

Unlike Claude's always-on root skill model, Z.ai enforcement is soft and layered:

### Layer 1: Skill Description (Passive Inference)

The `description` field in this SKILL.md's frontmatter is injected into the
`<available_skills>` list that the agent sees at the start of every session.

If the description is strong enough, the agent will INFER that `helm` is relevant
when the request involves engineering, implementation, code, features, or bugs.

**When it works:** The user's request naturally mentions engineering work.

**Limitation:** The agent may ignore if the description is vague or the request
doesn't clearly match.

### Layer 2: `payload.message` (Active for Crons)

When creating crons (`agentTurn` or `webDevReview`), include explicit instructions
in the `payload.message`. **Always follow the governance rules in
`adapters/runtime/cron-governance.md`** — crons must never invent tasks or
propose features.

```
"Read skills/helm/SKILL.md and follow ALL instructions before any work.
Read docs/TASKS.md and execute only the next pending task.
If no tasks are pending, STOP — do not invent work."
```

**When it works:** Crons are the primary mechanism for continuous automated work.

**Limitation:** Only applies to cron-triggered sessions.

### Layer 3: `worklog.md` Reference (Between Sessions)

Mention `helm` in the project's `worklog.md` as a permanent instruction:

```
"Projects in this repo must use helm. See skills/helm/"
```

**When it works:** The agent reads `worklog.md` at the start of each session for
context continuity.

**Limitation:** Depends on the agent checking the worklog first.

### What This Means

- Enforcement in Z.ai is SOFT, not hard — there is no technical gate that
  forces helm to be loaded
- The agent CAN ignore all three layers — mitigation is through strong
  descriptions, explicit payload messages, and persistent worklog references
- The human operator is the final enforcement authority
- There is no equivalent to Claude's "always-on root skill" — this is by
  design of the Z.ai platform

## Reference Map

Use these native authorities first:

- branch routing:
  - `core/control-plane/branch-enforcement-matrix.md`
  - `core/control-plane/quick-invocation-map.md`
- mutation / issue discipline:
  - `core/issue-topology/issue-driven-mutation-stack.md`
- proof and closure:
  - `core/runtime-packets/qa-proof-stack.md`
  - `core/workflows/operational-calibration.md`
- risk and enforcement:
  - `core/risk/enforcement-surfaces.md`
- critical visual/runtime review:
  - `core/review/product-critical-surfaces.md`
  - `core/review/premium-interface-production.md`
- delegation:
  - `core/delegation/subagent-model.md`

Open `references/` only when native authority is still thin or when comparison
against inherited doctrine is the point of the run.

## Bundled Skills

helm ships with 8 companion skills that extend the orchestration surface.
These are installed alongside helm in `skills/<name>/`:

| Skill | Category | Role |
|-------|----------|------|
| `brainstorming` | design-planning | MANDATORY before any creative work. Socratic design refinement producing design docs. |
| `writing-plans` | implementation-planning | Creates bite-sized implementation plans (2-5 min tasks) with exact code and verification. |
| `subagent-driven-dev` | delegation | Task dispatch with two-stage review (spec compliance + code quality). |
| `dispatching-parallel-agents` | orchestration | For 2+ independent tasks — one agent per problem domain, all concurrent. |
| `test-driven-development` | quality | Iron Law: NO production code without a failing test first. RED-GREEN-REFACTOR. |
| `systematic-debugging` | debugging | 4-phase root cause analysis (evidence → pattern → hypothesis → fix). |
| `verification-before-completion` | closure | Gate function: NO completion claims without fresh verification evidence. |
| `napkin` | knowledge-management | Cross-session persistent memory — curated runbook of lessons learned. |

### Pipeline Integration

The bundled skills form a complete development pipeline:

```
brainstorming → writing-plans → [implementation with TDD] → verification-before-completion
                                  ↓ (if bugs)
                            systematic-debugging
                                  ↓ (if complex)
                    subagent-driven-dev + dispatching-parallel-agents
                                  ↓ (across sessions)
                                  napkin
```

- **Design phase**: `brainstorming` → produces design docs → consumed by `writing-plans`
- **Planning phase**: `writing-plans` → produces task plans → executed by `subagent-driven-dev`
- **Implementation**: `test-driven-development` governs code writing
- **Quality**: `verification-before-completion` is the final gate before any "Done" claim
- **Debugging**: `systematic-debugging` activates when bugs are encountered
- **Delegation**: `subagent-driven-dev` + `dispatching-parallel-agents` handle multi-agent work
- **Memory**: `napkin` accumulates lessons across sessions for continuous improvement

All bundled skills reference `helm` as the orchestrator and are designed to be
invoked by helm's classification and branch routing, not used in isolation.
