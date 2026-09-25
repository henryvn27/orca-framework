# Harness Capability Profile

## Harness Name

Generic

## Detection Hints

- no strong host signal
- conflicting or weak detection evidence

## Supported Capabilities

- 

## Partial Capabilities

- MCP and tool support
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

- use host-neutral ORCA Framework commands and portable artifacts

## Fallback Rules

- generic safe path first

## Setup And Integration Caveats

- ask for host only when it changes the safe path materially

## Risk Notes

- unknown harness should tighten automation defaults

## Last Reviewed

2026-05-30

## Evidence Links

- local ORCA Framework fallback policy
