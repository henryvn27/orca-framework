# ORCA Framework Project Status

## Current Project State

- Active work item: repository maintenance and validation hardening; link the current work to its migrated GitHub issue or create a GitHub issue when a new bounded task is authorized
- Active milestone: `0.2` hardening and release prep per `ROADMAP.md`
- Current workflow phase: maintenance and verification
- Active harness: runtime-specific; confirm with `orca-status` for the current session
- Active goal: no checked-in goal contract

## Required Integrations

- GitHub Issues and Projects for the active engineering ledger, plus GitHub PRs/checks for delivery

## Existing Artifacts

- Core workflow and operating policy in `ORCA-Framework.md`, `docs/workflow.md`, and `integrations/github.md`
- Install and validation surface in `install/` and `.github/workflows/`
- Orientation and controller-entry docs in `docs/project-orientation.md` and `docs/controller-agent-integration.md`
- Compatibility baseline in `docs/compatibility-matrix.md` with reports under `reports/compatibility/`

## Missing Artifacts

- Current GitHub issue / Project link for the active maintenance lane
- Fresh orientation artifact generated from `templates/project-orientation.md` when a controller enters mid-stream
- Latest checked-in receipt or inspection artifact for the most recent non-trivial repo-maintenance pass

## Blocked Items

- GitHub Project scope must be revalidated in the active harness before changing Project fields; repository issue work should use its available authenticated path
- Refresh PR checks, required reviews, branch protection, and release evidence before any merge or release claim

## Recommended Next Action

- Run `orca-orient` and attach the next non-trivial repo-maintenance pass to its GitHub issue and Project before delegating new work

## Relevant Docs And Commands

- `docs/project-orientation.md`
- `docs/controller-agent-integration.md`
- `docs/delegation.md`
- `docs/result-ingestion.md`
- `orca-status`
- `orca-orient`
- `orca-delegate`
- `orca-ingest`
