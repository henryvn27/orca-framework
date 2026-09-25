# orca-web-qa

## Purpose

Drive a real browser for QA, artifact capture, and browser-visible bug confirmation.

## When To Use

Use when a URL, local dev server, deployed site, or browser-based product should be tested from the terminal in a real browser.

## Required Inputs

- URL or launch command

## Optional Inputs

- GitHub issue URL or number or opt-out work item
- viewport targets
- acceptance criteria
- artifact goals such as screenshot, snapshot, or trace

## Workflow

1. Prefer the Playwright CLI wrapper in `skills/orca-web-qa/scripts/playwright_cli.sh`.
2. Open the target in a real browser.
3. Snapshot before using element refs.
4. Re-snapshot after navigation or major DOM changes.
5. Attempt realistic tasks.
6. Capture screenshots, traces, or DOM evidence when needed.
7. Route to `orca-ui-debug` if the work needs a persistent interactive debugging loop instead of one-pass QA.

## Outputs And Artifacts

- blind, briefed, or regression QA report
- browser artifacts under `output/playwright/` when browser automation runs

## Failure Cases

- If `npx` or browser automation is unavailable, record the exact blocker and fall back to manual browser QA only when necessary.
- If refs go stale, re-snapshot instead of guessing.

## Related Commands And Skills

- Commands: `orca-test-blind`, `orca-test-briefed`, `orca-test-regression`, `orca-ui-debug`, `orca-screenshot`
- Skills: `orca-web-qa`
