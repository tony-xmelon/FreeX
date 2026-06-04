# Formula Range Entry Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Let users edit formulas Excel-style by selecting cells or ranges in the grid to insert live formula references.

**Architecture:** Add a focused planner for formula reference text edits, then wire it into the existing inline editor, formula bar, keyboard navigation, and mouse selection paths. Keep the workbook model unchanged; this is an App.Host editing UX feature over existing `CellAddress`, `GridRange`, A1/R1C1 formatting, and edit commit services.

**Tech Stack:** WPF, FreeX App.Host, xUnit/FluentAssertions, existing `MainWindow.Editing.cs`, `MainWindow.Selection.cs`, `ExcelTextEditorPlanner`, and `SpreadsheetDisplayFormatter`.

---

### Task 1: Formula Reference Text Planner

**Files:**
- Create: `FreeX/src/FreeX.App.Host/FormulaRangeEntryPlanner.cs`
- Test: `FreeX/tests/FreeX.App.Host.Tests/FormulaRangeEntryPlannerTests.cs`

- [x] Write failing tests for inserting a first selected range after `=SUM(`, replacing a previous live reference, extending `A1` to `A1:B3`, and using R1C1 display text.
- [x] Run `dotnet test FreeX/tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --filter FormulaRangeEntryPlannerTests` and verify the tests fail because the planner does not exist.
- [x] Implement `FormulaRangeEntryPlanner.TryApplyRangeSelection` returning `ExcelTextEdit`.
- [x] Re-run the planner tests until green.

### Task 2: Editing Session Integration

**Files:**
- Modify: `FreeX/src/FreeX.App.Host/MainWindow.Editing.cs`
- Modify: `FreeX/src/FreeX.App.Host/MainWindow.Selection.cs`
- Test: `FreeX/tests/FreeX.App.Host.Tests/ExcelEditKeyPlannerTests.cs`

- [x] Write failing tests for formula edit key planning: arrows should select references instead of committing while formula range entry is active, while Enter/Tab still commit and move.
- [x] Run the focused tests and verify the expected failure.
- [x] Add edit-session fields for the formula anchor cell, active editor, and live inserted reference span.
- [x] Route grid keyboard/mouse selection through the planner when a formula editor is active.
- [x] Keep formula text synchronized between inline editor and formula bar.
- [x] Re-run focused tests.

### Task 3: Verification And Human Test Build

**Files:**
- Modify only files from Tasks 1-2 unless verification exposes a focused issue.

- [x] Run `dotnet test FreeX/tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --filter "FormulaRangeEntryPlannerTests|ExcelEditKeyPlannerTests"`.
- [x] Run `dotnet build FreeX/src/FreeX.App.Host/FreeX.App.Host.csproj -m:1 /nodeReuse:false -p:UseSharedCompilation=false`.
- [x] Launch the app for human testing from the feature worktree and report the URL/process instructions or executable state.
