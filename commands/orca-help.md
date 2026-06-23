# orca-help

## Purpose

Show the ORCA workflow, `/goal` usage, Notion default, markdown fallback, optional Linear adapter, and recommended next command.

## When To Use

Use when a user asks what ORCA Framework can do, how to start, or which command fits the current situation.

## Required Inputs

- Current project state or user goal

## Optional Inputs

- Notion project page or Issue Board item
- `.orca/` markdown issue/task
- Linear issue ID when Linear is explicitly selected
- Existing artifacts
- Target platform
- Known blockers

## Backend Context

- Notion mode: treat the project page and Issue Board as canonical.
- Markdown mode: use `.orca/` files as canonical fallback.
- Linear mode: use Linear only when explicitly selected.

## Workflow

1. Identify whether the user needs intake, discovery, spec, planning, build, review, QA, security, shipping, or retro.
2. Confirm Notion, markdown fallback, or explicit Linear mode.
3. If the user mainly wants to understand what is happening or why ORCA chose a path, route to `orca-explain`.
4. If the user only wants one quick side question answered without derailing the main thread, route to the host's lightest side-question path or `orca-btw` behavior.
4. Summarize the next two useful commands.
5. Explain what artifact or issue comment each command will produce.
6. Call out whether blind QA can still be preserved.

## Outputs And Artifacts

- Recommended command
- Reasoning for command choice
- Artifact or comment expectation

## Failure Cases

- If the goal is unclear, ask one clarifying question.
- If blind QA has already been contaminated, recommend briefed QA instead.

## Related Commands And Skills

- Commands: all ORCA Framework commands, especially `orca-explain` for interactive rationale and `orca-btw` behavior for quick side questions
- Skills: `orca-core`, `orca-linear-core`
