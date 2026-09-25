# iOS Simulator MCP QA

ORCA Framework can use an iOS simulator MCP server when available. The framework does not require a specific server implementation, but the QA workflow assumes the agent can build or launch the app, interact with simulator UI, inspect accessibility-visible elements, and capture screenshots or logs when supported.

## GitHub Coordination

The GitHub issue should provide:

- Issue ID
- App or scheme launch instructions
- Simulator target when relevant
- Optional one-sentence user mission for blind QA

The blind tester should not receive the spec, code, implementation plan, design rationale, or PR discussion. It posts findings back to the issue using `templates/github-issue-update.md` after the blind report is saved.

## Blind Pass

During a blind pass, the tester may only use what the app exposes. The tester should infer the product, identify primary actions, try plausible flows, and document where the app fails to communicate intent.

## Briefed Pass

During a briefed pass, the tester receives a context packet from `orca-context-brief`. The packet should list included goals, withheld implementation details, target fixes, and known constraints.

## Report

Use `templates/blind-qa-report.md` for blind iOS passes and `templates/guided-qa-report.md` for briefed passes. Post a concise issue update after the report is saved. Include simulator model, OS version, app build source, interactions attempted, screenshots captured, accessibility observations, and reproduction steps.
