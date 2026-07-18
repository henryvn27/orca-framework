# First Success Check

Use this right after install.

## Success Sequence

1. run install verification
2. run doctor
3. add `.orca-framework/bin` or `$HOME/.orca-framework/bin` to `PATH`
4. create one small Mission with an observable criterion
5. run one real check through `orca mission check`
6. complete the Mission only after its evidence is visible

## Validation Commands

```sh
./install/verify-install.sh --target ./.orca-framework
./install/doctor.sh --target ./.orca-framework
export PATH="$(pwd)/.orca-framework/bin:$PATH"
orca mission create "Prove this repository is ready" --criterion "Git reports a valid work tree"
orca mission check AC-1 -- git status --short
orca mission complete
```

## Good First Success

A good first success is:

- one install target
- one verified setup
- one durable Mission
- one real command result recorded as evidence
- one guarded completion
