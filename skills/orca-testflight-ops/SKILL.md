---
name: orca-testflight-ops
description: Manage Control Studios TestFlight metadata, beta review details, tester groups, invitations, and public-link operations.
---

# ORCA Framework TestFlight Ops

## What This Skill Is

A Control Studios-specific App Store Connect and TestFlight operations workflow that continues after upload instead of stopping at build state.

## Trigger

Use when a TestFlight build needs metadata, tester distribution, group setup, or public-link handling.

## Do Not Trigger

Do not use for generic release-readiness advice when no App Store Connect or TestFlight operation is actually needed.

## Required Inputs

- app identifier
- build version or build number
- target group or metadata scope

## Optional Inputs

- tester list
- public-link intent
- beta review contact details
- `RELEASE.md`

## Exact Workflow

1. Read `references/metadata-fields.md` before changing metadata.
2. Separate metadata updates from distribution updates.
3. Use `scripts/update_testflight_info.rb` for What to Test and related TestFlight information when the structured path fits.
4. Use `scripts/manage_testflight_group.rb` for group creation, tester invitations, build-to-group association, and public-link operations when needed.
5. Verify the resulting state in App Store Connect or the equivalent API surface when possible.
6. Update `RELEASE.md` with group name, tester coverage, build association, public-link state, and blockers.

## Expected Outputs

- metadata update receipt
- tester distribution receipt
- explicit blockers when App Store Connect or Fastlane behavior is inconsistent

## Quality Bar

The skill should leave behind exact tester-distribution state, not just "uploaded and probably ready."

## Common Failure Modes

- updating a build without updating What to Test
- creating a group without attaching the intended build
- enabling a public link without recording its real state and URL

## Relationship To Other ORCA Framework Skills And Commands

Pairs with `orca-testflight-release`, `orca-ship`, and `orca-github-core`.
