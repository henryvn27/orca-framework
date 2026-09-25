# Harness Capability Profiles

Harness capability profiles are the inspectable runtime records ORCA Framework uses to route behavior safely.

## Purpose

Each profile captures what a harness clearly supports, partially supports, does not support, or still leaves unclear.

## Required Fields

- harness name
- detection hints
- supported capability set
- partial capability set
- unsupported capability set
- unclear capability set
- preferred commands and workflows
- fallback rules
- setup and integration caveats
- risk notes
- last reviewed date
- evidence links

## Capabilities

At minimum track:

- goal support
- memory integration
- checkpointing
- trace and inspector support
- GitHub repository, Issues, PRs, and Projects access (track separately when their scopes differ)
- MCP and tool support
- approval and governance patterns
- multi-agent coordination support
- side-session support
- branch or resume support
- background task support
- setup validation support

## Relationship To The Matrix

The matrix is the fast summary. Profiles hold the detail that justifies runtime choices.

## Location

Profiles live in `registry/harnesses/`.
