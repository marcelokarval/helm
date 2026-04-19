---
name: verification-before-completion
description: >
  Verification gate that prevents premature completion claims. MUST be invoked before marking
  ANY task as done — whether the work was done by the agent itself or by a subagent. Enforces
  fresh evidence collection (not cached or assumed), specific verification commands per claim
  type, rationalization detection, and a hard ban on "I believe" or "should be" language in
  closure reports. Catches the most common failure mode: declaring success without actually
  checking. Use as the final gate before ANY "Done", "completed", or "finished" statement.
metadata:
  category: closure
  origin: adapted-for-zai
  version: 1.0.0
---
# Verification Before Completion

## The Iron Law

**NO completion claim WITHOUT fresh verification evidence.**

You may not say "Done", "completed", "finished", "implemented", "fixed", or any
equivalent without first collecting and presenting evidence that the claim is true.

The evidence must be:
- **Fresh** — collected AFTER the work was done, not before
- **Specific** — not "it should work" but "I ran X and observed Y"
- **Relevant** — the evidence must actually prove the specific claim being made
- **Complete** — all acceptance criteria must have corresponding evidence

This applies to EVERY task, regardless of size. A "trivial" change still gets
verified. A one-line fix still gets checked. There are no exceptions.

## The Gate Function

Before any completion claim, run this mental gate:

```
GATE(task, claim, evidence):
  if evidence is empty → REJECT
  if evidence was collected before the work → REJECT
  if evidence does not directly address the claim → REJECT
  if any acceptance criterion has no matching evidence → REJECT
  if evidence contains "should", "believe", "probably", "likely" → REJECT
  return APPROVE
```

If the gate rejects, go collect real evidence. Do not reformulate the claim to
avoid verification.

## Verification Commands by Claim Type

Different claims require different verification methods. Here is the Z.ai
standard toolkit:

### "Code compiles / no type errors"
```bash
bun run lint
```
Must show zero errors. Warnings are acceptable only if pre-existing.

### "Tests pass" / "Nothing broke"
```bash
bun run lint
```
Plus: if there are API endpoints affected, verify at least one returns 200:
```bash
curl -s http://localhost:3000/api/<affected-endpoint> | python3 -m json.tool
```

### "Build succeeds"
```bash
bun run lint
```
(Z.ai sandbox does not have a separate build step. Lint includes TypeScript checking.)

### "Feature works" / "Page renders correctly"
Use `agent-browser` for visual verification:
1. Navigate to the affected page/route
2. Take a screenshot
3. Interact with the feature (click, fill, submit)
4. Verify the expected state change
5. Check for console errors

### "Bug fixed"
This is the most dangerous claim. Verify ALL of:
1. The original failure mode no longer occurs (reproduce the old bug, confirm it's gone)
2. The fix doesn't introduce new failures (regression check)
3. Edge cases around the fix still work
4. `bun run lint` passes

For visual bugs, use `agent-browser` to:
1. Reproduce the original visual issue (if documented)
2. Verify the fix resolves it
3. Check adjacent elements aren't affected

### "Agent/subagent completed the task"
The subagent said "done" — but that's THEIR claim, not evidence. Verify:
1. Check the VCS diff — are the expected files actually changed?
2. Run `bun run lint` on the modified files
3. Spot-check the implementation against the spec/requirements
4. If the subagent reported concerns, address them before accepting
5. Use `agent-browser` if the task involves any visual output

### "Refactoring complete / code improved"
1. `bun run lint` passes (behavior preserved)
2. The refactored code is functionally equivalent to the original
3. No imports were broken
4. No types were loosened (no new `any`)
5. The code is actually simpler, not just different

### "Documentation updated"
1. The doc file exists and contains the claimed content
2. The content is accurate (check against the code it documents)
3. No stale references to removed/renamed features

## Common Failures

These are the most frequent ways completion claims fail. Recognize them and
reject them:

| Failure Pattern | Example | Why It's Wrong |
|---|---|---|
| **Assumed verification** | "The component should work correctly" | "Should" is not evidence |
| **Stale evidence** | "Lint passed earlier so it still passes" | Evidence must post-date the last change |
| **Partial verification** | "The happy path works" | Edge cases and error paths need checking too |
| **Proxy verification** | "The subagent said it's done" | Subagent claims need independent verification |
| **Logical deduction** | "I wrote the code correctly so it must work" | Code correctness is an empirical question, not a logical one |
| **Scope assumption** | "The fix is complete for this component" | Did you check if other components depend on this behavior? |
| **Self-certification** | "I'm confident this is correct" | Confidence is not evidence |
| **Definition shifting** | "Well, it's done enough" | The acceptance criteria define done, not your feeling |

## Red Flags

Reject the completion claim immediately if you notice:

1. **"I believe" / "I think" / "I assume"** — These phrases indicate absence of evidence, not presence of it
2. **No command output** — If a claim involves running something, there should be output
3. **Selective evidence** — Only the positive cases were checked, failures ignored
4. **Vague language** — "works", "looks good", "seems fine" without specifics
5. **Missing the hard case** — The easy stuff was verified but the tricky edge case was skipped
6. **Rushed closure** — Speed of response suggests evidence wasn't actually collected
7. **No negative testing** — Only confirmed the positive path, never tried to break it
8. **Circular reasoning** — "It works because I implemented it according to the spec, and it matches the spec because I implemented it that way"

## Rationalization Prevention

The most insidious failure mode is not lying — it's convincing yourself that
incomplete evidence is sufficient. Watch for these internal rationalizations:

### "This is a trivial change"
Trivial changes break things too. A missing import, a typo in a className,
a wrong variable name — all trivial, all break production. Verify.

### "I already checked this earlier"
Then check it again. The state of the codebase has changed since your earlier
check. Your earlier evidence is stale.

### "The user is waiting / I should be fast"
The user would rather wait for a correct result than get a fast incorrect one.
Rushing verification saves seconds and costs hours of debugging later.

### "This isn't a formal PR, it's a conversation"
The code runs in production regardless of whether you called it a PR. Verification
is about correctness, not ceremony.

### "I'll verify in the next step"
No. Verify NOW. The "next step" is when you'll forget, or when new changes will
invalidate the evidence you could have collected now.

### "The linter/type checker would have caught it"
Linters catch what they're configured to catch. They don't catch logic errors,
missing features, wrong API contracts, or visual regressions.

## Evidence Format

When presenting verification evidence, use this format:

```markdown
## Verification

### Claim: <what you're claiming is done>

### Evidence:
1. **[evidence type]**: <command run / action taken>
   - Result: <specific output or observation>
2. **[evidence type]**: <command run / action taken>
   - Result: <specific output or observation>

### Acceptance Criteria Mapping:
| Criterion | Status | Evidence Reference |
|---|---|---|
| <criterion 1> | PASS/FAIL | Evidence #1 |
| <criterion 2> | PASS/FAIL | Evidence #2 |

### Outstanding Concerns:
- None. OR
- <specific concern that doesn't block completion but should be tracked>
```

## What Does NOT Count as Evidence

- "I read the code and it looks right"
- "The logic is straightforward"
- "I've done this many times before"
- "The patterns are consistent"
- "There are no obvious issues"
- "The types align"
- "This follows best practices"
- Any statement that could be true about code that is completely broken

## What DOES Count as Evidence

- `bun run lint` output showing zero errors
- `curl` response showing expected JSON from an API endpoint
- `agent-browser` screenshot showing the page renders correctly
- `agent-browser` interaction log showing a form submits successfully
- A VCS diff showing the expected files were changed with the expected content
- A file read confirming documentation content is present and accurate
- A console error log showing NO errors during the relevant interaction
- A specific test output (if tests exist) showing all tests passing

## The Bottom Line

Verification is not optional. It is not ceremonial. It is not a nice-to-have.

Every completion claim without fresh evidence is a **lie** — not necessarily an
intentional one, but a lie nonetheless. The code either works or it doesn't, and
you don't know which until you check.

The cost of verification: seconds to minutes.
The cost of shipping unverified code: hours to days of debugging, user trust
erosion, and production incidents.

**Check your work. Every time. No exceptions.**
