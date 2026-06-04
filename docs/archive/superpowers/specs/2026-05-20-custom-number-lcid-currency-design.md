# Custom Number LCID Currency Design

## Goal

Advance custom number-format parity for common Excel LCID currency tokens.

## Scope

- Preserve the visible currency symbol from bracket tokens such as `[$€-407]` and `[$£-809]`.
- Continue to ignore the locale identifier itself so display output remains deterministic and invariant-culture based.
- Keep existing conditional sections, color prefixes, escaped literals, fractions, scientific notation, elapsed time, and comma scaling behavior unchanged.
- Update command parity and architecture notes.

## Constraints

- Do not introduce OS-locale-dependent formatting in this slice.
- Do not attempt full Excel accounting spacing, localized currency names, or LCID-specific separators.
- Keep the logic centralized in `Core.Calc.NumberFormatter`.
