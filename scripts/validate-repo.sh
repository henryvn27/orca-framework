#!/bin/sh
set -eu

root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
cd "$root"

fail() {
  printf 'validate-repo: %s\n' "$1" >&2
  exit 1
}

need_file() {
  [ -f "$1" ] || fail "missing required file: $1"
}

need_dir() {
  [ -d "$1" ] || fail "missing required directory: $1"
}

need_grep_file() {
  pattern="$1"
  file="$2"
  grep -q "$pattern" "$file" || fail "missing '$pattern' in $file"
}

required_files="
README.md
LICENSE
NOTICE
THIRD_PARTY_NOTICES.md
ACKNOWLEDGEMENTS.md
UPSTREAM.md
CHANGELOG.md
CONTRIBUTING.md
CODE_OF_CONDUCT.md
SECURITY.md
ROADMAP.md
INSTALL.md
bin/orca
install/install.sh
install/verify-install.sh
install/doctor.sh
docs/install.md
docs/install-troubleshooting.md
docs/first-run.md
docs/first-workflow.md
docs/runtime-adaptation.md
docs/compatibility-matrix.md
docs/attribution.md
docs/commands.md
docs/command-index.md
docs/skills.md
docs/hosts/codex-cli.md
docs/hosts/claude-code.md
docs/hosts/generic.md
docs/hosts/vscode.md
integrations/README.md
integrations/impeccable.md
integrations/superpowers.md
scripts/fixtures/notion/goal-event-valid.json
scripts/fixtures/notion/goal-event-missing-data-source.json
scripts/fixtures/notion/goal-event-unsupported-schema.json
scripts/fixtures/notion/goal-event-unsupported-type.json
scripts/fixtures/notion/adapter-doctor-token-missing.json
"

required_dirs="
commands
skills
templates
docs
integrations
install
scripts
bin
"

for path in $required_files; do
  need_file "$path"
done

for path in $required_dirs; do
  need_dir "$path"
done

need_grep_file "Copy-paste prompt for Codex or Claude Code" README.md
need_grep_file "Install ORCA in this environment" README.md
need_grep_file "https://github.com/henryvn27/orca-framework" README.md
need_grep_file "orca goal --packs" README.md
need_grep_file "orca goal --packs --verbose" README.md
need_grep_file "orca notion handoff --issue" README.md
need_grep_file "orca notion handoff --json" README.md
need_grep_file "orca notion outbox --json.*ok:true" README.md
need_grep_file "orca backend status --json.*ok:true" README.md

[ -x bin/orca ] || fail "bin/orca is not executable"
[ -x install/install.sh ] || fail "install/install.sh is not executable"
[ -x install/verify-install.sh ] || fail "install/verify-install.sh is not executable"
[ -x install/doctor.sh ] || fail "install/doctor.sh is not executable"
[ -x scripts/check-notion-adapter-smoke.sh ] || fail "scripts/check-notion-adapter-smoke.sh is not executable"

if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  command_count="$(git ls-files 'commands/orca-*.md' | wc -l | tr -d ' ')"
  skill_count="$(git ls-files 'skills/**/SKILL.md' | wc -l | tr -d ' ')"
  template_count="$(git ls-files 'templates/**' | wc -l | tr -d ' ')"
  doc_count="$(git ls-files 'docs/*.md' 'docs/*.mdx' 'docs/**/*.md' 'docs/**/*.mdx' | wc -l | tr -d ' ')"
else
  command_count="$(/usr/bin/find commands -maxdepth 1 -type f -name 'orca-*.md' | wc -l | tr -d ' ')"
  skill_count="$(/usr/bin/find skills -maxdepth 2 -name SKILL.md | wc -l | tr -d ' ')"
  template_count="$(/usr/bin/find templates -type f | wc -l | tr -d ' ')"
  doc_count="$(/usr/bin/find docs -type f \( -name '*.md' -o -name '*.mdx' \) | wc -l | tr -d ' ')"
fi

[ "$command_count" = "86" ] || fail "expected 86 commands, found $command_count"
[ "$skill_count" = "71" ] || fail "expected 71 skills, found $skill_count"
[ "$template_count" = "183" ] || fail "expected 183 templates, found $template_count"
[ "$doc_count" = "454" ] || fail "expected 454 docs, found $doc_count"

for command in install doctor onboard spec plan build review ship context research delegate checkpoint receipt status attribution help impeccable superpowers; do
  need_file "commands/orca-$command.md"
done

for skill in install-help tool-setup onboard spec plan build review ship context research delegation checkpoint receipts attribution impeccable superpowers; do
  need_file "skills/orca-$skill/SKILL.md"
done

for wrapper in impeccable superpowers; do
  need_file "commands/orca-$wrapper.md"
  need_file "integrations/$wrapper.md"
done

for wrapper in caveman efficient-frontier visual-plan visual-recap; do
  if [ -e "commands/orca-$wrapper.md" ] || [ -e "integrations/$wrapper.md" ] || [ -d "skills/orca-$wrapper" ]; then
    need_file "commands/orca-$wrapper.md"
    need_file "integrations/$wrapper.md"
    need_file "skills/orca-$wrapper/SKILL.md"
  fi
done

if command -v ruby >/dev/null 2>&1; then
  RUBYOPT="${RUBYOPT:+$RUBYOPT }--disable-gems" ruby -rjson -e 'ARGV.each { |path| JSON.parse(File.read(path)) }' scripts/fixtures/notion/*.json ||
    fail "malformed Notion fixture JSON"
  RUBYOPT="${RUBYOPT:+$RUBYOPT }--disable-gems" ruby -rjson -e '
    data = JSON.parse(File.read("scripts/fixtures/notion/adapter-doctor-token-missing.json"))
    abort("missing backend fixture object") unless data["backend"].is_a?(Hash)
    abort("missing adapter fixture object") unless data["adapter"].is_a?(Hash)
    abort("expected doctor fixture ok=false") unless data["ok"] == false
    abort("expected doctor fixture backend ready=true") unless data["backend"]["ready"] == true
    abort("expected doctor fixture token_present=false") unless data["adapter"]["token_present"] == false
    abort("expected doctor fixture live_ready=false") unless data["adapter"]["live_ready"] == false
  ' || fail "invalid Notion adapter doctor fixture contract"
fi

./scripts/check-notion-adapter-smoke.sh >/dev/null ||
  fail "Notion adapter smoke failed"

if /usr/bin/find . -path './.git' -prune -o -name '.DS_Store' -print -quit | grep -q .; then
  fail "tracked tree still contains .DS_Store"
fi

printf 'validate-repo: ok\n'
