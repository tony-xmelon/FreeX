# Avalonia/WPF Parity Wave 128: FreeX Create Table

Date: 2026-08-03

## Scope

Bring the current `dialog.CreateTable` route to functional WPF parity before
tuning its visual layout, then compare fresh WPF and Linux Avalonia evidence at
the same 360x190 logical size and 96 DPI.

## Functional parity

- Both hosts consume the shared Create Table range parser and dialog layout
  contract, including the default checked header state and spacing constants.
- The range picker remains integrated with the shared pointing session: picker
  click enters selection mode, Enter applies the selected range, and Escape
  restores the original range. The picker is positioned before the range field
  to match WPF.
- Enter activates the default OK action; Escape activates Cancel. Invalid input
  shows a warning and returns focus to the range field with its text selected.
- The Avalonia production caller now follows WPF's styled table route, using
  the first gallery style and its banding mode rather than an unstyled insert.
- WPF targeted parity capture now supports `dialog.CreateTable` directly from
  current source, enabling honest paired evidence.

## Evidence and metrics

- WPF: direct `FreeX.App.Host --parity-capture --parity-capture-target
  dialog.CreateTable` capture, 360x190 PNG at 96 DPI.
- Avalonia: bounded Linux Docker/Xvfb `tools/Run-LinuxParityCapture.ps1`
  capture, `app_exit=0`, `capture_validated=true`, 360x190 PNG at 96 DPI.
- Prior canonical pair: WPF 540x285 at 144 DPI versus Avalonia 360x190 at
  96 DPI; triage score `0.085779`, sample delta `0.039980`, luma delta
  `0.004400`, non-background delta `0.041296`.
- Fresh promoted pair: both 360x190 at 96 DPI; triage score `0.044631`,
  sample delta `0.022440`, luma delta `0.002746`, non-background delta
  `0.019167`. This is a measurable improvement, not a claim of pixel identity.
- The generated summary reports zero nonblank PNG failures, zero logical
  dimension mismatches, zero expected-size mismatches, and zero high-delta
  review candidates at the 0.4 threshold.

## Verification

- Focused tests passed: Services 83, Presentation 10, WPF Host 16, Avalonia 9.
- Dialog inventory, visual evidence summary, and cross-app dashboard checks
  passed.
- Repository preflight passed.
- `dotnet build FreeX.slnx --configuration Release --no-restore` passed with
  zero warnings and zero errors.

## Remaining residuals

`dialog.CreateTable` is no longer in the top ten generated visual outliers. The
highest current FreeX rows remain `dialog.FormatCells.Alignment` at `0.086598`
and `dialog.PivotTableOptions.Display` at `0.069304`; remaining Create Table
differences are primarily native text/control rasterization and font metrics.
