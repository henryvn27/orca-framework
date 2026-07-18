#!/usr/bin/env sh
set -eu

root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
release_test_dir=$(mktemp -d "${TMPDIR:-/tmp}/orca-release.XXXXXX")
trap 'rm -rf "$release_test_dir"' EXIT INT TERM HUP

fail() {
  printf 'check-release-artifacts: %s\n' "$1" >&2
  exit 1
}

cd "$root"
python3 scripts/package-release.py --allow-dirty --output "$release_test_dir/first" >/dev/null
python3 scripts/package-release.py --allow-dirty --output "$release_test_dir/second" >/dev/null

version=$(cat VERSION)
for archive in "orca-$version.tar.gz" "orca-$version.zip"; do
  first=$(shasum -a 256 "$release_test_dir/first/$archive" | awk '{print $1}')
  second=$(shasum -a 256 "$release_test_dir/second/$archive" | awk '{print $1}')
  [ "$first" = "$second" ] || fail "$archive is not deterministic"
done

mkdir -p "$release_test_dir/tar" "$release_test_dir/zip"
tar -xzf "$release_test_dir/first/orca-$version.tar.gz" -C "$release_test_dir/tar"
unzip -q "$release_test_dir/first/orca-$version.zip" -d "$release_test_dir/zip"

for format in tar zip; do
  source="$release_test_dir/$format/orca-$version"
  target="$release_test_dir/$format-install"
  project="$release_test_dir/$format-project"
  [ -f "$source/RELEASE-MANIFEST.json" ] || fail "$format archive has no release manifest"
  "$source/install/install.sh" --mode local --target "$target" >/dev/null
  "$target/install/verify-install.sh" --target "$target" >/dev/null
  [ "$("$target/bin/orca" version)" = "$version" ] || fail "$format archive installed the wrong version"
  mkdir -p "$project"
  (
    cd "$project"
    "$target/bin/orca" mission create "Install the $format release" --criterion "The packaged lifecycle works" --by "Release artifact test" >/dev/null
    "$target/bin/orca" mission satisfy AC-1 --evidence "$format archive installed" --by "Release artifact test" >/dev/null
    "$target/bin/orca" mission complete --by "Release artifact test" >/dev/null
    "$target/bin/orca" mission validate >/dev/null
  ) || fail "$format archive lifecycle failed"
done

(cd "$release_test_dir/first" && shasum -a 256 -c "orca-$version-checksums.txt" >/dev/null) || fail "published checksums do not verify"
printf 'check-release-artifacts: ok\n'
