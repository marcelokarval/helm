# Control Plane

This layer is the native home of helm's root orchestration law,
including classification, branch discipline, quick invocation, and workflow
mutation approval.

The control plane also depends on native:

- `../personas/`
- `../review/`
- `../workflows/`

Native authority now starts here:

- `branch-enforcement-matrix.md`
- `quick-invocation-map.md`

Root-facing architectural context still lives in:

- `SKILL.md`
- `README.md`
- `docs/architecture/control-plane.md`

> **Z.ai Note:** No accelerate original, este módulo também continha `root-laws.md`,
> `workflow-change-approval-gate.md` e `parity-replacement-gate.md`. No helm (Z.ai),
> `root-laws.md` está incorporado no SKILL.md, e os gates de approval são aplicados
> via payload.message em crons e instruções explícitas ao master agent.
