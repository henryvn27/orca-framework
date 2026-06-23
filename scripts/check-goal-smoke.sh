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
  RUBYOPT="${RUBYOPT:+$RUBYOPT }--disable-gems" ruby -rjson -e '
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

packs_root="$tmp/packs-list"
ORCA_ROOT="$packs_root" ./bin/orca goal --packs > "$tmp/packs-list.txt"
need_grep "release-ready app-store-ready startup-mvp security performance notion-hygiene" "$tmp/packs-list.txt"
[ ! -e "$packs_root/state.env" ] || fail "goal --packs should not write state"

slash_packs_root="$tmp/slash-packs-list"
ORCA_ROOT="$slash_packs_root" ./bin/orca /goal --packs > "$tmp/slash-packs-list.txt"
need_grep "release-ready app-store-ready startup-mvp security performance notion-hygiene" "$tmp/slash-packs-list.txt"
[ ! -e "$slash_packs_root/state.env" ] || fail "/goal --packs should not write state"

packs_verbose_root="$tmp/packs-verbose"
ORCA_ROOT="$packs_verbose_root" ./bin/orca goal --packs --verbose > "$tmp/packs-verbose.txt"
need_grep "release-ready: test architecture code-hygiene docs-sync security pr-readiness" "$tmp/packs-verbose.txt"
need_grep "app-store-ready: test accessibility screenshots metadata purchases privacy pr-readiness" "$tmp/packs-verbose.txt"
need_grep "notion-hygiene: issue-board-sync docs-sync decisions handoffs stale-links pr-readiness" "$tmp/packs-verbose.txt"
[ ! -e "$packs_verbose_root/state.env" ] || fail "goal --packs --verbose should not write state"

slash_packs_verbose_root="$tmp/slash-packs-verbose"
ORCA_ROOT="$slash_packs_verbose_root" ./bin/orca /goal --packs --verbose > "$tmp/slash-packs-verbose.txt"
need_grep "security: secrets auth permissions dependency-audit threat-review handoff" "$tmp/slash-packs-verbose.txt"
[ ! -e "$slash_packs_verbose_root/state.env" ] || fail "/goal --packs --verbose should not write state"

plan_only_root="$tmp/plan-only"
run_goal "$plan_only_root" --plan-only > "$tmp/plan-only.txt"
need_grep "phase: plan" "$tmp/plan-only.txt"
need_grep "next: apply planned tasks, then run \`orca unify\`" "$tmp/plan-only.txt"
need_file "$plan_only_root/state.env"
need_file "$plan_only_root/runs/make-this-production-ready-plan.md"
need_grep "phase='plan'" "$plan_only_root/state.env"
need_grep "cycles_done='0'" "$plan_only_root/state.env"
need_grep "readiness_score='0'" "$plan_only_root/state.env"
[ ! -f "$plan_only_root/handoffs/make-this-production-ready.md" ] ||
  fail "plan-only should not create handoff"

until_blocked_root="$tmp/until-blocked"
run_goal "$until_blocked_root" --auto --max-cycles 1 --until blocked > "$tmp/until-blocked.txt"
assert_goal_artifacts "$until_blocked_root"
need_grep "auto: bounded, max_cycles=1, until=blocked" "$tmp/until-blocked.txt"
need_grep "until='blocked'" "$until_blocked_root/state.env"

if ORCA_ROOT="$tmp/bad-until" ./bin/orca /goal "make this production ready" --until forever > "$tmp/bad-until.txt" 2>&1; then
  fail "expected invalid --until value to return non-zero"
fi
need_grep "until must be blocked or done" "$tmp/bad-until.txt"

if ORCA_ROOT="$tmp/missing-pack" ./bin/orca /goal "make this production ready" --pack > "$tmp/missing-pack.txt" 2>&1; then
  fail "expected missing --pack value to return non-zero"
fi
need_grep "pack requires a value" "$tmp/missing-pack.txt"

if ORCA_ROOT="$tmp/missing-pack-next-option" ./bin/orca /goal "make this production ready" --pack --auto > "$tmp/missing-pack-next-option.txt" 2>&1; then
  fail "expected --pack followed by another option to return non-zero"
fi
need_grep "pack requires a value" "$tmp/missing-pack-next-option.txt"

if ORCA_ROOT="$tmp/missing-max-cycles" ./bin/orca /goal "make this production ready" --max-cycles > "$tmp/missing-max-cycles.txt" 2>&1; then
  fail "expected missing --max-cycles value to return non-zero"
fi
need_grep "max-cycles requires a value" "$tmp/missing-max-cycles.txt"

if ORCA_ROOT="$tmp/missing-max-cycles-next-option" ./bin/orca /goal "make this production ready" --max-cycles --until done > "$tmp/missing-max-cycles-next-option.txt" 2>&1; then
  fail "expected --max-cycles followed by another option to return non-zero"
fi
need_grep "max-cycles requires a value" "$tmp/missing-max-cycles-next-option.txt"

if ORCA_ROOT="$tmp/missing-until" ./bin/orca /goal "make this production ready" --until > "$tmp/missing-until.txt" 2>&1; then
  fail "expected missing --until value to return non-zero"
fi
need_grep "until requires a value" "$tmp/missing-until.txt"

if ORCA_ROOT="$tmp/missing-until-next-option" ./bin/orca /goal "make this production ready" --until --plan-only > "$tmp/missing-until-next-option.txt" 2>&1; then
  fail "expected --until followed by another option to return non-zero"
fi
need_grep "until requires a value" "$tmp/missing-until-next-option.txt"

if ORCA_ROOT="$tmp/bad-pack" ./bin/orca /goal "make this production ready" --pack release-reddy > "$tmp/bad-pack.txt" 2>&1; then
  fail "expected unknown --pack value to return non-zero"
fi
need_grep "unknown --pack: release-reddy" "$tmp/bad-pack.txt"
need_grep "valid packs: release-ready app-store-ready startup-mvp security performance notion-hygiene" "$tmp/bad-pack.txt"
[ ! -f "$tmp/bad-pack/state.env" ] || fail "invalid pack should not write state"

ORCA_ROOT="$fallback_root" ./bin/orca notion outbox > "$tmp/notion-outbox-fallback.txt"
need_grep "notion outbox: 0 payload(s)" "$tmp/notion-outbox-fallback.txt"
ORCA_ROOT="$fallback_root" ./bin/orca notion --help > "$tmp/notion-help.txt"
need_grep "orca notion handoff --issue TITLE \\[--status STATUS\\] \\[--note TEXT\\] \\[--json\\]" "$tmp/notion-help.txt"
ORCA_ROOT="$fallback_root" ./bin/orca notion help > "$tmp/notion-help-alias.txt"
need_grep "orca notion sync" "$tmp/notion-help-alias.txt"
ORCA_ROOT="$fallback_root" ./bin/orca backend --help > "$tmp/backend-help.txt"
need_grep "orca backend status" "$tmp/backend-help.txt"
ORCA_ROOT="$fallback_root" ./bin/orca backend help > "$tmp/backend-help-alias.txt"
need_grep "orca backend status" "$tmp/backend-help-alias.txt"
ORCA_ROOT="$fallback_root" ./bin/orca notion outbox --json > "$tmp/notion-outbox-fallback.json"
need_json_field "$tmp/notion-outbox-fallback.json" "outbox_count" "0"
need_json_field "$tmp/notion-outbox-fallback.json" "synced_count" "0"
need_json_field "$tmp/notion-outbox-fallback.json" "ok" "true"
ORCA_ROOT="$fallback_root" ./bin/orca notion sync --dry-run --json --all > "$tmp/notion-sync-empty-json.json"
need_json_field "$tmp/notion-sync-empty-json.json" "target" "--all"
need_json_field "$tmp/notion-sync-empty-json.json" "dry_run" "true"
need_json_field "$tmp/notion-sync-empty-json.json" "valid" "0"
need_json_field "$tmp/notion-sync-empty-json.json" "failed" "0"
need_json_field "$tmp/notion-sync-empty-json.json" "ok" "true"
fallback_outbox_before=$(/usr/bin/find "$fallback_root/notion/outbox" -type f 2>/dev/null | wc -l | tr -d ' ')
handoff_root="$tmp/notion-handoff"
handoff_payload=$(ORCA_ROOT="$handoff_root" ./bin/orca notion handoff --issue "Update Notion issue after PR merge" --status Done --note "Live Notion unavailable")
need_file "$handoff_payload"
need_json_field "$handoff_payload" "schema_version" "1"
need_json_field "$handoff_payload" "payload_type" "goal_event"
need_json_field "$handoff_payload" "action" "manual_handoff"
need_grep '"issue": "Update Notion issue after PR merge"' "$handoff_payload"
need_grep '"status": "Done"' "$handoff_payload"
need_grep '"note": "Live Notion unavailable"' "$handoff_payload"
ORCA_ROOT="$handoff_root" ./bin/orca notion payload --validate "$handoff_payload" > "$tmp/notion-handoff-validate.txt"
need_grep "notion-payload: valid $handoff_payload" "$tmp/notion-handoff-validate.txt"
ORCA_ROOT="$handoff_root" ./bin/orca notion outbox --json > "$tmp/notion-handoff-outbox.json"
need_json_field "$tmp/notion-handoff-outbox.json" "outbox_count" "1"
need_json_field "$tmp/notion-handoff-outbox.json" "ok" "true"
handoff_json_root="$tmp/notion-handoff-json"
ORCA_ROOT="$handoff_json_root" ./bin/orca notion handoff --json --issue "Update Notion issue after PR merge" --status Done --note "Live Notion unavailable" > "$tmp/notion-handoff-json.json"
need_json_field "$tmp/notion-handoff-json.json" "ok" "true"
need_json_field "$tmp/notion-handoff-json.json" "issue" "Update Notion issue after PR merge"
need_json_field "$tmp/notion-handoff-json.json" "status" "Done"
handoff_json_payload=$(RUBYOPT="${RUBYOPT:+$RUBYOPT }--disable-gems" ruby -rjson -e 'print JSON.parse(File.read(ARGV.fetch(0))).fetch("payload_path")' -- "$tmp/notion-handoff-json.json")
need_file "$handoff_json_payload"
need_json_field "$handoff_json_payload" "action" "manual_handoff"
if ORCA_ROOT="$tmp/notion-handoff-json-missing-issue" ./bin/orca notion handoff --json --status Done > "$tmp/notion-handoff-json-missing-issue.json" 2>&1; then
  fail "expected JSON notion handoff without --issue to fail"
fi
need_json_field "$tmp/notion-handoff-json-missing-issue.json" "ok" "false"
need_json_field "$tmp/notion-handoff-json-missing-issue.json" "error" "--issue is required"
for option in issue status note goal; do
  if ORCA_ROOT="$tmp/notion-handoff-json-missing-$option-value" ./bin/orca notion handoff "--$option" --json > "$tmp/notion-handoff-json-missing-$option-value.json" 2>&1; then
    fail "expected JSON notion handoff with --$option followed by --json to fail"
  fi
  need_json_field "$tmp/notion-handoff-json-missing-$option-value.json" "ok" "false"
  need_json_field "$tmp/notion-handoff-json-missing-$option-value.json" "error" "--$option requires a value"
done
if ORCA_ROOT="$tmp/notion-handoff-missing-issue" ./bin/orca notion handoff --status Done > "$tmp/notion-handoff-missing-issue.txt" 2>&1; then
  fail "expected notion handoff without --issue to fail"
fi
need_grep "issue is required" "$tmp/notion-handoff-missing-issue.txt"
ORCA_ROOT="$fallback_root" ./bin/orca notion payload --example > "$tmp/notion-payload-example.json"
need_json_field "$tmp/notion-payload-example.json" "schema_version" "1"
need_json_field "$tmp/notion-payload-example.json" "payload_type" "goal_event"
need_json_field "$tmp/notion-payload-example.json" "action" "goal_unified"
ORCA_ROOT="$fallback_root" ./bin/orca notion payload --validate "$tmp/notion-payload-example.json" > "$tmp/notion-payload-validate.txt"
need_grep "notion-payload: valid $tmp/notion-payload-example.json" "$tmp/notion-payload-validate.txt"
ORCA_ROOT="$fallback_root" ./bin/orca notion sync --dry-run --json "$tmp/notion-payload-example.json" > "$tmp/notion-sync-payload-json.json"
need_json_field "$tmp/notion-sync-payload-json.json" "target" "$tmp/notion-payload-example.json"
need_json_field "$tmp/notion-sync-payload-json.json" "dry_run" "true"
need_json_field "$tmp/notion-sync-payload-json.json" "valid" "1"
need_json_field "$tmp/notion-sync-payload-json.json" "failed" "0"
need_json_field "$tmp/notion-sync-payload-json.json" "ok" "true"
printf '{not json}\n' > "$tmp/notion-payload-malformed.json"
if ORCA_ROOT="$fallback_root" ./bin/orca notion sync --dry-run --json "$tmp/notion-payload-malformed.json" > "$tmp/notion-sync-malformed-json.json" 2> "$tmp/notion-sync-malformed-json.err"; then
  fail "expected malformed JSON sync dry-run to fail"
fi
need_json_field "$tmp/notion-sync-malformed-json.json" "target" "$tmp/notion-payload-malformed.json"
need_json_field "$tmp/notion-sync-malformed-json.json" "dry_run" "true"
need_json_field "$tmp/notion-sync-malformed-json.json" "valid" "0"
need_json_field "$tmp/notion-sync-malformed-json.json" "failed" "1"
need_json_field "$tmp/notion-sync-malformed-json.json" "ok" "false"
need_grep "Malformed Notion payload" "$tmp/notion-sync-malformed-json.err"
if ORCA_ROOT="$fallback_root" ./bin/orca notion payload --validate "$tmp/notion-payload-malformed.json" --json > "$tmp/notion-payload-malformed-validate.json" 2> "$tmp/notion-payload-malformed-validate.err"; then
  fail "expected malformed JSON payload validation to fail"
fi
need_json_field "$tmp/notion-payload-malformed-validate.json" "target" "$tmp/notion-payload-malformed.json"
need_json_field "$tmp/notion-payload-malformed-validate.json" "valid" "false"
need_json_field "$tmp/notion-payload-malformed-validate.json" "ok" "false"
need_grep "Malformed Notion payload" "$tmp/notion-payload-malformed-validate.err"
ORCA_ROOT="$fallback_root" ./bin/orca notion payload --validate "$tmp/notion-payload-example.json" --json > "$tmp/notion-payload-validate.json"
need_json_field "$tmp/notion-payload-validate.json" "target" "$tmp/notion-payload-example.json"
need_json_field "$tmp/notion-payload-validate.json" "valid" "true"
need_json_field "$tmp/notion-payload-validate.json" "ok" "true"
if ORCA_ROOT="$fallback_root" ./bin/orca notion payload --validate --json > "$tmp/notion-payload-missing-path.json" 2>&1; then
  fail "expected payload validation without PATH before --json to fail"
fi
need_json_field "$tmp/notion-payload-missing-path.json" "target" ""
need_json_field "$tmp/notion-payload-missing-path.json" "valid" "false"
need_json_field "$tmp/notion-payload-missing-path.json" "ok" "false"
need_json_field "$tmp/notion-payload-missing-path.json" "error" "PATH is required"
ORCA_ROOT="$fallback_root" ./bin/orca notion payload --example | ORCA_ROOT="$fallback_root" ./bin/orca notion payload --validate - --json > "$tmp/notion-payload-validate-stdin.json"
need_json_field "$tmp/notion-payload-validate-stdin.json" "target" "-"
need_json_field "$tmp/notion-payload-validate-stdin.json" "valid" "true"
need_json_field "$tmp/notion-payload-validate-stdin.json" "ok" "true"
if printf '{not json}\n' | ORCA_ROOT="$fallback_root" ./bin/orca notion payload --validate - --json > "$tmp/notion-payload-malformed-stdin.json" 2> "$tmp/notion-payload-malformed-stdin.err"; then
  fail "expected malformed stdin JSON payload validation to fail"
fi
need_json_field "$tmp/notion-payload-malformed-stdin.json" "target" "-"
need_json_field "$tmp/notion-payload-malformed-stdin.json" "valid" "false"
need_json_field "$tmp/notion-payload-malformed-stdin.json" "ok" "false"
need_grep "Malformed Notion payload" "$tmp/notion-payload-malformed-stdin.err"
adapter_fixture="scripts/fixtures/notion/goal-event-valid.json"
ORCA_ROOT="$fallback_root" ./bin/orca notion adapter --check "$adapter_fixture" > "$tmp/notion-adapter-check.txt"
need_grep "notion-adapter: action=create" "$tmp/notion-adapter-check.txt"
need_grep "notion-adapter: data_source_id=issue-board-123" "$tmp/notion-adapter-check.txt"
need_grep "notion-adapter: live_ready=false" "$tmp/notion-adapter-check.txt"
ORCA_ROOT="$fallback_root" ./bin/orca notion adapter --json-check "$adapter_fixture" > "$tmp/notion-adapter-json-check.json"
need_json_field "$tmp/notion-adapter-json-check.json" "action" "create"
need_json_field "$tmp/notion-adapter-json-check.json" "data_source_id" "issue-board-123"
need_json_field "$tmp/notion-adapter-json-check.json" "token_present" "false"
need_json_field "$tmp/notion-adapter-json-check.json" "live_ready" "false"
need_json_field "$tmp/notion-adapter-json-check.json" "ok" "true"
ORCA_ROOT="$fallback_root" ./bin/orca notion adapter --help > "$tmp/notion-adapter-help.txt"
need_grep "json-check validates payload shape and adapter plan readiness" "$tmp/notion-adapter-help.txt"
need_grep "doctor combines backend readiness, adapter readiness, and live sync readiness as top-level ok" "$tmp/notion-adapter-help.txt"
ORCA_ROOT="$fallback_root" ./bin/orca notion adapter --doctor "$adapter_fixture" > "$tmp/notion-adapter-doctor.json"
need_json_field "$tmp/notion-adapter-doctor.json" "ok" "false"
need_grep '"backend":{' "$tmp/notion-adapter-doctor.json"
need_grep '"adapter":{' "$tmp/notion-adapter-doctor.json"
need_grep '"notion_issue_board_configured":false' "$tmp/notion-adapter-doctor.json"
need_grep '"notion_sync_command_status":"missing"' "$tmp/notion-adapter-doctor.json"
need_grep '"token_present":false' "$tmp/notion-adapter-doctor.json"
need_grep '"live_ready":false' "$tmp/notion-adapter-doctor.json"
ORCA_ROOT="$fallback_root" ./bin/orca notion adapter --dry-run "$adapter_fixture" > "$tmp/notion-adapter-dry-run.json"
need_json_field "$tmp/notion-adapter-dry-run.json" "action" "create"
need_json_field "$tmp/notion-adapter-dry-run.json" "data_source_id" "issue-board-123"
ORCA_ROOT="$fallback_root" ./bin/orca notion sync --dry-run "$tmp/notion-payload-example.json" > "$tmp/notion-payload-example-dry-run.txt"
need_grep "notion-sync: dry-run valid=1 failed=0" "$tmp/notion-payload-example-dry-run.txt"
fallback_outbox_after=$(/usr/bin/find "$fallback_root/notion/outbox" -type f 2>/dev/null | wc -l | tr -d ' ')
[ "$fallback_outbox_after" -eq "$fallback_outbox_before" ] || fail "payload example/validate should not create outbox payloads"
ORCA_ROOT="$fallback_root" ./bin/orca backend status --json > "$tmp/backend-status-fallback.json"
need_json_field "$tmp/backend-status-fallback.json" "active_canonical" "markdown"
need_json_field "$tmp/backend-status-fallback.json" "notion_configured" "false"
need_json_field "$tmp/backend-status-fallback.json" "notion_status" "markdown_fallback"
need_json_field "$tmp/backend-status-fallback.json" "linear_configured" "false"
need_json_field "$tmp/backend-status-fallback.json" "ok" "true"
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
need_json_field "$tmp/notion-doctor-fallback.json" "ok" "false"
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
need_json_field "$tmp/backend-status-success.json" "ok" "true"
need_grep '"notion_configured":true' "$tmp/backend-status-success.json"
need_grep '"notion_sync_status":"outbox_mirror_only"' "$tmp/backend-status-success.json"
need_grep '"notion_outbox_count":0' "$tmp/backend-status-success.json"
ORCA_ROOT="$success_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca backend status --json > "$tmp/backend-status-success-env.json"
need_json_field "$tmp/backend-status-success-env.json" "active_canonical" "notion"
need_json_field "$tmp/backend-status-success-env.json" "notion_configured" "true"
need_json_field "$tmp/backend-status-success-env.json" "notion_sync_status" "executable"
need_json_field "$tmp/backend-status-success-env.json" "ok" "true"
need_grep '"notion_sync_status":"executable"' "$tmp/backend-status-success-env.json"
ORCA_ROOT="$success_root" ORCA_NOTION_SYNC_COMMAND='printf %s >/dev/null' ./bin/orca backend status --json > "$tmp/backend-status-shell-env.json"
need_json_field "$tmp/backend-status-shell-env.json" "active_canonical" "notion"
need_json_field "$tmp/backend-status-shell-env.json" "notion_configured" "true"
need_json_field "$tmp/backend-status-shell-env.json" "notion_sync_status" "configured_shell_command"
need_json_field "$tmp/backend-status-shell-env.json" "ok" "true"
need_grep '"notion_sync_status":"configured_shell_command"' "$tmp/backend-status-shell-env.json"
ORCA_ROOT="$success_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion doctor > "$tmp/notion-doctor-success.txt"
need_grep "notion issue board: configured" "$tmp/notion-doctor-success.txt"
need_grep "notion sync command: executable" "$tmp/notion-doctor-success.txt"
need_grep "notion outbox: 0 payload(s)" "$tmp/notion-doctor-success.txt"
ORCA_ROOT="$success_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion doctor --json > "$tmp/notion-doctor-success.json"
need_json_field "$tmp/notion-doctor-success.json" "notion_issue_board_configured" "true"
need_json_field "$tmp/notion-doctor-success.json" "notion_sync_command_status" "executable"
need_json_field "$tmp/notion-doctor-success.json" "ready" "true"
need_json_field "$tmp/notion-doctor-success.json" "ok" "true"
need_grep '"notion_issue_board_configured":true' "$tmp/notion-doctor-success.json"
need_grep '"notion_sync_command_status":"executable"' "$tmp/notion-doctor-success.json"
need_grep '"ready":true' "$tmp/notion-doctor-success.json"
ORCA_ROOT="$success_root" ORCA_NOTION_SYNC_COMMAND='printf %s >/dev/null' ./bin/orca notion doctor --json > "$tmp/notion-doctor-shell-env.json"
need_json_field "$tmp/notion-doctor-shell-env.json" "notion_issue_board_configured" "true"
need_json_field "$tmp/notion-doctor-shell-env.json" "notion_sync_command_status" "configured_shell_command"
need_json_field "$tmp/notion-doctor-shell-env.json" "ready" "true"
need_json_field "$tmp/notion-doctor-shell-env.json" "ok" "true"
need_grep '"notion_sync_command_status":"configured_shell_command"' "$tmp/notion-doctor-shell-env.json"
ORCA_ROOT="$success_root" ORCA_NOTION_SYNC_COMMAND="$sync_script" ./bin/orca notion adapter --doctor "$adapter_fixture" > "$tmp/notion-adapter-doctor-success.json"
need_json_field "$tmp/notion-adapter-doctor-success.json" "ok" "false"
need_grep '"backend":{' "$tmp/notion-adapter-doctor-success.json"
need_grep '"adapter":{' "$tmp/notion-adapter-doctor-success.json"
need_grep '"notion_issue_board_configured":true' "$tmp/notion-adapter-doctor-success.json"
need_grep '"notion_sync_command_status":"executable"' "$tmp/notion-adapter-doctor-success.json"
need_grep '"ready":true' "$tmp/notion-adapter-doctor-success.json"
need_grep '"token_present":false' "$tmp/notion-adapter-doctor-success.json"
need_grep '"live_ready":false' "$tmp/notion-adapter-doctor-success.json"
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
if ORCA_ROOT="$malformed_root" ./bin/orca notion adapter --doctor "$malformed_payload" > "$tmp/malformed-adapter-doctor.json" 2>/dev/null; then
  fail "expected malformed adapter doctor to return non-zero"
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
