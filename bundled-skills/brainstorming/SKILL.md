---
name: brainstorming
description: >
  Structured design-thinking skill for non-trivial features and architectural decisions. Explores
  project context, asks clarifying questions, proposes multiple approaches with tradeoffs, presents
  design artifacts (ASCII wireframes via ascii-wireframe skill), writes a formal design doc, runs
  spec review, and transitions to the writing-plans skill for implementation. HARD GATE: no code
  is written before design is explicitly approved by the user. Use when the request involves new
  features, significant refactors, UI design, architectural changes, or anything that benefits
  from structured exploration before implementation.
metadata:
  category: design-planning
  origin: adapted-from-superpowers-brainstorming-for-zai
  version: 1.0.0
---

# Brainstorming

A structured design-thinking flow for exploring, designing, and specifying non-trivial work before any implementation begins.

This skill enforces a hard gate: **no code is written until the user explicitly approves the design**.

## When to Use

Activate this skill when the request involves:

- New features or significant user-facing changes
- Architectural decisions with multiple viable approaches
- UI/UX design that needs visual exploration
- Refactors that touch multiple modules or surfaces
- Any non-trivial work where jumping straight to code would be premature

Do NOT activate for:

- Trivial bug fixes with an obvious solution
- Small styling adjustments
- Documentation-only changes
- Questions that can be answered by reading existing code

## Flow Overview

```
1. Explore Context
   ↓
2. Ask Questions
   ↓
3. Propose Approaches
   ↓
4. Present Design
   ↓
5. Write Design Doc
   ↓
6. Spec Review
   ↓
7. Hand Off to writing-plans
```

## Phase 1: Explore Context

Before proposing anything, understand the project landscape:

1. Read `worklog.md` for current project state and history
2. Read `docs/helm/napkin.md` for project conventions and pitfalls
3. Examine relevant source files — understand existing patterns, component structure, data models
4. Check `docs/helm/specs/` for any existing related specs
5. Identify constraints: tech stack limitations, existing API contracts, UI framework boundaries

Output a brief context summary:

```
## Context Summary
- Current state: [what exists today]
- Relevant files: [key files examined]
- Existing patterns: [patterns discovered]
- Constraints: [hard limits identified]
```

## Phase 2: Ask Questions

Before proposing approaches, ask the user targeted questions to resolve ambiguity:

- **Scope**: What is in scope vs out of scope?
- **Users**: Who is the primary user of this feature?
- **Priority**: What matters most — speed, quality, maintainability, or flexibility?
- **Constraints**: Are there technical, business, or timeline constraints?
- **Existing behavior**: Should any existing behavior change?
- **Edge cases**: Are there specific edge cases to handle?

Keep questions focused. Do NOT ask 20 questions at once. Group into 3-5 essential questions and ask them all at once.

## Phase 3: Propose Approaches

Present 2-3 viable approaches. For each approach:

```
### Approach A: [Name]

**Strategy:** [1-2 sentence summary]

**Pros:**
- [advantage 1]
- [advantage 2]

**Cons:**
- [drawback 1]
- [drawback 2]

**Effort:** [rough estimate: small / medium / large]

**Risk:** [low / medium / high]
```

Do NOT present a single approach and call it brainstorming. The value is in the comparison.

Recommend one approach but let the user decide. If the user wants a hybrid or entirely different approach, adapt.

## Phase 4: Present Design

Once an approach is selected, present the design in detail.

### For UI work:

Use the `ascii-wireframe` skill via the Skill tool to generate wireframes:

```
Invoke the `ascii-wireframe` skill to create wireframes for:
- Page layout and component hierarchy
- State transitions (empty, loading, populated, error)
- Mobile vs desktop layouts (if responsive)
```

Include in the design presentation:

- Component tree with responsibilities
- Data flow (what props, what server data, what state)
- User interactions and navigation
- Edge case handling
- Accessibility considerations

### For backend / architectural work:

Present:

- Data model changes (Prisma schema diffs)
- API contract (endpoints, request/response shapes)
- Integration points
- Migration strategy if applicable
- Error handling approach

### For full-stack work:

Combine both. Present backend changes first, then show how the UI consumes them.

## Phase 5: Write Design Doc

After the user approves the design direction, write a formal design doc to `docs/helm/specs/`.

### File Naming

```
docs/helm/specs/<feature-name>.md
```

Use kebab-case for the feature name. If a spec already exists for this feature, update it rather than creating a new one.

### Design Doc Template

```markdown
# Design: [Feature Name]

**Status:** Draft | Approved | Implemented | Deprecated
**Created:** YYYY-MM-DD
**Updated:** YYYY-MM-DD
**Approach:** [A / B / C / Hybrid]

## Problem

[What problem does this solve? Why does it matter?]

## Scope

**In scope:**
- [included item 1]
- [included item 2]

**Out of scope:**
- [excluded item 1]

## Design

### Architecture
[High-level design description]

### Data Model
[Schema changes, new models, relationship changes]

### API
[Endpoint changes, new routes, request/response shapes]

### UI
[Component hierarchy, layouts, interactions — reference ascii-wireframe output]

### Edge Cases
[How errors, empty states, and boundary conditions are handled]

## Decisions

| Decision | Choice | Rationale |
|---|---|---|
| [what] | [chosen] | [why] |

## Open Questions

[Unresolved questions, if any]

## Transition to Implementation

[Reference to the writing-plans skill and any plan files]
```

## Phase 6: Spec Review

Before transitioning to implementation, run a quick spec review:

1. **Completeness** — Does the spec cover all the user's requirements?
2. **Consistency** — Does it align with existing patterns in the napkin?
3. **Feasibility** — Can this be built with the current tech stack?
4. **Edge cases** — Are failure modes and boundary conditions addressed?
5. **Non-goals** — Are out-of-scope items explicitly listed?

If issues are found, present them to the user and update the spec before proceeding.

## Phase 7: Hand Off to writing-plans

Once the design doc is approved, transition to the `writing-plans` skill:

```
The design for [feature] has been approved and documented at:
  docs/helm/specs/<feature-name>.md

Transitioning to the `writing-plans` skill to create an implementation plan.
```

The writing-plans skill will:

1. Read the approved design doc
2. Decompose the work into bite-sized tasks (2-5 min each)
3. Create a plan file at `docs/helm/plans/<feature-name>.md`
4. Proceed to implementation

## HARD GATE: No Implementation Before Approval

This is the non-negotiable rule of this skill:

> **DO NOT write implementation code before the user explicitly approves the design.**

If the user says "just build it" or "skip the design phase", you MAY offer a lightweight path:

1. Write a minimal design doc (Problem + Scope + Design, no wireframes)
2. Get explicit approval for that minimal doc
3. Then proceed to writing-plans

You must NEVER skip both design and planning for non-trivial work.

## Visual Design with ascii-wireframe

For any UI work, use the `ascii-wireframe` skill to create visual artifacts:

- Wireframes for page layouts and component structures
- Flow diagrams for user journeys
- Architecture diagrams for data flow

Invoke the skill via the Skill tool:

```
Use the `ascii-wireframe` skill to generate [type of diagram] for [purpose].
```

Do NOT attempt to describe UI solely in text when wireframes would communicate more effectively.

## User Override

The user's explicit instructions always override skill defaults:

- If the user says "skip questions and propose approaches directly", skip Phase 2
- If the user says "only one approach is viable", present one with justification
- If the user says "I already have a design doc, just review it", jump to Phase 6
- If the user says "this is too heavy, just plan it", transition to writing-plans directly

Adapt the process to the situation. The flow exists to serve the work, not to create ceremony.

## Integration with Helm

When brainstorming is invoked within a helm-governed run:

- The napkin provides project conventions that the design should follow
- The spec review phase aligns with helm's governance audit
- The hard gate aligns with helm's "no premature implementation" enforcement
- The transition to writing-plans feeds into helm's planning-artifact workflow

Brainstorming does not replace helm's classification. If brainstorming is needed, helm should classify the run appropriately and invoke this skill as part of the branch workflow.

## Spec Location

All design specs live under:

```
docs/helm/specs/
```

This is the canonical location. When helm references specs, it should look here.
