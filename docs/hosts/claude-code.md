# Claude Code Host Adapter

Claude Code documents `/goal` as a session-scoped command that keeps working across turns until a completion condition is met.

ORCA Framework should treat `orca-explain` the same way it treats other portable workflow commands: use a native side-thread behavior only when Claude clearly supports it, otherwise keep the explanation session separate by framing and artifact.
Claude Code also exposes `/btw` for quick side questions, so ORCA should use that for one-shot "by the way" prompts instead of opening a full explain session when follow-up is not needed.
Claude Code also exposes stronger native orchestration surfaces such as `/agents`, `/branch`, `/resume`, and `/batch`, which ORCA should treat as first-class host capabilities when present.
When Claude exposes a native structured question or selection surface, ORCA should use that for setup and onboarding interviews instead of always asking raw text questions.

## ORCA Framework Usage

Use native `/goal` when:

- Claude Code version supports it
- workspace trust requirements are satisfied
- the ORCA Framework goal contract is complete
- the completion condition can be evaluated from surfaced evidence

Claude goal requirements and lifecycle:

- `/goal` requires Claude Code `v2.1.139` or later
- `/goal <condition>` starts the goal immediately
- `/goal` shows the current goal state
- `/goal clear` stops it early
- active goals can restore when the session is resumed
- `/goal` is unavailable when hooks are disabled or workspace trust is missing

## Lifecycle

Claude Code documents:

- setting a goal with `/goal <condition>`
- viewing status with `/goal`
- clearing with `/goal clear`
- resuming a session with an active goal according to host behavior

ORCA Framework should still track lifecycle in `templates/goal-status.md`.

## Explanation Sessions

For `orca-explain`:

- prefer `/branch` for a durable adjacent conversation when the active Claude surface clearly supports it
- otherwise keep explanation mode separate by framing and artifact instead of claiming a UI primitive Claude may not expose here
- keep follow-up questions inside the explanation session
- when the user pivots to action, emit a structured handoff back to the main execution thread instead of executing from explanation mode

For quick side questions:

- use `/btw <question>` when the user wants a one-shot side answer that should not clutter the main conversation
- do not use `/btw` for tool-backed research, file reads, or multi-turn discussion
- if the user needs follow-up questions or a durable explainer, switch to `orca-explain`

Good side-session candidates in Claude Code:

- `orca-explain`
- `orca-review`
- `orca-design`
- `orca-research`
- `orca-idea`

## Native Orchestration Surfaces

Claude Code can be a strong ORCA orchestrator when these native surfaces are available:

- `/agents` for specialized subagents
- `/branch` for durable side-session branching
- `/resume` for returning to prior threads
- `/batch` for parallel codebase-wide task decomposition
- `/background` and `/tasks` for durable detached work

ORCA should route into these host capabilities when they fit instead of hiding them behind generic wording.

## Fallback

If host requirements are not met, run the same goal contract through normal ORCA Framework workflow with shared state, traces, checkpoints, and status artifacts.

## External Tool Setup

Claude Code supports MCP-based tool setup, but individual service availability and authentication depend on the user's local configuration and workspace trust.

| Service | Preferred methods | Verification | Fallback |
| --- | --- | --- | --- |
| GitHub | Claude-supported MCP or host connector when configured | read target repo, issue, or PR before writing | local repo plus manual issue or PR text |
| GitHub Projects | authenticated GitHub connector or approved CLI/MCP path | verify Project read/write scope separately from repository issue access | continue safe local work and retain an issue/Project update draft without claiming it was posted |

Use conservative setup language. If MCP auth fails or the server is unavailable, switch to manual artifacts instead of blocking unrelated local work.

When the user wants a narrative explanation of current state, rationale, or blockers, route to `orca-explain` instead of overloading `orca-status` or `orca-inspect`.
When the user asks a quick side question about current context, prefer `/btw` when that is enough.
When ORCA needs short setup or onboarding answers, prefer Claude's structured question surface when available; otherwise keep the text interview grouped and short.

## Compatibility View

See [compatibility matrix](../compatibility-matrix.md) and [harness watch](../harness-watch.md) for the current conservative Claude Code compatibility view.

## Sources

- https://code.claude.com/docs/en/goal
- https://code.claude.com/docs/en/commands
- https://code.claude.com/docs/en/mcp
