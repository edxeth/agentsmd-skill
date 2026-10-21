#!/bin/sh
# Candidate scan for stale references in context files. Prints every backticked
# span that looks like a path (it has a slash or an extension) and exists
# neither from the current directory (run it from the repo root) nor from the
# file's own directory. A span with arguments passes when its first word
# exists, so commands pass. Spans with placeholders (<...>), globs (*), URLs,
# and variables are skipped; names without a slash or extension are not
# scanned. Hits are candidates: dismiss commands, package names, and files the
# runtime creates by eye.
# Exit 0: scan completed with no hits. 1: hits. 2: usage or unreadable input.
# Usage: sh check-refs.sh AGENTS.md packages/db/AGENTS.md
set -u
[ "$#" -ge 1 ] || { echo "usage: $0 <context-file>..." >&2; exit 2; }
status=0
for f in "$@"; do
  [ -f "$f" ] && [ -r "$f" ] || { echo "$0: not a readable file: $f" >&2; exit 2; }
  dir=$(dirname "$f")
  spans=$(grep -oE '`[^`]+`' "$f"); rc=$?
  [ "$rc" -le 1 ] || { echo "$0: cannot scan $f" >&2; exit 2; }
  [ "$rc" -eq 0 ] || continue
  printf '%s\n' "$spans" | tr -d '`' | grep -E '/|\.[A-Za-z0-9]+$' |
    grep -vE '^(https?://|[$~])|[<>*]' | sort -u |
    while IFS= read -r span; do
      first="${span%% *}"
      [ -e "$span" ] || [ -e "$dir/$span" ] || [ -e "$first" ] || [ -e "$dir/$first" ] || echo "$f: $span"
    done | grep . && status=1
done
exit $status
