# Matt Pocock Skills

## ORCA Framework Relationship

ORCA Framework treats Matt Pocock Skills as a thin wrapped engineering-practice pack.

Upstream: `https://github.com/mattpocock/skills/tree/main/skills`

## Use When

- a bug needs a tight reproduce-minimise-fix-regression loop
- a feature needs vertical-slice TDD instead of broad speculative tests
- a plan should become agent-ready issues or a short PRD
- project language, ADRs, or architecture boundaries need sharpening before build
- a session needs a compact handoff

## Route

- `diagnosing-bugs`: hard bugs, regressions, slow paths.
- `tdd`: feature or bug work where one public-interface test can lead the slice.
- `to-issues` / `to-prd`: turn approved scope into vertical work items.
- `domain-modeling` / `grill-with-docs`: sharpen project terms and ADR-worthy decisions.
- `codebase-design` / `improve-codebase-architecture`: inspect module depth and testability.
- `handoff`: compress current state for another agent.
- `writing-great-skills`: improve local skill docs without adding no-op prose.

## Do Not Route

- deprecated skills
- personal writing/vault skills
- Claude-only git hook setup unless the active host is Claude Code and the user asks for it

## What ORCA Still Owns

- Notion or issue context
- repo hygiene, branch/PR flow, approvals, QA evidence, receipts
- wrapper attribution and deciding whether the upstream skill is actually installed

## Install

```sh
npx skills@latest add mattpocock/skills
```

Select only the skills needed for the active harness. Do not vendor the upstream skill text into ORCA.

## Provenance Rule

Say when Matt Pocock Skills are being used. ORCA wraps the process; it does not claim the upstream engineering vocabulary as native ORCA work.
