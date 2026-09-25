# orca-review

## Purpose

Review a change for bugs, regressions, maintainability, missing tests, and release risk.

## When To Use

Use before QA or shipping any meaningful change.

## Required Inputs

- Diff, changed files, PR, artifact, or branch

## Optional Inputs

- GitHub issue URL or number or opt-out work item
- Spec
- Plan
- Test output

## GitHub Context

- Expects: issue ID, linked branch or PR, spec, plan, verification notes
- Reads: approved scope, changed artifacts, previous blockers, acceptance criteria
- Posts: findings, severity, decision, recommended next state
- Trigger: `In Review`, `review-required`
- Human approval: required to waive blocking findings

## Opt-Out Context

Post or store the review report in the declared record.

## Workflow

1. Use `orca-review`.
2. Inspect changed behavior and adjacent contracts.
3. Prioritize findings by severity.
4. Recommend fixes or state that no blocking issues were found.
5. Sync review decision to the work item.

## Side-Session Fit

`orca-review` is a strong side-session candidate because critique usually benefits from staying separate from the main executor thread until it is time to hand back findings.

## Outputs And Artifacts

- `templates/review-report.md`
- `templates/github-issue-update.md` when GitHub-first mode is active

## Failure Cases

- If the diff is unavailable, review files and record the limitation.
- If tests were not run, list the residual risk.

## Related Commands And Skills

- Commands: `orca-design`, `orca-security`, `orca-ship`
- Skills: `orca-review`, `orca-github-core`
