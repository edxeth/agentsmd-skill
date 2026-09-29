---
name: agentsmd
description: >-
  Required final step of every coding task, including a one-line fix: before
  your final answer, read this SKILL.md and check once for a durable lesson
  to record in AGENTS.md, such as a command that AGENTS.md misstates, a new
  app or package, or a generated file, secret, migration, or trap with
  special rules. Use it proactively. The user will not ask. Also read it before you
  create, update, or prune any AGENTS.md or CLAUDE.md, root or nested. This
  description is not enough to edit them correctly.
---

# agentsmd

Design and maintain `AGENTS.md` instruction hierarchies for Pi coding agents.

Every instruction has two axes:

- **Placement** — where it lives: root `AGENTS.md`, nested `AGENTS.md`, doc, skill, or executable check.
- **Condition** — when it applies: Foundational rules (nearly every task in scope) stay bare; Conditional rules carry a trigger.

Treat `AGENTS.md` as a versioned operating contract for future agents: exact commands, validation gates, directory boundaries, generated-file and secret rules, package-manager facts, known traps. Use the smallest durable instruction that prevents a future mistake. Notice durable lessons while you work; record only what stays true.

Per directory, Pi treats `CLAUDE.md` as a fallback when no `AGENTS.md` exists. Apply the same discipline to whichever name a repo uses.

## Project scope

The project is the git repository that contains the session start directory. Find its root with `git rev-parse --show-toplevel`. This skill edits only `AGENTS.md` or `CLAUDE.md` files at or below that root. When the start directory is in no git repository, there is no project, and this skill edits no file.

Every context file outside the project is read-only, whatever its tag in the system prompt says. It changes only when the user's current request names that file by path or by name. A request to remember a fact, or to make future sessions know it, names no file: ask the user which file to use, and edit only after the user names one. Your own recommendation in that question is not the user's answer. When no answer comes, for example because the question tool is unavailable, make no edit.

This boundary is fixed. Conflict precedence and the Placement table work inside it and never widen it. When a lesson has no home inside the project, make no edit and name it as a candidate, as Reporting describes.

## Wrap-up check

When you read this skill at the end of a coding task:

1. List the lesson candidates from this session. Compare each command line in the project's AGENTS.md files, word for word, with the command that worked this session. A line that differs is a candidate. Also list a new app or package, a generated file, secret, or migration with special rules, a trap you worked around, a wrong turn you took twice.
2. Run each candidate, and each AGENTS.md edit you already made this session, through the Write Gate and Placement below.
3. For each candidate that passes, make the smallest edit that "Audit and update" describes.
4. Report as Reporting describes.

The check is complete when every candidate is recorded or rejected.

## Reporting

The final answer covers context files only when there is something to tell:

- After an edit: one sentence per changed file, with the change and its reason.
- For a lesson with no home inside the project: one sentence that names it as a candidate for the user.
- With no edit and no candidate: say nothing about context files. The exception is a session where the user invoked this skill (a `<skill name="agentsmd">` block in a user message) or asked for a context-file change. Then say in one sentence why nothing changed.

## Write Gate

Default to no edit. A candidate line passes only when it is:

1. **Durable** — true beyond the current task and session.
2. **Repo-specific** — a generic coding agent would not already know it.
3. **Behavior-changing** — it alters which files, commands, tools, or patterns the agent chooses.
4. **Right-homed** — when a linter, formatter, test, or CI rule can enforce it, prefer that home and implement it only within the task's scope; when the agent can imitate it from consistent existing code, it needs no line.
5. **Single-sourced** — stated once, in the right file, contradicting neither parent nor nested instructions.
6. **Evidence-backed** — inferred from repo files, commands, or errors observed this session, not assumption.

Commands pass the same gate. A manifest is any file at a repo or package root that names runnable commands, in any ecosystem: `package.json` or `deno.json` scripts, `Makefile`, `justfile`, or `Taskfile.yml` targets, `pyproject.toml`, `Cargo.toml`, `composer.json`, `mix.exs`, `build.gradle`. A command that a manifest already names fails criterion 2: agents read those files before they run anything. So does the default command of a toolchain (`cargo test`, `go test ./...`). Add a command only for a fact the manifest does not show: which one to run before handoff, a required wrapper, environment variable, or service, a slow or dangerous run, or a command with no manifest entry. Its What-it-does cell states that fact (`Full check. Run before handoff`), not a restatement of the name (`Runs the check suite`). Keep existing command lines: correct a stale one to the working command, deduplicate it, or scope it, but do not delete it for brevity. Never record a secret-bearing command (token, connection string, production endpoint) or a one-off destructive invocation — record the safe wrapper, or the fact without the secret. Keep package-only commands in that package's nested file so root stays bounded.

Every line costs tokens on every request and is maintenance surface forever. The one controlled study found no adherence difference — prune for cost and maintenance, not for obedience. Prefer replacing, moving, or deleting stale guidance over appending; a good diff often reduces line count.

## Placement

Resolve the *where* axis before the *when* axis:

| Candidate guidance | Home |
| --- | --- |
| Always-relevant repo facts, and commands with a fact their manifest does not show | root `AGENTS.md` |
| Rules true only below a directory | nested `AGENTS.md` at the lowest directory whose descendants all need it |
| Long architecture explanation | docs, with a short pointer in `AGENTS.md` if needed |
| Reusable multi-step agent workflow | skill |
| Mechanical invariant | script, test, linter, typecheck, CI, or Pi extension |
| One-off task state | conversation or task list |
| Machine, tool, or personal fact that is true outside this project | no file: name it as a candidate for the user |
| Generic advice | nowhere |

Root vs nested turns on one Pi fact: nested files never load at startup, but this setup injects them on read (see "Pi runtime facts"). Put rules in a nested file when the agent reaches that subtree through reads; keep them in root — under a Condition — when they must apply before any read in that subtree.

Nested files scale by size: a 5-bullet nested file beats a full template. Create one when a subtree has rules that would pollute root (`apps/web/AGENTS.md` for frontend conventions, `packages/db/AGENTS.md` for migration rules).

If a rule applies to only one file or one current task, do not create an `AGENTS.md` for it.

## Condition

Inside the chosen file:

- Foundational content (project identity, project map, commands that pass the Write Gate) sits bare near the top — relevant to ~90 percent of tasks or more.
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

1. Discover the project's context files (`AGENTS.override.md` / `AGENTS.md` / `CLAUDE.md` variants). Read root first, then relevant nested files. Establish structure, package manager, and commands from repo files, not assumptions. Edit the active first-match file per directory — writing `AGENTS.md` beside a shadowing `AGENTS.override.md` or `CLAUDE.md` changes nothing.
2. Classify each line: keep / sharpen / add Condition / move nested / move to doc, skill, or check / delete.
3. Resolve parent/nested contradictions by editing the narrower or staler project file. Report a contradiction with a file outside the project.
4. Apply the smallest coherent edit — delete stale and generic lines, replace weak prose with exact commands, merge overlapping bullets, then add.
5. Verify every command you document against package scripts or project files.

Bloat review triggers for ordinary repo files: a healthy root file sits near 20 content lines, a nested file between 1 and 10. Treat over 40 root lines as a prune signal and over 100 as documentation that belongs in docs. Exceed a budget only with evidence. A new bullet per new mistake, instead of fixing the underlying command or check, is a prune signal.

Completion criterion: cross-check every trap and every misstated command from this session against the file. A durable trap you ran into but did not write down is a miss.

Report as Reporting describes.

For a full rewrite of a bloated file, use `/writing-for-agents` if it is installed and apply its pruning and hierarchy rules to the rewrite; if absent, do not search for it — apply the Writing style rules below. `$PI_SKILL_DIR/EXAMPLE.md` walks a full rewrite end to end.

## Writing style

Write for future agents under context pressure: short bullets, exact command names, concrete file paths, scoped headings, do/do-not pairs that prevent a known mistake.

Match register to scope. Repo and nested files stay machine-first. Greenfield files may keep founder language while it steers product decisions code cannot yet express. Every expressive passage must carry a decision; the user's authored text is its evidence. Delete performed personality that changes nothing — when user-authored voice is ambiguous, keep it or ask rather than deciding silently.

- Bad: `Run the appropriate tests.` Good: `For parser changes, run bun test parser.`
- Bad: `Make sure to follow best practices and keep things clean.` Good: `Use src/server/db.ts for database access; do not create new Prisma clients in route handlers.`

## Conflict precedence

1. The user's current explicit request
2. The nearest nested `AGENTS.md`
3. Parent/root `AGENTS.md`
4. General Pi/default behavior

This list gives session authority — which instruction wins when several are loaded. It does not choose the edit target, and it never widens Project scope: send each fix to the file the Placement section picks. Prefer a sharp scoped statement (`Use pnpm in legacy-app/. The repo root uses bun elsewhere.`) over hedged prose (`Usually use bun, except sometimes pnpm may be needed…`). When both instructions are defensible at their scopes, leave both. Report when the resolution is not obvious.

## Handling uncertain edits

- Small and clearly safe (correcting a command after package scripts changed, moving a local rule nested after confirming delivery — a parent pointer or on-read injection — deleting a line falsified by repo evidence): make it and explain briefly.
- Project policy (broad architecture rules, directory edit bans, validation expectations that cost significant time, creating several nested files at once): ask first.
- Uncertain: name it as a candidate for the user.

## Pi runtime facts

Verified facts driving the rules above:

- Context files load at startup from the session's start directory, from every parent directory up to the filesystem root, and from user-level scopes. All concatenate into the system prompt inside `<project_instructions path="...">` tags, so the tag does not show that a file is in the project. `/reload` re-reads them; the startup set is fixed for the session.
- Nested `AGENTS.md` files below the session root never load at startup. This setup injects them on read: reading a file below root prepends each `AGENTS.md` between it and the root to the read result, closest first, once per session (eligible again after compaction). Injection matches the exact filename `AGENTS.md` only and truncates a file over 32 KB.
- Per directory, Pi loads the first match of `AGENTS.override.md`, `AGENTS.md`, `AGENTS.MD`, `CLAUDE.md`, `CLAUDE.MD`. This chain governs startup loading; on-read injection matches `AGENTS.md` exactly.
- In a linked git worktree, the worktree's context file shadows the main checkout's file for that directory.
- `--no-context-files` (`-nc`) disables startup loading and on-read injection.
- Pi adds no "may or may not be relevant" caveat to injected context; `<important if>` is an unvalidated convention, not measured Pi behavior.
