# Persona Mandatory Skills

This document is the native core home of persona-level mandatory-skill
exposure.

If a blocking persona is active, its mandatory skills should appear in the
runtime packet unless an explicit branch exception is recorded.

## Matrix

| Persona | Mandatory skills | Typical trigger |
|---|---|---|
| `Specification PM` | `prompt-hardening`, `prop4you-frontend-architecture` | framing, ambiguity, scope definition |
| `Prompt Hardening Editor` | `prompt-hardening` | weak prompt shape |
| `Product Planner` | docs/TASKS.md + worklog.md or planning surface | issue tree, rollout, slices |
| `Implementation Designer` | `napkin-discipline`, `full-stack-developer` subagent when accepted | execution design |
| `Implementer / Developer` | active layer stack skills | generic code mutation |
| `Backend Implementer` | active backend stack skills | backend mutation |
| `Frontend Implementer` | active frontend stack skills | frontend mutation |
| `Browser-Proof Auditor` | `product-runtime-review` + active stack skills as needed | browser truth |
| `Runtime/Product Reviewer` | `product-runtime-review` | runtime-sensitive user surface |
| `Governance Auditor` | `prop4you-stack-constitution`, `prop4you-frontend-architecture` or relevant contract skills | governance doubt |
| `Data / Contract Steward` | contract / schema / validation governance skills relevant to the branch | DTO, persistence, identifier, vocabulary, or contract truth doubt |
| `Provider Boundary Auditor` | provider / boundary governance skills relevant to the branch | external integration, ownership seam, or upstream/downstream ambiguity |
| `Closure / Forensic Reviewer` | `verification-before-completion` | pre-close forensic lane |

## Backend Modeling Review Envelope

For backend modeling review, the minimum mandatory set should normally be:

- `prop4you-frontend-architecture` (replaces `architecture`)
- active backend stack skills
- contract/schema governance skills relevant to the branch
- `verification-before-completion` when closure language is being used

When provider or ownership seams are part of the review, add a boundary-governor
skill explicitly rather than treating seam inspection as optional.

## Display Rule

The `active skills` line should reflect the blocking persona's mandatory set,
not only the operator's preferred minimum.

## Z.ai Adaptation Notes

In the Z.ai platform, skill invocation replaces Claude-specific persona loading.
The structure of persona → required skills mapping is preserved. Key changes:

- `Specification PM` persona maps to `prompt-hardening` skill invocation via the
  Skill tool
- `Product Planner` persona maps to the `Plan` subagent via the Task tool
- `Governance Auditor` persona maps to `Plan` subagent via the Task tool
- `active workflow adapter` is replaced by `docs/TASKS.md + worklog.md`
- The `architecture` skill is replaced by `prop4you-frontend-architecture`
- Skills that exist natively in Z.ai (`prompt-hardening`, `product-runtime-review`,
  `ascii-wireframe`, `napkin-discipline`, `front-react-shadcn`, `nextjs-best-practices`)
  are kept as-is and invoked via the Skill tool
