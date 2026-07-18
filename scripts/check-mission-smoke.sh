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
  --by "Release captain" \
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
  abort "creator was not attributed" unless mission.fetch("events").first.fetch("actor") == "Release captain"
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

second_id=$(cat .orca/active-mission)
"$orca" mission show "$mission_id" --json > historical.json
ruby -rjson -e '
  mission = JSON.parse(File.read("historical.json")).fetch("mission")
  abort "historical lookup returned the wrong mission" unless mission.fetch("id") == ARGV.fetch(0)
  abort "historical mission lost completion" unless mission.fetch("status") == "completed"
' "$mission_id" || fail "historical mission lookup failed"

if "$orca" mission reopen "$mission_id" --reason "Confirm a late requirement" > reopen-conflict.out 2>&1; then
  fail "completed mission was reopened over active work"
fi
grep -q 'complete or cancel it before reopening another' reopen-conflict.out || fail "reopen collision was not explained"

"$orca" mission add --criterion "The follow-up owner is recorded" --by "Ops lead" --json > added.json
"$orca" mission satisfy AC-1 --evidence "Scope accepted in review" --by "Reviewer" --json > second-satisfied.json
"$orca" mission reset AC-1 --reason "The scope changed after review" --by "Ops lead" --json > reset.json
"$orca" mission satisfy AC-1 --evidence "Updated scope accepted" --by "Reviewer" --json > second-resatisfied.json
"$orca" mission satisfy AC-2 --evidence "Owned by Ops lead" --by "Ops lead" --json > second-ready.json
"$orca" mission note "Handoff includes the updated scope" --by "Ops lead" --json > noted.json
"$orca" mission validate --json > validated.json
"$orca" mission events --json > events.json
ruby -rjson -e '
  added = JSON.parse(File.read("added.json")).fetch("mission")
  reset = JSON.parse(File.read("reset.json")).fetch("mission")
  ready = JSON.parse(File.read("second-ready.json")).fetch("mission")
  noted = JSON.parse(File.read("noted.json")).fetch("mission")
  validation = JSON.parse(File.read("validated.json"))
  events = JSON.parse(File.read("events.json")).fetch("events")
  abort "criterion was not added" unless added.fetch("criteria").last.fetch("id") == "AC-2"
  abort "criterion reset retained stale evidence" unless reset.fetch("criteria").first.fetch("evidence").empty?
  abort "replacement evidence was not attributed" unless ready.fetch("criteria").first.fetch("evidence").last.fetch("actor") == "Reviewer"
  abort "note was not attributed" unless noted.fetch("notes").last.fetch("actor") == "Ops lead"
  abort "validation did not confirm the schema" unless validation.fetch("valid") && validation.fetch("schema_version") == "1.0.0"
  abort "reset event missing" unless events.any? { |event| event.fetch("type") == "criterion_reset" }
  abort "note event missing" unless events.any? { |event| event.fetch("type") == "note_added" }
' || fail "expanded lifecycle contract failed"

"$orca" mission export "$second_id" --output active-export.json --json > active-export-result.json
if "$orca" mission export "$second_id" --output active-export.json > export-overwrite.out 2>&1; then
  fail "export replaced an existing file without --force"
fi
grep -q 'use --force to replace it' export-overwrite.out || fail "export overwrite guard was not explained"
"$orca" mission export "$second_id" --output active-export.json --force > /dev/null

"$orca" mission cancel "Superseded by the original release mission" --by "Ops lead" --json > canceled.json
ruby -rjson -e '
  mission = JSON.parse(File.read("canceled.json")).fetch("mission")
  abort "mission was not canceled" unless mission.fetch("status") == "canceled"
  abort "cancel timestamp missing" if mission.fetch("canceled_at").nil?
  abort "canceled next action is wrong" unless mission.fetch("next_action") == "Mission canceled."
' || fail "cancel contract failed"

"$orca" mission reopen "$mission_id" --reason "Late release portability proof" --by "Release captain" --json > reopened.json
"$orca" mission add --criterion "The mission can move between machines" --by "Release captain" --json > reopened-added.json
"$orca" mission reset AC-2 --reason "Release notes changed for 1.0" --by "Release captain" --json > reopened-reset.json
"$orca" mission satisfy AC-2 --evidence "CHANGELOG.md now describes Orca 1.0" --by "Docs lead" > /dev/null
"$orca" mission satisfy AC-3 --evidence "Validated export imported in a clean root" --by "Release captain" > /dev/null
"$orca" mission note "Reopened solely to capture the final portable proof" --by "Release captain" > /dev/null
"$orca" mission complete --by "Release captain" --json > recompleted.json
ruby -rjson -e '
  reopened = JSON.parse(File.read("reopened.json")).fetch("mission")
  completed = JSON.parse(File.read("recompleted.json")).fetch("mission")
  abort "completed mission was not reopened" unless reopened.fetch("status") == "active" && reopened.fetch("completed_at").nil?
  abort "reopened mission did not complete again" unless completed.fetch("status") == "completed"
  abort "new criterion was not retained" unless completed.fetch("criteria").length == 3
  abort "mission revision did not advance" unless completed.fetch("revision") > reopened.fetch("revision")
' || fail "reopen and correction contract failed"

"$orca" mission export "$mission_id" --output completed-export.json --json > completed-export-result.json
portable_root="$mission_test_dir/portable-root"
ORCA_ROOT="$portable_root" "$orca" mission import completed-export.json --json > imported.json
ORCA_ROOT="$portable_root" "$orca" mission import completed-export.json --json > imported-again.json
ORCA_ROOT="$portable_root" "$orca" mission show "$mission_id" --json > imported-show.json
ruby -rjson -e '
  imported = JSON.parse(File.read("imported.json")).fetch("mission")
  again = JSON.parse(File.read("imported-again.json")).fetch("mission")
  shown = JSON.parse(File.read("imported-show.json")).fetch("mission")
  abort "import changed the mission id" unless imported.fetch("id") == ARGV.fetch(0)
  abort "completed state changed during import" unless shown.fetch("status") == "completed"
  abort "idempotent import changed revision" unless again.fetch("revision") == imported.fetch("revision")
' "$mission_id" || fail "portable import contract failed"

ORCA_ROOT="$portable_root" "$orca" mission create "Local portable work" --criterion "The local work is finished" > /dev/null
mkdir -p "$portable_root/missions"
ruby -rjson -e '
  payload = JSON.parse(File.read(ARGV.fetch(0)))
  mission = payload.fetch("mission")
  File.write(File.join(ARGV.fetch(1), "#{mission.fetch("id")}.json"), JSON.pretty_generate(mission) + "\n")
' active-export.json "$portable_root/missions"
if ORCA_ROOT="$portable_root" "$orca" mission import active-export.json > active-import-conflict.out 2>&1; then
  fail "existing active mission import overwrote other active work"
fi
grep -q 'cannot import active mission while' active-import-conflict.out || fail "active import collision was not explained"

cp completed-export.json conflicting-export.json
ruby -rjson -e '
  payload = JSON.parse(File.read(ARGV.fetch(0)))
  payload.fetch("mission")["outcome"] = "Tampered outcome"
  File.write(ARGV.fetch(0), JSON.pretty_generate(payload) + "\n")
' conflicting-export.json
if ORCA_ROOT="$portable_root" "$orca" mission import conflicting-export.json > conflicting-import.out 2>&1; then
  fail "different mission state replaced an existing mission"
fi
grep -q 'already exists with different state' conflicting-import.out || fail "different-state import collision was not explained"

cp completed-export.json unsupported-export.json
ruby -rjson -e '
  payload = JSON.parse(File.read(ARGV.fetch(0)))
  payload["format_version"] = "99.0.0"
  File.write(ARGV.fetch(0), JSON.pretty_generate(payload) + "\n")
' unsupported-export.json
if ORCA_ROOT="$portable_root" "$orca" mission import unsupported-export.json > unsupported-import.out 2>&1; then
  fail "unsupported export version was imported"
fi
grep -q 'unsupported Orca Mission export' unsupported-import.out || fail "unsupported export error was not specific"

printf 'check-mission-smoke: ok\n'
