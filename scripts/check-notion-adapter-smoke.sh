#!/bin/sh
set -eu

root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
cd "$root"

fail() {
  printf 'check-notion-adapter-smoke: %s\n' "$1" >&2
  exit 1
}

need_json_field() {
  file="$1"
  ruby_expr="$2"
  expected="$3"
  ruby -rjson -e '
    data = JSON.parse(File.read(ARGV.fetch(0)))
    actual = eval(ARGV.fetch(1)).to_s
    expected = ARGV.fetch(2)
    abort("#{ARGV[1]} expected #{expected}, got #{actual}") unless actual == expected
  ' -- "$file" "$ruby_expr" "$expected" || fail "JSON field mismatch: $ruby_expr"
}

tmp="${TMPDIR:-/tmp}/orca-notion-adapter-smoke.$$"
trap 'rm -rf "$tmp"' EXIT INT TERM HUP
mkdir -p "$tmp"

fixture_dir="$root/scripts/fixtures/notion"
payload="$fixture_dir/goal-event-valid.json"
missing_id="$fixture_dir/goal-event-missing-data-source.json"
unsupported_schema="$fixture_dir/goal-event-unsupported-schema.json"
unsupported_type="$fixture_dir/goal-event-unsupported-type.json"

for fixture in "$payload" "$missing_id" "$unsupported_schema" "$unsupported_type"; do
  [ -f "$fixture" ] || fail "missing fixture: $fixture"
done

ORCA_NOTION_ADAPTER_DRY_RUN=1 ./scripts/orca-notion-sync-adapter.sh "$payload" > "$tmp/plan-create.json"
need_json_field "$tmp/plan-create.json" 'data.fetch("action")' "create"
need_json_field "$tmp/plan-create.json" 'data.fetch("data_source_id")' "issue-board-123"
need_json_field "$tmp/plan-create.json" 'data.fetch("match").fetch("property")' "Issue"
need_json_field "$tmp/plan-create.json" 'data.fetch("match").fetch("title")' "Run /goal loop for make this production ready"
need_json_field "$tmp/plan-create.json" 'data.fetch("match").fetch("query").fetch("filter").fetch("title").fetch("equals")' "Run /goal loop for make this production ready"
need_json_field "$tmp/plan-create.json" 'data.fetch("create").fetch("method")' "POST"
need_json_field "$tmp/plan-create.json" 'data.fetch("create").fetch("body").fetch("parent").fetch("data_source_id")' "issue-board-123"
need_json_field "$tmp/plan-create.json" 'data.fetch("create").fetch("body").fetch("properties").fetch("Issue").fetch("title").fetch(0).fetch("text").fetch("content")' "Run /goal loop for make this production ready"
need_json_field "$tmp/plan-create.json" 'data.fetch("create").fetch("body").fetch("properties").fetch("Status").fetch("status").fetch("name")' "Done"

ORCA_NOTION_ADAPTER_DRY_RUN=1 ORCA_NOTION_EXISTING_PAGE_ID=page-789 ./scripts/orca-notion-sync-adapter.sh "$payload" > "$tmp/plan-update.json"
need_json_field "$tmp/plan-update.json" 'data.fetch("action")' "update"
need_json_field "$tmp/plan-update.json" 'data.fetch("existing_page_id")' "page-789"
need_json_field "$tmp/plan-update.json" 'data.fetch("update").fetch("method")' "PATCH"
need_json_field "$tmp/plan-update.json" 'data.fetch("update").fetch("url")' "https://api.notion.com/v1/pages/page-789"
need_json_field "$tmp/plan-update.json" 'data.fetch("update").fetch("body").fetch("properties").fetch("Status").fetch("status").fetch("name")' "Done"

ORCA_NOTION_ADAPTER_DRY_RUN=1 ORCA_NOTION_TITLE_PROPERTY=Name ORCA_NOTION_STATUS_PROPERTY=State ./scripts/orca-notion-sync-adapter.sh "$payload" > "$tmp/custom-plan.json"
need_json_field "$tmp/custom-plan.json" 'data.fetch("create").fetch("body").fetch("properties").key?("Name")' "true"
need_json_field "$tmp/custom-plan.json" 'data.fetch("create").fetch("body").fetch("properties").key?("State")' "true"

ORCA_NOTION_DATA_SOURCE_ID=override-456 ORCA_NOTION_ADAPTER_DRY_RUN=1 ./scripts/orca-notion-sync-adapter.sh "$payload" > "$tmp/override-plan.json"
need_json_field "$tmp/override-plan.json" 'data.fetch("data_source_id")' "override-456"
need_json_field "$tmp/override-plan.json" 'data.fetch("create").fetch("body").fetch("parent").fetch("data_source_id")' "override-456"

ORCA_NOTION_ADAPTER_DRY_RUN=1 ./scripts/orca-notion-sync-adapter.sh --summary "$payload" > "$tmp/summary-no-token.txt"
grep -q "notion-adapter: action=create" "$tmp/summary-no-token.txt" || fail "summary missing action"
grep -q "notion-adapter: title=Run /goal loop for make this production ready" "$tmp/summary-no-token.txt" || fail "summary missing title"
grep -q "notion-adapter: data_source_id=issue-board-123" "$tmp/summary-no-token.txt" || fail "summary missing data source"
grep -q "notion-adapter: match_property=Issue" "$tmp/summary-no-token.txt" || fail "summary missing match property"
grep -q "notion-adapter: token_present=false" "$tmp/summary-no-token.txt" || fail "summary missing false token state"
grep -q "notion-adapter: live_ready=false" "$tmp/summary-no-token.txt" || fail "summary missing false live readiness"

NOTION_TOKEN=test-token ./scripts/orca-notion-sync-adapter.sh --summary "$payload" > "$tmp/summary-token.txt"
grep -q "notion-adapter: token_present=true" "$tmp/summary-token.txt" || fail "summary missing true token state"
grep -q "notion-adapter: live_ready=true" "$tmp/summary-token.txt" || fail "summary missing true live readiness"

./scripts/orca-notion-sync-adapter.sh --json-summary "$payload" > "$tmp/json-summary-no-token.json"
need_json_field "$tmp/json-summary-no-token.json" 'data.fetch("action")' "create"
need_json_field "$tmp/json-summary-no-token.json" 'data.fetch("title")' "Run /goal loop for make this production ready"
need_json_field "$tmp/json-summary-no-token.json" 'data.fetch("data_source_id")' "issue-board-123"
need_json_field "$tmp/json-summary-no-token.json" 'data.fetch("match_property")' "Issue"
need_json_field "$tmp/json-summary-no-token.json" 'data.fetch("token_present")' "false"
need_json_field "$tmp/json-summary-no-token.json" 'data.fetch("live_ready")' "false"
need_json_field "$tmp/json-summary-no-token.json" 'data.fetch("ok")' "true"

NOTION_TOKEN=test-token ./scripts/orca-notion-sync-adapter.sh --json-summary "$payload" > "$tmp/json-summary-token.json"
need_json_field "$tmp/json-summary-token.json" 'data.fetch("token_present")' "true"
need_json_field "$tmp/json-summary-token.json" 'data.fetch("live_ready")' "true"

if ORCA_NOTION_DATA_SOURCE_ID=override-456 NOTION_TOKEN= ./scripts/orca-notion-sync-adapter.sh "$payload" >/dev/null 2>&1; then
  fail "expected live adapter without token to fail"
fi

if ORCA_NOTION_ADAPTER_DRY_RUN=1 ./scripts/orca-notion-sync-adapter.sh "$missing_id" >/dev/null 2>&1; then
  fail "expected missing issue board data source id to fail"
fi

if ORCA_NOTION_ADAPTER_DRY_RUN=1 ./scripts/orca-notion-sync-adapter.sh "$unsupported_schema" >/dev/null 2>&1; then
  fail "expected unsupported schema fixture to fail"
fi

if ORCA_NOTION_ADAPTER_DRY_RUN=1 ./scripts/orca-notion-sync-adapter.sh "$unsupported_type" >/dev/null 2>&1; then
  fail "expected unsupported type fixture to fail"
fi

bad="$tmp/bad.json"
printf '{bad json\n' > "$bad"
if ORCA_NOTION_ADAPTER_DRY_RUN=1 ./scripts/orca-notion-sync-adapter.sh --summary "$bad" >/dev/null 2>&1; then
  fail "expected malformed payload summary to fail"
fi
if ORCA_NOTION_ADAPTER_DRY_RUN=1 ./scripts/orca-notion-sync-adapter.sh --json-summary "$bad" >/dev/null 2>&1; then
  fail "expected malformed payload JSON summary to fail"
fi
if ORCA_NOTION_ADAPTER_DRY_RUN=1 ./scripts/orca-notion-sync-adapter.sh "$bad" >/dev/null 2>&1; then
  fail "expected malformed payload to fail"
fi

printf 'check-notion-adapter-smoke: ok\n'
