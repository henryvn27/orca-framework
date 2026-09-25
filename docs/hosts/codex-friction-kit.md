# Codex Host Friction Kit

This page is a compact paved road for recurring Codex-host friction seen during the blind product launch lab.
Use it when the work is blocked or slowed by host variance rather than by product code.

If local Codex CLI help or behavior differs from this page, follow the installed behavior and record the difference in the run artifacts.

## 1) Normalize `CODEX_HOME`

Not every Codex environment exports `CODEX_HOME`. Prefer a safe default:

```sh
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
```

If an automation references `$CODEX_HOME/...` and the variable is unset, use `$HOME/.codex` as the durable fallback path.

## 2) Bound commands that can hang

Some commands can block on auth prompts, network, or file-provider stalls. Prefer bounded snapshots.

macOS-friendly pattern:

```sh
perl -e 'alarm shift @ARGV; exec @ARGV' 45 <command> <args...>
```

Examples:

```sh
GH_PROMPT_DISABLED=1 GIT_TERMINAL_PROMPT=0 perl -e 'alarm shift @ARGV; exec @ARGV' 45 git status --porcelain
GH_PROMPT_DISABLED=1 perl -e 'alarm shift @ARGV; exec @ARGV' 45 gh pr checks 2 --watch=false
```

## 3) Fix “Playwright CLI works but `import(\"playwright\")` fails”

In some Codex installs, Playwright is available globally (CLI works) but the repo does not have `playwright` in `node_modules`, so Node cannot resolve it.

If you need in-repo Node resolution, add the global module root to `NODE_PATH`:

```sh
export NODE_PATH="$(npm root -g 2>/dev/null || true)${NODE_PATH:+:$NODE_PATH}"
```

Then re-run your Node/Playwright script.

If you do not actually need in-repo Node resolution, prefer the harness-native Playwright tooling (for example Playwright-MCP) instead of pulling Playwright into every repo.

## 4) GitHub Project scope in Codex

GitHub repository access does not prove GitHub Projects access. Validate Project reads and writes with the authenticated connector or `gh` CLI using the required `project` scope. If the scope is absent, continue safe local work and retain a Project update draft; do not claim the Project changed.

## 5) Ecosystem drift: Tailwind v4 scaffold mismatch

If Tailwind scaffold steps fail (for example `npx tailwindcss init -p`), pin a known-good version for the template or scaffold you are using, and treat the mismatch as ecosystem drift.

Promote repeated Tailwind v4 friction into a framework template update only after it repeats across multiple product runs.

## 6) Cross-workspace edits: avoid patching the wrong repo

Blind product runs often touch multiple sibling workspaces. `apply_patch` and relative-path commands default to the current working directory.

Guardrails:

- Prefer absolute file paths for edits outside the current repo.
- Before patching, sanity-check the target root (`pwd`) and the file path you are about to modify.
- When the work spans multiple repos, explicitly write the product workspace path into the run artifacts and re-use it verbatim.
