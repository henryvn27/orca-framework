# First Workflow

The first Orca workflow is one complete, evidence-backed Mission. It requires no LLM, tracker, account, or integration.

## 1. Open Mission Control

From the project whose outcome you want to manage:

```sh
orca dashboard
```

Choose **New**, or create the same contract from the CLI.

## 2. Create The Contract

```sh
orca mission create "Prepare this change for review" \
  --criterion "The repository has no whitespace errors" \
  --criterion "The behavior is documented" \
  --by "Change owner"
```

Criteria describe observable outcomes. “Edit the code” is a task; “the regression test passes” is a criterion.

## 3. Let Any Executor Work

Use a human, Codex, Claude Code, another agent, or CI. Orca does not hide or replace the executor.

An optional workflow definition can help:

```sh
orca run orca-build --print -- "Implement the current Mission"
```

The Mission remains authoritative even when no workflow or skill is used.

## 4. Record Command Evidence

```sh
orca mission check AC-1 --by "Local verification" -- git diff --check
```

Exit `0` satisfies the criterion and records command, timing, actor, and exit status. A failure leaves the criterion open and records the failed attempt.

## 5. Record Review Evidence

```sh
orca mission satisfy AC-2 \
  --evidence "README documents the changed behavior" \
  --by "Reviewer"
```

This is an explicit attestation. Keep it precise enough for another executor to inspect.

## 6. Correct Evidence When Reality Changes

```sh
orca mission reset AC-2 \
  --reason "The behavior changed after review" \
  --by "Change owner"
```

Reset removes the criterion’s stale evidence, returns it to open, and preserves the reason in history. Record replacement proof before completion.

## 7. Handle A Blocker

```sh
orca mission block "Waiting for the production credential" --by "Change owner"
orca mission status
orca mission resume --reason "Credential granted" --by "Change owner"
```

Blocked Missions reject criterion mutations and completion.

## 8. Complete Or Cancel

```sh
orca mission complete --by "Change owner"
```

Completion succeeds only when every criterion has evidence and no blocker remains. If the outcome should end without that claim:

```sh
orca mission cancel "Outcome superseded" --by "Change owner"
```

Both states remain inspectable. Either can be reopened with an attributable reason.

## 9. Inspect And Move The Mission

```sh
orca mission list
orca mission events
orca mission validate
orca mission export --output mission.orca.json
```

On another machine or clean project root:

```sh
orca mission import mission.orca.json
```

Import is idempotent for identical state and refuses conflicts.

## Automation

```sh
orca mission status --json
orca mission check AC-1 --by CI --json -- git diff --check
```

Command output goes to stderr in JSON mode so stdout remains parseable.
