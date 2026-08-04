# FreeX Print Preview Selected Range Parity: Wave 150

Date: 2026-08-04

## Gap

WPF Print Preview switches to a selected-range render by passing `SheetGrid.SelectedRange` to
`PrintRenderer.RenderWorksheet` as `printRangeOverride` with `ignorePrintArea: true`. Avalonia's
settings rail exposed no usable Selection scope: it always reported `hasSelection: false` and its
preview context paginated the configured print area or used range.

## Behavior

Avalonia now enables Print Selection when the active sheet has a valid selection. Switching between
Active Sheets and Selection repaginates the live preview immediately. Selection uses the exact single-
or multi-cell `GridRange`, bypasses the configured print area like WPF, and keeps the selected scope
after nested Page Setup returns and refreshes the preview.

Normal active-sheet previews still delegate to the shared multi-area pagination context. The transient
selection override is intentionally kept in `FreeX.App.Avalonia`; no shared or other platform host
contract was widened.

## Evidence

- `Wave150PrintPreviewSelectionParityTests` covers single-cell and multi-cell page content, live
  Active Sheets/Selection transitions, and nested Page Setup orientation refresh.
- Existing `R118_PrintPreviewSettingsRailInteractiveTests`, preview source guards, and selection gates
  remain green.

## Residual boundary

Avalonia Print Preview still previews one active sheet at a time; Print Entire Workbook remains
disabled in the live rail. Native platform print-dialog behavior remains platform-owned and is not
part of this selection-preview fix.
