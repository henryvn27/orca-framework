# orca-pr-feedback

## Purpose

Fetch, organize, and route pull-request comments and review threads into an actionable remediation queue.

## When To Use

Use when a PR exists and review feedback must be triaged or addressed before merge.

## Required Inputs

- PR context or current branch with an associated PR

## Optional Inputs

- GitHub issue URL or number or opt-out work item
- subset of threads to address

## Workflow

1. Resolve the PR.
2. Collect top-level comments, review submissions, and inline review threads.
3. Number the actionable threads and summarize what each requires.
4. Distinguish open, resolved, and outdated feedback.
5. Route the chosen remediation set into implementation or reply work.

## Outputs And Artifacts

- numbered feedback queue
- remediation summary
- recommended next command

## Failure Cases

- If no PR is associated with the branch, record that directly.
- If auth fails, record the exact blocker.
- If thread coverage is partial, say what source was unavailable.
- If GitHub is available, prefer `skills/orca-pr-feedback/scripts/fetch_comments.py` to avoid partial thread coverage.

## Related Commands And Skills

- Commands: `orca-build`, `orca-review`, `orca-ship`
- Skills: `orca-delegation`, `orca-github-core`
