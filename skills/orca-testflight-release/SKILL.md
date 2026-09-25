---
name: orca-testflight-release
description: Build, sign, archive, export, and upload Control Studios Apple apps to App Store Connect or TestFlight with explicit release-state evidence.
---

# ORCA Framework TestFlight Release

## What This Skill Is

A Control Studios-specific Apple release workflow for iOS, iPadOS, macOS, and related Xcode app lanes.

## Trigger

Use when the job is to move a Control Studios app from repo state to archive, export, upload, or verified TestFlight visibility.

## Do Not Trigger

Do not use as a generic ORCA release lane for non-Apple or non-Control Studios products.

## Required Inputs

- repo path
- scheme or target
- bundle id
- current version and build

## Optional Inputs

- workspace or project path
- `RELEASE.md`
- `fastlane/` or `project.yml` context
- device-install request

## Exact Workflow

1. Inspect the repo for project type, scheme, signing style, bundle id, and existing release docs.
2. Use Control Studios defaults:
   - team id `T5XL63445V`
   - preferred App Store Connect user `henry@controlstudios.net`
3. If this is an XcodeGen project, regenerate after signing or version edits.
4. Build before release.
5. Keep release states explicit:
   - local build passed
   - archive created
   - export created
   - uploaded
   - processed or visible
   - distributed
6. Use `references/testflight-release-runbook.md` for the concrete archive, export, and upload path.
7. Update `RELEASE.md` with exact evidence and exact blockers.

## Expected Outputs

- archive, export, and upload evidence
- updated `RELEASE.md`
- next-step recommendation if processing or distribution is still pending

## Quality Bar

A maintainer should be able to tell exactly how far the release got without conflating local success and App Store Connect state.

## Common Failure Modes

- calling the release done after a local archive only
- forcing a global code-sign identity that breaks dependency signing
- changing signing state without regenerating an XcodeGen project

## Relationship To Other ORCA Framework Skills And Commands

Pairs with `orca-ship`, `orca-testflight-ops`, and `orca-github-core`.
