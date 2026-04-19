---
name: subagent-driven-development
description: >
  Task dispatch and multi-stage review framework for delegating implementation work to Z.ai
  subagents via the Task tool. Use whenever a non-trivial engineering task benefits from bounded
  delegation: dispatch fresh subagents per task (full-stack-developer for implementation, Plan for
  architecture review, frontend-styling-expert for visual QA, Explore for evidence gathering), run
  two-stage review (spec compliance then code quality), and enforce strict status handling
  (DONE/DONE_WITH_CONCERNS/NEEDS_CONTEXT/BLOCKED). Prevents scope drift, ensures independent
  verification, and catches integration issues before closure.
metadata:
  category: delegation
  origin: adapted-for-zai
  version: 1.0.0
---
# Subagent-Driven Development

Dispatch bounded work to Z.ai subagents via the Task tool, then verify
the output through a mandatory two-stage review pipeline before accepting.

This skill governs HOW work is delegated and HOW results are verified. It
does not replace classification or branch selection — those remain the
orchestrator's responsibility.

## Core Concept

Every dispatched task gets a **fresh subagent** with an explicit prompt. The
subagent executes in isolation, then the master reviews the result through
two stages before integration. This prevents context contamination, ensures
independent verification, and catches issues that a single-threaded approach
would miss.

### Why Fresh Subagents?

A subagent that has been running for a long conversation accumulates context
that biases its review of its own work. Fresh dispatch means:

- no shared context contamination between tasks
- no anchoring on earlier decisions that might have been wrong
- the reviewing agent has no pride investment in the implementation choices
- the prompt can be tuned per task without carrying over stale instructions

### Z.ai Subagent Types

The Z.ai Task tool supports exactly 5 subagent types. Map tasks to the right one:

| Subagent Type | Best For | Avoid For |
|---|---|---|
| `full-stack-developer` | Bounded implementation slices, API routes, DB schemas, component creation | Architecture decisions, cross-slice review |
| `Plan` | Architecture review, complex analysis, multi-step planning, decomposition | Code implementation, visual QA |
| `frontend-styling-expert` | UI/UX refinement, CSS/Tailwind polish, visual QA, accessibility review | Backend logic, API design |
| `Explore` | Codebase exploration, evidence gathering, verification, search tasks | Implementation work |
| `general-purpose` | Cross-cutting tasks, research, documentation, multi-domain work | Bounded implementation slices |

**All subagents use the same underlying model.** There is no model selection or
cost tuning. The tradeoff is simplicity vs specialization — the right subagent
type matters because the system prompt shapes the agent's behavior, not because
a different model is loaded.

## Task Dispatch Protocol

### Step 1: Define the Bounded Task

Before dispatching, write down:

```
Task: <one-sentence description>
Scope: <files, surfaces, or domains affected>
Input: <what the subagent needs to know>
Output: <what the subagent must return>
Constraints: <explicit limits on scope or approach>
```

### Step 2: Select Subagent Type

Match the task to the subagent type table above. When in doubt:

- If the task produces code → `full-stack-developer`
- If the task evaluates architecture → `Plan`
- If the task evaluates visuals → `frontend-styling-expert`
- If the task gathers information → `Explore`

### Step 3: Write the Dispatch Prompt

The prompt must be self-contained. The subagent starts fresh with no context
from the master's conversation. Include:

```markdown
<task description with clear acceptance criteria>

## Context
- Spec/doc reference: docs/helm/specs/<relevant-spec>.md
- Plan reference: docs/helm/plans/<relevant-plan>.md (if exists)
- Existing code: <key files the subagent should read>

## Scope
- Files to modify: <list>
- Files to create: <list>
- Files to read-only: <list>

## Constraints
- Do NOT touch: <out-of-scope files>
- Use: <specific patterns, libraries, conventions>
- Verify with: bun run lint

## Return Format
When complete, report:
1. Files changed (with brief diff summary)
2. Verification results (bun run lint output)
3. Any deviations from the spec
4. Unresolved concerns
```

### Step 4: Dispatch via Task Tool

```
Task(
  type="<subagent-type>",
  prompt="<self-contained prompt from Step 3>"
)
```

### Step 5: Review the Result

See the Two-Stage Review section below.

## Two-Stage Review

Every subagent result MUST pass through both stages before integration.

### Stage 1: Spec Compliance Review

Dispatch a review subagent (typically `Plan` or `Explore`) with:

```markdown
Review the following implementation against the spec.

## Spec Requirements
<extract relevant requirements from docs/helm/specs/ or the task description>

## Implementation Changes
<paste or reference the subagent's output>

## Review Checklist
1. Does the implementation satisfy every spec requirement?
2. Are there missing edge cases?
3. Does the output match the expected data format?
4. Are error states handled?
5. Is the scope within the defined boundaries?
```

**Stage 1 result:** PASS, PASS_WITH_NOTES, or FAIL.

### Stage 2: Code Quality Review

Dispatch a quality review subagent (typically `full-stack-developer` or
`frontend-styling-expert` depending on the domain):

```markdown
Review the following code changes for quality.

## Files Changed
<list of files with changes>

## Review Checklist
1. TypeScript types are correct and specific (no `any` escaping)
2. No unused imports or dead code
3. Error handling follows project conventions
4. Component structure follows Next.js 16 App Router patterns
5. Tailwind classes follow the project's design system
6. Prisma queries are efficient and correct
7. API routes follow REST conventions and return proper status codes
8. Accessibility basics are covered (labels, aria attributes)
9. No hardcoded values that should be configurable
10. Console.log statements removed for production code

Run `bun run lint` and report the result.
```

**Stage 2 result:** PASS, PASS_WITH_NOTES, or FAIL.

### Handling Review Outcomes

| Outcome | Action |
|---|---|
| Stage 1: PASS, Stage 2: PASS | Integrate and proceed |
| Stage 1: PASS_WITH_NOTES | Fix noted issues, re-verify, integrate |
| Stage 1: FAIL | Do NOT integrate. Redesign or re-dispatch with corrected prompt |
| Stage 2: PASS_WITH_NOTES | Fix quality issues, re-run lint, integrate |
| Stage 2: FAIL | Do NOT integrate. Re-dispatch with quality constraints |

## Status Handling

Every dispatched task must resolve to one of these statuses:

### DONE
All acceptance criteria met. Both review stages passed. The result is safe to integrate.

### DONE_WITH_CONCERNS
The task is functionally complete but there are non-blocking concerns that should be
tracked. Example: the implementation works but uses a suboptimal pattern that should
be refactored later.

**Format:**
```
DONE_WITH_CONCERNS:
- [concern 1]: [why it's acceptable now, what to do later]
- [concern 2]: [why it's acceptable now, what to do later]
```

### NEEDS_CONTEXT
The subagent cannot complete because it's missing critical information that only the
master or the user can provide.

**Format:**
```
NEEDS_CONTEXT:
- [question 1]
- [question 2]
```

The master must answer the questions and re-dispatch. Do NOT guess or fill in
context on behalf of the subagent.

### BLOCKED
The subagent cannot proceed because of a dependency or conflict that prevents progress.

**Format:**
```
BLOCKED:
- [blocker]: [what needs to happen to unblock]
```

Common blockers:
- Merge conflicts with concurrent changes
- Missing dependencies or configuration
- Spec contradictions
- Platform limitations

## Anti-Patterns

### Context Dumping
Do NOT paste the entire conversation history into the dispatch prompt. The subagent
starts fresh — give it what it needs, not everything that happened before.

### Scope Creep by Proxy
If the subagent starts doing work outside the defined scope, the review stages will
catch it. But it wastes tokens and time. Be explicit about boundaries.

### Trusting Without Review
NEVER accept a subagent's self-assessment at face value. Even a well-intentioned
subagent can miss issues in its own work. The two-stage review exists because
verification must be independent.

### Sequential Review on Parallel Work
If you dispatch 2-3 subagents in parallel, review them in parallel too. Do not
serialize the reviews unless there are cross-slice dependencies.

## Example Workflow

### Task: Add a user profile settings page

**1. Master classifies and plans:**
"This is a product-critical user surface task. I'll dispatch a `full-stack-developer`
subagent for the implementation slice, then run both review stages."

**2. Master dispatches:**
```
Task(
  type="full-stack-developer",
  prompt="Create a user profile settings page at /settings/profile.

  ## Context
  - Read the existing layout: src/app/(dashboard)/layout.tsx
  - Follow the component patterns in src/components/ui/
  - Use shadcn/ui components from the existing set
  - Reference the user model in prisma/schema.prisma

  ## Scope
  - Create: src/app/(dashboard)/settings/profile/page.tsx
  - Create: src/components/settings/profile-form.tsx
  - Read-only: prisma/schema.prisma, src/lib/auth.ts
  - Do NOT touch: auth configuration, other settings pages

  ## Requirements
  - Form fields: display name, bio (textarea), avatar URL
  - Submit button that calls PUT /api/user/profile
  - Server action or API route for the update
  - Toast notification on success/error
  - Loading state during submission
  - Accessible form labels and error messages

  ## Constraints
  - Use bun for all commands
  - Run bun run lint before returning
  - No `any` types

  ## Return Format
  1. Files created/modified with brief descriptions
  2. bun run lint output
  3. Any deviations from requirements
  4. Unresolved concerns"
)
```

**3. Subagent returns DONE with changes listed.**

**4. Master runs Stage 1 review (Plan subagent):**
```
Task(
  type="Plan",
  prompt="Review this implementation against the requirements.

  ## Requirements
  - User profile settings page at /settings/profile
  - Form fields: display name, bio, avatar URL
  - PUT /api/user/profile endpoint
  - Toast notifications, loading state, accessibility

  ## Implementation
  [subagent output pasted]

  Evaluate: completeness, edge cases, error handling, scope compliance."
)
```

**5. Master runs Stage 2 review (frontend-styling-expert):**
```
Task(
  type="frontend-styling-expert",
  prompt="Review the code quality of these new settings page files.

  ## Files
  - src/app/(dashboard)/settings/profile/page.tsx
  - src/components/settings/profile-form.tsx
  - (any API route created)

  Check: TypeScript correctness, shadcn/ui patterns, accessibility,
  Tailwind usage, no dead code, proper error handling."
)
```

**6. Master integrates if both stages pass, or fixes and re-dispatches if not.**

## Integration Protocol

After both review stages pass:

1. Verify `bun run lint` passes on the combined codebase
2. Check for conflicts with any concurrent work
3. Verify the feature works via `agent-browser` (navigate to the page, interact)
4. Update relevant spec/plan docs with completion status
5. Report final status to the user

## Relationship to Helm

This skill is a **delegation tool** used BY helm, not a replacement for it.

- `helm` decides WHETHER to delegate and WHAT to delegate
- `subagent-driven-development` governs HOW to dispatch and verify
- The orchestrator (master agent) remains responsible for global correctness

When `helm` classifies a task as non-trivial and determines delegation creates
honest value, invoke this skill to execute the dispatch-review-integrate cycle.
