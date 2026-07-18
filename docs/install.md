# Install ORCA

This is the canonical install guide.

If you are not sure which version of these instructions to follow, use this page.

## Before You Start

Read:

1. [install-prerequisites.md](install-prerequisites.md)
2. [install-paths.md](install-paths.md)

If you want more handholding, switch to [install-for-beginners.md](install-for-beginners.md).
If you want the shorter version, switch to [install-for-technical-users.md](install-for-technical-users.md).

## 1. Confirm What You Need

Purpose:
Choose the smallest install that matches your actual use case.

Start with a short setup interview before giving commands.

Do this:

1. Decide whether you just want to try ORCA, use it in one project, or install it globally.
2. Name the first outcome you want a Mission to track and how it can be proved.
3. Decide whether a human will execute it or whether you need a harness.
4. Decide whether you want beginner, standard, or technical guidance.
5. Keep optional setup out of the critical path unless you already know you need it.

Suggested questions:

- Are you trying ORCA once, using it in one repo, or setting up your default multi-project environment?
- What observable criterion would prove the first Mission?
- Does that Mission require GitHub, Linear, or an agent harness?
- Do you want the safest beginner path or the fastest technical path?
- What is the first real task you want ORCA to help with after install?
- Do you expect design-heavy frontend work where ORCA should use Impeccable when it is the strongest fit?
- Do you expect execution-heavy coding workflow where ORCA should use Superpowers when it is the strongest fit?

Expected result:
You know which install path you are following.

Verify:
You can answer these questions:

- Am I doing a repo install, local project install, or global install?
- Do I need a harness right now?
- Do I need GitHub or Linear right now?
- What guidance level do I want?
- What first real task will I test after install?
- Do I want Impeccable or Superpowers available as part of my ORCA workflow from the start?

If this fails:
Read [install-paths.md](install-paths.md) and [harness-chooser.md](harness-chooser.md).

## 2. Install Prerequisites

Purpose:
Make sure the base tools are present before you run ORCA commands.

Do this:

1. Install git if it is missing.
2. Make sure you have a POSIX shell if you are using macOS or Linux.
3. Install Ruby if it is missing.
4. Make sure you can run local shell scripts.

Examples:

```sh
git --version
ruby --version
sh --version || true
```

Expected result:
The machine can run Git, shell commands, and the Ruby Mission runtime.

Verify:

```sh
git --version
ruby --version
```

If this fails:
Use [install-troubleshooting.md](install-troubleshooting.md) and [common-install-errors.md](common-install-errors.md).

## 3. Get ORCA

Purpose:
Get a clean copy of Orca before you try to install or validate it.

Do this:

```sh
git clone https://github.com/henryvn27/orca-framework.git
cd orca-framework
```

Expected result:
You are inside the ORCA repository folder.

Verify:

```sh
pwd
test -f ORCA-Framework.md && echo "repo looks right"
```

If this fails:
Check network access, repo permissions, and whether git is installed.

## 4. Choose Install Mode

Purpose:
Install only what you need.

Decision:

- If you want ORCA available only inside this project, use local install.
- If you want ORCA in a reusable user-level folder, use global install.
- If you only want to inspect or contribute to the repo, stay in repo mode.

Examples:

Local install:

```sh
./install/install.sh --mode local --target ./.orca-framework
```

Global install:

```sh
./install/install.sh --mode global
```

Expected result:
ORCA files are copied into the target location.

The install also creates a runnable command layer under `bin/`.

If you want to use `orca` and `orca-*` directly in the shell, add the installed `bin/` directory to `PATH`:

```sh
export PATH="$(pwd)/.orca-framework/bin:$PATH"
```

Verify:

```sh
./install/verify-install.sh --target ./.orca-framework
```

If you used global install, replace `./.orca-framework` with `$HOME/.orca-framework`.

If this fails:
Use [install-validation.md](install-validation.md) and [reset-and-retry.md](reset-and-retry.md).

## 5. Validate Core Install

Purpose:
Catch broken installs before you add integrations or harnesses.

Do this:

Repo validation:

```sh
./scripts/validate-repo.sh
```

Installed target validation:

```sh
./install/verify-install.sh --target ./.orca-framework
```

Broader doctor check:

```sh
./install/doctor.sh --target ./.orca-framework
```

If you used global install, replace `./.orca-framework` with `$HOME/.orca-framework`.

Expected result:
All checks report success.

Verify:
You see `validate-repo: ok`, `install verified`, or `doctor: ok`.

If this fails:
Go to [install-troubleshooting.md](install-troubleshooting.md).

## 6. Connect Core Services If Needed

Purpose:
Only connect services that the next real workflow needs.

Core services:

- GitHub when you need PRs, issues, or checks
- Linear when a Mission needs optional tracker-backed coordination

Do this:

1. Read [external-tool-setup.md](external-tool-setup.md).
2. Use [linear-setup.md](linear-setup.md) if you need Linear now.
3. Use [plugin-installation.md](plugin-installation.md) only if a plugin is actually required.

Expected result:
Needed services are either connected or intentionally skipped.

Verify:
Use [install-validation.md](install-validation.md) and `./install/doctor.sh --services github,linear`.

If this fails:
Use [plugin-troubleshooting.md](plugin-troubleshooting.md) or [install-troubleshooting.md](install-troubleshooting.md).

## 6.5. Add Official Capability Packs If Needed

Purpose:
Add the official wrapped upstream packs that ORCA supports without pretending they are native ORCA implementations.

Current official packs:

- Impeccable for design-heavy frontend work
- Superpowers for execution-heavy coding workflow

Do this:

1. Read [wrapped-capability-packs.md](wrapped-capability-packs.md).
2. Follow [../integrations/impeccable.md](../integrations/impeccable.md) if you want Impeccable inside ORCA.
3. Follow [../integrations/superpowers.md](../integrations/superpowers.md) if you want Superpowers inside ORCA.
4. Use the upstream install or update path for the active harness instead of copying the pack into ORCA Framework.

Expected result:
ORCA can route to these packs as official ORCA surfaces while keeping provenance clear.

Verify:

- you know which pack is installed for which harness
- you know the ORCA entry points: `orca-impeccable` and `orca-superpowers`
- you did not replace the upstream pack with a local ORCA clone

If this fails:
Use the relevant integration doc and continue with ORCA's local fallback path until the pack is installed correctly.

## 7. Add a Harness If Needed

Purpose:
Connect ORCA to the actual agent surface you plan to use.

Do this:

1. Read [harness-chooser.md](harness-chooser.md).
2. Follow [harness-installation.md](harness-installation.md).
3. Use [harness-setup.md](harness-setup.md) for host-specific steps.

Expected result:
You know which harness you are using and how ORCA maps to it.

Verify:

```sh
./install/doctor.sh --harness codex
```

Replace `codex` with the harness you chose.

If this fails:
Use [harness-troubleshooting.md](harness-troubleshooting.md).

## 8. Run a First Success Check

Purpose:
Prove the install works end to end.

Do this:

1. Read [first-run.md](first-run.md).
2. Run the first success flow in [first-success-check.md](first-success-check.md).

Expected result:
You complete one evidence-backed Mission and can still inspect its history.

Important:

- Orca installs the Mission runtime, docs, templates, commands, and skills
- Orca installs a runnable `bin/orca` launcher plus generated compatibility shims
- start with `orca mission create`, not the workflow catalog
- use `orca show <command>` or `orca run <command> --print` when you want the exact prompt without executing it
- in a host like Codex CLI, the shims can launch `codex exec` with the currently supported flag surface and `--ignore-user-config`

Verify:
Use [templates/first-run-validation.md](../templates/first-run-validation.md).

If this fails:
Use [install-troubleshooting.md](install-troubleshooting.md) and [reset-and-retry.md](reset-and-retry.md).

## 9. Know What To Do Next

After install, most users should continue with one of these:

- [first-workflow.md](first-workflow.md)
- [start-here.md](start-here.md)
- [choose-your-path.md](choose-your-path.md)

Do not widen into optional plugins, advanced harness setup, or extra integrations unless your next real task requires them.
