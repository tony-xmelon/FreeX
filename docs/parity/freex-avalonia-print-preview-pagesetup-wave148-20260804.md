# FreeX Avalonia Print Preview Page Setup parity: Wave 148

## Mismatch

WPF's live Print Preview settings rail invokes its Page Setup callbacks when the user chooses
`Custom Margins...` or `Custom Scaling Options...`. Avalonia built the same visible choices, but its
`OpenCustomMargins` and `OpenPageSetup` action cases were no-ops, so either selection reverted without
opening a workflow or applying a page-setup change.

## Fix

The Avalonia live rail now opens the existing Page Setup dialog with the matching entry source
(`CustomMargins` or `ScaleToFit`) and re-paginates the still-open preview after the dialog closes.
The parity-capture fixture remains read-only and unchanged.

## Evidence and verification

- WPF authority: `src/FreeX.App.Host/PrintPreviewSettingsPanelFactory.cs` invokes `showCustomMargins`
  and `showPageSetup` for these shared planner actions.
- Avalonia behavioral coverage: `R118_PrintPreviewSettingsRailInteractiveTests` selects both custom
  choices through the real live preview rail and verifies that a real Page Setup window opens.
- Focused Release test: 4 passed, 0 failed.

## Residuals

The Avalonia preview still intentionally keeps Print Selection and native printer-properties routes
out of scope because its pagination and platform print APIs do not yet provide those WPF surfaces.
