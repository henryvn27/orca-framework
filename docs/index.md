# Orca Mission Control

<div class="orca-doc-intro">
  <p class="orca-kicker">ORCA</p>
  <p class="orca-lead">Local mission control for AI coding work: explicit acceptance criteria, recorded evidence, guarded completion, and durable history.</p>
  <p class="orca-meta"><strong>State:</strong> Project-local <span>•</span> <strong>Interface:</strong> Human + JSON <span>•</span> <strong>Agents:</strong> Any harness</p>
</div>

## First Mission

```sh
orca mission create "Prepare this change for review" \
  --criterion "The repository has no whitespace errors" \
  --criterion "The change is documented"
orca mission check AC-1 -- git diff --check
orca mission satisfy AC-2 --evidence "README updated"
orca mission complete
```

Orca will refuse the last command until every criterion carries evidence and every blocker is resolved.

## The Product Boundary

- A Mission owns the outcome, criteria, evidence, blockers, readiness, and lifecycle.
- An agent performs the work.
- A skill teaches the agent a useful procedure.
- An integration connects an optional external system.

The Mission remains inspectable even when the agent, skill, or harness changes.

## Start Here

| If you want to... | Open this |
| --- | --- |
| prove Orca works | [First 10 Minutes](first-10-minutes.md) |
| understand the product | [Intro](intro.md) |
| run the complete product loop | [First Workflow](first-workflow.md) |
| install Orca | [Quickstart](quickstart.md) |
| use an agent procedure | [Commands](commands.md) |
| understand skills | [Skills](skills.md) |

## Beyond Mission Control

Orca ships optional workflow definitions and skills for planning, building, review, QA, release work, and integrations. Those are extensions to the mission runtime, not substitutes for it. Start with one Mission; add a workflow only when it helps prove a criterion.
