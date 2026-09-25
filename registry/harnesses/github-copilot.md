# Harness Capability Profile

## Harness Name

GitHub Copilot

## Detection Hints

- GitHub Copilot chat or CLI environment

## Supported Capabilities

- MCP and tool support
- GitHub integration

## Partial Capabilities

- GitHub Projects access (validate separately from repository and issue access)
- approval and governance patterns

## Unsupported Capabilities

- 

## Unclear Capabilities

- goal support
- memory integration
- shared state and checkpointing
- trace and inspector support
- multi-agent coordination support
- setup validation support

## Preferred Commands And Workflows

- use GitHub-native or MCP-backed paths when validated

## Fallback Rules

- use local artifacts and manual tracker fallback for non-GitHub services

## Setup And Integration Caveats

- supported surfaces vary by Copilot host and extension

## Risk Notes

- do not assume GitHub-native strength extends to other integrations

## Last Reviewed

2026-05-30

## Evidence Links

- https://docs.github.com/en/copilot/concepts/context/mcp
- https://docs.github.com/en/copilot/how-tos/provide-context/use-mcp/extend-copilot-chat-with-mcp
