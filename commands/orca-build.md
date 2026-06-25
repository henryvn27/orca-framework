# orca-build

## Purpose

Implement approved scope while preserving repo patterns and verification discipline.

## When To Use

Use after a plan exists or for a small change whose plan can be stated inline.

## Required Inputs

- Spec or explicit task
- Approved implementation plan or approved small-scope request

## Optional Inputs

- Notion issue, `.orca/` task, or explicit Linear issue
- Test command
- Design constraints
- Related issue

## Backend Context

- Notion mode: update Issue Board status, blockers, verification evidence, branch or PR links, and review handoff.
- Markdown mode: update `.orca/issues.md`, `.orca/runs/`, and `.orca/handoffs/`.
- Linear mode: sync comments only when explicitly active.
- Human approval: required before starting if approval gate is missing.

## Workflow

1. Use `orca-build`.
2. Confirm approval if required.
3. For non-trivial repo edits, follow `docs/version-control.md` before implementation: inspect repo root/status/current/default branch, preserve unrelated dirty work, and use a scoped non-protected branch.
4. Read relevant files before editing.
5. Make scoped changes, including realistic loading, empty, and error states for user-facing async surfaces.
6. If the execution workflow clearly benefits from Superpowers and the pack is available or desired, route that segment through `orca-superpowers` instead of cloning the upstream discipline locally.
7. Run verification after meaningful phases.
8. Update the work item with evidence, branch or PR links, and remaining risks.

## Outputs And Artifacts

- Code or content changes
- Verification notes
- Updated plan when applicable
- Notion issue update when active
- `.orca/` run/handoff update when markdown fallback is active
- Linear sync comments when explicitly active

## Failure Cases

- If unrelated dirty changes exist, preserve them.
- If current branch is protected, branch before editing.
- If tests fail, diagnose before claiming completion.
- If scope changes, return to planning and approval.
- If new async UI loads data, do not ship a blank gap when a skeleton frame or equivalent placeholder should exist.

## Related Commands And Skills

- Commands: `orca-linear-sync`, `orca-review`, `orca-superpowers`, `orca-test-blind`
- Skills: `orca-build`, `orca-superpowers`, `orca-linear-executor`
