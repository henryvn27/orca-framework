# Codex CLI Host Adapter

Codex CLI support should be verified from the installed CLI help, not from stale assumptions about flags or host behavior.

## ORCA Framework Usage

In Codex CLI, ORCA workflow commands such as `orca-onboard` and `orca-build` are not built-in Codex subcommands.
Use the installed ORCA wrapper when possible so the local CLI invocation stays aligned with the actual `codex exec` surface.

Use native Codex commands when they exist.
Use ORCA command names as workflow guidance in the prompt when they do not.

Current ORCA Framework baseline:

- treat native `/goal` support as part of the normal Codex path, not as a maybe-experimental edge
- treat `orca-goal` as the ORCA contract layer and native `/goal` as the execution layer
- treat `/side` as the preferred native Codex side-session surface for durable adjacent conversations
- treat `orca-explain` as a portable explanation-session concept that should prefer `/side` when available
- treat quick side questions as inline or side-session behavior depending on whether a one-shot native surface exists; do not invent a Codex `/btw` alias
- prefer Codex's native structured question or input surface for setup interviews, onboarding, and clarification when the active Codex surface exposes one
- use `codex doctor` when the user needs Codex environment diagnostics
- treat `/permissions` named profiles and `/status` remote details as real governance and inspection surfaces
- treat `/agent`, `/review`, `/plan`, `/resume`, and `/fork` as real orchestration surfaces when local help confirms them
- use `CODEX_NON_INTERACTIVE=1` for non-interactive install or setup automation when the environment requires it

Use native goal mode when:

- the local CLI supports `/goal`
- the ORCA Framework goal contract is complete
- verification is observable
- approval gates are satisfied

Codex lifecycle mapping:

- `/goal <objective>` starts a goal
- `/goal` shows the current goal
- `/goal pause` pauses it without clearing the objective
- `/goal resume` resumes it
- `/goal clear` removes it

Codex is also a strong executor harness for:

- implementation
- bounded repo research
- QA passes
- issue-focused work
- goal-mode execution when supported and approved

Codex is also a good host for explanation mode when a user wants a dedicated "what is happening and why?" thread that stays interactive without mutating the repo.

## Lifecycle

Codex goal behavior should still be treated as host-specific at the lifecycle-command level. ORCA should prefer the current documented Codex lifecycle surface above. If local command help differs from these docs, follow the local installed version and record the difference in the goal status artifact.

## Explanation Sessions

For `orca-explain`:

- prefer `/side` or another separate explanation thread when the active Codex surface supports it
- otherwise keep explanation mode separate by framing and artifact instead of pretending a UI primitive exists
- keep follow-up questions in the explanation session
- if the user pivots to action, emit a handoff back to the main execution thread instead of doing the work inside explanation mode

For quick side questions:

- if the active Codex surface supports opening another thread or `/side` cleanly, use that for a lightweight adjacent question when durable separation helps
- if not, keep the question inline and clearly label it as a quick side question
- if the question turns into a multi-turn discussion, switch to `orca-explain`

Good side-session candidates in Codex:

- `orca-explain`
- `orca-review`
- `orca-design`
- `orca-research`
- `orca-idea`

## Native Orchestration Surfaces

Codex can be a strong ORCA executor when these native surfaces are available in the installed version:

- `/agent` for switching or managing agent threads
- `/side` for a durable adjacent conversation
- `/plan` for explicit pre-execution planning
- `/review` for a native review pass
- `/resume` and `/fork` for thread continuation and branching

ORCA should prefer these native surfaces over pretending every orchestration move must be rebuilt from scratch.

## Non-Interactive Execution

Check `codex exec --help` before writing automation or docs that depend on specific flags.

For environment diagnostics or install triage, also check:

- `codex doctor`
- `/permissions`
- `/status`

When a user asks "what is going on?" or needs rationale for the current path, ORCA should prefer `orca-explain` over overloading `orca-status` with a long narrative.
When a user asks a quick "by the way" question that should not derail the current task, ORCA should prefer the lightest real side-session surface the active Codex UI supports.
When ORCA needs a short setup or onboarding interview, it should prefer Codex's structured question or input tool when available instead of scattering many plain text prompts across the thread.

At minimum, current Codex CLI help should be treated as authoritative for:

- `-m` / `--model`
- `-c` / `--config`
- `--sandbox`
- `-C` / `--cd`
- `--skip-git-repo-check`
- `-o` / `--output-last-message`

Do not assume flags such as `--full-auto` or older approval aliases exist unless the installed help shows them.

Example pattern:

```sh
orca-build --harness codex --target /path/to/workspace -- "Implement the approved plan"
```

Equivalent raw Codex pattern:

```sh
codex exec \
  --ignore-user-config \
  --skip-git-repo-check \
  -m gpt-5.4 \
  -c 'model_reasoning_effort="medium"' \
  --sandbox workspace-write \
  -C /path/to/workspace \
  "Follow ORCA Framework as workflow guidance: orca-onboard, orca-spec, orca-plan, orca-build, then orca-review."
```

The ORCA wrapper uses `--ignore-user-config` intentionally so broken local skills or memory jobs do not pollute the ORCA user flow.

## Fallback

If `/goal` is unavailable or experimental behavior is not acceptable, use ORCA Framework fallback:

- goal contract
- shared state
- run trace
- goal status artifact
- checkpoints for pause and resume

## Controller To Executor Path

When another harness is controlling the project:

- delegate Codex a bounded task, not open-ended project ownership
- include linked spec, milestone, or goal contract
- require verification and a structured return
- ingest Codex output back through receipt, lineage, and next-step artifacts

## External Tool Setup

Codex setup should be verified against the installed CLI and available connectors. Do not assume every Codex environment exposes the same external tools.

| Service | Preferred methods | Verification | Fallback |
| --- | --- | --- | --- |
| GitHub | connector when available, approved MCP, or `gh` CLI | check auth, repo reachability, and required read/write scope | local repo plus manual issue, PR, check, or release steps |
| GitHub Projects | authenticated connector or `gh` CLI/API with the `project` scope | verify Project access separately from repository issue access | continue safe local work and retain a draft without claiming the Project changed |

Use `orca-check-setup` to validate GitHub repository, issue, PR, and Project access separately. If setup is incomplete but the next phase is local, continue in degraded mode without claiming tracker updates.

## Compatibility View

See [compatibility matrix](../compatibility-matrix.md) and [harness watch](../harness-watch.md) for the current conservative Codex compatibility view.

## Known Friction And Paved Roads

For recurring Codex-host friction seen in real blind product runs (missing `CODEX_HOME`, bounded-command patterns, Playwright module resolution), use:

- [Codex friction kit](codex-friction-kit.md)
- `scripts/codex-host-preflight.sh`

## Source

- https://developers.openai.com/codex/cli/slash-commands
