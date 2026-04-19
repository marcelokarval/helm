# Persona Model

This document is the native core home of explicit skill activation via
description.

Use it when the active posture of the orchestrator matters more than the raw
phase list.

## Role Catalog

The core personas are:

- `Specification PM`
- `Product Planner`
- `Implementation Designer`
- `Implementer / Developer`
- `Delivery PM`
- `Runtime/Product Reviewer`
- `Governance Auditor`
- `Closure / Forensic Reviewer`
- `Master Integrator`

### Specialist Personas

These do not need to be active on every run, but the control plane should be
able to activate them explicitly when the branch demands it:

- `Prompt Hardening Editor`
- `Issue Architect / Workflow Adapter`
- `Backend Implementer`
- `Frontend Implementer`
- `Backend Tester`
- `Frontend Tester`
- `Browser-Proof Auditor`
- `E2E Regression Engineer`
- `Security Reviewer`
- `Anti-Abuse Reviewer`
- `Accessibility Reviewer`
- `Performance / Observability Reviewer`
- `Data / Contract Steward`
- `Provider Boundary Auditor`
- `Stack Constitution Auditor`
- `Legacy Truth Analyst`
- `Migration Steward`
- `Release / Handoff Manager`

## Activation Signals

Typical activation signals:

- actor/goal/value ambiguity -> `Specification PM`
- capability/story/task ambiguity -> `Product Planner`
- slices or rollout ambiguity -> `Implementation Designer`
- bounded code mutation -> `Implementer / Developer`
- browser truth or UX drift -> `Runtime/Product Reviewer`
- stack, contract, or truth drift -> `Governance Auditor`
- contract-vocabulary or DTO/persistence truth drift -> `Data / Contract Steward`
- provider/runtime boundary doubt -> `Provider Boundary Auditor`
- nearing closure -> `Closure / Forensic Reviewer`
- any multi-surface integration point -> `Master Integrator`

## Advisory vs Blocking

Classify personas explicitly:

- always blocking:
  - `Master Integrator`
  - `Closure / Forensic Reviewer`
- conditional blocking:
  - `Specification PM`
  - `Product Planner`
  - `Implementer / Developer`
  - `Runtime/Product Reviewer`
  - `Governance Auditor`
  - `Data / Contract Steward`
  - `Provider Boundary Auditor`
- mostly advisory unless activated by risk:
  - `Implementation Designer`

If a persona is blocking for the current slice, do not bypass it with narrative
confidence.

## Backend Modeling Review Activation

When the task is a backend schema, model, ontology, or persistence review,
activate at least:

- `Data / Contract Steward`
- `Closure / Forensic Reviewer`

Add these when the branch demands them:

- `Provider Boundary Auditor`
  - when ownership seams or upstream/downstream boundaries are in doubt
- `Governance Auditor`
  - when doctrine, contract, and persisted truth are visibly drifting
- `Backend Implementer`
  - when the review is expected to mutate the model or query layer

This activation exists to prevent backend modeling review from collapsing into
generic commentary.

## Z.ai Adaptation Notes

In the Z.ai platform, persona activation works differently from the original
accelerate model:

- **Original:** persona activation was a named concept where Claude loaded a
  persona configuration.
- **helm:** persona activation is achieved via **skill invocation using the
  Skill tool**. Each persona maps to one or more skills that the Z.ai agent
  invokes as needed.

### Persona-to-Subagent Mapping

The concept of **agent role** is replaced by **subagent type** in Z.ai:
the master Z.ai agent selects which of the 5 subagent types to spawn via the
Task tool based on the persona required for the work.

| Persona | Z.ai Activation Method |
|---|---|
| `Specification PM` | `prompt-hardening` skill via Skill tool |
| `Product Planner` | `Plan` subagent via Task tool |
| `Implementation Designer` | `full-stack-developer` subagent via Task tool |
| `Implementer / Developer` | `full-stack-developer` subagent via Task tool |
| `Runtime/Product Reviewer` | `product-runtime-review` skill via Skill tool |
| `Governance Auditor` | `Plan` subagent via Task tool |
| `Closure / Forensic Reviewer` | `forensic-review` or `verification-before-completion` skill via Skill tool |
| `Master Integrator` | Master Z.ai agent (no delegation) |
| `Browser-Proof Auditor` | `agent-browser` for interactive validation |
