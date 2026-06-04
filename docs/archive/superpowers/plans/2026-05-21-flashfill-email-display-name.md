# Flash Fill Email Display Name Plan

## Tasks

- [x] Identify that Flash Fill could extract email usernames but not convert dotted usernames to display names.
- [x] Add a focused red test for `ada.lovelace@contoso.com` -> `Ada Lovelace`.
- [x] Add a conservative single-column detector for two-part dotted email usernames.
- [x] Keep the detector before generic delimiter extraction so the richer pattern wins.
- [x] Document the architecture and command-parity tracker updates.

## Decisions

- The detector only accepts two nonnumeric username parts separated by a dot and followed by `@`.
- Output uses the existing invariant proper-case helper for deterministic display names.
- Full Excel ML-like Flash Fill inference remains outside scope.
