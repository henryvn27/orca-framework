# Beginner's Guide To Orca

This guide is for someone who has used a vibe-coding tool like Lovable, but feels overwhelmed by Codex or Claude Code.

You do not need to become a terminal power user before ORCA is useful.
The point of Orca is to give you one stable definition of success so you are not trying to learn:

- your project
- Codex or Claude Code
- agent prompting
- planning and QA procedures

all at once.

## The Mental Model

Think of the stack like this:

- Codex, Claude Code, or a human: the executor
- Orca Mission Control: the outcome, evidence, and completion gate
- skills and workflow definitions: optional guidance for the executor
- your project: the thing you actually care about

If you are new, do not try to learn every harness command first.
Learn the Mission path first.

## The Only Path You Need At First

1. Create a Mission with the outcome you want and observable acceptance criteria.
2. Let Codex, Claude Code, another agent, or a human do the work.
3. Use `orca mission check` for criteria a command can prove.
4. Use `orca mission satisfy` for explicit review evidence.
5. Run `orca mission complete`; if something is still unproven, Orca tells you exactly what is missing.

If you remember one thing, remember this: the executor does the work; the Mission decides whether the evidence is complete.

## What To Expect As A Beginner

At first, Orca should:

- ask a few useful setup questions
- explain terms briefly
- hide most optional features
- give you one next step instead of five
- tell you what "done" means for the current Mission

It should not:

- dump a huge command catalog on you
- assume you know Codex or Claude Code terminology
- make you choose between ten modes before first success
- act like you need to be "technical enough" to begin

## Good Beginner Preferences

If an agent asks how you want it to behave, good starting answers are:

- explanation: `explain briefly`
- jargon: `plain language` or `mixed`
- question style: `balanced`
- decision style: `short rationale`
- involvement: `keep me in the loop at meaningful steps`
- unattended work: `ask before switching to goal or background mode`

That usually gives enough support without turning the workflow into a lecture.

## How To Learn Without Getting Stuck

Use this rule:

- learn the current step
- learn why it exists
- learn one adjacent step only after success

Example:

- first learn `orca mission create`
- then learn `orca mission check` and `orca mission complete`
- after you complete one Mission, add one optional agent procedure such as `orca-plan`, `orca-review`, or `orca-test-blind`

Do not try to learn delegation, background mode, evals, and integrations on day one.

## What To Say To Your Agent

Good beginner prompts:

- `Help me figure out what I should build first`
- `I have an app idea but I need structure`
- `I want to change this feature but I do not know the right workflow yet`
- `Explain this briefly and then do the next step`
- `Keep the wording nontechnical`

Good correction prompts:

- `ask fewer questions`
- `explain more`
- `keep it concise`
- `show me options`
- `do not explain unless I ask`

You do not need perfect prompting. The agent can adapt while the Mission keeps the outcome stable.

## When Codex Or Claude Code Feels Overwhelming

That usually means one of these:

- too many host-specific terms too early
- too many choices before first success
- too much tool or setup detail before the real task is clear

The fix is usually not "learn the host better first."
The fix is to return to the Mission and reduce scope:

1. restate one small outcome
2. write observable criteria
3. do one small build
4. prove only those criteria

## How You Become Advanced

Orca should make success easier to inspect through repetition.

You are moving up when:

- you need less explanation
- you can spot a vague task and tighten it quickly
- you can write criteria that distinguish work from proof
- you start asking for more advanced paths like QA, goal mode, or delegation

You should not need to "graduate" from Orca. The same Mission contract should work when you become experienced, even if your executor and procedures change.

## If You Want To Be Very Hands-On Or Very Hands-Off

Orca should support both ends cleanly.

If you want to stay very involved:

- ask for reviewable checkpoints
- ask the agent to explain changes as it goes
- avoid goal mode for work you want to inspect step by step

If you want ORCA to run with less supervision:

- prefer milestone-sized work with a clear spec
- allow major-checkpoint summaries instead of step-by-step narration
- use goal mode only when the work is bounded and verifiable

You can change this preference later.
You do not have to pick one forever.

## Best Next Pages

- [install-for-beginners.md](../install-for-beginners.md)
- [first-run.md](../first-run.md)
- [first-workflow.md](../first-workflow.md)
- [explanation-mode.md](../explanation-mode.md)
- [command-index.md](../command-index.md)
