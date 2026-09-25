---
name: orca-tool-setup
description: Identify, guide, and validate GitHub Issues/Projects and other external integrations across different harnesses.
---

# ORCA Framework Tool Setup

## What This Skill Is

A harness-aware setup workflow for external tools and service integrations.

## Trigger

Use when a task needs GitHub Issues/Projects, MCP, a host connector, a CLI helper, or another external integration.

## Inputs

- Current ORCA Framework phase or task
- Harness or host, if known
- Needed services
- Required actions, such as read issue, post comment, open PR, or inspect checks

## Workflow

1. Identify required and optional tools.
2. Detect or ask for the current harness only when it affects setup.
3. Use the authenticated GitHub connector or CLI/API path with the minimum scope required; choose another setup path only for a user-requested optional integration.
4. Explain why the tool is needed.
5. Validate reachability, authentication, scope, and write access when safe.
6. Record status in `templates/integration-status.md`.
7. Offer degraded mode when setup is optional or blocked.
8. Do not block unrelated local work.

## Quality Bar

Guidance must be host-aware, service-aware, validation-driven, and plain. Do not assume connector parity across hosts.

## Failure Cases

- If the host is unknown, provide generic guidance and ask for the host only if it changes the next step.
- If validation cannot run, provide a manual checklist.
- If scope is insufficient, state the missing permission and offer read-only or manual fallback.

## Related Docs

- `docs/external-tool-setup.md`
- `docs/integrations-overview.md`
- `docs/setup-validation.md`
- `docs/degraded-mode.md`
