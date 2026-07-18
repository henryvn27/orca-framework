# Command Index

Orca exposes executable product commands and optional agent workflow definitions. They have different authority.

## Mission Control

- `orca mission create`: create the active Mission and its criteria.
- `orca mission status`: inspect readiness, blockers, evidence, and next action.
- `orca mission list`: inspect Mission history.
- `orca mission check`: run a command and record its result as criterion evidence.
- `orca mission satisfy`: attach an explicit evidence attestation.
- `orca mission block`: record why work cannot continue.
- `orca mission resume`: reopen a genuinely resolved blocker.
- `orca mission complete`: cross the completion gate.

These commands own durable state. See [Product and Workflow Commands](commands.md) for exact syntax.

## Runtime And Compatibility

- `orca help`: show command help.
- `orca backend status`: inspect the optional backend adapter.
- `orca notion`: use the optional Notion adapter.
- `orca goal`, `orca progress`, `orca unify`: use the earlier goal-loop compatibility runtime.

## Agent Workflow Definitions

Use `orca list` after install for exact workflow availability. These procedures help an executor; they do not own Mission state.

### Start

- `orca-install`: install Orca.
- `orca-doctor`: validate setup.
- `orca-help`: explain the workflow catalog.
- `orca-onboard`: clarify vague work.

## Plan And Build

- `orca-context`: resolve ambiguous repo/app/artifact context.
- `orca-research`: gather bounded evidence before planning.
- `orca-spec`: write implementation contract.
- `orca-plan`: break work into phases.
- `orca-build`: implement approved scope.

## Review And Ship

- `orca-review`: inspect implementation quality.
- `orca-ship`: finish release/handoff.
- `orca-receipt`: write compact run summary.
- `orca-checkpoint`: pause for human decision.
- `orca-status`: summarize current workflow state.
- `orca-delegate`: hand bounded work to another agent or harness.
- `orca-attribution`: check upstream credit.

## Wrapped Packs

- `orca-caveman`
- `orca-efficient-frontier`
- `orca-impeccable`
- `orca-superpowers`
- `orca-visual-plan`
- `orca-visual-recap`

Everything else is an extension, extracted tool, or candidate for a separate package—not Mission Control core.
