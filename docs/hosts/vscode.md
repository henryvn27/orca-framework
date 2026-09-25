# VS Code Host Adapter

VS Code support depends on the extension and agent surface in use. GitHub Copilot in VS Code supports MCP server configuration, but ORCA Framework should still validate the active workspace and available tools before relying on an integration.

## External Tool Setup

| Service | Preferred methods | Verification | Fallback |
| --- | --- | --- | --- |
| GitHub | GitHub Copilot connector, GitHub MCP server, `gh` CLI, or manual | confirm repo access, issue or PR access, and needed write scope | local repo plus manual GitHub steps |
| GitHub Projects | GitHub Copilot connector, approved GitHub MCP, or authenticated `gh` CLI/API | confirm Project access separately from repository issue access | local work plus an update draft; do not claim Project writes |

## Guidance

- Use workspace-level MCP config only when the project should own that setup.
- Use user-level setup when credentials are personal.
- Do not commit secrets.
- Validate with non-destructive reads before writes.

## Compatibility View

See [compatibility matrix](../compatibility-matrix.md) and [harness watch](../harness-watch.md) for the current conservative VS Code compatibility view.

## Sources

- https://code.visualstudio.com/docs/copilot/chat/mcp-servers
- https://docs.github.com/en/copilot/how-tos/provide-context/use-mcp/extend-copilot-chat-with-mcp
