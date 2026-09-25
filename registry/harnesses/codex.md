# Harness Capability Profile

## Harness Name

Codex

## Detection Hints

- Codex app or Codex CLI environment
- Codex-specific tool availability

## Supported Capabilities

- goal support

## Partial Capabilities

- trace and inspector support
- MCP and tool support
- GitHub integration
- GitHub Projects access (validate separately from repository and issue access)
- setup validation support

## Unsupported Capabilities

- 

## Unclear Capabilities

- memory integration
- shared state and checkpointing beyond portable ORCA Framework artifacts
- approval and governance patterns beyond ORCA Framework policy
- multi-agent coordination support

## Preferred Commands And Workflows

- use `orca-goal` plus native `/goal` as the default Codex goal path
- use `/goal <objective>` to start goal mode, `/goal` to inspect status, and `/goal pause`, `/goal resume`, or `/goal clear` for lifecycle control
- use `orca-check-setup` before external integration-heavy steps
- use `codex doctor` for local environment diagnostics before blaming ORCA Framework

## Fallback Rules

- use portable goal contracts if local `/goal` behavior is unavailable
- use manual or local artifact fallbacks for missing integrations

## Setup And Integration Caveats

- local capability varies by installed Codex environment
- GitHub Projects CLI/API writes require authenticated Project scope; validate it in the active host before changing Project fields

## Risk Notes

- do not assume external tool parity across Codex installations

## Last Reviewed

2026-06-02

## Evidence Links

- https://developers.openai.com/codex/cli/slash-commands
- https://github.com/openai/codex/releases
