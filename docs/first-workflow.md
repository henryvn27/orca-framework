# First Workflow

The first Orca workflow is one evidence-backed Mission. It works without an LLM, tracker, hosted account, or integration.

## 1. Create The Contract

From a Git repository with a small real change:

```sh
orca mission create "Prepare this change for review" \
  --criterion "The repository has no whitespace errors" \
  --criterion "The behavior is documented"
```

Criteria should describe observable outcomes. Avoid task-shaped criteria such as “edit the code”; state what the edit must prove.

## 2. Let Any Agent Work

Use Codex, Claude Code, another harness, or manual work. Orca does not hide or replace the executor.

If the agent benefits from an Orca workflow definition, print or launch one:

```sh
orca run orca-build --print -- "Implement the current Mission"
```

This step is optional. The Mission remains the authority even when no skill or workflow prompt is used.

## 3. Record Command Evidence

Ask Orca to run a check for a criterion:

```sh
orca mission check AC-1 -- git diff --check
```

On exit `0`, Orca marks the criterion satisfied and records the exact command and exit status. On failure, the criterion remains open and the failed attempt is preserved in the mission event history.

## 4. Record Non-Command Evidence

Some outcomes require review evidence rather than a shell check:

```sh
orca mission satisfy AC-2 --evidence "README documents the changed behavior"
```

This is an explicit attestation, not automatic proof. Keep it specific enough for another person or agent to inspect.

## 5. Handle A Blocker

When work cannot continue truthfully:

```sh
orca mission block "Waiting for a production credential"
orca mission status
```

Orca prevents criterion changes and completion while blocked. After the blocker is actually resolved:

```sh
orca mission resume
```

## 6. Complete The Mission

```sh
orca mission complete
```

Completion succeeds only when all criteria carry evidence and no blocker remains. The completed JSON stays under `.orca/missions/` and appears in `orca mission list` after the next Mission starts.

## Automation

Every mission command accepts `--json` before the check command separator:

```sh
orca mission status --json
orca mission check AC-1 --json -- git diff --check
```

Command output goes to stderr in JSON mode so stdout remains a single parseable JSON result.
