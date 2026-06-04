# Custom Number Elapsed Fractional Seconds Fidelity Plan

## Tasks

- [x] Identify that elapsed-time formats use a separate renderer from clock date/time formats.
- [x] Add focused tests for `[h]:mm:ss.000`, `[m]:ss.00`, and `[s].0`.
- [x] Preserve fractional seconds when elapsed formats request visible precision.
- [x] Round elapsed seconds to the requested display precision so carry behavior is deterministic.
- [x] Document the architecture and command-parity decision.

## Decisions

- Elapsed fractional seconds are handled inside `FormatElapsedTime` because elapsed leading units such as `[h]`, `[m]`, and `[s]` are not compatible with .NET `DateTime` custom formatting.
- Fractional precision is recognized only after an elapsed seconds token (`ss`, `s`, or `[s]`) to avoid changing ordinary numeric zero placeholders.
- The implementation rounds total elapsed seconds before decomposing hours, minutes, and seconds so fractional carry updates the visible elapsed unit values.
