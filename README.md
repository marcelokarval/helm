# Helm

`helm` is the root orchestration skill for engineering work in the
standalone platform and its supported project distributions.

Use it to decide how work should run before implementation starts, not merely
to narrate that work is happening.

It is the control plane that chooses:

- whether the run is trivial or non-trivial
- whether prompt hardening is required
- which issue topology is honest
- which lanes and skills must be open
- whether delegation is useful at all
- which proof stack is required
- which blockers still control closure

The short constitutional entry file is:

- [SKILL.md](./SKILL.md)

This README is the richer, living guide for how `helm` is meant to be understood and used in its current default distribution.

## What It Is

`helm` is:

- the root workflow orchestrator
- the visible operating system for engineering teamwork
- a specification-first and issue-aware control plane
- a stack-aware but project-agnostic governance layer
- the owner of topology, staffing, risk enforcement, and closure

It is strongest when work is:

- issue-driven
- cross-surface
- architecture-sensitive
- user-facing or runtime-sensitive
- abuse-sensitive
- ambiguous enough to drift without shaping

## What It Is Not

`helm` is not:

- an implementation skill
- a replacement for stack-specific skills
- a requirement that subagent types must exist before the workflow can operate
- a justification for unnecessary ceremony
- a license for bounded subagents to inherit orchestration authority

## Relationship To The Root Skill

Keep the split intentional:

- [SKILL.md](./SKILL.md)
  - short constitutional entry skill
- this README
  - richer operational guide, examples, reading map, and doctrine overview
- `references/`
  - inherited deep doctrine that remains readable as supporting context while
    native surfaces continue taking over primary authority

The root skill should stay compact.

The README should stay rich enough for onboarding and maintenance.

The references should stay readable for inherited depth, but when a surface has
already been rehomed into `core/`, the native local file is the primary
authority.

See also:

- [references/README.md](./references/README.md)

for the explicit native-vs-supporting authority map inside the reference layer.


## Pre-Agents Baseline

The standalone repo now has a native pre-agents baseline.

Start here:

- [pre-agents-baseline.md](./docs/architecture/pre-agents-baseline.md)
- [core/README.md](./core/README.md)
- [adapters/workflow/README.md](./adapters/workflow/README.md)
- [adapters/runtime/README.md](./adapters/runtime/README.md)
- [onboarding/README.md](./onboarding/README.md)
- [planning/README.md](./planning/README.md)

Use `references/` as supporting doctrine while rehoming continues. Branch,
proof, delegation, workflow, calibration, and product-critical doctrine now
have native homes under `core/`.

## Core Operating Model

At a high level, `helm` works like this:

1. classify the run
2. decide whether prompt hardening is mandatory
3. decide the honest issue topology
4. decide which lanes and skills are required
5. decide whether the work should stay root-only or use bounded subagents
6. execute with visible runtime packets and active gates
7. force proof in the correct order
8. enter root closure mode before `Done`

The control plane should be visible, not implied.

## Prompt Hardening

`helm` must decide whether prompt hardening is required before execution
starts.

Hardening is not cosmetic rewriting. It is a blocking gate when the request is:

- long
- ambiguous
- multi-objective
- multi-phase
- architecture-heavy
- likely to drift into issue creation, planning, runtime proof, or multi-surface
  work

When hardening is active, the run should visibly expose:

- `Prompt A`
- `Prompt B`
- material changes
- bounded scope
- explicit non-goals
- next branch or persona route

See:

- [prompt-hardening.md](./core/hardening/prompt-hardening.md)

## Issue-Driven Mutation Stack

When the work mutates code, docs, workflow seeds, or runtime governance, the
issue stack is mandatory.

The minimum mutation path is:

1. `helm`
2. `Issue Bootstrap Gate`
3. docs/TASKS.md + worklog.md
4. planning artifact
5. execution
6. proof stack
7. `worklog.md Stage Summary`
8. root closure mode

Mutation must not jump directly from request to implementation.

See:

- [issue-driven-mutation-stack.md](./core/issue-topology/issue-driven-mutation-stack.md)

## Enforcement And Branching

The native branch and enforcement authorities now live in:

- [branch-enforcement-matrix.md](./core/control-plane/branch-enforcement-matrix.md)
- [enforcement-surfaces.md](./core/risk/enforcement-surfaces.md)

Use them to decide:

- which branch is active
- which mandatory skills must be open
- which gates are blocking
- which proof and artifacts closure requires

## Proof Stack

The native proof-order and lane-ownership authority now lives in:

- [qa-proof-stack.md](./core/runtime-packets/qa-proof-stack.md)

Proof ordering is:

1. implementation proof
2. backend/frontend QA proof
3. browser truth
4. agent-browser validation
5. forensic closure

## Agent Optionality

Subagent types are a governed capability, not a structural dependency.

`helm` must remain fully functional:

- when no subagent types are selected
- when the user explicitly disables agents
- when the current pool has no honest fit
- when integration cost is higher than the gain from delegation

`helm` may:

- suggest a future subagent type selection
- decide that no subagent should be used
- keep the run fully root-owned

`helm` must not:

- force delegation because a catalog exists
- force delegation because thread budget exists
- treat gap detection as automatic subagent type selection

The native bounded-delegation authority now lives in:

- [subagent-model.md](./core/delegation/subagent-model.md)

### Suggestion vs Subagent Type Selection

These are different actions:

- `suggestion`
  - the root concludes that a repeated missing specialty exists
- `subagent type selection`
  - the governed process later decides to select the appropriate subagent type
    from the 5 available Z.ai subagent types

Detecting a gap does not create a subagent by itself.

## Root-Only Mode

Root-only mode is a valid operating posture, not a degraded failure state.

Keep work root-only when:

- topology is still unstable
- the dominant need is lane-governor judgment
- the fit for a bounded family is weak
- the user asked for no agents in this run
- the expected integration burden outweighs the delegation gain

## User-Controlled Agent Disable

The user may disable agents explicitly:

- for the whole run
- for one bounded slice

When that happens, `helm` still governs the run normally. The only change
is that the execution stays root-owned.

## Recommended Adjacent Skills

`helm` should coexist well with these adjacent disciplines:

- `napkin-discipline`
  - keeps the recurring runbook and durable tactical guidance fresh
- `prompt-hardening`
  - reinforces proper skill discovery and activation discipline via Skill tool

They are recommended operating companions.

They are not the semantic foundation of `helm`.

`helm` must still make correct control-plane decisions even if the user is
not explicitly talking about those adjacent skills.

## Named Workflows And Calibration

The native workflow and calibration authorities now live in:

- [catalog.md](./core/workflows/catalog.md)
- [operational-calibration.md](./core/workflows/operational-calibration.md)
- [self-evolution.md](./core/workflows/self-evolution.md)
- [maturity-control.md](./core/workflows/maturity-control.md)

Use them when the question is not only what branch is active, but what named
execution family, proportionality, and workflow self-improvement posture should
govern the run.

## Product-Critical And Premium Surfaces

The native review authority for high-stakes user surfaces now lives in:

- [product-critical-surfaces.md](./core/review/product-critical-surfaces.md)
- [premium-interface-production.md](./core/review/premium-interface-production.md)

Do not treat these branches as generic frontend work. They require backend
truth sufficiency, stronger artifact discipline, and stricter closure judgment.

## Root Authority

The root owns:

- classification
- prompt-hardening decisions
- issue topology
- lane opening and closing
- staffing shape
- delegation budget
- risk enforcement
- final AI review
- root closure mode
- `Done`

This authority is not delegated by default.

See:

- [root-vs-agent-authority-boundary.md](./references/codex-agents/root-vs-agent-authority-boundary.md)
- [issue-topology-policy.md](./references/codex-agents/issue-topology-policy.md)
- [risk-enforcement-matrix.md](./references/codex-agents/risk-enforcement-matrix.md)

## Future Bounded Subagent Authority

Future bounded subagents are subordinate execution or review units.

They may:

- accept a bounded slice
- stay inside their write scope
- run required validations
- perform self-review and self-forensic review
- return evidence on the task to the master
- set the task to `in-review` status

They must not, by default:

- decompose the work further
- create tasks
- change issue topology
- restaff or respawn the run
- claim closure authority
- update docs/TASKS.md status to `done`

### Helm Inside A Bounded Subagent

A future bounded subagent may still carry `helm` as local execution
discipline.

Inside that bounded context, `helm` means:

- bounded classification of the assigned slice
- visible runtime state
- honest verification

It does not mean:

- executive routing
- staffing authority
- topology control
- closure authority

## Control-Plane Pools

The control plane reasons through explicit pools before selecting a bounded
family:

- manager lane pool
- issue topology pool
- risk detection pool
- closure blocker pool
- evidence pool
- family pool
- future-gap pool

This means the root should think about:

1. which class of decision is active
2. which lane owns that decision
3. which risk is dominant
4. which evidence class is required
5. only then whether a bounded family is useful

See:

- [agent-pooling-model.md](./references/codex-agents/agent-pooling-model.md)

## Manager Lanes

The current macro model distinguishes explicit manager lanes:

- executive routing
- technical
- lifecycle
- design-contract
- proof
- trust

These are not runtime worker roles by default.

They are root-owned managerial functions that steer the system.

See:

- [manager-lane-map.md](./references/codex-agents/manager-lane-map.md)
- [lane-governance-model.md](./references/codex-agents/lane-governance-model.md)

## Issue Topology

Issue topology is a root decision, not an implementation convenience.

The root should choose between:

- single issue
- sibling issues
- parent + child
- parent + child + review lane

The question is not "how many tasks feel nice".

The question is "what is the honest execution graph for this work".

See:

- [issue-topology-policy.md](./references/codex-agents/issue-topology-policy.md)

## Risk Enforcement

Risk is an active control-plane function.

Material risk must have:

- detector
- signal
- owner
- blocker condition
- release condition

Do not treat risk as a vague narrative warning.

If a risk becomes dominant, the corresponding lane or blocker must activate.

See:

- [risk-enforcement-model.md](./references/codex-agents/risk-enforcement-model.md)
- [risk-enforcement-matrix.md](./references/codex-agents/risk-enforcement-matrix.md)
- [active-risk-detection-signals.md](./references/codex-agents/active-risk-detection-signals.md)

## Root Closure Mode

Final closure is root-owned.

That means:

- bounded subagents may return work
- bounded subagents may set `in-review` status
- only the root performs final revalidation
- only the root enters root closure mode
- only the root can update docs/TASKS.md status to `done`

The final closure question is not "did something happen".

It is "does the requested vs implemented comparison, evidence stack, issue
lifecycle, and residual-risk posture support real closure".

## Examples

### Example 1. Trivial bounded read

User asks a small engineering question with no mutation.

Expected behavior:

- `helm` classifies trivial
- no issue bootstrap
- no subagent types required
- root answers directly with honest evidence

### Example 2. Non-trivial work with no subagent types available

The repo has no subagent types selected yet, but the work is still
cross-surface and issue-driven.

Expected behavior:

- `helm` still operates normally
- root chooses topology, lanes, and proof stack
- root executes or coordinates bounded slices locally
- no delegation is forced

### Example 3. User disables agents explicitly

The user says not to use agents for this run.

Expected behavior:

- `helm` respects the instruction
- root-only mode becomes active
- issue bootstrap, planning, proof, and closure still happen normally

### Example 4. No honest fit in the current pool

The work repeatedly needs a specialty not covered by the current subagent types.

Expected behavior:

- `helm` does not force the least-wrong subagent type
- root keeps the run honest
- gap detection may suggest a future subagent type selection
- no automatic delegation happens

### Example 5. Parent + child + review lane

The outcome is one coherent feature, but rollout or proof deserves separate
visibility.

Expected behavior:

- root chooses `parent + child + review lane`
- lifecycle and technical lanes open first
- review lane exists as explicit surface, not an afterthought

### Example 6. Bounded subagent returns successfully

A future bounded subagent completes a slice.

Expected behavior:

- it returns requested vs implemented comparison
- it returns self-review and self-forensic review
- it returns evidence to the master
- it sets the task to `in-review` status
- the root still performs final AI review and closure

### Example 7. Ambiguous prompt triggers hardening first

The request is long, multi-phase, and still allows several honest execution
interpretations.

Expected behavior:

- `helm` does not jump into implementation
- prompt-hardening skill invocation runs first
- the hardened prompt exposes bounded scope and explicit non-goals
- only then does the root classify topology and staffing

### Example 8. Mutating work cannot skip the issue stack

The request mutates workflow docs, code, or living governance docs.

Expected behavior:

- `helm` opens the issue lane first
- issue bootstrap and planning artifact gates become visible
- execution only starts after issue and plan hygiene are satisfied
- closure still requires `worklog.md Stage Summary` and root closure mode

### Example 9. Subagent types exist, but root-only is still the cleaner path

Subagent types are available, but the fit is weak and the dominant need is still root
judgment.

Expected behavior:

- `helm` does not delegate by habit
- root-only mode remains active
- `single-threaded exception` is emitted honestly when the run is non-trivial
- the work still follows the same proof and closure standards

## Common Usage Guidance

Use `helm` whenever the request may involve:

- repository analysis
- planning
- debugging
- implementation
- review
- workflow mutation
- documentation mutation
- issue lifecycle work
- engineering command execution

Do not bypass it merely because the task looks small.

## Reading Map

Start here:

- [SKILL.md](./SKILL.md)

Then use the local architecture docs when you want the current standalone
forward path:

- [control-plane.md](./docs/architecture/control-plane.md)
- [sdd-v1.md](./docs/architecture/sdd-v1.md)

Then use the governed reference tree for supporting authority:

- [team-operating-model.md](./references/team-operating-model.md)
- [executive-operating-matrix.md](./references/executive-operating-matrix.md)
- [subagent-model.md](./references/subagent-model.md)
- [runtime-packet-templates.md](./references/runtime-packet-templates.md)
- [runtime-observability-cadence.md](./references/runtime-observability-cadence.md)
- [branch-enforcement-matrix.md](./references/branch-enforcement-matrix.md)
- [issue-stack.md](./references/issue-stack.md)
- [qa-proof-stack.md](./references/qa-proof-stack.md)

For the governed future-agent ecosystem:

- [codex-agents/README.md](./references/codex-agents/README.md)

## Platform Source Of Truth

For this standalone repository:

- repo source of truth:
  - the files tracked here
- runtime mirror:
  - `skills/helm/` when global sync is intentionally performed

This README describes the standalone product model first.

Global sync remains a separate step.

Do not treat any runtime mirror as the authoring source for governed
`helm` behavior.

## Current Distribution Reality

The current default distribution is still strongly shaped by the incubator
stack that matured `helm` first.

That is a distribution and migration fact, not the permanent boundary of the
platform core.

Treat:

- workflow backend assumptions
- stack assumptions
- runtime command assumptions
- project-specific docs posture

as material that will progressively move into adapters, profiles, and overlays.

## Current Repository Shape

The repository is no longer only a transitional import tree.

The first standalone shell of the target architecture now exists:

- `core/`
- `adapters/`
- `profiles/`
- `agents/`
- `onboarding/`
- `overlays/`

These directories currently act as contract-bearing shells while the inherited
doctrine is still being rehomed out of `references/`.

## Repository Bootstrap Context

This repository also carries standalone bootstrap and architecture context for
the extraction and early platform build-out:

- [docs/bootstrap/context-and-origin.md](./docs/bootstrap/context-and-origin.md)
- [docs/bootstrap/decisions-and-final-state.md](./docs/bootstrap/decisions-and-final-state.md)
- [docs/bootstrap/prd-initial-platform-foundation.md](./docs/bootstrap/prd-initial-platform-foundation.md)
- [docs/architecture/sdd-v1.md](./docs/architecture/sdd-v1.md)
- [docs/architecture/classification-matrix.md](./docs/architecture/classification-matrix.md)
- [docs/architecture/onboarding-model.md](./docs/architecture/onboarding-model.md)
- [docs/architecture/pre-agents-baseline.md](./docs/architecture/pre-agents-baseline.md)
