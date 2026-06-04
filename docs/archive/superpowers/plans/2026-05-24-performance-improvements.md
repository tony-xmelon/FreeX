# Performance Improvements Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make save asynchronous with footer progress, then use measurements/tests to continue optimizing load/save and selection navigation.

**Architecture:** Add a host-level save writer parallel to `OpenWorkbookLoader`, then wire it into `MainWindow.Backstage.cs` and the status bar. Keep IO adapters unchanged for the first slice so the UI no longer blocks, then profile adapter internals for true throughput improvements.

**Tech Stack:** C#, WPF, xUnit, FluentAssertions, .NET async tasks.

---

### Task 1: Async Save With Footer Progress

**Files:**
- Create: `src/FreeX.App.Host/SaveWorkbookWriter.cs`
- Modify: `src/FreeX.App.Host/MainWindow.Backstage.cs`
- Modify: `src/FreeX.App.Host/MainWindow.xaml`
- Test: `tests/FreeX.App.Host.Tests/SaveWorkbookWriterTests.cs`

- [ ] Write a failing test proving save runs through the adapter, writes bytes, and reports progress.
- [ ] Run the focused test and verify it fails because `SaveWorkbookWriter` does not exist.
- [ ] Implement the writer with staged progress.
- [ ] Run the focused test and verify it passes.
- [ ] Wire `SaveButton_Click`, `SaveWorkbookWithDialog`, and related callers to await async save.
- [ ] Add footer progress controls and hide them after completion.
- [ ] Run host tests and full solution tests.

### Task 2: Selection Toolbar Profiling And Deduplication

**Files:**
- Inspect: `src/FreeX.App.Host/MainWindow.Selection.cs`
- Inspect: `src/FreeX.App.Host/MainWindow.Ribbon*.cs`
- Test: targeted host tests based on the selected hot path.

- [ ] Trace selection-to-toolbar update flow.
- [ ] Add a failing test for duplicate formatting-state updates.
- [ ] Cache or compare toolbar state before applying WPF control changes.
- [ ] Run focused tests and solution tests.

### Task 3: IO Throughput Profiling

**Files:**
- Inspect: `src/FreeX.Core.IO/XlsxFileAdapter*.cs`
- Inspect: `src/FreeX.Core.IO/NativeJsonAdapter*.cs`
- Test: core IO tests or focused benchmark-style unit tests with deterministic input.

- [ ] Measure large workbook save/load hotspots with existing test fixtures or generated workbooks.
- [ ] Add focused regression tests around any optimized mapper.
- [ ] Replace high-cost XML/collection work only where measurements identify it.
- [ ] Run IO tests and solution tests.
