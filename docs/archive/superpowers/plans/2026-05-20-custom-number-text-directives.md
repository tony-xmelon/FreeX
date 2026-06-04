# Custom Number Text Directive Fidelity Plan

## Tasks

- [x] Identify remaining custom number-format text-section leakage for Excel `_` spacer and `*` fill directives.
- [x] Add focused formatter tests for accounting-style text sections, fill directives, quoted literals, and escaped `@`.
- [x] Update `NumberFormatter` text-section rendering to skip layout directives and honor escaped literals.
- [x] Document the architecture and command-parity decision.
- [x] Run focused verification, commit, merge to `main`, push, then continue with the next sensible fidelity slice.

## Decisions

- Text-section `_` and `*` tokens are treated as layout-only directives and removed from displayed text.
- Backslash escapes in text sections emit the escaped character literally, matching the existing numeric custom-format behavior.
- Exact accounting layout width remains outside the formatter; the grid stores/display strings rather than Excel's cell-layout expansion model.
