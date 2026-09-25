---
name: orca-discover
description: Inspect an existing repo, product surface, or environment and produce discovery notes.
---

# ORCA Framework Discover

## What This Skill Is

A structured inspection workflow for understanding existing systems before changing them.

## Trigger

Use before modifying an existing codebase or when architecture, tests, dependencies, or product behavior are unknown.

## Do Not Trigger

Do not use for an empty repo when the user only needs initial project creation.

## Required Inputs

- Repository path, app URL, executable, environment description, GitHub issue, or opt-out work item

## Optional Inputs

- Known feature area
- Test commands
- Deployment target

## Exact Workflow

1. Read the GitHub issue or opt-out work item for scope and links.
2. Inventory files, scripts, dependencies, and docs.
3. Identify core modules and ownership boundaries.
4. Inspect relevant implementation patterns.
5. Find verification commands and risk areas.
6. Produce discovery notes with recommendations.
7. Post or prepare the summary for the durable record.

## Expected Outputs

- Filled `templates/discovery-notes.md`

## Quality Bar

Discovery should reduce implementation risk and avoid unnecessary rewrites.

## Common Failure Modes

- Editing before reading.
- Ignoring existing patterns.
- Treating missing tests as proof the system is simple.

## Relationship To Other ORCA Framework Skills And Commands

Feeds `orca-legacy`, `orca-spec`, `orca-plan`, and `orca-review`.
