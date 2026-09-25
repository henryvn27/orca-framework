# orca-trace

## Purpose

Create a practical run trace for a meaningful ORCA Framework session, phase, or handoff.

## When To Use

Use for non-trivial runs, debugging, risky execution, handoff-heavy work, and eval preparation.

## Required Inputs

- Work item or durable record
- Run or phase to trace

## Optional Inputs

- Session metadata
- Timing data
- Token or cost data

## GitHub Context

- Expects: issue ID, project, command or skill used, linked artifacts, notable decisions
- Reads: issue comments, linked specs, plans, QA reports, and relevant evidence
- Posts: trace summary and linked trace artifact when the run matters to project state
- Trigger: handoff requested, debugging needed, eval requested, or risky run completed
- Human approval: not usually required to write a trace

## Opt-Out Context

Write the trace as a durable artifact and link it from the chosen work item.

## Workflow

1. Use `orca-observability`.
2. Record run identity, work identity, context read, major steps, and tools used.
3. Record decisions, failures, retries, and stop reason.
4. Keep the trace concise and secret-safe.

## Outputs And Artifacts

- `templates/run-trace.md`
- `templates/contracts/trace-contract.md`

## Failure Cases

- If the run is too small to justify a trace, say so explicitly.
- If timing or token data is unavailable, leave optional metadata blank.

## Related Commands And Skills

- Commands: `orca-eval`, `orca-review`, `orca-ship`
- Skills: `orca-observability`
