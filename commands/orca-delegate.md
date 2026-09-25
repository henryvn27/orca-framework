# orca-delegate

## Purpose

Create a bounded delegation brief for another harness or collaborator.

## When To Use

Use when a controller decides implementation, research, QA, review, or goal execution should be performed by another actor.

## Required Inputs

- objective
- linked work item or artifact
- scope boundaries

## Optional Inputs

- executor harness
- verification requirements
- stop conditions

## GitHub Context

- Expects: issue or project context, linked spec or plan, approval state, and the destination executor lane when GitHub-first mode is active
- Reads: current scope, non-goals, blockers, and required evidence
- Posts: delegation brief or worker-assignment note when a durable handoff comment is needed
- Human approval: required when the delegated work crosses an approval gate or expands scope

## Opt-Out Context

Link the delegation brief to the chosen record and preserve the intended return path there.

## Workflow

1. Use `orca-delegation`.
2. Decide whether the work should stay single-agent or use a specific orchestration pattern.
3. Define ownership, scope, constraints, required outputs, verification, and stop conditions.
4. Define how the result will be ingested back into the parent workflow.
5. Emit a structured delegation brief.

## Outputs And Artifacts

- `templates/delegation-brief.md`
- `templates/subagent-contract.md`
- `templates/subagent-context-packet.md`
- `templates/subagent-result-packet.md`
- `templates/result-ingestion.md`

## Failure Cases

- If the split adds more coordination cost than leverage, do not delegate.
- If ownership overlaps, narrow the scope before delegation.
- If verification is undefined, do not spawn the worker yet.

## Related Commands And Skills

- Commands: `orca-ingest`, `orca-next`, `orca-goal`
- Skills: `orca-delegation`
