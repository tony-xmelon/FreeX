# Excel Open Formats Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add open support for common Excel-compatible workbook formats beyond `.xlsx`, harden Excel parity for the implemented formats, and keep `.ods` parked until explicitly resumed.

**Architecture:** Extend the current `IFileAdapter` model with optional open aliases and save capability metadata, keeping existing adapters compatible. Reuse the XLSX load path for Open XML workbook/template formats, add a delimited text adapter for `.txt/.tsv/.tab`, and add a legacy `.xls` adapter backed by a read-only parser dependency.

**Tech Stack:** .NET 10, WPF, ClosedXML, ExcelDataReader for legacy binary `.xls`, xUnit/FluentAssertions.

---

### Task 1: Format Registry And Dialog Planning

**Files:**
- Create: `FreeX/src/FreeX.Core.IO/FileFormatDescriptor.cs`
- Create: `FreeX/src/FreeX.Core.IO/FileDialogFilterBuilder.cs`
- Modify: `FreeX/src/FreeX.Core.IO/IFileAdapter.cs`
- Modify: `FreeX/src/FreeX.Core.IO/FileSavePlanner.cs`
- Test: `FreeX/tests/FreeX.Core.IO.Tests/FileDialogFilterBuilderTests.cs`
- Test: `FreeX/tests/FreeX.Core.IO.Tests/FileSavePlannerTests.cs`

- [x] Write failing tests for open aliases, save-only filtering, and adapter resolution.
- [x] Run `dotnet test FreeX\tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --filter "FileDialogFilterBuilderTests|FileSavePlannerTests" -p:UseSharedCompilation=false -p:NodeReuse=false` and verify failure.
- [x] Add `FileFormatDescriptor` and default `IFileAdapter.Formats`.
- [x] Add filter builders and update save resolution to use save-capable descriptors.
- [x] Rerun the filtered tests and commit `Add workbook file format registry`.

### Task 2: Modern Open XML Aliases And Template Open Behavior

**Files:**
- Modify: `FreeX/src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Modify: `FreeX/src/FreeX.App.Host/OpenWorkbookLoader.cs`
- Modify: `FreeX/src/FreeX.App.Host/MainWindow.Backstage.cs`
- Modify: `FreeX/src/FreeX.App.Host/MainWindow.xaml.cs`
- Test: `FreeX/tests/FreeX.App.Host.Tests/OpenWorkbookLoaderTests.cs`
- Test: `FreeX/tests/FreeX.App.Host.Tests/MainWindowSourceHygieneTests.cs`

- [x] Write failing tests for `.xlsm/.xltx/.xltm` descriptors and template open metadata.
- [x] Run the focused host tests and verify failure.
- [x] Add `.xlsx/.xlsm/.xltx/.xltm` open descriptors to `XlsxFileAdapter`; keep save limited to `.xlsx`.
- [x] Make template opens clear the current path so Save routes to Save As.
- [x] Update Open/Save dialogs to use `FileDialogFilterBuilder`.
- [x] Rerun focused tests and commit `Open modern Excel workbook variants`.

### Task 3: Delimited Text Open Support

**Files:**
- Create: `FreeX/src/FreeX.Core.IO/DelimitedTextFileAdapter.cs`
- Modify: `FreeX/src/FreeX.Core.IO/CsvFileAdapter.cs`
- Modify: `FreeX/src/FreeX.App.Host/App.xaml.cs`
- Modify: `FreeX/src/FreeX.App.Host/MainWindow.DataCommands.cs`
- Test: `FreeX/tests/FreeX.Core.IO.Tests/DelimitedTextFileAdapterTests.cs`
- Test: `FreeX/tests/FreeX.Integration.Tests/IoRoundTripTests.cs`

- [x] Write failing tests for `.txt/.tsv/.tab` tab-delimited opens and quoted fields.
- [x] Run focused tests and verify failure.
- [x] Extract reusable delimited text parsing and keep CSV behavior unchanged.
- [x] Register tab-delimited text adapters and include them in Get Data.
- [x] Rerun focused tests and commit `Add delimited text workbook open support`.

### Task 4: Legacy `.xls` Read Support

**Files:**
- Modify: `FreeX/src/FreeX.Core.IO/FreeX.Core.IO.csproj`
- Create: `FreeX/src/FreeX.Core.IO/LegacyXlsFileAdapter.cs`
- Modify: `FreeX/src/FreeX.App.Host/App.xaml.cs`
- Test: `FreeX/tests/FreeX.Core.IO.Tests/LegacyXlsFileAdapterTests.cs`

- [x] Write failing tests proving `.xls` is open-only and maps workbook sheets plus basic scalar values.
- [x] Run focused tests and verify failure.
- [x] Add `ExcelDataReader` and `System.Text.Encoding.CodePages`.
- [x] Implement read-only `.xls` mapping and register the adapter.
- [x] Rerun focused tests and solution build, then commit `Add legacy XLS open support`.

### Task 5: Phase 3 `.ods` Research Note

Status: parked by user request while parity/hardening continues for the implemented formats.

**Files:**
- Create: `FreeX/docs/OPEN_FORMAT_PHASE3_ODS_RESEARCH.md`

- [x] Research maintained .NET ODS options from primary sources.
- [x] Document license, maintenance status, read fidelity, deployment impact, and recommendation.
- [x] Commit `Research ODS open support options`.

### Task 5a: Implemented Format Parity And Hardening

- [x] Name single-sheet text workbooks after the opened source file using Excel-compatible sheet-name rules.
- [x] Honor Excel CSV `sep=` delimiter directives.
- [x] Apply CSV `sep=` only to the first physical record.
- [x] Inspect unsupported package features for `.xlsx/.xlsm/.xltx/.xltm`.
- [x] Coerce imported booleans, numbers, percentages, formulas, error literals, ISO dates, and times in delimited text formats.
- [x] Preserve `DateTimeValue` when saving CSV.
- [x] Preserve leading blank row/column coordinates when saving CSV.
- [x] Preserve legacy `.xls` date cells as `DateTimeValue`.
- [x] Respect Excel's row/column limits during delimited text import.
- [x] Respect Excel's grid limits when saving CSV.
- [x] Honor `sep=<current delimiter>` directives for tab-delimited text files without switching to comma parsing.
- [x] Coerce ISO 8601 date/time values with `Z` or explicit offsets in delimited text imports.
- [x] Coerce the modeled `#CIRCULAR!` error literal in delimited text imports.
- [x] Coerce the `#GETTING_DATA` error literal in delimited text imports.
- [x] Coerce standalone AM/PM hour values in delimited text imports.
- [x] Preserve error-like text fields during CSV save/load round-trips.
- [x] Preserve whitespace-padded error-like text fields during CSV save/load round-trips.
- [x] Reuse delimiter buffers when saving delimited text rows.
- [x] Preserve parenthesized currency text fields during CSV save/load round-trips.
- [x] Preserve unsigned percentage text fields during CSV save/load round-trips.
- [x] Preserve boolean-like text fields during CSV save/load round-trips.
- [x] Preserve date/time-like text fields during CSV save/load round-trips.
- [x] Preserve unsigned currency text fields during CSV save/load round-trips.
- [x] Preserve numeric-like text fields during CSV save/load round-trips.
- [x] Avoid apostrophe marker leakage for ambiguous short date-like CSV text.
- [x] Preserve whitespace-padded percentage and parenthesized currency text during CSV round-trips.
- [x] Cover tab-delimited save/load round-trips for coercion-like text fields.
- [x] Preserve whitespace-padded signed currency text during CSV and tab-delimited round-trips.
- [x] Coerce and preserve newer Excel `#FIELD!` and `#BLOCKED!` delimited-text error literals.
- [ ] Continue corpus-driven hardening for Open XML package features and implemented text/legacy formats.

### Task 6: Final Verification And Integration

- [ ] Run focused IO, host, and integration tests.
- [ ] Run `dotnet build FreeX\FreeX.slnx -m:1 -p:UseSharedCompilation=false -p:NodeReuse=false`.
- [ ] Merge verified branch into `main`, push `main`, and sync this branch from updated `main`.
