# Custom Number Format Fidelity Design

**Status:** Approved for implementation

## Goal

Improve FreeX's custom number-format fidelity for common Excel format strings without expanding into full OS locale or LCID emulation.

## Scope

This slice upgrades the existing invariant-culture `NumberFormatter` support for:

- Bracketed numeric conditions such as `[>100]`, `[<=0]`, and section selection based on the first matching condition
  for numeric and date/time values.
- Combined color and condition prefixes such as `[Red][<0]0.00`.
- Indexed color prefixes `Color1` through `Color56`, mapped to FreeX's invariant default palette display colors and
  applied to numeric, date/time, and text sections.
- Escaped literals using backslash, including common suffix and prefix cases.
- Comma scaling for thousands and millions in custom numeric patterns.

The slice keeps current behavior for general numbers, dates, elapsed time, fractions, scientific notation, text sections, and accounting spacing unless a new test names a direct interaction.

## Architecture

`FreeX.Core.Calc.NumberFormatter` remains the single formatting engine used by the grid and status surfaces. The implementation adds a small internal section parser inside that class rather than introducing a new dependency or locale service. Parsed sections expose color, optional condition, and cleaned format text; number formatting then chooses the correct section before delegating to the existing numeric/date/fraction/scientific helpers.

## Non-Goals

- Full Excel locale/LCID behavior, localized currency names, or OS-specific accounting spacing.
- Full 56-color workbook palette/theme indexed-color fidelity.
- Full arbitrary custom format parsing beyond the tested subset.
- UI changes to the Format Cells dialog.

## Verification

Focused verification runs the `NumberFormatter` tests first, then the relevant app/command parity tests if docs are updated. Final branch verification runs the project test slice affected by `FreeX.Core.Calc` and any docs/parity tests touched by this change.
