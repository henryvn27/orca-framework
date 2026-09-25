# orca-test-regression

## Purpose

Verify fixes and ensure nearby behavior did not regress.

## When To Use

Use after changes responding to review, QA, bug reports, or release blockers.

## Required Inputs

- Fix summary
- Affected flows

## Optional Inputs

- GitHub issue URL or number or opt-out work item
- Previous QA reports
- Test commands
- Acceptance criteria

## GitHub Context

- Expects: issue ID, original finding, fix summary, linked PR or commit, affected flows
- Reads: prior review and QA comments, acceptance criteria, regression scope
- Posts: regression result, adjacent coverage, remaining risk, recommended next state
- Trigger: `regression`, `fix-ready`, reopened QA finding
- Human approval: required to accept unresolved regression risk

## Opt-Out Context

Store regression evidence in the chosen record.

## Workflow

1. Reproduce the original issue when possible.
2. Verify the fix.
3. Test adjacent flows.
4. Record remaining risk and evidence.
5. Sync the result to the work item.

## Outputs And Artifacts

- `templates/regression-report.md`
- `templates/contracts/regression-pack-contract.md`

## Failure Cases

- If the original issue cannot be reproduced, state why.
- If adjacent flows are unknown, inspect discovery notes or ask for scope.

## Related Commands And Skills

- Commands: `orca-regression-task`, `orca-review`, `orca-github-core`, `orca-ship`
- Skills: `orca-regression-task`, `orca-web-qa`, `orca-ios-sim-qa`, `orca-github-core`
