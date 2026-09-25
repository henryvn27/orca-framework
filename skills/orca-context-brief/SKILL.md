---
name: orca-context-brief
description: Create bounded context packets for briefed QA and layered retesting.
---

# ORCA Framework Context Brief

## What This Skill Is

A workflow for preparing limited context packets after blind QA.

## Trigger

Use before briefed QA, targeted retesting, or regression testing.

## Do Not Trigger

Do not use before the blind pass is complete unless blind QA has been explicitly waived.

## Required Inputs

- QA goal
- Context source

## Optional Inputs

- Blind QA report
- Acceptance criteria
- Known fixes

## Exact Workflow

1. Define the pass type: blind, briefed, or informed.
2. Read the GitHub issue or opt-out record only after the blind pass is saved, unless blind QA was waived.
3. List included context.
4. List withheld context.
5. Include only what the tester needs for the pass.
6. State contamination risk and allowed tools.
7. Tie the packet to the same issue or work item as the first pass.

## Expected Outputs

- Context packet embedded in `templates/guided-qa-report.md`, `templates/github-issue-update.md`, or a standalone brief

## Quality Bar

The packet should be small, explicit, and impossible to confuse with full project context.

## Common Failure Modes

- Including implementation details for a user-flow retest.
- Omitting what was withheld.
- Reusing blind terminology after briefing.

## Relationship To Other ORCA Framework Skills And Commands

Feeds `orca-test-briefed`, `orca-web-qa`, and `orca-ios-sim-qa`.
