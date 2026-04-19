# Helm Onboarding Model

## Purpose

This document defines the onboarding architecture for the `helm` platform
(adapted from `accelerate` for Z.ai).

The onboarding system is responsible for helping `helm` enter a project
that does not yet have a mature local ecosystem.

## Product Goal

`helm` should be able to help bootstrap:

- itself
- the project's workflow adapter choice (docs/TASKS.md + worklog.md)
- the stack profile choice (Next.js 16 / Tailwind CSS 4 / Prisma)
- runtime adapter selection (bun, agent-browser)
- documentation adapter selection
- recommended Z.ai skills
- candidate future subagent specializations (via Task tool)

This must work even in projects that begin with little structure.

## Core Onboarding Thesis

Onboarding is not a one-time installer wizard.

It is an executive planning and discovery loop that can be re-entered whenever
the project evolves.

That means the onboarding system must be:

- dynamic
- re-runnable
- state-aware
- recommendation-oriented

## Onboarding Inputs

The onboarding flow should discover or ask about:

- repository type
- main language(s)
- web/backend/runtime stack
- workflow tracking preference (docs/TASKS.md is default)
- package/runtime wrappers (bun)
- documentation system
- browser/E2E posture (agent-browser)
- desire for bounded subagents now vs later (via Task tool)
- current project maturity

## Onboarding Outputs

The onboarding flow should produce:

- selected default stack profile
- selected workflow adapter (docs/TASKS.md + worklog.md)
- selected runtime adapters (bun, agent-browser)
- selected documentation adapter
- recommended companion Z.ai skills
- recommended future subagent candidates
- executive bootstrap plan

## Onboarding Phases

### Phase 1. Discovery

Collect explicit and inferred signals from the repository.

Sources may include:

- repository layout
- existing tool configs (package.json, tsconfig.json)
- existing package files (bun.lockb, node_modules)
- existing CI/docs structures
- explicit user answers

### Phase 2. A&Q

Ask the minimum questions needed to resolve uncertainty that materially affects
the chosen profile or adapters.

Examples:

- workflow tracking preference (default: docs/TASKS.md)
- preferred web stack if not yet established
- preferred runtime wrappers
- docs publication preference

### Phase 3. Executive Planning

Generate a bootstrap plan that explains:

- chosen defaults
- why they were chosen
- what remains optional
- what follow-up setup is recommended

### Phase 4. Recommendation Layer

Recommend:

- Z.ai skills
- adapters
- profile
- future subagent paths (via Task tool)

### Phase 5. Re-entry

Allow onboarding to be re-run later when:

- stack changes
- workflow tracking backend changes
- docs adapter changes
- subagent needs become clearer

## Selection Hierarchy

The onboarding system should choose in this order:

1. core laws are fixed
2. workflow adapter (docs/TASKS.md + worklog.md)
3. runtime adapters (bun, agent-browser)
4. stack profile (Next.js 16 / Tailwind CSS 4 / Prisma)
5. documentation adapter
6. Z.ai skill recommendations
7. future subagent recommendations

The core laws are not negotiable through onboarding.

Everything else is selected around them.

## Default Distribution

The default distribution for the Z.ai platform is:

- workflow adapter:
  - `docs/TASKS.md + worklog.md` (file-based issue tracking)
- runtime adapters:
  - `bun` (package manager, lint, dev server)
  - `agent-browser` (browser automation and visual QA)
- stack profile:
  - `nextjs-tailwind-prisma` (Next.js 16 + Tailwind CSS 4 + Prisma ORM)
- docs adapter:
  - project-local markdown docs

This is a default distribution, not a universal lock.

## Skill Recommendation Model

Onboarding should recommend adjacent Z.ai skills based on the selected profile
and adapters.

Examples:

- if Next.js + Prisma stack:
  - `nextjs-best-practices`, `nextjs-app-router-patterns`, `fullstack-dev` skills
- if frontend-heavy React stack:
  - `front-react-shadcn`, `front-react-layout-system` skills
- if workflow tracking uses docs/TASKS.md:
  - reference the worklog.md convention

The system should also recommend:

- `napkin-discipline`
- `prompt-hardening`

as operating companions, while preserving the rule that `helm` does not
depend on them semantically.

## Subagent Recommendation Model

Onboarding may surface future bounded-subagent candidates when repeated missing
specialties are already obvious.

The onboarding system must preserve the distinction between:

- recommending a subagent type shape
- creating a real runtime specialization

In the Z.ai platform, subagent selection is done via the Task tool with 5
available subagent types: `full-stack-developer`, `Plan`, `frontend-styling-expert`,
`Explore`, and `general-purpose`.

## Persistence Model

The persistence model for helm onboarding outputs is:

- `docs/helm/` workspace (replaces `.accelerate/`)
- generated planning docs under `planning/`
- `worklog.md` for session memory and state persistence
- `docs/TASKS.md` for task tracking

The persistence choice should remain simple and file-based without requiring
a separate configuration system.

## Failure Modes

### Failure Mode 1. Over-questioning

The onboarding asks too many questions and loses momentum.

Mitigation:

- only ask questions that materially change adapter/profile choices

### Failure Mode 2. Over-inference

The onboarding assumes too much from weak repo signals.

Mitigation:

- keep A&Q for high-impact ambiguities

### Failure Mode 3. Fake flexibility

The onboarding becomes so generic that the platform loses its opinionated
defaults.

Mitigation:

- preserve the default distribution until a better fit is actually chosen

## Initial Implementation Guidance

When onboarding is first implemented, start with:

1. discovery inputs
2. A&Q schema
3. executive planning output
4. recommendation output

Do not start with full persistence or automation breadth first.
