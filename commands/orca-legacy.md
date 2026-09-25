# orca-legacy

## Purpose

Audit and prepare a legacy system for staged modernization.

## When To Use

Use for inherited repos, older applications, under-documented systems, fragile modules, or modernization requests where behavior must be preserved.

## Required Inputs

- Repository, module, system, or work item
- Modernization goal or pain point

## Optional Inputs

- Known risky flows
- Test commands
- Runtime or deployment context
- Existing architecture notes

## GitHub Context

- Expects: issue ID, target repo or module, modernization goal, constraints, labels, linked incidents or docs
- Reads: issue history, existing docs, prior QA or regression findings, test evidence, deployment context
- Posts: legacy audit, risk report, modernization spec, recommended first slice, and blockers
- Trigger: modernization request, fragile legacy area, inherited repo, low-confidence change request
- Human approval: required before modernization work changes behavior, dependencies, data, or deployment paths

## Opt-Out Context

Write the audit and modernization artifacts to the selected durable record.

## Workflow

1. Use `orca-legacy`.
2. Perform repo archaeology and reverse engineering.
3. Map dependencies, call chains, modules, and key flows.
4. Extract business logic hotspots and undocumented assumptions.
5. Identify fragile areas, test gaps, and migration risks.
6. Create a modernization spec for the first safe slice.
7. Generate regression candidates for behavior that must be preserved.

## Outputs And Artifacts

- `templates/legacy-audit.md`
- `templates/legacy-risk-report.md`
- `templates/modernization-spec.md`

## Failure Cases

- If the system cannot be inspected, record access blockers.
- If behavior cannot be verified, pause before recommending implementation.
- If the requested change implies a broad rewrite, narrow it into staged slices.

## Related Commands And Skills

- Commands: `orca-discover`, `orca-spec`, `orca-plan`, `orca-regression-task`, `orca-review`
- Skills: `orca-legacy`, `orca-discover`, `orca-regression-task`
