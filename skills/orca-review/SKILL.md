---
name: orca-review
description: Review changes for bugs, regressions, maintainability, tests, and release risk.
---

# ORCA Framework Review

## What This Skill Is

A code and artifact review workflow.

## Trigger

Use before QA or release, or when the user asks for a review.

## Do Not Trigger

Do not use as a substitute for blind QA.

## Required Inputs

- Diff, changed files, or artifact set

## Optional Inputs

- Spec
- Test output
- Risk notes

## Exact Workflow

1. Read approved scope, diff, and verification evidence from GitHub or the opt-out record.
2. Inspect changed behavior and contracts.
3. Identify likely bugs and regressions.
4. Check test and validation coverage.
5. Prioritize findings by severity.
6. Write findings in direct engineering language. Do not pad with generic praise or process filler.
7. Anchor each non-trivial finding to a concrete location (file path, route, command, or screenshot).
7. Post or prepare a review comment with decision and next gate.
8. State residual risk when no blocking findings exist.

## Expected Outputs

- Filled `templates/review-report.md`
- `templates/github-issue-update.md` when GitHub-first mode is active

## Quality Bar

Findings must be actionable, grounded in evidence, and ordered by impact.
The report should read like a real reviewer, not like a model smoothing the conversation.

## Common Failure Modes

- Summarizing instead of reviewing.
- Reporting style preferences as defects.
- Missing tests for behavior changes.
- Using vague review language that hides the actual bug or risk.

## Relationship To Other ORCA Framework Skills And Commands

Pairs with `orca-design`, `orca-security`, and `orca-ship`.
