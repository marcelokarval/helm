---
name: test-driven-development
description: >
  Iron Law: NO production code without a failing test first. Use whenever implementing features,
  fixing bugs, refactoring, or changing behavior. Enforces strict RED-GREEN-REFACTOR cycle with
  mandatory verification at each step — watch test fail, write minimal code, watch it pass, then
  clean up. Catches the most common TDD failure: writing code first then adding tests after, which
  proves nothing because passing tests may test the wrong thing. When invoked alongside systematic-
  debugging, ensures bugs are fixed with a regression test preventing recurrence.
metadata:
  category: quality
  origin: adapted-from-superpowers-for-zai
  version: 1.0.0
---
# Test-Driven Development

## The Iron Law

**NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST.**

Write code before the test? Delete it. Start over.

- Don't keep it as "reference"
- Don't "adapt" it while writing tests
- Don't look at it
- **Delete means delete**

Implement fresh from tests. Period.

## When to Use

**Always:**
- New features
- Bug fixes
- Refactoring
- Behavior changes

**Exceptions (ask the human first):**
- Throwaway prototypes
- Generated code
- Configuration files

Thinking "skip TDD just this once"? That's rationalization. Stop.

## Z.ai Context

In the Z.ai sandbox, the primary test commands are:

```bash
bun run lint          # TypeScript checking + ESLint
bun run test          # If test framework is configured
```

When no test framework is set up, use `agent-browser` for visual and
behavioral verification as a practical substitute — navigate, interact,
assert expected outcomes.

## Red-Green-Refactor

### RED — Write Failing Test

Write one minimal test showing what should happen.

**Requirements:**
- One behavior per test
- Clear name describing the expected outcome
- Real code (no mocks unless unavoidable)
- Test the WHAT (behavior), not the HOW (implementation)

### Verify RED — Watch It Fail

**MANDATORY. Never skip.**

Run the test and confirm:
- Test fails (not errors)
- Failure message matches the expected missing behavior
- Fails because the feature is missing (not because of typos)

**Test passes immediately?** You're testing existing behavior, not new behavior. Fix the test to actually test something new.

**Test errors out?** Fix the error (syntax, import), re-run until it fails correctly.

### GREEN — Minimal Code

Write the simplest code that passes the test. Nothing more.

- Don't add features the test doesn't require
- Don't refactor other code at this point
- Don't "improve" beyond what the test demands

### Verify GREEN — Watch It Pass

**MANDATORY.**

Run the test and confirm:
- Test passes
- All other tests still pass
- Output is clean (no errors, no warnings)

**Test fails?** Fix the implementation code, not the test.
**Other tests break?** Fix them now before continuing.

### REFACTOR — Clean Up

Only after green:
- Remove duplication
- Improve names
- Extract helpers
- Simplify structure

Keep tests green. Don't add behavior during refactoring.

### Repeat

Next failing test for the next piece of behavior.

## Good vs Bad Tests

| Quality | Good | Bad |
|---------|------|-----|
| **Minimal** | One thing. "and" in name? Split it. | `test('validates email AND domain AND whitespace')` |
| **Clear** | Name describes behavior | `test('test1')` |
| **Tests behavior** | Demonstrates what code should do | Tests mock implementation, not real logic |
| **Independent** | No shared mutable state between tests | Tests pass/fail depending on run order |

## Bug Fix Protocol

When fixing a bug, TDD applies as follows:

1. **RED**: Write a test that reproduces the bug
2. **Verify RED**: Confirm the test fails (bug exists)
3. **GREEN**: Write the minimal fix
4. **Verify GREEN**: Confirm the test passes (bug is fixed)
5. **REFACTOR**: Clean up if needed
6. **Regression check**: Run all tests to confirm no regressions

This produces two outcomes:
- The bug is fixed
- A regression test prevents the bug from returning

## When a Test Framework Exists

If the project has Jest, Vitest, or similar:

```bash
bun run test path/to/test.test.ts    # Run specific test
bun run test                          # Run all tests
```

## When No Test Framework Exists

In Z.ai projects without a configured test runner:

1. Write the test file anyway (it will be useful when tests are set up)
2. Use `agent-browser` for behavioral verification:
   - Navigate to the affected page/feature
   - Interact (click, fill, submit)
   - Assert the expected state change
   - Check for console errors
3. Use `bun run lint` for type safety verification
4. Document the test intent so it can be executed when a framework is added

## Rationalization Resistance

These are the lies you tell yourself to skip TDD:

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code breaks. The test takes 30 seconds. |
| "I'll test after" | Tests passing immediately prove nothing — you may test the wrong thing. |
| "Tests after achieve the same goals" | Tests-after answer "what does this do?" Tests-first answer "what should this do?" |
| "Already manually tested" | Ad-hoc is not systematic. No record, can't re-run, easy to forget cases. |
| "Deleting X hours of work is wasteful" | Sunk cost fallacy. Keeping unverified code is the real waste. |
| "Keep as reference, write tests first" | You'll look at it and adapt it. That's testing after. Delete means delete. |
| "Need to explore first" | Fine. Throw away the exploration. Start fresh with TDD. |
| "Hard to test = design unclear" | Listen to the test. If it's hard to test, it's hard to use. |
| "TDD will slow me down" | TDD is faster than debugging in production. Pragmatic = test-first. |
| "This is different because..." | No, it isn't. Write the test first. |

## Red Flags — STOP and Start Over

- Code written before test
- Test added after implementation
- Test passes immediately (not testing new behavior)
- Can't explain why the test failed
- "Just this once" reasoning
- "I already manually tested it"
- "Tests after are the same as tests first"
- "Keep as reference" or "adapt existing code"
- "TDD is dogmatic, I'm being pragmatic"
- "This is different because..."

## Relationship to Helm

This skill is a **quality gate** used BY helm, not a replacement for it.

- `helm` decides WHEN TDD applies (classification phase)
- `test-driven-development` enforces HOW to write code
- When `helm` classifies a task as feature work or bug fix, TDD is mandatory
- `systematic-debugging` pairs with TDD for bug fixes (debug to find cause, TDD to fix)

## Verification Checklist

Before marking any implementation task as done:

- [ ] Every new function/method has a corresponding test
- [ ] Each test was watched failing before implementation
- [ ] Each test failed for the expected reason (missing feature, not typo)
- [ ] Minimal code was written to pass each test
- [ ] All tests pass
- [ ] `bun run lint` passes with no new errors
- [ ] Tests use real code (mocks only when unavoidable)
- [ ] Edge cases and error paths are covered

Can't check all boxes? You skipped TDD. Start over.
