# Releases And Verification

Orca releases are designed to be inspectable and reproducible without trusting an installer pipe.

## Published Files

The `v1.0.0` release includes:

- `orca-1.0.0.tar.gz` for macOS and Linux;
- `orca-1.0.0.zip` for Windows and other zip-based installs;
- `orca-1.0.0-checksums.txt` with SHA-256 values;
- `orca-1.0.0-provenance.json` with source commit/tree and archive hashes;
- a GitHub artifact attestation for every published file.

Each archive contains `RELEASE-MANIFEST.json`, which records the expected path, normalized mode, and SHA-256 hash of every product file.

## Verify SHA-256

macOS:

```sh
shasum -a 256 -c orca-1.0.0-checksums.txt
```

Linux:

```sh
sha256sum -c orca-1.0.0-checksums.txt
```

PowerShell:

```powershell
(Get-FileHash .\orca-1.0.0.zip -Algorithm SHA256).Hash
```

Compare the PowerShell result with the zip line in `orca-1.0.0-checksums.txt`.

## Verify GitHub Attestation

With GitHub CLI:

```sh
gh attestation verify orca-1.0.0.tar.gz --repo henryvn27/orca-framework
```

## Deterministic Build

From a clean checkout of the release tag:

```sh
python3 scripts/package-release.py --output dist
./scripts/check-release-artifacts.sh
```

The builder uses tracked product files, sorted paths, fixed timestamps, normalized owners and modes, and fixed archive roots. The release-artifact check builds twice, compares archive hashes, extracts both formats, installs each one, and completes a Mission with each installed copy.

## Release Acceptance

The tag workflow runs repository validation, deterministic packaging, packaged install acceptance, GitHub provenance attestation, and release publication. Separate hosted install acceptance covers Linux, macOS, and native Windows PowerShell.
