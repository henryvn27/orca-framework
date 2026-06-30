---
name: orca-goal-prompt
description: Create a host-native `/goal` prompt for bounded ORCA plan work, especially when the user wants an agent to keep working through ready ORCA plans, delegate blocker fixes to subagents, record true blockers, and move on without stalling.
---

# ORCA Goal Prompt

## Purpose

Generate a copy-ready native `/goal` prompt that turns a predefined chunk of ORCA work into a bounded execution loop.

Use this after ORCA has ready plans, issues, or milestones. If the chunk is not explicit, ask the user whether to use the default chunk: all ready ORCA plans.

## Required Inputs

- ORCA project or repo path
- Work chunk, or user confirmation to use all ready ORCA plans
- Source of truth for plans and blockers
- Verification expectation

## Workflow

1. Inspect the project source of truth before writing the prompt.
2. If the user did not name the work chunk, ask one question: "Use all ready ORCA plans, or a narrower chunk?"
3. Define done as every item in the chosen chunk being completed, recorded as externally blocked, or intentionally skipped with a reason.
4. Require each main-agent cycle to pick the next ready unblocked item, implement the smallest useful slice, verify it, and update the source of truth.
5. When a blocker appears, require fresh blocker proof before delegation.
6. If a blocker may be fixable, spawn or request a subagent with its own `/goal` prompt focused only on that blocker.
7. Require the main agent to continue other independent work while the subagent runs.
8. When a blocker is truly external or repeated, record it with exact evidence and move on.
9. Stop only when the chunk is exhausted, verification proves completion, approval is required, or no independent work remains.

## Prompt Shape

Return one copy-ready prompt, not an essay:

```text
/goal Work through [CHUNK] for [PROJECT] until every item is completed, recorded as truly blocked, or intentionally skipped with a reason.

Start by inspecting [PLAN SOURCES], current repo state, existing worktree/branch policy, and [TRACKER]. Preserve unrelated dirty work.

Loop:
1. Pick the next ready unblocked item from [CHUNK].
2. Implement the smallest production-ready slice that advances it.
3. Run the cheapest meaningful verification for that slice.
4. Update [TRACKER] with status, files changed, verification, blockers, and next step.
5. If blocked, collect exact blocker proof. If a subagent could reasonably unblock it, launch this subagent goal and keep working on another independent item:

   /goal Fix blocker: [BLOCKER]. Work only on [OWNED SCOPE]. Use [ARTIFACTS]. Return status, files changed, verification, exact blocker proof if still blocked, and recommended next step. Do not touch unrelated work.

6. When a subagent returns, ingest only verified results, reconcile conflicts, update [TRACKER], and continue.
7. If blocker is external, repeated, or needs user credentials/approval, record it in [BLOCKER REPORT TARGET] with exact command/output/artifact path and move on.

Stop when [CHUNK] has no remaining actionable work, verification proves done, user approval is required, or all remaining work is truly blocked with fresh evidence.
Final answer: completed items, blocked items with proof, skipped items with reason, verification run, branch/PR state, and next human action.
```

## Defaults

- Chunk: all ready ORCA plans.
- Tracker: Notion issue board when configured; otherwise ORCA local status artifacts.
- Plan sources: `.orca/work-items/**`, `docs/**` plan/status files, checked-in ORCA plans, and current issue board.
- Branching: follow repo policy; avoid protected-branch implementation.
- Delegation: only for blockers with a clean ownership boundary.
- Blocker record: use `templates/blocker-report.md` shape.

## Quality Bar

The generated prompt must make continuation, delegation, blocker recording, verification, and stop conditions explicit. It must not imply infinite work.

## Common Failure Modes

- accepting "all work" without confirming the chunk
- spawning a subagent for tiny local fixes
- waiting idle on a blocker while independent work exists
- recording "blocked" without fresh proof
- letting subagents edit overlapping files without an ownership boundary
- finishing without tracker updates and verification evidence

## Related Skills

Use with `orca-goal-mode`, `orca-background-mode`, `orca-agent-orchestration`, `orca-delegation`, and `orca-receipts`.
