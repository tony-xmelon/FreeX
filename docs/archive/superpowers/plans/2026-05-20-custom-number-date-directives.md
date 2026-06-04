# Custom Number Date Directive Fidelity Plan

## Tasks

- [x] Identify remaining custom number-format date/time-section leakage for Excel `_` spacer and `*` fill directives.
- [x] Add focused formatter tests for date/time layout directives and escaped date literals.
- [x] Update `NumberFormatter` date/time rendering to skip layout directives and preserve escaped literal case.
- [x] Document the architecture and command-parity decision.
- [x] Run focused verification before commit.

## Decisions

- Date/time `_` and `*` tokens are treated as layout-only directives and removed from displayed text, matching numeric and text-section cleanup.
- Backslash escapes are converted to explicit .NET date-format literals before token mapping so escaped letters are not interpreted or lowercased as date tokens.
- Exact accounting layout width remains outside the formatter because FreeX currently emits display strings, not Excel's cell layout expansion model.
