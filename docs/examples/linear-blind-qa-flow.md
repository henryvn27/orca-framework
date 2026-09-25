# Linear Blind QA Flow (Historical)

> Retired 2026-09-24. Do not follow its tracker commands; active engineering work uses GitHub Issues and GitHub Projects.

## Setup

Issue: `APP-214`

Platform: web app

Launch: staging URL

Mission: "Try to prepare a client meeting brief from pasted notes."

The blind QA agent receives no spec, code, plan, design rationale, PR, or prior comments beyond the launch instructions and mission.

## Blind QA Comment

The agent posts:

- Product inference
- First impression
- Task steps attempted
- Confusing moments
- Accessibility-visible observations
- Evidence captured
- Confidence limits

Finding: the app makes generation clear but does not make export discoverable.

## Context Brief

The context briefer reads the issue, spec, and blind report. It creates a second-pass packet:

- Included: expected export behavior, target fix, staging URL
- Withheld: implementation details, component names, code diff

## Guided QA Comment

The guided QA agent verifies:

- Export button is visible after generation.
- Keyboard focus reaches export.
- Copy success state is announced visibly.

The issue thread now shows both first-look confusion and the guided retest result.
