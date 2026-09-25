---
name: orca-onboard
description: Run an adaptive subagent-style interview and produce an intake summary, unresolved questions, recommended workflow, and draft spec skeleton.
---

# ORCA Framework Onboard

## What This Skill Is

An adaptive onboarding workflow for turning unclear intent into usable product context.

## Trigger

Use for new products, major features, ambiguous requests, or work with missing user and success context.

## Do Not Trigger

Do not use when a complete approved spec already exists.

## Required Inputs

- Initial request or GitHub issue description and Project fields (default); Mission-only record only when explicitly requested

## Optional Inputs

- Existing notes
- Known user segments
- Constraints

## Exact Workflow

1. State that onboarding is gathering enough information for a first useful spec.
2. For repository work, read the GitHub issue title, body, labels, Status, comments, links, Project, and dependencies.
3. Use a local Mission-only record only when the user explicitly asks to work without GitHub tracking.
4. Ask high-leverage questions about user, job, success, constraints, risks, platform, data, and non-goals.
5. Also ask high-leverage operator questions:
   - how much explanation is wanted
   - how involved the user wants to be during planning and execution
   - how technical the wording can be
   - whether ORCA should mostly act, briefly explain, or show options at forks
   - whether ORCA should stop at each checkpoint, only at major checkpoints, or keep making bounded progress until blocked or complete
   - whether goal mode or background mode should be proactively considered for long unattended work
   - whether the user wants more questions up front or fewer questions plus stronger assumptions
   - whether any preference should be durable
6. Prefer a host-native structured question or selection tool when the active harness exposes one; use plain text only when no better question surface exists.
7. For first-run or especially vague work, start with a stronger first-pass interview covering both work context and operator preferences before narrowing.
8. Adapt based on answers; do not run a fixed questionnaire when fewer questions are enough.
9. Stop when the next answer is unlikely to materially change the first spec or the working interaction mode.
10. Write the intake in the language of the actual product, user, and workflow. Avoid category-sounding filler.
11. Run a human-voice pass: remove any sentence that could ship unchanged in ten unrelated products. Use `docs/human-voice.md` as the bar.
12. Produce intake summary, operator preference summary, unresolved questions, recommended ORCA Framework path, and draft spec skeleton.
13. If the user clearly wants durable behavior, prepare `templates/user-guidance-profile.md` or point to `orca-learning`.
14. Post or prepare the summary for the GitHub issue or opt-out record.

## Expected Outputs

- Filled `templates/intake.md`
- Initial spec skeleton using `templates/spec.md`
- Optional `templates/user-guidance-profile.md` when the user wants durable preference capture
- GitHub intake comment when GitHub-first mode is active

## Quality Bar

The result should let another agent write a credible spec without rereading the entire conversation.
It should also sound like a real operator captured the work item, not like a generic AI intake form.

## Common Failure Modes

- Asking every possible question.
- Asking too few early questions and then writing a fake-confident spec.
- Starting implementation before understanding the user job.
- Hiding assumptions instead of listing them.
- Treating user interaction preferences as stylistic fluff instead of first-run setup inputs.
- Treating involvement level as separate from workflow routing when it should influence checkpoints, summaries, and whether unattended execution is even appropriate.
- Ignoring a better harness-native question tool and dumping a long freeform questionnaire into the thread.

## Relationship To Other ORCA Framework Skills And Commands

Feeds `orca-onboard`, `orca-spec`, `orca-discover`, and `orca-research`.
