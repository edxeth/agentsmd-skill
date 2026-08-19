# Conditional-relevance blocks in AGENTS.md

Pi concatenates every context file into the system prompt at startup and on
`/reload`. To keep task-specific guidance findable and cheap to obey, we adopted
Dex Horthy's `<important if="condition">` convention (from humanlayer's
improve-claude-md, MIT) alongside trigger-prefixed bullets: foundational content
(project identity, map, commands) stays bare; task-specific guidance carries a
narrow condition.

Status: hypothesis, not measured. The mechanism originates in Claude Code, where
it counters a system-reminder caveat. Pi does not have this caveat. The author
of the convention disclaims a rigorous explanation. The one controlled study we
know of, on Claude Code files of 25 to 500 lines, found no adherence effect
from length. The benefit in Pi, across its many models, is unvalidated.
Falsification path: a cross-model eval that compares bare, trigger-prefixed, and
important-if forms in Pi. If that eval shows no effect, fall back to
trigger-prefixed bullets and plain markdown.
