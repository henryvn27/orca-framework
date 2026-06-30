# Information Architecture

ORCA Framework has enough surface area that documentation needs routing, not just accumulation.

## Layers

### Intro

Purpose: explain what ORCA Framework is, who it is for, and why it exists.

Primary audience:

- new visitors
- evaluators deciding whether the framework is relevant

Primary pages:

- `README.md`
- `docs/intro.md`
- `docs/start-here.md`

### Quickstart

Purpose: get a user to first value without reading the whole framework.

Primary audience:

- first-time installers
- users with a concrete repo or task already in mind

Primary pages:

- `docs/quickstart.md`
- `docs/choose-your-path.md`

### Concepts

Purpose: explain ORCA Framework language and mental models.

Primary audience:

- new users who understand the repo exists but not how the pieces fit together
- contributors who need shared vocabulary

Primary pages:

- `docs/glossary.md`
- `docs/concept-map.md`
- `docs/feature-index.md`

### Guides

Purpose: teach how to use a feature or workflow in practice.

Primary audience:

- users choosing an operating mode
- contributors writing user-facing workflow guidance

Primary pages:

- `docs/guides/*.md`

### Commands

Purpose: route users to the right command and define command contracts.

Primary audience:

- users who know roughly what they need to do
- agent authors mapping language to commands

Primary pages:

- `docs/command-index.md`
- `docs/commands.md`
- `commands/*.md`

### Features

Purpose: explain framework capabilities and how they connect.

Primary audience:

- intermediate users evaluating whether a capability is relevant

Primary pages:

- `docs/feature-index.md`
- feature-specific docs under `docs/`

### Hosts And Integrations

Purpose: explain harness-specific, integration-specific, and compatibility-specific differences.

Primary audience:

- users choosing between Codex, Claude Code, or other hosts
- maintainers updating adapter guidance

Primary pages:

- `docs/hosts/*.md`
- `docs/integrations/*.md`
- `docs/compatibility-matrix.md`

### Workflows

Purpose: show end-to-end paths rather than isolated features.

Primary audience:

- users trying to move from intake to shipped work
- contributors checking where a feature fits

Primary pages:

- `docs/workflow.md`
- `docs/linear-workflow.md`
- `docs/use-case-map.md`

### Examples

Purpose: show what good output looks like.

Primary audience:

- users who learn fastest from concrete examples
- contributors aligning on artifact quality

Primary pages:

- `docs/examples/*.md`

### Contributor Docs

Purpose: keep the docs system healthy over time.

Primary audience:

- maintainers
- contributors adding or changing framework features

Primary pages:

- `CONTRIBUTING.md`
- `docs/contributing-docs.md`
- `docs/docs-automation.md`
- `docs/doc-owners.md`

### Summary Docs

Primary audience:

- readers browsing on GitHub
- users who want a lighter navigation layer than the full docs tree

Primary pages:

- `docs/README.md`
- `docs/start-here.md`
- `docs/feature-index.md`
- `docs/command-index.md`

## Movement Through The Docs

Expected user path:

1. `README.md`
2. `docs/start-here.md`
3. one of the use-case or guide pages
4. command, workflow, and feature references

Expected contributor path:

1. `README.md`
2. `docs/README.md`
3. `docs/information-architecture.md`
4. `docs/contributing-docs.md`
5. targeted feature docs

## Placement Rules

- Put overview and routing pages near the top of `docs/`.
- Put teaching-oriented content in `docs/guides/`.
- Put examples in `docs/examples/`.
- Keep command contracts in `commands/`, not in the wiki.
- Keep the wiki summary-first. It should route and explain, not mirror every reference page.
