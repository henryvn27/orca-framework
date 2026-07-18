#!/usr/bin/env python3
"""Build deterministic Orca release archives, checksums, and provenance."""

from __future__ import annotations

import argparse
import gzip
import hashlib
import io
import json
from pathlib import Path
import subprocess
import tarfile
import zipfile


EXCLUDED_PREFIXES = (".github/", "Formula/")
EXCLUDED_FILES = {".gitignore", ".gitattributes", ".editorconfig"}
FIXED_ZIP_TIME = (1980, 1, 1, 0, 0, 0)


def run(root: Path, *command: str) -> str:
    result = subprocess.run(command, cwd=root, check=True, text=True, capture_output=True)
    return result.stdout.strip()


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def source_entries(root: Path, tree: str) -> list[tuple[Path, bytes, int]]:
    result = subprocess.run(
        ("git", "archive", "--format=tar", tree), cwd=root, check=True, capture_output=True
    )
    included: list[tuple[Path, bytes, int]] = []
    with tarfile.open(fileobj=io.BytesIO(result.stdout), mode="r:") as archive:
        for member in archive.getmembers():
            value = member.name
            if not member.isfile() or value in EXCLUDED_FILES or value.startswith(EXCLUDED_PREFIXES):
                continue
            extracted = archive.extractfile(member)
            if extracted is None:
                raise SystemExit(f"could not read release file {value}")
            mode = 0o755 if member.mode & 0o100 else 0o644
            included.append((Path(value), extracted.read(), mode))
    if not included:
        raise SystemExit("no indexed release files found")
    return sorted(included, key=lambda item: item[0].as_posix())


def ensure_index_matches_worktree(root: Path) -> None:
    unstaged = run(root, "git", "diff", "--name-only")
    untracked = run(root, "git", "ls-files", "--others", "--exclude-standard")
    if unstaged or untracked:
        details = ", ".join(value for value in (unstaged, untracked) if value)
        raise SystemExit(f"release packaging uses the Git index; stage or remove working-tree files first: {details}")


def manifest(version: str, entries: list[tuple[Path, bytes, int]]) -> bytes:
    payload = {
        "format": "orca_release_manifest",
        "format_version": "1.0.0",
        "product": "Orca Mission Control",
        "version": version,
        "files": [
            {
                "path": path.as_posix(),
                "sha256": sha256(data),
                "mode": format(mode, "04o"),
            }
            for path, data, mode in entries
        ],
    }
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def build_tar(archive_root: str, entries: list[tuple[Path, bytes, int]], manifest_bytes: bytes, destination: Path) -> None:
    with destination.open("wb") as raw:
        with gzip.GzipFile(filename="", mode="wb", fileobj=raw, compresslevel=9, mtime=0) as compressed:
            with tarfile.open(fileobj=compressed, mode="w", format=tarfile.PAX_FORMAT) as archive:
                for relative, data, mode in entries:
                    info = tarfile.TarInfo(f"{archive_root}/{relative.as_posix()}")
                    info.size = len(data)
                    info.mode = mode
                    info.mtime = 0
                    info.uid = 0
                    info.gid = 0
                    info.uname = "root"
                    info.gname = "root"
                    archive.addfile(info, io.BytesIO(data))
                info = tarfile.TarInfo(f"{archive_root}/RELEASE-MANIFEST.json")
                info.size = len(manifest_bytes)
                info.mode = 0o644
                info.mtime = 0
                info.uid = 0
                info.gid = 0
                info.uname = "root"
                info.gname = "root"
                archive.addfile(info, io.BytesIO(manifest_bytes))


def build_zip(archive_root: str, entries: list[tuple[Path, bytes, int]], manifest_bytes: bytes, destination: Path) -> None:
    with zipfile.ZipFile(destination, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for relative, data, mode in entries:
            info = zipfile.ZipInfo(f"{archive_root}/{relative.as_posix()}", FIXED_ZIP_TIME)
            info.compress_type = zipfile.ZIP_DEFLATED
            info.create_system = 3
            info.external_attr = (0o100000 | mode) << 16
            archive.writestr(info, data, compress_type=zipfile.ZIP_DEFLATED, compresslevel=9)
        info = zipfile.ZipInfo(f"{archive_root}/RELEASE-MANIFEST.json", FIXED_ZIP_TIME)
        info.compress_type = zipfile.ZIP_DEFLATED
        info.create_system = 3
        info.external_attr = (0o100000 | 0o644) << 16
        archive.writestr(info, manifest_bytes, compress_type=zipfile.ZIP_DEFLATED, compresslevel=9)


def verify_archive_members(archive_root: str, expected: set[str], tar_path: Path, zip_path: Path) -> None:
    expected_members = {f"{archive_root}/{path}" for path in expected} | {f"{archive_root}/RELEASE-MANIFEST.json"}
    with tarfile.open(tar_path, "r:gz") as archive:
        actual = {member.name for member in archive.getmembers() if member.isfile()}
        if actual != expected_members:
            raise SystemExit("tar archive member verification failed")
    with zipfile.ZipFile(zip_path) as archive:
        actual = {name for name in archive.namelist() if not name.endswith("/")}
        if actual != expected_members:
            raise SystemExit("zip archive member verification failed")
        bad = archive.testzip()
        if bad:
            raise SystemExit(f"zip archive integrity failed at {bad}")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", default="dist", help="output directory")
    parser.add_argument("--allow-dirty", action="store_true", help="allow packaging staged, uncommitted index state")
    arguments = parser.parse_args()

    root = Path(__file__).resolve().parent.parent
    ensure_index_matches_worktree(root)
    if not arguments.allow_dirty and run(root, "git", "status", "--porcelain", "--untracked-files=normal"):
        raise SystemExit("release packaging requires a clean Git worktree")
    version = (root / "VERSION").read_text().strip()
    if not version or version.count(".") != 2:
        raise SystemExit("VERSION must contain a semantic version")
    tree = run(root, "git", "write-tree")
    entries = source_entries(root, tree)
    archive_root = f"orca-{version}"
    manifest_bytes = manifest(version, entries)
    output = Path(arguments.output).resolve()
    output.mkdir(parents=True, exist_ok=True)
    tar_path = output / f"{archive_root}.tar.gz"
    zip_path = output / f"{archive_root}.zip"
    build_tar(archive_root, entries, manifest_bytes, tar_path)
    build_zip(archive_root, entries, manifest_bytes, zip_path)
    verify_archive_members(archive_root, {path.as_posix() for path, _data, _mode in entries}, tar_path, zip_path)

    provenance = {
        "format": "orca_release_provenance",
        "format_version": "1.0.0",
        "product": "Orca Mission Control",
        "version": version,
        "source_repository": run(root, "git", "config", "--get", "remote.origin.url"),
        "source_commit": run(root, "git", "rev-parse", "HEAD"),
        "source_tree": tree,
        "archives": {
            tar_path.name: sha256(tar_path.read_bytes()),
            zip_path.name: sha256(zip_path.read_bytes()),
        },
        "manifest_sha256": sha256(manifest_bytes),
    }
    provenance_path = output / f"{archive_root}-provenance.json"
    provenance_path.write_text(json.dumps(provenance, indent=2, sort_keys=True) + "\n")
    checksum_paths = [tar_path, zip_path, provenance_path]
    checksums_path = output / f"{archive_root}-checksums.txt"
    checksums_path.write_text("".join(f"{sha256(path.read_bytes())}  {path.name}\n" for path in checksum_paths))
    print(f"Built Orca {version} release artifacts in {output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
