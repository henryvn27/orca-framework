# Taste Skill

## ORCA Framework Relationship

ORCA Framework treats Taste Skill as a thin wrapped capability for anti-slop frontend design work.

Upstream: `https://github.com/Leonxlnx/taste-skill`

## Use When

- the task is a landing page, portfolio, public marketing page, or redesign
- the user asks for anti-AI UI, anti-slop frontend output, or Taste Skill directly
- generic SaaS layouts, weak hierarchy, bland copy, or default AI visual patterns are the main risk

## Do Not Use When

- the task is backend, data plumbing, or non-visual CLI work
- the UI is a dense product/dashboard surface better served by an existing product design system
- a tiny styling tweak does not need a separate design workflow

## ORCA Wrapper Entry Points

- `orca-taste`
- `orca-design`
- `orca-review`

## Variant Routing

- `design-taste-frontend`: default frontend, landing page, portfolio, or redesign pass.
- `redesign-existing-projects`: existing app/site upgrades where stack and behavior must stay intact.
- `gpt-taste`: cinematic GSAP/Awwwards work when the user explicitly wants that level of motion.
- `minimalist-ui`: restrained editorial product surfaces.
- `industrial-brutalist-ui`: mechanical, tactical, dense-data aesthetics.
- `imagegen-frontend-web` or `imagegen-frontend-mobile`: visual references only; do not treat as implementation code.

## What ORCA Still Owns

- Notion or issue context
- spec, plan, approval, implementation, QA, and receipt
- repo hygiene, branch/PR flow, and release evidence
- attribution and provenance

## Install And Update

Preferred install:

```sh
npx skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend"
```

Install a specific variant by replacing the skill name with the variant in `skills/*/SKILL.md`.

## Anti-AI UI Gate

Before marking UI work done, check:

- product-specific visual direction
- intentional layout, spacing, typography, and component language
- non-generic copy in hero, empty states, loading states, release notes, and review artifacts
- button/form contrast and responsive behavior
- screenshot or browser proof, not only a passing build

## Provenance Rule

Say when Taste Skill is being used. Do not copy the upstream skill wholesale into ORCA or describe its design rules as ORCA-authored.
