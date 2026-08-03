# Wave123 FreeX Text to Columns

## Scope

This slice replaces stale, mismatched Text to Columns evidence with one shared
fixture and aligns the production Avalonia dialog with the current WPF dialog.

## Implementation

- Added `TextToColumnsParityFixture` as the shared authority for the four-row
  capture data, three-row preview limit, and `560x560` dialog size.
- Routed both WPF and Avalonia captures through the shared fixture.
- Added targeted WPF capture support for `dialog.TextToColumns`.
- Aligned Avalonia's compact dialog chrome, original-data-type group, preview
  height and columns, margins, and wizard action buttons with WPF.
- Kept all three wizard steps and production behavior intact.

## Fresh paired evidence

Both production hosts were captured on Windows at `560x560`:

- WPF: `artifacts/wave123-freex-texttocolumns-wpf-final/`
- Avalonia: `artifacts/wave123-freex-texttocolumns-avalonia-final/`
- Comparison: `artifacts/wave123-freex-texttocolumns-compare-final/`

The focused comparison reports `1.8922%` differing pixels, both surfaces
present, and no hard regression. The comparison executable's process exit was
nonzero only because its global name-box contract is intentionally absent from
this one-dialog input; `parity-report.json` records this dialog as passed.

## Verification

- Focused Text to Columns presentation tests: 128/128 passed.
- WPF production host Release build: passed with 0 warnings and 0 errors.
- Avalonia production host Release build: passed with 0 warnings and 0 errors.
- Fresh WPF and Avalonia targeted captures: captured at `560x560`.

No Linux Docker capture was added in this recovered slice; the Avalonia
production host was rendered through its real Windows backend for the paired
geometry and visual comparison.
