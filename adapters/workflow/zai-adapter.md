# Z.ai Workflow Adapter

## Overview
The original accelerate uses Linear and GitHub Issues as workflow backends.
The Z.ai platform does not have native issue tracker integration. This adapter
defines the file-based workflow system that replaces Linear/GitHub Issues.

## Contract: docs/TASKS.md

The `docs/TASKS.md` file serves as the issue tracker for Z.ai projects.

### Format
```markdown
# TASKS

## Active Tasks
| ID | Title | Status | Branch | Assigned | Priority | Created |
|----|-------|--------|--------|----------|----------|---------|
| 001 | Create dashboard component | done | product-critical | full-stack-dev | P0 | 2026-06-20 |
| 002 | Add CSV export endpoint | in-progress | trivial | master | P1 | 2026-06-21 |
| 003 | Fix responsive layout bug | pending | bug/regression | frontend-styling-expert | P0 | 2026-06-22 |

## Backlog
| ID | Title | Priority | Notes |
|----|-------|----------|-------|
| 004 | Add dark mode toggle | P2 | Requires theme provider |
```

### Status Values
| Status | Meaning | Transition |
|---|---|---|
| `pending` | Not started | → `in-progress` |
| `in-progress` | Currently being worked on | → `in-review` or `blocked` |
| `in-review` | Subagent returned evidence, awaiting master review | → `done` or `in-progress` |
| `blocked` | Blocked by dependency or blocker | → `pending` when unblocked |
| `done` | Master reviewed, forensic closure passed | Terminal |

### Branch Types
Use the branch types defined in `core/control-plane/branch-enforcement-matrix.md`:
- `trivial` — small, well-scoped work
- `ambiguous` — unclear scope, needs hardening
- `issue-driven` — has clear task ID
- `bug/regression` — fixing existing problems
- `product-critical` — user-facing surfaces
- `premium` — perceived quality matters
- `security-sensitive` — auth, data, abuse
- `architecture` — structural decisions

## Contract: worklog.md

The `worklog.md` file serves as the activity log and session handoff document.

### Format
```markdown
---
Task ID: 001
Agent: full-stack-developer
Task: Create dashboard component

Work Log:
- Created /src/components/dashboard.tsx with summary cards
- Added /api/dashboard endpoint with aggregation queries
- Integrated with existing theme provider
- Applied Framer Motion animations

Stage Summary:
- Dashboard component rendering with 3 summary cards
- API returning correct aggregated data
- Zero lint errors
- Browser QA passed via agent-browser
```

### Relationship Between TASKS.md and worklog.md
- `docs/TASKS.md` is the WHAT (what needs to be done)
- `worklog.md` is the HOW (what was done, evidence, blockers)
- Both must be updated together:
  - Start work → set status to `in-progress` in TASKS.md
  - Complete work → add Stage Summary to worklog.md
  - Master review → set status to `done` in TASKS.md

## Integration with helm

The helm skill references this adapter when:
1. **Issue Bootstrap Gate** — requires a task ID in docs/TASKS.md
2. **Mutation Rule** — code changes must be linked to a task
3. **Closure** — task status must be updated to `done` before closure

## Not Available in Z.ai
- Linear integration (no API)
- GitHub Issues integration (no API)
- Automatic status transitions (manual update required)
- Webhook notifications (no event system)
- Issue linking/dependencies (manual tracking)
