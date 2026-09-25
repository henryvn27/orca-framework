# orca-state

## Purpose

Create or update shared state for a run or work item so cooperating roles can work from the same current context.

## When To Use

Use when planner, builder, reviewer, QA, or coordinator roles need a common phase, scope, blocker, or artifact view.

## Required Inputs

- Work item or run ID
- Current phase or coordination need

## Optional Inputs

- Scope summary
- Role ownership
- Checkpoint status
- Artifact links

## GitHub Context

- Expects: issue ID, active phase, linked artifacts, blockers, role ownership
- Reads: spec, plan, trace, metrics, checkpoint, QA, or eval artifacts
- Posts: shared-state artifact or summary when multi-role coordination matters
- Trigger: handoff, multi-agent split, pause-and-resume, blocked execution
- Human approval: not required to maintain state, but checkpoint fields must reflect human decisions accurately

## Opt-Out Context

Store shared state in the selected durable record or linked artifact.

## Workflow

1. Use `orca-shared-state`.
2. Record current phase, scope, ownership, blockers, and checkpoint status.
3. Link the active artifacts.
4. Keep the state concise and current.

## Outputs And Artifacts

- `templates/shared-state.md`

## Failure Cases

- If ownership is unclear, record the ambiguity instead of guessing.
- If state conflicts exist, preserve both views and escalate when needed.

## Related Commands And Skills

- Commands: `orca-checkpoint`, `orca-inspect`, `orca-trace`
- Skills: `orca-shared-state`
