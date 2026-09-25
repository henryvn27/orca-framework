# MCP Examples

ORCA Framework includes example MCP snippets for QA workflows. These files are not universal configuration files; adapt command names and paths to your agent client and installed MCP servers.

- `linear.example.json` is retained only as a historical example; do not install or use it for active work. GitHub Issues and Projects are the execution ledger.
- `ios-simulator.example.json` shows the intended shape for simulator QA.
- `browser.example.json` shows the intended shape for browser QA.

Use the QA examples with `orca-ios-sim-qa` and `orca-web-qa`. For work tracking, use the authenticated GitHub connector or CLI. Keep any credentials in the agent client's secret store.

MCP servers are not trusted by default. Review [docs/mcp-governance.md](../docs/mcp-governance.md) and [docs/mcp-review-workflow.md](../docs/mcp-review-workflow.md) before adding or expanding a server. Registry entries belong in `registry/mcp-servers/`.
