# orca-improve-framework

## Purpose

Run the ORCA Framework session-end improvement loop and decide whether this session surfaced a reusable framework issue.

## When To Use

Use at the end of a meaningful session, blocked session, surprising session, or retro when framework friction showed up.

## Required Inputs

- Session summary

## Optional Inputs

- Work item or issue ID
- Review findings
- Receipt or trace
- QA report
- Existing related issue links
- Quality-signal notes when frustration, generic output, or wrong-direction behavior appeared

## GitHub Context

- Expects: the completed work record, blockers, and any evidence artifacts
- Reads: receipts, traces, review findings, QA notes, and retro output
- Posts: improvement note or issue-draft link when appropriate
- Trigger: end of meaningful session, retro, or repeated framework friction
- Human approval: required before external GitHub issue submission

## Opt-Out Context

Store the improvement artifacts locally and link them from the chosen system of record.

## Workflow

1. Run a brief session review.
2. Triage session-quality signals.
3. Capture any candidate framework improvements.
4. Separate project-specific problems from framework problems.
5. Check issue worthiness.
6. Check duplicates or overlaps.
7. If warranted, ask the user whether to skip, draft, submit, merge, or remind later.
8. Draft the issue or backlog entry.

## Outputs And Artifacts

- `templates/session-improvement-review.md`
- `templates/framework-improvement-note.md`
- `templates/session-quality-signal.md`
- `templates/session-quality-score.md`
- `templates/issue-worthiness-check.md`
- `templates/related-issue-note.md`
- `templates/issue-approval-prompt.md`
- `templates/quality-check-prompt.md`
- `templates/hvn-framework-issue.md`
- `templates/improvement-backlog-entry.md`

## Failure Cases

- If the candidate is not reusable, keep it out of the framework issue path.
- If the evidence is mostly low-confidence quality signals, log or watch for recurrence instead of pushing an issue.
- If overlap exists, prefer appending evidence instead of creating a duplicate.
- If GitHub access is unavailable, prepare a local draft instead of pretending submission happened.

## Related Commands And Skills

- Commands: `orca-retro`, `orca-review`, `orca-inspect`, `orca-status`
- Skills: `orca-session-improvement`, `orca-retro`
