# Page Layout Print/Export Residual - 2026-06-08

Worker branch: `codex/page-layout-print-export-residual-20260608`

Worker worktree: `.worktrees/page-layout-print-export-residual-20260608`

## Scope

Inspected Page Layout print/export parity for a representative workbook with an `A1`-anchored used range selected, focused on Page Setup, Print Titles, Breaks, Background, Scale to Fit, and related Backstage print/export planning. Titlebar/QAT, formula, AutoFilter, chart, draw, and data import areas were avoided except where existing print/export renderer tests mention them.

## Evidence

- `MainWindow.PageLayout.cs` routes Print Area set/clear, Breaks, Background choose/clear, Print Titles, Scale to Fit, Page Setup, and print gridline/headings commands through worksheet model commands.
- `PageSetupDialog` seeds Sheet-tab repeat row/column fields and Page-tab scaling fields from the active sheet, and range-picker formatting converts the current selection into Excel-style print area, repeat-row, or repeat-column text.
- `MainWindow.PrintExport.cs` passes `SheetGrid.SelectedRange` into `PrintRenderer.RenderWorksheet` only for `ExportContentScope.Selection`.
- `PrintRenderer.RenderWorksheet` honors an explicit `printRangeOverride` ahead of print area or full used range, so selected-range export is already wired through the planner and renderer.
- `PrintSettingsPlanner` and `PrintPreviewSettingsPanelFactory` cover active-sheet preview, print area, ignore-print-area, paper/orientation/margins/scaling, gridlines, and headings. Full Excel Backstage "Print Selection" editing remains a cataloged gap rather than a narrow residual fix.

## Fix Made

Excel does not allow manual page breaks before row 1 or column A. The previous FreeX Page Layout Breaks planner used `Math.Max(2, selected row/column)`, so an `A1:D10` used-range selection could incorrectly create row 2 and column B page breaks. The host parser also accepted `row 1`, `col 1`, and `col A` even though `SetPageBreaksCommand` rejected those values later.

This slice aligned Page Layout Breaks with the command model:

- Reject first-row and first-column manual page break entries in `PageLayoutInputParser`.
- Stop Insert/Remove Page Break menu actions from inventing row 2 or column B when the selected range starts at `A1`.
- Added focused parser/dialog/planner coverage for the `A1`-anchored used-range case.

## Guard Recommendations

- Keep `A1`-anchored used-range selections in Page Layout Breaks coverage; they exercise the boundary where Excel cannot insert a manual break on either axis.
- Add live Backstage output inspection for selected-range PDF/XPS export once the foreground save-dialog harness is available; planner/renderer coverage is good, but reader-level PDF/XPS verification remains open.
- Treat Print Preview selection scope as an explicit future Backstage parity item. Current FreeX preview is active-sheet plus ignore-print-area, matching existing docs, while export already supports selected range.
