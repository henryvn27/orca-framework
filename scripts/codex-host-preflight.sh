#!/usr/bin/env sh
set -eu

root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

say() {
  printf '%s\n' "$1"
}

hr() {
  printf '\n'
}

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
GLOBAL_NPM_ROOT="$(npm root -g 2>/dev/null || true)"

say "Codex host preflight (ORCA Framework)"
say "repo: $root"
hr

say "1) CODEX_HOME"
say "   detected: ${CODEX_HOME}"
say "   export:   export CODEX_HOME=\"\${CODEX_HOME:-$HOME/.codex}\""
hr

say "2) Global Node modules (for NODE_PATH fixups)"
if [ -n "$GLOBAL_NPM_ROOT" ]; then
  say "   npm root -g: ${GLOBAL_NPM_ROOT}"
  say "   export:      export NODE_PATH=\"${GLOBAL_NPM_ROOT}\${NODE_PATH:+:\$NODE_PATH}\""
else
  say "   npm root -g: unavailable (npm not installed or not configured)"
fi
hr

say "3) Bounded command wrapper"
say "   perl -e 'alarm shift @ARGV; exec @ARGV' 45 <command> <args...>"
say "   Example:"
say "     GH_PROMPT_DISABLED=1 GIT_TERMINAL_PROMPT=0 perl -e 'alarm shift @ARGV; exec @ARGV' 45 git status --porcelain"
hr

say "4) Docs"
say "   - Codex host adapter: $root/docs/hosts/codex-cli.md"
say "   - Codex friction kit: $root/docs/hosts/codex-friction-kit.md"
say "   - GitHub work ledger: $root/docs/workflow.md"
