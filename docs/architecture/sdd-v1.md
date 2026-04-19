# Helm SDD v1

## Document Status

- status: draft baseline (adapted from accelerate SDD v1)
- phase: post-adaptation architecture definition
- source inputs:
  - `docs/bootstrap/context-and-origin.md`
  - `docs/bootstrap/decisions-and-final-state.md`
  - `docs/bootstrap/prd-initial-platform-foundation.md`
  - `docs/plano-helm.md` (adaptation plan)
- date: 2026-06-23

## Purpose

This document is the software design document for `helm`, the Z.ai adaptation
of the `accelerate` engineering orchestration platform.

Its job is to define how the mature accelerate system has been adapted into a
layered platform for the Z.ai ecosystem without losing the opinionated defaults
and root laws that make it valuable.

## Scope

This SDD covers:

- target repository architecture
- platform layer boundaries
- adaptation strategy (accelerate → helm)
- onboarding system shape
- planning system shape
- workflow adapter shape (docs/TASKS.md + worklog.md)
- runtime adapter shape (bun, agent-browser)
- stack profile shape (Next.js 16 / Tailwind CSS 4 / Prisma)
- subagent model shape (5 subagentes via Task tool)
- documentation architecture

This SDD does not implement those layers directly — it documents the adapted
architecture.

## Design Drivers

The design is constrained by the following accepted truths:

1. `helm` is more than a local skill bundle — it is an orchestration platform.
2. The root control plane must remain explicit and strong.
3. Subagents are optional and subordinate (via Task tool, not *.toml agents).
4. Adaptation is layered, preserving the original depth.
5. Strong defaults are part of the product value.
6. Greenfield onboarding is first-class.
7. Z.ai enforcement is soft (skill description + payload.message + worklog),
   not hard (no "always-on root skill" mechanism).

## Architectural Thesis

`helm` is designed as an opinionated platform with these layers:

- `core`
- `workflow adapters` (docs/TASKS.md + worklog.md)
- `runtime adapters` (bun, agent-browser)
- `stack profiles` (Next.js 16 / Tailwind CSS 4 / Prisma)
- `subagent model` (5 subagentes via Task tool)
- `onboarding`
- `planning`
- `project overlays`

The dominant default distribution is deeply aligned with the Z.ai stack
(bun/Next.js/Prisma/agent-browser) while still allowing the system to adapt
to another project through guided onboarding.

## Target Repository Shape

```text
helm/
├── SKILL.md
├── AGENTS.md
├── README.md
├── docs/
│   ├── bootstrap/
│   └── architecture/
├── core/
│   ├── control-plane/
│   ├── hardening/
│   ├── issue-topology/
│   ├── lanes/
│   ├── personas/
│   ├── review/
│   ├── risk/
│   ├── closure/
│   ├── delegation/
│   └── workflows/
├── adapters/
│   ├── workflow/
│   │   └── zai-adapter.md      (docs/TASKS.md + worklog.md)
│   ├── runtime/
│   │   └── zai-adapter.md      (bun, Prisma, agent-browser)
│   └── enforcement/
│       └── zai-enforcement.md  (3-layer enforcement model)
├── onboarding/
├── planning/
├── references/
└── overlays/
```

## Layer Responsibilities

### 1. Core

The core is where the non-negotiable laws of the platform live.

The core owns:

- root orchestration
- classification rules
- prompt-hardening gate
- issue topology model
- manager-lane model
- risk-enforcement model
- root closure mode
- runtime packet schemas
- proof ordering
- subagent optionality (Task tool, not *.toml)

The core must remain:

- project-agnostic
- stack-aware
- opinionated

The core must not own:

- vendor-specific workflow APIs
- raw repo-specific command strings
- project business overlays

### 2. Workflow Adapters

Workflow adapters implement the same orchestration concepts for different issue
or task tracking backends.

The Z.ai workflow adapter uses:

- `docs/TASKS.md` as the issue tracker (markdown table with status values)
- `worklog.md` as the activity log (stage summaries, evidence)

Every workflow adapter should support the same conceptual model:

- issue bootstrap (create task in docs/TASKS.md)
- issue topology (single/sibling/parent+child)
- metadata hygiene
- lifecycle state transitions (pending → in-progress → in-review → done)
- worklog.md stage summaries (replaces AI Review Report)
- traceable closure (update docs/TASKS.md status)

### 3. Runtime Adapters

Runtime adapters translate capability-level execution expectations into
concrete toolchains.

The Z.ai runtime adapter maps:

| Capability | Z.ai Implementation |
| --- | --- |
| Lint + type check | `bun run lint` |
| Database sync | `bun run db:push` (Prisma) |
| Dev server | `bun run dev` |
| Browser QA | `agent-browser` |
| Visual proof | `agent-browser --snapshot` |
| Web search | `z-ai function -n web_search` |

### 4. Stack Profiles

Stack profiles bundle opinionated defaults for a technology posture.

The default Z.ai profile is `nextjs-tailwind-prisma`:

- Next.js 16 (App Router)
- Tailwind CSS 4
- shadcn/ui
- Prisma ORM (SQLite)
- bun runtime

### 5. Subagent Model

The subagent model formalizes how the 5 Z.ai Task tool subagentes are used:

- `full-stack-developer` — implementation worker + planner sidecar
- `Plan` — governance auditor + decomposition
- `frontend-styling-expert` — runtime/product reviewer
- `Explore` — verification sidecar
- `general-purpose` — research + multi-step exploration

It must preserve the distinction between:

- gap detection
- suggestion
- human decision (the human decides to create/update skill or subagent config)
- runtime execution (via Task tool)

### 6. Onboarding

Onboarding is the system that lets `helm` land in a repository with
little prior setup.

It should determine:

- workflow backend (docs/TASKS.md + worklog.md)
- stack profile
- runtime adapters
- docs adapter
- recommended Z.ai skills
- candidate future subagent specializations

### 7. Planning

Planning formalizes the artifact layer that bridges discovery and execution.

It should own:

- executive plans
- architecture plans
- migration plans
- onboarding bootstrap plans
- promotion planning

Planning is a platform layer, not just a docs habit.

### 8. Overlays

Overlays capture project-specific deployment truth that should not leak into
the reusable core.

## Root Interface

The root interface is `SKILL.md` (registered as a Z.ai skill with strong
description).

Design decision:

- `SKILL.md` remains the compact constitutional entrypoint
- `README.md` remains the richer operational guide
- deep behavior continues to live in architecture docs and submodules

Rationale:

- the Z.ai Skill tool uses the description field for relevance inference
- keeps the root interface compact
- avoids forcing every session to consume the full architecture set

## Documentation Architecture

The documentation system uses a three-tier model:

1. root entry documents
   - `SKILL.md`
   - `AGENTS.md`
   - `README.md`
2. architecture documents
   - system design, adaptation, onboarding, planning, adapters
3. submodule doctrine
   - subagent model
   - profile-specific guidance
   - workflow adapter specifics

## Adaptation Model

The adaptation from accelerate to helm follows the "adapt, not rewrite" principle:

1. Clone the accelerate structure
2. Apply systematic substitutions (Claude→Z.ai, Linear→docs/TASKS.md, etc.)
3. Create Z.ai-specific adapters where no equivalent exists
4. Preserve depth and modularity

### What Changed

| accelerate Concept | helm Equivalent |
| --- | --- |
| always-on root skill | skill with strong description (3-layer enforcement) |
| *.toml agents | 5 subagentes via Task tool |
| Linear / GitHub Issues | docs/TASKS.md + worklog.md |
| manage.py check | bun run lint |
| makemigrations | bun run db:push |
| Django ORM | Prisma ORM |
| Python/uv | bun/Next.js |
| Chrome DevTools | agent-browser |
| Playwright | N/A (use agent-browser) |
| .accelerate/ workspace | docs/helm/ |
| AI Review Report | worklog.md Stage Summary |
| persona activation | skill invocation via Skill tool |
| auto-promote agent | human decides to create/update skill |

### What Stayed

- Core workflow catalog (25 named workflows)
- Branch enforcement matrix structure
- Persona model (11 personas, mapped to skills/subagentes)
- Self-evolution protocol
- Operational calibration
- Maturity control
- Review architecture
- Risk enforcement model

## Cross-Cutting Constraints

The design must preserve:

- root-owned closure
- root-owned topology
- subagent optionality
- strong opinionated defaults
- layered adaptation

The design must avoid:

- blind file mirroring
- weakening the root to make adapters easier
- reintroducing mandatory multi-subagent doctrine
- mixing profiles and overlays

## Testing Strategy For The Platform Architecture

At architecture time, proof is documentation and adaptation coherence.

The first validation pass should verify:

- every target layer has a clear responsibility
- every major upstream artifact can be classified
- no target layer requires contradictory authority
- onboarding can select adapters/profiles without weakening core laws

## Out-Of-Scope Decisions Deferred

The following remain intentionally deferred:

- packaging and publishing strategy
- installation CLI
- CI pipeline
- exact config file formats for onboarding outputs
- exact runtime adapter invocation API

## Next Artifacts

This SDD is not complete by itself.

It depends on the following companion docs:

- `classification-matrix.md`
- `control-plane.md`
- `onboarding-model.md`

Together, these documents define the adapted architecture set for helm on
the Z.ai platform.
