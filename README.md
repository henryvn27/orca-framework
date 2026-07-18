# Orca

Orca is local mission control for AI coding work.

It gives any coding agent a durable contract for what “done” means, records the evidence behind each acceptance criterion, blocks false completion, and leaves a mission you can inspect or resume later.

```text
request -> mission -> agent work -> evidence -> completion gate -> durable history
```

Skills can tell an agent how to review code, plan a feature, or run QA. Orca is the product that owns the work itself: its outcome, acceptance criteria, lifecycle, blockers, evidence, readiness, and final state.

## See It Work

Create a mission in any project:

```sh
orca mission create "Prepare this change for review" \
  --criterion "The repository has no whitespace errors" \
  --criterion "The change is documented"
```

Orca writes a project-local mission and immediately names the next unproven criterion:

```text
ORCA MISSION  20260718t164706-prepare-this-change-for-review
Prepare this change for review
Status: ACTIVE  |  Readiness: 0/2 (0%)

Acceptance criteria
[ ] AC-1  The repository has no whitespace errors
[ ] AC-2  The change is documented

Next: Prove AC-1: The repository has no whitespace errors
```

Let Orca run a real check:

```sh
orca mission check AC-1 -- git diff --check
```

Record evidence that cannot be expressed as a command:

```sh
orca mission satisfy AC-2 --evidence "README updated with the new behavior"
```

Then inspect and complete the mission:

```sh
orca mission status
orca mission complete
```

`orca mission complete` fails until every criterion has evidence and every blocker is resolved. Use `--json` with mission commands when an agent, CI job, or other tool needs stable machine-readable state.

## What Makes Orca A Product

| Orca Mission Control | A skill or prompt pack |
| --- | --- |
| Owns a durable mission and lifecycle | Influences one agent interaction |
| Derives readiness from recorded evidence | Can claim work looks ready |
| Executes verification commands and records exit status | Suggests commands for an agent to run |
| Rejects premature completion | Relies on the agent to follow instructions |
| Survives across agents, harnesses, and sessions | Usually lives inside one harness |
| Exposes human and JSON control surfaces | Primarily exposes prose instructions |

Orca does not replace Codex, Claude Code, or another coding agent. It gives them a shared, inspectable definition of success.

## The Product Object: A Mission

A Mission is a small state machine with one active instance per project:

```text
ACTIVE <-> BLOCKED -> COMPLETED
```

Each mission contains:

- one outcome;
- one or more acceptance criteria;
- command evidence or explicit evidence notes;
- blockers and their resolution history;
- derived readiness and the next action;
- an append-only event history;
- timestamps and a versioned JSON schema.

Mission files live under `.orca/`:

```text
.orca/
  active-mission
  mission.lock
  missions/
    <mission-id>.json
```

The state is local, inspectable, atomic, and independent of a hosted account. Completed missions remain available through `orca mission list`.

## Mission Commands

```text
orca mission create OUTCOME --criterion TEXT [--criterion TEXT ...]
orca mission status [--json]
orca mission list [--json]
orca mission check AC-ID [--json] -- COMMAND [ARG ...]
orca mission satisfy AC-ID --evidence TEXT [--json]
orca mission block REASON [--json]
orca mission resume [--json]
orca mission complete [--json]
```

The deliberate constraint is one active mission per project. Orca refuses to overwrite unfinished work; after completion, creating the next mission preserves the previous one in history.

## Where Skills Fit

The repository still includes reusable skills and workflow commands for planning, implementation, review, QA, release work, and integrations. They are optional execution strategies that an agent can use while pursuing a Mission.

```text
Mission = what must become true and what proves it
Skill   = guidance for how an agent might make it true
Agent   = the executor that changes the project
```

Inspect compatibility workflow definitions with:

```sh
orca list
orca show orca-build
orca run orca-build --print -- "Implement the approved plan"
```

The earlier goal/loop-pack commands remain available for existing users, but Missions are the primary product path:

```sh
orca goal --packs
orca progress
orca unify
```

## Install

Orca currently requires Git, a POSIX shell, and Ruby. Ruby is used only from its standard library; there are no package dependencies for Mission Control.

```sh
git clone https://github.com/henryvn27/orca-framework.git
cd orca-framework
./scripts/validate-repo.sh
./install/install.sh --mode global
export PATH="$HOME/.orca-framework/bin:$PATH"
./install/verify-install.sh --target "$HOME/.orca-framework"
./install/doctor.sh --target "$HOME/.orca-framework"
```

For a project-local install:

```sh
./install/install.sh --mode local --target ./.orca-framework
export PATH="$(pwd)/.orca-framework/bin:$PATH"
```

## Current Boundary

Mission Control is real local software today. It creates state, executes checks, enforces transitions, and emits automation-safe JSON.

Orca does not yet provide a hosted dashboard, remote worker, account system, or cross-machine sync. It also does not pretend to verify subjective work automatically: those criteria require an explicit evidence note whose author remains accountable for the claim.

That boundary is intentional. The local contract is the product core; hosted collaboration can be added later without changing what a Mission means.

## Documentation

- [First workflow](docs/first-workflow.md)
- [Commands](docs/commands.md)
- [Skills and their boundary](docs/skills.md)
- [Installation](docs/install.md)
- [Attribution](docs/attribution.md)

## Attribution

Orca routes to upstream projects without claiming authorship. See [ACKNOWLEDGEMENTS.md](ACKNOWLEDGEMENTS.md), [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md), and [UPSTREAM.md](UPSTREAM.md).
