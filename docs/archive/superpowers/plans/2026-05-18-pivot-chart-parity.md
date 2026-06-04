# PivotChart Parity Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add Excel-style PivotCharts that stay bound to PivotTables, render using FreeX's existing chart surface, and round-trip native `.xlsx` PivotChart metadata.

**Architecture:** PivotCharts are `ChartModel` instances with explicit PivotTable binding metadata, not a parallel chart subsystem. PivotTable refresh materializes the pivot output and synchronizes bound chart ranges; XLSX chart parts read/write `<c:pivotSource>` while keeping existing chart-series OOXML behavior. UI command work builds on the existing chart insertion and PivotTable command patterns.

**Tech Stack:** C#/.NET 10, FreeX.Core.Model, FreeX.Core.Commands, FreeX.Core.IO OOXML package writer/reader, xUnit/FluentAssertions.

---

### Task 1: PivotChart Model And Command Binding

**Files:**
- Modify: `src/FreeX.Core.Model/ChartModel.cs`
- Modify: `src/FreeX.Core.Commands/ChartCommands.cs`
- Modify: `tests/FreeX.Core.Model.Tests/ChartCommandTests.cs`

- [x] Add failing tests for creating a PivotChart from an existing PivotTable and rejecting a missing PivotTable.
- [x] Add `IsPivotChart`, `PivotTableName`, and `PivotCacheId` to `ChartModel`.
- [x] Add `AddPivotChartCommand` that finds the PivotTable, refreshes it, calculates the materialized pivot output range, and adds a bound chart.
- [x] Verify undo removes the bound chart without changing the PivotTable.

### Task 2: PivotTable Refresh Keeps PivotCharts Current

**Files:**
- Modify: `src/FreeX.Core.Commands/PivotTableRefreshService.cs`
- Modify: `src/FreeX.Core.Commands/PivotTableCommands.cs`
- Modify: `tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.cs`

- [x] Add a failing test where source data grows, `RefreshPivotTableCommand` runs, and the bound PivotChart range expands to the new materialized pivot output.
- [x] Add `GetMaterializedOutputRange` by scanning the PivotTable target range after refresh.
- [x] Update `RefreshPivotTableCommand` to update charts bound to the refreshed PivotTable.

### Task 3: XLSX PivotChart Read/Write Metadata

**Files:**
- Modify: `src/FreeX.Core.IO/XlsxChartPartReader.cs`
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Modify: `tests/FreeX.Core.IO.Tests/XlsxChartPartReaderTests.cs`
- Modify: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`

- [x] Add failing chart-reader test for `<c:pivotSource><c:name>Data!PivotTable1</c:name></c:pivotSource>`.
- [x] Add failing save/load smoke test for authored PivotChart XML containing `<c:pivotSource>`.
- [x] Read `pivotSource` into `ChartModel` pivot binding metadata.
- [x] Write `pivotSource` for bound PivotCharts before `<c:chart>`.
- [x] Ensure normal charts remain unchanged.

### Task 4: UI Entry Point

**Files:**
- Modify: `src/FreeX.App.Host/MainWindow.xaml`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Test: `tests/FreeX.App.Host.Tests`

- [x] Add an Insert PivotChart command entry for sheets with existing PivotTables.
- [x] Invoke `AddPivotChartCommand` using the first selected/available PivotTable and default column chart.
- [x] Add host-level command wiring tests if an existing command test seam is available.

### Task 5: Docs And Verification

**Files:**
- Modify: `docs/FIDELITY_CONTRACT.md`
- Modify: `docs/XLSX_CORPUS_REPORT.md`
- Modify: `docs/COMMAND_SURFACE_PARITY.md`
- Modify: `docs/NEXT_PHASES_PLAN.md`

- [x] Mark PivotCharts as model/read/write/refresh supported, with field buttons and filtering UI wired through the PivotTable filter/sort menu; full PivotChart layout/design editing remains partial.
- [x] Run `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --filter "PivotChart|PivotTableRefresh"`.
- [x] Run `dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --filter "PivotChart|XlsxChartPartReader"`.
- [x] Run full model, IO, app-host tests and `dotnet build FreeX.slnx`.
