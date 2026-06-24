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
  RUBYOPT="${RUBYOPT:+$RUBYOPT }--disable-gems" ruby -rjson -e '
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
need_json_field "$tmp/plan-create.json" 'data.fetch("create").fetch("body").fetch("properties").fetch("Completed Date").fetch("date").fetch("start")' "$(date '+%Y-%m-%d')"
need_json_field "$tmp/plan-create.json" 'data.fetch("create").fetch("body").fetch("properties").key?("Last Updated Date")' "false"

active_payload="$tmp/active-payload.json"
RUBYOPT="${RUBYOPT:+$RUBYOPT }--disable-gems" ruby -rjson -e '
  data = JSON.parse(File.read(ARGV.fetch(0)))
  data.fetch("payload")["status"] = "In progress"
  File.write(ARGV.fetch(1), JSON.pretty_generate(data))
' -- "$payload" "$active_payload"
ORCA_NOTION_ADAPTER_DRY_RUN=1 ./scripts/orca-notion-sync-adapter.sh "$active_payload" > "$tmp/plan-create-active.json"
need_json_field "$tmp/plan-create-active.json" 'data.fetch("create").fetch("body").fetch("properties").fetch("Status").fetch("status").fetch("name")' "In progress"
need_json_field "$tmp/plan-create-active.json" 'data.fetch("create").fetch("body").fetch("properties").key?("Completed Date")' "false"
need_json_field "$tmp/plan-create-active.json" 'data.fetch("create").fetch("body").fetch("properties").key?("Last Updated Date")' "false"

ORCA_NOTION_ADAPTER_DRY_RUN=1 ORCA_NOTION_EXISTING_PAGE_ID=page-789 ./scripts/orca-notion-sync-adapter.sh "$payload" > "$tmp/plan-update.json"
need_json_field "$tmp/plan-update.json" 'data.fetch("action")' "update"
need_json_field "$tmp/plan-update.json" 'data.fetch("existing_page_id")' "page-789"
need_json_field "$tmp/plan-update.json" 'data.fetch("update").fetch("method")' "PATCH"
need_json_field "$tmp/plan-update.json" 'data.fetch("update").fetch("url")' "https://api.notion.com/v1/pages/page-789"
need_json_field "$tmp/plan-update.json" 'data.fetch("update").fetch("body").fetch("properties").fetch("Status").fetch("status").fetch("name")' "Done"
need_json_field "$tmp/plan-update.json" 'data.fetch("update").fetch("body").fetch("properties").key?("Completed Date")' "false"
need_json_field "$tmp/plan-update.json" 'data.fetch("update").fetch("body").fetch("properties").key?("Last Updated Date")' "false"

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

fake_bin="$tmp/fake-bin"
mkdir -p "$fake_bin"
cat > "$fake_bin/curl" <<'EOF'
#!/bin/sh
set -eu
out_file=
method=
url=
data_file=
while [ "$#" -gt 0 ]; do
  case "$1" in
    -o)
      out_file="$2"
      shift 2
      ;;
    -X)
      method="$2"
      shift 2
      ;;
    --data-binary)
      data_file="${2#@}"
      shift 2
      ;;
    -H|-w)
      shift 2
      ;;
    -sS)
      shift
      ;;
    http*)
      url="$1"
      shift
      ;;
    *)
      shift
      ;;
  esac
done
[ -n "$out_file" ] || exit 2
case "$url" in
  */data_sources/*/query)
    if [ -n "${FAKE_NOTION_COMPLETED_DATE:-}" ]; then
      completed_json='{"start":"'"$FAKE_NOTION_COMPLETED_DATE"'","end":null,"time_zone":null}'
    else
      completed_json='null'
    fi
    cat > "$out_file" <<JSON
{"results":[{"id":"page-existing","properties":{"Completed Date":{"type":"date","date":$completed_json}}}]}
JSON
    printf '200'
    ;;
  */pages/page-existing)
    if [ "$method" = "PATCH" ]; then
      cp "$data_file" "$FAKE_NOTION_PATCH_CAPTURE"
      printf '{"url":"https://notion.example/page-existing"}' > "$out_file"
      printf '200'
    else
      printf '{"id":"page-existing","properties":{"Completed Date":{"type":"date","date":null}}}' > "$out_file"
      printf '200'
    fi
    ;;
  *)
    printf '{"url":"https://notion.example/new"}' > "$out_file"
    printf '200'
    ;;
esac
EOF
chmod +x "$fake_bin/curl"

FAKE_NOTION_PATCH_CAPTURE="$tmp/patch-blank-completed-date.json" \
  PATH="$fake_bin:$PATH" \
  NOTION_TOKEN=test-token \
  ORCA_NOTION_COMPLETION_DATE=2026-06-24 \
  ./scripts/orca-notion-sync-adapter.sh "$payload" > "$tmp/live-update-blank.txt"
need_json_field "$tmp/patch-blank-completed-date.json" 'data.fetch("properties").fetch("Completed Date").fetch("date").fetch("start")' "2026-06-24"
need_json_field "$tmp/patch-blank-completed-date.json" 'data.fetch("properties").key?("Last Updated Date")' "false"

FAKE_NOTION_PATCH_CAPTURE="$tmp/patch-existing-completed-date.json" \
  FAKE_NOTION_COMPLETED_DATE=2026-06-20 \
  PATH="$fake_bin:$PATH" \
  NOTION_TOKEN=test-token \
  ORCA_NOTION_COMPLETION_DATE=2026-06-24 \
  ./scripts/orca-notion-sync-adapter.sh "$payload" > "$tmp/live-update-existing.txt"
need_json_field "$tmp/patch-existing-completed-date.json" 'data.fetch("properties").key?("Completed Date")' "false"
need_json_field "$tmp/patch-existing-completed-date.json" 'data.fetch("properties").key?("Last Updated Date")' "false"

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
