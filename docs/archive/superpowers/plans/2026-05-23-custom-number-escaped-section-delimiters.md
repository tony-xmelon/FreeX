# Custom Number Escaped Section Delimiters Plan

## Goal

Improve Excel custom number format fidelity for escaped semicolons (`\;`) so they render as literal text instead of splitting the format into separate positive/negative/zero/text sections.

## Checklist

- [x] Add a focused red test proving `0\;` renders a literal trailing semicolon.
- [x] Teach section splitting to carry escaped characters through before interpreting semicolons or brackets as format metadata.
- [x] Re-run the focused formatter test.
- [x] Run the full `NumberFormatterTests` suite and final branch verification.
- [x] Complete code review.
- [x] Commit, merge to `main`, and sync the branch from updated `main`.

## Architectural Decision

Escaped delimiters are handled in the section splitter instead of as a later numeric-rendering cleanup. Semicolons decide which format section applies, so a literal escaped semicolon must be preserved before section selection or the selected section is already wrong.
