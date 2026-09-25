---
name: orca-blind-qa
description: Run a zero-context first-look QA pass and produce a realistic first-impression report.
---

# ORCA Framework Blind QA

## What This Skill Is

A first-look testing workflow that protects the tester from hidden project context.

## Trigger

Use when a user-facing product surface can be tested before the tester reads the spec or implementation notes.

## Do Not Trigger

Do not use after the tester has already read hidden project context. Use briefed QA instead.

## Required Inputs

- Product surface: URL, app, simulator target, CLI, or screenshot set
- Issue ID or opt-out work item identifier

## Optional Inputs

- Device or viewport
- Tool capabilities

## Exact Workflow

1. State the context received and confirm hidden context is excluded.
2. In GitHub-first mode, accept only issue ID, platform, launch instructions, and optional one-sentence mission.
3. In opt-out mode, accept only the equivalent minimal launch context.
4. Observe only exposed behavior and available accessibility-visible information.
5. Infer what the product is for.
6. Attempt plausible tasks without reading the spec.
7. Record confusion, dead ends, visual or interaction problems, and successful paths.
8. State evidence captured and what could not be observed.
9. Post or prepare the report for the same issue or work item.

## Expected Outputs

- Filled `templates/blind-qa-report.md`
- `templates/github-issue-update.md` when GitHub-first mode is active

## Quality Bar

The report should sound like a real first user, not a builder validating their own assumptions.

## Common Failure Modes

- Pretending to see UI when visual context is unavailable.
- Reading source code or specs.
- Editing the blind report after briefing.

## Relationship To Other ORCA Framework Skills And Commands

Feeds `orca-context-brief`, `orca-test-briefed`, and `orca-test-regression`.
