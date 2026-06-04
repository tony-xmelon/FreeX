# Flash Fill Hyphen Email Display Name Plan

## Tasks

- [x] Identify that email display-name cleanup handled dot and underscore separators but not hyphen.
- [x] Add a focused red test for `ada-lovelace@contoso.com` -> `Ada Lovelace`.
- [x] Extend the detector to accept hyphen-separated two-part usernames.
- [x] Re-run the email display-name test group.
- [x] Document the architecture and command-parity tracker updates.

## Decisions

- Hyphen support follows the same conservative constraints as dot and underscore support: exactly two nonnumeric local-part segments.
- Multi-separator and multi-part email names remain outside the deterministic subset.
- The output remains invariant proper case rather than locale/person-name aware casing.
