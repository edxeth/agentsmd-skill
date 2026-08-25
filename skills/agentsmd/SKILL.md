---
name: agentsmd
description: >-
  AGENTS.md files, root or nested in any subdirectory: create, update, and
  prune them so future sessions keep what this session learned. Use proactively; the user will not ask. Before
  finishing any coding task, check once for a durable lesson — a command you
  had to hunt for, a wrong directory or pattern you picked twice, a generated
  file, secret, or migration with special rules, or a trap you worked around
  — and invoke this skill to place it. Also invoke when you created a new app
  or package, a subtree you worked in needs different rules than the root
  file, or an AGENTS.md line is stale or contradicted by code.
---

# agentsmd

Design and maintain `AGENTS.md` instruction hierarchies for Pi coding agents.

Every instruction has two axes:

- **Placement** — where it lives: root `AGENTS.md`, nested `AGENTS.md`, doc, skill, or executable check.
- **Condition** — when it applies: Foundational rules (nearly every task in scope) stay bare; Conditional rules carry a trigger.

Treat `AGENTS.md` as a versioned operating contract for future agents: exact commands, validation gates, directory boundaries, generated-file and secret rules, package-manager facts, known traps. Use the smallest durable instruction that prevents a future mistake. Notice durable lessons while you work; record only what stays true.

Per directory, Pi treats `CLAUDE.md` as a fallback when no `AGENTS.md` exists. Apply the same discipline to whichever name a repo uses.

## Write Gate

Default to no edit. A candidate line passes only when it is:

1. **Durable** — true beyond the current task and session.
2. **Repo-specific** — a generic coding agent would not already know it.
3. **Behavior-changing** — it alters which files, commands, tools, or patterns the agent chooses.
4. **Right-homed** — when a linter, formatter, test, or CI rule can enforce it, prefer that home and implement it only within the task's scope; when the agent can imitate it from consistent existing code, it needs no line.
5. **Single-sourced** — stated once, in the right file, contradicting neither parent nor nested instructions.
6. **Evidence-backed** — inferred from repo files, commands, or errors observed this session, not assumption.

Commands are the one exception: an agent cannot guess a command it has never seen. Keep every command. Correct it, deduplicate it, or scope it — never delete it for brevity.
When a command carries a selection, timing, wrapper, or danger fact, its What-it-does cell states that fact (`Full check. Run before handoff`), not a restatement of the name (`Runs the check suite`); a routine command keeps its row with a plain cell. Never record a secret-bearing command (token, connection string, production endpoint) or a one-off destructive invocation — record the safe wrapper, or the fact without the secret. Keep package-only commands in that package's nested file so root stays bounded.

Every line costs tokens on every request and is maintenance surface forever. The one controlled study found no adherence difference — prune for cost and maintenance, not for obedience. Prefer replacing, moving, or deleting stale guidance over appending; a good diff often reduces line count.

## Placement

Resolve the *where* axis before the *when* axis:

| Candidate guidance | Home |
| --- | --- |
| Always-relevant repo facts and commands | root `AGENTS.md` |
| Rules true only below a directory | nested `AGENTS.md` at the lowest directory whose descendants all need it |
| Long architecture explanation | docs, with a short pointer in `AGENTS.md` if needed |
| Reusable multi-step agent workflow | skill |
| Mechanical invariant | script, test, linter, typecheck, CI, or Pi extension |
| One-off task state | conversation or task list |
| Personal preference across repos | user-level agent config |
| Generic advice | nowhere |

Root vs nested turns on one Pi fact: nested files never load at startup, but this setup injects them on read (see "Pi runtime facts"). Put rules in a nested file when the agent reaches that subtree through reads; keep them in root — under a Condition — when they must apply before any read in that subtree.

Nested files scale by size: a 5-bullet nested file beats a full template. Create one when a subtree has rules that would pollute root (`apps/web/AGENTS.md` for frontend conventions, `packages/db/AGENTS.md` for migration rules).

If a rule applies to only one file or one current task, do not create an `AGENTS.md` for it.

## Condition

Inside the chosen file:

- Foundational content (project identity, project map, commands) sits bare near the top — relevant to ~90 percent of tasks or more.
- A single Conditional rule is a trigger-prefixed bullet: `- When touching packages/db/migrations: never edit a committed migration. Add a new one.`
- A group of rules for one kind of work may use an `<important if="narrow trigger">` block. This form is unvalidated; trigger-prefixed bullets are the portable default. `$PI_SKILL_DIR/docs/adr/0001-conditional-relevance-blocks.md` records the status and the fallback plan.

Make each condition narrow — a condition matching most work adds no signal. `if="you are writing or modifying any code"` is worthless; `if="you are adding or modifying imports"` carries information.

Keep conditioned guidance inline: a separate doc costs a search before it helps. Cut embedded code snippets — point at a file (`see src/server/db.ts for the access pattern`) — but keep short do/do-not pairs that prevent a known mistake.

## File shape

Order multi-concern files in layers: foundational bare content first, then conditioned sections. The loader states the file path at injection time, so the body never restates its own location; a nested file's heading may carry its own path to help humans tell equal-named files apart. With on-read injection active, do not point at a nested AGENTS.md from root: injection delivers it on the first subtree read, and a pointer invites a second, explicit read of content already in context. A root pointer is the delivery mechanism only when on-read injection is absent.

```md
# AGENTS.md

[one-line project identity]

## Project map

[directory listing; nested-file pointers only without on-read injection]

## Commands

| Command | What it does |
| --- | --- |
| `...` | ... |

- When [narrow trigger]: [rule]
```

Use only layers with real content.

## Audit and update

1. Discover context files (`AGENTS.override.md` / `AGENTS.md` / `CLAUDE.md` variants). Read root first, then relevant nested files. Establish structure, package manager, and commands from repo files, not assumptions. Edit the active first-match file per directory — writing `AGENTS.md` beside a shadowing `AGENTS.override.md` or `CLAUDE.md` changes nothing.
2. Classify each line: keep / sharpen / add Condition / move nested / move to doc, skill, or check / delete.
3. Resolve parent/nested contradictions by editing the narrower or staler file.
4. Apply the smallest coherent edit — delete stale and generic lines, replace weak prose with exact commands, merge overlapping bullets, then add.
5. Verify every command you document against package scripts or project files.

Bloat review triggers for ordinary repo files: a healthy root file sits near 20 content lines, a nested file between 1 and 10. Treat over 40 root lines as a prune signal and over 100 as documentation that belongs in docs. Exceed a budget only with evidence. A new bullet per new mistake, instead of fixing the underlying command or check, is a prune signal.

Completion criterion: cross-check every command and trap you executed this session against the file. A durable trap you ran into but did not write down is a miss.

Report per-file changes with reasons, plus anything you deliberately did not add. When you decide not to edit, say why.

For a full rewrite of a bloated file, use `/writing-for-agents` if it is installed and apply its pruning and hierarchy rules to the rewrite; if absent, do not search for it — apply the Writing style rules below. `$PI_SKILL_DIR/EXAMPLE.md` walks a full rewrite end to end.

## Writing style

Write for future agents under context pressure: short bullets, exact command names, concrete file paths, scoped headings, do/do-not pairs that prevent a known mistake.

Match register to scope. Repo and nested files stay machine-first. Personal and global files may carry first-person voice, humor, and taste when the words encode identity or collaboration style. Greenfield files may keep founder language while it steers product decisions code cannot yet express. Every expressive passage must carry a decision; the user's authored text is its evidence. Delete performed personality that changes nothing — when user-authored voice is ambiguous, keep it or ask rather than deciding silently.

- Bad: `Run the appropriate tests.` Good: `For parser changes, run bun test parser.`
- Bad: `Make sure to follow best practices and keep things clean.` Good: `Use src/server/db.ts for database access; do not create new Prisma clients in route handlers.`

## Conflict precedence

1. The user's current explicit request
2. The nearest nested `AGENTS.md`
3. Parent/root `AGENTS.md`
4. General Pi/default behavior

This list gives session authority — which instruction wins when several are loaded. It does not choose the edit target: send each fix to the file the Placement section picks. Prefer a sharp scoped statement (`Use pnpm in legacy-app/. The repo root uses bun elsewhere.`) over hedged prose (`Usually use bun, except sometimes pnpm may be needed…`). When both instructions are defensible at their scopes, leave both. Report when the resolution is not obvious.

## Handling uncertain edits

- Small and clearly safe (correcting a command after package scripts changed, moving a local rule nested after confirming delivery — a parent pointer or on-read injection — deleting a line falsified by repo evidence): make it and explain briefly.
- Project policy (broad architecture rules, directory edit bans, validation expectations that cost significant time, creating several nested files at once): ask first.
- Uncertain: report the candidate lesson and why you did not add it.

## Pi runtime facts

Verified facts driving the rules above:

- Context files load at startup from three scopes: `~/.pi/agent/AGENTS.md` (global), the `AGENTS.md` at the session's start directory (project), and any `AGENTS.md` in parent directories walking up from it (repo root and above). All concatenate into the system prompt inside `<project_instructions path="...">` tags. `/reload` re-reads them; the startup set is fixed for the session.
- Nested `AGENTS.md` files below the session root never load at startup. This setup injects them on read: reading a file below root prepends each `AGENTS.md` between it and the root to the read result, closest first, once per session (eligible again after compaction). Injection matches the exact filename `AGENTS.md` only and truncates a file over 32 KB.
- Per directory, Pi loads the first match of `AGENTS.override.md`, `AGENTS.md`, `AGENTS.MD`, `CLAUDE.md`, `CLAUDE.MD`. This chain governs startup loading; on-read injection matches `AGENTS.md` exactly.
- In a linked git worktree, the worktree's context file shadows the main checkout's file for that directory.
- `--no-context-files` (`-nc`) disables startup loading and on-read injection.
- Pi adds no "may or may not be relevant" caveat to injected context; `<important if>` is an unvalidated convention, not measured Pi behavior.
