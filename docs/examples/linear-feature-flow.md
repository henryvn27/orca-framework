# Linear Feature Flow (Historical)

> Retired 2026-09-24. Do not follow its tracker commands; active engineering work uses GitHub Issues and GitHub Projects.

## Initial Issue

Title: Add saved meeting brief templates

Description: Users want reusable templates for client meeting briefs. The request does not specify template fields, editing behavior, or sharing expectations.

State: `Triage`

Labels: `feature`, `needs-spec`

## Onboard Agent Comment

The onboard agent asks:

- Who creates templates: admins, consultants, or every user?
- Are templates private or shared across a workspace?
- What fields are reusable?
- Does this need to migrate existing briefs?

## Spec Agent Comment

The spec agent posts a structured spec:

- Users can create, rename, duplicate, and delete personal templates.
- Templates contain section headings and prompt guidance.
- Sharing is excluded from this cycle.
- Acceptance criteria include empty states, validation, and copy clarity.

State recommendation: `Spec Ready`

## Planner Comment

The planner posts phases:

1. Data model and persistence.
2. Template management UI.
3. Brief generation integration.
4. Tests and browser QA.

Human approval required before build.

## Build Agent Updates

The build agent posts:

- Branch link
- Phase completion notes
- Test output
- Scope questions if implementation reveals ambiguity

## Review And QA

The review agent comments findings. The blind QA agent receives only the issue ID, app URL, and mission: "Create and use a saved meeting brief template." It posts first-look confusion about where templates live. A guided QA agent later receives a minimal brief and verifies the revised navigation.

## Ship

The release agent posts a ship checklist with test evidence, QA evidence, known risks, and recommended transition to `Done`.
