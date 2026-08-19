# Conditional-relevance blocks in AGENTS.md

Pi loads every context file at startup and concatenates it into the always-on
system prompt, so uniformly-weighted instructions dilute attention for the rules
that matter in the current task. We adopted Dex Horthy's `<important if="condition">`
mechanism (from humanlayer's improve-claude-md skill) alongside trigger-prefixed
bullets: foundational content (project identity, map, commands) stays bare, while
task-specific guidance carries a narrow condition. Plain markdown is simpler and
portable to harnesses that ignore the tags; conditioned blocks buy better
instruction adherence in Pi at the cost of a non-standard format.
