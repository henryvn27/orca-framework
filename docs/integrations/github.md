# GitHub Integration

GitHub Issues and GitHub Projects are the default ledger for engineering work. GitHub integration also provides repository metadata, pull requests, reviews, checks, releases, and changelog context.

## When GitHub Is Required

Require authenticated GitHub access when ORCA Framework must:

- read or update GitHub issues directly
- open or update a pull request
- inspect PR checks or workflow runs
- create releases or release notes
- create draft issues for ecosystem findings
- read or update GitHub Project fields, including Status and Priority

## When GitHub Is Optional

GitHub can be deferred only when:

- the user explicitly requests a local Mission-only action
- the next action is safe local discovery or implementation that does not depend on changing tracker state
- a separate authorized GitHub writer will post the prepared update; do not claim it is already posted

## Setup Paths

- Native connector: use when the harness provides an authenticated GitHub connector.
- GitHub MCP server: use when the host supports MCP and the server is approved by tool governance.
- `gh` CLI: use when local shell access and GitHub CLI auth are available.
- API token: use only when the user or environment already provides a scoped token.
- Manual: use local repo plus pasted issues, PR links, and check output.

## Validation

Prefer non-destructive checks:

- confirm auth state
- confirm target repo is reachable
- read issue or PR metadata
- read check status when needed
- verify issue/PR write access and Project scope separately before changing the corresponding resource

Do not assume write access from read success.

Runtime adaptation should prefer the shortest validated GitHub path for the active host. If write scope is missing, preserve local work and an update draft without representing it as tracker state.

## Fallback

If GitHub is unavailable, ORCA Framework can still:

- continue safe local repo work
- produce branch and commit instructions
- write draft PR or issue text locally
- keep verification claims limited to observed local evidence
- refresh the issue and Project after authenticated access returns
- record release notes without publishing them

## Sources

- https://github.com/github/github-mcp-server
- https://cli.github.com/manual/gh_auth_status
- https://docs.github.com/en/copilot/how-tos/provide-context/use-mcp/extend-copilot-chat-with-mcp
