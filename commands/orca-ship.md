# orca-ship

## Purpose

Prepare a change for release with final validation, handoff, done-state evidence, and rollback notes.
This is also the official ORCA ship lane for Apple app release ops and web deploy handoff.

## When To Use

Use after implementation, review, QA, and required fixes are complete.

## Required Inputs

- Completed change summary
- Verification evidence

## Optional Inputs

- Linear issue ID or opt-out work item
- Release notes
- Version target
- Deployment procedure
- platform target such as TestFlight, App Store Connect, or Vercel

## Linear Context

- Expects: issue ID, spec, plan approval, implementation evidence, review, QA, security status, linked artifacts
- Reads: the full issue thread and linked release evidence
- Posts: ship readiness checklist, known risks, rollback guidance, done recommendation or blockers
- Trigger: `Ready to Ship`, `ready-to-ship`
- Human approval: required when release ownership or risk acceptance is manual

## Opt-Out Context

Write ship readiness to the chosen record before marking work complete.

## Workflow

1. Use `orca-ship`.
2. Confirm acceptance criteria and gates.
3. Identify the ship target and release lane.
4. Run final validation.
5. For Apple releases, keep these states separate:
   - local build passed
   - archive created
   - export created
   - uploaded
   - processed or visible
   - distributed
6. For web deploys, keep preview and production distinct and default to preview unless production is explicitly intended.
7. For repo changes, follow `docs/version-control.md`: review diff, stage scoped files only, commit, push, open or update the PR, check PR status, and merge only when policy/checks/risk allow.
8. Prepare release notes and rollback guidance.
9. Identify follow-up issues.
10. Recommend done only with evidence.

## Outputs And Artifacts

- `templates/ship-checklist.md`
- `templates/linear-ship-comment.md` when Linear-first mode is active
- Release summary

## Failure Cases

- If a gate is incomplete, stop and route to the relevant command.
- If validation cannot run, record the exact blocker.
- If upload or deploy evidence is missing, do not call the release complete.
- If branch protection or PR checks block merge, record the blocker and leave the branch/PR ready.

## Related Commands And Skills

- Commands: `orca-linear-ship-check`, `orca-retro`, `orca-test-regression`
- Skills: `orca-ship`, `orca-linear-release`
