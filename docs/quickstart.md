# Quickstart

This is the shortest path from clone to a real Orca Mission.

## 1. Install

```sh
git clone https://github.com/henryvn27/orca-framework.git
cd orca-framework
./scripts/validate-repo.sh
./install/install.sh --mode local --target ./.orca-framework
export PATH="$(pwd)/.orca-framework/bin:$PATH"
./install/verify-install.sh --target ./.orca-framework
```

## 2. Enter A Project

Change into a repository with one small outcome you can actually verify. Orca stores state in that project’s `.orca/` directory, not in the framework checkout.

## 3. Create A Mission

```sh
orca mission create "Prepare this change for review" \
  --criterion "The repository has no whitespace errors" \
  --criterion "The behavior is documented"
```

## 4. Prove The Criteria

```sh
orca mission check AC-1 -- git diff --check
orca mission satisfy AC-2 --evidence "README documents the behavior"
```

## 5. Complete

```sh
orca mission status
orca mission complete
```

If completion is rejected, the error names the criteria or blocker that still needs proof. Continue with [the first workflow](first-workflow.md) for failure, blocker, history, and JSON behavior.
