# Visual Quality

ORCA Framework should push user-facing work toward interfaces that feel intentional, product-specific, and human-reviewed.

The target is not empty polish. The target is:

- clear hierarchy
- strong taste
- product-specific visual choices
- disciplined spacing and typography
- copy that sounds human, not generated
- results that do not look like generic prompt output

## What "AI-Looking" Usually Means Here

A surface starts to look AI-generated when it has some mix of:

- generic layout choices with no product point of view
- interchangeable color systems that could belong to any SaaS
- weak typography hierarchy
- decorative effects without product meaning
- repetitive section patterns
- bland stock phrasing or over-smoothed copy
- too many ideas on the page and no obvious visual priority

## Quality Standard

User-facing work should aim for:

- one clear visual point of view
- one strong content hierarchy
- a constrained component language
- product-specific language and content structure
- obvious next actions
- non-empty loading states for async content, with skeleton frames when layout is already known
- clean states, empty states, and error states
- responsive behavior that preserves the same design idea instead of collapsing into generic mobile stacks

## Hard Rules

- do not let the model design from a blank vacuum when references, brand context, or a real product category exist
- do not mix layout invention, copy invention, and styling invention in one uncontrolled pass
- do not accept generic hero, feature-grid, testimonial, pricing, and FAQ stacks without proving they fit the product
- do not let decorative gradients, blobs, or motion stand in for hierarchy
- do not let copy drift into motivational filler, jargon fog, or "AI nice" tone
- do not leave known async surfaces visually empty while data is loading if a skeleton frame can preserve the expected layout
- do not let artifact copy, empty states, labels, or release notes read like interchangeable startup-template prose

## Preferred Approach

1. lock the product goal and target user first
2. define the visual direction or references
3. define the content structure and hierarchy
4. define typography, spacing, and component rules
5. implement and then review with real screenshots or browser context

When the work is a landing page, portfolio, redesign, or public marketing UI and the main risk is generic AI-looking output, route through `orca-taste` and `integrations/taste-skill.md`.

## Artifact Spillover

If the UI is specific but the surrounding artifacts are generic, ORCA still feels AI-generated.

The same anti-generic standard should apply to:

- release notes
- loading states
- launch copy
- empty states
- review summaries
- spec and plan headings
- issue comments that other humans will skim first
