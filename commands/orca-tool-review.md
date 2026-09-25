# orca-tool-review

## Purpose

Review an external tool and assign an explicit ORCA Framework trust status.

## When To Use

Use before introducing a new tool, calling a high-risk tool, or expanding a tool's allowed context.

## Required Inputs

- Tool name
- Purpose
- Source or owner
- Intended use

## Optional Inputs

- Permission scope
- Example parameters
- Prior registry entry

## GitHub Context

- Expects: issue ID when tied to a work item, proposed tool use, risk context
- Reads: registry entries, approval decisions, security notes, and relevant tool docs
- Posts: trust decision, constraints, approval requirements, and registry update
- Trigger: new tool, high-risk tool call, permission expansion
- Human approval: required for approval-required or high-risk calls

## Opt-Out Context

Store the tool review in the chosen durable record and update the registry when relevant.

## Workflow

1. Use `orca-tool-governance`.
2. Identify the source, purpose, and permission scope.
3. List risky behaviors and validation requirements.
4. Assign trust status.
5. Update or draft a registry entry.

## Outputs And Artifacts

- `templates/tool-registry-entry.md`
- registry entry in `registry/tools/`

## Failure Cases

- If source or permission scope is unclear, default to `approval required`.
- If behavior is unsafe or unverifiable, mark the tool `blocked`.

## Related Commands And Skills

- Commands: `orca-mcp-review`, `orca-approve`, `orca-checkpoint`, `orca-security-check`
- Skills: `orca-tool-governance`, `orca-security`
