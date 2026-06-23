#!/bin/sh
set -eu

root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
cd "$root"

fail() {
  printf 'check-goal-smoke: %s\n' "$1" >&2
  exit 1
}

need_file() {
  [ -f "$1" ] || fail "missing expected file: $1"
}

need_grep() {
  pattern="$1"
  file="$2"
  grep -q "$pattern" "$file" || fail "missing pattern '$pattern' in $file"
}

tmp="${TMPDIR:-/tmp}/orca-goal-smoke.$$"
trap 'rm -rf "$tmp"' EXIT INT TERM HUP
mkdir -p "$tmp"

run_goal() {
  root_dir="$1"
  shift
  ORCA_ROOT="$root_dir" ./bin/orca /goal "make this production ready" --pack release-ready "$@"
}

assert_goal_artifacts() {
  root_dir="$1"
  need_file "$root_dir/state.env"
  need_file "$root_dir/issues.md"
  need_file "$root_dir/runs/make-this-production-ready-plan.md"
  need_file "$root_dir/handoffs/make-this-production-ready.md"
  need_file "$root_dir/loops/make-this-production-ready/docs-sync.pass"
  need_file "$root_dir/loops/make-this-production-ready/handoffs.pass"
  need_grep "phase='handoff'" "$root_dir/state.env"
  need_grep "readiness_score=" "$root_dir/state.env"
}

fallback_root="$tmp/fallback"
run_goal "$fallback_root" >/dev/null
assert_goal_artifacts "$fallback_root"

sync_script="$tmp/sync.sh"
sync_log="$tmp/sync.log"
cat > "$sync_script" <<EOF
#!/bin/sh
printf '%s\n' "\$1" >> "$sync_log"
exit 0
EOF
chmod +x "$sync_script"

success_root="$tmp/notion-success"
ORCA_ROOT="$success_root" ./bin/orca backend status >/dev/null
sed -i.bak 's/notion_issue_board_data_source_id=/notion_issue_board_data_source_id=collection-456/' "$success_root/config.env"
ORCA_ROOT="$success_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca /goal "make this production ready" --pack release-ready >/dev/null
assert_goal_artifacts "$success_root"
[ -s "$sync_log" ] || fail "sync command did not run"
synced_count=$(/usr/bin/find "$success_root/notion/synced" -type f | wc -l | tr -d ' ')
[ "$synced_count" -gt 0 ] || fail "expected synced Notion payloads"

fail_root="$tmp/notion-fail"
ORCA_ROOT="$fail_root" ./bin/orca backend status >/dev/null
sed -i.bak 's/notion_issue_board_data_source_id=/notion_issue_board_data_source_id=collection-456/' "$fail_root/config.env"
ORCA_ROOT="$fail_root" ORCA_NOTION_SYNC_COMMAND=/usr/bin/false ./bin/orca /goal "make this production ready" --pack release-ready >/dev/null
assert_goal_artifacts "$fail_root"
outbox_count=$(/usr/bin/find "$fail_root/notion/outbox" -type f | wc -l | tr -d ' ')
[ "$outbox_count" -gt 0 ] || fail "expected failed sync payloads to remain in outbox"

printf 'check-goal-smoke: ok\n'
