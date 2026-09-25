# orca-metrics

## Purpose

Record time, retries, and optional token, cache, or cost signals for an ORCA Framework workflow run.

## When To Use

Use for meaningful runs, eval passes, QA-heavy workflows, repeated tasks, or any situation where efficiency and retry burden matter.

## Required Inputs

- Workflow type
- Run or issue ID

## Optional Inputs

- Token or cost data
- Cached-token or cache-read signals
- Retry breakdown by stage
- Trace artifact

## GitHub Context

- Expects: issue ID, workflow stage, trace or artifact links, outcome state
- Reads: traces, QA reports, review findings, and run notes
- Posts: metrics summary when the run contributes to workflow analysis or release confidence
- Trigger: meaningful run complete, blocked run, repeated retries, eval or benchmark review
- Human approval: not required to record metrics

## Opt-Out Context

Store workflow metrics in the chosen durable record or linked artifact.

## Workflow

1. Use `orca-accounting`.
2. Record run timing and status.
3. Record retries and stage burden.
4. Record token, cache, or cost fields only with honest confidence.
5. Write the metrics artifact.

## Outputs And Artifacts

- `templates/workflow-metrics.md`

## Failure Cases

- If exact usage or cache data is unavailable, mark it estimated or unavailable.
- If retries are unclear, record the uncertainty instead of pretending precision.

## Related Commands And Skills

- Commands: `orca-trace`, `orca-eval`, `orca-review`
- Skills: `orca-accounting`
