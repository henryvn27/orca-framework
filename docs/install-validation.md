# Install Validation

Install validation is the check layer that tells the user whether ORCA is actually ready.

## What It Checks

- required files exist
- Mission Control runtime, docs, commands, skills, and templates were copied
- runnable `orca` and `orca-*` command shims exist in `bin/`
- install scripts are present
- core shell and Ruby dependencies exist
- optional harness and service checks are routed correctly

## Validation Commands

Repo validation:

```sh
./scripts/validate-repo.sh
```

Installed target validation:

```sh
./install/verify-install.sh --target ./.orca-framework
```

Broader install doctor:

```sh
./install/doctor.sh --target ./.orca-framework --services github,linear
```

Harness-aware doctor:

```sh
./install/doctor.sh --target ./.orca-framework --harness codex
```

## Output Shape

The result should tell the user:

- what passed
- what failed
- what was not checked
- what to do next
