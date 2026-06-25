# Contributing

Thank you for improving ORCA Framework. Contributions should make the framework clearer, more verifiable, or easier to install.

## Standards

- Keep commands, skills, docs, and templates internally consistent.
- Preserve the separation between blind QA, briefed QA, and informed QA.
- Avoid unsupported claims about tool support or test coverage.
- Write concrete guidance that an agent can follow.
- Use `docs/version-control.md` for branch, PR, protected-branch, and handoff expectations.
- Run `./scripts/validate-repo.sh` before opening a pull request.

## Pull Request Checklist

- The change has a clear reason.
- New commands include required inputs, workflow, outputs, failures, and related skills.
- New skills include trigger rules, workflow, outputs, quality bar, and failure modes.
- New docs or changed behavior are reflected in the right routing pages, not only in a deep reference file.
- Documentation links resolve.
- Scripts remain portable POSIX shell unless a file explicitly targets another shell.
- The changelog is updated for user-visible framework changes.
- Multi-commit framework iterations use `templates/iteration-log.md` or an equivalent PR summary.
- New upstream influences, wrappers, integrations, or redistributed third-party components are recorded in `UPSTREAM.md` and related notice files when needed.
- If the top-level experience changed, update `README.md`, `docs/start-here.md`, `docs/feature-index.md`, `docs/command-index.md`, and the relevant wiki pages.
- Add or refresh examples when the workflow change would otherwise be non-obvious.
- Refresh review dates or owner signals when the change materially affects an owned docs area.

## Development

Use the validation script as the main local check:

```sh
./scripts/validate-repo.sh
```

For markdown-only changes:

```sh
./scripts/check-markdown.sh
./scripts/check-links.sh
```

For version-control and iteration expectations, read `docs/version-control.md`.

For docs architecture, wiki maintenance, and docs refresh rules, read:

- `docs/README.md`
- `docs/information-architecture.md`
- `docs/contributing-docs.md`
- `docs/docs-automation.md`
- `docs/wiki-maintenance.md`
- `docs/staleness-detection.md`

For upstream credit, provenance, and notice maintenance, read:

- `docs/attribution.md`
- `docs/provenance.md`
- `docs/attribution-maintenance.md`
