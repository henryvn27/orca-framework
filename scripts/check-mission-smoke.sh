#!/usr/bin/env sh
set -eu

root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
orca="$root/bin/orca"
mission_test_dir=$(mktemp -d "${TMPDIR:-/tmp}/orca-mission.XXXXXX")
trap 'rm -rf "$mission_test_dir"' EXIT INT TERM HUP

fail() {
  printf 'check-mission-smoke: %s\n' "$1" >&2
  exit 1
}

cd "$mission_test_dir"
git init -q

if "$orca" mission create "Invalid contract" --criterion "   " > blank-criterion.out 2>&1; then
  fail "blank acceptance criterion was accepted"
fi
grep -q 'criteria cannot be blank' blank-criterion.out || fail "blank criterion error was not specific"

"$orca" mission create "Ship a trustworthy export" \
  --criterion "The export tests pass" \
  --criterion "The release notes explain the change" \
  --json > created.json

ruby -rjson -e '
  result = JSON.parse(File.read("created.json"))
  mission = result.fetch("mission")
  abort "create was not ok" unless result.fetch("ok")
  abort "wrong product" unless mission.fetch("product") == "orca_mission"
  abort "wrong initial state" unless mission.fetch("status") == "active"
  abort "wrong initial readiness" unless mission.dig("readiness", "percent") == 0
  abort "missing next action" unless mission.fetch("next_action").start_with?("Prove AC-1")
  abort "wrong criterion count" unless mission.fetch("criteria").length == 2
' || fail "create JSON contract failed"

[ -f .orca/active-mission ] || fail "active mission pointer was not written"
mission_id=$(cat .orca/active-mission)
[ -f ".orca/missions/$mission_id.json" ] || fail "durable mission state was not written"

if "$orca" mission complete > premature.out 2>&1; then
  fail "mission completed without evidence"
fi
grep -q 'evidence is still required for AC-1, AC-2' premature.out || fail "premature completion did not name missing evidence"

if "$orca" mission check AC-1 -- sh -c 'exit 7' > failed-check.out 2>&1; then
  fail "failing check satisfied a criterion"
fi
grep -q 'AC-1 check failed with exit 7' failed-check.out || fail "failed check did not report its exit code"

if "$orca" mission check AC-1 -- sh -c 'kill -TERM $$' > signaled-check.out 2>&1; then
  fail "terminated check satisfied a criterion"
fi
grep -q 'AC-1 check failed with exit 143' signaled-check.out || fail "terminated check did not report a shell-compatible exit code"

"$orca" mission status --json > after-failure.json
ruby -rjson -e '
  mission = JSON.parse(File.read("after-failure.json")).fetch("mission")
  criterion = mission.fetch("criteria").first
  failed = mission.fetch("events").last
  abort "failed criterion changed state" unless criterion.fetch("status") == "open"
  abort "terminated check was not recorded" unless failed.fetch("type") == "criterion_checked" && failed.fetch("exit_code") == 143
' || fail "failed-check state contract failed"

"$orca" mission check AC-1 -- sh -c 'printf "export-ok\n"' > successful-check.out
grep -q 'AC-1 satisfied by command' successful-check.out || fail "successful check was not reported"

"$orca" mission block "Waiting for the approved release note" --json > blocked.json
ruby -rjson -e '
  mission = JSON.parse(File.read("blocked.json")).fetch("mission")
  abort "mission was not blocked" unless mission.fetch("status") == "blocked"
  abort "wrong blocker count" unless mission.dig("readiness", "unresolved_blockers") == 1
  abort "wrong blocked next action" unless mission.fetch("next_action").start_with?("Resolve blocker:")
' || fail "blocked state contract failed"

if "$orca" mission satisfy AC-2 --evidence "should be rejected" > blocked-mutation.out 2>&1; then
  fail "blocked mission accepted criterion evidence"
fi
grep -q 'mission is blocked' blocked-mutation.out || fail "blocked mutation did not explain recovery"

"$orca" mission resume --json > resumed.json
"$orca" mission satisfy AC-2 --evidence "Documented in CHANGELOG.md" --json > satisfied.json
ruby -rjson -e '
  mission = JSON.parse(File.read("satisfied.json")).fetch("mission")
  readiness = mission.fetch("readiness")
  abort "mission is not fully ready" unless readiness.fetch("percent") == 100
  abort "mission should be completable" unless readiness.fetch("ready_to_complete")
  abort "missing completion next action" unless mission.fetch("next_action") == "Run `orca mission complete`."
' || fail "ready state contract failed"

"$orca" mission complete --json > completed.json
ruby -rjson -e '
  mission = JSON.parse(File.read("completed.json")).fetch("mission")
  abort "mission was not completed" unless mission.fetch("status") == "completed"
  abort "completion timestamp missing" if mission.fetch("completed_at").nil?
  abort "completed mission has wrong next action" unless mission.fetch("next_action") == "Mission complete."
' || fail "completion contract failed"

"$orca" mission create "Prepare the follow-up" --criterion "The follow-up is scoped" --json > second.json
if "$orca" mission create "Overwrite active work" --criterion "This must not happen" > overwrite.out 2>&1; then
  fail "unfinished active mission was overwritten"
fi
grep -q 'is still active' overwrite.out || fail "active mission collision was not explained"

"$orca" mission list --json > list.json
ruby -rjson -e '
  missions = JSON.parse(File.read("list.json")).fetch("missions")
  abort "mission history was not preserved" unless missions.length == 2
  abort "active mission was not identified" unless missions.count { |mission| mission.fetch("active") } == 1
  abort "completed mission missing" unless missions.any? { |mission| mission.fetch("status") == "completed" }
' || fail "mission history contract failed"

printf 'check-mission-smoke: ok\n'
