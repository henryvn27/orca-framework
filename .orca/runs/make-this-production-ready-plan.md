# ORCA Goal Plan

Goal: make this production ready

Workflow: clarify -> plan -> apply -> unify -> loop pack -> readiness score -> handoff

Backend defaults:

- PM/docs/issues: Notion when configured
- Fallback: `.orca/` markdown
- Linear: optional adapter only

## Clarify

Ask only for missing success criteria, scope boundaries, repo/path, backend choice, test/build commands, and do-not-touch areas.

## Acceptance-Driven Tasks

| Task | Files | Action | Verify | Done | ACs |
| --- | --- | --- | --- | --- | --- |
| T1 | README.md, bin/orca, .orca/* | Make `/goal` the primary workflow with durable state | `orca progress` | State exists and names next action | AC-1, AC-6 |
| T2 | .orca/issues.md, .orca/runs/* | Track files/action/verify/done/ACs | Review generated plan | Tasks are executable and checkable | AC-task |
| T3 | .orca/packs/* | Run selected loop pack and readiness scoring | `orca unify` | Score and handoff written | AC-pack |

## Loop Pack: release-ready

- [ ] test: goal, measurement, action, stop condition, budget, handoff
- [ ] architecture: goal, measurement, action, stop condition, budget, handoff
- [ ] code-hygiene: goal, measurement, action, stop condition, budget, handoff
- [ ] docs-sync: goal, measurement, action, stop condition, budget, handoff
- [ ] security: goal, measurement, action, stop condition, budget, handoff
- [ ] pr-readiness: goal, measurement, action, stop condition, budget, handoff

## Stop Conditions

- acceptance criteria satisfied
- no ready issues remain
- repeated test/build failure
- confidence below threshold
- credentials/context missing
- diff/time/cycle budget reached
- user approval required
