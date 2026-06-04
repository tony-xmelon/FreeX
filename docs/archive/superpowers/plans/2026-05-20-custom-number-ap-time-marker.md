# Custom Number Compact AM/PM Marker Fidelity Plan

## Tasks

- [x] Identify that Excel `A/P` compact AM/PM markers were treated as literal text.
- [x] Add focused tests for morning and afternoon `h:mm A/P` formats.
- [x] Include compact markers in 12-hour clock detection.
- [x] Map `A/P` and `a/p` to the single-letter .NET designator used by the invariant formatter.
- [x] Document the architecture and command-parity decision.

## Decisions

- Compact markers stay in the deterministic formatter path and use invariant `A`/`P` output.
- `A/P` participates in the same 12-hour-clock decision as `AM/PM`, so PM values render as `1:34 P` rather than `13:34 P`.
- Lowercase `a/p` is accepted as input, but localized/lowercase designator fidelity remains outside the current locale subset.
