# XLSX Performance Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [x]`) syntax for tracking.

**Goal:** Reduce large XLSX open/save time by removing pathological ClosedXML scans and avoidable sparse-cell copies.

**Architecture:** Keep the existing `XlsxFileAdapter` flow, but move high-cardinality metadata reads to direct Open XML package readers. Keep changes scoped to IO and preserve current model behavior with round-trip tests.

**Tech Stack:** C#, .NET, ClosedXML, `System.IO.Compression`, LINQ to XML, xUnit/FluentAssertions.

---

### Task 1: Direct Comment Loading

**Files:**
- Create: `src/FreeX.Core.IO/XlsxWorksheetCommentReader.cs`
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Test: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`

- [x] Add a direct comment reader that maps worksheet part paths to comment XML parts through worksheet relationships and returns `(row, column, text)`.
- [x] Replace `xlSheet.CellsUsed(XLCellsUsedOptions.All)` plus `GetComment()` with direct comment application.
- [x] Add a test that saves an XLSX with a comment, reloads it, and verifies the comment survives.
- [x] Run `dotnet test tests/FreeX.Core.IO.Tests/FreeX.Core.IO.Tests.csproj --filter XlsxAdapter`.

### Task 2: Direct Row/Column Layout Loading

**Files:**
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.SheetXmlLayout.cs`
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.LoadSheetXmlLayoutApplication.cs`
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Test: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`

- [x] Extend worksheet XML layout data to carry row heights, hidden rows, row outlines, column widths, hidden columns, and column outlines.
- [x] Apply that layout data to the `Sheet` model after cell import.
- [x] Remove `RowsUsed(AllFormats)` and `ColumnsUsed(AllFormats)` scans from the ClosedXML load path.
- [x] Add a load test that verifies row/column width, hidden, and outline metadata.

### Task 3: Conditional Package Sanitizer

**Files:**
- Modify: `src/FreeX.Core.IO/XlsxClosedXmlLoadPackageSanitizer.cs`
- Test: `tests/FreeX.Core.IO.Tests/XlsxFileAdapterFormatTests.cs`

- [x] Add a preflight that returns the original package stream when no sanitizer rewrite is required.
- [x] Preserve current sanitizer rewrites for unsupported constructs covered by existing tests.
- [x] Add a test for the no-op sanitizer path.

### Task 4: Save-Side Sparse Scans

**Files:**
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.Save.cs`
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.SavePostProcessing.cs`
- Modify: `src/FreeX.Core.IO/XlsxWorksheetDiagnosticsMapper.cs`
- Test: existing IO save tests

- [x] Replace save-side `GetUsedCells()` dictionary copies with `EnumerateCells()`.
- [x] Keep save output behavior unchanged for formulas, styles, diagnostics, and ignored errors.
- [x] Run the XLSX save-focused IO tests.

### Task 5: Benchmark And Integrate

**Files:**
- No production files required.

- [x] Run build and tests.
- [x] Re-run the large workbook benchmark and compare open/save stages.
- [ ] Commit the performance slice.
- [ ] Merge verified work to `main`.
- [ ] Sync `codex/performance-improvements` from updated `main`.
