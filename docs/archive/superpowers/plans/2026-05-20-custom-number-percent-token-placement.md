# Custom Number Percent Token Placement Plan

## Tasks

- [x] Identify that active percent tokens were always appended at the end of the formatted text.
- [x] Add focused tests for percent-before-suffix placement and multiple active percent tokens.
- [x] Count active percent tokens outside quotes and escapes.
- [x] Scale once per active percent token and replace active tokens with in-place percent literals before .NET formatting.
- [x] Document the architecture and command-parity decision.

## Decisions

- Active percent tokens are converted to quoted percent literals after FreeX applies Excel's 100x-per-token scaling.
- Quoted and escaped percent signs remain literal and do not contribute to scaling.
- This preserves visible token position for common formats such as `0% "done"` without moving to a full custom-number parser.
