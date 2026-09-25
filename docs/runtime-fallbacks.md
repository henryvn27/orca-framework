# Runtime Fallbacks

For each major capability, ORCA Framework should define:

- preferred path
- acceptable fallback
- degraded behavior
- blocked behavior

## Capability Rules

### Goal Support

- Preferred: host-native goal mode when supported and reviewed
- Fallback: ORCA Framework milestone plus goal-contract artifacts
- Degraded: standard implementation loop with explicit checkpoints
- Blocked: no goal recommendation for risky or unclear support

### Memory And Checkpoints

- Preferred: harness-native support when supported and reviewed
- Fallback: ORCA Framework run memory, shared state, and checkpoint artifacts
- Degraded: local artifact-only continuity
- Blocked: none, as long as durable artifacts remain available

### GitHub Issues And Projects

- Preferred: validated native connector or approved MCP path
- Fallback: CLI helper, token path, or manual artifact flow
- Degraded: local artifacts plus manual posting
- Blocked: direct write workflows when auth or scope is insufficient
