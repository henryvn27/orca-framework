# orca-mcp-review

## Purpose

Review an MCP server or MCP tool integration before allowing or expanding use.

## When To Use

Use before adding a new MCP server, exposing new tools, changing server permissions, or approving high-risk MCP calls.

## Required Inputs

- MCP server name
- Source or owner
- Intended use

## Optional Inputs

- Version or pin
- Exposed tool list
- Permission scope
- Prior registry entry

## GitHub Context

- Expects: issue ID when tied to setup or workflow work, proposed server, permission scope, risk context
- Reads: MCP registry, server docs, config snippets, approval records, and security notes
- Posts: MCP review result, constraints, trust status, and registry update
- Trigger: new MCP server, server upgrade, permission change, high-risk MCP tool use
- Human approval: required when the server can mutate important data or account-level state

## Opt-Out Context

Store the MCP review in the chosen durable record and update `registry/mcp-servers/`.

## Workflow

1. Use `orca-tool-governance`.
2. Review source, version, exposed tools, and permission scope.
3. Identify risky behaviors and parameter validation expectations.
4. Assign trust status.
5. Record approval or checkpoint requirements.
6. Update or draft the MCP registry entry.

## Outputs And Artifacts

- `templates/mcp-review.md`
- `templates/mcp-server-entry.md`
- registry entry in `registry/mcp-servers/`

## Failure Cases

- If exposed tools or permissions are unclear, default to `approval required`.
- If the server cannot be pinned or trusted enough for the intended use, mark it constrained or blocked.

## Related Commands And Skills

- Commands: `orca-tool-review`, `orca-approve`, `orca-checkpoint`, `orca-security-check`
- Skills: `orca-tool-governance`, `orca-security`
