# orca-discover

## Purpose

Inspect an existing codebase, product surface, or technical environment before planning work.

## When To Use

Use before changing an existing project or when constraints are unknown.

## Required Inputs

- Repository path, app URL, product surface, GitHub issue, or opt-out work item

## Optional Inputs

- Known problem area
- Test commands
- Architecture notes

## GitHub Context

- Expects: issue ID, target repo or surface, relevant links, labels, state, and comments
- Reads: requested scope, linked PRs, existing artifacts, platform labels
- Posts: discovery summary, risks, verification commands, recommended next state
- Trigger: `Ready for Spec`, `needs-discovery`, `needs-plan`, or unclear implementation surface
- Human approval: not required unless discovery changes issue scope

## Opt-Out Context

Write discovery notes to the selected artifact location and link or reference them from the work item.

## Workflow

1. Use `orca-discover`.
2. Inspect structure, dependencies, scripts, tests, and relevant files.
3. Identify ownership boundaries and existing patterns.
4. Record risks, constraints, and recommended next steps.
5. Sync findings to GitHub or the opt-out record.

## Outputs And Artifacts

- `templates/discovery-notes.md`
- GitHub discovery comment when active

## Failure Cases

- If files or tools are inaccessible, record the access blocker.
- If the project is empty, recommend `orca-onboard` or `orca-spec`.

## Related Commands And Skills

- Commands: `orca-legacy`, `orca-research`, `orca-spec`, `orca-plan`
- Skills: `orca-discover`, `orca-legacy`, `orca-github-core`
