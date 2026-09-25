# orca-retro

## Purpose

Capture what changed, what was learned, and how future ORCA Framework work should improve.

## When To Use

Use after a release, major feature, incident, or meaningful agent workflow.

## Required Inputs

- Completed work summary

## Optional Inputs

- GitHub issue URL or number, project ID, or opt-out work item
- Review findings
- QA reports
- Release notes
- User feedback

## GitHub Context

- Expects: issue or project thread, ship checklist, QA and review comments, follow-up links
- Reads: completed scope, blockers, evidence, surprises, deferred work
- Posts: retrospective summary and follow-up recommendations
- Trigger: project completion, incident closure, major release, or requested retro
- Human approval: not required unless creating or changing follow-up scope

## Opt-Out Context

Store the retrospective in the selected record or project documentation.

## Workflow

1. Use `orca-retro`.
2. Summarize outcomes against the spec.
3. Record failures, surprises, and useful patterns.
4. Create concrete follow-up actions.
5. Sync lessons to the durable record.
6. If the session exposed reusable ORCA Framework friction or strong quality-signal evidence, run `orca-improve-framework`.

## Outputs And Artifacts

- `templates/retrospective.md`

## Failure Cases

- If evidence is missing, state the gap.
- If follow-ups are not actionable, rewrite them with owners or triggers.

## Related Commands And Skills

- Commands: `orca-onboard`, `orca-plan`, `orca-github-core`, `orca-improve-framework`
- Skills: `orca-retro`, `orca-session-improvement`, `orca-github-core`
