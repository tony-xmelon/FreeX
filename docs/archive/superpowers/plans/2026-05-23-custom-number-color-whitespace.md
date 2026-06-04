# Custom Number Color Whitespace

## Goal

Improve custom number format color parsing for Excel-style bracketed color tokens with spaces inside the brackets.

## Scope

- Accept optional whitespace around named colors such as `[ Red ]`.
- Accept optional whitespace around indexed colors such as `[ Color5 ]`.
- Keep existing named and indexed color mappings unchanged.
- Update architecture and command parity documentation.

## Verification

- Red: focused Core.Calc formatter color tests failed because spaced color tokens returned no color.
- Green: focused Core.Calc formatter color tests passed.
- Full solution build.
