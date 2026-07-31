# FreeX Wave 80: Quick Sort Header Parity

## Gap

The WPF Home/Data quick Sort A to Z and Sort Z to A handlers detect a labels-over-values header row and exclude it before creating the `SortCommand`. Avalonia's visible quick-sort route called `WorkbookSession.SortSelectedRange(bool)`, which passed the entire selection to the command. A selection containing `Name`/`Score` headers therefore sorted the header into the data rows.

## Fix

`FreeX.App.Avalonia.MainWindow.SortSelectedRange` now uses the existing shared `QuickAnalysisSelectionReader` header policy and the session's keyed sort overload. This preserves grouped-sheet propagation, undo/redo, and the existing Core `SortCommand` while excluding only a detected header row. Headerless selections still sort their first row as data.

## Evidence

- WPF authority: `src/FreeX.App.Host/MainWindow.DataFilterCommands.cs`, `SortAscButton_Click` and `SortDescButton_Click` call `ExcludeHeaderRowForQuickSort` before dispatch.
- Avalonia mismatch: the prior `SortSelectedRange(bool)` call routed the full selected range to `WorkbookSession.SortSelectedRange(bool)`.
- Tests: `AvaloniaQuickSortParityTests` executes the production ribbon registry for both directions, checks header preservation, undo restoration, and headerless first-row sorting.

## Residuals

This slice covers the quick A to Z/Z to A commands. Custom Sort continues to use its existing dialog-owned header choice, and AutoFilter dropdown sorting remains on its separate header-exclusion path.
