# Custom Number Elapsed Directive Fidelity Plan

## Tasks

- [x] Identify remaining custom number-format elapsed-time leakage for Excel `_` spacer and `*` fill directives.
- [x] Add focused formatter tests for elapsed-time layout directives and escaped literals.
- [x] Update `NumberFormatter` elapsed-time rendering to skip layout directives and honor backslash escapes.
- [x] Document the architecture and command-parity decision.
- [x] Run focused verification before commit.

## Decisions

- Elapsed-time `_` and `*` tokens are treated as layout-only directives and removed before rendering `[h]`, `[m]`, or `[s]` formats.
- Backslash escapes in elapsed-time formats emit literal characters, matching text/date custom-format cleanup.
- Exact Excel fill-width expansion remains outside the formatter because FreeX emits deterministic display strings.
