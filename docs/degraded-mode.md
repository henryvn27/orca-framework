# Degraded Mode

Degraded mode lets ORCA Framework continue when an external integration is missing, optional, or partially available.

## Principles

- Do not block local work for optional tools.
- Preserve the system of record through local artifacts when direct writes are unavailable.
- State what the user must do manually.
- Record the missing capability so future agents do not assume full setup.

## Examples

### GitHub Issue or Project Access Unavailable

Continue only safe local work. Preserve the exact missing permission and prepare a local draft of any issue comment or Project update. Do not claim that GitHub state changed; resume the canonical issue/Project update when authenticated access is available.

### No MCP Support

Use a CLI helper, native connector, browser workflow, or manual copy/paste path. Do not claim MCP-only features are available.

### Read-Only Access

Read service context, then produce a local write artifact for the authorized GitHub writer. Do not silently treat the draft as a tracker update.

## Done Condition

Degraded mode is acceptable when the user can still complete the ORCA Framework phase with clear manual steps and no hidden loss of evidence.
