# SaaS Stack Guide

This guide exists to compress common SaaS decisions into one strong path, not to add a larger tool menu.

For a typical startup SaaS, ORCA Framework should recommend a bundle instead of a menu:

- Next.js
- Vercel
- Supabase
- Stripe
- Resend
- PostHog
- Sentry
- GitHub
- GitHub Projects for project and issue workflow

## Why This Bundle

- app shell and product surface
- deploy path
- auth and data
- billing
- transactional email
- analytics and monitoring
- build and project workflow through GitHub Issues and Projects

## When To Deviate

- choose Cloudflare for edge-heavy or worker-heavy patterns
- choose Railway for simpler backend hosting or internal tooling
- choose Paddle or LemonSqueezy when merchant-of-record needs outweigh Stripe fit
