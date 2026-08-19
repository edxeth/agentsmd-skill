# agentsmd-architect

The domain of designing and maintaining AGENTS.md instruction hierarchies for
Pi coding agents: deciding what guidance becomes durable instruction, where it
lives, and when it applies.

## Language

**Placement**:
The *where* axis — which file a rule lives in: root AGENTS.md, nested AGENTS.md,
docs, skill, or executable check. Resolved by the lowest common directory rule.
_Avoid_: location, scoping

**Condition**:
The *when* axis — the task trigger that makes a rule relevant inside a loaded
file. Expressed as an `<important if="...">` block or a trigger-prefixed bullet.
_Avoid_: trigger, filter

**Foundational**:
Relevant to nearly every task in a file's scope; written bare, with no condition.
_Avoid_: always-on, global

**Conditional**:
Relevant only to a specific kind of work; always carries a Condition.
_Avoid_: optional, scoped

**Durable**:
Likely to remain true beyond the current task or session; Write Gate criterion 1.
_Avoid_: permanent, timeless

**Command**:
An exact runnable invocation (test, build, lint, dev). Foundational reference
that survives pruning; never deleted for brevity, only corrected or deduplicated.
_Avoid_: task, script example
