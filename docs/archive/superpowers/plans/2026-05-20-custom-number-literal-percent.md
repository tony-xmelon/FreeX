# Custom Number Literal Percent Fidelity Plan

## Tasks

- [x] Identify that quoted and escaped percent literals incorrectly triggered percent scaling.
- [x] Add focused tests for active, quoted, and escaped percent signs.
- [x] Replace raw percent detection with a scanner that skips quoted and escaped literals.
- [x] Remove only active percent tokens before numeric formatting.
- [x] Document the architecture and command-parity decision.

## Decisions

- Percent scaling is driven only by active `%` tokens outside quotes and not preceded by an Excel escape.
- Quoted and escaped percent signs remain in the format string and are left to the existing literal formatting path.
- This does not implement every Excel literal edge case, but it prevents visible literal percent signs from changing numeric scale.
