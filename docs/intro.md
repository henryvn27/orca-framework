# What Orca Is

Orca is a local control plane for agent-assisted software work.

Coding agents can produce changes, but chat does not reliably preserve the surrounding contract: what outcome was approved, what counted as done, which checks actually passed, why work stopped, and whether another executor can trust the handoff. Orca makes that contract executable and durable.

## One Product Object

A Mission contains an outcome, acceptance criteria, evidence, blockers, notes, actors, readiness, and history. Exactly one Mission is current per project. Terminal Missions remain inspectable and can be reopened without erasing their prior state.

```text
Human intent
    |
    v
Mission: outcome + acceptance criteria
    |
    v
Any human, agent, or CI system performs the work
    |
    v
Orca records command proof or explicit attestations
    |
    v
Validated completion gate + durable history
```

The Mission is the product. Commands, skills, templates, and integrations are ways to execute or extend it.

## Orca Versus Skills

A skill is reusable guidance loaded into an agent. Its effect depends on the executor following that guidance in a particular interaction.

Orca is deterministic software around those interactions. It persists state, locks concurrent writes, validates a versioned schema, runs verification commands, attributes evidence, derives readiness, manages blockers, rejects invalid transitions, and exports/imports portable Mission files.

A Mission can use no skills, one skill, or many skills without changing its contract.

## Finished Local-First Boundary

Mission Control runs entirely on the user’s computer:

- the dashboard is a loopback-only web application;
- state stays under the selected project’s `.orca/` directory;
- no account, telemetry collector, hosted database, or background cloud worker is required;
- validated export/import is the cross-machine transfer mechanism;
- the human-readable CLI, dashboard, and JSON API all operate the same runtime.

Hosted accounts, remote execution, and opaque synchronization are product non-goals. Orca coordinates local tools and the agent harnesses users already choose.

## Honest Proof

Orca does not claim to judge every subjective outcome. A command with exit code `0` is recorded as command evidence. A visual review or release decision is recorded as an attributable attestation. The evidence type stays visible so another person can evaluate its strength.

## Next

- Launch [Mission Control](mission-control.md).
- Run [the first workflow](first-workflow.md).
- Read [the command contract](commands.md).
- See [where skills fit](skills.md).
