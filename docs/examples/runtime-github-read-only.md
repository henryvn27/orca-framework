> Current degraded-mode example. GitHub Issues and Projects remain canonical; missing write access never authorizes a fallback to Linear.

# Runtime Example: GitHub Read-Only

## Situation

The active harness can read GitHub but lacks issue and Project write access.

## Route

- GitHub read integration: connected
- GitHub write permission: missing
- runtime choice: continue scoped local work and never claim tracker updates
- fallback: preserve the GitHub issue URL and prepare exact verification evidence for reporting

## Why

The workflow should keep moving without pretending the system of record is available.
