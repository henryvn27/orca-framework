# orca-design

## Purpose

Review product experience, visual hierarchy, accessibility, copy, responsive behavior, interaction quality, and whether the result feels generic or obviously AI-generated.

## When To Use

Use for frontend, product, marketing, mobile, or user-facing CLI work.

## Required Inputs

- Product surface or changed UI

## Optional Inputs

- Linear issue ID or opt-out work item
- Brand constraints
- Screenshots
- Design system
- Target user

## Linear Context

- Expects: issue ID, target user, product surface, screenshots or launch link, acceptance criteria
- Reads: intended user job, design constraints, QA findings, linked screenshots
- Posts: prioritized design findings, accessibility notes, recommended next state
- Trigger: `design-review`, `In Review`, user-facing UI changes
- Human approval: required to waive major accessibility or product clarity blockers

## Opt-Out Context

Store design findings in the chosen record.

## Workflow

1. Use `orca-design`.
2. Inspect the experience from user goals outward.
3. Check clarity, hierarchy, loading states, empty states, accessibility, responsiveness, and interaction feel.
4. Check whether layout, typography, motion, and copy feel product-specific instead of generic prompt output.
5. Check whether surrounding artifacts such as release notes, empty states, onboarding text, and review summaries also sound product-specific instead of framework boilerplate.
6. If the work is design-heavy and Impeccable is available or desired, route through `orca-impeccable` instead of pretending ORCA should replace the upstream pack.
7. If the work is a landing page, portfolio, redesign, or anti-AI UI pass, route through `orca-taste` and keep Taste Skill provenance explicit.
8. Produce prioritized design findings.
9. Sync findings to the work item.

## Side-Session Fit

`orca-design` is a strong side-session candidate because UX critique, copy discussion, and visual interpretation often work better in a separate thread than in the main build thread.

## Outputs And Artifacts

- Design review notes
- Updates to `templates/review-report.md` when paired with code review
- Reference standards in `docs/visual-quality.md` and `docs/human-voice.md` when relevant

## Failure Cases

- If visual context is unavailable, do not invent visual observations.
- If product goals are unclear, ask for target user and task.

## Related Commands And Skills

- Commands: `orca-impeccable`, `orca-taste`, `orca-test-blind`, `orca-review`
- Skills: `orca-design`, `orca-impeccable`, `orca-taste`, `orca-linear-core`
