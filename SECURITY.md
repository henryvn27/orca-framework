# Security Policy

## Supported Versions

Security fixes target Orca `1.x` and the `main` branch. Users should install the latest published `1.x` release.

## Reporting A Vulnerability

Report vulnerabilities privately to Henry Van Ness through the maintainer contact listed on the GitHub repository profile. Do not open a public issue until disclosure timing is confirmed.

Include:

- a concise description;
- affected version, platform, files, or workflow;
- reproduction steps;
- expected impact;
- suggested mitigation when known.

## Product Security Boundary

- Mission state is local and is not uploaded by Orca.
- Mission files and temporary writes use the current OS account’s filesystem permissions; persisted state is written mode `0600` on POSIX systems.
- Mutations take an exclusive project lock and validate the full resulting state before atomic rename.
- Mission Control binds only to `127.0.0.1`.
- Dashboard writes require a per-process random token, exact origin, JSON content type, and an allowed action.
- Dashboard commands execute as argument arrays without a shell.
- Export files are validated but not encrypted; users must protect them with an appropriate filesystem and transfer channel.
- Optional agent workflows can still invoke powerful external tools. Their permissions and credentials remain under the chosen harness and OS account.

Security reports may cover runtime transitions, state integrity, dashboard/CSRF boundaries, installers, release artifacts, native launchers, optional workflow definitions, CI, or documentation that could cause unsafe agent behavior.
