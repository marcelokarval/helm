---
name: systematic-debugging
description: >
  Four-phase debugging discipline (Root Cause → Pattern Analysis → Hypothesis → Implementation)
  that replaces guess-and-check with structured root-cause analysis. Use whenever a bug, error,
  unexpected behavior, or failure occurs — whether in code, browser, API responses, or build
  output. Enforces gathering evidence BEFORE proposing fixes, forming falsifiable hypotheses
  BEFORE writing code, and verifying the fix with fresh evidence AFTER implementation. Prevents
  the most common debugging failure: applying random fixes without understanding the actual cause.
metadata:
  category: debugging
  origin: adapted-from-superpowers-for-zai
  version: 1.0.0
---
# Systematic Debugging

## The Iron Law

**Do NOT fix what you do NOT understand.**

Every bug has a root cause. Your job is to find it — not to try random fixes until
something sticks. Guessing at fixes wastes time, creates technical debt, introduces
new bugs, and leaves you vulnerable to the same issue recurring.

This skill gives you a structured process for finding root causes efficiently.

## The Four Phases

Debugging always follows this sequence. Do not skip phases. Do not jump ahead.

```
Phase 1: Root Cause Investigation
    ↓
Phase 2: Pattern Analysis
    ↓
Phase 3: Hypothesis Formation
    ↓
Phase 4: Fix Implementation + Verification
```

---

## Phase 1: Root Cause Investigation

**Goal: Gather raw evidence about the failure.**

This phase is OBSERVATION only. You are a detective at a crime scene. You do not
touch anything. You do not propose solutions. You collect evidence.

### Evidence Collection Toolkit

| Evidence Type | Z.ai Method | What It Tells You |
|---|---|---|
| Error messages | Read the exact error text, stack trace, or console output | The WHERE and WHAT of the failure |
| Terminal output | Read `bun run lint` or `bun run dev` output | Compilation errors, runtime errors, warnings |
| API responses | `curl -s http://localhost:3000/api/<endpoint>` | What the server actually returns vs what's expected |
| Browser state | `agent-browser` snapshot, screenshot, console log | DOM state, network errors, visual rendering |
| Code reading | Read the relevant source files | The logic that produced the failure |
| Data state | Read database records, check Prisma queries | What data exists vs what the code expects |
| Logs | Read any application logs or console output | Chronological sequence of events |

### What to Collect

1. **Exact error message** — verbatim, not paraphrased
2. **Reproduction steps** — the minimum sequence that triggers the failure
3. **Expected vs actual behavior** — what should happen vs what happens
4. **Context** — when did it start? after what change? in what environment?
5. **Scope** — does it affect one case, multiple cases, or everything?
6. **Related code** — the files and functions involved in the failure path

### Phase 1 Output

A structured evidence document:

```markdown
## Bug Evidence

### Error:
<exact error message or description of unexpected behavior>

### Reproduction:
1. <step 1>
2. <step 2>
3. <step 3>

### Expected:
<what should happen>

### Actual:
<what happens instead>

### Scope:
<how widespread is this issue>

### Files Involved:
- <file 1>: <role in the failure>
- <file 2>: <role in the failure>

### Environment:
<dev server running? which port? any special conditions?>
```

**Do NOT proceed to Phase 2 until you have this evidence documented.**

---

## Phase 2: Pattern Analysis

**Goal: Find patterns in the evidence that point toward a cause.**

Now that you have raw evidence, look for patterns. This is where you start
narrowing down the root cause.

### Pattern Questions

Ask these questions systematically:

1. **Isolation**: Does this happen only in one specific scenario, or across many?
   - Single scenario → likely a specific code path issue
   - Multiple scenarios → likely a shared dependency, configuration, or architecture issue

2. **Timing**: When did this start?
   - After a specific code change → look at that diff
   - After a dependency update → check changelogs
   - It's always been this way → likely a design flaw or misunderstanding

3. **Data**: What data is involved?
   - Wrong data shape → check Prisma schema vs expected shape
   - Missing data → check seed data, migrations, queries
   - Unexpected data → check the query that produces it

4. **Boundary**: Where does the failure occur?
   - Client-side → check React state, event handlers, API calls
   - Server-side → check API routes, server actions, middleware
   - Database → check queries, constraints, schema
   - Between layers → check the API contract (request shape, response shape)

5. **Assumptions**: What assumptions does the code make?
   - Does the code assume a field exists that might not?
   - Does the code assume a specific order of operations?
   - Does the code assume a specific environment or configuration?

### Common Root Cause Patterns

| Pattern | How to Detect | Example |
|---|---|---|
| **Type mismatch** | TypeScript error, runtime type error, API response shape differs from expected | API returns `{id: number}` but code expects `{id: string}` |
| **Null/undefined access** | "Cannot read property of undefined", optional chaining missing | Accessing `user.name` when `user` might be null from Prisma |
| **Stale state** | Value is correct initially but wrong after interaction | React state not updated after mutation, TanStack Query cache not invalidated |
| **Race condition** | Intermittent failure, works sometimes but not always | Async operation completing before state is ready |
| **Missing error handling** | Error appears in console but is not caught or displayed | API call fails silently, form submission error not surfaced |
| **Wrong API contract** | Request shape doesn't match what the route expects | Frontend sends `{name}` but route expects `{displayName}` |
| **CSS/Tailwind issue** | Visual output doesn't match intent | Missing responsive classes, specificity conflict, Tailwind v4 syntax difference |
| **Missing import or export** | Module not found, function undefined | Named export used as default import |
| **Environment assumption** | Works in one environment but not another | Feature flag not set, environment variable missing |

### Phase 2 Output

A list of candidate causes ranked by likelihood:

```markdown
## Candidate Causes (ranked by likelihood)

1. [HIGH] <cause description>
   - Evidence supporting: <specific evidence>
   - Evidence against: <specific evidence>

2. [MEDIUM] <cause description>
   - Evidence supporting: <specific evidence>
   - Evidence against: <specific evidence>

3. [LOW] <cause description>
   - Evidence supporting: <specific evidence>
   - Evidence against: <specific evidence>
```

---

## Phase 3: Hypothesis Formation

**Goal: Form a specific, falsifiable hypothesis about the root cause.**

A hypothesis is NOT a guess. It is a specific claim that can be proven or
disproven with a targeted test.

### Hypothesis Structure

```
I believe that [specific cause] is producing [specific failure]
because [specific mechanism].

If this is correct, then [specific observable prediction].
If this is wrong, then [specific contradictory observation].
```

### Falsifiability Check

A good hypothesis must be falsifiable. Ask:

1. What observation would PROVE this hypothesis wrong?
2. Can I test for that observation?
3. Is the prediction specific enough that it can't be explained by other causes?

If you can't answer these, refine the hypothesis.

### Hypothesis Testing Methods

| Test Type | Z.ai Method | When to Use |
|---|---|---|
| Code inspection | Read the specific code path | When the hypothesis points to a specific function or line |
| API contract check | `curl` the endpoint with specific input | When the hypothesis involves request/response shape |
| Browser inspection | `agent-browser` navigate, inspect, interact | When the hypothesis involves rendering, events, or state |
| Data verification | Read database records, check Prisma output | When the hypothesis involves data shape or missing data |
| Isolation test | Comment out code, add logging | When the hypothesis needs narrowing |

### Common Anti-Patterns in Hypothesis Formation

| Anti-Pattern | Example | Why It's Dangerous |
|---|---|---|
| **Confirmation bias** | "I think it's X, let me check if X could cause this" | You'll find evidence for any hypothesis if you look hard enough |
| **Premature fix** | "Let me try changing this and see if it fixes it" | You've skipped to Phase 4 without a hypothesis |
| **Broad hypothesis** | "Something is wrong with the state management" | Too vague to test. Which state? What component? What operation? |
| **Multiple hypotheses** | "It could be A or B or C" | Pick the most likely ONE and test it. If wrong, test the next. |
| **Assumption as hypothesis** | "The code should work, maybe it's a platform bug" | Last resort, not first. Prove your own code wrong first. |

### Phase 3 Output

```markdown
## Hypothesis

**Claim**: <specific root cause claim>

**Mechanism**: <how the cause produces the failure>

**Prediction**: <what I expect to observe if this is correct>

**Disproof**: <what would prove this wrong>

**Test**: <how I will test this hypothesis>
```

**Do NOT proceed to Phase 4 until you have a tested hypothesis.**

---

## Phase 4: Fix Implementation + Verification

**Goal: Implement the minimal fix and verify it resolves the root cause.**

### Fix Principles

1. **Minimal change** — Fix exactly what's broken. Don't refactor, don't "improve",
   don't add features. The fix should be the smallest change that addresses the
   root cause.
2. **Address the cause, not the symptom** — If a variable is null, don't add a null
   check everywhere it's used. Find out WHY it's null and fix that.
3. **One fix at a time** — If the hypothesis has multiple possible fixes, try them
   one at a time so you know which one actually works.
4. **Explain the fix** — Before writing code, write a one-sentence explanation of
   what the fix does and why it works.

### Implementation Steps

1. Write the one-sentence fix explanation
2. Implement the minimal change
3. Run `bun run lint` — must pass
4. Verify the bug is fixed using the same evidence collection from Phase 1
5. Check for regressions — does anything that was working before now break?

### Verification Protocol

After implementing the fix, you MUST:

1. **Reproduce the original bug** — Use the exact reproduction steps from Phase 1.
   The bug MUST no longer occur.
2. **Run `bun run lint`** — Zero new errors introduced.
3. **Check adjacent functionality** — If you changed a shared component or utility,
   verify other consumers still work.
4. **Visual verification** (if applicable) — Use `agent-browser` to verify the
   fix in the browser. Navigate, interact, check for console errors.
5. **Edge case check** — Think of one edge case related to the fix and verify it.

### When Tests Exist

If the project has a test framework:
1. Write a failing test that reproduces the bug
2. Verify the test fails before the fix
3. Apply the fix
4. Verify the test passes after the fix

If no test framework is set up, use `agent-browser` for visual and behavioral
verification as the primary evidence.

### Phase 4 Output

```markdown
## Fix Report

**Root Cause**: <confirmed root cause>

**Fix**: <one-sentence description>

**Changes**:
- <file>: <change description>

**Verification**:
1. Original reproduction: <PASSES/FAILS> — <evidence>
2. bun run lint: <PASSES/FAILS> — <output>
3. Regression check: <what was checked, result>
4. Edge case: <what was checked, result>

**Visual verification** (if applicable):
- agent-browser: <screenshot or interaction evidence>
```

---

## Quick Reference

| Phase | Goal | Key Question | Exit Criterion |
|---|---|---|---|
| 1. Root Cause | Gather evidence | "What exactly is happening?" | Structured evidence document complete |
| 2. Pattern | Find patterns | "What do the clues point to?" | Ranked candidate causes identified |
| 3. Hypothesis | Form and test | "Is it specifically X?" | Falsifiable hypothesis confirmed or rejected |
| 4. Fix | Implement and verify | "Does the fix work?" | Original bug resolved, no regressions |

## Red Flags

Stop and reconsider your approach if you notice:

1. **"Let me just try this..."** — You're skipping phases. Go back to evidence collection.
2. **Multiple attempted fixes** — You're guessing. Form a hypothesis.
3. **The fix feels like a hack** — It probably is. Find the real cause.
4. **"It works but I don't know why"** — You haven't found the root cause. You've masked the symptom.
5. **Fixing one thing breaks another** — The root cause is shared. Go back to Phase 2.
6. **The same bug keeps coming back** — Your fix addressed a symptom, not the cause.
7. **"This must be a framework bug"** — It might be. But prove your own code is innocent first.

## Common Rationalizations

These are the lies you tell yourself to skip the process:

| Rationalization | Reality |
|---|---|
| "I've seen this before, I know the fix" | You've seen SOMETHING like this. The cause might be different. |
| "This is a simple typo, just fix it" | Fix it, but verify it's the only issue. Typos cluster. |
| "The user said it works now" | The user might have tested a different path. Verify yourself. |
| "I don't have time for systematic debugging" | You don't have time for systematic debugging, but you have time to try 10 random fixes? |
| "The error message is obvious" | Error messages describe symptoms, not causes. |
| "Adding a null check will fix it" | It will mask the crash. It will NOT fix why the value is null. |

## Supporting Techniques

This skill covers the core 4-phase process. For deeper debugging situations,
refer to these related disciplines:

- **Root-cause-tracing** — For multi-layer failures where the visible error is
  several steps removed from the actual cause
- **Defense-in-depth** — For failures caused by missing safety layers (error
  boundaries, input validation, type guards)
- **Condition-based-waiting** — For intermittent failures caused by timing
  and race conditions

These are invoked separately when the debugging situation demands them.
