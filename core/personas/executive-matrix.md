# Executive Persona Matrix

This document is the native executive matrix for:

- persona
- mandatory skills
- typical trigger
- expected output packet

It is not optional garnish. When persona catalogs, mandatory skills, workflow
catalogs, or review architecture change, this matrix should be reviewed in the
same mutation package or the defer reason should be explicit.

## Matrix

| Persona | Mandatory skills | Typical trigger | Expected output |
|---|---|---|---|
| `Specification PM` | `prompt-hardening`, `prop4you-frontend-architecture` | actor/goal ambiguity, weak request framing | `Specification Handoff Packet` |
| `Product Planner` | docs/TASKS.md + worklog.md or planning surface | scope split, rollout shape, slices | `Planning Handoff Packet` |
| `Implementation Designer` | `napkin-discipline`, `full-stack-developer` subagent when accepted | execution design | `Implementation Design Packet` |
| `Implementer / Developer` | active layer stack skills | bounded implementation | `Implementation Handoff Packet` |
| `Backend Implementer` | active backend stack skills | backend-heavy mutation | backend implementation packet |
| `Frontend Implementer` | active frontend stack skills | frontend-heavy mutation | frontend implementation packet |
| `Runtime/Product Reviewer` | `product-runtime-review` | user-facing runtime-sensitive flow | `Runtime Review Packet` |
| `Governance Auditor` | `prop4you-stack-constitution`, `prop4you-frontend-architecture` or relevant contract skills | governance / truth doubt | `Governance Packet` |
| `Data / Contract Steward` | contract / schema / validation governance skills relevant to the branch | DTO, persistence, identifier, or contract truth doubt | contract packet |
| `Provider Boundary Auditor` | provider / boundary governance skills relevant to the branch | external integration or upstream/downstream seam doubt | provider/runtime packet |
| `Closure / Forensic Reviewer` | `verification-before-completion` | pre-close reconciliation | `Closure Packet` |
| `Master Integrator` | active stack as needed | multi-surface integration authority | `Master Revalidation Checklist` |

## Backend Modeling Review Profile

For backend modeling review, the default posture is:

- blocking personas:
  - `Data / Contract Steward`
  - `Closure / Forensic Reviewer`
- conditional personas:
  - `Provider Boundary Auditor`
  - `Governance Auditor`

Expected output should include:

- findings ordered by severity
- explicit evidence surfaces inspected
- a relation map or UML when multiple persisted models interact
- a compact table of key fields and relations
- a side-by-side reconciliation of doctrine vs persistence vs runtime use

## Z.ai Adaptation Notes

In the Z.ai platform, mandatory skills map to existing skills available via
the Skill tool. The following substitutions have been applied:

| accelerate Skill | Z.ai Equivalent | Method |
|---|---|---|
| `prompt-hardening` | `prompt-hardening` | Skill tool invocation (kept as-is) |
| `product-runtime-review` | `product-runtime-review` | Skill tool invocation (kept as-is) |
| `ascii-wireframe` | `ascii-wireframe` | Skill tool invocation (kept as-is) |
| `napkin-discipline` | `napkin-discipline` | Skill tool invocation (kept as-is) |
| `front-react-shadcn` | `front-react-shadcn` | Skill tool invocation (kept as-is) |
| `nextjs-best-practices` | `nextjs-best-practices` | Skill tool invocation (kept as-is) |
| `architecture` | `prop4you-frontend-architecture` | Skill tool invocation |
| `active workflow adapter` | `docs/TASKS.md + worklog.md` | File-based workflow |
| `planning-with-files` | `napkin-discipline` + Plan subagent | Skill + Task tool |
| `executing-plans` | `full-stack-developer` subagent | Task tool |

The "active workflow adapter" is replaced by the Z.ai-native workflow system:
`docs/TASKS.md` for issue tracking and `worklog.md` for activity logging.
