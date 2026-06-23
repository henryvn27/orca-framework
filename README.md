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
```

When those values exist, `orca goal`, `orca progress`, and `orca unify` treat Notion as canonical and write sync payloads under `.orca/notion/`. If `ORCA_NOTION_SYNC_COMMAND` or `notion_sync_command` is set, ORCA calls that adapter command with the payload path; the adapter owns the live Notion write. If the adapter is missing or fails, `.orca/notion/outbox/` remains the durable mirror to apply.

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
```

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
