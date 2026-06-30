# Harness Watch

This watchlist tracks harness-level compatibility shifts that affect ORCA Framework guidance, workflows, or documentation.
Track not only what hosts can do, but whether host-specific features are adding or removing user friction when surfaced through ORCA Framework.

## What To Track

- added support
- removed or broken support
- improved setup paths
- degraded setup paths
- newly documented caveats
- changes that should update ORCA Framework docs or commands

## Current Snapshot Inputs

Use these artifacts together:

- [runtime adaptation](runtime-adaptation.md)
- [compatibility matrix](compatibility-matrix.md)
- [ecosystem watch](ecosystem-watch.md)
- [ecosystem opportunities](ecosystem-opportunities.md)

## Active Harness Shifts

### Codex

- Baseline moved beyond the earlier `0.133.0` goal-support shift.
- Current sweep evidence points to a `0.135.0` baseline with stronger `codex doctor`, `/permissions`, `/status`, and non-interactive setup guidance.
- ORCA Framework docs should treat native `/goal` as the default Codex path when the installed help still exposes it.

### Claude Code

No active shifts yet.

### OpenCode

- Tracking should split between active docs/runtime behavior and the archived legacy GitHub repo.
- ORCA Framework should cite active docs first when making current-behavior claims.

### Cursor

No active shifts yet.

### GitHub Copilot

No active shifts yet.

## Adopt-Now Compatibility Changes

List compatibility shifts here when they should trigger an ORCA Framework update immediately.

- Refresh ORCA Framework Codex guidance for default goal support and newer governance surfaces.
- Refresh ORCA Framework Linear setup guidance around the official Linear MCP server.
- Split ORCA Framework OpenCode tracking between active docs/runtime behavior and the archived legacy repo.

## Compatibility Research Notes

- verify uncertain harness capabilities before promoting them from `unclear`
- prefer official docs and release notes over secondary summaries
- record broken or deprecated paths before removing them from recommendations
- watch the improvement backlog for repeated harness pain that should become a compatibility or runtime update
- watch for harness-native subagent or worker features that change the best fallback mapping for ORCA orchestration
