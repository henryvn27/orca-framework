# Ecosystem Watch

When a finding moves from `Watch` or `Investigate soon` to `Adopt now`, update the existing watch entry in place, preserve its earlier sightings, and link the resulting draft issue back to that history.

The watchlist tracks the full research surface. Use [ecosystem-opportunities](ecosystem-opportunities.md) for the short maintainer list of actionable items.
Use [harness-watch](harness-watch.md) for harness-level compatibility shifts.

## What We Track

- repos
- harnesses
- capability areas

## Capability Areas

Every sweep should explicitly watch:

- `/goal` or long-running objective mode
- pause, resume, continue, and clear lifecycle semantics
- checkpointing
- shared state and persistent memory
- run inspection and inspector features
- workflow metrics and cost tracking
- modern startup stack defaults across web, mobile, auth, billing, analytics, and monitoring
- whether current defaults still look like best-fit recommendations rather than popularity-driven suggestions
- whether ORCA Framework is accumulating setup burden or option sprawl in places that should stay simpler
- whether ecosystem shifts are exposing recurring local needs that should become framework candidates after enough evidence
- approval and human-in-the-loop patterns
- tool governance and MCP review
- GitHub integration setup paths
- Linear integration setup paths
- MCP-based setup flows
- connector support changes
- host-specific install and config steps
- auth and permission pattern changes
- deprecated setup patterns
- NotebookLM Enterprise API and setup changes
- NotebookLM community MCP or browser-automation shifts
- Graphify maintenance and setup changes
- Obsidian graph and backlink workflow changes that affect vault analysis
- onboarding UX improvements
- novice and expert workflow adaptation
- regression generation from QA
- benchmark and eval improvements
- release channel changes, update policy shifts, or official rollout and rollback guidance changes that should affect ORCA update behavior

## Active Opportunities

For each active opportunity, keep:

- title
- short summary
- source links
- status
- adoption shape
- primary category
- cross-harness or host-specific status
- setup method when relevant
- affected hosts when relevant
- currently recommended setup path when relevant
- unstable or deprecated setup path when relevant
- required ORCA Framework change
- UX impact
- first seen
- last confirmed
- prior sightings
- related issue if created

## Classifications

- `Adopt now`: open or link a draft issue and mirror the item in [ecosystem-opportunities](ecosystem-opportunities.md).
- `Investigate soon`: gather more evidence, host behavior, or implementation detail.
- `Watch`: keep the source on the radar without creating work yet.
- `Ignore for now`: record only if useful to avoid repeated rediscovery.

## Adoption Shapes

- native ORCA Framework feature candidate
- host-adapter opportunity
- docs/workflow guidance opportunity
- experimental pattern worth watching
- setup-path update

### commands

- Title: Spec Kit extension and integration packaging as a pattern source
- Short summary: Spec Kit's current extension catalogs, controlled multi-install integrations, and token-budget extension are notable, but they widen surface area faster than ORCA Framework should by default.
- Source links:
  - https://github.com/github/spec-kit/releases
  - https://github.github.com/spec-kit/reference/integrations.html
  - https://github.github.com/spec-kit/reference/extensions.html
- Status: `Watch`
- Adoption shape: docs/workflow guidance opportunity
- Primary category: `commands`
- Cross-harness or host-specific: cross-harness pattern source
- Required ORCA Framework change: none yet; keep as a packaging/reference pattern only
- UX impact: expert UX more than beginner UX
- First seen: 2026-05-31
- Last confirmed: 2026-05-31
- Prior sightings:
  - 2026-05-31 initial live ORCA Framework sweep
- Related issue if created: none

### memory

- Title: GSD learnings and queryable intelligence as memory-design inputs
- Short summary: GSD's global learnings store and queryable codebase intelligence are stronger signals for ORCA Framework memory design than ad hoc prompt tricks.
- Source links:
  - https://github.com/gsd-build/get-shit-done/blob/main/docs/FEATURES.md
- Status: `Investigate soon`
- Adoption shape: native ORCA Framework feature candidate
- Primary category: `memory`
- Cross-harness or host-specific: cross-harness pattern source
- Required ORCA Framework change: evaluate whether ORCA's memory layer needs a narrower durable learnings primitive
- UX impact: both
- First seen: 2026-05-31
- Last confirmed: 2026-05-31
- Prior sightings:
  - 2026-05-31 initial live ORCA Framework sweep
- Related issue if created: none

### install

- Title: Official Linear MCP remote path is now concrete enough to recommend
- Short summary: Linear now documents a first-party MCP endpoint with Streamable HTTP (OAuth 2.1 dynamic client registration), explicit Codex CLI setup (including required Codex experimental RMCP flag), and direct `Authorization: Bearer ...` auth as a non-interactive option.
- Source links:
  - https://linear.app/docs/mcp
- Status: `Adopt now`
- Adoption shape: setup-path update
- Primary category: `install`
- Cross-harness or host-specific: cross-harness with Codex-specific setup details
- Setup method: remote MCP
- Affected hosts: Codex, VS Code, Windsurf, Zed, generic MCP-capable hosts
- Currently recommended setup path: generic "approved MCP or manual" wording
- Unstable or deprecated setup path: vague/manual-only Linear setup language
- Required ORCA Framework change: refresh Linear-first setup docs and examples around the official endpoint and auth options
- UX impact: both
- First seen: 2026-05-31
- Last confirmed: 2026-06-02
- Prior sightings:
  - 2026-05-31 initial live ORCA Framework sweep
  - 2026-06-02 docs unchanged; local Linear runtime still blocked by reauthentication
- Related issue if created: Linear MCP setup refresh.

- Title: Impeccable wrapper guidance is starting to drift across official surfaces
- Short summary: Official Impeccable pages now mix `/impeccable teach` and `/impeccable init`, while recent releases changed Codex subagent delivery, deprecated `--fast`, and added daily self-update behavior. ORCA Framework should keep wrapper guidance version-aware instead of restating one brittle install or onboarding story.
- Source links:
  - https://impeccable.style/changelog/
  - https://impeccable.style/docs/init
  - https://impeccable.style/faq
  - https://github.com/pbakaus/impeccable
- Status: `Investigate soon`
- Adoption shape: docs/workflow guidance opportunity
- Primary category: `install`
- Cross-harness or host-specific: cross-harness with Codex-specific delivery changes
- Required ORCA Framework change: refresh `orca-impeccable` wrapper guidance so it treats `teach` as an alias, prefers harness-detected install paths, and avoids stale Codex sidecar assumptions
- UX impact: both
- First seen: 2026-06-02
- Last confirmed: 2026-06-02
- Prior sightings:
  - 2026-06-02 wrapper-pack audit during the ecosystem sweep
- Related issue if created: none

### cross-harness

- Title: OpenCode tracking currently mixes active docs with an archived legacy repo
- Short summary: ORCA Framework tracks OpenCode through active docs plus an archived `opencode-ai/opencode` GitHub repo, which is not a stable single source of truth.
- Source links:
  - https://dev.opencode.ai/docs/cli/
  - https://dev.opencode.ai/docs/config
  - https://dev.opencode.ai/docs/mcp-servers/
  - https://github.com/opencode-ai/opencode/releases
- Status: `Adopt now`
- Adoption shape: docs/workflow guidance opportunity
- Primary category: `cross-harness`
- Cross-harness or host-specific: cross-harness
- Required ORCA Framework change: split future OpenCode reporting into active runtime/docs versus archived legacy repo history
- UX impact: both
- First seen: 2026-05-31
- Last confirmed: 2026-05-31
- Prior sightings:
  - 2026-05-31 initial live ORCA Framework sweep
- Related issue if created: OpenCode source tracking split.

### QA

- Title: GSD optional Playwright-MCP verification is a useful QA pattern
- Short summary: GSD explicitly treats Playwright-MCP visual verification as optional verify-phase support rather than a universal default.
- Source links:
  - https://github.com/gsd-build/get-shit-done/blob/main/docs/FEATURES.md
- Status: `Investigate soon`
- Adoption shape: docs/workflow guidance opportunity
- Primary category: `QA`
- Cross-harness or host-specific: cross-harness pattern source
- Required ORCA Framework change: assess whether ORCA should document the same "opt-in visual verification" posture more explicitly
- UX impact: both
- First seen: 2026-05-31
- Last confirmed: 2026-05-31
- Prior sightings:
  - 2026-05-31 initial live ORCA Framework sweep
- Related issue if created: none

### workflow

- Title: Codex goal mode and governance baseline moved past ORCA Framework's current wording
- Short summary: Codex moved well past the original `0.133.0` goal-mode shift. `0.136.0` now adds archive/unarchive commands, richer app-server MCP status, `codex app-server --stdio`, remote `CODEX_API_KEY` registration for approved OpenAI hosts, and more command-safety hardening on top of the already-mature goal/governance baseline.
- Source links:
  - https://github.com/openai/codex/releases
- Status: `Adopt now`
- Adoption shape: host-adapter opportunity
- Primary category: `workflow`
- Cross-harness or host-specific: Codex-specific
- Required ORCA Framework change: refresh Codex host docs and compatibility notes so they cover the current lifecycle surface rather than only the earlier goal/governance drift
- UX impact: both
- First seen: 2026-05-31
- Last confirmed: 2026-06-02
- Prior sightings:
  - 2026-05-31 initial live ORCA Framework sweep
  - 2026-05-31 same-day refresh: updated to Codex `0.135.0` release details
  - 2026-06-02: broadened with Codex `0.136.0` archive, app-server, remote-registration, and safety changes
- Related issue if created: Codex goal guidance refresh.

- Title: Claude Code dynamic workflows are significant but still host-specific
- Short summary: Claude Code keeps deepening its lifecycle and safety surface. The current `2.1.160` release adds prompts before writing shell-startup and build-tool config files that can grant code execution, and fixes restored `claude agents` sessions dropping history, but the path is still Claude-specific.
- Source links:
  - https://code.claude.com/docs/en/changelog
- Status: `Investigate soon`
- Adoption shape: host-adapter opportunity
- Primary category: `workflow`
- Cross-harness or host-specific: Claude-specific
- Required ORCA Framework change: decide whether to add a Claude-only advanced orchestration guide or fold the new signals into a broader lifecycle abstraction later
- UX impact: expert UX
- First seen: 2026-05-31
- Last confirmed: 2026-06-02
- Prior sightings:
  - 2026-05-31 initial live ORCA Framework sweep
  - 2026-06-02: updated with `2.1.160` safety prompts and restored-session fix
- Related issue if created: none

## Cross-Harness Capability Matrix

Track existence and confidence for:

| Capability | Codex CLI | Claude Code | OpenCode | Notes |
| --- | --- | --- | --- | --- |
| `/goal` | supported | supported | unclear | Codex goals are now enabled by default; Claude documents `/goal`; OpenCode remains conservative. |
| checkpointing | partial | partial | unclear | unclear | Codex archive/unarchive and Claude restore reliability both strengthened, but semantics are still host-specific. |
| pause/resume | partial | partial | unclear | unclear | Codex archive/unarchive and Claude restored-session fixes improved the surface without creating parity. |
| persistent state | partial | partial | unclear | partial | OpenCode docs describe compaction, attach, and remote config, but not enough for strong parity claims. |
| approvals | partial | unclear | unclear | partial | OpenCode explicitly documents permission gating; Codex permission profiles matured. |
| inspection | partial | partial | unclear | partial | Codex and Claude both improved inspectability; OpenCode exposes server/attach flows. |
| tool governance | partial | partial | unclear | supported | OpenCode MCP/tool gating is explicit; Codex governance surfaces expanded. |
| QA support | unclear | unclear | unclear | unclear | GSD is a pattern source here, not direct proof of harness-native support. |

## Integration Setup Watch

Track currently recommended setup paths and caveats. Update this table during each sweep when official docs, host behavior, or connector support changes.

| Service | Codex CLI | Claude Code | OpenCode | VS Code | Generic fallback |
| --- | --- | --- | --- | --- | --- |
| GitHub | connector, approved MCP, `gh`, or manual; verify locally | MCP or configured connector when available; manual fallback | verify host docs before recommending connector parity | verify current docs and active implementation lineage | Copilot connector, MCP, `gh`, or manual | `gh`, approved MCP, token, or manual |
| Linear | official remote MCP path now documented; `codex mcp add linear --url https://mcp.linear.app/mcp` | MCP path when approved; manual fallback | verify host docs before recommending connector parity | verify current docs and auth flow before recommending | `npx -y mcp-remote https://mcp.linear.app/mcp` | approved MCP, token, or manual |
| NotebookLM | community MCP or browser path unless enterprise setup is confirmed | community MCP or browser path unless enterprise setup is confirmed | verify host and browser automation support before recommending | unknown; verify local docs | browser automation or enterprise web path, depending on host setup | enterprise path, Google Cloud APIs, or user-managed MCP/browser tooling |
| Graphify | optional local install or shell invocation; never required | optional local install or shell invocation; never required | verify host shell and file access support first | unknown; verify local docs | optional local install if the user wants graph analysis | direct vault inspection first, Graphify only as optional enhancement |

Current local caveat:
Linear's official remote MCP path is still the right documented baseline, but local verification in this workspace remains blocked by `401: "Server returned 401: 'Reauthentication required'"`. Keep recurring automations on the local draft-issue fallback until runtime auth is healthy again.

## Setup Path Risks

Use this section for unstable, broken, or deprecated setup guidance.

- OpenCode risk: ORCA Framework currently tracks active docs against an archived legacy repo. Future setup recommendations should cite the active docs/runtime lineage explicitly.
- Linear risk: this session's Linear connector required reauthentication, so live issue-native maintenance was blocked even though the setup path is now better documented officially.

## Setup Simplification Opportunities

Use this section for easier setup paths ORCA Framework may want to adopt.

- Linear MCP can now be documented with one official endpoint and explicit host examples instead of generic MCP prose.
- Codex guidance can move from "maybe experimental" goal wording to a clearer version-aware baseline.

## Host-Specific Caveats

- Do not assume MCP setup, connector auth, or write permissions transfer across hosts.
- Treat official connector changes as host-specific until evidence shows portability.
- If a setup path changes from local server to remote MCP, verify auth and permission implications before recommending it.
- Do not blur NotebookLM Enterprise APIs with community automation. Track them as separate setup paths.
- Do not let graph tooling drift into mandatory setup. Keep it explicitly optional.
- Do not widen the default surface just because a tool or host capability exists.

## Recently Adopted

- 2026-05-31: Linear official MCP setup path promoted to `Adopt now` for ORCA Framework setup guidance refresh.
- 2026-05-31: Codex goal/governance baseline promoted to `Adopt now` for host-guidance refresh.
- 2026-05-31: OpenCode source-tracking split promoted to `Adopt now` to prevent future compatibility overclaim.

## Dormant / Not Worth It

- No dormant items yet.

## Monitoring Notes

- First live ecosystem sweep completed on 2026-05-31.
- No prior dated sweep existed, so all items above are baseline discoveries rather than upgrades from an earlier run.
- Linear was blocked by reauthentication during this run.
- Direct issue creation was not verified, so adopt-now follow-ups were written as local Markdown drafts.
