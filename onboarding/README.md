# Onboarding

Onboarding is a first-class layer of the `helm` platform for Z.ai.

Its job is to help `helm` land in a repository with little or no prior
setup by discovering:

- workflow backend (docs/TASKS.md + worklog.md)
- stack profile (Next.js 16 / Tailwind CSS 4 / Prisma)
- runtime adapters (bun, agent-browser)
- docs posture
- recommended Z.ai skills
- future subagent candidates (via Task tool)

## Current Stage

The onboarding layer is already native in the `pre-agents` phase.

That means onboarding is no longer only an architecture idea. It already has a
defined operating surface, and the first native implementation surface for the
project-local `docs/helm/` workspace.

## Z.ai-Specific Onboarding Flow

When onboarding a project on the Z.ai platform, the flow follows these
Z.ai-specific steps:

1. **Discovery** — Scan the repository for package.json, tsconfig.json,
   bun.lockb, and existing docs/ structure
2. **Stack Detection** — Identify if Next.js/Prisma/Tailwind are present;
   default to the Z.ai stack profile if found
3. **Workflow Setup** — Create or verify `docs/TASKS.md` for task tracking
   and `worklog.md` for session memory
4. **Workspace** — Create `docs/helm/` workspace for helm-specific config
5. **Skill Inventory** — List relevant Z.ai skills from the available
   `<available_skills>` that complement helm

### Key Differences from accelerate Onboarding

| accelerate | helm (Z.ai) |
| --- | --- |
| `.accelerate/` workspace | `docs/helm/` workspace |
| `Claude` platform | Z.ai agent platform |
| `Linear` / GitHub Issues | `docs/TASKS.md` + `worklog.md` |
| `manage.py check` | `bun run lint` |
| `playwright` | `agent-browser` |
| `*.toml` agents | 5 subagentes via Task tool |
| `Django ORM` | `Prisma ORM` |

## What Onboarding Must Already Do

At the current phase, onboarding must already be able to:

- frame discovery as a control-plane concern, not as an install wizard
- ask only the minimum questions that materially affect adapter/profile choice
- produce an executive bootstrap plan
- recommend Z.ai skills, adapters, profiles, and future subagent candidates
- work in repos that still have no specialized subagents

## What Onboarding Must Not Pretend Yet

At the current phase, onboarding must not pretend that it already has:

- a final persistence format beyond file-based markdown
- a mandatory interactive wizard implementation
- a fully enforced workflow backend
- automatic skill promotion (the human decides to create/update skills)

The current layer is operationally real, but still architecturally conservative.

It now hands off explicitly into the native `planning/` layer rather than
ending inside onboarding itself.

## Operational Reading Order

For a fresh session using onboarding as an active layer, read in this order:

1. `../AGENTS.md`
2. `../SKILL.md`
3. `README.md` (this file)
4. `../docs/architecture/onboarding-model.md`
5. `../planning/README.md`

## Current Output Contract

The onboarding layer should currently leave enough truth behind for another
session to continue without reconstructing first principles.

The minimum output is:

- discovered repo signals
- unresolved high-impact ambiguities
- selected or recommended workflow adapter (docs/TASKS.md + worklog.md)
- selected or recommended runtime adapters (bun, agent-browser)
- selected or recommended stack profile (nextjs-tailwind-prisma)
- selected or recommended docs posture
- recommended adjacent Z.ai skills
- recommended future subagent candidates
- executive bootstrap plan

## Re-entry Rule

Onboarding is re-runnable.

Re-enter it when:

- the stack changes
- the workflow tracking approach changes
- the docs posture changes
- the repo moves from pre-agents toward real subagent specialization
- the current bootstrap assumptions are no longer honest

The architecture doc remains the wider design source:

- `docs/architecture/onboarding-model.md`
