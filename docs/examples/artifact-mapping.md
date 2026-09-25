# Example Artifact Mapping

## Source

- Artifact family: spec
- Schema version: 1.0.0
- Human-readable source: `docs/spec.md`

## Target

- Target system: GitHub Issues and Projects
- Target artifact type: GitHub issue plus linked spec document

## Mapping Shape

- `goal` -> issue summary heading
- `requirements` -> linked document checklist
- `acceptance_criteria` -> issue acceptance criteria and verification section
- `open_questions` -> issue comment follow-up section

## Known Losses

- long-form rationale may stay only in the Markdown artifact
- some tracker fields may not preserve ORCA Framework schema identity directly
