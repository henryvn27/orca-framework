# Choose Your Stack

ORCA Framework should bias toward one good default path per use case, but only when the use case is clear enough.

If the use case is weakly specified, stay neutral or ask one concise clarifying question.
The job here is to reduce decisions, not multiply them.

## I Am Building A Web SaaS

Start with:

- [web-stack-guide.md](web-stack-guide.md)
- [saas-stack-guide.md](saas-stack-guide.md)

Default:

- Next.js + Vercel + Supabase + Stripe + Resend + PostHog + Sentry
Confidence: strong default when the user clearly fits a web SaaS profile.

## I Am Building A Mobile App Fast

Start with:

- [mobile-stack-guide.md](mobile-stack-guide.md)
- [guides/expo-guide.md](guides/expo-guide.md)

Default:

- Expo + React Native + Expo EAS + Supabase or Firebase + RevenueCat + OneSignal + Sentry
Confidence: strong default when the user clearly fits a mobile-app-fast profile.

## I Need Auth + Billing + Analytics

Web default:

- Clerk or Supabase Auth
- Stripe
- PostHog

Mobile default:

- Supabase Auth or Firebase Auth
- RevenueCat
- PostHog or Firebase Analytics plus Sentry

## I Need An Internal Tool

Default:

- Next.js + Railway + Postgres + Clerk + GitHub Issues + GitHub Projects
Confidence: good fit when the user clearly fits an internal-tool workflow.
