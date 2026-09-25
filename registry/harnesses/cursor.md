# Harness Capability Profile

## Harness Name

Cursor

## Detection Hints

- Cursor environment or explicit user declaration

## Supported Capabilities

- MCP and tool support

## Partial Capabilities

- GitHub integration
- GitHub Projects access (validate separately from repository and issue access)

## Unsupported Capabilities

- 

## Unclear Capabilities

- goal support
- memory integration
- shared state and checkpointing
- trace and inspector support
- approval and governance patterns
- multi-agent coordination support
- setup validation support

## Preferred Commands And Workflows

- use documented MCP path when validated

## Fallback Rules

- generic workflow and manual service fallback

## Setup And Integration Caveats

- MCP catalog presence does not guarantee account-level auth or write scope

## Risk Notes

- avoid stronger routing claims until non-MCP workflow support is verified

## Last Reviewed

2026-05-30

## Evidence Links

- https://docs.cursor.com/context/model-context-protocol
- https://docs.cursor.com/en/tools/mcp
