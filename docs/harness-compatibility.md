# Harness Compatibility

Harness compatibility is ORCA Framework's answer to "what works where." It tracks which host environments support the capabilities and integrations ORCA Framework depends on, and how confidently those claims are backed by current evidence.

## What ORCA Framework Tracks

ORCA Framework tracks harnesses it targets directly or watches closely:

- Codex
- Claude Code
- OpenCode
- Cursor
- GitHub Copilot
- other harnesses when they become materially relevant

## Capabilities That Matter

ORCA Framework cares about capabilities that affect real workflow quality:

- goal or long-running objective support
- run memory or long-term memory support
- shared state and checkpointing
- trace, inspector, or observability support
- tool and MCP integration support
- GitHub integration options
- Linear integration options
- approval, policy, and governance features
- multi-agent or coordinator patterns
- regression, eval, and benchmark support

## How To Read The Matrix

The compatibility matrix uses conservative status labels:

- `supported`: current evidence shows the capability is available in a way ORCA Framework can likely use
- `partial`: the capability exists with important caveats, external setup, or reduced ergonomics
- `not supported`: current evidence indicates the capability is absent or blocked
- `unclear`: evidence is missing, conflicting, or too weak to recommend a claim

Do not treat `supported` as "equivalent across harnesses." Native support, MCP support, connector support, and manual fallback are different qualities of support.

## Artifacts

- [compatibility matrix](compatibility-matrix.md) is the concise current view
- [harness watch](harness-watch.md) tracks changes, caveats, and draft-issue-worthy shifts
- dated compatibility snapshots should be generated outside the tracked repository
- accepted compatibility changes should be promoted back into the docs above

## Limited-Support Behavior

When the current harness lacks a capability ORCA Framework prefers:

- use degraded mode instead of inventing support
- keep the limitation explicit in next-step guidance
- prefer local artifacts and manual follow-up over false automation
- open a draft issue only when the compatibility change is strong enough to justify a framework update
