# External Tool Setup

External tools are services or local capabilities ORCA Framework can use to coordinate, inspect, or publish work outside the immediate repository. Examples include GitHub Issues/Projects, browser automation, CI, release systems, and MCP servers.

Read [install.md](install.md) first if core ORCA install is not finished yet. External tool setup should not outrun the base install.

This setup layer decides which tools are needed for the current workflow, how the current harness can access them, how to validate access, and what fallback is available when setup is incomplete.

## Required vs Optional

A tool is required only when the next ORCA Framework action cannot be completed without it.

Examples:

- GitHub access is required to read or update the canonical engineering issue or Project directly, and to open a PR or inspect its checks.
- GitHub access may be deferred for a local Mission-only action when the user explicitly requests local-only work.
- Use the authenticated GitHub connector or CLI with only the scopes needed for the current action; do not put tokens in repository files.

Do not tell the user to install a tool unless it is required for the next action.

## Three Setup Axes

Keep these separate:

- Service integration: the external service, normally GitHub for engineering work.
- Transport or integration method: native connector, MCP server, API token, plugin, CLI helper, or manual copy/paste.
- Harness or host surface: Codex, Claude Code, VS Code, or a generic terminal/editor.

The same service may have different setup paths in different hosts.

## Decision Process

1. Identify the next ORCA Framework phase.
2. List tools needed for that phase.
3. Mark each tool as required or optional.
4. Detect or ask which harness is being used.
5. Choose the shortest viable setup path for that harness.
6. Validate reachability, authentication, scope, and write capability when safe.
7. Continue in degraded mode if the tool is optional or a manual fallback exists.

Runtime adaptation should choose the shortest valid setup path for the active host rather than the richest path available in some other harness.

## Fallback Behavior

Fallbacks should be explicit and practical:

- no GitHub connection: continue only safe local work, preserve the exact missing capability, and do not claim tracker updates or delivery
- no MCP support: use CLI, browser, or manual artifact workflows
- insufficient write scope: read what is available and ask the user to perform the write step

Record the fallback in the setup status so later agents do not assume full integration. Linear references retained in imported history are provenance only and are not a supported execution path.
