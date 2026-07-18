# Mission Portability

Orca moves Mission state explicitly rather than running an account-backed sync service.

## Export

```sh
orca mission export --output mission.orca.json
orca mission export MISSION-ID --output historical.orca.json
```

Export refuses to replace an existing file. Use `--force` only after resolving the target path:

```sh
orca mission export --output mission.orca.json --force
```

The file is a versioned `orca_mission_export` envelope containing validated public Mission state. Derived readiness and next action are included for inspection and recalculated on import.

## Import

```sh
orca mission import mission.orca.json
```

Import validates the envelope, schema, identifiers, timestamps, criteria, evidence, blockers, notes, events, lifecycle timestamps, and status invariants before writing anything.

Safety behavior:

- identical state with the same ID is idempotent;
- different state with the same ID is rejected;
- an active import cannot overwrite another active Mission;
- unsupported export or Mission schema versions are rejected;
- writes use the same lock and atomic persistence as local mutations.

## Transfer Procedure

1. Validate the source Mission with `orca mission validate`.
2. Export to a new file.
3. Transfer that file through the user’s chosen secure channel.
4. Keep the source project unchanged until the destination import succeeds.
5. Import on the destination.
6. Run `orca mission show MISSION-ID` and `orca mission validate MISSION-ID`.

Orca does not encrypt exported files. Evidence and notes may contain sensitive project context, so storage and transfer protection belong to the user’s chosen filesystem and channel.
