---
name: orca-vercel-deploy
description: Deploy web projects to Vercel with preview-first behavior and a claimable fallback path when normal CLI auth is unavailable.
---

# ORCA Framework Vercel Deploy

## What This Skill Is

A direct Vercel deployment workflow for preview-by-default web shipping.

## Trigger

Use when the user wants a deploy link, a preview deployment, or a fast web ship check outside a full release review.

## Do Not Trigger

Do not use for production deploys unless production was explicitly requested.

## Required Inputs

- repo path or deploy target

## Optional Inputs

- linked Vercel project
- production intent

## Exact Workflow

1. Check whether `vercel` is available.
2. Default to preview deploys.
3. If linked-project CLI auth works, use the normal Vercel preview path.
4. If CLI auth is unavailable, use `../orca-ship/scripts/deploy.sh` as the fallback deploy surface.
5. Return the preview URL directly.
6. If the fallback path is used, also return the claim URL.

## Expected Outputs

- preview URL
- claim URL when fallback deploy is used
- exact blocker when neither path can complete

## Quality Bar

The user should get a real preview link or a precise deploy blocker, not just instructions about what might work.

## Common Failure Modes

- treating preview as production
- dropping the claim URL on fallback deploys
- claiming success without the actual deployment URL

## Relationship To Other ORCA Framework Skills And Commands

Pairs with `orca-ship`, `orca-web-qa`, and `orca-github-core`.
