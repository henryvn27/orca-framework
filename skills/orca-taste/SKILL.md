---
name: orca-taste
description: Wrap Taste Skill as an ORCA workflow surface for anti-slop frontend and anti-AI UI work.
---

# ORCA Framework Taste Skill Wrapper

## What This Skill Is

A wrapper skill that lets ORCA route frontend design work into Taste Skill while keeping ORCA responsible for repo-visible workflow structure, QA, and attribution.

## Trigger

Use when the user asks for Taste Skill, design-taste-frontend, anti-slop frontend output, anti-AI UI, or a user-facing web design pass where generic AI-looking UI is the main risk.

## Do Not Trigger

Do not use for backend work, generic implementation tasks, dense internal dashboards, or small CSS fixes that do not need a design workflow.

## Required Inputs

- target UI area or page

## Optional Inputs

- current frontend stack
- brand constraints
- reference sites or screenshots
- desired Taste Skill variant

## Exact Workflow

1. Confirm the task is frontend, marketing UI, portfolio, or redesign work.
2. Open `integrations/taste-skill.md`.
3. Pick the narrowest Taste Skill variant.
4. Keep ORCA artifacts in sync if the design pass changes scope, plan, QA expectations, or review criteria.
5. Require screenshot or browser evidence before signoff.
6. State clearly that ORCA is wrapping Taste Skill and not claiming the upstream design language as native ORCA work.

## Expected Outputs

- wrapper recommendation or setup path
- ORCA next step when the design pass affects broader delivery work

## Quality Bar

The wrapper should make Taste Skill easier to use from ORCA, not vendor the whole upstream repo or create a second ambiguous design framework.
