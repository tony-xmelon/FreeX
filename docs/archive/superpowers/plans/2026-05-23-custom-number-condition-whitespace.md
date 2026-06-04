# Custom Number Condition Whitespace

## Goal

Improve custom number format condition parsing for Excel-style bracketed conditions with spaces inside the brackets.

## Scope

- Accept optional leading/trailing whitespace around condition operators and threshold values.
- Keep the existing invariant signed/scientific numeric threshold behavior.
- Add a focused formatter regression test.
- Update architecture and command parity documentation.

## Verification

- Red: focused Core.Calc formatter test failed because `[ >= 100 ]` was not treated as a condition.
- Green: focused Core.Calc formatter condition tests passed.
- Full solution build.
