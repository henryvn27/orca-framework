# Orca

Orca is local mission control for AI coding work.

It turns a request into a durable Mission: one outcome, explicit acceptance criteria, attributable evidence, blockers, readiness, and a guarded final state. Humans and any coding agent can do the work; Orca owns what “done” means and refuses to record completion until the contract is satisfied.

```text
request -> Mission -> work -> evidence -> completion gate -> durable history
```

## See The Product

Launch Mission Control inside any project:

```sh
orca dashboard
```

The same state is available from the CLI and as stable JSON:

```sh
orca mission create "Prepare this change for review" \
  --criterion "The repository has no whitespace errors" \
  --criterion "The behavior is documented" \
  --by "Release owner"

orca mission check AC-1 --by "CI" -- git diff --check
orca mission satisfy AC-2 --evidence "README documents the behavior" --by "Reviewer"
orca mission complete --by "Release owner"
```

`orca mission complete` fails until every criterion has evidence and every blocker is resolved.

## Why Orca Is Not A Skill Bundle

| Orca Mission Control | A skill or prompt |
| --- | --- |
| Owns a durable outcome and lifecycle | Advises one interaction |
| Derives readiness from recorded evidence | Can suggest that work looks ready |
| Executes checks and records exit status | Suggests checks for an agent to run |
| Rejects invalid and premature transitions | Depends on instruction-following |
| Survives agents, harnesses, sessions, and machines | Usually lives inside one harness |
| Has human, browser, JSON, and portable file interfaces | Primarily exposes prose |

```text
Mission = what must become true and what proves it
Skill   = guidance for how an agent might make it true
Agent   = the executor that changes the project
```

Skills remain useful. A Mission can use none, one, or many without changing its completion contract.

## The Product Object

One Mission is current per project. Completed and canceled Missions remain inspectable.

```text
                 block                 cancel
ACTIVE ----------------------> BLOCKED ---------> CANCELED
  ^                              |                    |
  |            resume            | cancel             | reopen
  +------------------------------+                    |
  |                                                   |
  +------------------------ reopen -------------------+
  |
  +----------- COMPLETED <----------- complete
                  |
                  +------------------- reopen --------> ACTIVE
```

Each Mission contains:

- one outcome and one or more acceptance criteria;
- command evidence or explicit human/agent attestations;
- actor attribution, notes, blockers, and resolutions;
- derived readiness and the next required action;
- an append-only event history and monotonic revision;
- a strict, versioned JSON schema.

State is written atomically under the project’s `.orca/` directory. A lock protects concurrent mutations.

## Complete Mission Lifecycle

```text
orca mission create OUTCOME --criterion TEXT [--criterion TEXT ...] [--by ACTOR]
orca mission status [--json]
orca mission show [MISSION-ID] [--json]
orca mission list [--json]
orca mission events [MISSION-ID] [--json]
orca mission add --criterion TEXT [--by ACTOR]
orca mission reset AC-ID --reason TEXT [--by ACTOR]
orca mission check AC-ID [--by ACTOR] [--json] -- COMMAND [ARG ...]
orca mission satisfy AC-ID --evidence TEXT [--by ACTOR] [--json]
orca mission note TEXT [--by ACTOR]
orca mission block REASON [--by ACTOR]
orca mission resume [--reason TEXT] [--by ACTOR]
orca mission cancel REASON [--by ACTOR]
orca mission reopen MISSION-ID --reason TEXT [--by ACTOR]
orca mission complete [--by ACTOR]
orca mission validate [MISSION-ID] [--json]
orca mission export [MISSION-ID] --output PATH [--force]
orca mission import PATH
```

Use `--json` for automation. Command output is separated from JSON so stdout stays parseable.

## Local, Private, Portable

Orca 1.0 is deliberately local-first:

- Mission Control binds only to `127.0.0.1`.
- Dashboard writes require an unguessable session token and same-origin request.
- No account, telemetry service, hosted worker, or cloud database is required.
- Orca does not upload Mission state.
- `mission export` and `mission import` move validated state between machines without overwriting different or active work.

Hosted accounts, remote execution, and opaque automatic sync are non-goals for this product. Orca coordinates the tools and agents you already trust.

## Install Orca 1.0

Runtime dependency: Ruby 2.6 or newer. Git is needed only for source installs. Mission Control uses the Ruby standard library and has no package dependency installation.

### Homebrew (macOS and Linux)

```sh
brew install --formula https://raw.githubusercontent.com/henryvn27/orca-framework/main/Formula/orca.rb
orca version
orca dashboard
```

### Release archive (macOS and Linux)

Download `orca-1.0.0.tar.gz` and `orca-1.0.0-checksums.txt` from the [v1.0.0 release](https://github.com/henryvn27/orca-framework/releases/tag/v1.0.0), verify the checksum, then:

```sh
tar -xzf orca-1.0.0.tar.gz
./orca-1.0.0/install/install.sh --mode global
export PATH="$HOME/.orca-framework/bin:$PATH"
orca version
```

### PowerShell (Windows)

Download and expand `orca-1.0.0.zip`, then run:

```powershell
& .\orca-1.0.0\install\install.ps1 -Mode global
$env:PATH = "$HOME\.orca-framework\bin;$env:PATH"
orca version
orca dashboard
```

### Source checkout

```sh
git clone https://github.com/henryvn27/orca-framework.git
cd orca-framework
./scripts/validate-repo.sh
./install/install.sh --mode local --target ./.orca-framework
export PATH="$(pwd)/.orca-framework/bin:$PATH"
./install/verify-install.sh --target ./.orca-framework
```

## Optional Execution Library

The repository includes 86 agent workflow commands, 72 skills, templates, schemas, and integration guidance. They are execution strategies around a Mission, not the Mission runtime.

```sh
orca list
orca show orca-build
orca run orca-build --print -- "Implement the current Mission"
```

Earlier goal/loop-pack commands remain available on the POSIX compatibility launcher:

```sh
orca goal --packs
orca progress
orca unify
```

## Product Proof

- `scripts/check-mission-smoke.sh` exercises every lifecycle and portability transition.
- `scripts/check-dashboard-smoke.sh` exercises the full browser API and security boundary.
- `scripts/check-release-artifacts.sh` proves deterministic tar/zip output and installs both formats.
- Hosted install acceptance runs on Linux, macOS, and Windows.
- Every GitHub release carries SHA-256 checksums, a file manifest, provenance JSON, and a GitHub build attestation.

## Documentation

- [First workflow](docs/first-workflow.md)
- [Mission Control](docs/mission-control.md)
- [Commands](docs/commands.md)
- [Portability](docs/portability.md)
- [Installation](docs/install.md)
- [Release verification](docs/releases.md)
- [Architecture](docs/architecture.md)

## License And Attribution

Orca is MIT licensed. It routes to upstream projects without claiming authorship. See [ACKNOWLEDGEMENTS.md](ACKNOWLEDGEMENTS.md), [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md), and [UPSTREAM.md](UPSTREAM.md).
