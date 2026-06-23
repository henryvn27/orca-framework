#!/usr/bin/env sh
set -eu

usage() {
  cat <<'EOF'
Usage: orca-notion-sync-adapter.sh [--dry-run] PAYLOAD.json

Environment:
  NOTION_TOKEN                      Required outside dry-run.
  NOTION_VERSION                    Defaults to 2025-09-03.
  ORCA_NOTION_DATA_SOURCE_ID         Overrides payload issue_board_data_source_id.
  ORCA_NOTION_TITLE_PROPERTY         Defaults to Issue.
  ORCA_NOTION_STATUS_PROPERTY        Defaults to Status.
  ORCA_NOTION_ADAPTER_DRY_RUN=1      Print request JSON, no network.
EOF
}

dry_run="${ORCA_NOTION_ADAPTER_DRY_RUN:-0}"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run)
      dry_run=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --*)
      printf 'notion-adapter: unknown option: %s\n' "$1" >&2
      exit 2
      ;;
    *)
      break
      ;;
  esac
done

[ "$#" -eq 1 ] || {
  usage >&2
  exit 2
}

payload_file=$1
[ -f "$payload_file" ] || {
  printf 'notion-adapter: payload not found: %s\n' "$payload_file" >&2
  exit 1
}

command -v ruby >/dev/null 2>&1 || {
  printf 'notion-adapter: ruby is required for payload mapping\n' >&2
  exit 1
}

request_file=$(mktemp "${TMPDIR:-/tmp}/orca-notion-request.XXXXXX")
response_file=$(mktemp "${TMPDIR:-/tmp}/orca-notion-response.XXXXXX")
trap 'rm -f "$request_file" "$response_file"' EXIT INT TERM HUP

ruby -rjson - "$payload_file" "$request_file" <<'RUBY'
payload_path = ARGV.fetch(0)
request_path = ARGV.fetch(1)
payload = JSON.parse(File.read(payload_path))

abort("notion-adapter: unsupported schema_version") unless payload["schema_version"] == 1
abort("notion-adapter: unsupported payload_type") unless payload["payload_type"] == "goal_event"
abort("notion-adapter: payload must be an object") unless payload["payload"].is_a?(Hash)

data_source_id = ENV["ORCA_NOTION_DATA_SOURCE_ID"].to_s
data_source_id = payload["issue_board_data_source_id"].to_s if data_source_id.empty?
data_source_id = data_source_id.sub(/\Acollection:\/\//, "")
abort("notion-adapter: missing issue board data source id") if data_source_id.empty?

title_property = ENV.fetch("ORCA_NOTION_TITLE_PROPERTY", "Issue")
status_property = ENV.fetch("ORCA_NOTION_STATUS_PROPERTY", "Status")

body_payload = payload["payload"]
title = body_payload["issue"].to_s
title = payload["goal"].to_s if title.empty?
title = "#{payload["action"]} #{payload["goal_slug"]}".strip if title.empty?
abort("notion-adapter: missing issue title") if title.empty?

status = body_payload["status"].to_s
if status.empty?
  status = case payload["phase"].to_s
           when "handoff" then "Done"
           when "apply", "plan", "clarify" then "In progress"
           else "Not started"
           end
end

summary = [
  "Action: #{payload["action"]}",
  "Goal: #{payload["goal"]}",
  "Phase: #{payload["phase"]}",
  "Pack: #{payload["pack"]}",
  "Readiness: #{body_payload["readiness_score"]}",
  "Handoff: #{body_payload["handoff_path"]}"
].reject { |line| line.end_with?(": ") }

request = {
  "parent" => {"data_source_id" => data_source_id},
  "properties" => {
    title_property => {
      "title" => [{"type" => "text", "text" => {"content" => title[0, 2000]}}]
    },
    status_property => {
      "status" => {"name" => status}
    }
  },
  "children" => [
    {
      "object" => "block",
      "type" => "paragraph",
      "paragraph" => {
        "rich_text" => [
          {"type" => "text", "text" => {"content" => summary.join("\n")[0, 2000]}}
        ]
      }
    }
  ]
}

File.write(request_path, JSON.pretty_generate(request))
RUBY

if [ "$dry_run" = "1" ]; then
  cat "$request_file"
  exit 0
fi

token="${NOTION_TOKEN:-${ORCA_NOTION_TOKEN:-}}"
[ -n "$token" ] || {
  printf 'notion-adapter: NOTION_TOKEN is required outside dry-run\n' >&2
  exit 1
}

notion_version="${NOTION_VERSION:-2025-09-03}"
status=$(curl -sS -o "$response_file" -w '%{http_code}' \
  -X POST 'https://api.notion.com/v1/pages' \
  -H "Authorization: Bearer $token" \
  -H "Content-Type: application/json" \
  -H "Notion-Version: $notion_version" \
  --data-binary "@$request_file")

case "$status" in
  2??)
    ruby -rjson -e '
      data = JSON.parse(File.read(ARGV.fetch(0)))
      puts "notion-adapter: created #{data["url"] || data["id"] || "page"}"
    ' "$response_file"
    ;;
  *)
    printf 'notion-adapter: Notion API failed with HTTP %s\n' "$status" >&2
    cat "$response_file" >&2
    exit 1
    ;;
esac
