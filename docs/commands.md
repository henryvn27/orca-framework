# Commands

Orca has two command layers with different responsibilities.

## Product Commands

Mission commands are executable product behavior. They own durable state and enforce lifecycle rules.

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

The backend and Notion commands are optional adapter surfaces:

```text
orca backend status [--json]
orca notion ...
```

The earlier goal/loop-pack runtime remains available for compatibility:

```text
orca goal ...
orca progress
orca unify
```

## Agent Workflow Commands

Markdown files under `commands/` are procedures for an agent. They do not own Mission state and should not be confused with the product runtime.

Inspect or run them with:

```sh
orca list
orca show orca-build
orca run orca-build --print -- "Implement the current Mission"
```

Installed shims such as `orca-build` call the same `orca run` compatibility layer.

Use a workflow command when its procedure helps satisfy a Mission criterion. Do not create a Mission merely to browse a prompt, and do not treat a successful prompt run as completion evidence unless it produces a concrete check or attestation.
