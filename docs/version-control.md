# Version Control And Iteration

ORCA Framework changes should be easy to inspect, compare, and ship. The repo uses ordinary Git history as the source of truth, with a small amount of framework-specific structure so agents and maintainers can understand what changed and why.

## Branch Model

Use one branch per coherent iteration.

Recommended branch names:

- `codex/<short-topic>` for agent-authored framework work
- `feature/<short-topic>` for human-authored feature work
- `fix/<short-topic>` for narrow fixes
- `docs/<short-topic>` for documentation-only work

Do not mix unrelated framework systems in the same branch unless the work is intentionally a single reliability or release iteration.

Before non-trivial repo work, inspect and record:

```sh
git rev-parse --show-toplevel
git status --short --branch
git branch --show-current
git symbolic-ref refs/remotes/origin/HEAD
```

Use repo-specific protected branch names when documented. If none are documented, treat `main` as protected. Preserve unrelated dirty work. Do not reset, revert, delete, or stage unrelated files.

Start from a scoped non-protected branch. Never implement directly on a protected branch.

## Iteration Shape

Each meaningful iteration should have:

- a clear objective
- bounded scope
- docs, commands, skills, templates, and examples updated together when the capability crosses those surfaces
- validation results recorded in the final summary or PR
- changelog entry for user-visible framework changes
- follow-up notes when work is intentionally deferred

Use [templates/iteration-log.md](../templates/iteration-log.md) when the iteration spans multiple commits or adds a new framework capability.

## Commit Policy

Prefer small, reviewable commits grouped by capability.

Good commit subjects:

- `Add coordination state and inspection layer`
- `Add benchmark, accounting, and regression systems`
- `Extend ecosystem sweep watch and draft issues`

Avoid commit subjects that hide scope:

- `misc updates`
- `more docs`
- `fix stuff`

## Changelog Policy

Update [CHANGELOG.md](../CHANGELOG.md) for user-visible framework changes. Unreleased work should go under `Unreleased` until the next version is cut.

Use categories when useful:

- Added
- Changed
- Fixed
- Validation
- Known blockers

## Versioning Policy

Orca uses semantic versioning:

- patch: wording fixes, broken links, narrow template fixes
- minor: new commands, skills, templates, docs, or workflow capabilities
- major: incompatible workflow model or install behavior changes

The current product release is `1.0.0`. User-visible changes accumulate under `Unreleased` after that tag until the next version is selected.

## Validation Before PR Or Push

Meaningful changes go through PRs unless repo policy explicitly allows a direct merge. Do not push directly to protected branches.

Before closing repo work:

1. Re-read the current request.
2. Review the diff.
3. Stage only scoped files.
4. Commit with a concise message.
5. Run focused verification.
6. Push the scoped branch.
7. Open or update a PR.
8. Check PR status before merge.
9. Merge only when scope is complete and checks/risk are acceptable.
10. Delete the merged feature branch only when safe.
11. End on the correct integration branch or documented clean state.

PRs should include target branch, summary, files changed, tests/checks run, manual QA, risk/rollback, version/build impact, and deployment/Xcode Cloud/CI impact when relevant.

Final handoff should report branch, commit, PR URL, merge state, tests/checks, remaining dirty files, blockers, and follow-ups.

Avoid `git reset --hard`, `git checkout -- <file>`, force-push, deleting branches or worktrees, changing protected branch rules, or bypassing branch guards unless Henry explicitly requests it.

Run:

```sh
./scripts/validate-repo.sh
```

For targeted changes, also run the relevant focused check:

```sh
./scripts/check-reliability.sh
./scripts/check-improvement-systems.sh
./scripts/check-markdown.sh
./scripts/check-links.sh
```

## Push And Workflow Scope

This repo contains GitHub workflow files. Any branch that adds or edits `.github/workflows/*` needs GitHub credentials with workflow-file permission to push.

If push is blocked by auth scope:

- keep the local commit intact
- record the blocker in the handoff
- do not rewrite the branch to hide workflow changes
- push after reauthenticating with the required scope

## Iteration Review

Before considering an iteration complete, inspect:

- branch status
- recent commits
- changed file surface
- validation output
- changelog entry
- any manual push or auth blocker
- whether new tools or MCP servers need registry entries or approval notes

The goal is not process overhead. The goal is that another maintainer can reconstruct the iteration without reading the full chat transcript.

## Scoutly Policy

Use these rules only for Scoutly repos unless a newer Scoutly doc says otherwise:

- Protected branches: `main`, `staging`, `dev`.
- Normal work: branch from `dev`, PR to `dev`.
- Release-candidate work: branch from `staging`, PR to `staging`.
- Production hotfix: branch from `main`, PR to `main`, then merge forward to `staging` and `dev`.
- Allowed prefixes: `feature/`, `fix/`, `chore/`, `docs/`, `release/`.
- Run `npm run git:guard` before push when available.
