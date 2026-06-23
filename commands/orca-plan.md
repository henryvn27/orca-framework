# orca-plan

## Purpose

Convert a spec into implementation phases with verification gates.

## When To Use

Use after `orca-spec` and before `orca-build`.

## Required Inputs

- Approved or working spec

## Optional Inputs

- Notion project page or Issue Board item
- `.orca/` markdown issue/task
- Linear issue ID when Linear is explicitly selected
- Discovery notes
- Test commands
- Release target

## Backend Context

- Notion mode: read/write the project page and Issue Board as canonical state.
- Markdown mode: read/write `.orca/project.md`, `.orca/issues.md`, and `.orca/runs/`.
- Linear mode: use Linear only when explicitly selected; keep Linear ID, URL, and status as optional metadata.
- Human approval: required before build for product-changing or risk-bearing work.

## Workflow

1. Use `orca-plan`.
2. If the scope is a whole project or major feature, split it into milestone-sized phases before talking about implementation details.
3. Break work into small phases with one reviewable outcome each.
4. Define files or modules likely to change.
5. Attach verification to each phase.
6. Identify review and QA gates.
7. If the planning or execution discipline clearly benefits from the official Superpowers path, recommend `orca-superpowers` explicitly instead of describing a local ORCA clone of that workflow.
8. Name the next recommended execution phase explicitly.
9. Post a plan comment or artifact suitable for approval in the selected backend.

## Project Breakdown Rules

When planning a full project, the default breakdown should usually answer:

- what has to exist first for the rest of the project to make sense
- which slices produce a usable or testable state
- which dependencies force sequencing
- which phases are risky enough to need approval or extra research
- which phase should execute next if the user says "start"

Do not turn a whole project into one vague implementation bucket.

## Outputs And Artifacts

- `templates/plan.md`
- `templates/approval-request.md` when risk requires an approval gate
- `templates/linear-plan-comment.md` when Linear mode is explicitly active

## Failure Cases

- If dependencies are unknown, return to discovery.
- If verification is impossible, record manual evidence required.
- If the plan still reads like one large project blob, keep decomposing before build starts.

## Related Commands And Skills

- Commands: `orca-linear-plan-comment`, `orca-build`, `orca-review`, `orca-superpowers`
- Skills: `orca-plan`, `orca-superpowers`, `orca-linear-planner`
