# orca-setup

## Purpose

Guide external tool setup for the current ORCA Framework workflow.

## When To Use

Use before a workflow depends on GitHub Issues/Projects, MCP, a host connector, a CLI helper, or another external tool. GitHub is the default work-management system.

## Required Inputs

- Current task or ORCA Framework phase
- Desired workflow

## Optional Inputs

- Harness or host
- Target service
- Preferred setup mode: quick or guided

## Workflow

1. Use `orca-tool-setup`.
2. Identify required and optional tools.
3. Explain why each required tool matters.
4. Choose the shortest safe setup path for the current harness.
5. Validate setup or provide manual validation.
6. Record fallback if setup is incomplete.

## Outputs And Artifacts

- `templates/tool-requirements.md`
- `templates/integration-status.md`
- service checklist when relevant

## Failure Cases

- If a tool is optional, do not block the workflow.
- If the harness cannot support the integration, use degraded mode.
- If auth or scope fails, report the exact missing capability.

## Related Commands And Skills

- Commands: `orca-check-setup`, `orca-validate-integration`, `orca-next`
- Skills: `orca-tool-setup`, `orca-tool-governance`
