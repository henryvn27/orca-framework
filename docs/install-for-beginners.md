# Install For Beginners

Use this page if you want Orca explained in plain language and in the safest order.

## What You Are Doing

You are installing Orca Mission Control so you can create an outcome, record proof, and know when the work is actually complete.

You do not need to understand every feature before you start.

## Beginner Path

1. Read [install-prerequisites.md](install-prerequisites.md).
2. Download the repository with Git.
3. Run local install into `./.orca-framework`.
4. Add the installed `bin/` directory to `PATH`.
5. Run verification and the doctor.
6. Skip trackers, plugins, and agent setup unless your first Mission needs them.
7. Run [first-run.md](first-run.md).

## Short Setup Interview

Answer these before you start:

1. Are you just trying Orca, or do you want a setup you will keep using?
2. What is the first outcome you want a Mission to track?
3. Which command or artifact could prove that outcome?
4. Will a human do the work, or do you want Codex, Claude Code, or another agent?
5. Does that Mission actually need GitHub, Linear, or another integration?

## Exact Commands

```sh
git clone https://github.com/henryvn27/orca-framework.git
cd orca-framework
./install/install.sh --mode local --target ./.orca-framework
export PATH="$(pwd)/.orca-framework/bin:$PATH"
./install/verify-install.sh --target ./.orca-framework
./install/doctor.sh --target ./.orca-framework
```

## What Success Looks Like

You should see messages that say the install worked and the doctor check passed.

Then continue to:

1. [first-run.md](first-run.md)
2. [first-success-check.md](first-success-check.md)
3. [first-workflow.md](first-workflow.md)

## Things You Can Skip

You can safely skip these on day one:

- plugins you do not understand yet
- advanced integrations
- extra harnesses
- global install

## If Something Fails

Read:

- [install-troubleshooting.md](install-troubleshooting.md)
- [common-install-errors.md](common-install-errors.md)
- [reset-and-retry.md](reset-and-retry.md)
