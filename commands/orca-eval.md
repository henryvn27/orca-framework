# orca-eval

## Purpose

Evaluate an ORCA Framework workflow or run using trajectory-aware checks instead of grading only the final artifact.

## When To Use

Use when validating framework changes, comparing command quality, or reviewing whether a workflow behaves reliably.

## Required Inputs

- Eval case or eval set
- Target command, skill, or workflow

## Optional Inputs

- Trace artifacts
- Spec, plan, QA, review, or ship artifacts
- Prior eval report

## GitHub Context

- Expects: issue or project context when the eval is tied to a real work item
- Reads: linked artifacts, traces, approval records, and QA evidence
- Posts: eval summary and linked report when it affects framework confidence or release readiness
- Trigger: framework change, command regression concern, release-candidate review
- Human approval: required only if the eval outcome is being used to waive a known risk

## Opt-Out Context

Store the eval report in the selected system of record and link it from the work item when relevant.

## Workflow

1. Use `orca-eval`.
2. Load the eval case or starter eval set.
3. Review the full trajectory and artifacts.
4. Score hard checks and rubric dimensions.
5. Write a human-reviewable report with recommendations.

## Outputs And Artifacts

- `templates/eval-case.md`
- `templates/eval-report.md`
- `templates/contracts/eval-contract.md`

## Failure Cases

- If the eval case is underspecified, rewrite it before scoring.
- If only final output exists and no trajectory evidence exists, record limited confidence.

## Related Commands And Skills

- Commands: `orca-trace`, `orca-review`, `orca-ship`
- Skills: `orca-eval`, `orca-observability`
