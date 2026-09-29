# agentsmd-skill

A public `skills` package repo for the `agentsmd` skill.

`agentsmd` maintains AGENTS.md instruction files for AI coding agents. It answers three questions for every candidate rule:

- **Does it belong in a file at all?** A six-point Write Gate filters out generic advice, linter territory, patterns the agent can imitate from code, one-off task notes, and rules without evidence.
- **Where does it live?** Root AGENTS.md, nested AGENTS.md, docs, a skill, an executable check — or nowhere.
- **When does it apply?** Foundational rules stay bare. Task-specific rules carry a narrow condition: `<important if>` blocks or trigger-prefixed bullets.

The default action is "no edit". A command gets a line only when it carries a fact that its manifest does not show. A manifest is any root file that names runnable commands, in any ecosystem: `package.json`, `Makefile`, `justfile`, `pyproject.toml`, `Cargo.toml`, and similar.

Built and verified for the Pi coding agent. The runtime-facts section documents both context-file regimes: the startup upward walk and on-read injection of nested files. The general doctrine transfers to any harness that loads AGENTS.md or CLAUDE.md.

## Install

```bash
npx skills add edxeth/agentsmd-skill
```

## Included skill

### agentsmd

Create, update, audit, split, and prune AGENTS.md files, root or nested. The description makes the skill a required final step of every coding task: the agent reads the body before its final answer and runs the wrap-up check. It edits only context files inside the git repository of the session. Its final answer mentions context files only when a file changed or a lesson needs the user's decision. The agent also reads it before any AGENTS.md or CLAUDE.md edit.

Field-tested in live sessions on production codebases (vuejs/core, Effect-TS): manual invocation produced near-textbook output with evidence-based refusals. A live Pi benchmark with low-cost models like GLM-5.3-Flash and GPT-6-Luna (10 runs per scenario) measured autonomous firing on four coding tasks and a read-only question. The final AGENTS.md was correct in 100 of 100 runs. The agent read the skill in 78 of 80 coding runs and in 0 of 20 question runs.

Pairs with Matt Pocock's writing-for-agents — see [Recommended companions](#recommended-companions).

## What's inside

- **Write Gate** — six criteria each instruction must pass before it is written
- **Project scope** — edits stay inside the session's git repository; other context files change only when the user names them
- **Placement table and algorithm** — where guidance belongs, with the lowest-common-directory rule
- **Layered template** — identity and map bare, commands in a table, conditioned sections after
- **Update strategy** — delete, replace, move, and merge before you add
- **Pi runtime facts** — verified loader behavior: startup concatenation, `/reload`, the precedence chain, on-read nested injection, worktree shadowing
- **Worked example** — a messy AGENTS.md rewritten end to end, with removed, moved, and kept accounting
- **CONTEXT.md** — the skill's own glossary: Placement, Condition, Foundational, Conditional, Durable, Command, Manifest
- **ADR 0001** — conditional-relevance blocks recorded as a hypothesis, with a falsification path

## Recommended companions

### [writing-for-agents](https://github.com/mattpocock/skills/tree/main/skills/productivity/writing-for-agents)

The skill body references `/writing-for-agents` for full rewrites of bloated instruction files. With both installed, its full doctrine — pruning, information hierarchy, context pointers — arrives automatically. Without it, the skill falls back to its own Writing style rules and never searches for the missing skill.

### [pi-better-skills](https://github.com/edxeth/pi-better-skills)

Injects referenced skills' bodies whenever a skill loads, and resolves skill-bundled file paths. This is what turns the `/writing-for-agents` reference into the full doctrine instead of a bare name.

```bash
pi install git:github.com/edxeth/pi-better-skills
```

### [pi-ancestor-agentsmd](https://github.com/edxeth/pi-ancestor-agentsmd)

Injects nested AGENTS.md files into read results when the agent reads a file below the session root. The skill's placement doctrine is calibrated to this loader: nested files for read-touched subtrees, root under a condition otherwise.

```bash
pi install git:github.com/edxeth/pi-ancestor-agentsmd
```

Companions are optional. The skill degrades gracefully without each one.

## License

MIT
