# GitHub

- Category: business and project systems
- Priority tier: tier 1
- Ideal use cases: source control, PRs, issues, release workflows
- Setup requirements: repo access path, auth method, scope validation
- Permissions or credentials: connector, CLI auth, token, or SSH for repo access
- Supported workflows: repository discovery; issue and Project reads/updates; assignment, labels, status, milestones, dependencies, sub-issues, branches, PRs, checks, and releases
- Validation steps: auth works, repo reachable, needed write scope present
- Common failure modes: auth scope mismatch, host path mismatch, assuming connector parity across harnesses
- Related ORCA Framework commands or docs: `orca-setup`, `orca-validate-integration`, `docs/integrations/github.md`
- Related integrations: GitHub Actions, Vercel
- Risk notes: external write actions should stay explicit
- Web, mobile, or platform caveats: service used across all stack types

## Default work loop

1. Read repository instructions and inspect the issue plus its Project fields.
2. Select one Ready/Queued issue whose dependencies are resolved; confirm scope and acceptance criteria.
3. Assign/claim it and move it to In Progress when the project allows agent-managed status updates.
4. Create an issue-scoped branch or worktree under the repository's branch policy.
5. Implement the issue scope and run its required checks without weakening CI, review, or release gates.
6. Push the branch and open/update a PR that references the issue with `Closes #N` only when merge should close the issue.
7. Record the branch, exact commit SHA, PR, checks, blockers, and residual risk on the issue. Move it to Review / Verify.
8. Use a separate reviewer when required. Merge only after branch protection, checks, reviews, and release gates pass.
9. Close the issue only when acceptance criteria and required gates are satisfied. Keep Project Status synchronized with the issue's true state.

Use native Project fields, issue dependencies, sub-issues, milestones, and PR linking when available. If a native relationship is unavailable, preserve it in a consistent issue-body section and the local migration map. Never put secrets in issue text or automation configuration.
