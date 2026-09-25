# Web QA

ORCA Framework web QA uses browser automation or manual browser inspection to evaluate a web product from the user's point of view. In GitHub-first mode, QA results are posted to the issue. Use a Mission-only record only when the user explicitly requests local tracking.

When browser automation is available, prefer a real browser-driving path over speculative reading of source code alone.
The default CLI-first browser-driving path is `skills/orca-web-qa/scripts/playwright_cli.sh`, which wraps Playwright CLI and keeps snapshots, screenshots, and traces in `output/playwright/`.
When persistent iterative debugging is needed, route to `orca-ui-debug` instead of forcing all UI work into a one-pass QA flow.

## First-Look Pass

A blind browser tester should receive only the issue ID, URL or launch command, platform constraints, and optional one-sentence mission. The tester should:

- Open the provided URL.
- Describe what the product appears to be.
- Identify the primary action without reading hidden docs.
- Attempt realistic tasks.
- Inspect visible errors, loading states, responsiveness, keyboard navigation, and accessibility-visible labels.
- For async views, note whether the screen goes blank, shows only a spinner, or preserves structure with skeleton frames before data resolves.
- Record screenshots or DOM observations if tools allow.
- Save findings to `templates/blind-qa-report.md`, then post a concise summary with `templates/github-issue-update.md`.

## Later Passes

Briefed and regression passes may use context packets, acceptance criteria, and issue links. They should still report exact steps and observed evidence.

## Browser Automation Rules

- snapshot before using element refs
- re-snapshot after navigation or major DOM changes
- prefer traces for flaky or stateful flows
- route to `orca-ui-debug` when the task needs a persistent session instead of a one-pass QA pass

## GitHub Issue Update

A web QA comment should include:

- URL or build tested
- Browser and viewport
- Context received
- Steps attempted
- Console or network observations when available
- Screenshots or statement that screenshots were unavailable
- Recommended next state
