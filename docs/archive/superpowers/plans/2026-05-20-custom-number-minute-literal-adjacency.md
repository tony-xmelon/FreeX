# Custom Number Minute Literal Adjacency Fidelity Plan

## Tasks

- [x] Identify that quoted literals between time tokens could cause `m`/`mm` to be treated as months.
- [x] Add focused tests for `h "hours" m "minutes"` while preserving date-only month behavior.
- [x] Make month/minute adjacency scans skip quoted literals and bracket metadata.
- [x] Document the architecture and command-parity decision.
- [x] Run focused formatter verification before merge.

## Decisions

- Quoted literals and bracketed metadata are transparent for the narrow purpose of deciding whether `m/mm` is near an hour or second token.
- Date-only formats remain month-biased when no neighboring hour or second token is found.
- This keeps the existing heuristic model rather than introducing a full Excel custom-format parser.
