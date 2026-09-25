# orca-ui-debug

## Purpose

Run persistent interactive UI debugging for local web, mobile web, or Electron-style surfaces when one-shot QA is not enough.

## When To Use

Use when the product needs iterative reload-and-recheck debugging, persistent browser state, or repeated UI inspection while changes are being made.

## Required Inputs

- App URL, launch command, or desktop app target

## Optional Inputs

- GitHub issue URL or number or opt-out work item
- Browser or Electron target
- Viewports
- Functional checklist
- Visual QA checklist

## Workflow

1. Define the QA inventory before making final claims.
2. Start or identify the target runtime.
3. Decide whether the workflow needs browser automation, persistent interactive handles, or manual fallback.
4. Use reload for renderer-only changes and relaunch for startup or process-boundary changes.
5. Keep functional checks separate from visual signoff.
6. Capture screenshot evidence and exact blockers.

## Outputs And Artifacts

- debugging notes
- screenshot evidence
- updates to the chosen work item or QA artifact

## Failure Cases

- If the runtime cannot be launched, record the exact blocker.
- If a persistent debugging surface is unavailable, fall back to `orca-test-briefed` or `orca-web-qa` and say what was lost.

## Related Commands And Skills

- Commands: `orca-test-briefed`, `orca-test-regression`, `orca-screenshot`
- Skills: `orca-web-qa`, `orca-context-brief`
