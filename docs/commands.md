# Commands

ORCA commands are Markdown workflow definitions in `commands/`.

Use the launcher as source of truth:

```sh
orca goal "Ship the next safe slice" --pack release-ready
orca list
orca show orca-build
orca run orca-build --print -- "Implement the approved plan"
```

`orca goal` and `orca /goal` are launcher subcommands, not Markdown command prompt files. They create/update ORCA state, issue rows, loop evidence, readiness score, and handoff artifacts.

## Core Workflow

- `orca-install`
- `orca-doctor`
- `orca-onboard`
- `orca-spec`
- `orca-plan`
- `orca-build`
- `orca-review`
- `orca-ship`
- `orca-receipt`

## Context And Coordination

- `orca-context`
- `orca-research`
- `orca-delegate`
- `orca-status`
- `orca-checkpoint`
- `orca-attribution`
- `orca-help`

## Thin Wrapped Packs

- `orca-caveman`
- `orca-efficient-frontier`
- `orca-impeccable`
- `orca-superpowers`
- `orca-taste`
- `orca-visual-plan`
- `orca-visual-recap`

## Removed From ORCA Core

Background/Linear/test/update/design/security/demo/benchmark/corpus/graph/vendor commands were removed or moved to HVN Stack. `/goal` remains the primary launcher workflow in `bin/orca`. Use `https://github.com/henryvn27/hvn-stack` for Henry-specific workflow and stack surfaces.
