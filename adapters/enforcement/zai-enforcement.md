# Z.ai Enforcement Adapter

## Problem
The original accelerate assumes "always-on root skill" — the SKILL.md is loaded
in every session. The Z.ai platform does NOT have this mechanism — skills are
loaded on-demand via the Skill tool.

## Solution: 3-Layer Enforcement

### Layer 1 — Skill Description (passive inference)
The `description` field in the SKILL.md frontmatter is injected into the
`<available_skills>` list that the agent sees. If the description is strong
enough and matches the engineering context, the agent will INFER that helm
is relevant and invoke it.

**Triggers for inference:**
- The request involves code implementation, feature development, or bug fixing
- The request mentions "engineering", "development", "implementation", "refactor"
- The request is non-trivial (multi-file, cross-surface, architectural)
- A cron job's payload.message explicitly references helm

**Limitations:**
- The agent MAY choose not to invoke helm — there is no hard gate
- Conversational requests will not trigger inference
- The agent's model version affects inference quality

### Layer 2 — payload.message (active for cron jobs)
When creating cron jobs (agentTurn or webDevReview), include explicit
instructions in the `payload.message`:

```
"Before any work, read skills/helm/SKILL.md and follow the helm discipline:
1. Classify the request (trivial vs non-trivial)
2. Open the correct branch
3. Follow proof stack in order
4. Do not claim 'Done' without forensic closure"
```

This is the STRONGEST enforcement layer because it is an explicit instruction
that the agent must follow.

### Layer 3 — worklog.md Reference (active between sessions)
Include a helm reference in the worklog.md:

```
## Project Notes
This project uses helm as the orchestration discipline.
Before any engineering work, read skills/helm/SKILL.md and follow the
classification contract, branch selection, and proof order.
```

Since the agent reads worklog.md at the start of each session, this serves
as a persistent reminder across sessions.

## What This Means
- Enforcement in Z.ai is SOFT, not hard
- The agent CAN ignore helm — there is no technical gate
- Mitigation: strong description + explicit payload.message + worklog reference
- The human operator is the final enforcement mechanism
- When enforcement matters most (cron jobs), use Layer 2 explicitly

## Comparison with Original accelerate

| Aspect | accelerate (Claude) | helm (Z.ai) |
|---|---|---|
| Default behavior | SKILL.md always loaded | SKILL.md loaded on demand |
| Enforcement strength | Hard (always present) | Soft (inferred or instructed) |
| Bypass possible | No (always-on) | Yes (agent can ignore) |
| Mitigation | Not needed | 3-layer enforcement |
| Human role | Optional oversight | Mandatory for enforcement |
