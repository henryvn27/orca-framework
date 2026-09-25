# orca-security

## Purpose

Review security-relevant behavior, data handling, permissions, dependencies, installers, CI, and unsafe agent instructions.

## When To Use

Use for auth, payments, personal data, external calls, install scripts, CI, generated code execution, or public release.

## Required Inputs

- Changed files or target system

## Optional Inputs

- GitHub issue URL or number or opt-out work item
- Threat model
- Dependency list
- Deployment environment

## GitHub Context

- Expects: issue ID, changed surface, risk labels, linked PR or diff, deployment context
- Reads: data handling, permissions, external calls, install and CI changes, prior findings
- Posts: security findings, severity, mitigation, release blocker status
- Trigger: `security-review`, auth/data/payment/install/CI labels, `Ready to Ship`
- Human approval: required to waive security blockers

## Opt-Out Context

Post the security findings to the selected record.

## Workflow

1. Use `orca-security`.
2. Identify assets, trust boundaries, inputs, outputs, and dangerous operations.
3. Inspect implementation and docs for unsafe claims, untrusted content handling, and prompt-injection risk.
4. Produce findings with severity and mitigation.
5. Sync blocker status to the work item.

## Outputs And Artifacts

- Security section in `templates/review-report.md`
- Release blocker list when needed

## Failure Cases

- If environment details are missing, record assumptions.
- If a vulnerability is likely, recommend private disclosure handling.

## Related Commands And Skills

- Commands: `orca-security-check`, `orca-review`, `orca-ship`, `orca-ship`
- Skills: `orca-security`, `orca-github-core`
