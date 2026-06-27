# Karpathy Guidelines

## ORCA Framework Relationship

ORCA Framework treats Karpathy Guidelines as a thin wrapped coding-agent behavior pack.

Upstream: `https://github.com/multica-ai/andrej-karpathy-skills`

## Use When

- an agent is making silent assumptions
- the diff risks speculative abstractions or broad rewrites
- nearby code is being edited without a direct reason
- success criteria are vague or unverifiable

## Route

Use the upstream `karpathy-guidelines` skill as a four-check gate:

1. Think before coding: surface assumptions, ambiguity, and tradeoffs.
2. Simplicity first: choose the minimum code that solves the request.
3. Surgical changes: touch only lines that trace to the task.
4. Goal-driven execution: define the check that proves the work is done.

## What ORCA Still Owns

- Notion or issue context
- branch/PR hygiene
- approval gates
- QA evidence and receipts
- routing when Ponytail, Matt Pocock Skills, or native ORCA already covers the need

## Install

Claude Code plugin path:

```text
/plugin marketplace add forrestchang/andrej-karpathy-skills
/plugin install andrej-karpathy-skills@karpathy-skills
```

Cursor can use the upstream `.cursor/rules/karpathy-guidelines.mdc` rule.

## Provenance Rule

Say when Karpathy Guidelines are being used. ORCA wraps the behavior gate; it does not vendor the upstream instruction file.
