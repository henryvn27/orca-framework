#!/usr/bin/env sh
set -eu

mode="local"
target=""

print_next_steps() {
  printf '\nNext steps:\n'
  printf '1. Add Orca to PATH: export PATH="%s/bin:$PATH"\n' "$target"
  printf '2. Verify the install: %s/verify-install.sh --target %s\n' "$target/install" "$target"
  printf '3. Run the doctor: %s/doctor.sh --target %s\n' "$target/install" "$target"
  printf '4. Create your first Mission: orca mission create "Outcome" --criterion "Observable proof"\n'
  printf '5. Follow the product walkthrough: %s\n' "$target/docs/first-workflow.md"
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

for item in VERSION ORCA-Framework.md README.md commands skills templates docs dashboard mcp install scripts bin; do
  [ -e "$root/$item" ] || { printf 'Missing source item: %s\n' "$item" >&2; exit 1; }
  rm -rf "$target/$item"
  cp -R "$root/$item" "$target/$item"
done

generate_bin_shims

printf 'Orca Mission Control installed to %s\n' "$target"
printf 'Install overview: %s\n' "$target/docs/install-overview.md"
printf 'Beginner path: %s\n' "$target/docs/install-for-beginners.md"
printf 'Technical path: %s\n' "$target/docs/install-for-technical-users.md"
printf 'Optional tracker integration: %s\n' "$target/docs/linear-guidance.md"
print_next_steps
