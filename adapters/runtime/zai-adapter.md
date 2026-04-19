# Z.ai Runtime Adapter

## Overview
The original accelerate defines runtime adapters for Python/uv, Node, Chrome DevTools,
and Playwright. This adapter defines the Z.ai-specific runtime commands and tools.

## Standard Toolchain

| Capability | Command / Tool | Notes |
|---|---|---|
| Lint + TypeScript check | `bun run lint` | ESLint + TypeScript in single command |
| Database schema sync | `bun run db:push` | Prisma push to SQLite |
| Database seed | `npx tsx prisma/seed.ts` | Seed data with deterministic IDs |
| Dev server | `bun run dev` | Auto-restart on file change (port 3000) |
| Build check | `bun run lint` | No `bun run build` in sandbox |
| Package install | `bun add <package>` | Install new dependencies |

## Proof Methods

### Layer 1: Implementation Proof
```bash
bun run lint  # Must return zero errors
```

### Layer 2: Backend QA
```bash
# Verify API endpoints return 200
curl -s http://localhost:3000/api/endpoint | python3 -m json.tool
```

### Layer 3: Browser Truth
```bash
# Visual QA via agent-browser
agent-browser snapshot http://localhost:3000
agent-browser click "button:text('Submit')"
agent-browser screenshot /path/to/evidence.png
```

### Layer 4: Persistent Regression
**Not available in Z.ai sandbox.** Use agent-browser as substitute:
- Run agent-browser through critical user flows
- Compare screenshots between sessions (manual)
- Check for console errors

### Layer 5: Forensic Closure
Invoke the `forensic-review` skill:
```
Skill(command="forensic-review")
```

## Z.ai-Specific Tools

| Tool | Purpose | Usage |
|---|---|---|
| `agent-browser` | Headless browser automation | Visual QA, screenshots, interaction testing |
| `z-ai function` | AI SDK CLI | Web search, page reading, LLM, TTS, VLM, etc. |
| `Skill tool` | Invoke skills | Load skill documentation into context |
| `Task tool` | Spawn subagents | Delegate bounded work to subagent types |

## Mini-Services

The Z.ai platform supports mini-services for real-time features:

| Service | Port | Purpose |
|---|---|---|
| Main app | 3000 | Next.js application |
| WebSocket | 3003+ | Socket.io for real-time updates |
| Other services | 3004+ | Additional microservices |

All services communicate via gateway with `XTransformPort` query parameter.

## NOT Available in Z.ai

| Capability | Status | Substitute |
|---|---|---|
| Playwright (persistent E2E) | Not available | agent-browser |
| Chrome DevTools (manual) | Not available | agent-browser |
| EXPLAIN (PostgreSQL) | Not available | N/A (SQLite) |
| manage.py (Django) | Not available | bun/prisma |
| makemigrations | Not available | `bun run db:push` |
| npm/pnpm/yarn | Not available | bun |
| Docker | Not available | bun services |
| Redis/MySQL | Not available | SQLite + in-memory cache |
| CI/CD pipelines | Not available | cron jobs |

## Environment Constraints

- **Port:** Only port 3000 is exposed externally
- **Database:** SQLite only (via Prisma)
- **Caching:** In-memory (no Redis)
- **Auth:** NextAuth.js v4 available
- **State:** Zustand (client) + TanStack Query (server)
- **Styling:** Tailwind CSS 4 + shadcn/ui
- **Animations:** Framer Motion
- **AI SDK:** z-ai-web-dev-sdk (backend only)
