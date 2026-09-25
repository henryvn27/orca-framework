# Blind QA

Blind QA is a zero-context first-look test. In GitHub-first mode, it is coordinated through the GitHub issue. A Mission-only run is supported only when the user explicitly chooses local tracking.

## GitHub First-Look Model

A blind QA agent receives only:

- GitHub issue URL or number
- Platform
- Launch instructions
- Optional one-sentence user mission

It does not receive:

- Spec
- Code
- Implementation plan
- Design rationale
- PR discussion
- Hidden issue history beyond the allowed launch context

The agent runs first-look QA through browser automation, iOS simulator MCP, CLI, or manual inspection and posts findings back to the same issue.

## Rules

- Do not read the spec during a blind pass.
- Do not read implementation notes.
- Do not inspect source code.
- Do not use issue history or intended flows unless explicitly included as the one-sentence mission.
- Do not pretend to see visual information when only text is available.
- Record confusion as a product signal, not as tester failure.

## Second-Pass Flow

After the blind report is posted:

1. A context briefer reads the issue, spec, and first-pass report.
2. The briefer creates a minimal packet for the second-pass tester.
3. The second-pass tester receives only disclosed context.
4. The issue records differences between blind and briefed outcomes.

The brief should satisfy the QA brief contract in `templates/contracts/qa-brief-contract.md`.

## Output

Use `templates/blind-qa-report.md` for full artifacts or `templates/github-issue-update.md` for the issue comment. The report should include:

- Product inference
- First impression
- Attempted tasks
- Observed blockers
- Accessibility notes
- Evidence captured
- Confidence limits

After a blind report is written, it should remain unchanged. Briefed and regression passes get separate reports.

Use traces when needed to show what the QA run actually did, but do not turn the blind report itself into a hidden-context artifact.

When a blind finding is strong enough to preserve, use `orca-regression-task` to turn it into a structured regression candidate or regression task instead of leaving it as a one-off note.

After QA completes, `orca-next` should recommend fixing blockers, running a briefed pass, or creating regression follow-up depending on severity and confidence. It should stay silent if retesting is already underway.
