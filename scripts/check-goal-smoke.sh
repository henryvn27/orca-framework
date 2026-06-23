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

need_json_field() {
  file="$1"
  field="$2"
  expected="$3"
  command -v ruby >/dev/null 2>&1 || fail "ruby is required for JSON contract checks"
  ruby -rjson -e '
    data = JSON.parse(File.read(ARGV.fetch(0)))
    actual = data.fetch(ARGV.fetch(1)).to_s
    expected = ARGV.fetch(2)
    abort("#{ARGV[1]} expected #{expected}, got #{actual}") unless actual == expected
  ' -- "$file" "$field" "$expected" || fail "JSON field mismatch: $field in $file"
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
ORCA_ROOT="$fallback_root" ./bin/orca notion outbox > "$tmp/notion-outbox-fallback.txt"
need_grep "notion outbox: 0 payload(s)" "$tmp/notion-outbox-fallback.txt"
ORCA_ROOT="$fallback_root" ./bin/orca notion outbox --json > "$tmp/notion-outbox-fallback.json"
need_json_field "$tmp/notion-outbox-fallback.json" "outbox_count" "0"
need_json_field "$tmp/notion-outbox-fallback.json" "synced_count" "0"
ORCA_ROOT="$fallback_root" ./bin/orca backend status --json > "$tmp/backend-status-fallback.json"
need_json_field "$tmp/backend-status-fallback.json" "active_canonical" "markdown"
need_json_field "$tmp/backend-status-fallback.json" "notion_configured" "false"
need_json_field "$tmp/backend-status-fallback.json" "notion_status" "markdown_fallback"
need_json_field "$tmp/backend-status-fallback.json" "linear_configured" "false"
need_grep '"notion_configured":false' "$tmp/backend-status-fallback.json"
need_grep '"notion_status":"markdown_fallback"' "$tmp/backend-status-fallback.json"
need_grep '"linear_configured":false' "$tmp/backend-status-fallback.json"
ORCA_ROOT="$fallback_root" ./bin/orca notion doctor > "$tmp/notion-doctor-fallback.txt"
need_grep "notion issue board: missing" "$tmp/notion-doctor-fallback.txt"
need_grep "notion sync command: missing" "$tmp/notion-doctor-fallback.txt"
need_grep "linear: not configured, still optional" "$tmp/notion-doctor-fallback.txt"
ORCA_ROOT="$fallback_root" ./bin/orca notion doctor --json > "$tmp/notion-doctor-fallback.json"
need_json_field "$tmp/notion-doctor-fallback.json" "notion_issue_board_configured" "false"
need_json_field "$tmp/notion-doctor-fallback.json" "notion_sync_command_status" "missing"
need_json_field "$tmp/notion-doctor-fallback.json" "ready" "false"
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
ORCA_ROOT="$success_root" ./bin/orca backend status --json > "$tmp/backend-status-success.json"
need_json_field "$tmp/backend-status-success.json" "active_canonical" "notion"
need_json_field "$tmp/backend-status-success.json" "notion_configured" "true"
need_json_field "$tmp/backend-status-success.json" "notion_sync_status" "outbox_mirror_only"
need_json_field "$tmp/backend-status-success.json" "notion_outbox_count" "0"
need_grep '"notion_configured":true' "$tmp/backend-status-success.json"
need_grep '"notion_sync_status":"outbox_mirror_only"' "$tmp/backend-status-success.json"
need_grep '"notion_outbox_count":0' "$tmp/backend-status-success.json"
ORCA_ROOT="$success_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion doctor > "$tmp/notion-doctor-success.txt"
need_grep "notion issue board: configured" "$tmp/notion-doctor-success.txt"
need_grep "notion sync command: executable" "$tmp/notion-doctor-success.txt"
need_grep "notion outbox: 0 payload(s)" "$tmp/notion-doctor-success.txt"
ORCA_ROOT="$success_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion doctor --json > "$tmp/notion-doctor-success.json"
need_json_field "$tmp/notion-doctor-success.json" "notion_issue_board_configured" "true"
need_json_field "$tmp/notion-doctor-success.json" "notion_sync_command_status" "executable"
need_json_field "$tmp/notion-doctor-success.json" "ready" "true"
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
ORCA_ROOT="$adapter_root" ./bin/orca notion outbox > "$tmp/notion-outbox-adapter.txt"
need_grep "notion outbox: " "$tmp/notion-outbox-adapter.txt"
ORCA_ROOT="$adapter_root" ./bin/orca notion outbox --json > "$tmp/notion-outbox-adapter.json"
need_json_field "$tmp/notion-outbox-adapter.json" "outbox_count" "$adapter_outbox_before"
need_grep '"outbox":\[' "$tmp/notion-outbox-adapter.json"
first_adapter_payload=$(/usr/bin/find "$adapter_root/notion/outbox" -type f | head -1)
need_json_field "$first_adapter_payload" "schema_version" "1"
need_json_field "$first_adapter_payload" "payload_type" "goal_event"
ORCA_ROOT="$adapter_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion sync --dry-run "$first_adapter_payload" > "$tmp/adapter-dry-run-single.txt"
need_grep "notion-sync: dry-run valid=1 failed=0" "$tmp/adapter-dry-run-single.txt"
ORCA_ROOT="$adapter_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion sync --dry-run --json "$first_adapter_payload" > "$tmp/adapter-dry-run-single.json"
need_json_field "$tmp/adapter-dry-run-single.json" "dry_run" "true"
need_json_field "$tmp/adapter-dry-run-single.json" "target" "$first_adapter_payload"
need_json_field "$tmp/adapter-dry-run-single.json" "valid" "1"
need_json_field "$tmp/adapter-dry-run-single.json" "failed" "0"
need_json_field "$tmp/adapter-dry-run-single.json" "ok" "true"
[ ! -s "$adapter_log" ] || fail "dry-run single payload should not call adapter"
adapter_outbox_after_dry_single=$(/usr/bin/find "$adapter_root/notion/outbox" -type f | wc -l | tr -d ' ')
[ "$adapter_outbox_after_dry_single" -eq "$adapter_outbox_before" ] || fail "dry-run single payload should not move outbox payloads"
ORCA_ROOT="$adapter_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion sync --dry-run --all > "$tmp/adapter-dry-run-all.txt"
need_grep "notion-sync: dry-run valid=" "$tmp/adapter-dry-run-all.txt"
ORCA_ROOT="$adapter_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion sync --dry-run --json --all > "$tmp/adapter-dry-run-all.json"
need_json_field "$tmp/adapter-dry-run-all.json" "dry_run" "true"
need_json_field "$tmp/adapter-dry-run-all.json" "target" "--all"
need_json_field "$tmp/adapter-dry-run-all.json" "failed" "0"
need_json_field "$tmp/adapter-dry-run-all.json" "ok" "true"
[ ! -s "$adapter_log" ] || fail "dry-run all should not call adapter"
adapter_outbox_after_dry_all=$(/usr/bin/find "$adapter_root/notion/outbox" -type f | wc -l | tr -d ' ')
[ "$adapter_outbox_after_dry_all" -eq "$adapter_outbox_before" ] || fail "dry-run all should not move outbox payloads"
ORCA_ROOT="$adapter_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion sync --json --all > "$tmp/adapter-sync-all.json"
need_json_field "$tmp/adapter-sync-all.json" "dry_run" "false"
need_json_field "$tmp/adapter-sync-all.json" "target" "--all"
need_json_field "$tmp/adapter-sync-all.json" "failed" "0"
need_json_field "$tmp/adapter-sync-all.json" "ok" "true"
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
if ORCA_ROOT="$malformed_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion sync --dry-run "$malformed_payload" >/dev/null 2>&1; then
  fail "expected malformed dry-run sync to return non-zero"
fi
if ORCA_ROOT="$malformed_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion sync --dry-run --json "$malformed_payload" > "$tmp/malformed-dry-run.json" 2>/dev/null; then
  fail "expected malformed JSON dry-run sync to return non-zero"
fi
need_json_field "$tmp/malformed-dry-run.json" "dry_run" "true"
need_json_field "$tmp/malformed-dry-run.json" "failed" "1"
need_json_field "$tmp/malformed-dry-run.json" "ok" "false"
[ -f "$malformed_payload" ] || fail "expected malformed dry-run payload to remain in outbox"
if ORCA_ROOT="$malformed_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion sync "$malformed_payload" >/dev/null 2>&1; then
  fail "expected malformed payload sync to return non-zero"
fi
[ -f "$malformed_payload" ] || fail "expected malformed payload to remain in outbox"

missing_field_payload="$malformed_root/notion/outbox/missing-field.json"
cat > "$missing_field_payload" <<EOF
{
  "schema_version": 1,
  "payload_type": "goal_event",
  "action": "goal_unified",
  "canonical_backend": "notion",
  "phase": "handoff",
  "payload": {"ok": true},
  "updated_at": "2026-06-23T00:00:00Z"
}
EOF
if ORCA_ROOT="$malformed_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion sync --dry-run "$missing_field_payload" >/dev/null 2>&1; then
  fail "expected missing-field dry-run sync to return non-zero"
fi
[ -f "$missing_field_payload" ] || fail "expected missing-field payload to remain in outbox"

unsupported_schema_payload="$malformed_root/notion/outbox/unsupported-schema.json"
cat > "$unsupported_schema_payload" <<EOF
{
  "schema_version": 999,
  "payload_type": "goal_event",
  "action": "goal_unified",
  "canonical_backend": "notion",
  "goal_slug": "make-this-production-ready",
  "phase": "handoff",
  "payload": {"ok": true},
  "updated_at": "2026-06-23T00:00:00Z"
}
EOF
if ORCA_ROOT="$malformed_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion sync --dry-run "$unsupported_schema_payload" >/dev/null 2>&1; then
  fail "expected unsupported-schema dry-run sync to return non-zero"
fi
[ -f "$unsupported_schema_payload" ] || fail "expected unsupported-schema payload to remain in outbox"

unsupported_type_payload="$malformed_root/notion/outbox/unsupported-type.json"
cat > "$unsupported_type_payload" <<EOF
{
  "schema_version": 1,
  "payload_type": "unknown",
  "action": "goal_unified",
  "canonical_backend": "notion",
  "goal_slug": "make-this-production-ready",
  "phase": "handoff",
  "payload": {"ok": true},
  "updated_at": "2026-06-23T00:00:00Z"
}
EOF
if ORCA_ROOT="$malformed_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion sync --dry-run "$unsupported_type_payload" >/dev/null 2>&1; then
  fail "expected unsupported-type dry-run sync to return non-zero"
fi
[ -f "$unsupported_type_payload" ] || fail "expected unsupported-type payload to remain in outbox"

printf 'check-goal-smoke: ok\n'
