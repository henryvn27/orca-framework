# Install Orca 1.0

This is the canonical install guide. Orca uses Ruby’s standard library and installs no runtime packages.

## Requirements

- Ruby 2.6 or newer
- macOS, Linux, or Windows
- a terminal with permission to write the selected install directory
- Git only for a source-checkout install

Verify Ruby:

```sh
ruby --version
```

## Homebrew

Homebrew is the shortest verified path on macOS and Linux:

```sh
brew install --formula https://raw.githubusercontent.com/henryvn27/orca-framework/main/Formula/orca.rb
orca version
orca dashboard
```

The formula installs the published `v1.0.0` archive, verifies its SHA-256, and depends on Homebrew Ruby.

## Release Archive On macOS Or Linux

Download these files from [GitHub Release v1.0.0](https://github.com/henryvn27/orca-framework/releases/tag/v1.0.0):

- `orca-1.0.0.tar.gz`
- `orca-1.0.0-checksums.txt`

Verify and install:

```sh
shasum -a 256 -c orca-1.0.0-checksums.txt
tar -xzf orca-1.0.0.tar.gz
./orca-1.0.0/install/install.sh --mode global
export PATH="$HOME/.orca-framework/bin:$PATH"
orca version
orca dashboard
```

On Linux, use `sha256sum -c` if `shasum` is unavailable.

For a project-local product copy:

```sh
./orca-1.0.0/install/install.sh --mode local --target ./.orca-framework
export PATH="$(pwd)/.orca-framework/bin:$PATH"
```

## Release Archive On Windows

Download `orca-1.0.0.zip` and `orca-1.0.0-checksums.txt`. Compare the zip hash:

```powershell
(Get-FileHash .\orca-1.0.0.zip -Algorithm SHA256).Hash
```

Expand the archive, then:

```powershell
& .\orca-1.0.0\install\install.ps1 -Mode global
$env:PATH = "$HOME\.orca-framework\bin;$env:PATH"
orca version
orca dashboard
```

For one project:

```powershell
& .\orca-1.0.0\install\install.ps1 -Mode local -Target .\.orca-framework
$env:PATH = "$(Resolve-Path .\.orca-framework\bin);$env:PATH"
```

`orca.cmd` is the normal Windows entrypoint and routes to the native PowerShell launcher.

## Source Checkout

```sh
git clone https://github.com/henryvn27/orca-framework.git
cd orca-framework
./scripts/validate-repo.sh
./install/install.sh --mode local --target ./.orca-framework
export PATH="$(pwd)/.orca-framework/bin:$PATH"
./install/verify-install.sh --target ./.orca-framework
./install/doctor.sh --target ./.orca-framework
orca version
```

PowerShell source install:

```powershell
git clone https://github.com/henryvn27/orca-framework.git
Set-Location orca-framework
& .\install\install.ps1 -Mode local -Target .\.orca-framework
& .\.orca-framework\bin\orca.cmd version
```

## First Installed-Copy Proof

Change into a real project and run:

```sh
orca mission create "Verify Orca in this project" \
  --criterion "The installed lifecycle completes" \
  --by "Install owner"
orca mission satisfy AC-1 --evidence "Installed Orca executed" --by "Install owner"
orca mission complete --by "Install owner"
orca mission validate
```

Mission state appears in that project’s `.orca/`, not in the Orca installation.

## What Gets Installed

- Mission runtime and secure dashboard
- POSIX, PowerShell, and Windows launchers
- install verification and doctor scripts
- product documentation
- optional workflow commands, skills, templates, schemas, and integration guidance

No service account, daemon, telemetry client, or global project state is created.

## Uninstall

The installer copies Orca into the selected target. Remove that exact target when it is no longer needed. Project `.orca/` Mission history is separate and is never removed by uninstalling the product.

See [install troubleshooting](install-troubleshooting.md) and [release verification](releases.md) for recovery and supply-chain checks.
