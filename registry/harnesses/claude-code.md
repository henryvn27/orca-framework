# Harness Capability Profile

## Harness Name

Claude Code

## Detection Hints

- Claude Code environment
- Claude Code-specific MCP setup context

## Supported Capabilities

- goal support

## Partial Capabilities

- shared state and checkpointing
- MCP and tool support
- GitHub integration
- GitHub Projects access (validate separately from repository and issue access)

## Unsupported Capabilities

- 

## Unclear Capabilities

- memory integration
- trace and inspector support
- approval and governance patterns
- multi-agent coordination support
- setup validation support

## Preferred Commands And Workflows

- use `orca-goal` plus native `/goal` as the default Claude Code goal path when workspace trust and hooks policy allow it
- use `/goal <condition>` to start goal mode, `/goal` to inspect status, and `/goal clear` to stop it early
- prefer MCP-based setup when validated

## Fallback Rules

- fall back to portable ORCA Framework artifacts when MCP or service setup is missing

## Setup And Integration Caveats

- local MCP configuration and auth still determine real usability
- `/goal` requires Claude Code `v2.1.139` or later and is unavailable when hooks are disabled or workspace trust is missing

## Risk Notes

- do not assume documented MCP support means service integrations are already available

## Last Reviewed

2026-06-02

## Evidence Links

- https://code.claude.com/docs/en/goal
- https://code.claude.com/docs/en/commands
- https://code.claude.com/docs/en/mcp
