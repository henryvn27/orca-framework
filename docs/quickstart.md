# Quickstart

## 1. Install

Homebrew:

```sh
brew install --formula https://raw.githubusercontent.com/henryvn27/orca-framework/main/Formula/orca.rb
```

Or use the verified [archive, PowerShell, or source path](install.md).

Confirm:

```sh
orca version
```

## 2. Enter A Project

Change into the repository whose outcome you want to manage. Orca writes `.orca/` there.

## 3. Launch Mission Control

```sh
orca dashboard
```

Create one outcome and its observable proofs in the browser, or use the CLI:

```sh
orca mission create "Prepare this change for review" \
  --criterion "The repository has no whitespace errors" \
  --criterion "The behavior is documented"
```

## 4. Record Proof

```sh
orca mission check AC-1 -- git diff --check
orca mission satisfy AC-2 --evidence "README documents the behavior"
```

## 5. Complete

```sh
orca mission complete
orca mission validate
```

If completion is rejected, the error and dashboard next action identify the missing proof or blocker. Continue with [the complete first workflow](first-workflow.md).
