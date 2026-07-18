# Start Here

Orca is local mission control for AI coding work. Start with one Mission.

## The Four Parts

1. **Mission:** the durable outcome, acceptance criteria, blockers, evidence, and lifecycle.
2. **Executor:** Codex, Claude Code, another agent, or a human doing the work.
3. **Skills:** optional procedures that help the executor plan, build, review, or ship.
4. **Integrations:** optional adapters for trackers, docs, and other external systems.

Only the Mission is required. This separation is what keeps Orca useful across harnesses instead of turning it into another directory of prompts.

## The First Path

1. Install with [Quickstart](quickstart.md).
2. Create one Mission with observable acceptance criteria.
3. Let any executor make the change.
4. Use `orca mission check` for command-verifiable criteria.
5. Use `orca mission satisfy` for explicit review evidence.
6. Resolve blockers and run `orca mission complete`.

The full walkthrough is in [First Workflow](first-workflow.md).

## Choose The Next Layer Only When Needed

- Need an agent implementation procedure? See [Commands](commands.md).
- Need reusable agent guidance? See [Skills](skills.md).
- Need host-specific behavior? See [Compatibility Matrix](compatibility-matrix.md).
- Need the larger capability catalog? See [Feature Index](feature-index.md).
- Need the conceptual boundary? Read [What Orca Is](intro.md).

The catalog is reference material. It is not the onboarding flow and it is not the definition of the product.
