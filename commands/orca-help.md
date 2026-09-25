# orca-help

## Purpose

Show the ORCA workflow, `/goal` usage, GitHub Issues/Projects default, Mission-only fallback, optional Notion integration, and recommended next command.

## When To Use

Use when a user asks what ORCA Framework can do, how to start, or which command fits the current situation.

## Required Inputs

- Current project state or user goal

## Optional Inputs

- GitHub issue URL or number and Project (default for engineering work)
- `.orca/` Mission only when the user explicitly requests local-only tracking
- Optional linked Notion project page
- Existing artifacts
- Target platform
- Known blockers

## Backend Context

- GitHub-first mode: GitHub Issues and Projects are the canonical queue and status record.
- Mission-only mode: use `.orca/` as the work record only when the user explicitly requests local-only tracking.
- Notion remains an optional integration and does not replace the GitHub engineering ledger.

## Workflow

1. Identify whether the user needs intake, discovery, spec, planning, build, review, QA, security, shipping, or retro.
2. Identify the current GitHub issue and Project, or the explicit Mission-only record.
3. If the user mainly wants to understand what is happening or why ORCA chose a path, route to `orca-explain`.
4. If the user only wants one quick side question answered without derailing the main thread, route to the host's lightest side-question path or `orca-btw` behavior.
5. Summarize the next two useful commands.
6. Explain what artifact or issue comment each command will produce.
7. Call out whether blind QA can still be preserved.

## Outputs And Artifacts

- Recommended command
- Reasoning for command choice
- Artifact or comment expectation

## Failure Cases

- If the goal is unclear, ask one clarifying question.
- If blind QA has already been contaminated, recommend briefed QA instead.

## Related Commands And Skills

- Commands: all ORCA Framework commands, especially `orca-explain` for interactive rationale and `orca-btw` behavior for quick side questions
- Skills: `orca-core`, `orca-github-core`
