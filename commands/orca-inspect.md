# orca-inspect

## Purpose

Produce an inspectable run summary that makes the current workflow state auditable and resumable.

## When To Use

Use when a human or another agent needs to review state before approval, after a pause, during a blocker, or before ship-readiness decisions.

## Required Inputs

- Run or work item identity

## Optional Inputs

- Shared state
- Run memory summary
- Trace summary
- Checkpoint artifacts
- QA or eval status

## GitHub Context

- Expects: issue ID, linked artifacts, current phase, blockers, checkpoint status
- Reads: shared state, run memory, traces, metrics, approvals, QA, eval, and ship artifacts
- Posts: inspection summary or linked artifact when the run needs review or resume support
- Trigger: pause, approval review, blocked run, handoff, ship readiness
- Human approval: not required to inspect, but inspection often precedes a human decision

## Opt-Out Context

Store the run inspection artifact in the chosen durable record.

## Workflow

1. Gather shared state, run memory, trace, metrics, and checkpoint context.
2. Summarize current phase, approvals, artifacts, QA status, and blockers.
3. Produce an inspection artifact that another maintainer can scan quickly.

## Outputs And Artifacts

- `templates/run-inspection.md`

## Failure Cases

- If key artifacts are missing, record the gap instead of inventing status.
- If the run identity is unclear, clarify it before inspection.

## Related Commands And Skills

- Commands: `orca-state`, `orca-checkpoint`, `orca-approve`, `orca-ship`
- Skills: `orca-shared-state`
