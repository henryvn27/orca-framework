# ORCA Tool Catalog

ORCA is moving from bundled utilities to a manager/catalog layer.

End state:

- ORCA owns catalog loading, picker UI, dependency/conflict checks, install orchestration, update/uninstall/status, verification, and attribution display.
- Tools own their source, docs, install path, tests, and releases in standalone repos.
- HVN Stack disappears after useful entries become tool repos or catalog entries.
- ORCA manager-core pieces such as install, doctor, attribution, receipts, and registry bookkeeping stay in ORCA.
- External skills should be invoked directly by the new picker/installer. Do not create ORCA wrapper repos for skills that already exist.

## Current Catalog

Machine-readable tool entries live in `catalog/tools/*.json`.

```sh
orca tools
orca tools --json
```

## Status Values

- `external`: already outside ORCA.
- `extract-tool`: still inside ORCA and should become its own repo.
- `split-required`: temporary grouping that must be split into smaller repos.

## First Entries

- `anti-ai-ui`: renamed external UI library.
- `github-flow-manager`: standalone GitHub workflow skill.
- `orca-goal-runner`: bounded goal-loop engine.
