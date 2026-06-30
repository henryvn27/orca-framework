# Changelog

## Unreleased

- Add a layered docs system with start-here flow, guide layer, wiki knowledge base, docs automation, staleness detection, and contributor doc maintenance rules.

### Added

- Added `orca-goal-prompt` for creating native `/goal` prompts that work through bounded ORCA plan chunks, delegate blocker fixes, record true blockers, and keep moving.
- Added default GitHub hygiene guidance for repo work, including scoped branches, PR expectations, protected-branch safety, and Scoutly-specific branch policy.
- Added an auto-update architecture with update channels, update modes, update discovery and verification, rollback and recovery policy, staged rollout guidance, update UX artifacts, and ORCA update command surfaces.
- Added background mode and keep-making-progress support with autonomy levels, loop guards, permission handling, risk tiers, and resumable background receipts.
- Added a dedicated business-ideation and venture-evaluation lane with idea one-pagers, evaluation lenses, research briefs, opportunity memos, validation plans, and `orca-idea` workflow commands.
- Added harness-aware runtime adaptation with capability profiles, detection rules, runtime routing, policy switches, status artifacts, and safe fallbacks.
- Upgraded the ecosystem sweep to watch GitHub, Linear, MCP, connector, auth, permission, and host-specific setup-path changes.
- Added harness-aware external tool setup for GitHub and Linear, including setup commands, validation artifacts, host guides, and degraded-mode fallbacks.
- Added adaptive next-step guidance for phase exits, including tone rules, experience adaptation, phase templates, examples, and the `orca-next` command.
- Upgraded the recurring ecosystem sweep to track harness-native execution capabilities, maintain ecosystem opportunities, and require explicit capability-to-ORCA Framework mapping.
- Added ecosystem sweep automation artifacts, including tracked sources, living watch document, draft adopt-issue template, and promotion-history rules.
- Added observability, trajectory evals, approval gates, artifact contracts, security guardrails, and prompt-injection guidance.
- Added onboarding/spec benchmark pack, workflow accounting, and QA-to-regression task generation.
- Added shared state, human checkpoints, and run inspection for multi-agent coordination and resumable runs.
- Added version-control and iteration guidance with an iteration log template.
- Added tool trust and MCP governance docs, registry templates, review commands, and trust-level guidance.
- Added legacy modernization workflow with repo archaeology, legacy audit, risk report, modernization spec, and staged migration guidance.
- Added goal mode support with goal contracts, status tracking, safety rules, host adapters, and host-neutral ORCA Framework goal commands.
- Added a portable artifact schema layer with versioned schemas, mapping guidance, validation guidance, and ORCA Framework schema commands.
- Added controller-agent orientation, delegation, ingestion, and controller/executor compatibility support for multi-harness ORCA Framework workflows.

### Validation

- Added reliability and improvement-system validation scripts and CI workflow definitions.

### Known Blockers

- Branches that modify `.github/workflows/*` require GitHub credentials with workflow-file permission before push.

## 0.1.0 - 2026-05-30

Initial public release candidate.

- Added ORCA Framework operating manual.
- Added Linear-first workflow model with explicit opt-out support.
- Added Linear setup workflow for states, labels, guidance, permissions, smoke tests, and opt-out mapping.
- Added installable command definitions.
- Added Linear-specific command definitions.
- Added reusable skill definitions.
- Added Linear-specific skill definitions.
- Added copy-ready workflow templates.
- Added Linear issue comment templates.
- Added local and global install scripts.
- Added validation, markdown, and link checking scripts.
- Added GitHub issue templates, PR template, funding metadata, and CI workflows.
- Added MCP examples for Linear coordination, iOS simulator QA, and browser QA.
