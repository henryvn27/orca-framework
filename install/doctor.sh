#!/usr/bin/env sh
set -eu

root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
target=""
harness=""
services=""

usage() {
  printf 'Usage: doctor.sh [--target path] [--harness codex|claude-code|vscode|generic] [--services github,linear,...]\n'
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target) target="$2"; shift 2 ;;
    --harness) harness="$2"; shift 2 ;;
    --services) services="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown argument: %s\n' "$1" >&2; usage >&2; exit 1 ;;
  esac
done

cd "$root"

printf 'ORCA Framework doctor\n'

for bin in sh find grep sed cp rm mkdir git ruby; do
  command -v "$bin" >/dev/null 2>&1 || { printf 'Missing dependency: %s\n' "$bin" >&2; exit 1; }
done

printf 'Core runtime dependencies: ok\n'

if [ -f "$root/ORCA-Framework.md" ] && [ -d "$root/docs" ] && [ -d "$root/commands" ]; then
  printf 'Repo layout: ok\n'
else
  printf 'Repo layout: failed\n' >&2
  exit 1
fi

if [ -n "$target" ]; then
  ./install/verify-install.sh --target "$target"
elif [ -d "$HOME/.orca-framework" ]; then
  ./install/verify-install.sh --target "$HOME/.orca-framework"
else
  printf 'Installed target: not checked (no --target provided and no global install at %s/.orca-framework)\n' "$HOME"
fi

if [ -n "$harness" ]; then
  case "$harness" in
    codex) doc="docs/hosts/codex-cli.md" ;;
    claude-code) doc="docs/hosts/claude-code.md" ;;
    vscode) doc="docs/hosts/vscode.md" ;;
    generic) doc="docs/hosts/generic.md" ;;
    *) printf 'Unsupported harness for doctor: %s\n' "$harness" >&2; exit 1 ;;
  esac
  [ -f "$root/$doc" ] || { printf 'Harness guide missing: %s\n' "$doc" >&2; exit 1; }
  printf 'Harness guide: ok (%s)\n' "$doc"
  if [ "$harness" = "codex" ]; then
    if command -v codex >/dev/null 2>&1; then
      if codex exec --ignore-user-config --help >/dev/null 2>&1; then
        printf 'Harness codex CLI: ok\n'
      else
        printf 'Harness codex CLI: installed, but local help failed; try codex exec --ignore-user-config --help directly\n'
      fi
    else
      printf 'Harness codex CLI: missing; use docs/hosts/codex-cli.md\n'
    fi
  fi
fi

if [ -n "$services" ]; then
  old_ifs="${IFS}"
  IFS=','
  for service in $services; do
    case "$service" in
      github)
        if command -v gh >/dev/null 2>&1; then
          printf 'Service github: gh available\n'
        else
          printf 'Service github: gh missing, use connector or manual fallback\n'
        fi
        ;;
      linear)
        printf 'Service linear: host or connector validation still required; see docs/linear-setup.md\n'
        ;;
      notebooklm|graphify)
        printf 'Service %s: optional; verify only if your path needs it\n' "$service"
        ;;
      *)
        printf 'Service %s: no built-in automation check, use docs/install-validation.md\n' "$service"
        ;;
    esac
  done
  IFS="${old_ifs}"
fi

printf 'Recommended next docs:\n'
printf '%s\n' '- docs/install-validation.md'
printf '%s\n' '- docs/install-troubleshooting.md'
printf '%s\n' '- docs/first-run.md'
printf 'doctor: ok\n'
