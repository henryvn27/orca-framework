# orca-check-setup

## Purpose

Check whether external tools needed by the current workflow are connected, missing, misconfigured, unavailable, or available through fallback.

## When To Use

Use before starting a phase that needs GitHub Issues/Projects, MCP, host connectors, or CLI helpers.

## Required Inputs

- Current workflow or phase
- Services to check

## Optional Inputs

- Harness or host
- Required actions

## Workflow

1. List required and optional services.
2. Check available harness capabilities.
3. Validate service reachability and auth when possible.
4. Classify each service status.
5. State whether the workflow can continue.

## Outputs And Artifacts

- `templates/tool-requirements.md`
- `templates/integration-status.md`

## Failure Cases

- If validation cannot be automated, provide manual validation steps.
- If direct integration is unavailable, state fallback behavior.

## Related Commands And Skills

- Commands: `orca-setup`, `orca-validate-integration`
- Skills: `orca-tool-setup`
