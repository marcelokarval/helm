# Quick Invocation Map

## Purpose

This is the native operator quick map for answering fast:

- what branch is active
- what proof is missing
- what review still blocks closure
- what workflow family is running

Use this before opening deeper modules when the goal is orientation, not full
study.

> **Z.ai Note:** No Z.ai, este mapa é consultado pelo master agent após a classificação
> da request. Subagentes recebem as instruções relevantes via prompt no Task tool.

## Minimal Flow

```text
User Request
  -> classify
     -> conversational / no-op
     -> trivial bounded
     -> ambiguous / prompt hardening
     -> non-trivial engineering
          -> branch select
          -> issue / planning / execution / proof / closure
```

## Active Branch Families

- issue-driven delivery
- bug / failure / regression
- architecture / governance doubt
- backend implementation
- frontend implementation
- full-stack delivery
- product-critical surface
- visual / artifact-driven frontend
- query / contract-sensitive backend
- browser-proof audit
- persistent regression authoring (via agent-browser)
- adversarial / hostile-path review
- observability / performance / N+1
- transport / dependency / legacy doubt
- benchmark rerun / result registration

## Workflow Families

Use the named workflow catalog for exact sequencing, but the common families
are:

- entry shaping
- issue bootstrap
- planning artifact
- implementation handoff
- backend QA
- frontend QA
- browser proof
- persistent regression
- governance / contract review
- benchmark rerun / result registration
- closure / forensic review

## Fast Reading Order

1. `branch-enforcement-matrix.md`
2. `../issue-topology/issue-driven-mutation-stack.md`
3. `../runtime-packets/qa-proof-stack.md`
4. `../review/product-critical-surfaces.md`
5. `../workflows/catalog.md`
6. `../delegation/subagent-model.md`

## Quick Questions

Before starting a non-trivial run, answer:

1. what branch is active?
2. what mandatory skills are in force?
3. is issue bootstrap already satisfied (docs/TASKS.md entry)?
4. is the planning artifact already satisfied?
5. what proof lane is next?
6. what review still blocks closure?
7. should this be delegated to a subagent (full-stack-developer, Plan, Explore)?
