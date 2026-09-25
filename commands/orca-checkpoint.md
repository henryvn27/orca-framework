# orca-checkpoint

## Purpose

Pause work at an explicit checkpoint, present inspection context, record a human decision, and resume safely.

## When To Use

Use for risky actions, ambiguous verification outcomes, architecture pivots, destructive edits, dependency changes, new or risky tool and MCP use, or ship-readiness decisions.

## Required Inputs

- Triggering risk or ambiguity
- Current state summary

## Optional Inputs

- Shared state link
- Trace summary
- Approval request link
- Tool or MCP registry entry

## GitHub Context

- Expects: issue ID, current phase, risk reason, linked evidence, active blockers
- Reads: shared state, traces, metrics, approval context, tool or MCP registry entries, QA or eval artifacts
- Posts: checkpoint request and decision artifacts or summaries
- Trigger: pause requested, approval gate escalated, resume blocked, ship confidence low
- Human approval: the command exists to gather and record that intervention explicitly

## Opt-Out Context

Store checkpoint request and decision artifacts in the chosen durable record.

## Workflow

1. Use `orca-checkpoint`.
2. Pause at a clean boundary.
3. Write the checkpoint request and inspection context.
4. Record the decision once available.
5. Resume only from the recorded decision.

## Outputs And Artifacts

- `templates/checkpoint-request.md`
- `templates/checkpoint-decision.md`

## Failure Cases

- If the checkpoint request does not state the exact decision needed, rewrite it.
- If the decision is missing, do not pretend the run has resumed cleanly.

## Related Commands And Skills

- Commands: `orca-approve`, `orca-inspect`, `orca-state`, `orca-ship`
- Skills: `orca-checkpoint`
