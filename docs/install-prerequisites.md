# Install Prerequisites

## Supported Operating Systems

- macOS: supported by Homebrew, tar archive, or source installer
- Linux: supported by Homebrew, tar archive, or source installer
- Windows: supported by zip archive and native PowerShell installer/launcher

Hosted installed-copy acceptance exercises all three platforms on every product change.

## Required Items

| Item | Required | Why |
| --- | --- | --- |
| Ruby 2.6+ | yes | Mission runtime and local dashboard |
| terminal access | yes | launch and operate Orca |
| write permission | yes | install product and write project-local Mission state |
| Git | source install only | clone and validate the repository |
| Homebrew | Homebrew path only | install formula and Ruby dependency |

Mission Control uses only the Ruby standard library.

## Optional Items

| Item | Required | Why |
| --- | --- | --- |
| GitHub auth | no | PRs, issues, checks, release attestation verification |
| Linear access | no | optional tracker-backed workflow extensions |
| agent harness | no | only when an agent executes Mission work |
| plugins | no | specialized optional workflows |

No Orca account or hosted service login exists or is required.
