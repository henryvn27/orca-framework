# Feature Routing

Feature routing is the decision layer that maps workflow intent to the best available harness path.

## Common Routing Decisions

ORCA Framework should route dynamically for:

- goal mode versus standard milestone flow
- MCP-based setup versus manual fallback
- native integration versus generic workflow
- host-specific shortcuts versus host-neutral guidance
- native memory or checkpoint features versus portable ORCA Framework artifacts

## Routing Rules

- If goal support is `supported` and the task is a good candidate, recommend goal mode.
- If goal support is `partial`, explain caveats and keep the portable fallback visible.
- If goal support is `not supported` or `unclear`, do not make goal mode the default path.
- If GitHub issue/Project access is unavailable, do not claim a tracker update; continue safe local work and preserve a draft for the authorized writer.
- If GitHub issue access is available but Project scope is missing, continue issue-level work while recording that Project state was not updated.
- If tool governance is weak or unclear, tighten approval and avoid aggressive automation defaults.

## Output

The chosen route should be inspectable in runtime status artifacts.
