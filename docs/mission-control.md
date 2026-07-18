# Mission Control Dashboard

Mission Control is Orca’s dependency-free local web application for operating a Mission without translating lifecycle rules into CLI syntax.

## Launch

```sh
orca dashboard
```

Options:

```text
--project PATH  operate PATH/.orca instead of the current directory
--port PORT     bind a specific loopback port; 0 chooses an available port
--no-open       print the URL without opening a browser
```

The process prints its URL, selected project, and state path. Stop it with `Ctrl-C`.

## What The Interface Owns

The dashboard exposes the complete lifecycle:

- create a Mission and acceptance criteria;
- select durable Mission history;
- add, satisfy, run, and reset criteria;
- add attributable notes;
- block, resolve, and resume;
- cancel, reopen, and complete;
- inspect readiness, evidence, blockers, revision, and event history.

Export, import, and explicit schema validation remain CLI operations because they act on files and automation boundaries rather than the current visual workflow.

## Same Runtime, No Duplicate Logic

The dashboard server maps each allowed action to an argument array and invokes `scripts/orca-mission.rb`. It never writes Mission JSON itself. CLI and browser mutations therefore share locking, validation, attribution, and transition behavior.

## Security Model

Mission Control is available only on the local computer:

- the listener binds to `127.0.0.1`, never all interfaces;
- each process generates a 256-bit random session token;
- every write requires the token and exact server origin;
- checked commands are argument arrays and do not pass through a shell;
- request bodies are size-bounded and must be JSON;
- framing, caching, external scripts, and cross-origin connections are blocked by response headers.

Another local process running as the same OS user already has the permissions required to edit the project. The token and origin protections address browser cross-site request attacks; OS account and filesystem permissions remain the local trust boundary.

## Accessibility And Responsive Behavior

Mission Control uses semantic landmarks and controls, labeled forms, visible focus, keyboard-safe dialogs, an Escape close path, live success/error feedback, reduced-motion support, and text/icon state labels that do not depend on color alone. The same interface adapts from a desktop operations layout to a narrow mobile browser.

## Troubleshooting

- **Port already in use:** run `orca dashboard --port 0`.
- **Wrong project:** stop the server and pass `--project /absolute/path`.
- **Browser did not open:** visit the printed loopback URL.
- **Write rejected:** reload the page from the current server process so it receives the current session token.
- **Ruby missing:** install Ruby 2.6 or newer and confirm `ruby --version`.
