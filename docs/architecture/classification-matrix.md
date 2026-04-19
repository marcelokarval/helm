# Helm Classification Matrix

## Purpose

This matrix classifies the upstream `helm` material (adapted from `accelerate`)
into the target layers of the Z.ai platform.

It is intentionally practical. It exists to stop migration from becoming
guesswork or blind copying.

## Classification Legend

- `core`
  - non-negotiable reusable platform laws
- `Z.ai skill`
  - a Z.ai skill invoked via the Skill tool (replaces agent activation)
- `workflow adapter`
  - issue/ticket backend implementation layer (docs/TASKS.md + worklog.md)
- `runtime adapter`
  - concrete command/toolchain layer (bun, Prisma, agent-browser)
- `stack profile`
  - opinionated technology posture (Next.js 16 / Tailwind CSS 4 / Prisma)
- `agent factory`
  - bounded-subagent doctrine via Task tool (5 subagentes)
- `planning`
  - formal planning artifacts that bridge discovery and execution
- `overlay`
  - project-specific deployment truth
- `publication adapter`
  - public-doc rendering layer

## Matrix

| Upstream Artifact | Current Location | Target Layer | Migration Note |
| --- | --- | --- | --- |
| root `SKILL.md` | `skills/helm/SKILL.md` | `core` + `Z.ai skill` | Keep as the compact constitutional entrypoint. Also registered as a Z.ai skill with strong description. |
| root `README.md` | `skills/helm/README.md` | `core` | Keep as operational guide; update links after extraction. |
| `control-plane.md` | `docs/architecture/control-plane.md` | `core` | Becomes canonical platform architecture source. |
| bootstrap PRD / SDD / architecture docs | `docs/bootstrap/*`, `docs/architecture/*` | `planning` + `core` | Architecture reasoning remains durable docs; execution-facing planning should gain native planning homes. |
| `prompt-hardening-gate.md` | `references/prompt-hardening-gate.md` | `core` + `Z.ai skill` | Move under `core/hardening/`. The existing `prompt-hardening` Z.ai skill is the runtime implementation. |
| `issue-stack.md` | `references/issue-stack.md` | `core` | Move under `core/control-plane/` or `core/issue-topology/`. Replace Linear/GitHub issue references with docs/TASKS.md entries. |
| runtime packet templates | `references/runtime-packet-templates.md` | `core` | Move under `core/runtime-packets/`. |
| runtime observability cadence | `references/runtime-observability-cadence.md` | `core` | Move under `core/runtime-packets/`. Adapt to worklog.md patterns. |
| trivial branch contract | `references/trivial-branch-contract.md` | `core` | Keep as branch contract under control-plane doctrine. |
| `subagent-model.md` | `references/subagent-model.md` | `core` + `agent factory` | Split root law vs Task tool subagent specifics. Map to 5 Z.ai subagentes. |
| `current-enforcement-surfaces.md` | `references/current-enforcement-surfaces.md` | `core` | Reframe as enforcement inventory in the platform. Replace "always-on root skill" with "skill com description forte". |
| `executive-operating-matrix.md` | `references/executive-operating-matrix.md` | `core` | Keep as executive summary of platform laws. |
| `autoresearch-and-self-evolution.md` | `references/autoresearch-and-self-evolution.md` | `core` + `onboarding` | Root self-evolution law stays core; onboarding discovery hooks may reference it. |
| `codex-agents/README.md` | `references/codex-agents/README.md` | `agent factory` | Rehome as inherited doctrine. Map Codex agent concepts to Z.ai Task tool subagentes. |
| `agent-ontology.md` | `references/codex-agents/agent-ontology.md` | `agent factory` | Move into doctrine. Adapt for Z.ai subagent model. |
| `agent-capability-matrix.md` | `references/codex-agents/agent-capability-matrix.md` | `agent factory` | Move into doctrine. Map capabilities to Z.ai subagent types. |
| `control-plane-org-map.md` | `references/codex-agents/control-plane-org-map.md` | `core` + `agent factory` | Root macro model should stay visible in core; family mapping can live in agents. |
| `manager-lane-map.md` | `references/codex-agents/manager-lane-map.md` | `core` | This is root-lane doctrine. |
| `lane-governance-model.md` | `references/codex-agents/lane-governance-model.md` | `core` | This is root governance law. |
| `root-vs-agent-authority-boundary.md` | `references/codex-agents/root-vs-agent-authority-boundary.md` | `core` + `agent factory` | Root law plus Task tool subagent subordination. |
| `issue-topology-policy.md` | `references/codex-agents/issue-topology-policy.md` | `core` | Root-owned topology remains core. Replace issue references with docs/TASKS.md. |
| `agent-execution-contract.md` | `references/codex-agents/agent-execution-contract.md` | `agent factory` | Bounded-subagent execution law via Task tool. |
| `staffing-and-decomposition-policy.md` | `references/codex-agents/staffing-and-decomposition-policy.md` | `core` + `agent factory` | Root law with Z.ai subagent selection implications. |
| `risk-enforcement-model.md` | `references/codex-agents/risk-enforcement-model.md` | `core` | Core law. |
| `risk-enforcement-matrix.md` | `references/codex-agents/risk-enforcement-matrix.md` | `core` | Core law. |
| `active-risk-detection-signals.md` | `references/codex-agents/active-risk-detection-signals.md` | `core` | Core enforcement details. |
| `closure-blockers-and-escalation.md` | `references/codex-agents/closure-blockers-and-escalation.md` | `core` | Core closure and escalation law. |
| `return-and-escalation-contracts.md` | `references/codex-agents/return-and-escalation-contracts.md` | `core` + `agent factory` | Root return law plus Task tool subagent return contract. |
| `agent-empirical-replay.md` | `references/codex-agents/agent-empirical-replay.md` | `agent factory` + `profiles` | Replay should be profile-aware over time. |
| `agent-pooling-model.md` | `references/codex-agents/agent-pooling-model.md` | `agent factory` | Pooling and fit scoring. |
| `agent-selection-policy.md` | `references/codex-agents/agent-selection-policy.md` | `agent factory` | Selection logic. |
| `agent-gap-detection.md` | `references/codex-agents/agent-gap-detection.md` | `agent factory` | Gap detection and suggestion law. |
| `agent-skill-envelopes.md` | `references/codex-agents/agent-skill-envelopes.md` | `agent factory` | Skill-envelope doctrine. |
| executive bootstrap plan template | `onboarding/planning/executive-bootstrap-plan-template.md` | `planning` | Canonical ownership should move into `planning/executive/`. |
| workflow tracking assumptions | mixed skills/docs | `workflow adapter` + `overlay` | Replace Linear/GitHub with docs/TASKS.md + worklog.md. Shared orchestration concepts become adapter. |
| `uv run ... manage.py ...` examples | mixed skills/docs | `runtime adapter` + `stack profile` | Replace with `bun run lint`, `bun run db:push`, `agent-browser`. |
| `Next.js 16`, Prisma, Tailwind CSS 4, shadcn/ui assumptions | mixed skills/docs | `stack profile` | Becomes default Z.ai profile. |
| Chrome DevTools and Playwright proof ordering | mixed skills/docs | `runtime adapter` + `core` | Ordering law stays core; tool specifics become `agent-browser`. |
| Docusaurus docs | `frontends/docusaurus/docs/ai/*` | `publication adapter` + `overlay` | Public-doc output path, optional. |
| Project-specific language | mixed docs | `overlay` | Keep out of reusable core whenever possible. |

## Immediate Extraction Guidance

The safest early moves are:

1. extract `core` doctrine first
2. institute `planning` as a native layer
3. extract `agent factory` (adapt to 5 Z.ai subagentes via Task tool)
4. define the first `stack profile` (Next.js 16 / Tailwind CSS 4 / Prisma)
5. then define workflow/runtime adapters (docs/TASKS.md + worklog.md + agent-browser)
6. leave overlays and publication adapters for later phases

## Explicit Split Warnings

### Core vs Stack Profile

Do not let these leak into core:

- repo-specific paths
- package manager flags (bun vs npm)
- framework-specific validation commands

### Core vs Overlay

Do not let these leak into core:

- project brand naming
- project-specific task conventions that are not part of the shared workflow
  model
- local documentation publishing paths

### Core vs Agent Factory

Keep in core:

- root authority
- topology law
- risk law
- closure law

Keep in agent factory:

- subagent type selection (5 Z.ai subagentes via Task tool)
- templates
- envelopes
- delegation criteria

### Core vs Z.ai Skill

Keep in core:

- the law (what must happen)
- the gate (when it blocks)

Keep in Z.ai skill:

- the implementation (how it executes)
- the runtime payload
- the invocation via Skill tool

## Next Use

This matrix should be used directly by the migration plan.
