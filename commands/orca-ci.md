# orca-ci

## Purpose

Inspect failing CI checks, extract actionable failure context, and route to the right fix workflow.

## When To Use

Use when GitHub Actions or other linked CI status is blocking a branch, PR, or release path.

## Required Inputs

- Branch, PR, or failing check context

## Optional Inputs

- GitHub issue URL or number or opt-out work item
- specific CI provider

## Workflow

1. Confirm the CI provider and auth surface.
2. Resolve the relevant PR or branch.
3. Inspect failing checks with bounded commands and helper scripts where the provider supports it.
4. Separate in-progress, infra, and code failures.
5. Propose a fix plan before implementation.

## Outputs And Artifacts

- CI triage summary
- actionable failure snippets
- recommended next command

## Failure Cases

- If auth is missing, record the exact blocker.
- If checks are still running, say the logs are incomplete.
- If the provider is not inspectable through the current tool surface, link the failure and stop at triage.
- If GitHub is the provider, prefer `skills/orca-ci/scripts/inspect_pr_checks.py` over manual log spelunking.

## Related Commands And Skills

- Commands: `orca-build`, `orca-review`, `orca-ship`
- Skills: `orca-tool-setup`, `orca-delegation`
