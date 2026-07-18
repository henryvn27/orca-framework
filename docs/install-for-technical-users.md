# Install For Technical Users

Use this page if you want the compact path.

## Fast Path

```sh
git clone https://github.com/henryvn27/orca-framework.git
cd orca-framework
./scripts/validate-repo.sh
./install/install.sh --mode local --target ./.orca-framework
export PATH="$(pwd)/.orca-framework/bin:$PATH"
./install/verify-install.sh --target ./.orca-framework
./install/doctor.sh --target ./.orca-framework
orca mission create "First verifiable outcome" --criterion "A real check passes"
```

## Choose Only What You Need

- Stay in repo mode if you are contributing.
- Use local install for one project.
- Use global install only if you actually want a user-level copy.

## Additions

- Need GitHub or Linear for a specific Mission: [external-tool-setup.md](external-tool-setup.md)
- Need a harness: [harness-installation.md](harness-installation.md)
- Need optional plugins: [plugin-installation.md](plugin-installation.md)

## Canonical Truth

This page is the short form.

The canonical install contract is still [install.md](install.md).
