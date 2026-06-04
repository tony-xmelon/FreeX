# Custom Number Fractional Seconds Fidelity Plan

## Tasks

- [x] Identify the Excel custom date/time gap for `.0`, `.00`, and `.000` fractional-second tokens.
- [x] Add focused tests proving fractional seconds render actual milliseconds instead of literal zeros.
- [x] Map fractional-second zero runs after seconds tokens to .NET fractional-second tokens.
- [x] Round the formatted `DateTime` to the requested fractional-second precision to match Excel display behavior.
- [x] Document the architecture and command-parity decision.

## Decisions

- Fractional-second tokens are recognized only when the zero run follows an Excel seconds token, keeping numeric zero placeholders outside date/time formats unchanged.
- The formatter rounds the `DateTime` at display time for fractional-second formats because Excel rounds visible precision while .NET custom `f` tokens truncate.
- This remains part of the deterministic custom-number subset; broader locale and calendar fidelity stay outside this slice.
