---
name: orca-research
description: Gather evidence from authoritative sources and convert it into a decision-ready research brief.
---

# ORCA Framework Research

## What This Skill Is

A focused research workflow for facts that affect implementation or product decisions.

## Trigger

Use when information may be current, external, domain-specific, high-risk, or uncertain.

## Do Not Trigger

Do not use for facts already present in the repo, vault, or conversation unless accuracy is high-stakes.

## Required Inputs

- Research question
- Decision the research supports

## Optional Inputs

- GitHub issue URL or number or opt-out work item
- Source preferences
- Recency requirement
- Jurisdiction or platform version

## Exact Workflow

1. Define the decision and evidence needed.
2. Read the issue or opt-out record for constraints and decision context.
3. List the unknowns blocking the next decision and rank them by leverage.
4. If a vault or declared live knowledge base exists, treat it as the primary source of workflow truth.
5. Prefer primary sources and official documentation for external facts that the vault does not answer.
6. Record citations, dates, confidence, and whether a conclusion is direct evidence or extrapolation.
7. End with a recommendation, narrowed choice, or explicit unresolved blocker.
8. Explain how findings affect the spec or plan.
9. Post or prepare the conclusion for the durable record.

## Expected Outputs

- Filled `templates/research-brief.md`

## Quality Bar

Findings should be actionable and distinguish fact from inference. If vault evidence is weak, the fallback to generic guidance should be stated plainly.
Another engineer should be able to see what decision was unblocked, not just what sources were read.

## Common Failure Modes

- Summarizing sources without a decision.
- Researching everything instead of the next highest-leverage unknown.
- Using stale or secondary evidence for current technical claims.
- Omitting uncertainty.
- Overriding strong vault evidence with generic industry advice.

## Relationship To Other ORCA Framework Skills And Commands

Feeds `orca-spec`, `orca-plan`, and `orca-security`.
