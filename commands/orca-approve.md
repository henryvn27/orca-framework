# orca-approve

## Purpose

Request, record, or review approval for risky work before execution continues.

## When To Use

Use for destructive actions, broad refactors, installer changes, dependency upgrades, production-risk changes, unreviewed or high-risk tool and MCP use, scope expansion, or low-confidence ship decisions.

## Required Inputs

- Proposed action
- Risk and scope summary

## Optional Inputs

- Spec or plan link
- Verification and rollback plan
- Deadline or blocker note
- Tool or MCP registry entry

## GitHub Context

- Expects: issue ID, spec or plan context, risk labels, current state, affected systems
- Reads: approved scope, prior decisions, linked artifacts, release context
- Posts: approval request or decision record to the issue
- Trigger: risky action detected, approval pending, ship confidence low
- Human approval: this command exists to make that approval explicit

## Opt-Out Context

Write the approval request to the selected record and do not proceed until the required decision exists.

## Workflow

1. Use `orca-approval-gate`.
2. Classify the action and blast radius.
3. Decide whether approval is required.
4. If required, write the request with clear scope, alternatives, and rollback.
5. Record approval, denial, or delay and the safe next step.

## Outputs And Artifacts

- `templates/approval-request.md`

## Failure Cases

- If the action is already approved, link the prior decision.
- If the scope is unclear, narrow it before requesting approval.

## Related Commands And Skills

- Commands: `orca-tool-review`, `orca-mcp-review`, `orca-plan`, `orca-build`, `orca-ship`
- Skills: `orca-approval-gate`, `orca-tool-governance`
