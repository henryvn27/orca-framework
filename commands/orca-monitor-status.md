# orca-monitor-status

## Purpose

Emit or refresh the local Orca Monitor-facing ORCA Framework status snapshot.

## When To Use

Use when workflow state materially changes and Orca Monitor should see the current ORCA context without parsing internal artifacts.

## Required Inputs

- current project or repository identity

## Optional Inputs

- workflow
- step
- status: `idle`, `running`, `blocked`, `failed`, or `completed`
- queue count
- failing check count
- latest receipt path
- recent model/provider/token entries when ORCA already knows them cheaply

## GitHub Context

- Reads: current issue or project state when GitHub-first mode is active
- Posts: no GitHub update required
- Trigger: status transition, blocker transition, queue change, failing-check change, receipt creation
- Human approval: not required for local status export

## Opt-Out Context

Read the selected durable local record or linked artifact and write the same local JSON snapshot.

## Workflow

1. Read current runtime status, shared state, goal status, receipts, and workflow metrics when available.
2. Prefer explicit current-transition inputs over stale artifact values.
3. Build the smallest valid snapshot.
4. Omit optional fields that ORCA does not already know.
5. Write the per-project snapshot at `$HOME/.orca-framework/projects/orca-monitor/status.json`.
6. If configured, also write `$HOME/.orca-framework/state/orca-monitor.json`.
7. Use atomic same-directory temp-file replacement.

## Outputs And Artifacts

- `$HOME/.orca-framework/projects/orca-monitor/status.json`
- optional `$HOME/.orca-framework/state/orca-monitor.json`
- schema: `schema/versions/v1/orca-monitor-status.schema.json`

## Failure Cases

- If no active run is known, emit an idle snapshot.
- If filesystem writes fail, report the path and continue without remote fallback.
- If model usage is unavailable, omit `recent_models`.
- If a value would require reading hosted billing/account state, omit it.

## Related Commands And Skills

- Commands: `orca-state`, `orca-status`, `orca-goal-status`, `orca-background-status`, `orca-receipt`, `orca-metrics`
- Docs: `docs/orca-monitor-status.md`
