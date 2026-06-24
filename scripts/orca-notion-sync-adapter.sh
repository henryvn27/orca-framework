#!/usr/bin/env sh
set -eu

usage() {
  cat <<'EOF'
Usage: orca-notion-sync-adapter.sh [--dry-run] [--summary] [--json-summary] PAYLOAD.json

Environment:
  NOTION_TOKEN                      Required outside dry-run.
  NOTION_VERSION                    Defaults to 2026-03-11.
  ORCA_NOTION_DATA_SOURCE_ID         Overrides payload issue_board_data_source_id.
  ORCA_NOTION_TITLE_PROPERTY         Defaults to Issue.
  ORCA_NOTION_STATUS_PROPERTY        Defaults to Status.
  ORCA_NOTION_COMPLETED_DATE_PROPERTY Defaults to Completed Date.
  ORCA_NOTION_MATCH_PROPERTY         Defaults to title property.
  ORCA_NOTION_EXISTING_PAGE_ID       Dry-run/live override to force update path.
  ORCA_NOTION_COMPLETION_DATE        Optional YYYY-MM-DD override for tests/backfills.
  ORCA_NOTION_ADAPTER_DRY_RUN=1      Print request plan JSON, no network.
EOF
}

dry_run="${ORCA_NOTION_ADAPTER_DRY_RUN:-0}"
summary=0
json_summary=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run)
      dry_run=1
      shift
      ;;
    --summary|--check)
      summary=1
      dry_run=1
      shift
      ;;
    --json-summary|--json-check)
      json_summary=1
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

ruby_json() {
  RUBYOPT="${RUBYOPT:+$RUBYOPT }--disable-gems" ruby -rjson "$@"
}

plan_file=$(mktemp "${TMPDIR:-/tmp}/orca-notion-plan.XXXXXX")
query_file=$(mktemp "${TMPDIR:-/tmp}/orca-notion-query.XXXXXX")
create_file=$(mktemp "${TMPDIR:-/tmp}/orca-notion-create.XXXXXX")
update_file=$(mktemp "${TMPDIR:-/tmp}/orca-notion-update.XXXXXX")
response_file=$(mktemp "${TMPDIR:-/tmp}/orca-notion-response.XXXXXX")
trap 'rm -f "$plan_file" "$query_file" "$create_file" "$update_file" "$response_file"' EXIT INT TERM HUP

ruby_json - "$payload_file" "$plan_file" "$query_file" "$create_file" "$update_file" <<'RUBY'
require "date"
payload_path, plan_path, query_path, create_path, update_path = ARGV
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
completed_date_property = ENV.fetch("ORCA_NOTION_COMPLETED_DATE_PROPERTY", "Completed Date")
match_property = ENV.fetch("ORCA_NOTION_MATCH_PROPERTY", title_property)
existing_page_id = ENV["ORCA_NOTION_EXISTING_PAGE_ID"].to_s
completion_date = ENV.fetch("ORCA_NOTION_COMPLETION_DATE", Date.today.iso8601)
abort("notion-adapter: ORCA_NOTION_COMPLETION_DATE must be YYYY-MM-DD") unless completion_date.match?(/\A\d{4}-\d{2}-\d{2}\z/)

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

properties = {
  title_property => {
    "title" => [{"type" => "text", "text" => {"content" => title[0, 2000]}}]
  },
  status_property => {
    "status" => {"name" => status}
  }
}

create_properties = Marshal.load(Marshal.dump(properties))
if status == "Done"
  create_properties[completed_date_property] = {"date" => {"start" => completion_date}}
end

query = {
  "page_size" => 1,
  "filter" => {
    "property" => match_property,
    "title" => {"equals" => title}
  }
}

create = {
  "parent" => {"data_source_id" => data_source_id},
  "properties" => create_properties,
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

update = {"properties" => properties}
action = existing_page_id.empty? ? "create" : "update"

plan = {
  "action" => action,
  "data_source_id" => data_source_id,
  "match" => {
    "property" => match_property,
    "title" => title,
    "query" => query
  },
  "existing_page_id" => existing_page_id,
  "completed_date" => {
    "property" => completed_date_property,
    "completion_date" => completion_date,
    "set_on_create_when_done" => status == "Done",
    "set_on_update_when_done_and_blank" => status == "Done",
    "dry_run_existing_page_note" => "Existing-page updates add Completed Date only after live page/query evidence shows it is blank.",
    "last_updated_date" => "read-only; never written"
  },
  "create" => {
    "method" => "POST",
    "url" => "https://api.notion.com/v1/pages",
    "body" => create
  },
  "update" => {
    "method" => "PATCH",
    "url" => existing_page_id.empty? ? "" : "https://api.notion.com/v1/pages/#{existing_page_id}",
    "body" => update
  }
}

File.write(plan_path, JSON.pretty_generate(plan))
File.write(query_path, JSON.generate(query))
File.write(create_path, JSON.generate(create))
File.write(update_path, JSON.generate(update))
RUBY

if [ "$dry_run" = "1" ]; then
  if [ "$json_summary" -eq 1 ]; then
    ruby_json - "$plan_file" <<'RUBY'
plan = JSON.parse(File.read(ARGV.fetch(0)))
token_present = !ENV.fetch("NOTION_TOKEN", ENV.fetch("ORCA_NOTION_TOKEN", "")).empty?
summary = {
  "action" => plan.fetch("action"),
  "title" => plan.fetch("match").fetch("title"),
  "data_source_id" => plan.fetch("data_source_id"),
  "match_property" => plan.fetch("match").fetch("property"),
  "token_present" => token_present,
  "live_ready" => token_present,
  "ok" => true
}
puts JSON.generate(summary)
RUBY
  elif [ "$summary" -eq 1 ]; then
    ruby_json - "$plan_file" <<'RUBY'
plan = JSON.parse(File.read(ARGV.fetch(0)))
token_present = !ENV.fetch("NOTION_TOKEN", ENV.fetch("ORCA_NOTION_TOKEN", "")).empty?
puts "notion-adapter: action=#{plan.fetch("action")}"
puts "notion-adapter: title=#{plan.fetch("match").fetch("title")}"
puts "notion-adapter: data_source_id=#{plan.fetch("data_source_id")}"
puts "notion-adapter: match_property=#{plan.fetch("match").fetch("property")}"
puts "notion-adapter: token_present=#{token_present}"
puts "notion-adapter: live_ready=#{token_present}"
RUBY
  else
    cat "$plan_file"
  fi
  exit 0
fi

token="${NOTION_TOKEN:-${ORCA_NOTION_TOKEN:-}}"
[ -n "$token" ] || {
  printf 'notion-adapter: NOTION_TOKEN is required outside dry-run\n' >&2
  exit 1
}

notion_version="${NOTION_VERSION:-2026-03-11}"
data_source_id=$(ruby_json -e 'puts JSON.parse(File.read(ARGV.fetch(0))).fetch("data_source_id")' "$plan_file")
existing_page_id="${ORCA_NOTION_EXISTING_PAGE_ID:-}"
existing_completed_date=

if [ -z "$existing_page_id" ]; then
  query_status=$(curl -sS -o "$response_file" -w '%{http_code}' \
    -X POST "https://api.notion.com/v1/data_sources/$data_source_id/query" \
    -H "Authorization: Bearer $token" \
    -H "Content-Type: application/json" \
    -H "Notion-Version: $notion_version" \
    --data-binary "@$query_file")
  case "$query_status" in
    2??)
      existing_page_id=$(ruby_json -e '
        data = JSON.parse(File.read(ARGV.fetch(0)))
        result = data.fetch("results", []).first
        puts(result ? result["id"].to_s : "")
      ' "$response_file")
      if [ -n "$existing_page_id" ]; then
        existing_completed_date=$(ruby_json -e '
          data = JSON.parse(File.read(ARGV.fetch(0)))
          completed_property = JSON.parse(File.read(ARGV.fetch(1))).fetch("completed_date").fetch("property")
          result = data.fetch("results", []).first
          puts result.fetch("properties", {}).fetch(completed_property, {}).fetch("date", {})&.fetch("start", nil).to_s
        ' "$response_file" "$plan_file")
      fi
      ;;
    *)
      printf 'notion-adapter: Notion query failed with HTTP %s\n' "$query_status" >&2
      cat "$response_file" >&2
      exit 1
      ;;
  esac
elif [ -n "$existing_page_id" ]; then
  page_status=$(curl -sS -o "$response_file" -w '%{http_code}' \
    -X GET "https://api.notion.com/v1/pages/$existing_page_id" \
    -H "Authorization: Bearer $token" \
    -H "Content-Type: application/json" \
    -H "Notion-Version: $notion_version")
  case "$page_status" in
    2??)
      existing_completed_date=$(ruby_json -e '
        data = JSON.parse(File.read(ARGV.fetch(0)))
        completed_property = JSON.parse(File.read(ARGV.fetch(1))).fetch("completed_date").fetch("property")
        puts data.fetch("properties", {}).fetch(completed_property, {}).fetch("date", {})&.fetch("start", nil).to_s
      ' "$response_file" "$plan_file")
      ;;
    *)
      printf 'notion-adapter: Notion page fetch failed with HTTP %s\n' "$page_status" >&2
      cat "$response_file" >&2
      exit 1
      ;;
  esac
fi

if [ -n "$existing_page_id" ]; then
  ORCA_EXISTING_COMPLETED_DATE="$existing_completed_date" ruby_json - "$plan_file" "$update_file" <<'RUBY'
plan_path, update_path = ARGV
plan = JSON.parse(File.read(plan_path))
body = plan.fetch("update").fetch("body")
completed = plan.fetch("completed_date")
existing_completed_date = ENV.fetch("ORCA_EXISTING_COMPLETED_DATE", "")
if completed.fetch("set_on_update_when_done_and_blank") && existing_completed_date.empty?
  body.fetch("properties")[completed.fetch("property")] = {
    "date" => {"start" => completed.fetch("completion_date")}
  }
end
File.write(update_path, JSON.generate(body))
RUBY
  status=$(curl -sS -o "$response_file" -w '%{http_code}' \
    -X PATCH "https://api.notion.com/v1/pages/$existing_page_id" \
    -H "Authorization: Bearer $token" \
    -H "Content-Type: application/json" \
    -H "Notion-Version: $notion_version" \
    --data-binary "@$update_file")
  verb=updated
else
  status=$(curl -sS -o "$response_file" -w '%{http_code}' \
    -X POST 'https://api.notion.com/v1/pages' \
    -H "Authorization: Bearer $token" \
    -H "Content-Type: application/json" \
    -H "Notion-Version: $notion_version" \
    --data-binary "@$create_file")
  verb=created
fi

case "$status" in
  2??)
    ruby_json -e '
      verb = ARGV.fetch(1)
      data = JSON.parse(File.read(ARGV.fetch(0)))
      puts "notion-adapter: #{verb} #{data["url"] || data["id"] || "page"}"
    ' "$response_file" "$verb"
    ;;
  *)
    printf 'notion-adapter: Notion write failed with HTTP %s\n' "$status" >&2
    cat "$response_file" >&2
    exit 1
    ;;
esac
