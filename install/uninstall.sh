#!/usr/bin/env sh
set -eu

target="${HOME}/.orca-framework"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target) target="$2"; shift 2 ;;
    -h|--help) printf 'Usage: uninstall.sh [--target path]\n'; exit 0 ;;
    *) printf 'Unknown argument: %s\n' "$1" >&2; exit 1 ;;
  esac
done

[ -f "$target/ORCA-Framework.md" ] || { printf 'Refusing to remove non-Orca target: %s\n' "$target" >&2; exit 1; }
[ -d "$target/commands" ] || { printf 'Refusing to remove target without commands: %s\n' "$target" >&2; exit 1; }
[ -d "$target/skills" ] || { printf 'Refusing to remove target without skills: %s\n' "$target" >&2; exit 1; }

rm -rf "$target"
printf 'Orca Mission Control removed from %s\n' "$target"
