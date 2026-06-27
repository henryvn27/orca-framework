---
name: orca-karpathy-guidelines
description: Wrap Karpathy Guidelines as an ORCA behavior gate for assumptions, simplicity, surgical diffs, and verifiable goals.
---

# ORCA Framework Karpathy Guidelines Wrapper

## What This Skill Is

A wrapper skill that routes ORCA work into the upstream Karpathy Guidelines behavior gate while ORCA keeps workflow governance, attribution, approvals, QA evidence, and receipts.

## Trigger

Use when the user asks for Andrej Karpathy Skills or Karpathy Guidelines, or when an agent needs a compact check against silent assumptions, overbuilt code, drive-by edits, or vague success criteria.

## Do Not Trigger

Do not use when Ponytail already fully covers the requested shortest-diff discipline, or when Matt Pocock Skills are the better route for a bug/TDD/domain-modeling loop.

## Required Inputs

- target task or diff

## Exact Workflow

1. Open `integrations/karpathy-guidelines.md`.
2. Apply the four checks: assumptions, simplicity, surgical scope, verifiable goal.
3. Name only real ambiguity or tradeoffs; do not add ceremony to trivial tasks.
4. Keep ORCA artifacts in sync when the gate changes scope, QA, review, or handoff state.
5. State clearly that ORCA is wrapping Karpathy Guidelines, not vendoring the upstream instruction file.

## Expected Outputs

- scoped behavior gate result
- ORCA next step
- verification command or artifact path
