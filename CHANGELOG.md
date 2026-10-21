# Changelog

Notable changes to the `agentsmd` skill. Pending entries sit under `## [Unreleased]`; each released section carries its tag date.

## [Unreleased]

### Added

- Added `skills/agentsmd/scripts/check-refs.sh`, a candidate scan the wrap-up runs on every edited context file. It lists each backticked span with a slash or an extension that exists neither from the repository root nor from the file's directory; commands pass when their first word exists, and placeholders, globs, URLs, and variables are skipped. Exit 0 means a clean scan, 1 hits, 2 usage error or unreadable input. See [Reference check](skills/agentsmd/SKILL.md#reference-check).
- Added a second worked example to [EXAMPLE.md](skills/agentsmd/EXAMPLE.md): an accreted nested file (module map, timings, an unverifiable "kept in sync" claim, a planned directory, an operator step, a stale command) pruned to three checkable lines, each removal naming the gate criterion it failed.
- Added **Trigger file** and **Checkable** to [GLOSSARY.md](skills/agentsmd/GLOSSARY.md).

### Changed

- Changed the Write Gate's six criteria without adding a seventh: Durable now rejects plans, paths nothing yet creates, and numbers that drift with hardware or time, while keeping generated, ignored, or secret files that a generator, configuration, or ignore rule accounts for; Repo-specific rejects directory listings without a placement fact, module and class inventories, dependency lists, and restated docstrings; Right-homed states that a sentence enforces nothing and an invariant gets a check the line names; Single-sourced spans READMEs, docs, docstrings, and test names, so a fact that already lives there gets a pointer or nothing; Evidence-backed becomes "Evidence-backed and checkable", so an unverifiable claim is not written.
- Changed file budgets from lines to words (`wc -w`), because a long bullet hid as one line: root near 20 bullets and 500 words, nested 1 to 10 bullets under 300 words, over 1,000 root words a prune signal, over 2,500 documentation. An over-budget file takes an addition only with a pruning pass; when nothing can go, the addition is made and reported. The full audit now has triggers: over budget, additions-only history, or a line that proved false in the session.
- Changed the audit's verification step to cover paths, tests, and identifiers, not only commands, and to grep the test suite for sentences a test pins verbatim: a pinned sentence is kept as it is or reported as a blocker, editing the test is outside the skill's scope, and no new prose pin is added on a context file.
- Changed the file-shape template: the project map lists top-level directories with the placement or boundary fact a listing does not show, not a bare listing.
- Changed the Placement table's one-off row to include the progress notes and prompts of an automation run, which are never cited as evidence.
- Changed the always-loaded description to name the new branch: a line in AGENTS.md that the session showed false.
- Renamed `skills/agentsmd/CONTEXT.md` to `GLOSSARY.md`; README updated.

### Fixed

- Fixed the end-of-task check only ever adding lines. Before, the wrap-up compared command lines with the commands that ran and listed new lessons, so dead paths, rules for directories that were only planned, drifted measurements, and paraphrases of docs stayed in context files for as long as the repository lived. Now the first wrap-up step falsifies: every line about a path, command, test, directory, or setting the session touched is confirmed against what the agent saw, a contradicted line is corrected or deleted, a line that can be neither confirmed nor refuted stays, and one false line triggers the reference scan on its file. Completion now counts a false line left standing as a miss.
- Fixed rules landing in a nested file that is never injected for the file that triggers them. Placement now starts from the trigger file (the file an agent edits or runs when the rule applies): the rule lives in the lowest context file that is in context before that edit, so a rule triggered by a root-level file goes to root under a condition even when the lesson was learned inside a subtree.
- Fixed context files written for a human reader. Agents copied the user's explanations into instructions (keyboard shortcuts, GUI actions, "ask the operator"). The writing-style rule now states that the reader is never a person: no operator steps unless the agent runs them, no tool identities or workflow narration it cannot act on, the user appearing only as decision-maker, one rule per bullet. Founder language is allowed only while it steers a product decision code cannot yet express.

## [1.0.2] - 2026-09-29

### Added

- Added a **Project scope** section. The project is the git repository containing the session start directory (`git rev-parse --show-toplevel`); the skill edits only `AGENTS.md` or `CLAUDE.md` files at or below that root. Every context file outside it is read-only unless the user's current request names it by path or name; a request to remember a fact names no file, so the agent asks which file to use and edits only after the user names one; outside any repository, the skill edits nothing. Conflict precedence and the Placement table work inside this boundary and never widen it.
- Added a **Reporting** section. The final answer mentions context files only after an edit (one sentence per changed file) or for a lesson with no home inside the project (named as a candidate for the user). With no edit and no candidate it says nothing, except when the user invoked the skill or asked for a context-file change, where one sentence explains why nothing changed. This replaces the mandatory trailing `AGENTS.md: ...` line of 1.0.1.

### Changed

- Changed the Placement row "Personal preference across repos → user-level agent config" to "Machine, tool, or personal fact that is true outside this project → no file; name it as a candidate for the user".
- Changed the audit to discover the project's context files and to report, not edit, a contradiction with a file outside the project. The wrap-up compares the project's AGENTS.md files, not every loaded file.
- Changed the runtime facts: startup loading is described as the session's start directory, every parent directory up to the filesystem root, and user-level scopes, with the note that the `<project_instructions>` tag does not show whether a file is in the project. The earlier wording named the global file `~/.pi/agent/AGENTS.md` as one of three scopes.
- Removed the writing-style allowance for first-person voice, humor, and taste in personal and global files, which the skill no longer edits.

### Fixed

- Fixed agents editing the user's global AGENTS.md without being asked. Reading the skill for a "remember this" request, agents followed the placement row that routed personal preferences to user-level configuration and wrote there; sessions started outside any repository had no boundary at all. Now the Project scope boundary applies, the uncertain-edit rule names the lesson as a candidate instead of placing it, and an explicit request that names the global file still succeeds.

## [1.0.1] - 2026-09-28

### Added

- Added a **Wrap-up check** section: at the end of a coding task the agent lists lesson candidates (command lines that differ word for word from the command that worked, a new app or package, a generated file, secret, or migration with special rules, a trap worked around, a wrong turn taken twice), runs each through the Write Gate and Placement, makes the smallest edit, and ends the final answer with one `AGENTS.md: <file>: <change and reason>` or `AGENTS.md: no change (<reason>)` line.
- Added **Manifest** to the glossary: any file at a repository or package root that names runnable commands, in any ecosystem.

### Changed

- Changed the command rule. Before, commands were the one exception to the Write Gate ("an agent cannot guess a command it has never seen; keep every command"). Now commands pass the same gate: a command that a manifest (`package.json` or `deno.json` scripts, `Makefile`, `justfile`, `Taskfile.yml`, `pyproject.toml`, `Cargo.toml`, `composer.json`, `mix.exs`, `build.gradle`) or a toolchain default (`cargo test`, `go test ./...`) already names gets no line; a command is recorded only for a fact the manifest does not show (which one to run before handoff, a required wrapper, environment variable, or service, a slow or dangerous run, no manifest entry), and that fact is its What-it-does cell. Existing command lines are kept and corrected, never deleted for brevity. The Placement root row, the Condition section, and the worked example follow the rule: `bun run dev` and plain `bun run test` left the example's command table, `bun run check` stayed with its handoff fact.
- Changed the completion criterion to cross-check every trap and every misstated command from the session, instead of every command executed.

### Fixed

- Fixed the skill not being read at wrap-up, or AGENTS.md being edited from the description alone. The description now makes the skill a required final step of every coding task, including a one-line fix, to be read before the final answer and before any AGENTS.md or CLAUDE.md edit, and states that the description is not enough to edit them correctly. The earlier description listed the lesson types and asked the agent to "invoke this skill to place it".

## [1.0.0] - 2026-08-25

First release of the `agentsmd` skill, installed with `npx skills add edxeth/agentsmd-skill`.

### Added

- Added the skill body ([SKILL.md](skills/agentsmd/SKILL.md)): `AGENTS.md` hierarchies for Pi coding agents are designed on two axes, Placement (root, nested, doc, skill, or executable check) and Condition (foundational rules bare, conditional rules behind a narrow trigger). `CLAUDE.md` is treated as the per-directory fallback name.
- Added the six-point **Write Gate** (Durable, Repo-specific, Behavior-changing, Right-homed, Single-sourced, Evidence-backed) with "no edit" as the default, commands kept as the one exception, no secret-bearing or one-off destructive command ever recorded, and package-only commands kept in the package's nested file.
- Added the **Placement** table (root, nested at the lowest directory whose descendants all need it, docs with a pointer, skill, executable check, conversation, user-level config, nowhere), the root-versus-nested rule built on on-read injection, and the one-file, one-task negative case.
- Added **Condition** forms: trigger-prefixed bullets as the portable default and `<important if>` blocks as an unvalidated hypothesis recorded in [ADR 0001](skills/agentsmd/docs/adr/0001-conditional-relevance-blocks.md), with a falsification path.
- Added the layered **file shape** template (identity, project map, commands table, conditional bullets), with no self-path in the body and no root pointer to a nested file while on-read injection is active.
- Added the **Audit and update** procedure (discover the active first-match file, classify each line, resolve contradictions, smallest coherent edit, verify commands), line budgets (root near 20 content lines, over 40 a prune signal, over 100 documentation), a completion criterion, and the pointer to `/writing-for-agents` for full rewrites with a no-search guard when it is absent; [EXAMPLE.md](skills/agentsmd/EXAMPLE.md) walks one rewrite end to end.
- Added writing style, conflict precedence (user request, nearest nested, root, default behavior), and the three tiers of uncertain edits.
- Added the verified **Pi runtime facts**: startup scopes, on-read injection of nested files (closest first, once per session, exact filename, 32 KB truncation), the first-match chain `AGENTS.override.md`, `AGENTS.md`, `AGENTS.MD`, `CLAUDE.md`, `CLAUDE.MD`, worktree shadowing, and `--no-context-files`.
- Added the glossary (Placement, Condition, Foundational, Conditional, Durable, Command), the README, and the MIT license.
