---
name: napkin
description: >
  Persistent project-specific runbook that keeps recurring guidance fresh across sessions.
  Automatically read and curated whenever worklog.md is loaded. Stores conventions, decisions,
  patterns, pitfalls, and "do instead" rules in capped categories. This skill is always active —
  every engineering session should read and update the napkin to prevent repeated mistakes and
  maintain project memory between Z.ai agent turns.
metadata:
  category: knowledge-management
  origin: adapted-from-napkin-by-blader-for-zai
  version: 1.0.0
---

# Napkin

A continuously curated runbook for project-specific knowledge that persists across Z.ai sessions.

The napkin is NOT a session log, changelog, or conversation diary. It is a living reference that captures recurring decisions, conventions, and tactical guidance so that no session has to relearn the same lessons.

## Core Concept

The napkin stores knowledge in categories. Each category has a maximum of 10 entries. When a category is full, the oldest or least relevant entry is replaced. This keeps the document focused and prevents it from becoming a dumping ground.

## Activation

The napkin should be read and updated:

1. **At session start** — when the agent reads `worklog.md`, it should also read `docs/helm/napkin.md` (or the napkin section at the top of `worklog.md`)
2. **During work** — when a new convention, pattern, or pitfall is discovered
3. **At session end** — to capture any lessons learned that should persist

This is an "always active" skill. Do not wait for explicit activation.

## Storage Location

The napkin lives at:

```
docs/helm/napkin.md
```

If this file does not exist, create it with the template below. If the project uses a napkin section at the top of `worklog.md` instead, curate that section — but prefer the separate file when the project has been initialized with helm.

## Template

```markdown
# Napkin

Last curated: YYYY-MM-DD

## Conventions

(ongoing coding standards, naming patterns, file organization rules)

## Decisions

(architectural choices and their rationale)

## Patterns

(recurring solutions that work well in this project)

## Pitfalls

(mistakes already made — do not repeat)

## Do Instead

(when the agent is about to do something wrong, what should it do instead?)

## Stack Notes

(project-specific framework/tool quirks and gotchas)

## Pending Questions

(open questions that need resolution)
```

## Categories and Caps

Each category has a maximum of **10 entries**.

| Category | Purpose | Max |
|---|---|---|
| Conventions | Coding standards, naming, organization | 10 |
| Decisions | Architectural choices with rationale | 10 |
| Patterns | Proven solutions for this codebase | 10 |
| Pitfalls | Mistakes already made — prevent recurrence | 10 |
| Do Instead | Corrective guidance for common errors | 10 |
| Stack Notes | Framework/tool-specific quirks | 10 |
| Pending Questions | Open questions needing resolution | 10 |

When a category is full, replace the weakest entry. The napkin is a curated guide, not an archive.

## Date Format

All dates use `YYYY-MM-DD` format.

Each entry should include the date it was added or last confirmed relevant:

```
- [2025-01-15] Always use `server components` for data-fetching pages
```

## "Do Instead" Rule

The `Do Instead` category is the most important category. When the agent recognizes a pattern of repeated mistakes, it should add a "Do Instead" entry:

```
### Do Instead

- [2025-01-15] When adding a new API route, DO create the Prisma schema migration
  file first. Do NOT write the route handler before the schema exists.
- [2025-01-14] When styling with Tailwind, DO use the design token variables from
  `globals.css`. Do NOT hardcode arbitrary color values.
```

## Curation Rules

### Read

- Read the napkin at session start alongside `worklog.md`
- Use the napkin to avoid repeating known pitfalls
- Reference "Do Instead" entries when making decisions

### Write

- Add entries when a new lesson is learned
- Update the `Last curated` date on every modification
- Do NOT add session-level notes (those belong in `worklog.md`)
- Do NOT add entries that are already covered in the project docs
- Do NOT add generic advice — only project-specific guidance

### Prune

- Remove entries that are no longer relevant
- When a category is at capacity, replace the weakest entry
- If a "Pending Question" has been resolved, move it to the appropriate category

## Relationship to worklog.md

| Artifact | Purpose | Lifespan |
|---|---|---|
| `worklog.md` | Session handoff, task tracking, stage summaries | Active project history |
| `docs/helm/napkin.md` | Curated runbook of persistent guidance | Long-lived, continuously pruned |

The worklog records what happened. The napkin records what to do and what not to do.

## Integration with Helm

When helm classifies a run and opens branches, it should check the napkin for:

- Relevant `Conventions` that apply to the current work
- `Pitfalls` that could cause regression
- `Do Instead` rules for the current branch family

The napkin is a supporting artifact, not a control-plane authority. It informs decisions but does not replace branch routing or proof requirements.

## Example Napkin

```markdown
# Napkin

Last curated: 2025-01-15

## Conventions

- [2025-01-15] All new components go in `src/components/` with a co-located test file
- [2025-01-14] API routes use the pattern `src/app/api/[resource]/route.ts`
- [2025-01-13] Use `cn()` helper for conditional Tailwind class merging

## Decisions

- [2025-01-15] Using Prisma ORM for all database access — no raw SQL
- [2025-01-10] Server Components by default, Client Components only for interactivity
- [2025-01-08] shadcn/ui for all UI primitives — no custom component library

## Patterns

- [2025-01-14] Use `React.cache()` for deduplicating server-side data fetches
- [2025-01-12] Error boundaries wrap each route segment, not the entire layout

## Pitfalls

- [2025-01-15] Do NOT import client-side libraries in Server Components
- [2025-01-13] Do NOT use `useEffect` for data fetching — use server actions

## Do Instead

- [2025-01-15] When creating a new form, DO use `react-hook-form` + `zod`.
  Do NOT build custom form state management.
- [2025-01-14] When adding a new page, DO create the route handler first.
  Do NOT start with the UI shell.

## Stack Notes

- [2025-01-12] `bun run lint` runs both ESLint and type-checking
- [2025-01-10] `bun run dev` starts both frontend and backend in one process

## Pending Questions

- [2025-01-15] Should we add a real-time subscription layer? Needs product input.
```

## Enforcement

In the Z.ai platform, napkin enforcement is soft:

1. **Session start** — the agent reads `worklog.md` and should also read `docs/helm/napkin.md`
2. **Skill description** — this description helps the agent infer that napkin is relevant for recurring guidance
3. **Helm integration** — helm references napkin as a supporting artifact during branch classification

There is no hard gate that forces napkin reading. The value comes from consistent curation.
