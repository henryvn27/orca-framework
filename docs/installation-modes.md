# Installation Modes

## Repo Mode

Repo mode uses this repository directly. It is best for Orca contributors and source-level evaluation.

## Local Mode

Local mode installs Orca into a project folder, usually `./.orca-framework`. It is best when one project wants a pinned Mission Control runtime.

## Global Mode

Global mode installs Orca into `$HOME/.orca-framework`. It is best when one user wants the same Mission Control commands available across projects.

## Choosing A Mode

Use repo mode while editing Orca itself. Use local mode when a project should pin its installation. Use global mode when you want one installation across many projects. Mission state still lives in each target project's `.orca/` directory.
