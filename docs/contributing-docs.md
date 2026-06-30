# Contributing Docs

Documentation changes should keep ORCA Framework easier to navigate, not just larger.

## Required Mindset

- add routing when adding surface area
- prefer updating an index or guide over adding another orphan page
- keep summary pages summary-first
- update examples when behavior would otherwise be hard to infer

## When A Feature Changes

Check whether you also need to update:

- `README.md`
- `docs/start-here.md`
- `docs/feature-index.md`
- `docs/command-index.md`
- a guide under `docs/guides/`
- `docs/README.md` and related docs indexes
- `docs/whats-new.md`

## Required Companion Artifacts

- `templates/doc-change-checklist.md`
- `templates/doc-metadata.md`
- `templates/doc-refresh-note.md` when drift is detected

## Validation

Always run:

```sh
./scripts/validate-repo.sh
```
