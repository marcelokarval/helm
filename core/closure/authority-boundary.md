# Closure And Authority Boundary

## Purpose

This document defines the native pre-agents rule for root closure authority and
bounded execution subordination.

## Root Authority

The root may:

- classify the run
- decide topology
- create issues (in docs/TASKS.md)
- open and close lanes
- choose staffing
- decide root-only mode
- perform final AI review
- enter root closure mode
- update docs/TASKS.md status to `Done`

## Bounded Authority

Task tool subagents may:

- accept a bounded slice
- mutate only within scope
- run required validations
- perform self-review and self-forensic review
- return evidence
- return evidence to master (subagent returns evidence, master updates docs/TASKS.md)

They must not:

- re-decompose the work
- create issues
- change topology
- restaff the run
- claim final closure authority
- update docs/TASKS.md status to `Done`

## Pre-Agents Reading

This boundary is already binding before real agents exist.

It governs:

- root-only runs
- future Task tool subagents
- future subagent type selections

## Authority

Detailed support still lives in:

- `references/Z.ai-agents/root-vs-agent-authority-boundary.md`
