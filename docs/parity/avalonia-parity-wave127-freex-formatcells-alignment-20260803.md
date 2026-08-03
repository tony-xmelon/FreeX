# Avalonia/WPF Parity Wave 127: FreeX Format Cells Alignment

Date: 2026-08-03

## Scope

Reduce the current-source visual residual for `dialog.FormatCells.Alignment`
at identical 620x540 logical size and 96 DPI, while preserving the existing
checkbox instances, automation IDs, and formatting behavior.

## Diagnosis and Fix

- Fresh WPF and Linux captures showed the first two 24px alignment controls
  already aligned within one pixel.
- The Avalonia Alignment checkboxes were forced to 20px by the shared dialog
  checkbox chrome, while the WPF authority's native 12pt rows measured about
  15px. The extra row height accumulated into a 14px lower-field drift.
- Added the shared `FormatCellsDialogAlignmentLayout.CheckBoxHeight` contract
  at 16px and applied it only to the three Alignment-tab checkbox instances.
  The global dialog checkbox styling and other Format Cells tabs are unchanged.
- A pane top-margin compensation was tested and reverted because it worsened
  the paired visual diff from 2.5714% to 2.7500%.

## Evidence

- WPF: current-source `FreeX.App.Host.exe --parity-capture --parity-capture-target dialog.FormatCells`.
- Avalonia: current-source Linux publish in Ubuntu 24.04 Docker/Xvfb via
  `tools/Run-LinuxParityCapture.ps1 --surface-id dialog.FormatCells.Alignment`.
- Both promoted PNGs are 620x540 at 96 DPI and nonblank.
- Focused `FreeX.ParityCompare` visual diff improved from `2.5714%` to
  `2.4652%`; the tool reported no hard regressions. The generated evidence
  summary's triage score improved from `0.086872` to `0.086598`.
- The remaining difference is primarily Linux text/control rasterization and
  the dialog frame; the canonical pair does not claim pixel identity.

## Verification

- `FormatCellsDialogPlannerTests.AlignmentLayout_UsesWpfDialogSpacingContract` passed with the 16px height contract.
- `CaptureParitySurfaces_CapturesFormatCellsAlignmentTabWithoutRunningInteractionContract` remains the focused rendered-surface coverage.
- The canonical manifests and generated JSON summary were refreshed only for
  this evidence pair; no cross-app dashboard was regenerated.
