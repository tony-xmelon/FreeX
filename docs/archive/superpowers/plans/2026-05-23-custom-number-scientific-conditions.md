# Custom Number Scientific Conditions

## Goal

Improve Excel custom-number condition fidelity by recognizing signed and scientific numeric thresholds in section predicates.

## Scope

- Extend `NumberFormatter` condition parsing from plain decimals to signed decimal and exponent notation.
- Cover formats such as `[>=1E3]0,"K";0` and `[>=+100]0;0.00`.
- Update architecture and command parity notes.

## Verification

- Focused `CustomNumberSubset_UsesConditionalSections` tests.
- Full `NumberFormatterTests`.
- Full solution build.
