# Mission Control Demo

The shortest honest Orca demo is a Mission whose gate visibly rejects incomplete work.

## Run It

From a Git repository:

```sh
orca mission create "Demonstrate evidence-gated completion" \
  --criterion "The repository has no whitespace errors" \
  --criterion "The demo result is explained"

orca mission complete
orca mission check AC-1 -- git diff --check
orca mission satisfy AC-2 --evidence "Mission Control demo completed"
orca mission status --json
orca mission complete
```

The first completion attempt fails. The final one succeeds only after both criteria carry evidence. The completed Mission remains under `.orca/missions/` and in `orca mission list`.

## What This Proves

- Orca owns durable state rather than relying on chat memory.
- A real command exit status becomes criterion evidence.
- Readiness is derived from evidence, not asserted by an agent.
- The same Mission has human-readable and JSON interfaces.
- Completion is a guarded state transition.

## Optional Agent Demo

The repository also includes an [`orca-demo` workflow definition](../commands/orca-demo.md) that asks discovery questions and produces a goal prompt. That is an optional agent procedure, not the Mission Control product demo.

Continue with [First 10 Minutes](first-10-minutes.md) or [Proof and Outcomes](proof.md).
