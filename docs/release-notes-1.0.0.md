# Orca 1.0.0

Orca 1.0 turns the framework into a concrete local Mission Control product.

## Product

- Durable Missions with outcome, criteria, evidence, actors, blockers, notes, revisions, and event history.
- Complete lifecycle: create, inspect, add/reset proof, block/resume, cancel/reopen, validate, export/import, and evidence-gated completion.
- A secure loopback dashboard that operates the full lifecycle through the canonical runtime.
- Stable human and JSON interfaces for people, agents, and CI.
- Explicit portable files instead of account-backed sync.

## Distribution

- Native POSIX, PowerShell, and Windows command launchers.
- Hosted install acceptance on Linux, macOS, and Windows.
- Deterministic tar and zip archives with SHA-256 checksums and embedded file manifests.
- Commit/tree provenance JSON and GitHub build attestations.
- Homebrew formula for macOS and Linux.

## Compatibility

The existing workflow-command and skill catalog remains available as an optional execution library. Skills can help an agent satisfy a Mission; they do not own readiness or completion.

## Requirements

Ruby 2.6 or newer. The runtime and dashboard use only the Ruby standard library.
