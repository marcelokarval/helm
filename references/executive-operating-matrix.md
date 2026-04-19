# Executive Operating Matrix

Use this module when the operator needs a single executive view of the full
`accelerate` system without opening every reference module individually.

## One-Page Matrix

```text
╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                                        ACCELERATE — EXECUTIVE OPERATING MATRIX                                            ║
╠══════════════════════╦══════════════════════╦══════════════════════╦══════════════════════╦══════════════════════╣
║ ENTRY / SHAPING      ║ ISSUE / PLANNING     ║ IMPLEMENTATION       ║ QA / PROOF           ║ CLOSURE              ║
╠══════════════════════╬══════════════════════╬══════════════════════╬══════════════════════╬══════════════════════╣
║ prompt-hardening skill     ║ Issue Architect /    ║ Implementation       ║ Backend Tester       ║ Closure / Forensic   ║
║ Prompt Hardening     ║ Workflow Adapter     ║ Designer             ║ Frontend Tester      ║ Reviewer             ║
║ Editor               ║ Plan subagent      ║ Wireframe / Design   ║ Browser-Proof        ║ Plan subagent   ║
║                      ║                      ║ Contract Extractor   ║ Auditor              ║ Stack Constitution   ║
║ Outputs:             ║ Outputs:             ║ Implementer /        ║ E2E Regression       ║ Auditor              ║
║ - Prompt A/B         ║ - issue bootstrap    ║ Developer            ║ Engineer             ║ Release / Handoff    ║
║ - actor/goal         ║ - hierarchy          ║ Backend Implementer  ║ QA outputs:          ║ Manager              ║
║ - non-goals          ║ - plan artifact      ║ Frontend Implementer ║ - agent-browser    ║ Master Integrator    ║
║                      ║                      ║ Outputs:             ║ - agent-browser         ║ Outputs:             ║
║                      ║                      ║ - impl packets       ║ - intensity labels   ║ - closure packet     ║
║                      ║                      ║ - runtime deltas     ║                      ║ - revalidation       ║
╠══════════════════════╩══════════════════════╩══════════════════════╩══════════════════════╩══════════════════════╣
║ ENFORCEMENT LENSES: IDOR | N+1 | anti-abuse | OWASP | race/save audit | service-layer-first | Inertia-first          ║
║ DRY/shared/compounds/enhanceds | source ladder | anti-div-soup | i18n | contract correctness | shared props governance ║
║ query ownership -> presenter ownership -> UI ownership | backend validation authority | named URLs | err() protocol     ║
╠══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╣
║ AGENT POSTURE: non-trivial -> use bounded subagent(s) when they create honest value; root-only remains legitimate       ║
║ SUBAGENT RULE: each subagent loads `accelerate` first, stays bounded, returns self-review + self-forensic review         ║
║ PROOF ORDER: implementation -> backend/frontend QA -> browser truth (agent-browser) -> persistent E2E (agent-browser)     ║
║ ISSUE ORDER: bootstrap -> docs/TASKS.md + worklog.md -> planning artifact -> execution -> worklog.md Stage Summary -> real closure   ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

## Reading Order

- persona details -> `references/persona-model.md`
- named workflows -> `references/workflow-catalog.md`
- QA/browser/E2E lanes -> `references/qa-proof-stack.md`
- issue lane -> `references/issue-stack.md`
- enforcement checklist -> `references/current-enforcement-surfaces.md`
- invocation families -> `references/full-invocation-map.md`
- packet shapes -> `references/runtime-packet-templates.md`
- packet cadence -> `references/runtime-observability-cadence.md`

## Purpose

This file is the executive summary artifact for humans deciding whether the
system is coherent enough to operate as the basis for future agents.
