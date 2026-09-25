---
name: orca-spec
description: Convert intent, discovery, and research into a clear implementation specification.
---

# ORCA Framework Spec

## What This Skill Is

A spec-writing workflow that creates the contract for implementation and QA.

## Trigger

Use before non-trivial implementation.

## Do Not Trigger

Do not use for tiny mechanical edits where acceptance is obvious and low-risk.

## Required Inputs

- Goal
- User or system behavior
- Constraints

## Optional Inputs

- GitHub issue URL/number and Project (default), or an explicitly requested Mission-only work item
- Intake summary
- Discovery notes
- Research brief

## Exact Workflow

1. Read GitHub issue context or the opt-out work item.
2. Define the problem and target users.
3. Write goals, non-goals, flows, requirements, edge cases, and acceptance criteria.
4. For user-facing async work, specify what appears during loading, when skeleton frames are expected, and what eventually replaces them.
5. Identify assumptions and unresolved questions.
6. Confirm that each acceptance criterion is testable.
7. Rewrite generic category language into the real product, user, data, and system language from the task.
8. Run `docs/human-voice.md` rewrite test: cut filler, name constraints, and leave uncertainty explicit instead of smoothing it away.
9. Format the result for a GitHub spec comment or durable opt-out artifact.
10. State whether human approval is required before planning or build.

## Expected Outputs

- Filled `templates/spec.md`
- Follows `templates/contracts/spec-contract.md`
- `templates/github-issue-update.md` when GitHub-first mode is active

## Quality Bar

A builder and reviewer should reach the same interpretation of done.
The spec should read like it belongs to this product and repo, not like a reusable startup template with names swapped in.

## Common Failure Modes

- Writing implementation details as goals.
- Missing non-goals.
- Creating acceptance criteria that cannot be verified.
- Hiding weak understanding behind polished but generic prose.

## Relationship To Other ORCA Framework Skills And Commands

Feeds `orca-plan`, `orca-goal-mode`, `orca-plan`, `orca-review`, and briefed QA.
