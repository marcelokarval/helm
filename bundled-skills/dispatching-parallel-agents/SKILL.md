---
name: dispatching-parallel-agents
description: >
  Dispatch one agent per independent problem domain and let them work concurrently.
  Use when a task contains 2+ independent subproblems that can be solved in parallel
  (e.g., investigating separate failures, updating unrelated modules, researching
  different systems). In Z.ai, parallel dispatch works by sending MULTIPLE Task tool
  calls in a SINGLE message — the platform handles concurrency internally. This skill
  prevents sequential bottlenecking, accelerates discovery, and produces structured
  cross-domain results. NOT for tasks that are sequential, dependent, or trivially small.
metadata:
  category: orchestration
  origin: adapted-from-superpowers-mit-license
  version: 1.0.0
---
# Dispatching Parallel Agents

## Core Concept

When you face a task with **multiple independent problem domains**, dispatch one
agent per domain and let them run concurrently.

In Z.ai, you dispatch parallel subagents by sending **multiple Task tool calls in a
single message**. The Task tool handles concurrency internally — you do not need any
special syntax beyond making multiple tool invocations at once.

**The rule is simple:** if two subproblems share no inputs and produce no outputs
that the other needs, they can run in parallel.

## When to Use This Pattern

**Use it when:**

- A task contains 2+ independent subproblems that can be solved simultaneously
- You need to investigate multiple separate failures or issues
- You need to update, refactor, or modify unrelated modules at once
- Research requires exploring different systems, APIs, or codebases independently
- A bug report mentions multiple symptoms that may have different root causes
- You need to gather evidence from several independent sources before synthesizing

**Do NOT use it when:**

- Subproblems have dependencies (B needs A's output)
- The task is small enough for a single agent to handle quickly
- Subproblems share mutable state or conflicting file writes
- One subproblem's failure would invalidate the others
- The coordination overhead exceeds the parallelism benefit

## The Pattern

### Step 1: Identify Independent Domains

Decompose the task. For each piece, ask: "Does this depend on any other piece?"

```
Task: "The payment flow is broken — users see errors at checkout, the webhook
      handler crashes, and the email confirmation never sends."

Analysis:
  1. Checkout error → frontend form + API endpoint (domain: checkout)
  2. Webhook crash → webhook handler + error logs (domain: webhooks)
  3. Missing emails → email service + queue system (domain: notifications)

These three domains are independent — fixing one doesn't affect the others.
```

### Step 2: Create Agent Tasks

Define a clear, bounded task for each agent. Each task must be:
- **Self-contained** — the agent has everything it needs to work
- **Bounded** — clear success criteria and scope limits
- **Non-conflicting** — no file write collisions with other agents

### Step 3: Dispatch in Parallel

In Z.ai, send multiple Task tool calls in a single message:

```
"I'll dispatch 3 parallel agents to investigate these independent failures.

Agent 1 (checkout): Investigate the checkout error — check the form validation,
API endpoint, and error handling.

Agent 2 (webhooks): Investigate the webhook crash — check the handler code,
error logs, and payload parsing.

Agent 3 (notifications): Investigate the missing email confirmations — check
the email service integration, queue system, and retry logic."
```

### Step 4: Review and Synthesize

When all agents report back:
1. Read each result
2. Identify cross-domain patterns (are the failures related?)
3. Prioritize fixes
4. Present a unified report

## Agent Prompt Structure

Each parallel agent task should follow this structure:

```
## Task: [Short description of what this agent should do]

### Context
[Relevant background — what's known so far]

### Scope
[What files, systems, or areas to investigate]
[What to do: search, analyze, fix, document]

### Deliverable
[What the agent should produce: findings, code changes, report]

### Constraints
[Files to avoid, things NOT to do, scope limits]
```

## Common Mistakes

### Mistake 1: False Independence

```
Bad:  Dispatching agent A to "design the database schema" and agent B to
      "write the API endpoints" — these ARE dependent.

Good: Agent A designs schema, THEN agent B writes endpoints using that schema.
```

### Mistake 2: File Write Conflicts

```
Bad:  Two agents both editing the same config file or the same component.

Good: Each agent owns its own files. Shared files are touched by only one agent,
      or edited during the synthesis step.
```

### Mistake 3: Over-Parallelizing

```
Bad:  Dispatching 5 agents for a task that one agent could handle in 2 minutes.

Good: Parallelism has overhead — coordination, synthesis, potential conflicts.
      Use it when the subproblems genuinely benefit from concurrent investigation
      or when total work time significantly exceeds coordination cost.
```

### Mistake 4: Vague Agent Tasks

```
Bad:  "Look into the authentication system and fix whatever's wrong."

Good: "Investigate the JWT token refresh flow. Check:
      - Token expiry handling in middleware.js
      - Refresh endpoint in auth/routes.js
      - Client-side token storage in auth/store.js
      Report: what's broken, why, and the minimal fix."
```

### Mistake 5: Ignoring Synthesis

```
Bad:  Running agents and reporting their results as separate disconnected items.

Good: After all agents report, synthesize:
      - Are any findings related?
      - What's the root cause priority order?
      - What's the unified fix plan?
      - Are there cascading risks?
```

## Real-World Example: Z.ai Context

**Task:** "The dashboard page is completely broken after the last deployment —
charts don't load, the filter panel throws errors, and user data is stale."

**Dispatch:**

1. **Agent A — Charts:** Investigate the chart rendering pipeline. Check the data
   fetching hook, chart component props, and API response format for chart endpoints.
   Scope: `components/charts/`, `hooks/useChartData.ts`, `api/charts/`.

2. **Agent B — Filters:** Investigate the filter panel error. Check the filter
   state management, query parameter sync, and filter API calls. Scope:
   `components/filters/`, `hooks/useFilters.ts`, `utils/queryParams.ts`.

3. **Agent C — Data Freshness:** Investigate stale user data. Check caching headers,
   revalidation strategy, and SWR/React Query configuration. Scope:
   `hooks/useUserData.ts`, `api/users/`, `config/cache.ts`.

**Synthesis:** Agent A finds a breaking API response change. Agent B finds a query
parameter parsing regression. Agent C finds that cache TTL was increased. The root
cause is a single API migration that affected all three — the synthesis reveals
this shared root cause that individual agents couldn't see.

## Sizing Guidelines

| Subproblems | Agents | Rationale |
|---|---|---|
| 2-3 | 2-3 | Sweet spot — clear domains, easy synthesis |
| 4-6 | 3-4 | Group related subproblems; limit coordination cost |
| 7+ | Stop and reassess | Consider whether the task should be broken into phases |

## Relationship to Other Patterns

- **prompt-hardening** — use before dispatching to ensure each agent task is well-defined
- **helm** — the orchestration layer decides whether parallel dispatch is appropriate
- **fullstack-dev** — individual agents typically use this for their implementation work
- **forensic-review** — parallel agents may produce evidence that needs forensic synthesis

## Summary

1. **Identify** truly independent subproblems
2. **Create** bounded, self-contained agent tasks
3. **Dispatch** by sending multiple Task tool calls in a single message
4. **Review** each result individually
5. **Synthesize** findings into a unified understanding and action plan

The power isn't in running things fast — it's in giving each problem domain the
full attention of a dedicated agent while not wasting time on sequential bottlenecks.
