# Helm Pre-Agents Baseline

## Status

- status: active baseline
- phase: pre-agents
- date: 2026-06-23
- platform: Z.ai

## Purpose

This document declares what must already be true before the platform begins
real subagent specialization work.

## A Standalone Repo Is Pre-Agents Ready When

1. the root control plane is natively documented
2. prompt hardening is a native gate
3. issue-driven mutation discipline is native (via docs/TASKS.md)
4. topology, lanes, risk, and closure are native core concepts
5. skill activation via Skill tool and review architecture are native core concepts
6. workflow, proof, and delegation doctrine are native core concepts
7. workflow adapters are documented as peers, not accidents
8. runtime adapters are documented as capabilities-to-tooling layers
9. onboarding has a native operational surface
10. the repo remains fully functional with zero specialized subagents

## Current Native Baseline

The current native pre-agents baseline now includes:

- `core/control-plane/branch-enforcement-matrix.md`
- `core/control-plane/quick-invocation-map.md`
- `core/control-plane/workflow-change-approval-gate.md`
- `core/personas/model.md`
- `core/personas/mandatory-skills.md`
- `core/personas/executive-matrix.md`
- `core/hardening/` (references prompt-hardening skill)
- `core/issue-topology/issue-driven-mutation-stack.md`
- `core/delegation/subagent-model.md`
- `core/lanes/manager-lane-model.md`
- `core/risk/enforcement-surfaces.md`
- `core/review/product-critical-surfaces.md`
- `core/review/premium-interface-production.md`
- `core/workflows/catalog.md`
- `core/workflows/operational-calibration.md`
- `core/workflows/self-evolution.md`
- `core/workflows/maturity-control.md`
- `core/closure/authority-boundary.md`
- `core/runtime-packets/qa-proof-stack.md`
- `adapters/workflow/zai-adapter.md` (docs/TASKS.md + worklog.md)
- `adapters/runtime/zai-adapter.md` (bun, agent-browser)
- `adapters/enforcement/zai-enforcement.md` (3-layer enforcement)
- onboarding docs and recommendations

## What Pre-Agents Does Not Require Yet

- specialized `*.toml` agents (Z.ai uses 5 subagentes via Task tool instead)
- full rehome of all imported doctrine
- full adapter implementation breadth
- full overlay cleanup

## Z.ai Platform Note

The Z.ai platform is currently in the pre-agents phase. This means:

- Subagent delegation is available via the Task tool with 5 fixed types
- No custom agent promotion mechanism exists (the human decides to create/update skills)
- Enforcement is soft (skill description + payload.message + worklog reference)
- The 5 available subagent types are sufficient for current needs:
  - `full-stack-developer` — implementation
  - `Plan` — governance and decomposition
  - `frontend-styling-expert` — frontend review
  - `Explore` — verification and exploration
  - `general-purpose` — research and multi-step tasks

This baseline document is directly applicable — the platform is already where
accelerate expected to be before agent-factory work.

## Next Phase After Pre-Agents

Once this baseline is stable, the next major phase is:

1. rehome more doctrine from `references/` into native layers
2. normalize the default distribution as explicit profile + adapters
3. evolve inherited doctrine into the native subagent model
4. validate enforcement through real delivery cycles
