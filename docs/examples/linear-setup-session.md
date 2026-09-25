# Linear Setup Session (Historical)

> Retired 2026-09-24. Do not follow its tracker commands; active engineering work uses GitHub Issues and GitHub Projects.

## Context

A team wants ORCA Framework to coordinate work for a new web app repository. They use Linear but have not configured agent-specific workflow guidance.

## Setup Decisions

- Scope: project-level rollout first.
- Project: `Meeting Brief Builder`
- Team: engineering
- Agent state permissions: agents may recommend transitions but humans move issues across gates.
- Agent label permissions: agents may recommend labels but not apply them automatically.
- Opt-out rule: GitHub Issues may be used for open-source contributor work, but the issue must link back to Linear when internal delivery is involved.

## State Mapping

- `Triage` maps to intake.
- `Ready for Spec` maps to spec generation.
- `Spec Ready` maps to human approval and planning.
- `Ready for Build` maps to approved implementation.
- `In Review` maps to code or artifact review.
- `In QA` maps to blind and guided QA.
- `Ready to Ship` maps to ship checklist.
- `Done` requires posted evidence.

## Smoke-Test Issue Comment

```text
## ORCA Framework Linear Setup Check

Context read: issue title, description, labels, current state, and project.

Setup status:
- State gate mapping exists.
- Recommended labels are present or documented.
- Agent guidance is installed at project level.
- Agents may recommend state transitions but should not apply them automatically.
- Opt-out path is documented for GitHub Issues.

Result: ready for a low-risk ORCA Framework issue.

Recommended next state: Ready for Spec
```

## Follow-Up

The team creates one real feature issue and runs `orca-linear-intake` before allowing build agents to pick up work.
