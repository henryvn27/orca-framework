# orca-orient

## Purpose

Produce a fast project-orientation artifact for humans or controller agents entering the repository.

## When To Use

Use at project entry, resume, handoff, or before delegation.

## Required Inputs

- repository state

## Optional Inputs

- active work item
- latest receipt
- latest goal contract

## GitHub Context

- Expects: issue or project context, current status, and linked artifacts when GitHub-first mode is active
- Reads: issue scope, blockers, approvals, receipts, and latest comments
- Posts: orientation summary only when the parent workflow needs a durable current-state note
- Human approval: not required

## Opt-Out Context

Write the orientation against the chosen local work record or artifact set.

## Workflow

1. Read `HVN-STATUS.md`.
2. Gather current phase, active work item, goal, required integrations, blockers, and missing artifacts.
3. Write the orientation summary using `templates/project-orientation.md`.
4. Recommend the next action or next command.

## Outputs And Artifacts

- `templates/project-orientation.md`

## Related Commands And Skills

- Commands: `orca-status`, `orca-inspect`, `orca-next`
- Skills: `orca-controller-mode`
