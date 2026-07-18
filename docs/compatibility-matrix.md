# Compatibility Matrix

## Orca 1.0 Product Platforms

| Platform | Native launcher | Installer | Mission lifecycle | Dashboard | Hosted installed-copy acceptance |
| --- | --- | --- | --- | --- | --- |
| macOS | POSIX `orca` | shell + Homebrew | supported | supported | required |
| Linux | POSIX `orca` | shell + Homebrew | supported | supported | required |
| Windows | `orca.cmd` + PowerShell | PowerShell | supported | supported | required |

Ruby 2.6 or newer is the runtime contract. Mission Control and the dashboard use the Ruby standard library only.

## Optional Agent Harnesses

This matrix records harness-level compatibility conservatively. Do not assume parity across hosts. If evidence is weak or conflicting, use `unclear`.

Status meanings:

- `supported`
- `partial`
- `not supported`
- `unclear`

## Current Matrix

| Harness | Goal mode | Run memory | Shared state / checkpoints | Trace / inspector | Tool / MCP support | GitHub integration | Linear integration | Approval / governance | Multi-agent patterns | Regression / eval / benchmark | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Codex | supported | partial | partial | partial | partial | partial | partial | partial | unclear | unclear | `/goal` is a normal current path with documented set, status, pause, resume, and clear commands; external integrations still depend on local configuration, RMCP flags, and available tools. |
| Claude Code | supported | unclear | partial | unclear | partial | partial | partial | unclear | unclear | unclear | `/goal` is documented and should be preferred when version, workspace trust, and hooks policy allow it; service setup still depends on local configuration. |
| OpenCode | unclear | unclear | unclear | unclear | supported | partial | partial | unclear | unclear | unclear | Use active `dev.opencode.ai` docs for current behavior; treat the archived GitHub repo as historical context only. |
| Cursor | unclear | unclear | unclear | unclear | supported | partial | partial | unclear | unclear | unclear | Cursor documents MCP support and a curated MCP server catalog, including GitHub and Linear entries. |
| GitHub Copilot | unclear | unclear | unclear | unclear | supported | supported | partial | partial | unclear | unclear | Copilot documents MCP support, policy controls, and a built-in GitHub MCP path in supported surfaces. |
| VS Code | unclear | unclear | unclear | unclear | supported | partial | partial | unclear | unclear | unclear | Depends on the active extension and workspace policy. |
| Generic host | unclear | unclear | unclear | unclear | partial | partial | partial | unclear | unclear | unclear | Fall back to CLI, approved MCP, token, or manual workflows. |

## Footnotes

- `supported` does not imply native support. A capability may rely on MCP, connectors, or manual setup.
- GitHub and Linear integration columns reflect viable integration options, not guaranteed built-in connectors.
- Update automation should also respect harness reality. A host that can run ORCA is not automatically cleared for the same update mode or channel policy as every other host.
- Knowledge-layer integrations such as NotebookLM depend heavily on setup mode and host tooling; treat enterprise API paths and community MCP paths separately.
- Graph or vault tooling should be treated as optional helper support, not as part of the minimum compatible path.
- Feature visibility should stay tiered. Host capability is not a reason to surface every possible feature by default.
- Local adaptation to one harness should not silently become a global compatibility claim without stronger evidence.
- Integration routing should also respect platform category, especially web deployment versus mobile build or billing workflows.
- Compatibility should inform what is possible, not automatically what is recommended.
- `unclear` means ORCA Framework should prefer degraded mode or an explicit research note over a stronger claim.

## Related Artifacts

- [runtime adaptation](runtime-adaptation.md)
- [harness compatibility](harness-compatibility.md)
- [harness watch](harness-watch.md)
- generated compatibility reports should stay outside the tracked repository

Reviewed compatibility knowledge informs runtime behavior only after maintainers accept the change. New research should not become an automatic runtime default until reviewed or classified as `Adopt now`.

Use receipts and replay results as evidence before converting a newly supported harness path into a default runtime route.
Session-improvement candidates that repeatedly cite the same harness mismatch should be linked from [improvement-backlog](improvement-backlog.md) and can justify matrix or host-guide updates even before a larger ecosystem sweep lands.

## Fallback

When native goal mode is missing or uncertain, use:

- [templates/goal-contract.md](../templates/goal-contract.md)
- [templates/goal-status.md](../templates/goal-status.md)
- shared state
- traces
- checkpoints
- run memory

When external integrations are missing or uncertain, use:

- [templates/tool-requirements.md](../templates/tool-requirements.md)
- [templates/integration-status.md](../templates/integration-status.md)
- [docs/degraded-mode.md](degraded-mode.md)
