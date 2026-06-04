# Custom Number Month Initial Token Fidelity Plan

## Tasks

- [x] Identify that Excel `mmmmm` month tokens rendered as full .NET month names.
- [x] Add focused tests for January and February month-initial display.
- [x] Replace unquoted five-`m` tokens with culture-aware month initials before .NET date formatting.
- [x] Preserve quoted literals and escaped characters during the replacement pass.
- [x] Document the architecture and command-parity decision.

## Decisions

- `mmmmm` is handled as a pre-pass because .NET custom date formatting does not provide Excel's month-initial token.
- Month initials use the deterministic `DateTimeFormatInfo` already selected for the modeled LCID/invariant date format path.
- Quoted and escaped content remains literal and is not scanned for month-initial tokens.
