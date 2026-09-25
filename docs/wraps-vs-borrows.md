# Wraps Vs Borrows

This document explains a distinction ORCA Framework should make clearly on GitHub.

## Wraps

ORCA Framework `wraps` something when it provides a structured interface around a real external service, host, or tool.

Examples in this repository:

- GitHub issue, Project, and workflow coordination
- GitHub repository, PR, issue, check, and release workflows
- MCP-based setup and governance around external MCP servers
- host adapters for Codex CLI, Claude Code, VS Code, and generic hosts

When ORCA Framework wraps something:

- the external project still matters directly
- setup and auth affect the workflow
- compatibility and permission limits should be documented
- the upstream project should be easy to find in [UPSTREAM.md](../UPSTREAM.md)

## Borrows

ORCA Framework `borrows` when it adopts or adapts an idea, framing, or workflow pattern without directly shipping the upstream tool.

Examples in this repository:

- spec-first sequencing influenced by broader spec-driven development ecosystems
- customer-discovery and smallest-experiment thinking in the ideation lane
- venture-style written evaluation lenses for opportunities

When ORCA Framework borrows:

- explain the influence plainly
- do not imply code reuse if there is none
- do not hide the influence behind vague wording

## Supports Or Integrates

Sometimes ORCA Framework neither fully wraps nor materially borrows. It may simply support or document compatibility with another system.

Examples:

- a host adapter that explains how to use ORCA Framework in that host
- an ecosystem watch entry that tracks a repo or host for compatibility reasons

## Reimagines Or Extends

ORCA Framework can also extend upstream patterns:

- turning spec-driven patterns into a broader artifact-and-gate framework
- combining shared state, receipts, lineage, replay, compatibility routing, and human checkpoints
- using the same underlying services across multiple harnesses with stricter provenance and governance records

That is real work, but it should still credit upstreams clearly.
