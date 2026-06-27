# Upstream Catalog

This is the canonical catalog of upstream projects, tools, manuals, and references that materially shape ORCA Framework.

Use [docs/attribution.md](docs/attribution.md) for the model behind these entries.

## Entry Format

Each entry records:

- project or source
- link
- maintainer or organization
- license when known
- relationship type
- what ORCA Framework uses or borrows
- whether code is copied, adapted, wrapped, referenced, or only inspiring
- whether special notices are required
- related ORCA Framework feature areas
- status notes

## Upstream Entries

### Linear

- Link: [linear.app](https://linear.app/)
- Maintainer or org: Linear
- License: proprietary service
- Relationship type: direct wrapper or integration
- What ORCA Framework uses or borrows: issue-first workflow, project coordination, comments as durable records, state-gated progression, and tracker-native execution paths
- ORCA Framework relationship detail: wraps and integrates the service through Linear-first commands, setup guidance, and runtime routing; no Linear source code is redistributed in this repo
- Special notices required: none known for service interoperability alone
- Related ORCA Framework areas: `docs/linear-*`, `commands/orca-linear-*`, setup docs, runtime docs
- Status notes: active primary system-of-record integration

### GitHub

- Link: [github.com](https://github.com/)
- Maintainer or org: GitHub
- License: proprietary service
- Relationship type: direct wrapper or integration
- What ORCA Framework uses or borrows: repository, issue, PR, checks, release, and workflow surfaces
- ORCA Framework relationship detail: integrates and wraps GitHub workflows through docs, setup guidance, validation flows, and GitHub-specific release expectations; no GitHub source code is redistributed
- Special notices required: none known for service interoperability alone
- Related ORCA Framework areas: `docs/integrations/github.md`, setup docs, ship docs, ecosystem sweep
- Status notes: active ecosystem and release integration

### GitHub MCP Server

- Link: [github/github-mcp-server](https://github.com/github/github-mcp-server)
- Maintainer or org: GitHub
- License: see upstream repository
- Relationship type: direct wrapper or integration
- What ORCA Framework uses or borrows: an approved MCP path for GitHub access in supported hosts
- ORCA Framework relationship detail: documented integration target and setup path; no bundled server code in this repo
- Special notices required: only if code or configuration is redistributed beyond examples
- Related ORCA Framework areas: `docs/integrations/github.md`, `docs/mcp-governance.md`, `registry/mcp-servers/`
- Status notes: active optional integration path

### Linear MCP

- Link: [Linear MCP docs](https://linear.app/docs/mcp)
- Maintainer or org: Linear
- License: documentation and service terms per upstream
- Relationship type: direct wrapper or integration
- What ORCA Framework uses or borrows: an official MCP path for Linear access where host support and governance allow it
- ORCA Framework relationship detail: integration target and setup method; no bundled Linear MCP server code in this repo
- Special notices required: none known for interoperability documentation
- Related ORCA Framework areas: `docs/integrations/linear.md`, setup docs, MCP governance docs
- Status notes: active optional integration path

### OpenAI Codex CLI

- Link: [openai/codex](https://github.com/openai/codex)
- Maintainer or org: OpenAI
- License: see upstream repository
- Relationship type: compatibility target
- What ORCA Framework uses or borrows: a host environment for execution, command routing, and goal-mode compatibility
- ORCA Framework relationship detail: ORCA Framework supports and documents Codex-specific behavior but does not redistribute Codex CLI code
- Special notices required: none known for compatibility documentation alone
- Related ORCA Framework areas: `docs/hosts/codex-cli.md`, runtime docs, compatibility matrix
- Status notes: active executor target

### Impeccable

- Link: [pbakaus/impeccable](https://github.com/pbakaus/impeccable)
- Maintainer or org: Paul Bakaus and contributors
- License: Apache-2.0
- Relationship type: direct wrapper or integration
- What ORCA Framework uses or borrows: a maintained design skill pack, shared frontend design vocabulary, design shaping commands, and deterministic anti-slop checks
- ORCA Framework relationship detail: ORCA Framework wraps Impeccable as an official capability pack through `orca-impeccable`, integration docs, and wrapper skills; ORCA Framework does not redistribute Impeccable source in this repo
- Special notices required: preserve attribution and any required notices if future changes vendor commands, skill text, rules, or code
- Related ORCA Framework areas: `commands/orca-impeccable.md`, `skills/orca-impeccable/`, `integrations/impeccable.md`
- Status notes: active maintained upstream wrapper target for design-heavy work

### Superpowers

- Link: [obra/superpowers](https://github.com/obra/superpowers)
- Maintainer or org: Jesse Vincent, Prime Radiant, and contributors
- License: MIT
- Relationship type: direct wrapper or integration
- What ORCA Framework uses or borrows: a maintained skills framework, disciplined coding workflow, design-before-build sequencing, planning conventions, and multi-agent execution patterns
- ORCA Framework relationship detail: ORCA Framework wraps Superpowers as an official capability pack through `orca-superpowers`, integration docs, and wrapper skills; ORCA Framework does not redistribute Superpowers source in this repo
- Special notices required: preserve attribution and any required notices if future changes vendor prompts, skills, or helper code from the upstream repo
- Related ORCA Framework areas: `commands/orca-superpowers.md`, `skills/orca-superpowers/`, `integrations/superpowers.md`
- Status notes: active maintained upstream wrapper target for execution-heavy coding workflows

### Matt Pocock Skills

- Link: [mattpocock/skills](https://github.com/mattpocock/skills)
- Maintainer or org: Matt Pocock
- License: MIT
- Relationship type: direct wrapper or integration
- What ORCA Framework uses or borrows: engineering-practice skill routes for tight bug diagnosis, vertical-slice TDD, issue/PRD synthesis, domain modeling, codebase design, architecture review, handoff, and skill-writing discipline
- ORCA Framework relationship detail: ORCA Framework wraps Matt Pocock Skills through `orca-matt-pocock-skills`, integration docs, and wrapper skills; ORCA Framework does not redistribute upstream skill source in this repo
- Special notices required: preserve attribution and MIT notices if future changes vendor prompts, skills, or helper code from the upstream repo
- Related ORCA Framework areas: `commands/orca-matt-pocock-skills.md`, `skills/orca-matt-pocock-skills/`, `integrations/matt-pocock-skills.md`
- Status notes: active optional upstream wrapper target for engineering feedback loops

### Karpathy Guidelines

- Link: [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills)
- Maintainer or org: Multica AI / forrestchang
- License: MIT
- Relationship type: direct wrapper or integration
- What ORCA Framework uses or borrows: a compact coding-agent behavior gate for surfacing assumptions, avoiding overbuilt code, keeping diffs surgical, and defining verifiable success criteria
- ORCA Framework relationship detail: ORCA Framework wraps Karpathy Guidelines through `orca-karpathy-guidelines`, integration docs, and wrapper skills; ORCA Framework does not redistribute upstream skill source in this repo
- Special notices required: preserve attribution and MIT notices if future changes vendor prompts, skills, Cursor rules, or helper files from the upstream repo
- Related ORCA Framework areas: `commands/orca-karpathy-guidelines.md`, `skills/orca-karpathy-guidelines/`, `integrations/karpathy-guidelines.md`
- Status notes: active optional upstream wrapper target for coding-agent behavior discipline

### Claude Code

- Link: [Claude Code docs](https://code.claude.com/docs/en/overview)
- Maintainer or org: Anthropic
- License: proprietary host and docs terms per upstream
- Relationship type: compatibility target
- What ORCA Framework uses or borrows: host compatibility behavior, goal-mode support expectations, and MCP setup expectations
- ORCA Framework relationship detail: host adapter and compatibility target; no bundled Claude Code software
- Special notices required: none known for compatibility documentation alone
- Related ORCA Framework areas: `docs/hosts/claude-code.md`, runtime docs, compatibility matrix
- Status notes: active compatibility target

### Hermes Agent

- Link: [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent)
- Maintainer or org: Nous Research
- License: see upstream repository
- Relationship type: compatibility target
- What ORCA Framework uses or borrows: controller-agent compatibility target and host-model framing
- ORCA Framework relationship detail: ORCA Framework documents Hermes-like controller behavior and compatibility; no Hermes code is redistributed
- Special notices required: none known for compatibility documentation alone
- Related ORCA Framework areas: `docs/hosts/hermes-agent.md`, `docs/controller-agent-integration.md`, compatibility docs
- Status notes: active compatibility target

### GitHub Spec Kit

- Link: [github/spec-kit](https://github.com/github/spec-kit)
- Maintainer or org: GitHub
- License: see upstream repository
- Relationship type: workflow influenced by
- What ORCA Framework uses or borrows: spec-driven workflow framing, artifact sequencing, and the idea that AI-assisted delivery benefits from explicit spec and plan stages
- ORCA Framework relationship detail: ORCA Framework adapts the broader spec-driven mindset into its own Linear-first, QA-layered, multi-harness framework; no Spec Kit code is known to be redistributed in this repo
- Special notices required: none known from conceptual influence alone
- Related ORCA Framework areas: `docs/spec-driven-workflow.md`, workflow docs, ecosystem sweep
- Status notes: conceptual workflow influence, not a runtime dependency

### LLM Council

- Link: [karpathy/llm-council](https://github.com/karpathy/llm-council)
- Maintainer or org: Andrej Karpathy and contributors
- License: see upstream repository
- Relationship type: concept adapted from
- What ORCA Framework uses or borrows: the three-stage council pattern of independent responses, anonymized peer review and ranking, and a final synthesized answer
- ORCA Framework relationship detail: ORCA Framework adapts the council shape into reusable subagent decision workflows for product ideas, feature evaluation, and market-opportunity judgment; ORCA Framework does not redistribute upstream code in this repo
- Special notices required: preserve attribution if future work vendors prompts, code, or UI concepts more directly
- Related ORCA Framework areas: `skills/orca-model-council/`, `skills/orca-council-product-idea/`, `skills/orca-council-feature-evaluation/`, `skills/orca-council-market-opportunity/`, `docs/model-council.md`
- Status notes: conceptual decision-workflow influence, not a bundled dependency

### Bloomberg Beta Manual

- Link: [Bloomberg Beta Manual](https://github.com/Bloomberg-Beta/Manual)
- Maintainer or org: Bloomberg Beta
- License: see upstream repository
- Relationship type: documentation or reference influence
- What ORCA Framework uses or borrows: explicit written thinking about venture evaluation, criteria, and decision transparency
- ORCA Framework relationship detail: influences the business-ideation lane's preference for inspectable written judgment over hype; no Bloomberg Beta content is redistributed as bundled source
- Special notices required: none known from reference use alone
- Related ORCA Framework areas: business ideation docs and templates
- Status notes: reference influence for ideation framing

### Steve Blank Customer Development Writing

- Link: [Customer Development is Not a Focus Group](https://steveblank.com/2009/11/30/customer-development-is-not-a-focus-group/)
- Maintainer or org: Steve Blank
- License: public site terms per upstream
- Relationship type: documentation or reference influence
- What ORCA Framework uses or borrows: hypothesis-testing and customer-discovery framing for idea validation
- ORCA Framework relationship detail: informs validation bias toward explicit assumptions and small experiments; no upstream code or text is redistributed beyond normal citation
- Special notices required: none known from reference use alone
- Related ORCA Framework areas: `docs/idea-validation.md`, validation templates
- Status notes: reference influence for startup validation workflow
