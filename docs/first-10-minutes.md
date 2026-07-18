# First 10 Minutes

The fastest way to understand Orca is to complete one Mission, not browse its skill catalog.

## Minutes 1–3: Install

Follow the [Quickstart](quickstart.md) through local installation and verification.

## Minute 4: Create A Contract

In a project repository:

```sh
orca mission create "Prove this repository is ready for a small change" \
  --criterion "Repository validation passes" \
  --criterion "The result is documented"
```

## Minutes 5–7: Produce Evidence

Use the repository’s real validation command for the first criterion:

```sh
orca mission check AC-1 -- ./scripts/validate-repo.sh
```

If this project uses a different check, pass that command instead. A failed command remains visible and does not satisfy the criterion.

Record the reviewable artifact for the second criterion:

```sh
orca mission satisfy AC-2 --evidence "Recorded the result in the project README"
```

## Minutes 8–10: Inspect The Gate

```sh
orca mission status
orca mission status --json
orca mission complete
orca mission list
```

You have now seen the actual product loop: durable intent, real verification, derived readiness, guarded completion, and history. Only then browse [agent workflow commands](commands.md) or [skills](skills.md) if they help with a larger Mission.
