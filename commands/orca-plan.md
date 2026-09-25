# orca-plan

## Purpose

Convert a spec into implementation phases with verification gates.

## When To Use

Use after `orca-spec` and before `orca-build`.

## Required Inputs

- Approved or working spec

## Optional Inputs

- GitHub issue URL/number and Project (default)
- `.orca/` Mission only when the user explicitly chooses local-only tracking
- Optional linked Notion project page
- Discovery notes
- Test commands
- Release target

## Backend Context

- GitHub mode: read the issue and Project as canonical queue/status; record the plan and dependencies on the issue when useful.
- Mission-only mode: read/write `.orca/project.md`, `.orca/issues.md`, and `.orca/runs/` only when the user explicitly chooses local-only tracking.
- Notion remains an optional linked reference, not the engineering source of truth.
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
9. Post a plan comment or link a plan artifact on the GitHub issue for review; preserve any required human approval gate.

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
- `templates/github-issue-update.md` for a substantive issue update

## Failure Cases

- If dependencies are unknown, return to discovery.
- If verification is impossible, record manual evidence required.
- If the plan still reads like one large project blob, keep decomposing before build starts.

## Related Commands And Skills

- Commands: `orca-plan`, `orca-build`, `orca-review`, `orca-superpowers`
- Skills: `orca-plan`, `orca-superpowers`, `orca-github-core`
