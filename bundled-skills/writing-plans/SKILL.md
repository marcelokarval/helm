---
name: writing-plans
description: >
  Implementation planning skill that decomposes approved designs into bite-sized, executable tasks
  with exact file paths, complete code, and explicit verification steps. Enforces the "No Placeholders"
  rule — every task must contain full code, not descriptions. Tasks are sized for 2-5 minutes each,
  follow DRY and YAGNI principles, and include self-review checkpoints. Use after brainstorming
  design approval or whenever non-trivial implementation work needs decomposition before coding
  begins. Integrates with helm for subagent-driven execution via the Task tool.
metadata:
  category: implementation-planning
  origin: adapted-from-superpowers-writing-plans-for-zai
  version: 1.0.0
---

# Writing Plans

A disciplined implementation planning skill that turns approved designs into executable, bite-sized tasks with complete code and explicit verification.

This skill enforces that planning is a distinct phase from implementation. The plan is the bridge between design and code.

## When to Use

Activate this skill when:

- A brainstorming design doc has been approved and needs decomposition
- Non-trivial implementation work needs structured decomposition
- A feature spans multiple files, modules, or surfaces
- You need to hand off work to a `full-stack-developer` subagent via the Task tool

Do NOT activate for:

- Trivial changes that fit in a single file edit
- Work that has already been decomposed and planned
- When the user explicitly says "just implement it" on small work

## Core Principles

### 1. Bite-Sized Tasks

Every task should take **2-5 minutes** to implement. If a task would take longer, decompose it further.

Signs a task is too big:
- It says "implement the feature" instead of naming a specific change
- It touches more than 3 files
- It requires multiple logical steps with no intermediate verification
- Its description uses words like "and then" or "also"

### 2. Exact File Paths

Every task must specify exact file paths, not descriptions:

```
CORRECT:
  File: src/app/api/properties/route.ts
  Action: Add GET handler that queries properties with pagination

WRONG:
  File: the API route for properties
  Action: implement the endpoint
```

### 3. Complete Code (No Placeholders)

**This is the most important rule.** Every task must include the complete code to be written, not a description of what the code should do.

```
CORRECT:
  ```typescript
  import { NextRequest, NextResponse } from 'next/server';
  import { prisma } from '@/lib/prisma';

  export async function GET(request: NextRequest) {
    const { searchParams } = new URL(request.url);
    const page = parseInt(searchParams.get('page') ?? '1');
    const limit = parseInt(searchParams.get('limit') ?? '20');

    const [items, total] = await Promise.all([
      prisma.property.findMany({
        skip: (page - 1) * limit,
        take: limit,
        orderBy: { createdAt: 'desc' },
      }),
      prisma.property.count(),
    ]);

    return NextResponse.json({ items, total, page, limit });
  }
  ```

WRONG:
  Create a GET handler that fetches properties with pagination
  using Prisma. Support page and limit query params.
```

### 4. DRY — Don't Repeat Yourself

If a pattern is already established in the codebase, reference it rather than duplicating it. The plan should say "follow the same pattern as `src/app/api/leads/route.ts`" when applicable.

### 5. YAGNI — You Aren't Gonna Need It

Do not plan for hypothetical future features. Only plan what the approved design requires. If a design doc lists "out of scope" items, do not include them in the plan.

## Plan File Structure

### Location

All plans live under:

```
docs/helm/plans/<feature-name>.md
```

Use kebab-case for the feature name. Match the naming convention of the corresponding spec in `docs/helm/specs/`.

### Plan Template

```markdown
# Plan: [Feature Name]

**Status:** Draft | In Progress | Complete
**Created:** YYYY-MM-DD
**Updated:** YYYY-MM-DD
**Design doc:** docs/helm/specs/<feature-name>.md
**Branch:** [branch name if applicable]

## Summary

[1-3 sentence overview of what this plan implements]

## Tasks

### Task 1: [Descriptive task name]

**File:** `src/path/to/file.ts`
**Action:** [What this task does]
**Depends on:** [Task number or "none"]
**Estimated:** [2-5 min]

```[language]
// Complete code for this task
```

**Verification:**
- [ ] [Specific verification step]

---

### Task 2: [Descriptive task name]

**File:** `src/path/to/another-file.ts`
**Action:** [What this task does]
**Depends on:** [Task 1]
**Estimated:** [2-5 min]

```[language]
// Complete code for this task
```

**Verification:**
- [ ] [Specific verification step]

---

## Self-Review Checklist

Before marking this plan as "Complete", verify:

- [ ] Every task has complete code (no placeholders)
- [ ] Every task has exact file paths
- [ ] Every task has a verification step
- [ ] Dependencies between tasks are correct
- [ ] No task exceeds 5 minutes
- [ ] Plan covers the full design doc scope
- [ ] No YAGNI violations (no gold-plating)
```

## Task Structure

Every task MUST have:

| Field | Required | Description |
|---|---|---|
| **Task name** | Yes | Short, descriptive verb phrase |
| **File** | Yes | Exact file path (relative to project root) |
| **Action** | Yes | What this task accomplishes in one sentence |
| **Depends on** | Yes | Task number it depends on, or "none" |
| **Estimated** | Yes | Time estimate (must be 2-5 min) |
| **Code** | Yes | Complete, copy-pasteable code |
| **Verification** | Yes | Specific, testable verification step |

## Verification Steps

Every task must have at least one explicit verification step. Choose the strongest applicable verification:

| Type | When to use | Example |
|---|---|---|
| **Lint** | All code changes | `bun run lint` passes |
| **Type check** | TypeScript changes | `bun run lint` includes type checking |
| **Build** | After significant changes | `bun run build` succeeds |
| **Dev server** | UI and API changes | `bun run dev` starts without errors |
| **Browser test** | UI flows | Use `agent-browser` to verify page renders |
| **API test** | Backend endpoints | `curl` or `agent-browser` to verify response |
| **Database** | Schema changes | `bun run db:push` succeeds |
| **Manual review** | Last resort | Code review shows no obvious issues |

Prefer automated verification (`bun run lint`, `bun run build`) over manual review. Use `agent-browser` for visual verification of UI changes.

## Dependency Management

Tasks should form a dependency graph that allows for maximum parallelism:

- Tasks with **no dependencies** can run in parallel
- Tasks with **dependencies** must wait for their prerequisites
- The dependency graph should be acyclic (no circular dependencies)

Example:

```
Task 1: Create database schema (no deps)
Task 2: Create API route handler (depends on Task 1)
Task 3: Create UI component (no deps — can parallel with Task 1)
Task 4: Wire UI to API (depends on Tasks 2 and 3)
Task 5: Add error handling (depends on Task 2)
```

## Self-Review Process

Before marking the plan as ready for execution, run this checklist:

### Completeness
- [ ] Every design doc requirement has a corresponding task
- [ ] Every task has complete code
- [ ] No "TODO" or "implement this" placeholders
- [ ] File paths are accurate and specific

### Correctness
- [ ] Code follows existing project patterns
- [ ] Import paths are correct
- [ ] Types and interfaces are consistent with the data model
- [ ] No conflicting changes between tasks

### Proportionality
- [ ] No task exceeds 5 minutes
- [ ] No unnecessary tasks (YAGNI)
- [ ] No duplicate work between tasks
- [ ] Verification steps are specific and testable

### Execution Readiness
- [ ] Dependency order allows parallel execution where possible
- [ ] A subagent could execute tasks sequentially without ambiguity
- [ ] The plan could survive a session boundary (another agent could pick it up)

## Execution Handoff

### Subagent-Driven Execution

When the plan is ready and helm delegates implementation:

```
Handing off to full-stack-developer subagent via Task tool.
Plan: docs/helm/plans/<feature-name>.md
Execute tasks sequentially. Do not skip any task. Do not modify
the plan — only execute.
```

The subagent should:

1. Read the plan file
2. Execute tasks in dependency order
3. Run verification steps after each task
4. Report back with: files changed, tests passed, issues encountered

### Inline Execution

When the plan is small or subagent delegation is not warranted:

1. Execute tasks sequentially in the current session
2. Run verification after each task
3. Update the plan status as tasks complete

### Task Status Tracking

After each task, update the task in the plan:

```
### Task 1: [Name] ✅

**Status:** Completed
**Completed:** YYYY-MM-DD
**Verified:** [what verification passed]
```

## No Placeholders Rule (Expanded)

The following are ALL considered placeholders and are FORBIDDEN in plan tasks:

- `// TODO: implement this`
- `// Add your code here`
- `/* implementation left as exercise */`
- `// similar to existing code`
- Any description that says "create a function that..." instead of showing the function
- Any code block that has `...` in place of actual code
- Any task that says "implement X" without providing the implementation

The ONLY exception: if the task is genuinely about creating a new file from a template that does not yet exist, describe the full structure in pseudocode that is specific enough to implement without ambiguity.

## Relationship to Other Skills

| Skill | Relationship |
|---|---|
| `brainstorming` | writing-plans consumes brainstorming design docs as input |
| `helm` | writing-plans operates within helm's planning-artifact workflow |
| `napkin` | writing-plans should check the napkin for project conventions |
| `prompt-hardening` | writing-plans may need hardening if the plan request is ambiguous |
| `fullstack-dev` | subagent execution of plans uses fullstack-dev patterns |

## Integration with Helm

When writing-plans is invoked within a helm-governed run:

- The approved design doc from brainstorming (or equivalent) is the input
- The plan file goes to `docs/helm/plans/`
- Execution follows helm's implementation workflow
- Verification aligns with helm's proof stack (`bun run lint`, `agent-browser`, etc.)
- Closure feeds back into helm's forensic-closure workflow

## Plan Location

All implementation plans live under:

```
docs/helm/plans/
```

This is the canonical location. When helm references plans, it should look here.
