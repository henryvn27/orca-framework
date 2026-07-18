# First Run

The first run should prove Orca’s product contract with as little setup as possible.

## Success Means

- Orca creates a Mission in the target project.
- At least one real verification command runs through Orca.
- A failed check does not increase readiness.
- Every satisfied criterion shows its evidence.
- Completion is rejected until the contract is fulfilled.
- The final Mission remains readable in `.orca/missions/` and through `--json`.

## Recommended First Run

Use [First Workflow](first-workflow.md) with a small project change whose verification command you already know.

Do not begin by configuring Notion, Linear, subagents, a hosted service, or the full skill set. Those may help later, but none is required to prove Mission Control works.

## After The First Mission

Add only the layer the next Mission needs:

- an agent workflow from [Commands](commands.md);
- a reusable procedure from [Skills](skills.md);
- a host adapter from [Compatibility Matrix](compatibility-matrix.md);
- an external integration from [Integrations Overview](integrations-overview.md).
