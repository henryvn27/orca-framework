---
name: orca-delegation
description: Create bounded delegation briefs and structured executor returns for ORCA Framework workflows.
---

# ORCA Framework Delegation

## What This Skill Is

A delegation procedure for controller-to-executor handoff across harnesses or humans.

## Trigger

Use when a controller decides another actor should perform bounded implementation, research, QA, or review work.

## Required Inputs

- objective
- linked work artifact
- scope boundaries

## Exact Workflow

1. Decide whether delegation is actually warranted.
2. Choose the orchestration pattern if delegation is warranted.
3. State the objective, linked artifacts, and ownership boundary.
4. Bound scope and out-of-scope work.
5. For repo-writing delegates, require `docs/version-control.md`: start/status branch checks, unrelated dirty-work preservation, scoped branch ownership, PR target, and no protected-branch implementation.
6. Define required outputs, verification, and return schema.
7. Define stop conditions, escalation rules, and approval boundary.
8. Require a structured result on return.

## Expected Outputs

- `templates/delegation-brief.md`
- `templates/delegation-result.md`

## Quality Bar

The executor should not have to infer the real task.
The parent should not have to guess how to ingest the result.

## Common Failure Modes

- delegation with fuzzy scope
- delegation where the parent outsourced the immediate critical-path step unnecessarily
- overlapping ownership between workers
- no verification requirement
- no structured return format
- no branch or PR ownership boundary for repo-writing work
