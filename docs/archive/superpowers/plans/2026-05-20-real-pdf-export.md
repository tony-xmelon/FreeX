# Real PDF Export Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create real local PDF files for PDF export paths while preserving deterministic XPS export.

**Architecture:** Keep `PrintRenderer` as the single page-layout source. Add a `PdfDocumentExporter` service that writes a WPF `FixedDocument` to PDF pages, and update `ExportPlanner`/`MainWindow` to route `.pdf` paths to it.

**Tech Stack:** C# 12, .NET 10 WPF, PDFsharp-WPF 6.2.4, xUnit, FluentAssertions.

---

### Task 1: Planner and Exporter Tests

**Files:**
- Modify: `tests/FreeX.App.Host.Tests/ExportPlannerTests.cs`
- Create: `src/FreeX.App.Host/PdfDocumentExporter.cs`
- Modify: `src/FreeX.App.Host/ExportPlanner.cs`
- Modify: `src/FreeX.App.Host/FreeX.App.Host.csproj`

- [x] **Step 1: Write failing tests**

Add tests that `.pdf` plans as `Pdf` without XPS fallback and that `PdfDocumentExporter` writes a valid PDF header/trailer from a one-page `FixedDocument`.

- [x] **Step 2: Verify red**

Run:

```powershell
dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal --filter FullyQualifiedName~ExportPlannerTests
```

Expected: compile or assertion failure because `ExportFormat.Pdf` and `PdfDocumentExporter` do not exist yet.

- [x] **Step 3: Add PDF dependency and minimal exporter**

Add `PDFsharp-WPF` 6.2.4 to `FreeX.App.Host.csproj`. Implement `PdfDocumentExporter.Save(FixedDocument document, string path)` by rendering each `FixedPage` to a bitmap and drawing it onto a same-sized PDF page.

- [x] **Step 4: Verify green**

Run the same `ExportPlannerTests` command. Expected: all export tests pass.

### Task 2: MainWindow Integration and Docs

**Files:**
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Modify: `src/FreeX.App.Host/MainWindow.xaml`
- Modify: `tests/FreeX.App.Host.Tests/MainWindowSourceHygieneTests.cs`
- Modify: `tests/FreeX.App.Host.Tests/MainWindowXamlKeyTipTests.cs`
- Modify: `docs/COMMAND_SURFACE_PARITY.md`
- Modify: `docs/MENU_TOOLBAR_PARITY.md`
- Modify: `docs/ARCHITECTURE.md`
- Modify: `docs/DECISIONS/007-commands-parity-closeout.md`

- [x] **Step 1: Write/update failing source and tooltip tests**

Update tests to require `ExportAsPdf(request.Path)` and remove fallback wording from the PDF tooltip.

- [x] **Step 2: Wire PDF export**

Route `ExportFormat.Pdf` to `ExportAsPdf`, call `PdfDocumentExporter.Save`, and update success/failure messages.

- [x] **Step 3: Update docs**

Document that PDF export is implemented as print-faithful raster PDF via PDFsharp-WPF; full Excel PDF publish options remain partial.

- [x] **Step 4: Run verification**

Run:

```powershell
dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal --filter "FullyQualifiedName~ExportPlannerTests|FullyQualifiedName~MainWindowSourceHygieneTests|FullyQualifiedName~MainWindowXamlKeyTipTests|FullyQualifiedName~CommandParityStatusTests"
```

Expected: all focused App.Host tests pass.

- [ ] **Step 5: Commit and merge**

Commit the slice, merge it to `main`, push remotes, and start the next priority branch from updated `main`.

## Review Notes

- [x] Spec compliance review passed.
- [x] Code quality review passed.
- [x] Strengthened PDF exporter test to reopen the generated PDF and verify page count plus page dimensions.
