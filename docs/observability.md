# Observability

ORCA Framework observability is a practical, file-based tracing layer for understanding what an agent run actually did. It is meant to support debugging, review, QA, and trajectory evaluation without pretending ORCA Framework needs a full telemetry platform.

## Purpose

Use traces to answer questions such as:

- What issue, project, or work item was this run acting on?
- Which agent role performed the work?
- What steps were taken and in what order?
- Which tools, commands, and artifacts were involved?
- Where did the run fail, retry, or stop?
- What evidence exists for later review or evaluation?
- What receipt summarizes the run?
- Which replay or restore artifacts exist for debugging?

## Trace Model

Each meaningful run should capture:

- Run identity: run ID, session ID if available, start time, end time, elapsed time
- Work identity: GitHub issue and Project (default), or explicit Mission-only record
- Agent identity: command, skill, role, harness
- Context read: artifacts, issue comments, docs, external sources
- Actions taken: major steps, tools used, commands executed, files read or written
- Decisions made: important branches, approvals requested, scope changes, assumptions
- Receipt link: compact summary of the run outcome
- Lineage link: upstream and downstream artifact relationships when tracked
- Goal state: objective, contract link, lifecycle transition, verifier result, and steering note when goal mode is active
- Reliability signals: retries, failures, blockers, warnings, stop reason
- Optional metadata: token, cost, cached-token, or cache-read data when the harness exposes it

When workflow accounting is enabled, traces should link to the per-run metrics artifact described in [docs/workflow-accounting.md](workflow-accounting.md).
When Orca Monitor status export is enabled, traces and receipts should be summarized into the local snapshot described in [docs/orca-monitor-status.md](orca-monitor-status.md).

Use [templates/run-trace.md](../templates/run-trace.md) as the default artifact shape and [templates/contracts/trace-contract.md](../templates/contracts/trace-contract.md) for the required fields.
For portable machine-readable structure, use `schema/versions/v1/run-trace.schema.json`.

## What To Trace

Trace decisions and workflow boundaries, not every keystroke.

Good trace entries include:

- starting a spec or plan pass
- reading a work item, spec, or QA brief
- invoking a risky command or external tool
- calling a governed tool or MCP server
- deciding to stop, retry, escalate, or request approval
- writing or updating a durable artifact
- changing course because evidence contradicted an assumption

## What Not To Trace

Do not trace:

- secrets, tokens, credentials, or raw environment values
- full copies of external pages when a short citation is enough
- repetitive low-value shell noise
- private user data that is not needed for debugging or evaluation
- sensitive security details that should stay in a restricted report
- raw secrets or credential values passed through tool parameters
- large logs or transcript dumps when a targeted excerpt or linked artifact is enough
- Orca Monitor status snapshots that claim billing, quota, account, or hosted usage truth

## Traces Versus Run Memory

Run memory and traces are related but different:

- Run memory records durable project facts, decisions, and context worth carrying forward.
- Traces record what happened during a specific run.

Run memory answers "what should future runs remember?".
Traces answer "what did this run actually do?".

See [docs/run-memory.md](run-memory.md) for the durable-memory side of the model.
See [docs/shared-state.md](shared-state.md) for the active coordination side of the model.

## How Traces Help

- Debugging: find where a run made the wrong assumption or skipped a gate.
- Review: show what evidence supported a change or recommendation.
- Evals: score the trajectory, not just the final answer.
- Handoffs: let the next agent understand what already happened.
- Inspection: give humans enough evidence to approve or resume without rereading the entire history.
- Replay and restore: let maintainers compare newer behavior or recover from known-good workflow states.
- Token efficiency: show where retries, context drift, or oversized artifacts are wasting spend.

## Storage Model

Start simple:

- keep traces as Markdown artifacts linked from the work item
- allow schema-backed companions when validation or transformation matters
- keep the Orca Monitor status export as a tiny derived local JSON file, not as the trace itself
- use one trace per meaningful run or phase
- prefer inspectable files over opaque binary logs
- keep summaries in the work item comment and detailed traces in linked artifacts when needed

## Lightweight Rules

- Trace only meaningful work.
- Keep entries concise and evidence-oriented.
- Record stop reason clearly.
- Link the trace from the GitHub issue when the run matters to project state; use a Mission-only record only when explicitly requested.
