# XLSX Pivot Models Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add model-first PivotTable and pivot-cache XLSX metadata loading while preserving native package parts across normal FreeX saves.

**Architecture:** Add lightweight PivotTable metadata records to `Core.Model`, populate them in `XlsxFileAdapter.Load()` from workbook and worksheet package relationships, and keep the existing package-preserving save path as the round-trip mechanism. Phase 1 does not calculate, refresh, render, or edit PivotTables.

**Tech Stack:** C# 13, .NET 10, ClosedXML for supported workbook I/O, `System.IO.Compression.ZipArchive` plus `System.Xml.Linq` for OOXML metadata.

---

### Task 1: Pivot Metadata Model

**Files:**
- Create: `src/FreeX.Core.Model/PivotTableModel.cs`
- Modify: `src/FreeX.Core.Model/Workbook.cs`
- Modify: `src/FreeX.Core.Model/Sheet.cs`
- Test: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`

- [ ] Write a failing test that loads an XLSX package containing minimal pivot cache and PivotTable parts and asserts `Workbook.PivotCaches` and `Sheet.PivotTables` expose parsed names, ids, source range, target range, and fields.
- [ ] Run `dotnet test tests/FreeX.Core.IO.Tests/FreeX.Core.IO.Tests.csproj --filter XlsxAdapter_LoadsPivotTableMetadata` and verify it fails because the model properties do not exist.
- [ ] Add the minimal model records and list properties.
- [ ] Run the focused test and verify compilation reaches the next missing loader behavior.

### Task 2: Pivot Metadata Loader

**Files:**
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Test: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`

- [ ] Extend the failing test fixture helper to inject workbook pivot-cache definition relationships and worksheet pivot-table relationships.
- [ ] Implement package parsing for pivot caches and pivot tables.
- [ ] Extract cache id, source worksheet/range, cache fields, pivot table name, cache id, location range, row fields, column fields, page fields, and data fields.
- [ ] Run the focused metadata test and verify it passes.

### Task 3: Pivot Package Round-Trip

**Files:**
- Modify: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`

- [ ] Write a failing test that saves a loaded workbook after editing a normal cell and asserts pivot table parts, pivot cache parts, content types, workbook relationships, worksheet relationships, and workbook pivot-cache references survive.
- [ ] Run the focused round-trip test and verify it fails if package references are dropped.
- [ ] Extend preservation only where needed so generated workbook/worksheet XML keeps pivot cache/table references from the source package.
- [ ] Run focused tests, then full `FreeX.Core.IO.Tests`, then `dotnet build FreeX.slnx`.

### Task 4: Docs And App Review Readiness

**Files:**
- Modify: `docs/FIDELITY_CONTRACT.md`
- Modify: `docs/DECISIONS/003-xlsx-fidelity.md`
- Modify: `docs/COMMAND_SURFACE_PARITY.md`

- [ ] Update docs so PivotTables are in the model-first implementation track, not permanently excluded.
- [ ] Keep the excluded feature list aligned with the user-approved out-of-scope list.
- [ ] Run `dotnet test tests/FreeX.Core.IO.Tests/FreeX.Core.IO.Tests.csproj` and `dotnet build FreeX.slnx`.
