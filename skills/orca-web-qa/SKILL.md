---
name: orca-web-qa
description: Run browser or web automation QA with first-look, briefed, and regression modes.
---

# ORCA Framework Web QA

## What This Skill Is

A browser QA workflow for web products.

## Trigger

Use when a URL, local dev server, deployed site, or web app surface is available.

## Do Not Trigger

Do not use for native-only apps unless they expose a web surface.

## Required Inputs

- URL or launch command

## Optional Inputs

- Viewports
- Browser tools
- Context packet
- Acceptance criteria

## Exact Workflow

1. State the QA mode.
2. In GitHub-first mode, read only issue context allowed for that pass.
3. Prefer the CLI-first browser-driving path when `npx` is available:
   - use `scripts/playwright_cli.sh`
   - keep artifacts in `output/playwright/`
4. Open the app in a real browser.
5. Snapshot before using element refs and snapshot again after navigation or major DOM changes.
6. Observe visible content, accessibility-visible elements, console errors, and network failures when tools support them.
7. Attempt realistic tasks.
8. Capture screenshots, DOM evidence, or traces when available.
9. If the work needs a persistent interactive loop instead of a one-pass QA flow, route to `orca-ui-debug`.
10. Produce reproducible findings for the issue or opt-out record.

## Expected Outputs

- Blind pass: `templates/blind-qa-report.md`
- Guided pass: `templates/guided-qa-report.md`
- Regression pass: `templates/regression-report.md`

## Quality Bar

Findings should include exact steps, observed result, expected result, and evidence.
When browser automation is available, the workflow should produce real browser evidence instead of source-only speculation.

## Common Failure Modes

- Reading hidden project docs during blind QA.
- Testing only the happy path.
- Missing responsive and keyboard behavior.
- Using stale element refs instead of re-snapshotting.
- Falling back to source review when a browser can be driven directly.

## Relationship To Other ORCA Framework Skills And Commands

Pairs with `orca-blind-qa`, `orca-context-brief`, and `orca-design`.
Use `references/cli.md` and `references/workflows.md` for the concrete Playwright CLI command surface.
