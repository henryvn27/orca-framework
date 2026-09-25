# orca-regression-task

## Purpose

Turn a QA, review, bug, or debugging finding into a structured regression candidate or reusable regression task.

## When To Use

Use when a finding is important enough that the same issue should be less likely to be rediscovered manually.

## Required Inputs

- Source finding
- Affected surface

## Optional Inputs

- Related issue or GitHub issue
- Fix summary
- Reproduction evidence

## GitHub Context

- Expects: issue ID, source finding, QA or review comment, affected surface, related fix if available
- Reads: prior QA reports, regression scope, acceptance criteria, debugging notes
- Posts: regression candidate or promoted regression task linked back to the original finding
- Trigger: meaningful QA or review finding, repeated bug, high-value risk area
- Human approval: required before investing in high-cost automation for a fragile scenario

## Opt-Out Context

Store the regression candidate or task in the chosen durable record and link it to the source finding.

## Workflow

1. Use `orca-regression-task`.
2. Capture the source finding as a regression candidate.
3. Classify it as test now, backlog, or watch only.
4. If promoted, define deterministic reproduction and verification steps.
5. Record automation level and fragility risk.

## Outputs And Artifacts

- `templates/regression-candidate.md`
- `templates/regression-task.md`

## Failure Cases

- If the finding is too vague to reproduce, keep it as a candidate instead of a full regression task.
- If the scenario is unstable, bias toward manual or watch-only treatment.

## Related Commands And Skills

- Commands: `orca-test-blind`, `orca-test-briefed`, `orca-test-regression`, `orca-review`
- Skills: `orca-regression-task`
