# Install Prerequisites

Be explicit here. If a requirement is optional, say so.

## Supported Operating Systems

Current documented paths:

- macOS: supported
- Linux: supported for shell-based install paths
- Windows: partial support through PowerShell install and manual verification

## Required Items

| Item | Required | Why |
| --- | --- | --- |
| git | yes | needed to clone the repo |
| shell access | yes for macOS/Linux | needed to run install and validation scripts |
| Ruby | yes | runs Mission Control using only the Ruby standard library |
| this repository | yes | source of the Mission runtime, launcher, docs, and optional extensions |

## Optional But Common

| Item | Required | Why |
| --- | --- | --- |
| GitHub auth | only if your workflow needs GitHub actions | PRs, issues, checks |
| Linear access | only if you want tracker-backed workflow extensions | optional issue integration |
| harness install | only if you want an agent to execute the work | Codex, Claude Code, VS Code |
| plugins | no | only for specific workflows |

## Accounts You May Need

- GitHub account: only if you need GitHub-integrated workflows
- Linear account: only if a Mission needs the optional Linear integration
- harness account or login: only if the chosen harness requires it

## Permissions

You may need:

- permission to clone the repo
- permission to run local scripts
- permission to sign into GitHub or Linear if your workflow needs them

## Safe To Skip On Day One

- plugins
- optional integrations
- advanced harness setup
- global install
