# Changelog

## 1.0.0 - 2026-07-18

Orca becomes a complete local Mission Control product rather than a workflow catalog.

### Product

- Added durable Missions with outcomes, acceptance criteria, evidence, actors, blockers, notes, revisions, derived readiness, next action, and append-only event history.
- Added the complete lifecycle: create, status, show, list, events, add, reset, check, satisfy, note, block, resume, cancel, reopen, complete, validate, export, and import.
- Added strict invariant validation, exclusive mutation locking, and atomic mode-`0600` persistence.
- Added idempotent portable Mission envelopes with schema, collision, and active-work protection.
- Reframed commands and skills as optional execution strategies that cannot override Mission readiness or completion.

### Mission Control

- Added a dependency-free, responsive local dashboard for the full Mission lifecycle and durable history.
- Added a loopback-only HTTP server with random session-token writes, exact-origin enforcement, bounded JSON requests, a fixed action allowlist, CSP, no-store, and anti-framing headers.
- Added accessible forms, keyboard-safe dialogs, visible focus, reduced-motion behavior, and complete interaction feedback.

### Platforms And Installation

- Added `VERSION` as the single `1.0.0` source for launchers, installers, validation, and packaging.
- Added native PowerShell and Windows command launchers alongside the POSIX launcher.
- Updated local and global installers to ship the runtime, dashboard, native launchers, docs, and optional extension library.
- Added hosted installed-copy acceptance on Linux, macOS, and Windows, including native Windows dashboard startup.

### Release Supply Chain

- Added deterministic tar and zip packaging with sorted paths, fixed timestamps, normalized modes/ownership, and embedded file SHA-256 manifest.
- Added checksum and commit/tree provenance files plus GitHub build attestations.
- Added extracted-archive install/lifecycle acceptance for both package formats.
- Added a Homebrew formula and `v1.0.0` release workflow.

### Documentation

- Rewrote product, architecture, command, install, lifecycle, portability, security, compatibility, and release documentation around Mission Control.
- Replaced the speculative roadmap with the Orca 1.0 product completion record and explicit non-goals.
- Preserved the existing workflow-command, skill, template, schema, and integration corpus as an optional execution library.

### Verification

- Added comprehensive Mission lifecycle and portability smoke coverage.
- Added full dashboard API/security lifecycle smoke coverage.
- Added real browser desktop/mobile interaction and visual proof.
- Kept repository, reliability, Markdown, link, docs, install, and hosted checks as release gates.

## 0.1.0 - 2026-05-30

Initial public framework release candidate.

- Added the framework operating manual, workflow commands, reusable skills, templates, schemas, installation scripts, validation, and optional integrations.
- Added Linear-oriented coordination guidance with explicit opt-out paths.
