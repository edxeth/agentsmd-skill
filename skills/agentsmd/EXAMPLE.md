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

- `bun run check`, with its handoff fact in the What-it-does cell. The UI test and typecheck commands stay in the UI block, where their selection fact applies.
- `bun run dev` and plain `bun run test` are not added: `package.json` already names them and the file adds no fact about them.
- The Prisma-client rule — a single root-relevant rule, so a trigger-prefixed bullet.
- Project map — Foundational, stays bare.

## Second example: pruning an accreted nested file

Everything the example claims is evidenced in the hypothetical fixture repo: `Makefile` defines `run`, `test`, and `verify`, and `make -n verify` lists no `archive` target; `make run` prints the port it listens on; `src/` holds twelve modules, each with a same-named directory under `test/` except `src/queue`, which the `jobs` runtime target proves; `src/handlers/` does not exist; the two CSS copies already differed, and `test/renderer-css` was added in the same change; the timings appear in the commit bodies that measured them.

### Input — `services/worker/AGENTS.md` after many sessions

```md
# services/worker

- Module map: `src/queue` consumes jobs (test: `jobs` target); `src/billing` totals (test `test/billing`); `src/render` ... (nine more lines)
- Full suite 22 s, focused run 1.1 s (2026-03-02); re-measure before relying on these.
- The shell CSS lives in two synchronized places, `app.css` and the inline block in `src/render`. Change both together.
- New handlers go in `src/handlers/<feature>/` once that migration lands.
- Click Run in the IDE, or ask the maintainer to start the worker.
- `make verify` runs the full matrix including the `archive` target.
```

### Output

```md
# services/worker

- Each `src/<module>` has `test/<module>`; `src/queue` is proven by the `jobs` runtime target instead.
- The shell CSS lives twice (`app.css`, the inline block in `src/render`); `test/renderer-css` fails when they differ.
- Start the worker with `make run`; it prints the port it listens on.
```

### What was removed, and why

- The module map — one listing gives it (Repo-specific). The convention and its one exception carry the same information in one line.
- The timings — they drift with hardware and time (Durable); they live in the commit bodies that measured them.
- "two synchronized places" — unverifiable, and the copies had already diverged (Checkable). The invariant became `test/renderer-css`, and the line now names that check (Right-homed).
- `src/handlers/<feature>/` — a plan; the directory does not exist (Durable).
- The IDE button and the maintainer — a person's steps; the agent runs the command (Writing style).
- `make verify ... archive` — false; `make -n verify` no longer runs that target. Deleted rather than corrected because the Makefile already shows what `verify` runs (Repo-specific), not for brevity. Found by the wrap-up's falsification step, not by a reader noticing.
