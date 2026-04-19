# Helm Control Plane

## Purpose

This document is the canonical architecture source for the `helm` control
plane (adapted from `accelerate` for the Z.ai platform).

It exists to stop the full operating model from living only in:

- operator memory
- the root skill body
- adjacent workflow docs

`helm` is the runtime root control plane for engineering work on the Z.ai
platform. It classifies the run, chooses the dominant branch, loads the
minimum correct skill chain, and blocks closure until review and forensic
revalidation are complete.

For non-trivial issue-driven work, this control plane also blocks execution
until a post-issue planning artifact exists. Issue bootstrap alone is not
enough to authorize implementation.

This document does not replace:

- the installed root skill
- adjacent specialized Z.ai skills
- repo review policy
- current workflow-adapter execution policy

It explains how those pieces fit together as one operating system.

## Canonical Layering

Read the system in this order:

1. repo policy in `skills/helm/AGENTS.md`
2. this control-plane architecture doc
3. the installed `helm` root skill (via Skill tool)
4. adjacent workflow docs and specialized skills

The native branch, proof, delegation, workflow, and calibration surfaces now
live under `core/` and should be treated as primary authority before inherited
`references/` modules for these concerns.

## What Helm Is

`helm` is:

- the entry classifier for engineering work
- the branch router for non-trivial execution
- the orchestrator of the minimum valid skill stack
- the owner of phase discipline
- the governor of subagent use (via Task tool)
- the enforcer of final forensic closure

`helm` is not:

- an implementation skill
- a replacement for adjacent domain or stack Z.ai skills
- an autonomous swarm runtime
- proof that a workflow happened just because the skill was named

## Explicit Aliases

The control plane recognizes these as aliases over the existing model, not as
competing frameworks:

- `SDD` = `Spec Driven Development`
  - maps to the existing `Spec -> Design -> Plan -> Implement -> Verify -> Release or Follow-up` overlay
- `RPI` = `Research -> Plan -> Implement`
  - maps to the operational path where research happens in `Frame` and `Load`,
    execution shape is fixed in `Plan`, and code lands in `Execute`
- `PO`
  - maps to existing personas rather than a separate role class
  - `prompt-hardening` skill owns actor/goal/value/spec clarity
  - `Plan` subagent owns scope split, task shape, and parent/child decomposition

## Invocation Model

There are two valid invocation shapes.

### Active Invocation

```text
User explicitly names helm
  -> helm must be loaded (via Skill tool)
  -> helm becomes the visible root
```

### Passive Invocation

```text
Work is engineering
  -> repo policy still requires helm classification
  -> helm remains the runtime root even if the user did not name it
```

This means:

- trivial work may downshift quickly under the same root
- non-trivial work should still expose a visible `helm` manifest
- recurring repo-specific guidance from `napkin-discipline` should remain
  above the chain rather than being treated as an optional late-load

## Validation Gate Matrix

Validation in `helm` is slice-aware, not memory-based.

For backend schema/runtime-sensitive work, the minimum stack is defined at the
capability level first:

1. backend runtime/config checks
2. model/migration drift checks

These prove different things:

- `bun run lint`
  - TypeScript + ESLint checks
- `bun run db:push`
  - Prisma schema drift detection and sync

For frontend-bearing or TypeScript contract-bearing work, the minimum frontend
gate is `bun run lint` (includes type checking).

For full-stack work, both gate sets apply.

Treat closure without the applicable gate set as workflow failure, not as
acceptable operator discretion.

## Root-Owned Closure Mode

The current control plane now treats closure as a root-owned mode instead of
relying on vague "review later" language or a delegable closure lane.

Use these Z.ai skills distinctly:

- `product-runtime-review`
  - judgment of runtime-facing product correctness
- `forensic-review`
  - final closure-verdict gate when the question is whether the work can
    honestly be called done
- `anti-abuse-review`
  - review of abuse-sensitive flows
- `acceptance-verification`
  - acceptance and closure verification for delivered work

Do not collapse these into a single generic "tested/reviewed" claim.
These are review and verification surfaces, not substitutes for root closure
authority.

## Native Operating Surfaces

For concrete control-plane execution, start with these native modules:

- `core/control-plane/branch-enforcement-matrix.md`
- `core/control-plane/quick-invocation-map.md`
- `core/issue-topology/issue-driven-mutation-stack.md`
- `core/runtime-packets/qa-proof-stack.md`
- `core/delegation/subagent-model.md`
- `core/workflows/catalog.md`
- `core/workflows/operational-calibration.md`
- `core/control-plane/workflow-change-approval-gate.md`
- `core/review/product-critical-surfaces.md`
- `core/review/premium-interface-production.md`

## Classification Contract

Every engineering run should be classified explicitly.

```text
if small + bounded + low-risk + no real orchestration need
  -> trivial
else
  -> non-trivial
```

### Trivial

Use the bounded direct path when:

- the slice is narrow
- the implementation is local
- review needs are light
- orchestration overhead would be waste

### Non-Trivial

Use the full root orchestration path when:

- multiple surfaces or layers are involved
- planning or issue structure matters
- stack-sensitive review lenses apply
- product/runtime proof is needed
- abuse, contract, or governance drift is plausible

Trivial and non-trivial are both branches beneath the same runtime root.

## Control Plane Flow

```text
┌──────────────────────────────────────────────────────────────┐
│ Request arrives                                             │
└──────────────────────────────────────────────────────────────┘
                              |
                              v
┌──────────────────────────────────────────────────────────────┐
│ 1. Classification                                            │
│ trivial vs non-trivial                                       │
└──────────────────────────────────────────────────────────────┘
                              |
                              v
┌──────────────────────────────────────────────────────────────┐
│ 1.5 Napkin re-anchor                                          │
│ recurring repo guidance (napkin-discipline) above chain      │
└──────────────────────────────────────────────────────────────┘
                              |
                              v
┌──────────────────────────────────────────────────────────────┐
│ 2. Prompt hardening gate                                     │
│ required when the request is ambiguous, long, epic-like,     │
│ architectural, or otherwise not execution-ready              │
└──────────────────────────────────────────────────────────────┘
                              |
                              v
┌──────────────────────────────────────────────────────────────┐
│ 3. Branch Entry Packet                                       │
│ classification + branch + stack + gates + artifacts          │
└──────────────────────────────────────────────────────────────┘
                              |
                              v
┌──────────────────────────────────────────────────────────────┐
│ 4. Branch routing                                            │
│ choose dominant workflow and minimum skill stack             │
└──────────────────────────────────────────────────────────────┘
                              |
                              v
┌──────────────────────────────────────────────────────────────┐
│ 5. Post-issue planning gate                                  │
│ required for non-trivial issue-driven work                   │
└──────────────────────────────────────────────────────────────┘
                              |
                              v
┌──────────────────────────────────────────────────────────────┐
│ 6. Bounded execution                                         │
│ batches + micro-review + follow-ups for residuals            │
└──────────────────────────────────────────────────────────────┘
                              |
                              v
┌──────────────────────────────────────────────────────────────┐
│ 7. Verification and forensic review                          │
│ quality lenses + recursive scan + review-of-review           │
└──────────────────────────────────────────────────────────────┘
                              |
                              v
┌──────────────────────────────────────────────────────────────┐
│ 8. worklog.md Stage Summary / update docs/TASKS.md status    │
└──────────────────────────────────────────────────────────────┘
```

## Phase Model

Operationally, the root behaves in these phases:

1. `Frame`
2. `Load`
3. `Classify`
4. `Plan`
5. `Execute`
6. `Gate`
7. `Final Forensic Review`
8. `Deliver`

## Post-Issue Planning Gate

This gate applies when all of these are true:

- the run is non-trivial
- the run is issue-driven (tracked in docs/TASKS.md)
- the run is expected to mutate code, workflow, or living docs

The gate requires an integrated planning artifact created after issue bootstrap
and before execution.

That artifact must make visible at least:

- bounded slices
- dependency order
- blocking gates
- required evidence
- expected validations
- closure blockers

Moving from issue bootstrap directly into implementation without this artifact
is workflow failure and must be named as `execution-drift`.

### Phase Meanings

#### `Frame`

- understand the real request
- detect stack, product, contract, runtime, and abuse sensitivity
- re-anchor recurring repo-specific guidance from `napkin-discipline`
- gather the minimum context that makes routing defensible

#### `Load`

- discover candidate skills broadly, then invoke the minimum useful
  Z.ai skills via the Skill tool
- do not inflate context with unrelated playbooks

#### `Classify`

- choose trivial vs non-trivial
- choose the dominant entry branch
- decide whether delegation (via Task tool) is justified

#### `Plan`

- define bounded slices
- map dependencies
- define expected evidence
- keep issue shape and execution shape aligned

#### `Execute`

- implement in bounded batches
- keep review checkpoints active
- create follow-ups for real residuals instead of hiding them

#### `Gate`

- apply the required quality lenses
- re-check contracts, metadata, runtime promises, and branch obligations
- if `prompt-hardening` was required, verify the run surfaced the hardened
  artifact rather than only mentioning the gate

## Prompt-Hardening Satisfaction Rule

When `prompt-hardening` is active, the gate is not satisfied by commentary such
as "using prompt-hardening" alone.

The run must visibly expose one bounded artifact:

- `Hardened Prompt`
- `Execution-Ready Prompt`
- `Execution-Ready Prompt Packet`

A summary-only artifact is insufficient. The control plane should treat missing
transformation proof as an unsatisfied `Prompt Hardening Gate`.

Missing this artifact is a workflow defect and should be reviewable as a gate
failure.

## Issue Bootstrap Gate

The control plane now treats issue bootstrap as a blocking gate for engineering
mutation.

If the run is going to mutate code, workflow seeds, or living docs, it must do
one of these before implementation begins:

- attach to an existing execution-ready governing task in docs/TASKS.md
- create the governing task or parent/child package first
- expose an explicit, narrow, user-approved no-issue exception

What is no longer acceptable:

- starting implementation and creating the task later
- treating lifecycle, commit traceability, and review as optional because the
  task did not exist yet
- retroactively naming the run "issue-driven" after work already happened

This gate is enforced through:

- the `helm` root skill
- the branch enforcement matrix
- docs/TASKS.md + worklog.md
- the workflow execution manifest

## Persona Model

The formal persona catalog is:

1. `Specification PM` → `prompt-hardening` skill invocation
2. `Product Planner` → `Plan` subagent
3. `Implementation Designer` → `full-stack-developer` subagent
4. `Implementer / Developer` → `full-stack-developer` subagent
5. `Delivery PM` → master (checkpoint discipline, lifecycle hygiene)
6. `Runtime/Product Reviewer` → `product-runtime-review` skill
7. `Governance Auditor` → `Plan` subagent or master review
8. `Closure / Forensic Reviewer` → `forensic-review` skill
9. `Master Integrator` → master orchestrator

These are operating roles, not proof that separate agents exist.

### Practical Read

```text
prompt-hardening skill
  -> clarify actor / goal / acceptance

Plan subagent
  -> scope shape, parent/child, rollout order

full-stack-developer subagent
  -> bounded slices and execution design

full-stack-developer subagent
  -> code mutation, bounded implementation trade-offs, implementation proof

master
  -> checkpoint discipline, task lifecycle hygiene (docs/TASKS.md)

product-runtime-review skill
  -> browser truth (agent-browser), product correctness

Plan subagent / master review
  -> stack adherence, contract and truth drift

forensic-review skill
  -> side-by-side reconciliation, residual classification

master
  -> global authority and final judgment
```

## Subagent And Parallelism Model

`helm` is subagent-aware and treats multi-subagent execution (via Task tool)
as available for non-trivial work.

Subagents are bounded collaborators for:

- implementation slices (`full-stack-developer`)
- planning sidecars (`Plan`)
- governance audits (`Plan`)
- runtime/browser reviews (agent-browser + `frontend-styling-expert`)
- verification sidecars (`Explore`)

For non-trivial work:

- prefer bounded subagents when they create honest value
- if there is no safe implementation split, prefer a proof, review,
  governance, browser, or verification sidecar
- if no delegation shape is honest, keep the run root-owned
- if the run still remains fully single-threaded, emit an explicit
  `single-threaded exception` in the runtime packet

Every spawned subagent should start by loading `helm` classification for its
own slice, then leave self-review and self-forensic review output before
returning.

### Default Rules

- the master owns the global plan
- the master owns final integration correctness
- the master owns final forensic closure
- nested delegation is forbidden unless explicitly approved

### Parallelism Budget

```text
0 subagents
  -> only for trivial bounded work or explicit single-threaded exception

1 subagent
  -> one meaningful sidecar or the minimum valid non-trivial delegation

2-3 subagents
  -> independent bounded slices with real integration value

>3
  -> requires strong explicit justification
```

### Delegated Run

```text
Master run
  -> decide branch
  -> define Subagent Delegation Manifest
  -> spawn bounded subagents (via Task tool)
       -> each executes assigned slice
       -> each self-reviews
       -> each self-forensic-reviews
  -> master reviews child outputs
  -> master integrates
  -> master performs final closure
```

## Skill Activation Rule

The current intended rule is:

```text
discover broadly
  -> activate minimally (via Skill tool)
```

That means:

- if a skill might matter, it should be inspected
- after inspection, only the minimum valid skill stack should remain active for
  the chosen branch

This resolves the apparent tension between broad skill discovery and minimal
active orchestration.

## Transversal Workflows

The control plane also carries transversal workflows that cut across the entry
branches:

### Specification Workflow

```text
Spec
  -> Design
  -> Plan
  -> Implement
  -> Verify
  -> Release or Follow-up
```

### Review Workflow

```text
micro-review
  -> branch review
  -> integration review
  -> forensic review
  -> closure review
  -> review-of-review
```

### Autoresearch / Self-Evolution

```text
Failure capture
  -> root cause
  -> pattern test
  -> promotion decision
  -> insertion plan
```

### Subagent Workflow

```text
Decide spawn
  -> bound scope
  -> subagent execution (via Task tool)
  -> subagent self-review
  -> master review
  -> integration
  -> final forensic closure
```

## Quality Lenses And Review Architecture

`helm` does not close work on technical correctness alone.

Depending on the branch and surface, the run may require:

- `Product Correctness`
- `Anti-Abuse`
- `Contract Correctness`
- `Frontend Structure Correctness`
- `Backend Query Correctness`
- `Stack Adherence`

The final reconciliation must compare:

- requested vs implemented
- promised vs delivered
- issue scope vs actual landing
- review claim vs reality

## Product-Critical And Runtime-Sensitive Work

When the surface is user-facing and the cost of being merely "technically
correct" is high, the branch must treat product/runtime proof as first-class.

Typical examples:

- auth
- onboarding
- billing
- settings
- staged forms
- premium visual surfaces

In those cases:

- browser truth (via agent-browser) comes before narrative
- product-runtime review is not optional
- anti-abuse review becomes mandatory when the flow is abuse-sensitive

## Failure Taxonomy

Serious misses should be classified instead of hand-waved.

Useful classes include:

- `missing-rule`
- `enforcement-failure`
- `routing-failure`
- `review-failure`
- `closure-failure`
- `execution-drift`

This classification is especially important when deciding whether a miss should
stay local or be promoted into workflow hardening.

## Workflow Change Approval

When the proposed change would mutate workflow truth itself, the run should use
an explicit `Workflow Change Approval Gate`.

This applies to changes in:

- `helm` core
- adjacent workflow skills
- workflow enforcement docs
- stack-level workflow constitutions

The gate requires:

- a visible evidence packet
- explicit human approval in the session or in already-approved governing task
  policy that itself has prior explicit human authorization

Agent-authored task detail is not approval by itself.

## Entry Branches

The root currently recognizes these 12 main branches:

1. trivial bounded
2. ambiguous / long / epic-like
3. issue-driven delivery (via docs/TASKS.md)
4. bug / failure / regression
5. architecture / governance doubt
6. admin / operator / unfold surface
7. runtime / product-heavy flow
8. copy / locale / translation-boundary
9. product-critical user surface
10. visual / artifact-driven frontend
11. query / contract-sensitive backend
12. transport / dependency / legacy-adaptation doubt

## Branch Router

```text
helm
├── trivial bounded path
├── ambiguous / long / epic-like
│   └── prompt-hardening
├── issue-driven delivery (docs/TASKS.md)
│   ├── docs/TASKS.md entry
│   └── executing-plans
├── bug / failure / regression
│   └── systematic-debugging + stack lenses
├── architecture / governance doubt
│   ├── architecture
│   ├── governance-audit (Plan subagent)
│   └── prop4you-stack-constitution
├── admin / operator / unfold surface
│   └── admin surface skills
├── runtime / product-heavy flow
│   ├── product-runtime-review
│   └── anti-abuse-review when needed
├── copy / locale / translation-boundary
│   ├── i18n-patterns
│   └── server-prop-governance
├── product-critical user surface
│   ├── product-runtime-review
│   ├── server-prop-governance
│   ├── ascii-wireframe
│   └── domain-sensitive skills
├── visual / artifact-driven frontend
│   ├── front-react-shadcn
│   ├── frontend-boundary-governance
│   ├── tailwind-design-system
│   ├── ascii-wireframe
│   └── premium-interface-production when needed
├── query / contract-sensitive backend
│   ├── prisma patterns
│   ├── server-prop-governance
│   ├── sql-optimization-patterns
│   └── financial-source-truth when needed
└── transport / dependency / legacy-adaptation doubt
    ├── api-surface-governance
    ├── dependency-governance
    ├── legacy-transplant
    └── legacy-first-protocol
```

## Related Docs

- [Classification Matrix](classification-matrix.md)
- [Onboarding Model](onboarding-model.md)
- [SDD v1](sdd-v1.md)
- [Pre-Agents Baseline](pre-agents-baseline.md)

### Issue Stack Workflow

```text
helm
  -> Issue Bootstrap Gate
  -> docs/TASKS.md entry
  -> planning artifact gate
  -> executing-plans
  -> QA / browser-proof (agent-browser)
  -> worklog.md Stage Summary
  -> update docs/TASKS.md status to done
```

### QA / Proof Workflow

```text
Implement
  -> Backend QA (bun run lint + API checks)
  -> Frontend QA (bun run lint)
  -> Browser-Proof (agent-browser)
  -> Forensic closure (forensic-review skill)
```

### Runtime Observability Workflow

```text
Branch Entry Packet
  -> Runtime Delta Packet(s) on stack change
  -> Prompt Hardening Packet when active
  -> Subagent Return Packet(s)
  -> QA / Proof Packet(s)
  -> Closure Packet
```
