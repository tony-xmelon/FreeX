# Flash Fill Underscore Email Display Name Plan

## Tasks

- [x] Identify that the email display-name detector only handled dotted usernames.
- [x] Add a focused red test for `ada_lovelace@contoso.com` -> `Ada Lovelace`.
- [x] Extend the detector to accept underscore-separated two-part usernames.
- [x] Re-run the dotted and underscored email display-name tests.
- [x] Document the architecture and command-parity tracker updates.

## Decisions

- The detector remains conservative: exactly two nonnumeric username parts, separated by either `.` or `_`.
- Hyphenated and multi-part usernames remain outside this slice to avoid overfitting ambiguous email local parts.
- Output continues to use invariant proper casing for deterministic results.
