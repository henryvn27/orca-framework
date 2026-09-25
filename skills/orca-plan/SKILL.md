---
name: orca-plan
description: Turn a spec into sequenced implementation phases with verification gates.
---

# ORCA Framework Plan

## What This Skill Is

A planning workflow for converting a spec into executable phases.

## Trigger

Use after a spec exists and before implementation begins.

## Do Not Trigger

Do not use when the user explicitly asks only for a review or explanation.

## Required Inputs

- Spec or task contract

## Optional Inputs

- GitHub issue URL/number and Project (default), or an explicitly requested Mission-only work item
- Discovery notes
- Verification commands
- Risk areas

## Exact Workflow

1. Read the spec from GitHub or the opt-out record.
2. If the scope is project-sized, split it into milestone-sized phases before discussing implementation details.
3. Break the work into small phases with one reviewable outcome each.
4. Name expected files or system areas.
5. Attach verification to each phase.
6. Identify dependencies, unblockers, and rollback points.
7. Identify whether a bounded phase is a safe goal-mode candidate.
8. Name phases in concrete project language. Avoid filler phase names like "core improvements" or "polish."
9. If the workflow should use the official wrapped Superpowers path, say so explicitly instead of implying ORCA maintains its own copy of that execution discipline.
10. End with an explicit next recommended phase to execute.
11. Produce a plan that can be posted to the issue or durable record.
12. Do a last anti-generic pass: phase names, verification, and rollback should make the diff guessable.
13. Include an explicit human approval request when required.

## Expected Outputs

- Filled `templates/plan.md`
- Goal candidate note when a phase is suitable for `orca-goal-create`
- Approval request shape from `templates/approval-request.md` when risk requires it
- `templates/github-issue-update.md` when GitHub-first mode is active

## Quality Bar

Each phase should produce a reviewable, testable state.
Another engineer should be able to picture the real change from the phase names alone.
A full-project plan should read like a sequence of real milestones, not like one giant backlog paragraph.

## Common Failure Modes

- Creating phases too broad to verify.
- Planning the whole project at once without naming the first executable slice.
- Treating manual QA as the only validation when automated checks exist.
- Missing migration or data risks.
- Using abstract project-manager language that hides what will actually change.

## Relationship To Other ORCA Framework Skills And Commands

Feeds `orca-goal-mode`, `orca-build`, `orca-review`, and `orca-ship`.
