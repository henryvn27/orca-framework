# Generic Host Adapter

Use this adapter when the active harness is unknown or does not have a dedicated ORCA Framework host guide.

## External Tool Setup

| Service | Preferred methods | Verification | Fallback |
| --- | --- | --- | --- |
| GitHub | `gh` CLI, approved MCP, API token, or manual | check auth, repo read, and required write scope | local repo plus manual issue, PR, checks, or release actions |
| GitHub Projects | authenticated connector or approved CLI/API | verify Project access separately from issue and PR access | safe local work plus an update draft; do not claim tracker writes |

## Guidance

Ask for the harness only when it changes the next setup step. Otherwise give a generic path and a manual fallback.

Do not assume MCP support. Do not assume write permissions. Validate each layer separately.
Do not assume side-chat, popout, or `/btw` support. If the host is unknown, keep side sessions separate by framing and artifact instead of claiming a native UI behavior.

## Compatibility View

See [compatibility matrix](../compatibility-matrix.md) and [harness watch](../harness-watch.md) when deciding whether to keep a claim generic or host-specific.
