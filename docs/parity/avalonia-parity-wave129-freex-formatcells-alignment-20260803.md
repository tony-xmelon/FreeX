# FreeX Wave129: Format Cells Alignment

## Scope

This bounded slice targets the highest current FreeX paired visual residual, `dialog.FormatCells.Alignment`, at the canonical 620x540 logical size and 96 DPI. WPF remains the layout authority through `src/FreeX.App.Host/FormatCellsDialog.xaml`.

## Diagnosis and change

- The Alignment content frame and controls now consume the shared WPF spacing contract from `FormatCellsDialogAlignmentLayout`, including the 20px tab header height.
- Shared Avalonia classic tab chrome now honors an explicit tab height with `Height` and `MaxHeight`, so the application-wide 24px tab style cannot override the WPF-aligned value.
- Format Cells combo boxes use the shared Windows-style combo chrome, matching the WPF light-gray interior and border metrics.
- Format Cells tab headers have a shared 54px minimum width. Fresh Alignment evidence shows the complete `Number`, `Alignment`, `Font`, `Border`, `Fill`, and `Protection` labels.
- Existing checkbox behavior, tab/focus traversal, Enter/Escape handling, automation IDs, localization, and the production dialog caller remain unchanged.

## Fresh evidence

Fresh matched WPF and Linux Docker/Xvfb captures were produced from this worktree at 620x540 and 96 DPI. Both captures completed successfully with seven Format Cells states and no blank or expected-size failures. The promoted evidence is intentionally limited to fresh Alignment: the fresh Avalonia Fill and Protection captures changed fixture state relative to WPF, so their canonical PNGs and manifest records remain unchanged.

The generated paired summary reports:

- Before: triage score `0.086598`.
- After: triage score `0.024344`.
- After sample mean delta `0.014197`, luma delta `0.002870`, and non-background delta `0.006998`.
- Alignment logical dimensions match and expected-size validation passes.

The focused parity report found zero hard-threshold regressions across the seven captured Format Cells states. Its nonzero process result is limited to the runner's unrelated name-box contract because this intentionally bounded directory contains no `popup.nameBoxDropdown` surface.

## Verification

- `FormatCellsDialogPlannerTests`: 5 passed.
- Avalonia focused lane covering shared compact chrome, Format Cells visual parity, and Format Cells tab focus graph: 6 passed.
- Dialog visual evidence summary regenerated with 94 paired surfaces, zero nonblank failures, and zero logical dimension mismatches.
- Cross-app parity dashboard regenerated and tested.
