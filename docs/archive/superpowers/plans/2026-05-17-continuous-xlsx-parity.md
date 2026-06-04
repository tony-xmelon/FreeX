# Continuous XLSX Parity Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Move FreeX toward full MS Excel XLSX parity without approval stops between feature phases.

**Architecture:** Use the executable XLSX corpus as the control surface. Each parity slice starts with a failing corpus/per-feature test, adds the smallest model/IO behavior needed to preserve or implement that feature, then updates docs and app copy only after tests pass.

**Tech Stack:** C#/.NET 10, ClosedXML, `ZipArchive`, `XDocument`, xUnit/FluentAssertions, WPF.

---

### Task 1: Corpus Harness Upgrade

**Files:**
- Modify: `tests/FreeX.Core.IO.Tests/XlsxCorpusRunnerTests.cs`
- Modify: `docs/XLSX_CORPUS_REPORT.md`

- [ ] Add per-feature summary fields for PivotTables, PivotCaches, structured tables, sparklines, charts, comments, hyperlinks, data validations, conditional formats, page setup, and object counts.
- [ ] Run `dotnet test tests/FreeX.Core.IO.Tests/FreeX.Core.IO.Tests.csproj --filter XlsxCorpusRunnerTests` and verify the summary comparison catches newly added fields.
- [ ] Update corpus report with the stronger comparison surface.

### Task 2: Structured Table Model-First XLSX Fidelity

**Files:**
- Create: `src/FreeX.Core.Model/StructuredTableModel.cs`
- Modify: `src/FreeX.Core.Model/Sheet.cs`
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Modify: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`

- [ ] Write a failing test for loading table metadata from `xl/tables/table1.xml`.
- [ ] Implement metadata model and loader.
- [ ] Write a failing test for preserving workbook/worksheet table references and table package parts after normal cell edits.
- [ ] Implement targeted table reference preservation.

### Task 3: PivotTable Behavior Slice

**Files:**
- Modify: `src/FreeX.Core.Model/PivotTableModel.cs`
- Create/modify commands under `src/FreeX.Core.Commands`
- Add tests under `tests/FreeX.Core.Model.Tests`

- [ ] Add a minimal in-memory PivotTable creation command that records source range, target range, row fields, and data fields.
- [ ] Add tests for command validation, undo/redo, and model state.
- [ ] Keep refresh/rendering out of this slice unless the tests require it.

### Task 4: Conditional Formatting Fidelity Slice

**Files:**
- Modify: `src/FreeX.Core.Model/ConditionalFormat.cs`
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Modify: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`

- [ ] Add icon set metadata tests.
- [ ] Add richer color scale/data bar option round-trip tests.
- [ ] Implement model/IO fields needed for those tests.

### Task 5: Chart/Object Fidelity Slice

**Files:**
- Modify: `src/FreeX.Core.Model/ChartModel.cs`
- Modify: `src/FreeX.Core.IO/XlsxChartPartReader.cs`
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Modify: chart/object tests.

- [ ] Add failing tests for one advanced chart family or unsupported chart package metadata retention.
- [ ] Add failing tests for one drawing/object formatting feature.
- [ ] Implement the smallest model/IO preservation needed.

### Task 6: Verification And App Review

**Files:**
- Modify docs touched by implemented slices.

- [ ] Run `dotnet test tests/FreeX.Core.IO.Tests/FreeX.Core.IO.Tests.csproj`.
- [ ] Run focused model/host tests touched by commands or UI copy.
- [ ] Run `dotnet build FreeX.slnx`.
- [ ] Launch the WPF app for review.
