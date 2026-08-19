# Conditional-relevance blocks in AGENTS.md

Pi concatenates every context file into the system prompt at startup and on
`/reload`. To keep task-specific guidance findable and cheap to obey, we adopted
Dex Horthy's `<important if="condition">` convention (from humanlayer's
improve-claude-md, MIT) alongside trigger-prefixed bullets: foundational content
(project identity, map, commands) stays bare; task-specific guidance carries a
narrow condition.

Status: hypothesis, not measured. The mechanism originates in Claude Code, where
it counters a system-reminder caveat Pi does not have, and its author disclaims
a rigorous explanation; the one controlled study we know of (Claude Code,
25–500 line files) found no adherence effect from length. The benefit in Pi —
across its many models — is unvalidated. Falsification path: a cross-model eval
comparing bare, trigger-prefixed, and important-if forms in Pi. If that eval
shows no effect, fall back to trigger-prefixed bullets and plain markdown.
