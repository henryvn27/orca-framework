#!/usr/bin/env sh
set -eu

mode="local"
target=""

print_next_steps() {
  printf '\nNext steps:\n'
  printf '1. Read the install guide: %s\n' "$target/docs/install.md"
  printf '2. Pick a path: %s\n' "$target/docs/install-paths.md"
  printf '3. Add ORCA commands to PATH: export PATH="%s/bin:$PATH"\n' "$target"
  printf '4. Run install verification: %s/verify-install.sh --target %s\n' "$target/install" "$target"
  printf '5. Run doctor when you want a broader check: %s/doctor.sh --target %s\n' "$target/install" "$target"
}

generate_bin_shims() {
  mkdir -p "$target/bin"
  cp "$root/bin/orca" "$target/bin/orca"
  chmod +x "$target/bin/orca"

  find "$target/commands" -type f -name 'orca-*.md' | while IFS= read -r command_file; do
    command_name=$(basename "$command_file" .md)
    shim_path="$target/bin/$command_name"
    cat > "$shim_path" <<EOF
#!/usr/bin/env sh
set -eu
script_dir=\$(CDPATH= cd -- "\$(dirname -- "\$0")" && pwd)
exec "\$script_dir/orca" "$command_name" "\$@"
EOF
    chmod +x "$shim_path"
  done
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --mode) mode="$2"; shift 2 ;;
    --target) target="$2"; shift 2 ;;
    -h|--help)
      printf 'Usage: install.sh [--mode local|global] [--target path]\n'
      exit 0
      ;;
    *) printf 'Unknown argument: %s\n' "$1" >&2; exit 1 ;;
  esac
done

case "$mode" in
  local) target="${target:-./.orca-framework}" ;;
  global) target="${target:-$HOME/.orca-framework}" ;;
  *) printf 'Mode must be local or global\n' >&2; exit 1 ;;
esac

root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
mkdir -p "$target"

for item in ORCA-Framework.md README.md commands skills templates docs mcp install scripts bin; do
  [ -e "$root/$item" ] || { printf 'Missing source item: %s\n' "$item" >&2; exit 1; }
  rm -rf "$target/$item"
  cp -R "$root/$item" "$target/$item"
done

generate_bin_shims

cat > "$target/VERSION" <<VERSION
0.2.0-dev
VERSION

printf 'ORCA Framework installed to %s\n' "$target"
printf 'Install overview: %s\n' "$target/docs/install-overview.md"
printf 'Beginner path: %s\n' "$target/docs/install-for-beginners.md"
printf 'Technical path: %s\n' "$target/docs/install-for-technical-users.md"
printf 'Linear-first guidance: %s\n' "$target/docs/linear-guidance.md"
printf 'Opt-out mode: choose a durable system of record and map ORCA Framework gates there.\n'
print_next_steps
