# PDF Bitmap Text Option Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an Excel-like PDF publish option that can suppress FreeX's selectable text overlay and export bitmap-only text when requested.

**Architecture:** `ExportOptions` remains the single command boundary for PDF/XPS publish choices. PDF export keeps the existing raster-first renderer; the new option only controls whether the PDF text overlay is emitted, and XPS summaries label it as PDF-only.

**Tech Stack:** C# 12, WPF, PDFsharp-WPF, xUnit, FluentAssertions.

---

### Task 1: Model and Apply Bitmap Text Export Option

**Files:**
- Modify: `src/FreeX.App.Host/ExportPlanner.cs`
- Modify: `src/FreeX.App.Host/ExportOptionsDialog.cs`
- Modify: `src/FreeX.App.Host/MainWindow.PrintExport.cs`
- Test: `tests/FreeX.App.Host.Tests/ExportPlannerTests.cs`

- [x] **Step 1: Write failing planner/dialog/workflow tests**

Add tests proving `ExportOptions` can carry the bitmap-text option, summaries describe it, the options dialog exposes a keyboard-accessible checkbox, and the export workflow passes `includeSelectableText: !options.BitmapTextWhenFontsMayNotBeEmbedded`.

- [x] **Step 2: Run the focused test slice and verify RED**

Run: `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --filter "ExportOptions|ExportWorkflow" --logger "console;verbosity=minimal"`

Observed: RED compile failure `CS1739` because `ExportOptions` does not yet have a `BitmapTextWhenFontsMayNotBeEmbedded` parameter.

- [x] **Step 3: Implement the minimal option plumbing**

Extend `ExportOptions`, `ExportOptionsDialog.CreateResult`, dialog UI, and `MainWindow.PrintExport` so bitmap-text requests suppress the PDF selectable overlay.

- [x] **Step 4: Verify GREEN**

Focused App.Host export tests passed: 17 passed, 0 failed.

- [x] **Step 5: Update docs and commit**

Update `docs/COMMAND_SURFACE_PARITY.md`, `docs/ARCHITECTURE.md`, and this plan checklist, then commit and merge/sync through `main`.
