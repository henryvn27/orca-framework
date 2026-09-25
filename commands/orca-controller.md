# orca-controller

## Purpose

Run ORCA Framework in controller-agent mode for orientation, routing, delegation, and ingestion.

## When To Use

Use when a controller agent is entering a project, checking state, deciding the next move, or managing multi-harness execution.

## Required Inputs

- repository state or work-item identity

## Optional Inputs

- active harness
- latest receipt
- latest orientation artifact

## GitHub Context

- Expects: issue or project context, active state, latest linked artifacts, and delegation history when GitHub-first mode is active
- Reads: current work item, blockers, approvals, and prior executor returns
- Posts: controller-state summary or next-step note when a coordinating comment is needed
- Human approval: not required for orientation alone; required before risky delegated execution when the approval gate says so

## Opt-Out Context

Use the chosen work record as the controller source of truth and keep delegation decisions linked there.

## Workflow

1. Use `orca-controller-mode`.
2. Read `HVN-STATUS.md` and the latest orientation or inspection artifacts.
3. Determine the active phase, missing artifacts, and blockers.
4. Decide whether to execute directly or delegate.
5. If delegated work returns, route to ingestion.

## Outputs And Artifacts

- project orientation snapshot
- delegation decision
- next-step recommendation

## Related Commands And Skills

- Commands: `orca-orient`, `orca-status`, `orca-next`, `orca-delegate`, `orca-ingest`
- Skills: `orca-controller-mode`
