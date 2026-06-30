# Docs Automation

ORCA Framework documentation should improve continuously instead of depending on one large manual rewrite.

## Purpose

The docs automation layer keeps the top-level docs and routing pages aligned with the real framework surface.

## Inputs

- `README.md`
- `docs/README.md`
- `docs/information-architecture.md`
- `docs/feature-index.md`
- `docs/command-index.md`
- `docs/choose-your-path.md`
- `docs/doc-owners.md`
- `docs/staleness-detection.md`
- `docs/whats-new.md`
- `commands/*.md`
- `skills/*/SKILL.md`
- major feature docs under `docs/`

## What The Automation Should Detect

- new commands without index or guide coverage
- new major features without routing from README or `docs/start-here.md`
- changed command names, guide names, or feature names that leave stale links
- guide pages whose linked feature docs changed materially
- top-level docs that have not been reviewed relative to recent framework changes

## Expected Automation Actions

- propose README and start-here refreshes when the top-level user story changes
- update indexes when commands or feature families are added
- draft freshness notes for stale pages
- update `docs/recent-doc-updates.md` and `docs/whats-new.md` when major docs surfaces change
- watch install docs, plugin docs, and harness setup docs for drift as scripts, hosts, or service requirements change
- watch update docs, release notes surfaces, and versioning guidance for drift when channel rules, compatibility policy, or doctor behavior changes
- surface recurring docs friction from the session improvement backlog when the same routing or clarity gap keeps recurring
- watch integration packs and stack guides for ecosystem drift in tier 1 and tier 2 services
- watch recommendation-policy pages so defaults do not expand into generic vendor suggestion lists
- keep the single beginner ORCA path clear instead of letting the intro experience collapse into a command catalog
- watch optional integrations such as NotebookLM so official and community guidance do not get blurred together
- use vault or graph analysis outputs to spot duplicate docs, weak hub pages, and routing gaps when that would reduce docs drift
- prefer collapsing redundant explanation over adding one more top-level page
- convert repeated docs confusion into either a local routing adaptation or a framework docs candidate depending on recurrence and generalizability

## Boundaries

- do not rewrite every reference page automatically
- do not produce duplicate summary pages when links would do
- do not treat generated volume as success
- prefer routing, summary, and staleness notes over speculative rewriting
