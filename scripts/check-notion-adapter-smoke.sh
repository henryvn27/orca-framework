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

payload="$tmp/payload.json"
./bin/orca notion payload --example > "$payload"
ruby -rjson -e '
  data = JSON.parse(File.read(ARGV.fetch(0)))
  data["issue_board_data_source_id"] = "collection://issue-board-123"
  File.write(ARGV.fetch(0), JSON.pretty_generate(data))
' "$payload"

ORCA_NOTION_ADAPTER_DRY_RUN=1 ./scripts/orca-notion-sync-adapter.sh "$payload" > "$tmp/request.json"
need_json_field "$tmp/request.json" 'data.fetch("parent").fetch("data_source_id")' "issue-board-123"
need_json_field "$tmp/request.json" 'data.fetch("properties").fetch("Issue").fetch("title").fetch(0).fetch("text").fetch("content")' "Run /goal loop for make this production ready"
need_json_field "$tmp/request.json" 'data.fetch("properties").fetch("Status").fetch("status").fetch("name")' "Done"

ORCA_NOTION_ADAPTER_DRY_RUN=1 ORCA_NOTION_TITLE_PROPERTY=Name ORCA_NOTION_STATUS_PROPERTY=State ./scripts/orca-notion-sync-adapter.sh "$payload" > "$tmp/custom-request.json"
need_json_field "$tmp/custom-request.json" 'data.fetch("properties").key?("Name")' "true"
need_json_field "$tmp/custom-request.json" 'data.fetch("properties").key?("State")' "true"

ORCA_NOTION_DATA_SOURCE_ID=override-456 ORCA_NOTION_ADAPTER_DRY_RUN=1 ./scripts/orca-notion-sync-adapter.sh "$payload" > "$tmp/override-request.json"
need_json_field "$tmp/override-request.json" 'data.fetch("parent").fetch("data_source_id")' "override-456"

if ORCA_NOTION_DATA_SOURCE_ID=override-456 NOTION_TOKEN= ./scripts/orca-notion-sync-adapter.sh "$payload" >/dev/null 2>&1; then
  fail "expected live adapter without token to fail"
fi

missing_id="$tmp/missing-id.json"
./bin/orca notion payload --example > "$missing_id"
if ORCA_NOTION_ADAPTER_DRY_RUN=1 ./scripts/orca-notion-sync-adapter.sh "$missing_id" >/dev/null 2>&1; then
  fail "expected missing issue board data source id to fail"
fi

bad="$tmp/bad.json"
printf '{bad json\n' > "$bad"
if ORCA_NOTION_ADAPTER_DRY_RUN=1 ./scripts/orca-notion-sync-adapter.sh "$bad" >/dev/null 2>&1; then
  fail "expected malformed payload to fail"
fi

printf 'check-notion-adapter-smoke: ok\n'
