# Truth Hierarchy

ORCA Framework should be explicit about which evidence outranks which other evidence.

## Default Rule

Use the strongest available local source of truth before reaching for generic outside advice.

## When A Vault Exists

If the user provides access to a vault such as `zipvault`, treat that vault as the primary source of truth for:

- how the user actually works
- which tools they already use or already chose
- what friction repeats
- what projects, stacks, and workflows are real
- what automations, docs, or integrations would actually help

Do not substitute generic industry advice when the vault already contains relevant evidence.

## What To Do When Vault Evidence Is Strong

- recommend from repeated patterns in the vault
- support user-chosen tools that the vault shows are already in use
- quote or reference concrete vault evidence
- prefer actual workflow signals over popularity or trend signals

## What To Do When Vault Evidence Is Weak

If the vault is incomplete, stale, or too sparse to support a strong recommendation:

- say that the vault evidence is weak
- mark the next conclusion as extrapolation or low-confidence inference
- use outside or industry guidance only as a fallback
- avoid presenting fallback advice as if it came from the vault

## Required Labeling

When ORCA Framework goes beyond direct vault evidence, it should label that clearly with phrasing such as:

- `Extrapolation from partial vault evidence`
- `Low-confidence inference`
- `Fallback to generic guidance because vault evidence is weak`

## Practical Priority Order

For workflow and recommendation questions, prefer this order:

1. the user's vault or other declared live knowledge base
2. the active repo and project artifacts
3. the active GitHub issue and GitHub Project for engineering work
4. direct user statements in the current request
5. external primary sources
6. generic industry guidance

This is a priority order for relevance, not a claim that every source is equally authoritative for every topic.
