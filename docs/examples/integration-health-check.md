# Integration Health Check

## Example Report

| Service | Reachable | Authenticated | Scope Sufficient | Harness Capable | Status |
| --- | --- | --- | --- | --- | --- |
| GitHub Issues and Projects | yes | yes | read only | yes | available read-only |
| Linear | retired | disabled | not applicable | not applicable | historical only |

## Recommendation

Continue local repository work using the available GitHub issue context. Because GitHub write access is read-only, do not claim to have updated issues or Projects and do not fall back to Linear. Prepare the scoped changes and verification evidence, then report the missing GitHub write permission.
