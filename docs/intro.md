# What Orca Is

Orca is a local control plane for agent-assisted software work.

Coding agents are good at producing changes, but the surrounding work is easy to lose: what outcome was approved, what counted as done, which checks actually ran, why work stopped, and whether a later agent can trust the handoff. Orca makes that operating state durable.

## The Core Model

```text
Human intent
    |
    v
Orca Mission: outcome + acceptance criteria
    |
    v
Any agent or human performs the work
    |
    v
Orca records command evidence or explicit attestations
    |
    v
Completion gate + durable mission history
```

The model is intentionally smaller than the full framework catalog. A Mission is the one product object. Everything else either executes it, helps execute it, or connects it to another system.

## Orca Versus Skills

A skill is reusable guidance loaded into an agent. It can teach review heuristics, planning structure, or a release procedure. Its effect depends on the agent following the instructions in that interaction.

Orca Mission Control is deterministic software around those interactions. It persists state, runs verification commands, records exit status, derives readiness, manages blockers, and rejects invalid lifecycle transitions.

That means an Orca Mission can use no skills, one skill, or many skills without changing its contract.

## What Orca Does Not Claim

Orca does not write code by itself, judge every subjective criterion automatically, or make a local check equivalent to production proof. It records exactly which proof was supplied and leaves subjective attestations visible as attestations.

Orca is local-first today. Hosted collaboration, remote workers, and sync are future delivery surfaces around the same Mission contract, not prerequisites for using the product.

## Next

- Run [the first workflow](first-workflow.md).
- Read [the command boundary](commands.md).
- See [where skills fit](skills.md).
