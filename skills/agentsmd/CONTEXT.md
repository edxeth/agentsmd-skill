# agentsmd

The domain of designing and maintaining AGENTS.md instruction hierarchies for
Pi coding agents: deciding what guidance becomes durable instruction, where it
lives, and when it applies.

## Language

**Placement**:
The *where* axis — which file a rule lives in: root AGENTS.md, nested AGENTS.md,
docs, skill, or executable check. Resolved by the lowest common directory rule.
_Avoid_: location

**Condition**:
The *when* axis — the task trigger that makes a rule relevant inside a loaded
file. Expressed as an `<important if="...">` block or a trigger-prefixed bullet.
_Avoid_: filter

**Foundational**:
Relevant to nearly every task in a file's scope; written bare, with no condition.
_Avoid_: global

**Conditional**:
Relevant only to a specific kind of work; always carries a Condition.
_Avoid_: optional

**Durable**:
Likely to remain true beyond the current task or session.
_Avoid_: permanent, timeless

**Command**:
An exact runnable invocation (test, build, lint, dev). Recorded only with a
fact that its Manifest does not show.
_Avoid_: task, script example

**Manifest**:
Any file at a repo or package root that names runnable commands, in any
ecosystem: `package.json` scripts, `Makefile` or `justfile` targets,
`pyproject.toml`, `Cargo.toml`, and similar.
_Avoid_: config
