# Install For Technical Users

## Homebrew

```sh
brew install --formula https://raw.githubusercontent.com/henryvn27/orca-framework/main/Formula/orca.rb
orca version
orca dashboard
```

## Source

```sh
git clone https://github.com/henryvn27/orca-framework.git
cd orca-framework
./scripts/validate-repo.sh
./install/install.sh --mode local --target ./.orca-framework
export PATH="$(pwd)/.orca-framework/bin:$PATH"
./install/verify-install.sh --target ./.orca-framework
orca version
```

## Windows

```powershell
& .\install\install.ps1 -Mode local -Target .\.orca-framework
$env:PATH = "$(Resolve-Path .\.orca-framework\bin);$env:PATH"
orca version
orca dashboard
```

Release checksums, attestations, archive layout, and deterministic reproduction are documented in [releases.md](releases.md). The complete canonical contract is [install.md](install.md).
