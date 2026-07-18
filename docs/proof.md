# Proof And Outcomes

This page answers one question: what observable behavior proves Orca is more than a prompt or skill pack?

## Product Proof

| Claim | Observable proof |
| --- | --- |
| Mission state is durable | `.orca/missions/<id>.json` survives process and agent changes |
| Evidence is real data | `mission check` records the command and exit status |
| Failed work stays incomplete | a nonzero check leaves its criterion open |
| Readiness is deterministic | human and JSON status derive the same satisfied count |
| Blockers affect lifecycle | a blocked Mission rejects evidence changes and completion |
| Completion is guarded | `mission complete` fails until every criterion has evidence |
| History remains inspectable | completed Missions remain available through `mission list` |

Run the [Mission Control Demo](demo.md) to observe the completion gate directly, or complete [First Workflow](first-workflow.md) for the full blocker and history path.

## Integration Proof

Orca is executor-agnostic. The same local Mission can be advanced by a human, Codex, Claude Code, CI, or another tool because the contract lives in project state rather than in a harness prompt.

Optional workflows can still demonstrate planning, building, review, QA, orchestration, and release procedures. Their output counts only when it becomes concrete Mission evidence.

## What Good Proof Looks Like

- The acceptance criterion is observable.
- The evidence identifies the command or artifact that supports it.
- Failed attempts remain visible instead of being rewritten as success.
- Subjective evidence is labeled as an explicit attestation.
- Another executor can inspect the state without reading the original chat.

## Best Next Pages

- [First 10 Minutes](first-10-minutes.md)
- [What Orca Is](intro.md)
- [Product and Workflow Commands](commands.md)
- [Optional Skills](skills.md)
