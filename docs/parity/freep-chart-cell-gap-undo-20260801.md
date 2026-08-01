# FreeP Chart Gap Undo - 2026-08-01

`SetChartCellValueCommand` now preserves a missing chart point when an edit is
undone. Previously, the command captured `null` as `0.0`, so undo converted an
authored gap into a plotted zero. The command still accepts the existing numeric
edit surface, while its captured state is nullable and round-trips through the
normal chart workbook regeneration path.

## Verification

- Focused regression: `SetChartCellValue_Revert_RestoresMissingPointAsGap` passed.
- Full `ChartDataCommandTests`: 72/72 passed.

This is a functional chart-editing parity fix; it makes no new PowerPoint raster
baseline claim.
