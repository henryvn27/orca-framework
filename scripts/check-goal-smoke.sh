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
ORCA_ROOT="$fallback_root" ./bin/orca notion doctor > "$tmp/notion-doctor-fallback.txt"
need_grep "notion issue board: missing" "$tmp/notion-doctor-fallback.txt"
need_grep "notion sync command: missing" "$tmp/notion-doctor-fallback.txt"
need_grep "linear: not configured, still optional" "$tmp/notion-doctor-fallback.txt"
ORCA_ROOT="$fallback_root" ./bin/orca notion doctor --json > "$tmp/notion-doctor-fallback.json"
need_grep '"notion_issue_board_configured":false' "$tmp/notion-doctor-fallback.json"
need_grep '"notion_sync_command_status":"missing"' "$tmp/notion-doctor-fallback.json"
need_grep '"ready":false' "$tmp/notion-doctor-fallback.json"
if ORCA_ROOT="$fallback_root" ./bin/orca notion doctor --strict >/dev/null 2>&1; then
  fail "expected strict doctor to fail without Notion config"
fi
if ORCA_ROOT="$fallback_root" ./bin/orca notion doctor --strict --json >/dev/null 2>&1; then
  fail "expected strict JSON doctor to fail without Notion config"
fi

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
ORCA_ROOT="$success_root" ./bin/orca backend status > "$tmp/backend-status.txt"
need_grep "notion outbox: 0 payload(s)" "$tmp/backend-status.txt"
need_grep "notion synced: " "$tmp/backend-status.txt"
ORCA_ROOT="$success_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion doctor > "$tmp/notion-doctor-success.txt"
need_grep "notion issue board: configured" "$tmp/notion-doctor-success.txt"
need_grep "notion sync command: executable" "$tmp/notion-doctor-success.txt"
need_grep "notion outbox: 0 payload(s)" "$tmp/notion-doctor-success.txt"
ORCA_ROOT="$success_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion doctor --json > "$tmp/notion-doctor-success.json"
need_grep '"notion_issue_board_configured":true' "$tmp/notion-doctor-success.json"
need_grep '"notion_sync_command_status":"executable"' "$tmp/notion-doctor-success.json"
need_grep '"ready":true' "$tmp/notion-doctor-success.json"
ORCA_ROOT="$success_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion doctor --strict >/dev/null
ORCA_ROOT="$success_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion doctor --strict --json >/dev/null

fail_root="$tmp/notion-fail"
ORCA_ROOT="$fail_root" ./bin/orca backend status >/dev/null
sed -i.bak 's/notion_issue_board_data_source_id=/notion_issue_board_data_source_id=collection-456/' "$fail_root/config.env"
ORCA_ROOT="$fail_root" ORCA_NOTION_SYNC_COMMAND=/usr/bin/false ./bin/orca /goal "make this production ready" --pack release-ready >/dev/null
assert_goal_artifacts "$fail_root"
outbox_count=$(/usr/bin/find "$fail_root/notion/outbox" -type f | wc -l | tr -d ' ')
[ "$outbox_count" -gt 0 ] || fail "expected failed sync payloads to remain in outbox"
ORCA_ROOT="$fail_root" ./bin/orca backend status > "$tmp/backend-status-fail.txt"
need_grep "notion outbox: " "$tmp/backend-status-fail.txt"
need_grep "notion synced: 0 payload(s)" "$tmp/backend-status-fail.txt"

adapter_log="$tmp/adapter.log"
cat > "$sync_script" <<EOF
#!/bin/sh
printf '%s\n' "\$1" >> "$adapter_log"
exit 0
EOF
chmod +x "$sync_script"

adapter_root="$tmp/adapter-success"
ORCA_ROOT="$adapter_root" ./bin/orca backend status >/dev/null
sed -i.bak 's/notion_issue_board_data_source_id=/notion_issue_board_data_source_id=collection-456/' "$adapter_root/config.env"
ORCA_ROOT="$adapter_root" ./bin/orca /goal "make this production ready" --pack release-ready >/dev/null
adapter_outbox_before=$(/usr/bin/find "$adapter_root/notion/outbox" -type f | wc -l | tr -d ' ')
[ "$adapter_outbox_before" -gt 0 ] || fail "expected adapter success setup to create outbox payloads"
ORCA_ROOT="$adapter_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion sync --all >/dev/null
[ -s "$adapter_log" ] || fail "adapter sync command did not receive payloads"
adapter_outbox_after=$(/usr/bin/find "$adapter_root/notion/outbox" -type f | wc -l | tr -d ' ')
[ "$adapter_outbox_after" -eq 0 ] || fail "expected adapter success to clear outbox"
adapter_synced=$(/usr/bin/find "$adapter_root/notion/synced" -type f | wc -l | tr -d ' ')
[ "$adapter_synced" -gt 0 ] || fail "expected adapter success to move payloads to synced"

adapter_fail_root="$tmp/adapter-fail"
ORCA_ROOT="$adapter_fail_root" ./bin/orca backend status >/dev/null
sed -i.bak 's/notion_issue_board_data_source_id=/notion_issue_board_data_source_id=collection-456/' "$adapter_fail_root/config.env"
ORCA_ROOT="$adapter_fail_root" ./bin/orca /goal "make this production ready" --pack release-ready >/dev/null
if ORCA_ROOT="$adapter_fail_root" ORCA_NOTION_SYNC_COMMAND=/usr/bin/false ./bin/orca notion sync --all >/dev/null 2>&1; then
  fail "expected adapter sync failure to return non-zero"
fi
adapter_fail_outbox=$(/usr/bin/find "$adapter_fail_root/notion/outbox" -type f | wc -l | tr -d ' ')
[ "$adapter_fail_outbox" -gt 0 ] || fail "expected adapter failure payloads to remain in outbox"

missing_config_root="$tmp/adapter-missing-config"
ORCA_ROOT="$missing_config_root" ./bin/orca backend status >/dev/null
sed -i.bak 's/notion_issue_board_data_source_id=/notion_issue_board_data_source_id=collection-456/' "$missing_config_root/config.env"
ORCA_ROOT="$missing_config_root" ./bin/orca /goal "make this production ready" --pack release-ready >/dev/null
if ORCA_ROOT="$missing_config_root" ./bin/orca notion sync --all >/dev/null 2>&1; then
  fail "expected adapter sync without configured command to return non-zero"
fi
missing_config_outbox=$(/usr/bin/find "$missing_config_root/notion/outbox" -type f | wc -l | tr -d ' ')
[ "$missing_config_outbox" -gt 0 ] || fail "expected missing-config payloads to remain in outbox"

malformed_root="$tmp/adapter-malformed"
ORCA_ROOT="$malformed_root" ./bin/orca backend status >/dev/null
mkdir -p "$malformed_root/notion/outbox"
malformed_payload="$malformed_root/notion/outbox/bad.json"
printf '{bad json\n' > "$malformed_payload"
if ORCA_ROOT="$malformed_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion sync "$malformed_payload" >/dev/null 2>&1; then
  fail "expected malformed payload sync to return non-zero"
fi
[ -f "$malformed_payload" ] || fail "expected malformed payload to remain in outbox"

printf 'check-goal-smoke: ok\n'
