# Archived Wiki Maintenance

The GitHub wiki is disabled for this repository. Keep the public documentation surface in `docs/` so it remains versioned, link-checked, and reviewed with code changes.

This page is retained as historical guidance for avoiding a second docs tree.

## Current Rules

- keep `docs/catalog.md` and `docs/start-here.md` current
- keep docs indexes aligned with the current information architecture
- use summary pages to route, not to mirror every command contract
- refresh top-level docs when the feature map or start-here path changes
- avoid restoring a duplicate tracked `wiki/` mirror

## When To Update Summary Docs

- a new major feature bucket is added
- a new default user path appears
- a new host or integration meaningfully changes onboarding
- a knowledge-layer integration such as NotebookLM becomes a practical optional path for research or documentation workflows
- vault or graph analysis reveals missing hub pages, duplicated topic areas, or weak wiki routing
- README or `docs/start-here.md` changes enough that the docs home would now mislead readers
- the docs layer starts surfacing more routes than a new user can reasonably absorb in the first pass
- repeated docs confusion appears across sessions strongly enough to justify framework-level cleanup instead of just local routing help

## Refresh Targets

- `docs/catalog.md`
- `docs/start-here.md`
- `docs/feature-index.md`
- `docs/command-index.md`
- `docs/choose-your-path.md`
- `docs/whats-new.md`
