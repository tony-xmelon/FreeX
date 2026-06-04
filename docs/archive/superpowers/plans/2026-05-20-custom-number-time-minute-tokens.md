# Custom Number Time Minute Token Fidelity Plan

## Tasks

- [x] Identify Excel `m`/`mm` date-time ambiguity in custom number formats.
- [x] Add focused tests for `h:mm:ss`, `hh:mm AM/PM`, and combined date/time formats.
- [x] Map `m`/`mm` to .NET minute tokens when adjacent to hour or second tokens, and to month tokens otherwise.
- [x] Document the architecture and command-parity decision.
- [x] Run focused verification before commit.

## Decisions

- The formatter keeps a deterministic heuristic rather than a full Excel parser: adjacency to `h/H` or `s/S` marks `m/mm` as minutes.
- Date-only formats such as `m/d/yyyy` continue to render months.
- Elapsed-time bracket formats remain handled by the dedicated `[h]`, `[m]`, `[s]` renderer.
