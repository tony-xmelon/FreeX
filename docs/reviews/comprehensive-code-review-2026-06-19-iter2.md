# Comprehensive Code Review - 2026-06-19 Iteration 2

Branch: `codex/review-iterate-20260619-2`

Base reviewed: `origin/main` at `adc7c90e`

Scope: second full review/fix cycle across Avalonia save/edit behavior, XLSX tooling save diagnostics, structural command recalculation contracts, and structured-table totals materialization.

## Findings

### P1 - Avalonia formula editing can mutate the live workbook during save

`SaveWorkbookToTargetAsync` serializes `_session.Workbook` while `_isSaving` is true, but the formula bar Enter/Tab path called `CommitFormulaBox()` directly. That path committed `_session.CommitCellText(...)` without checking `_isSaving`, so a keyboard edit could mutate the same workbook instance while the save service was serializing it.

Fix: `FormulaBox_KeyDown` and `CommitFormulaBox` now block commits while opening or saving.

### P1 - Structural formula rewrites do not report rewritten formulas as affected cells

Insert/delete row/column/cell commands rewrite formulas through `RowColumnShiftHelpers.RewriteAllFormulas`, but their `CommandOutcome.AffectedCells` either omitted affected cells entirely or only returned the edited range. Incremental recalculation depends on this list to refresh formula values and dependencies, so formulas rewritten outside the directly edited range could keep stale dependency graph edges.

Fix: structural commands now add rewritten formula addresses from the rewrite snapshot to their affected-cell outcome.

### P2 - Avalonia save warnings are discarded

`WorkbookSaveService.SaveAsync` returns warnings from XLSX saves, and the WPF host surfaces them, but Avalonia awaited the save task and ignored the returned warnings before reporting a clean save.

Fix: Avalonia now captures save warnings and includes warning count in the save-completion status.

### P2 - XLSX diagnostic tools hide lossy save warnings

`FreeX.ExcelOpenSmoke` and `FreeX.SheetFidelity` saved workbooks through `XlsxFileAdapter.Save`, even though `SaveWithWarnings` exists to report non-fatal data loss. A smoke run could therefore pass while the FreeX save leg dropped comments, hyperlinks, or other warnable content.

Fix: both tools now save through `SaveWithWarnings`; the smoke tool carries save warnings into its report warning path and enforces them for supported corpus rows.

### P2 - Structured-table totals formulas are written as literal text

`RefreshStructuredTableTotalsCommand` converted `TotalsRowFormula` into `new TextValue(...)`, so explicit totals formulas were displayed and persisted as text rather than formulas.

Fix: explicit totals formulas now materialize as formula cells, and totals-row cells are reported as affected cells for recalculation.

## Resolution

Implemented and verified in this branch. Focused tests passed for the affected calc, model, IO/tooling, and Avalonia source-guard areas. Repository preflight passed, the normal full Release build timed out without a product error, the documented single-node/no-shared-compiler fallback full build passed, and the default non-UI test solution passed with `--no-build`.
