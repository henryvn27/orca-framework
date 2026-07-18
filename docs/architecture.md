# Architecture

Orca 1.0 has a small product core surrounded by optional execution content.

```text
                     browser / human UI
                              |
                              v
agent or human ----> Mission runtime <---- CI / JSON automation
                              |
                lock + validate + atomic write
                              |
                              v
                    project-local .orca/

optional commands / skills / integrations help executors satisfy the Mission
```

## Mission Runtime

`scripts/orca-mission.rb` is the canonical state machine. Every human and JSON command passes through the same transition and invariant checks.

Responsibilities:

- create, inspect, list, and validate Missions;
- add and reset acceptance criteria;
- record command evidence, attestations, notes, actors, and events;
- block, resume, cancel, reopen, and complete;
- reject premature or conflicting mutations;
- export and import validated portable envelopes;
- write state atomically under an exclusive project lock.

Mission files use schema `1.0.0`. Derived readiness and next action are calculated from canonical state.

## Mission Control Server

`scripts/orca-dashboard.rb` is a standard-library HTTP adapter around the Mission runtime. It does not implement a second state machine.

Security boundary:

- binds only to `127.0.0.1`;
- emits a per-process random session token;
- requires that token and the exact same origin for every write;
- enforces JSON content type and bounded request bodies;
- serves a strict content security policy and disables caching/framing;
- maps a fixed action allowlist to argument arrays without invoking a shell.

The HTML, CSS, and JavaScript under `dashboard/` are dependency-free static assets.

## Storage

```text
.orca/
  active-mission
  mission.lock
  missions/
    <mission-id>.json
```

The active pointer identifies the current Mission. Terminal files are retained. Mutations take an exclusive lock, validate the resulting state, write through a mode-`0600` temporary file, flush it, and rename it atomically.

## Portability

An export is a versioned envelope containing validated public Mission state. Import rejects:

- unknown format or schema versions;
- malformed Mission invariants;
- a different Mission with the same ID;
- an active Mission that would overwrite other active work.

Importing identical state is idempotent.

## Native Launchers

- `bin/orca` is the POSIX launcher.
- `bin/orca.ps1` is the native PowerShell launcher.
- `bin/orca.cmd` makes `orca` discoverable through normal Windows `PATH` rules.

All launchers expose Mission Control, dashboard, version, workflow discovery, prompt inspection, and prompt execution. The POSIX launcher also retains legacy goal/adapter compatibility commands.

## Optional Execution Library

- `commands/` contains inspectable agent workflow definitions.
- `skills/` contains reusable procedures.
- `templates/` and `schema/` contain portable working artifacts.
- `integrations/` and `mcp/` contain optional connection guidance.

These layers can help an executor satisfy a criterion. They cannot bypass Mission validation or completion.

## Release Supply Chain

`scripts/package-release.py` builds normalized tar and zip archives from tracked product files. It fixes ordering, timestamps, ownership, and permissions; embeds a per-file SHA-256 manifest; and emits checksums plus commit/tree provenance. The tag workflow validates the source, install-tests archives, creates a GitHub build attestation, and publishes the release.
