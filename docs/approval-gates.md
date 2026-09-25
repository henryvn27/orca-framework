# Approval Gates

ORCA Framework approval gates are lightweight policy checks that slow down risky actions before they become expensive mistakes.

## Purpose

Use approval gates to distinguish:

- work that can proceed automatically
- work that needs explicit approval
- work that should stop until risk is reduced

Approval gates are about control, not bureaucracy. The goal is to make risky moves visible before they happen.

## Actions That Need Approval

Approval is normally required for:

- destructive file or data operations
- large refactors with broad blast radius
- installer changes
- dependency upgrades with behavior or supply-chain risk
- production config or release-process changes
- unreviewed tools or MCP servers
- high-risk tool calls outside allowed registry contexts
- goal mode for risky, destructive, unclear, or approval-dependent work
- widening a runtime default after only fresh research or limited replay evidence
- controller to executor delegation when the delegated action would cross an existing approval boundary
- scope expansion beyond the approved spec
- issue-closing or ship-readiness decisions when confidence is low

## Actions That Usually Do Not Need Approval

These can usually proceed automatically unless repo rules say otherwise:

- bounded discovery and research
- drafting specs, plans, traces, and eval reports
- local validation and non-destructive checks
- documentation improvements inside approved scope
- small implementation tasks already covered by an approved spec and plan

## Approval Request Shape

Use [templates/approval-request.md](../templates/approval-request.md) when asking for approval. Required fields are summarized in [docs/artifact-contracts.md](artifact-contracts.md).

An approval request should state:

- what action is proposed
- why it is risky
- what will change
- what alternatives were considered
- what happens if approval is delayed or denied

## Recording Decisions

Record approvals on the GitHub issue or a linked reviewable artifact. For an explicitly local-only Mission, record the approval in its durable file or receipt.

Do not rely on ephemeral chat as the only approval record for non-trivial work.

## Denied Or Delayed Approval

If approval is denied:

- stop the risky action
- record the denial and reason
- propose a safer next step when possible

If approval is delayed:

- continue only with safe adjacent work
- mark the blocker clearly
- do not silently expand scope

## Confidence Rule

Low confidence is itself a reason to gate. When the cost of being wrong is high, request approval instead of improvising.

This applies to harness compatibility as well. If runtime adaptation cannot confidently establish support for a risky feature, prefer approval or manual confirmation.
