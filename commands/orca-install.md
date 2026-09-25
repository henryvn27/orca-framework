# orca-install

## Purpose

Guide a user through ORCA installation in the smallest correct path for their current situation.

## When To Use

Use when a user is trying to install ORCA, verify it, recover from a broken setup, or decide between beginner, standard, and technical install paths.

## Required Inputs

- target install goal
- current operating system

## Optional Inputs

- harness choice
- service needs
- plugin needs
- preferred path: beginner, standard, or technical

## Workflow

1. Run a short setup interview before showing commands.
2. Prefer the active harness's structured question or input tool for that interview when available.
3. Confirm prerequisites.
4. Choose the correct install path.
5. Give exact commands in order.
6. Verify each major stage.
7. Route optional plugins and harnesses only when needed.
8. Route failures to the specific troubleshooting page.

## Setup Interview

Ask enough questions to avoid giving the wrong install path or front-loading unnecessary setup.

Good starter questions:

- Are you just trying ORCA, using it in one repo, or installing it for repeated cross-project use?
- Which harness do you actually plan to use first?
- Do you need GitHub Issues/Projects on day one, or can they wait until after the local Mission workflow is proven?
- Do you want the beginner path, the shortest technical path, or a guided path with more explanation?
- Are you trying to prove ORCA works today, or set up your long-term default environment?
- How much explanation do you want during setup and first runs?
- Should ORCA default to terse/direct, brief rationale, or more guided step-by-step help?
- How technical can ORCA be with wording and assumptions?
- Do you want ORCA to ask more setup questions now or keep the first path minimal?
- Do you want those preferences remembered beyond this install?

## Outputs And Artifacts

- [docs/install.md](../docs/install.md)
- [templates/install-checklist.md](../templates/install-checklist.md)
- [templates/preflight-check.md](../templates/preflight-check.md)
- [templates/setup-intake.md](../templates/setup-intake.md)

## Related Commands And Skills

- Commands: `orca-doctor`, `orca-setup`, `orca-check-setup`
- Skills: `orca-install-help`, `orca-tool-setup`
