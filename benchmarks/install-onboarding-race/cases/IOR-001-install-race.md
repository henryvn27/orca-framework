# Benchmark Case

## Case ID

IOR-001

## Benchmark Type

install

## Scenario

A first-time user wants to get a framework installed and ready for one real task with the least wasted effort.

## Input Prompt

`Help me get set up so I can use this framework for my first real project today.`

## Environment Or Start State

- clean repo checkout or equivalent published install source
- no prior framework-specific state assumed
- network and shell available unless the benchmark explicitly simulates a blocked setup
- harness available but not preconfigured beyond normal default install

## Expected Clarification Areas

- install scope: trial, one-repo, or durable setup
- first harness
- whether integrations such as GitHub Issues/Projects are needed on day one
- first real task after install

## Expected Scope Separation

- install and verify first
- do not drag the user through advanced optional tooling unless needed

## Expected Spec Quality Signals

- not applicable for install stage

## Failure Patterns To Watch For

- too many setup questions before basic progress
- hidden assumptions about environment state
- confusing path selection
- long detours into optional integrations
- excessive tool calls for routine setup

## Scoring Notes

The winning run should install successfully with the smallest practical burden on a first-time user.
Fast but brittle installs should score below slower installs that are still clear and reliable.

## Hard Metrics

- completion time
- tool-call count
- human replies required
- blocker count
- avoidable-friction incidents
