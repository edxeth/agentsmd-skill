---
name: agentsmd-architect
description: >-
  Create, update, audit, split, or prune AGENTS.md instruction files for Pi
  coding agents. Use when the user mentions AGENTS.md or CLAUDE.md, asks to
  make future agents remember something, reports repeated agent mistakes, or
  when repo structure, package commands, generated files, or architecture
  boundaries suggest future sessions need durable guidance. Decides where
  guidance lives (root or nested AGENTS.md, doc, skill, executable check,
  nowhere) and when it applies (foundational bare rules vs condition-scoped
  blocks); requires evidence, correct scope, conflict checks, and pruning
  over appending.
---

# agentsmd-architect

Design and maintain `AGENTS.md` instruction hierarchies for Pi coding agents.

Every instruction has two axes:

- **Placement** — where it lives: root `AGENTS.md`, nested `AGENTS.md`, doc, skill, executable check, or nowhere.
- **Condition** — when it applies: foundational rules are relevant to nearly every task and stay bare; conditional rules apply to one kind of work and carry a trigger.

The job is not to "write more instructions." The job is to keep future Pi sessions reliably oriented without turning the repository into a growing pile of stale, contradictory, always-on context.

Per directory, Pi treats `CLAUDE.md` as a fallback when no `AGENTS.md` exists (see "Pi runtime facts"). Apply the same discipline to whichever name a repo uses.

Assume many users do not know when instruction files should change. The agent must notice durable lessons while working, but stay disciplined enough not to memorialize every temporary fact.

## Core stance

Treat `AGENTS.md` as a versioned operating contract for future Pi agents.

Good `AGENTS.md` files contain durable, repo-specific instructions that change agent behavior:

- exact commands
- validation gates
- directory ownership and architecture boundaries
- generated-file and secret-handling rules
- package-manager/runtime facts
- local conventions that differ from generic defaults
- known traps that repeatedly waste agent time

Bad `AGENTS.md` files accumulate:

- one-off task notes
- vague advice and generic best practices
- style rules a linter or formatter can enforce
- patterns the agent can imitate from existing code
- duplicated docs and stale commands
- contradictions patched with more caveats

Use the smallest durable instruction that prevents future mistakes.

## When to trigger this skill

Use this skill when the user asks to:

- create, improve, audit, clean up, split, or consolidate `AGENTS.md`
- "make future agents know this"
- "add this to memory/instructions"
- fix repeated Pi agent mistakes
- make a repo easier for AI agents to work in
- set up a new project, app, package, service, or monorepo area

Also trigger proactively when you discover evidence that future sessions may need durable guidance:

- the package manager, test command, build command, or dev command is non-obvious
- a subtree has different conventions than the repo root
- generated files, vendored files, migrations, secrets, or snapshots have special handling rules
- agents repeatedly choose the wrong directory, command, framework pattern, or import boundary
- an `AGENTS.md` instruction is stale, false, duplicated, or contradicted by code
- a new nested app/package/module creates a new instruction scope
- a root `AGENTS.md` is becoming a ball of mud
- the user is vibe-building and probably will not know to request instruction maintenance explicitly

Do not trigger for every edit. Trigger when there is a plausible durable instruction-design decision.

## Anti-entropy law

Default to **no AGENTS.md edit** unless the proposed instruction passes the Write Gate.

Every added line is token cost on every request and maintenance surface forever. (Whether length also degrades instruction adherence is unproven — the best controlled study, on Claude Code, found no adherence difference between 25- and 500-line files — so prune for token and maintenance reasons, not fear of "diluted attention".) Prefer replacing, moving, or deleting stale guidance over appending more.

One exception: **commands are foundational reference.** An agent cannot guess a command it has never seen. Never delete a command for brevity — correct it, deduplicate it, or scope it, but keep it.

## The Write Gate

Before creating or modifying any `AGENTS.md`, evaluate each candidate instruction:

1. **Durable** — likely to remain true beyond the current task/session?
2. **Repo-specific** — would a generic coding agent not already know this?
3. **Behavior-changing** — will it alter what files, commands, tools, or patterns the agent chooses?
4. **Correctly scoped** — repo-wide, or only under one subtree?
5. **Concise** — statable as a short instruction, checklist item, or example?
6. **Non-duplicative** — not already stated nearby?
7. **Conflict-free** — does not contradict root, parent, or nested instructions?
8. **Right home** — if a linter, formatter, test, CI rule, or Pi extension hook can enforce it, cut the instruction and enforce instead. Otherwise, is `AGENTS.md` better than a doc or skill?
9. **Evidence-backed** — inferred from files/commands/errors, not vibes?
10. **Not-imitable** — if the agent can learn it by imitating consistent patterns in existing code, do not write it. LLMs are in-context imitators; consistently applied conventions do not need documenting.

If any answer fails, either skip the edit or recommend another home.

## Where guidance belongs

Classify every candidate before writing.

| Candidate guidance | Best home |
| --- | --- |
| Always-relevant repo facts and commands | root `AGENTS.md` |
| Rules only true below a directory | nested `AGENTS.md` at that directory |
| Long architecture explanations | docs, with a short pointer in `AGENTS.md` if needed |
| Reusable multi-step agent workflow | skill |
| Mechanical invariant | script, test, linter, typecheck, CI, or Pi extension hook |
| One-off task state | current conversation or task list, not `AGENTS.md` |
| Personal preference across repos | user-level agent config/memory, not repo `AGENTS.md` |
| Generic advice | nowhere |

`AGENTS.md` guides behavior. Mechanical checks enforce correctness. Docs hold long reference. Skills hold reusable workflows.

## Conditional relevance

Weight each rule by when it applies, so an agent reading the file sees at a glance which rules matter for the current task. The `<important if>` form is a convention imported from Claude Code; trigger-prefixed bullets are the portable, always-safe form.

**Foundational stays bare.** Content relevant to virtually every task — project identity, project map, tech stack, commands — is plain markdown near the top of the file. Rule of thumb: relevant to 90%+ of tasks, leave it bare.

**Conditional rules carry a trigger.** Two forms, split by granularity:

- `<important if="condition">` XML blocks for grouped multi-rule domain sections (testing patterns, API conventions, state management, schema rules).
- Trigger-prefixed bullets for single rules anywhere:

```md
- When touching `packages/db/migrations`: never edit a committed migration; add a new one.
```

**Conditions must be narrow.** A condition that matches most work weights nothing.

Bad:

```md
<important if="you are writing or modifying any code">
```

Good:

```md
<important if="you are adding or modifying imports">
<important if="you are creating new components">
<important if="you are touching the database schema or Prisma models">
```

**Prefer inline over discoverable.** Conditioned guidance stays inline in a loaded file; do not move it to a separate doc the agent must find. Nested `AGENTS.md` placement is a different axis — but the loader never reaches below the session's start directory, so a nested file trades scope isolation for discovery risk (see "Root vs nested placement").

**Cut embedded code, keep instruction examples.** Code snippets go stale and bloat the file — point at a file instead: "see `src/server/db.ts` for the access pattern." Short do/do-not instruction pairs that prevent a known mistake stay.

## Root vs nested placement

Use the narrowest scope that remains useful.

Pi's loader walks upward from the session's start directory, so a nested `AGENTS.md` loads only when the session starts inside that subtree — and sessions usually start at the repo root. Choose nested placement when the subtree is a workspace sessions enter directly, or its rules are cold enough that a root pointer suffices. When sessions launch at root and the rules are hot, keep them in root under a condition instead.

### Root `AGENTS.md`

Put guidance in the repo root only when it applies to most future work in the repository:

- package manager and top-level commands
- repo-wide validation expectations
- project layout map
- global generated-file, secret, and security rules
- global architecture constraints
- pointers to nested `AGENTS.md` files (loaded only when a session starts inside that subtree; see "Pi runtime facts")

Root examples:

```md
- Use `bun`, not `npm`, for this repository.
- Before handoff, run `bun run check` unless the task is docs-only.
- Do not edit files under `dist/`; they are generated.
- For changes under `apps/*`, also read the nearest nested `AGENTS.md` before editing.
```

Do not put local framework details, one package's test commands, or temporary project plans in root.

### Nested `AGENTS.md`

Create or update a nested file when a subtree has rules that would pollute root:

- `apps/web/AGENTS.md` for frontend conventions
- `packages/db/AGENTS.md` for schema/migration rules
- `services/api/AGENTS.md` for backend/API patterns
- `infra/AGENTS.md` for deployment/IaC constraints
- `tests/AGENTS.md` for test fixture/snapshot rules

Nested files scale by size: a 5-bullet nested file beats a full template. Apply the layered structure below only when a nested file has domain sections that need it.

Nested example:

```md
# packages/db/AGENTS.md

- Schema changes require a migration in `packages/db/migrations`.
- Never edit an existing committed migration; add a new one.
- For schema changes, run `bun test packages/db`.
```

### No edit

Do not write instructions like:

```md
- Today we are fixing login.
- Be careful when editing code.
- Write clean, maintainable code.
- The user likes beautiful UI.
- Ask before making big changes.
```

These are temporary, generic, or too vague to improve future behavior.

## Layered file template

Order any `AGENTS.md` with multiple concerns in layers: foundational bare content first, then conditioned sections.

```md
# AGENTS.md

[one-line project identity — what it is, what it is built with]

## Project map

[directory listing with brief descriptions; point at nested AGENTS.md files]

## Commands

| Command | What it does |
| --- | --- |
| `...` | ... |

<important if="<narrow trigger for one kind of work>">

[rule group]
</important>
```

Use only layers that have real content. Do not create empty boilerplate.

## Update strategy

When an `AGENTS.md` already exists, avoid append-only edits.

1. **Delete** false, stale, duplicated, generic, tool-enforceable, or imitable guidance.
2. **Replace** weak prose with exact commands or constraints.
3. **Move** local rules from root to nested files, minding the loader caveat above.
4. **Merge** overlapping bullets into one sharper instruction.
5. **Add** new guidance only after pruning/replacement — bare if foundational, with a condition otherwise.

Commands are the exception: keep all of them, corrected and deduplicated, including rarely used ones.

A good diff often reduces line count.

## Audit workflow

When auditing or rewriting `AGENTS.md` files:

1. Discover existing `AGENTS.md` files (and `AGENTS.override.md` / `CLAUDE.md` variants).
2. Read root first, then relevant nested files.
3. Identify actual repo structure, package manager, and commands from files, not assumptions.
4. Classify each existing instruction: keep / sharpen / add condition / move nested / move to docs, skill, or check / delete.
5. Check parent/nested contradictions.
6. Apply the smallest coherent edit.
7. Report what changed and why.

Verify commands exist in package scripts or project files before documenting them.

## Writing style

Write for future Pi agents under context pressure.

Prefer:

- short bullets
- exact command names and concrete file paths
- "do / do not" pairs
- instruction examples and counterexamples that prevent a known mistake
- scoped headings

Avoid:

- long essays and motivational tone
- obvious software platitudes
- multiple ways to say the same thing
- rules without evidence
- instructions that require guessing
- embedded code snippets — use file-path pointers instead

Bad:

```md
Make sure to follow best practices and keep things clean.
```

Good:

```md
- Use `src/server/db.ts` for database access; do not create new Prisma clients in route handlers.
```

Bad:

```md
Run the appropriate tests.
```

Good:

```md
- For parser changes, run `bun test parser`.
- For UI changes, run `bun test apps/web` plus `bun run typecheck`.
```

## Worked example

Input — a messy flat root `AGENTS.md`. Everything the output claims is evidenced here or in `package.json`, which defines exactly four scripts: `dev`, `test`, `typecheck`, `check` (run as `bun run <script>`):

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

Output — root rewritten in layers; schema rules moved to a nested file:

```md
# AGENTS.md

Bun monorepo: Next.js web app, Express API, Prisma packages.

## Project map

- `apps/web/` — Next.js app (App Router).
- `apps/api/` — Express REST API.
- `packages/db/` — Prisma schema, client, migrations; see `packages/db/AGENTS.md` before schema work.

## Commands

| Command | What it does |
| --- | --- |
| `bun run dev` | Start dev server |
| `bun run test` | Run all tests |
| `bun run typecheck` | Typecheck |
| `bun run check` | Full check; run before handoff |

<important if="you are building or styling UI in apps/web">

- Prefer server components unless the component needs browser state or effects.
- Use Tailwind v4 utilities; avoid adding CSS modules. See `src/app/` for the pattern.
- For UI changes: `bun run test apps/web` plus `bun run typecheck`.
</important>

- When accessing the database from route handlers: use `src/server/db.ts`; do not create new Prisma clients.
```

```md
# packages/db/AGENTS.md

- Schema changes require a migration in `packages/db/migrations`.
- Never edit a committed migration; add a new one.
```

What was removed and why:

- "clean code / best practices" — generic, changes nothing
- named exports, `const` vs `let`, strict equality — linter/formatter territory; enforce with tooling
- functional components with TS props interfaces — imitable from existing `src/app` components
- "Today we are fixing login" — one-off task state

What was moved:

- migration rules → `packages/db/AGENTS.md` (per the placement algorithm: the lowest directory whose descendants all need them), with a map pointer; sessions doing schema work often start inside the package
- web rules stayed in root, conditioned — sessions launch at root and UI work is hot, so a nested `apps/web/AGENTS.md` might never load

What was kept:

- all four commands from `package.json`, now bare in the Commands section (commands survive pruning)
- the Prisma-client rule — a single root-relevant rule, so a trigger-prefixed bullet
- project map — foundational, stays bare

## Handling noncoder / vibe-coded projects

The user may not know what should be made durable. You are responsible for noticing durable lessons, but you must not silently bloat instructions.

When you suspect an instruction update is needed:

- If the edit is clearly safe and small, make it and explain briefly.
- If it changes project policy, ask first.
- If it is uncertain, report: "I noticed a possible future-agent instruction, but I am not adding it because..."

Safe small updates:

- correcting a documented command after package scripts changed
- moving a local rule from root to a nested `AGENTS.md`
- deleting a false instruction after evidence from repo files

Ask before:

- adding broad architectural policy
- forbidding future edits to a directory
- changing validation expectations that cost significant time
- creating many nested files at once

## Conflict handling

Instruction precedence for AGENTS.md hierarchy:

1. The user's current explicit request
2. The nearest nested `AGENTS.md`
3. Parent/root `AGENTS.md`
4. General Pi/default behavior

If instructions conflict, do not patch around it with caveats. Resolve by editing the narrower or stale instruction, or report the conflict if resolution is not obvious.

This list is session authority — which instruction wins when several are loaded. It does not override edit-target selection: fixes still go wherever the placement algorithm points.

Prefer:

```md
- Use `pnpm` in `legacy-app/`; the repo root uses `bun` elsewhere.
```

Over:

```md
- Usually use bun, except sometimes pnpm may be needed depending on where you are, so check carefully.
```

## Bloat detection

Watch for these smells:

- root file contains many app-specific details
- repeated "be careful" or "follow best practices" language
- old task notes preserved as policy
- multiple conflicting test commands
- every new mistake gets a new bullet instead of fixing the underlying command or check
- long copied docs that could be a link or file pointer
- embedded code snippets that could be file pointers
- instructions for tools/frameworks no longer present
- nested file repeats the root file instead of adding local differences

If bloat is present, propose or perform a prune pass before adding anything.

## Placement algorithm

Two axes, in order — first where, then when:

```text
Does it pass the Write Gate (durable, repo-specific, not-imitable)?
  no  -> do not add to AGENTS.md
  yes -> Could a linter, test, CI rule, or hook enforce it?
           yes -> enforce mechanically; optionally add a short pointer
           no  -> Does it apply across the whole repo?
                    yes -> root AGENTS.md
                    no  -> nested AGENTS.md at the lowest directory whose descendants all need it

Inside the chosen file, pick the form:
  Applies to nearly every task in scope -> bare, foundational layer
  Group of rules for one kind of work    -> <important if> block
  Single rule for one kind of work       -> trigger-prefixed bullet
```

Lowest common directory rule:

- If a rule applies to `apps/web/src/components` only, place it there or the nearest stable parent.
- If it applies to all of `apps/web`, place it at `apps/web/AGENTS.md`.
- If it applies to all apps, maybe root or `apps/AGENTS.md` if that scope exists.
- If it applies to only one file or one current task, do not create an `AGENTS.md` for it.

## Final response format

When you modify AGENTS.md files, summarize in this shape:

```md
Updated AGENTS.md hierarchy:
- `AGENTS.md`: changed X because Y
- `apps/web/AGENTS.md`: added/moved Z because it only applies there
- Removed: stale/duplicated guidance about Q

Not added:
- R: one-off task detail, not durable
- S: better enforced by test/script/CI
```

When you decide not to edit, say why:

```md
I did not update AGENTS.md because the discovered fact is task-specific and not durable. If this becomes a recurring issue, the right place would be `packages/db/AGENTS.md`.
```

## Pi runtime facts

These verified facts drive every rule above:

- Pi loads context files at startup, from `~/.pi/agent/AGENTS.md` (global), the session's start directory, and parent directories walking up from it. All matching files are concatenated into the system prompt inside `<project_instructions path="...">` tags.
- Context files are re-read when the user runs `/reload`. Nothing loads automatically on file access or directory change mid-session.
- The loader walks upward only: a nested `AGENTS.md` below the start directory is never auto-loaded. It matters only when a session starts inside that subtree, or a root pointer tells the agent to read it.
- Pi adds no "may or may not be relevant" caveat to injected context. `<important if>` conditioning is a convention imported from Claude Code, not a measured Pi behavior.
- Per directory, Pi loads the first match of: `AGENTS.override.md`, `AGENTS.md`, `AGENTS.MD`, `CLAUDE.md`, `CLAUDE.MD`. Other directories still layer normally.
- In a linked git worktree, the worktree's context file shadows the main checkout's file for that directory.
- Context file discovery can be disabled with `--no-context-files` (`-nc`).
