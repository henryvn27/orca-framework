# Commands

Orca has an executable product layer and an optional agent-workflow library.

## Mission Product Commands

Every mutation accepts `--by ACTOR`. `ORCA_ACTOR` and then the current OS user are the fallbacks. Read and mutation commands accept `--json` unless the command’s help says otherwise.

| Command | Purpose |
| --- | --- |
| `mission create OUTCOME --criterion TEXT...` | create the only current Mission |
| `mission status` | inspect the current Mission |
| `mission show [MISSION-ID]` | inspect current or historical state |
| `mission list` | list all durable Missions |
| `mission events [MISSION-ID]` | inspect attributable history |
| `mission add --criterion TEXT` | extend the active acceptance contract |
| `mission reset AC-ID --reason TEXT` | remove stale evidence and reopen a criterion |
| `mission check AC-ID -- COMMAND...` | run a command directly and record its exit status |
| `mission satisfy AC-ID --evidence TEXT` | record an explicit attestation |
| `mission note TEXT` | add context without changing readiness |
| `mission block REASON` | stop mutations with a visible cause |
| `mission resume [--reason TEXT]` | resolve current blockers and continue |
| `mission cancel REASON` | end without claiming completion |
| `mission reopen MISSION-ID --reason TEXT` | return a terminal Mission to active |
| `mission complete` | complete only when every criterion has proof |
| `mission validate [MISSION-ID]` | check the full schema and invariant set |
| `mission export [MISSION-ID] --output PATH` | write a portable envelope |
| `mission import PATH` | safely import portable Mission state |

Use `orca mission help` for exact option placement.

## Dashboard

```text
orca dashboard [--project PATH] [--port PORT] [--no-open]
```

The dashboard binds to loopback, opens the browser by default, and operates the same Mission runtime. `--port 0` chooses an available port. `--project` selects the project whose `.orca/` state is shown.

## Version

```text
orca version
```

The value comes from the installed `VERSION` file.

## JSON Automation

Place `--json` before the separator used by `check`:

```sh
orca mission status --json
orca mission check AC-1 --by CI --json -- git diff --check
```

In JSON mode, the checked command writes to stderr and stdout remains one parseable result object. Errors use `{"ok":false,"error":"..."}` and a nonzero process exit.

## Workflow Library

Markdown files under `commands/` are optional agent procedures. They do not own Mission state.

```sh
orca list
orca show orca-build
orca path orca-build
orca run orca-build --print -- "Implement the current Mission"
orca run orca-build --target /path/to/project -- "Implement the current Mission"
```

Installed POSIX shims such as `orca-build` and Windows shims such as `orca-build.cmd` route to the same prompt execution layer.

Use a workflow when it helps satisfy a criterion. A prompt run is not completion evidence until it produces a concrete check or attributable attestation.
