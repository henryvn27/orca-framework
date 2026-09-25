# orca-benchmark

## Purpose

Compare install, onboarding, spec, or orchestration quality across benchmark cases so ORCA Framework can be evaluated over time.

## When To Use

Use when validating a workflow change, comparing framework versions, or reviewing whether install, onboarding, or spec quality improved.

## Required Inputs

- Benchmark case or case set
- Target install, onboarding, spec, or orchestration workflow

## Optional Inputs

- Prior benchmark report
- Generated artifacts from the workflow under test

## GitHub Context

- Expects: issue or project context when the benchmark is tied to real work
- Reads: spec artifacts, onboarding notes, traces, and prior benchmark results
- Posts: benchmark summary when the result matters to framework quality or release readiness
- Trigger: framework changes, onboarding regressions, spec quality concerns
- Human approval: not normally required to run benchmarks

## Opt-Out Context

Store the benchmark report in the selected durable record and link it from the relevant work item when useful.

## Workflow

1. Use `orca-benchmark`.
2. Load the benchmark case or starter pack.
3. Review or run the onboarding and spec workflow under test.
4. Score hard checks, friction signals, and rubric dimensions.
5. Write a comparison-ready benchmark report.

## Outputs And Artifacts

- `templates/benchmark-case.md`
- `templates/benchmark-report.md`
- `benchmarks/onboarding-spec/cases/`
- `benchmarks/install-onboarding-race/`

## Failure Cases

- If the case is too vague to score, tighten the case before benchmarking.
- If the report cannot compare versions meaningfully, record the limitation instead of inventing precision.

## Related Commands And Skills

- Commands: `orca-install`, `orca-onboard`, `orca-spec`, `orca-eval`, `orca-trace`
- Skills: `orca-benchmark`, `orca-eval`
