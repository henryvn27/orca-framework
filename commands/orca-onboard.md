# orca-onboard

## Purpose

Run adaptive onboarding to understand a product, feature, or project before writing a spec.

## When To Use

Use at the start of a new project, significant feature, unclear Notion issue, or markdown fallback task.

## Required Inputs

- Initial user request, Notion issue description, `.orca/` task, or explicit Linear issue

## Optional Inputs

- Target users
- Business constraints
- Existing repo path
- Deadline or release target

## Backend Context

- Notion mode: read/write the project page and Issue Board as canonical state.
- Markdown mode: use `.orca/` files as canonical fallback.
- Linear mode: use Linear only when explicitly selected.

## Workflow

1. Use `orca-onboard`.
2. Start with a stronger first-pass interview that covers both:
   - work context: user, job, success, constraints, platform, data, risks, and non-goals
   - operator preferences: explanation depth, jargon tolerance, directness, guidance level, involvement level, and whether ORCA should ask more questions up front or make stronger assumptions
3. Prefer the active harness's structured question or input tool when it exists and fits the moment.
4. Ask follow-up questions one at a time or in small groups only where the answers would materially change the first spec.
5. Stop when more questions would not materially improve the first spec.
6. Produce intake summary, operator preference summary, unresolved questions, recommended workflow, and draft spec skeleton.
7. Sync the result to Notion, `.orca/`, or explicit Linear record.

## First-Pass Interview

For new projects, first runs, or vague requests, the default first pass should usually answer:

- Who is this for?
- What are they trying to get done?
- What does success look like?
- What platform or repo is in scope?
- What constraints or deadlines matter?
- What data, integrations, or external systems are involved?
- What can go wrong?
- What is explicitly out of scope?
- How much explanation does the user want by default?
- How involved does the user want to be during execution?
- Should ORCA stop for reviewable checkpoints, summarize only major checkpoints, or keep going inside a bounded contract until it finishes or hits a blocker?
- Does the user want ORCA to recommend `/goal` or background execution for long unattended work when the task is safe and well-bounded?
- Should ORCA mostly just act, explain briefly, or show options when there is a fork?
- How technical can the wording be?
- Should ORCA ask more setup questions now or keep onboarding minimal and infer the rest?
- Are any preferences one-run only versus something the user wants ORCA to remember?

## Outputs And Artifacts

- `templates/intake.md`
- optional `templates/user-guidance-profile.md` when a durable preference is explicit
- Draft `templates/spec.md` skeleton
- Notion issue update when Notion mode is active
- Markdown intake update when `.orca/` fallback is active
- Linear intake comment when Linear mode is explicitly active
- host-native captured answers when the harness provides a structured question surface

## Failure Cases

- If the user cannot answer, record assumptions and unresolved questions.
- If the project is already specified, skip to `orca-spec`.
- If the first pass did not cover user, success, and scope, keep onboarding active instead of pretending the work is spec-ready.
- If preference capture is partial, default to concise, direct, low-intrusion behavior and keep preferences easy to revise later.

## Related Commands And Skills

- Commands: `orca-linear-intake`, `orca-spec`, `orca-discover`
- Skills: `orca-onboard`, `orca-linear-triage`, `orca-core`
