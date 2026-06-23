# ORCA

ORCA is a closed-loop workflow layer for AI coding agents.

It turns a broad request into scoped work, verified implementation, durable state, readiness scoring, and a handoff you can resume later.

```text
/goal -> clarify -> plan -> apply -> unify -> loop pack -> readiness score -> handoff
```

## Start

```sh
orca goal "make this production ready" --pack release-ready
orca progress
orca unify
```

Autonomous mode is bounded:

```sh
orca goal "make this production ready" --pack release-ready --auto --max-cycles 5 --until blocked
```

It stops on completed acceptance criteria, no ready issues, repeated failures, low confidence, missing credentials/context, risky diff size, time/cycle budget, or required user approval. It is not infinite background execution.

## State

ORCA defaults to Notion for project management, docs, and issues when configured.

Notion config is ID-free by default. Set project-specific IDs in `.orca/config.env`:

```sh
notion_project_page_id=<page-id>
notion_issue_board_data_source_id=<collection-id>
notion_sync_command=/path/to/notion-adapter
```

When those values exist, `orca goal`, `orca progress`, and `orca unify` treat Notion as canonical and write sync payloads under `.orca/notion/`. If `ORCA_NOTION_SYNC_COMMAND` or `notion_sync_command` is set, ORCA calls that adapter command with the payload path; the adapter owns the live Notion write. If the adapter is missing or fails, `.orca/notion/outbox/` remains the durable mirror to apply.

Run queued Notion payloads explicitly:

```sh
orca notion outbox
orca notion outbox --json
orca notion payload --example
orca notion payload --validate .orca/notion/outbox/2026-06-22T12:00:00Z-goal_unified-example-handoff-1.json
orca notion adapter --check .orca/notion/outbox/2026-06-22T12:00:00Z-goal_unified-example-handoff-1.json
orca notion adapter --json-check .orca/notion/outbox/2026-06-22T12:00:00Z-goal_unified-example-handoff-1.json
orca notion adapter --doctor .orca/notion/outbox/2026-06-22T12:00:00Z-goal_unified-example-handoff-1.json
orca notion adapter --dry-run .orca/notion/outbox/2026-06-22T12:00:00Z-goal_unified-example-handoff-1.json
orca notion sync --dry-run --all
orca notion sync --dry-run --json --all
ORCA_NOTION_SYNC_COMMAND=/path/to/notion-adapter orca notion sync --all
orca notion sync .orca/notion/outbox/2026-06-22T12:00:00Z-goal_unified-example-handoff-1.json
```

Dry-run validates queued payloads without calling the adapter or moving files. Add `--json` when an agent or CI gate needs a machine-readable sync summary. Use `orca notion payload --example` to print a valid adapter payload example, and `orca notion payload --validate PATH [--json]` to check one payload without sync semantics. Payload validation also accepts stdin with `PATH` set to `-`. Payloads must include `schema_version: 1`, `payload_type: goal_event`, `action`, `canonical_backend`, `goal_slug`, `phase`, object-shaped `payload`, and `updated_at`. The adapter command receives one argument: the JSON payload path. ORCA moves a payload to `.orca/notion/synced/` only after the adapter exits `0`; missing config, adapter failure, and malformed payloads leave files in `.orca/notion/outbox/`.

ORCA includes an optional Notion API adapter:

```sh
export NOTION_TOKEN=<secret>
export ORCA_NOTION_SYNC_COMMAND="$(pwd)/scripts/orca-notion-sync-adapter.sh"
orca notion sync --all
```

The adapter reads `issue_board_data_source_id` from each payload, or `ORCA_NOTION_DATA_SOURCE_ID` when you need an override. It defaults to issue-board properties named `Issue` and `Status`; set `ORCA_NOTION_TITLE_PROPERTY` or `ORCA_NOTION_STATUS_PROPERTY` for a different board schema. Before creating, it queries the data source by title so repeated payloads update the existing page instead of creating duplicates. Set `ORCA_NOTION_MATCH_PROPERTY` if your board uses a different title property, or `ORCA_NOTION_EXISTING_PAGE_ID` when a caller already knows the target page. Test the create/update plan without network access:

```sh
orca notion adapter --dry-run .orca/notion/outbox/payload.json
orca notion adapter --check .orca/notion/outbox/payload.json
orca notion adapter --json-check .orca/notion/outbox/payload.json
orca notion adapter --doctor .orca/notion/outbox/payload.json
```

Stable adapter fixtures live in `scripts/fixtures/notion/` for contract tests and integration examples.
Use `--doctor` when you need one read-only JSON preflight that combines backend readiness with adapter readiness. Its top-level `ok` means the payload is valid, ORCA's Notion backend is configured, and the adapter has live Notion sync readiness. A payload can pass `--json-check` while `--doctor` still reports `ok: false` when config or `NOTION_TOKEN` is missing.

Example `--doctor` output when ORCA's backend config is ready but live Notion sync is not:

```json
{
  "backend": {
    "notion_issue_board_configured": true,
    "notion_sync_command_status": "executable",
    "ready": true
  },
  "adapter": {
    "action": "create",
    "data_source_id": "issue-board-123",
    "token_present": false,
    "live_ready": false,
    "ok": true
  },
  "ok": false
}
```

If Notion is unavailable, ORCA uses a local markdown fallback:

```text
.orca/
  config.env
  project.md
  issues.md
  decisions.md
  docs/
  runs/
  handoffs/
  packs/
  loops/
  notion/
```

Linear is still supported, but only when explicitly selected or configured as an adapter. It is not the default source of truth.

Check current backend state:

```sh
orca backend status
orca backend status --json
orca notion doctor --json
```

Use text output for humans and JSON output for agents, CI, or release gates that need stable backend readiness fields without scraping prose.

## Tasks

Every ORCA task should be acceptance-driven:

```text
Files: exact files or modules likely to change
Action: specific implementation step
Verify: command, check, or manual evidence
Done: observable done condition
ACs: linked acceptance criteria
```

Vague tasks should be clarified before implementation starts.

## Loop Packs

A loop pack defines what "done" means for the goal.

Built-in packs:

- `release-ready`
- `app-store-ready`
- `startup-mvp`
- `security`
- `performance`
- `notion-hygiene`

Each loop has a goal, measurement, action, stop condition, budget, and handoff. Loop evidence is stored in `.orca/loops/<goal>/`; readiness scores only count loops with pass evidence.

## Core Commands

```text
orca goal
orca progress
orca unify
orca notion sync
orca backend status
orca review
```

Existing command prompts remain available for compatibility:

```sh
orca list
orca show orca-build
orca run orca-build --print -- "Implement the approved plan"
```

## Install

```sh
git clone https://github.com/henryvn27/orca-framework.git
cd orca-framework
./scripts/validate-repo.sh
./install/install.sh --mode local --target ./.orca-framework
export PATH="$(pwd)/.orca-framework/bin:$PATH"
./install/verify-install.sh --target ./.orca-framework
./install/doctor.sh --target ./.orca-framework
```

If already inside an ORCA checkout, do not clone again.

## Advanced Docs

- [docs/install.md](docs/install.md)
- [docs/first-run.md](docs/first-run.md)
- [docs/first-workflow.md](docs/first-workflow.md)
- [docs/commands.md](docs/commands.md)
- [docs/skills.md](docs/skills.md)
- [docs/attribution.md](docs/attribution.md)

## Attribution

ORCA wraps or routes to upstream projects without claiming authorship. See:

- [ACKNOWLEDGEMENTS.md](ACKNOWLEDGEMENTS.md)
- [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)
- [UPSTREAM.md](UPSTREAM.md)
- [docs/attribution.md](docs/attribution.md)
