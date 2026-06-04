# PivotTable UI Parity Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Complete the remaining non-excluded PivotTable parity surface by adding Excel-like authoring UI, field controls, PivotChart controls, and slicer/timeline filtering on top of the existing refresh engine.

**Architecture:** Keep `PivotTableModel` and `ConfigurePivotTableLayoutCommand` as the mutation boundary. Add focused WPF panels/dialogs that produce model snapshots and execute undoable commands; refresh and PivotChart synchronization continue to flow through existing command services.

**Tech Stack:** C#/.NET 10, WPF/XAML, FreeX.Core.Model, FreeX.Core.Commands, FreeX.Core.IO, xUnit/FluentAssertions.

---

### Task 1: Layout Command And Value Field Settings Foundation

**Files:**
- Modify: `src/FreeX.Core.Commands/PivotTableCommands.cs`
- Modify: `src/FreeX.Core.Model/PivotTableModel.cs`
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Test: `tests/FreeX.Core.Model.Tests/PivotTableCommandTests.cs`
- Test: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`

- [x] Permit values-only PivotTables through `ConfigurePivotTableLayoutCommand`; Excel allows no row fields when at least one value field exists.
- [x] Add value-field settings metadata needed by UI: custom name, summary function, number format id, and "show values as" baseline mode.
- [x] Round-trip value-field settings through authored PivotTable XML.
- [x] Apply percent-of-grand-total display values across row-only, column-only, matrix, and values-only layouts.

### Task 2: PivotTable Field List Pane

**Files:**
- Modify: `src/FreeX.App.Host/MainWindow.xaml`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Test: `tests/FreeX.App.Host.Tests/MainWindowXamlKeyTipTests.cs`

- [x] Add a right-side Field List pane that appears when the selection is inside a PivotTable.
- [x] Populate fields from the PivotTable cache/source headers with row/column/value/filter zone lists.
- [x] Add move buttons for Rows, Columns, Values, Filters, and Remove; each applies `ConfigurePivotTableLayoutCommand`.
- [x] Keep the pane keyboard reachable and visually close to Excel's right task pane.
- [x] Add drag/drop field reordering and checkbox toggles in the field list.

### Task 3: Field Dropdowns And Value Settings UI

**Files:**
- Modify: `src/FreeX.App.Host/MainWindow.xaml`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Test: `tests/FreeX.App.Host.Tests/MainWindowXamlKeyTipTests.cs`

- [x] Add field dropdown commands for sort ascending/descending, clear filter, and value settings entry points.
- [x] Add checked item selection and label/value filter command entry points.
- [x] Replace prompt-based filter commands with the full Excel checkbox/filter popup chrome.
- [x] Add a Value Field Settings entry point for summary function, display name, and show-values-as.
- [x] Route sort/filter changes through undoable pivot commands and refresh the output range.
- [x] Replace prompt-based value settings with a full Excel-like tabbed dialog including number format.

### Task 4: Contextual PivotTable Analyze And Design UI

**Files:**
- Modify: `src/FreeX.App.Host/MainWindow.xaml`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Test: `tests/FreeX.App.Host.Tests/MainWindowXamlKeyTipTests.cs`

- [x] Add contextual Analyze and Design tabs shown/enabled when a PivotTable is selected.
- [x] Add commands for Field List, Refresh, Change Data Source, Show Details, PivotChart, Grand Totals, Subtotals, Report Layout, Blank Rows, and Style Gallery.
- [x] Wire layout/style commands to existing PivotTable model flags and refresh behavior.
- [x] Make Change Data Source and layout/style toggles fully undoable model commands.

### Task 5: PivotChart Field Buttons And Filtering

**Files:**
- Modify: `src/FreeX.App.UI/ChartRenderer.cs`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Test: `tests/FreeX.App.UI.Tests`
- Test: `tests/FreeX.App.Host.Tests`

- [x] Render PivotChart field buttons for bound charts.
- [x] Add button menus that reuse PivotTable field filter/sort commands.
- [x] Keep chart data range synchronized after filter changes.

### Task 6: Slicer And Timeline Interaction

**Files:**
- Modify: `src/FreeX.Core.Model/SlicerModel.cs`
- Modify: `src/FreeX.Core.Model/TimelineModel.cs`
- Modify: `src/FreeX.App.Host/MainWindow.xaml`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Test: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`
- Test: `tests/FreeX.App.Host.Tests`

- [x] Add selected-item state to slicer models.
- [x] Add active date-range filtering state to timeline models.
- [x] Render slicer tiles and timeline ranges in the workbook surface/task pane.
- [x] Apply slicer selections to connected PivotTables via field selected-items metadata.
- [x] Apply timeline selections to connected PivotTables via date grouping metadata.
- [x] Persist authored slicer/timeline state where FreeX owns the model.

### Task 7: Verification And Documentation

**Files:**
- Modify: `docs/COMMAND_SURFACE_PARITY.md`
- Modify: `docs/FIDELITY_CONTRACT.md`
- Modify: `docs/XLSX_CORPUS_REPORT.md`
- Modify: `docs/NEXT_PHASES_PLAN.md`

- [x] Update parity docs with implemented UI, remaining excluded items, and known deferrals.
- [x] Run pivot model tests, pivot IO tests, host UI tests, App.UI tests, and full solution build.
