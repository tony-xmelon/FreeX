# Avalonia/WPF Parity Wave 121: FreeX Format Cells Alignment

Date: 2026-08-03

## Scope

This slice aligns the Avalonia Format Cells Alignment tab with the WPF authority
while keeping the shared formatting behavior and existing control automation IDs.

## Implementation

- Added `FormatCellsDialogAlignmentLayout` to the shared
  `FormatCellsDialogPlanner` service with the WPF Alignment-tab inset, label,
  checkbox, and control-height measurements.
- Updated the Avalonia Alignment tab to consume those shared measurements,
  preserve the existing checkbox instances, stretch both alignment dropdowns,
  and stretch the indent and rotation inputs across the content pane.
- Left the other Format Cells tabs on their existing layout helper path.

## Evidence

- WPF: fresh current-source `FreeX.App.Host --parity-capture --parity-capture-target dialog.FormatCells`.
- Avalonia: fresh current-source `linux-x64` publish, Ubuntu 24.04 Docker/Xvfb,
  `--parity-capture --parity-capture-surface dialog.FormatCells.Alignment`.
- Promoted pair:
  `docs/parity/dialog-visual-assets/wpf-capture/dialog.FormatCells.Alignment.png`
  and
  `docs/parity/dialog-visual-assets/avalonia-capture/dialog.FormatCells.Alignment.png`.
- Both frames are `620x540` at 96 DPI, nonblank, and the focused comparison is
  `2.5714%` mean pixel difference with no hard regression.
- The raw seven-surface capture and focused comparison are retained under
  `artifacts/wave121-freex-alignment/`.

## Verification

- `FormatCellsDialogPlannerTests`: 5 passed.
- `CaptureParitySurfaces_CapturesFormatCellsAlignmentTabWithoutRunningInteractionContract`: 1 passed.
- `dotnet build src/FreeX.App.Host/FreeX.App.Host.csproj --configuration Release --no-restore`: passed, 0 warnings, 0 errors.
- `dotnet build src/FreeX.App.Avalonia/FreeX.App.Avalonia.csproj --configuration Release --no-restore`: passed, 0 warnings, 0 errors.

The cross-app/global parity summaries were intentionally not regenerated in this
worker; integration owns those generated documents.
