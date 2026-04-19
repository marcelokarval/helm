# Cron Governance — Z.ai

## Purpose

This module governs how cron jobs are configured in Z.ai projects that use helm.

It exists because the default system prompt for `webDevReview` crons includes
dangerous autonomous instructions that contradict helm discipline.

## The Problem

The default `webDevReview` payload template includes instructions like:

> "Prioritize fixing bugs or propose new requirements"
> "Continue development autonomously"

These instructions create two critical risks:

### Risk 1: Uncontrolled Feature Invention

"Propose new requirements" gives the cron agent permission to INVENT work that
was never requested, reviewed, or approved by the human operator.

Consequences:
- features that don't align with the project vision
- scope creep without human oversight
- git history polluted with unsolicited commits
- potential conflicts with planned work in `docs/TASKS.md`

### Risk 2: Ungrounded Autonomous Execution

"Continue development autonomously" without anchoring to a defined task list
means the agent decides what to work on based on its own interpretation — not
on what the human actually wants.

Consequences:
- the agent may "improve" things that don't need improvement
- cosmetic churn (padding 4→6→8→4 in an infinite loop)
- breaking changes introduced without review
- wasted compute on work that gets reverted

## The Rule

> **A cron MUST NEVER create, propose, or invent requirements.**
> **A cron MUST NEVER decide what to work on without an explicit task source.**
> **A cron MUST stop when there is no grounded work to perform.**

The ONLY valid sources of work for a cron are:

1. `docs/TASKS.md` — the human-approved task list
2. An explicit instruction in `payload.message` for a single bounded task
3. A bug or regression discovered during REVIEW of existing code (not invention)

## webDevReview: Correct Usage

`webDevReview` is a payload kind that includes `agent-browser` for visual
testing. It is NOT an orchestrator, NOT a product manager, and NOT a feature
designer.

### What webDevReview MAY do:

- Read `docs/TASKS.md` and execute the next pending task
- Test existing functionality via `agent-browser`
- Fix bugs found during testing
- Fix regressions found during QA
- Update `worklog.md` with findings
- Commit fixes with descriptive messages

### What webDevReview MUST NOT do:

- Propose new features or requirements
- Invent tasks that don't exist in `docs/TASKS.md`
- Make architectural decisions without human approval
- "Improve" things that aren't broken
- Refactor without an explicit task
- Add dependencies without approval
- Change project structure without a task
- Continue working after all tasks are done
- Skip testing to move faster

### When webDevReview finds no pending tasks:

```
If docs/TASKS.md has no ⏳ tasks:
  → Log status in worklog.md
  → Stop. Do not invent work.
  → Do not "explore improvements"
  → Do not "refine existing features"
  → Simply stop.
```

## Recommended payload.message Templates

### Template 1: Task-Driven Execution (Safe)

Use when `docs/TASKS.md` exists and has pending tasks:

```
Read skills/helm/SKILL.md and follow helm discipline.

Execute the NEXT pending task from docs/TASKS.md:
1. Read docs/TASKS.md — find the first task with status ⏳
2. Verify all dependencies are ✅ (if not, mark ⛔ and stop)
3. Read docs/SDD.md for design context
4. Execute following acceptance criteria
5. Test with bun run lint + agent-browser visual QA
6. Commit with descriptive conventional commit message
7. Mark task ✅ in docs/TASKS.md
8. Append work record to worklog.md

STOP CONDITIONS (mandatory):
- All tasks are ✅ → stop, do not invent more
- Task blocked by dependency → log in worklog, stop
- Unresolvable error → log in worklog, stop
- Lint fails after 2 attempts → log in worklog, stop

NEVER:
- Invent new tasks or features
- Modify completed (✅) tasks
- Skip testing to move faster
- Make architectural changes without a task
- Continue after all tasks are done
```

### Template 2: Review-Only Mode (Safest)

Use when you want QA without new implementation:

```
Read skills/helm/SKILL.md and follow helm discipline.

REVIEW-ONLY MODE — do not implement new features.

1. Read worklog.md for context
2. Run bun run lint — fix any errors found
3. Use agent-browser to test all active pages and flows
4. Check for console errors, broken layouts, or regressions
5. If bugs are found:
   - Fix the bug
   - Test the fix
   - Commit with: fix: <description>
   - Log in worklog.md
6. If no bugs found:
   - Log "QA pass, no issues found" in worklog.md
   - STOP — do not look for improvements

NEVER:
- Propose new features or requirements
- Implement features not in docs/TASKS.md
- Make cosmetic changes without a bug to fix
- Refactor without a task
- Continue working after QA is complete
```

### Template 3: Single-Task Bounded (Explicit)

Use for one specific task, no task list needed:

```
Read skills/helm/SKILL.md and follow helm discipline.

Execute THIS task only:
<TASK_DESCRIPTION>

Acceptance criteria:
- <CRITERION_1>
- <CRITERION_2>

After completion:
1. Test with bun run lint
2. Test visually with agent-browser
3. Commit
4. Log in worklog.md
5. STOP — this was the only task assigned
```

## agentTurn vs webDevReview

| Aspect | agentTurn | webDevReview |
|---|---|---|
| agent-browser access | No | Yes |
| Best for | Backend, API, logic, docs | Full-stack with visual QA |
| Risk level | Lower (no browser = less surface) | Higher (more tools = more power) |
| Governance needed | Standard | Strict (more tools = stricter rules) |

Both payload kinds share the SAME governance rules:
- No feature invention
- No task invention
- Stop when work is done
- Log everything in worklog.md

## The "No Task, No Work" Contract

This is the foundational contract between human and cron:

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│  HUMAN defines:        CRON executes:                │
│                                                      │
│  • docs/TASKS.md       • Next ⏳ task only           │
│  • docs/SDD.md         • Per SDD design              │
│  • Acceptance crit.    • Per acceptance criteria      │
│  • Priority order      • In priority order           │
│                                                      │
│  HUMAN decides:        CRON must NOT decide:         │
│                                                      │
│  • What to build       • What features to add        │
│  • What to fix         • What to "improve"           │
│  • What to prioritize  • What to refactor            │
│  • When to stop        • When to keep going          │
│                                                      │
└──────────────────────────────────────────────────────┘
```

## Anti-Patterns

### Anti-Pattern: "Autonomous Improvement"

```
❌ payload.message: "Improve the application continuously"
   → Agent invents work forever
   → No alignment with project goals
   → Infinite churn

✅ payload.message: "Execute next task from docs/TASKS.md"
   → Grounded in human-approved work
   → Predictable scope
   → Stops when done
```

### Anti-Pattern: "Fix or Propose"

```
❌ payload.message: "Fix bugs or propose new features"
   → "Propose" is a trap — the agent will propose
   → Proposals become implementations without approval
   → Scope creep

✅ payload.message: "Fix bugs found during QA of existing features"
   → No proposals, only fixes
   → Bounded by existing functionality
   → Stops when no bugs found
```

### Anti-Pattern: "Keep Going"

```
❌ payload.message: "Continue development autonomously"
   → No defined stopping point
   → Agent works until timeout
   → Waste of resources

✅ payload.message: "Execute Task 005 from docs/TASKS.md, then stop"
   → One task, clear scope
   → Natural stopping point
   → Efficient resource use
```

## Integration with helm Enforcement

When helm is installed, the cron governance integrates with the 3-layer
enforcement model:

1. **Layer 1 (Skill Description):** The SKILL.md description mentions
   classification and branch routing — the cron must follow these same rules
2. **Layer 2 (payload.message):** This is where the governance lives.
   The payload.message MUST include explicit constraints
3. **Layer 3 (worklog.md):** The cron logs its work. The next session
   reads this log. If the cron invented work, the log exposes it

The cron payload.message is the GOVERNANCE DOCUMENT for that specific job.
It must be treated with the same care as a PRD or SDD.

## Quick Reference

```
┌──────────────────────────────────────────────────────────┐
│                 CRON GOVERNANCE CHEAT SHEET               │
│                                                          │
│  ✅ ALWAYS:                                              │
│     • Anchor to docs/TASKS.md                            │
│     • Include stop conditions                            │
│     • Include "NEVER invent tasks"                       │
│     • Log to worklog.md                                  │
│     • Test before committing                             │
│                                                          │
│  ❌ NEVER:                                               │
│     • "Propose new requirements"                         │
│     • "Continue autonomously"                            │
│     • "Improve the application"                          │
│     • Work without a defined task                        │
│     • Skip testing                                       │
│     • Continue after tasks are done                      │
│                                                          │
│  ⚠️  IF NO TASKS PENDING:                                │
│     → Log status                                         │
│     → STOP                                               │
│     → Do NOT explore, improve, or refine                 │
│                                                          │
└──────────────────────────────────────────────────────────┘
```
