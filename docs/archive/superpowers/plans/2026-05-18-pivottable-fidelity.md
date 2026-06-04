# PivotTable Fidelity Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Move PivotTables from a basic single-value sum slice toward Excel-like functional fidelity for existing and authored PivotTables.

**Architecture:** Keep `PivotTableModel` as the source of truth and expand the refresh engine rather than adding a parallel pivot subsystem. Refresh reads source rows, applies page-field filters, groups by all row fields plus the first column field, evaluates all data fields with Excel-style summary functions, writes a static materialized grid, and keeps bound PivotCharts synchronized.

**Tech Stack:** C#/.NET 10, FreeX.Core.Model, FreeX.Core.Commands, FreeX.Core.IO OOXML, xUnit/FluentAssertions.

---

### Task 1: Aggregation Semantics

**Files:**
- Modify: `src/FreeX.Core.Model/PivotTableModel.cs`
- Modify: `src/FreeX.Core.Commands/PivotTableRefreshService.cs`
- Test: `tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.cs`

- [x] Add failing tests for multiple row fields, multiple data fields, and non-sum summaries (`count`, `average`, `min`, `max`, `product`, `countNums`).
- [x] Add optional selected-item filtering to `PivotFieldModel`.
- [x] Rewrite refresh around reusable grouping and aggregation helpers.
- [x] Keep existing row-only and row/column matrix tests green.

### Task 2: Page Field Filtering

**Files:**
- Modify: `src/FreeX.Core.Commands/PivotTableRefreshService.cs`
- Test: `tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.cs`

- [x] Add failing test for a page field that filters source rows before aggregation.
- [x] Apply all selected page-field filters before grouping.
- [x] Verify PivotChart output-range sync still follows filtered materialized output.

### Task 3: XLSX Metadata For Expanded Fields

**Files:**
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Test: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`

- [x] Add failing save/load smoke test for multiple row fields, page fields, and summary functions.
- [x] Preserve optional page-field selected item metadata when FreeX authors PivotTables.
- [x] Keep native PivotTable package preservation unchanged for unrelated edits.

### Task 4: App Command Surface

**Files:**
- Modify: `src/FreeX.App.Host/MainWindow.xaml`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Test: `tests/FreeX.App.Host.Tests/MainWindowXamlKeyTipTests.cs`

- [x] Replace the deferred PivotTable Insert button with a working creation path for the selected range.
- [x] Add visible Refresh PivotTable command for the active sheet/selection.
- [x] Keep the remaining PivotChart layout/design and deep PivotStyle gaps explicit in docs.

### Task 5: Docs And Verification

**Files:**
- Modify: `docs/FIDELITY_CONTRACT.md`
- Modify: `docs/XLSX_CORPUS_REPORT.md`
- Modify: `docs/COMMAND_SURFACE_PARITY.md`
- Modify: `docs/NEXT_PHASES_PLAN.md`

- [x] Mark PivotTables as functional for creation, refresh, multiple data fields, common summaries, page filters, and PivotChart sync.
- [x] Run `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --filter "PivotTableRefresh|PivotTableCommand|PivotChart"`.
- [x] Run `dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --filter "PivotTable|PivotChart"`.
- [x] Run full model, IO, host tests and `dotnet build FreeX.slnx`.

### Task 6: Subtotals, Calculated Fields, And Drill-Down

**Files:**
- Modify: `src/FreeX.Core.Model/PivotTableModel.cs`
- Modify: `src/FreeX.Core.Commands/PivotTableRefreshService.cs`
- Modify: `src/FreeX.Core.Commands/PivotTableCommands.cs`
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Modify: `src/FreeX.App.Host/MainWindow.xaml`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Test: `tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.cs`
- Test: `tests/FreeX.Core.Model.Tests/PivotTableCommandTests.cs`
- Test: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`
- Test: `tests/FreeX.App.Host.Tests/MainWindowXamlKeyTipTests.cs`

- [x] Add failing tests for outer row-field subtotals, calculated-field aggregation, and source-row drill-down extraction.
- [x] Add PivotTable model support for subtotal flags and calculated fields.
- [x] Evaluate calculated fields during pivot refresh with arithmetic field-reference formulas.
- [x] Add command-backed Show Details drill-down sheet creation with undo.
- [x] Round-trip authored subtotal and calculated-field pivot metadata through XLSX.
- [x] Add Insert ribbon Show Details entry point.
- [x] Add double-click Show Details gesture before cell edit fallback.
- [x] Run host tests and `dotnet build FreeX.slnx` after double-click gesture wiring.

### Task 7: Grouping, Filters, And Calculated Items

**Files:**
- Modify: `src/FreeX.Core.Model/PivotTableModel.cs`
- Modify: `src/FreeX.Core.Commands/PivotTableRefreshService.cs`
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Test: `tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.cs`
- Test: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`

- [x] Add failing tests for multi-select page filters, date grouping, top-N value filters, and calculated items.
- [x] Add model primitives for field grouping, value filters, and calculated items.
- [x] Apply grouping/filter semantics during PivotTable refresh.
- [x] Persist grouping/filter/calculated-item metadata through authored PivotTable XML.
- [x] Run full model, IO, formula, host tests and `dotnet build FreeX.slnx`.

### Task 8: Number Grouping, Advanced Filters, Sorting, And Layout Command

**Files:**
- Modify: `src/FreeX.Core.Model/PivotTableModel.cs`
- Modify: `src/FreeX.Core.Commands/PivotTableRefreshService.cs`
- Modify: `src/FreeX.Core.Commands/PivotTableCommands.cs`
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Test: `tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.cs`
- Test: `tests/FreeX.Core.Model.Tests/PivotTableCommandTests.cs`
- Test: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`

- [x] Add failing tests for number grouping, label filters, threshold value filters, value sorting, and layout editing.
- [x] Add model primitives for number grouping, label filters, threshold value filters, and sort settings.
- [x] Apply number grouping, label/value filtering, and sort semantics during refresh.
- [x] Add undoable command-level PivotTable field layout editing.
- [x] Persist number grouping, label filters, value thresholds, and sort metadata through authored PivotTable XML.
- [x] Run pivot-focused model/IO tests, full model/IO/host tests, and `dotnet build FreeX.slnx`.
- [ ] Full formula suite is blocked by unrelated Phase B distribution failures (`KURT`, `GAMMA.DIST`, `BETA.DIST`, `SKEW`, `T.TEST`).

### Task 9: Layout Flags And Style Metadata

**Files:**
- Modify: `src/FreeX.Core.Model/PivotTableModel.cs`
- Modify: `src/FreeX.Core.Commands/PivotTableRefreshService.cs`
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Test: `tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.cs`
- Test: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`

- [x] Add failing tests for hiding grand totals, suppressing repeated outer labels, and inserting blank lines after outer items.
- [x] Add model primitives for grand-total visibility, repeated-label behavior, blank-line spacing, and PivotTable style names.
- [x] Apply row/matrix layout options during refresh.
- [x] Persist layout flags and style names through authored PivotTable XML.
- [x] Run full model/IO tests and `dotnet build FreeX.slnx`.

### Task 10: Nested Column Field Matrices

**Files:**
- Modify: `src/FreeX.Core.Commands/PivotTableRefreshService.cs`
- Test: `tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.cs`
- Test: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`

- [x] Add failing refresh test for two column fields materialized as nested column headers.
- [x] Generalize matrix refresh from a single column field to composite column keys.
- [x] Preserve single-column matrix behavior.
- [x] Assert authored XLSX round-trip keeps multiple column fields.
- [x] Run pivot-focused model and IO tests.

### Task 11: Separate Row And Column Grand Totals

**Files:**
- Modify: `src/FreeX.Core.Model/PivotTableModel.cs`
- Modify: `src/FreeX.Core.Commands/PivotTableRefreshService.cs`
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Test: `tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.cs`
- Test: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`

- [x] Add failing tests for hiding the right-side row grand-total column independently from the bottom column grand-total row.
- [x] Keep `ShowGrandTotals` as the compatibility switch for both axes.
- [x] Apply separate row/column grand-total flags in matrix refresh output, including the bottom-right overall total cell.
- [x] Round-trip separate row/column grand-total metadata through authored PivotTable XML.
- [x] Run pivot-focused model and IO tests.

### Task 12: No-Row Layouts And Detail Extraction Fidelity

**Files:**
- Modify: `src/FreeX.Core.Commands/PivotTableRefreshService.cs`
- Test: `tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.cs`

- [x] Add failing tests for values-only and column-only PivotTable materialization.
- [x] Materialize values-only PivotTables without a synthetic grand-total row.
- [x] Materialize column-only PivotTables with column headers and right-side grand totals.
- [x] Add failing tests for matrix, grand-total, subtotal, repeated-label-off, and column-only Show Details extraction.
- [x] Filter Show Details rows by row keys, column keys, subtotal prefixes, grand totals, and inferred repeated labels.
- [x] Run pivot-focused model tests.

### Task 13: Column-Axis Filters And Sorting

**Files:**
- Modify: `src/FreeX.Core.Model/PivotTableModel.cs`
- Modify: `src/FreeX.Core.Commands/PivotTableRefreshService.cs`
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Test: `tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.cs`
- Test: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`

- [x] Add failing tests for label filters applied to PivotTable column fields.
- [x] Apply column-axis label filters before writing matrix/column-only headers.
- [x] Recompute row and column grand totals from visible column items after filters.
- [x] Add optional source-field targeting to value filters for Excel-like row/column axis semantics.
- [x] Apply source-field-targeted value filters to column fields.
- [x] Round-trip value-filter source-field metadata through authored PivotTable XML.
- [x] Add failing tests for label sorting of column fields.
- [x] Sort column keys by the targeted column-field label while preserving row sort behavior.
- [x] Run pivot-focused model and IO tests.

### Task 14: Field Item Selection, Subtotal Placement, And Drill-Down Guards

**Files:**
- Modify: `src/FreeX.Core.Model/PivotTableModel.cs`
- Modify: `src/FreeX.Core.Commands/PivotTableRefreshService.cs`
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Test: `tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.cs`
- Test: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`

- [x] Add failing tests for value sorting targeted at column fields.
- [x] Sort column keys by aggregate value while keeping row-axis sorting scoped to row fields.
- [x] Add failing tests for top-of-group subtotal placement.
- [x] Add `PivotSubtotalPlacement` and render row-field subtotals above or below each outer group.
- [x] Round-trip `subtotalTop` metadata through authored PivotTable XML.
- [x] Apply checked-item selection filters to row and column fields, not only page fields.
- [x] Round-trip row/column selected-item metadata through authored PivotTable XML.
- [x] Prevent Show Details extraction from row-label cells; only data-area cells return source detail rows.
- [x] Run pivot-focused model and IO tests.
