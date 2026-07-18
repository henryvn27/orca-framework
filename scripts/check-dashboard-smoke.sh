#!/usr/bin/env sh
set -eu

root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
dashboard_test_dir=$(mktemp -d "${TMPDIR:-/tmp}/orca-dashboard.XXXXXX")
server_pid=""

cleanup() {
  if [ -n "$server_pid" ]; then
    kill "$server_pid" 2>/dev/null || true
    wait "$server_pid" 2>/dev/null || true
  fi
  rm -rf "$dashboard_test_dir"
}
trap cleanup EXIT INT TERM HUP

fail() {
  printf 'check-dashboard-smoke: %s\n' "$1" >&2
  [ -f "$dashboard_test_dir/server.log" ] && tail -n 40 "$dashboard_test_dir/server.log" >&2
  exit 1
}

project="$dashboard_test_dir/project"
state_root="$dashboard_test_dir/state"
mkdir -p "$project"
cd "$project"
git init -q

ORCA_ROOT="$state_root" ORCA_DASHBOARD_TOKEN="dashboard-smoke-token" \
  "$root/bin/orca" dashboard --project "$project" --port 0 --no-open \
  > "$dashboard_test_dir/server.log" 2>&1 &
server_pid=$!

attempt=0
origin=""
while [ "$attempt" -lt 80 ]; do
  origin=$(sed -n 's/^Orca Mission Control: //p' "$dashboard_test_dir/server.log" | head -n 1)
  [ -n "$origin" ] && break
  kill -0 "$server_pid" 2>/dev/null || fail "server exited before announcing its URL"
  attempt=$((attempt + 1))
  sleep 0.05
done
[ -n "$origin" ] || fail "server did not announce its URL"

curl -fsS -D "$dashboard_test_dir/index.headers" "$origin/" -o "$dashboard_test_dir/index.html" || fail "dashboard HTML was not served"
grep -q '<title>Orca Mission Control</title>' "$dashboard_test_dir/index.html" || fail "dashboard HTML is incomplete"
grep -q 'dashboard-smoke-token' "$dashboard_test_dir/index.html" || fail "dashboard session token was not delivered"
grep -qi '^Content-Security-Policy: ' "$dashboard_test_dir/index.headers" || fail "dashboard CSP is missing"
grep -qi "frame-ancestors 'none'" "$dashboard_test_dir/index.headers" || fail "dashboard CSP does not prevent framing"
curl -fsS "$origin/orca.css" -o "$dashboard_test_dir/orca.css" || fail "dashboard CSS was not served"
curl -fsS "$origin/orca.js" -o "$dashboard_test_dir/orca.js" || fail "dashboard JavaScript was not served"

curl -fsS "$origin/api/state" -o "$dashboard_test_dir/empty.json" || fail "empty dashboard state failed"
ruby -rjson -e '
  payload = JSON.parse(File.read(ARGV.fetch(0)))
  abort "empty state was not ok" unless payload.fetch("ok")
  abort "empty state unexpectedly has a mission" unless payload.fetch("current").nil?
  abort "project path changed" unless File.realpath(payload.fetch("project")) == File.realpath(ARGV.fetch(1))
' "$dashboard_test_dir/empty.json" "$project" || fail "empty dashboard contract failed"

post() {
  name="$1"
  payload="$2"
  curl -fsS \
    -H 'Content-Type: application/json' \
    -H 'X-Orca-Token: dashboard-smoke-token' \
    -H "Origin: $origin" \
    --data "$payload" \
    "$origin/api/action" \
    -o "$dashboard_test_dir/$name.json"
}

missing_status=$(curl -sS -o "$dashboard_test_dir/missing-token.json" -w '%{http_code}' \
  -H 'Content-Type: application/json' -H "Origin: $origin" \
  --data '{"action":"create","outcome":"Forbidden","criteria":["Must not exist"]}' "$origin/api/action")
[ "$missing_status" = "403" ] || fail "missing token was not rejected with 403"

origin_status=$(curl -sS -o "$dashboard_test_dir/wrong-origin.json" -w '%{http_code}' \
  -H 'Content-Type: application/json' -H 'X-Orca-Token: dashboard-smoke-token' -H 'Origin: https://example.invalid' \
  --data '{"action":"create","outcome":"Forbidden","criteria":["Must not exist"]}' "$origin/api/action")
[ "$origin_status" = "403" ] || fail "cross-origin mutation was not rejected with 403"

post created '{"action":"create","outcome":"Ship from Mission Control","criteria":["The runtime check passes"],"actor":"Dashboard tester"}'
mission_id=$(ruby -rjson -e 'puts JSON.parse(File.read(ARGV.fetch(0))).fetch("mission").fetch("id")' "$dashboard_test_dir/created.json")
post added '{"action":"add","criterion":"The release proof is recorded","actor":"Dashboard tester"}'
post checked '{"action":"check","criterion_id":"AC-1","command":["ruby","-e","exit 0"],"actor":"Dashboard tester"}'
post satisfied '{"action":"satisfy","criterion_id":"AC-2","evidence":"Release proof inspected","actor":"Dashboard tester"}'
post reset '{"action":"reset","criterion_id":"AC-2","reason":"Proof was superseded","actor":"Dashboard tester"}'
post resatisfied '{"action":"satisfy","criterion_id":"AC-2","evidence":"Replacement proof inspected","actor":"Dashboard tester"}'
post note '{"action":"note","summary":"All dashboard transitions are attributable","actor":"Dashboard tester"}'
post blocked '{"action":"block","reason":"Waiting for final authorization","actor":"Dashboard tester"}'

blocked_status=$(curl -sS -o "$dashboard_test_dir/blocked-mutation.json" -w '%{http_code}' \
  -H 'Content-Type: application/json' -H 'X-Orca-Token: dashboard-smoke-token' -H "Origin: $origin" \
  --data '{"action":"satisfy","criterion_id":"AC-1","evidence":"Must fail","actor":"Dashboard tester"}' "$origin/api/action")
[ "$blocked_status" = "422" ] || fail "blocked mission accepted a dashboard mutation"

post resumed '{"action":"resume","reason":"Final authorization received","actor":"Dashboard tester"}'
post completed '{"action":"complete","actor":"Dashboard tester"}'
post second-created '{"action":"create","outcome":"Exercise cancellation","criteria":["The cancellation path is safe"],"actor":"Dashboard tester"}'
second_id=$(ruby -rjson -e 'puts JSON.parse(File.read(ARGV.fetch(0))).fetch("mission").fetch("id")' "$dashboard_test_dir/second-created.json")
post canceled '{"action":"cancel","reason":"Cancellation path verified","actor":"Dashboard tester"}'
post reopened "{\"action\":\"reopen\",\"mission_id\":\"$second_id\",\"reason\":\"Verify reopening\",\"actor\":\"Dashboard tester\"}"
post second-satisfied '{"action":"satisfy","criterion_id":"AC-1","evidence":"Cancellation and reopen verified","actor":"Dashboard tester"}'
post second-completed '{"action":"complete","actor":"Dashboard tester"}'

curl -fsS "$origin/api/state?mission=$mission_id" -o "$dashboard_test_dir/history.json" || fail "historical dashboard state failed"
ruby -rjson -e '
  completed = JSON.parse(File.read(ARGV.fetch(0))).fetch("mission")
  history = JSON.parse(File.read(ARGV.fetch(1)))
  current = history.fetch("current")
  abort "first mission did not complete" unless completed.fetch("status") == "completed"
  abort "historical lookup returned the wrong mission" unless current.fetch("id") == ARGV.fetch(2)
  abort "historical mission lost evidence" unless current.fetch("readiness").fetch("percent") == 100
  abort "history did not retain both missions" unless history.fetch("missions").length == 2
  abort "dashboard actor missing" unless current.fetch("events").all? { |event| !event.fetch("actor").empty? }
' "$dashboard_test_dir/completed.json" "$dashboard_test_dir/history.json" "$mission_id" || fail "dashboard lifecycle contract failed"

printf 'check-dashboard-smoke: ok\n'
