# Harness Capability Profile

## Harness Name

OpenCode

## Detection Hints

- OpenCode environment or explicit user declaration

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

- prefer MCP-aware setup when validated

## Fallback Rules

- use generic runtime path when capability evidence is missing

## Setup And Integration Caveats

- treat active docs at `dev.opencode.ai` as the primary current-behavior source
- treat the archived `opencode-ai/opencode` GitHub repo as historical context, not as the default runtime source of truth
- other workflow features should be verified per release

## Risk Notes

- do not infer broad workflow support from MCP support alone
- do not imply parity from archived-repo history when the active docs/runtime surface is separate

## Last Reviewed

2026-05-31

## Evidence Links

- https://dev.opencode.ai/docs/mcp-servers/
- https://dev.opencode.ai/docs/cli/
- https://dev.opencode.ai/docs/config/
- https://github.com/opencode-ai/opencode/releases
