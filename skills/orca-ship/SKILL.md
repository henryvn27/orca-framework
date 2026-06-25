---
name: orca-ship
description: Prepare release readiness checks, release notes, rollback guidance, and handoff.
---

# ORCA Framework Ship

## What This Skill Is

A final release-readiness workflow.

## Trigger

Use when implementation, review, and QA are complete or when preparing a public release.

## Do Not Trigger

Do not use to bypass incomplete review, QA, or security gates.

## Required Inputs

- Completed work summary
- Verification evidence

## Optional Inputs

- Version number
- Deployment instructions
- Known residual risks

## Exact Workflow

1. Read the issue thread or opt-out record.
2. Confirm acceptance criteria.
3. Confirm review, QA, and security status.
4. Identify the release lane such as Apple app distribution or web deploy.
5. Run final validation where available.
6. For Apple release work, use the Control Studios defaults when the app belongs to that lane:
   - team id `T5XL63445V`
   - preferred App Store Connect user `henry@controlstudios.net`
   - XcodeGen projects should regenerate after signing or version edits
7. Keep ship states explicit instead of collapsing them into one "done" claim.
   - local build passed
   - archive created
   - export created
   - uploaded
   - processed or visible
   - distributed
8. For TestFlight metadata and tester distribution, use `scripts/update_testflight_info.rb` and `scripts/manage_testflight_group.rb` when App Store Connect or Fastlane flows need exact ops handling.
9. For Vercel deploys, default to preview and use `scripts/deploy.sh` as the fallback path when CLI auth is unavailable or the host cannot run the normal linked-project flow cleanly.
10. For repo changes, follow `docs/version-control.md`: re-read the request, review diff, stage only scoped files, commit, push the scoped branch, open or update the PR, check PR status, and merge only when repo policy and checks allow.
11. Prepare release notes, rollback guidance, and follow-ups.
12. Post or prepare ship readiness evidence in `RELEASE.md`, `templates/ship-checklist.md`, or the linked work item.
13. Mark blockers clearly if release should not proceed.

## Expected Outputs

- Filled `templates/ship-checklist.md`
- `templates/linear-ship-comment.md` when Linear-first mode is active
- explicit release-lane receipt for archive, export, upload, processing, and distribution state

## Quality Bar

Shipping output should let another maintainer release or defer with clear reasoning.
It should distinguish local success from actual uploaded or deployed state.

## Common Failure Modes

- Calling work shipped with failed validation.
- Missing rollback or recovery instructions.
- Hiding incomplete gates.
- Pushing or merging directly to a protected branch without explicit repo policy.
- Treating local archive success as equivalent to uploaded or distributed.
- Treating preview deploy success as production confirmation.

## Relationship To Other ORCA Framework Skills And Commands

Uses outputs from review, QA, security, and regression skills.
For Apple release specifics, pair with `orca-testflight-release` and `orca-testflight-ops`.
