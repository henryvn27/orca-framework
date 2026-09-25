# orca-spec

## Purpose

Create the implementation contract for a project, feature, or fix.

## When To Use

Use after onboarding or discovery, and before planning non-trivial implementation.

## Required Inputs

- Goal
- User or system behavior
- Constraints

## Optional Inputs

- GitHub issue URL or number or opt-out work item
- Intake summary
- Discovery notes
- Research brief

## GitHub Context

- Expects: issue title, description, comments, labels, state, project, links, and related issues
- Reads: user request, clarified scope, constraints, previous questions, non-goals
- Posts: spec comment or linked spec artifact, open questions, recommended `Spec Ready` state
- Trigger: `Ready for Spec`, `needs-spec`, or issue delegated to a spec agent
- Human approval: required before build when the spec changes product behavior, data, security, billing, or public UX

## Opt-Out Context

Write the spec to `templates/spec.md` or an equivalent artifact and reference it from the chosen work item.

## Workflow

1. Use `orca-spec`.
2. Define goal, users, scenarios, requirements, non-goals, acceptance criteria, and risks, including loading behavior for user-facing async work.
3. Separate confirmed facts from assumptions.
4. Ask for approval when the spec changes project direction.
5. Post or attach the spec to the work item.

## Outputs And Artifacts

- `templates/spec.md`
- `templates/contracts/spec-contract.md`
- `templates/github-issue-update.md` when GitHub-first mode is active

## Failure Cases

- If acceptance criteria cannot be tested, revise them.
- If scope is too broad, split into separate work items.

## Related Commands And Skills

- Commands: `orca-plan`, `orca-plan`, `orca-research`
- Skills: `orca-spec`, `orca-github-core`
