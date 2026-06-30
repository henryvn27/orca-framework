# Skills

Skills are reusable operating procedures stored in `skills/*/SKILL.md`. They define trigger rules, inputs, workflow, outputs, quality bar, common failure modes, and relationships to other ORCA Framework skills.

ORCA is moving these skills toward standalone tool repos. Catalog entries for extracted and external tools live in `catalog/tools/*.json`; use `orca tools` to list them.

## Linear Skills

- `orca-linear-setup`
- `orca-linear-core`
- `orca-linear-triage`
- `orca-linear-planner`
- `orca-linear-executor`
- `orca-linear-qa`
- `orca-linear-release`

These skills coordinate issue-native work in Linear. If the user opts out of Linear, use the same behaviors against the chosen system of record.

## Core Skill Groups

- Core governance: `orca-core`
- Intake and discovery: `orca-onboard`, `orca-discover`, `orca-legacy`, `orca-research`, `orca-controller-mode`, `orca-business-ideation`, `orca-model-council`, `orca-council-product-idea`, `orca-council-feature-evaluation`, `orca-council-market-opportunity`, `orca-attribution`, `orca-background-mode`, `orca-docs-system`, `orca-integrations`, `orca-integration-recommendation`, `orca-graph-vault-support`, `orca-corpus-support`, `orca-adaptive-guidance`, `orca-agent-orchestration`
- Wrapped upstream packs: `orca-impeccable`, `orca-superpowers`
- Install and setup: `orca-install-help`
- Updates and release safety: `orca-auto-update`
- Delivery: `orca-spec`, `orca-plan`, `orca-goal-mode`, `orca-goal-prompt`, `orca-build`
- Reliability: `orca-observability`, `orca-eval`, `orca-approval-gate`, `orca-benchmark`, `orca-accounting`, `orca-portability`, `orca-regression-task`, `orca-shared-state`, `orca-checkpoint`, `orca-tool-governance`, `orca-tool-setup`, `orca-runtime-adaptation`, `orca-receipts`, `orca-next-step`, `orca-delegation`, `orca-ci`, `orca-pr-feedback`, `orca-context`
- Platform release packs: `orca-testflight-release`, `orca-testflight-ops`
- Web deploy packs: `orca-vercel-deploy`
- Gates: `orca-review`, `orca-design`, `orca-security`, `orca-ship`
- QA: `orca-blind-qa`, `orca-context-brief`, `orca-ios-sim-qa`, `orca-web-qa`, `orca-ui-debug`, `orca-screenshot`
- Learning: `orca-retro`, `orca-session-improvement`, `orca-friction-policy`
- Self-improvement: `orca-self-improvement`

## Skill Installation

Skills can be installed into agent clients that support skill directories, or read directly by agents using repo mode. Linear guidance can be installed separately into workspace, team, or project instructions.

Reliability skills should be treated as cross-cutting helpers:

- `orca-observability` for traces
- `orca-eval` for trajectory scoring
- `orca-approval-gate` for risky-action control
- `orca-benchmark` for onboarding/spec comparisons
- `orca-accounting` for workflow timing and retry signals
- `orca-business-ideation` for idea framing, venture-style evaluation, opportunity memos, and validation planning
- `orca-model-council` for five-subagent deliberation with anonymized peer review and a final chair synthesis
- `orca-council-product-idea` for stronger product and startup idea generation
- `orca-council-feature-evaluation` for deciding whether a feature deserves roadmap or spec work
- `orca-council-market-opportunity` for buyer, wedge, and market-attractiveness judgment
- `orca-background-mode` for bounded unattended progress with explicit loop guards, permissions handling, and final states
- `orca-docs-system` for docs routing, start-here guidance, wiki maintenance, and stale-doc refresh planning
- `orca-attribution` for upstream credit, provenance classification, wrapper clarity, and notice maintenance
- `orca-portability` for schema definition, validation, versioning, and artifact mapping
- `orca-controller-mode` for repository-first orientation, routing, and multi-harness coherence
- `orca-regression-task` for preserving high-value findings as regression work
- `orca-shared-state` for current multi-role coordination
- `orca-checkpoint` for explicit pause, inspect, approve, reject, and resume flows
- `orca-tool-governance` for external tool and MCP server trust decisions
- `orca-tool-setup` for harness-aware GitHub, Linear, connector, MCP, CLI, and fallback setup
- `orca-runtime-adaptation` for capability-based routing, policy switches, and safe degraded behavior by harness
- `orca-receipts` for compact execution summaries that support review, replay, and restore decisions
- `orca-legacy` for repo archaeology, business logic extraction, and staged modernization planning
- `orca-goal-mode` for converting bounded specs or milestones into durable goal contracts
- `orca-goal-prompt` for creating native `/goal` prompts that work through bounded ORCA plan chunks, delegate blocker fixes, record true blockers, and keep moving
- `orca-next-step` for concise, adaptive phase-exit guidance
- `orca-delegation` for bounded controller-to-executor briefs and structured returns
- `orca-ship` for final release readiness and explicit uploaded or deployed evidence, not just local success
- `orca-ci` for bounded CI triage with actionable failure extraction before code changes
- `orca-pr-feedback` for converting review comments and threads into a numbered remediation queue
- `orca-context` for ambiguity resolution when the user is referring to a recent or visible artifact without naming it directly
- `orca-testflight-release` for Control Studios Apple archive, export, upload, and release-state evidence work
- `orca-testflight-ops` for TestFlight metadata, tester groups, invitations, and public-link operations
- `orca-vercel-deploy` for preview-first Vercel deploys and fallback claimable deploy links
- `orca-session-improvement` for turning real session friction and quality-signal evidence into deduplicated, human-approved framework backlog work
- `orca-integrations` for routing modern startup stacks across web, mobile, auth, payments, analytics, automation, and business systems
- `orca-integration-recommendation` for restrained, best-fit stack recommendations and respectful setup-only support for user-chosen tools
- `orca-graph-vault-support` for low-friction vault inspection and optional graph analysis only when it materially improves understanding
- `orca-corpus-support` for explicit global and project corpus rules, separate reference and write-back permissions, and fail-closed path handling
- `orca-friction-policy` for deciding whether a feature, integration, or workflow surface reduces more friction than it creates
- `orca-adaptive-guidance` for lightweight skill-sensitive coaching, opt-out learning help, and non-condescending prompt or context hints
- `orca-agent-orchestration` for deciding when to delegate, which pattern fits, and how to keep parent and worker boundaries clean
- `orca-ui-debug` for persistent iterative UI debugging where one-pass QA is too weak
- `orca-screenshot` for OS-level and app-level screenshot evidence when tool-specific capture is not enough
- `orca-install-help` for step-by-step install guidance, validation, plugin routing, harness setup help, and failure recovery
- `orca-auto-update` for channel-aware update checks, verification, compatibility gating, staged rollout decisions, and rollback readiness
- `orca-self-improvement` for separating local adaptation from framework evolution and requiring evidence before promotion
- `orca-impeccable` for routing ORCA design work into the maintained Impeccable skill pack with explicit wrapper boundaries
- `orca-superpowers` for routing ORCA build and plan work into the maintained Superpowers workflow when that pack is the strongest fit
