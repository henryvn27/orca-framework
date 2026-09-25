# orca-ingest

## Purpose

Ingest a structured executor result back into ORCA Framework.

## When To Use

Use after delegated work returns from Codex, Claude Code, another harness, or a human collaborator.

## Required Inputs

- delegation result

## Optional Inputs

- linked receipt
- linked trace
- required approval or QA context

## GitHub Context

- Expects: prior delegation brief, returned worker result, and linked issue or project state when GitHub-first mode is active
- Reads: what was requested, what came back, and which gate is next
- Posts: ingestion summary, unresolved risk, and recommended next state
- Human approval: required only if the ingested result triggers an approval gate

## Opt-Out Context

Attach the ingestion summary to the chosen record and link it to the source delegation.

## Workflow

1. Read the delegation result and linked evidence.
2. Confirm what changed and what artifacts were produced.
3. Record unresolved items, approval needs, and QA needs.
4. Emit the ingestion artifact and next-step recommendation.

## Outputs And Artifacts

- `templates/result-ingestion.md`

## Related Commands And Skills

- Commands: `orca-receipt`, `orca-lineage`, `orca-next`, `orca-approve`
- Skills: `orca-controller-mode`, `orca-delegation`
