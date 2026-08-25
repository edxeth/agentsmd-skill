# Worked example: full rewrite of a flat root AGENTS.md

Everything the example claims is evidenced here or in `package.json`, which defines exactly four scripts: `dev`, `test`, `typecheck`, `check` (run as `bun run <script>`).

## Input — messy flat root file

```md
# AGENTS.md

This is our full-stack app. We love clean code!

## Project structure

- apps/web — Next.js app (App Router)
- apps/api — Express REST API
- packages/db — Prisma schema, client, migrations

## Rules

- Write clean, maintainable code and follow best practices.
- Use named exports; prefer `const` over `let`; always use strict equality.
- Components use functional components with TypeScript interfaces for props.
- Use Tailwind v4 utilities; avoid adding CSS modules.
- Prefer server components unless the component needs browser state or effects.
- For UI changes, run `bun run test apps/web` and `bun run typecheck`.
- Schema changes require a migration in `packages/db/migrations`.
- Never edit a committed migration; add a new one.
- Use `src/server/db.ts` for database access; do not create new Prisma clients in route handlers.
- Today we are fixing the login flow.
- Run `bun run check` before handoff.
```

## Output — root rewritten in layers, schema rules moved nested

```md
# AGENTS.md

Bun monorepo: Next.js web app, Express API, Prisma packages.

## Project map

- `apps/web/` — Next.js app (App Router).
- `apps/api/` — Express REST API.
- `packages/db/` — Prisma schema, client, migrations.

## Commands

| Command | What it does |
| --- | --- |
| `bun run dev` | Start dev server |
| `bun run test` | Run all tests |
| `bun run typecheck` | Typecheck |
| `bun run check` | Full check. Run before handoff |

<important if="you are building or styling UI in apps/web">

- Prefer server components unless the component needs browser state or effects.
- Use Tailwind v4 utilities. Do not add CSS modules. See `src/app/` for the pattern.
- For UI changes: `bun run test apps/web` plus `bun run typecheck`.
</important>

- When accessing the database from route handlers: use `src/server/db.ts`. Do not create new Prisma clients.
```

```md
# packages/db/AGENTS.md

- Schema changes require a migration in `packages/db/migrations`.
- Never edit an existing committed migration. Add a new one.
```

## What was removed, and why

- "clean code / best practices" — generic, changes nothing.
- Named exports, `const` vs `let`, strict equality — linter/formatter territory; enforce with tooling.
- Functional components with TS props interfaces — imitable from existing `src/app` components.
- "Today we are fixing login" — one-off task state.

## What was moved, and why

- Migration rules → `packages/db/AGENTS.md`. Schema work always reads files under `packages/db`, so on-read injection delivers the file. The placement algorithm picks the lowest directory whose descendants all need the rules.
- Web rules stayed in root, under a Condition. UI work does not always read `apps/web` files first, so root keeps the rules visible from the first turn.

## What was kept

- All four commands from `package.json`, bare in the Commands section (commands survive pruning).
- The Prisma-client rule — a single root-relevant rule, so a trigger-prefixed bullet.
- Project map — Foundational, stays bare.
