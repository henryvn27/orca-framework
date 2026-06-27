# orca-karpathy-guidelines

## Purpose

Route ORCA work through Karpathy Guidelines when an agent needs a compact behavior gate against wrong assumptions, overbuilt code, broad diffs, or unverifiable goals.

## When To Use

Use when the user asks for Andrej Karpathy Skills, Karpathy Guidelines, or wants ORCA to tighten coding-agent behavior before implementation or review.

## Workflow

1. Open `integrations/karpathy-guidelines.md`.
2. Apply the four-check gate to the current task.
3. Keep ORCA responsible for tracker context, branch/PR hygiene, QA evidence, and receipts.
4. Prefer Ponytail or Matt Pocock Skills when they are the narrower fit for shortest-diff or test-loop discipline.

## Output

- assumptions or ambiguity found
- simplest acceptable path
- files intentionally in scope
- verification command or artifact

## Related Commands And Skills

- Commands: `orca-build`, `orca-review`, `orca-matt-pocock-skills`, `orca-taste`
- Skills: `orca-karpathy-guidelines`, `orca-attribution`
