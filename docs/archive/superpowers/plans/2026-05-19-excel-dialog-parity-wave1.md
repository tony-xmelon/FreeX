# Excel Dialog Parity Wave 1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace prompt-based local workbook workflows with typed WPF dialogs and reusable picker components for Excel-like dialog parity.

**Architecture:** Keep workbook behavior in existing command/model classes and add thin WPF dialogs in `FreeX.App.Host` that return typed result objects. Shared helpers for color, border, range input, and checklist state should be implemented first so later dialogs stay small and consistent.

**Tech Stack:** C# 13/.NET 10, WPF XAML, xUnit, FluentAssertions, existing FreeX command and model types.

---

## File Structure

- Create `src/FreeX.App.Host/ColorPickerDialog.xaml` and `ColorPickerDialog.xaml.cs` for reusable Excel-style color selection.
- Create `src/FreeX.App.Host/BorderPickerPlanner.cs` for typed edge/style/color-to-`StyleDiff` mapping that both Format Cells and ribbon border flows can use.
- Create `src/FreeX.App.Host/CellShiftDialog.cs` for Insert Cells and Delete Cells choices.
- Create `src/FreeX.App.Host/GoToDialog.cs` and `GoToSpecialDialog.cs`.
- Create `src/FreeX.App.Host/SortDialog.cs` and `AutoFilterDialog.cs`.
- Create `src/FreeX.App.Host/TextToColumnsDialog.cs`, `RemoveDuplicatesDialog.cs`, `SubtotalDialog.cs`, `AdvancedFilterDialog.cs`, `ConsolidateDialog.cs`, and `DataTableDialog.cs`.
- Create `src/FreeX.App.Host/ScenarioManagerDialog.cs`.
- Create `src/FreeX.App.Host/ProtectionDialogs.cs`.
- Modify `src/FreeX.App.Host/MainWindow.xaml.cs` only to route existing prompt-based handlers through the new dialogs.
- Add focused tests under `tests/FreeX.App.Host.Tests`.

## Task 1: Shared Color Picker and Border Planner

**Files:**
- Create: `src/FreeX.App.Host/ColorPickerDialog.xaml`
- Create: `src/FreeX.App.Host/ColorPickerDialog.xaml.cs`
- Create: `src/FreeX.App.Host/BorderPickerPlanner.cs`
- Modify: `src/FreeX.App.Host/FormatCellsDialog.xaml`
- Modify: `src/FreeX.App.Host/FormatCellsDialog.xaml.cs`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Test: `tests/FreeX.App.Host.Tests/ColorPickerDialogTests.cs`
- Test: `tests/FreeX.App.Host.Tests/BorderPickerPlannerTests.cs`
- Test: `tests/FreeX.App.Host.Tests/FormatCellsDialogXamlTests.cs`

- [ ] **Step 1: Write failing color picker tests**

Add tests proving:

```csharp
ColorPickerDialog.BuildDefaultSwatches()
    .Select(swatch => swatch.Hex)
    .Should()
    .Contain(["#000000", "#FFFFFF", "#FF0000", "#00B050", "#0070C0"]);

ColorPickerDialog.TryParseColorText("#217346", out var parsed).Should().BeTrue();
parsed.Should().Be(new CellColor(0x21, 0x73, 0x46));

ColorPickerDialog.TryParseColorText("33,115,70", out parsed).Should().BeTrue();
parsed.Should().Be(new CellColor(33, 115, 70));
```

Run: `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --filter ColorPickerDialogTests -m:1`
Expected: FAIL because `ColorPickerDialog` does not exist.

- [ ] **Step 2: Implement minimal color picker**

Create a WPF dialog with:

- Title passed by constructor.
- Swatch grid with default Excel-like standard colors.
- Custom text field accepting `#RRGGBB` and `R,G,B`.
- Optional clear button controlled by constructor.
- `SelectedColor` result property.
- Public static `BuildDefaultSwatches()` and `TryParseColorText(...)` helpers for tests and reuse.

- [ ] **Step 3: Write failing border planner tests**

Add tests proving:

```csharp
var result = BorderPickerPlanner.CreateDiff(
    BorderPickerEdges.Outline,
    BorderStyle.Thick,
    new CellColor(1, 2, 3),
    new GridRange(new CellAddress(sheetId, 1, 1), new CellAddress(sheetId, 2, 2)),
    new CellAddress(sheetId, 1, 1));

result.BorderTop.Should().Be(new CellBorder(BorderStyle.Thick, new CellColor(1, 2, 3)));
result.BorderLeft.Should().Be(new CellBorder(BorderStyle.Thick, new CellColor(1, 2, 3)));
result.BorderBottom.Should().BeNull();
result.BorderRight.Should().BeNull();
```

Run: `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --filter BorderPickerPlannerTests -m:1`
Expected: FAIL because `BorderPickerPlanner` does not exist.

- [ ] **Step 4: Implement border planner**

Create a small planner that supports `All`, `Outline`, `Inside`, `Top`, `Right`, `Bottom`, `Left`, `None`, and returns `StyleDiff` using existing `BorderShortcutService` behavior where possible. Add explicit color application instead of always black.

- [ ] **Step 5: Route color prompts through dialog**

Modify these handlers in `MainWindow.xaml.cs`:

- `FontColorBtn_Click`
- `FillColorBtn_Click`
- `SheetCtxTabColor_Click`
- `SetSelectedDrawingObjectColor`

Each should show `ColorPickerDialog`, then execute the same existing commands with the selected `CellColor?`.

- [ ] **Step 6: Upgrade Format Cells color fields**

Keep existing text boxes for keyboard entry, but add `...` buttons next to font, fill, and border color fields that open `ColorPickerDialog` and write the selected color back to the text field.

- [ ] **Step 7: Verify Task 1**

Run:

```powershell
dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --filter "ColorPickerDialogTests|BorderPickerPlannerTests|FormatCellsDialogXamlTests" -m:1
```

Expected: PASS.

## Task 2: Cell Shift, Go To, and Go To Special Dialogs

**Files:**
- Create: `src/FreeX.App.Host/CellShiftDialog.cs`
- Create: `src/FreeX.App.Host/GoToDialog.cs`
- Create: `src/FreeX.App.Host/GoToSpecialDialog.cs`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Test: `tests/FreeX.App.Host.Tests/CellShiftDialogTests.cs`
- Test: `tests/FreeX.App.Host.Tests/GoToDialogsTests.cs`

- [ ] **Step 1: Write failing tests**

Add tests for:

- Insert dialog maps `Shift cells right`, `Shift cells down`, `Entire row`, `Entire column` to the current `InsertCellsShiftDirection` or row/column command path.
- Delete dialog maps `Shift cells left`, `Shift cells up`, `Entire row`, `Entire column` to the current `DeleteCellsShiftDirection` or row/column command path.
- Go To accepts `B5` and rejects invalid addresses.
- Go To Special exposes at least blanks, constants, formulas, comments, validation, and visible cells only.

Run: `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --filter "CellShiftDialogTests|GoToDialogsTests" -m:1`
Expected: FAIL because the dialog classes do not exist.

- [ ] **Step 2: Implement dialogs**

Create compact WPF code-only dialogs that return typed selections. Reuse `GoToSpecialInputParser` for special selection mapping.

- [ ] **Step 3: Route handlers**

Modify:

- `ExecuteKeyboardInsertCellsWithPrompt`
- `ExecuteKeyboardDeleteCellsWithPrompt`
- `InsertCellsMenuItem_Click`
- `DeleteCellsMenuItem_Click`
- `GoToBtn_Click`
- `GoToSpecialBtn_Click`

Keep existing command execution and error handling.

- [ ] **Step 4: Verify Task 2**

Run:

```powershell
dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --filter "CellShiftDialogTests|GoToDialogsTests|GoToSpecialInputParserTests|KeyboardInsertDeletePlannerTests" -m:1
```

Expected: PASS.

## Task 3: Sort and AutoFilter Dialogs

**Files:**
- Create: `src/FreeX.App.Host/SortDialog.cs`
- Create: `src/FreeX.App.Host/AutoFilterDialog.cs`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Test: `tests/FreeX.App.Host.Tests/SortDialogTests.cs`
- Test: `tests/FreeX.App.Host.Tests/AutoFilterDialogTests.cs`

- [ ] **Step 1: Write failing tests**

Add tests proving:

- Sort dialog result builds `IReadOnlyList<SortKey>` for one or more sort levels.
- AutoFilter dialog result supports checklist value selection and text/number criteria modes already accepted by the existing filter parser/commands.
- AutoFilter dialog exposes search text and select all/clear all behavior.

Run: `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --filter "SortDialogTests|AutoFilterDialogTests" -m:1`
Expected: FAIL because the dialog classes do not exist.

- [ ] **Step 2: Implement dialogs**

Use existing `SortInputParser`, filter command types, and `PivotFieldFilterDialog` checklist behavior as references. Keep result objects independent from `MainWindow`.

- [ ] **Step 3: Route handlers**

Modify `SortBtn_Click`, context sort/filter entry points, and `ApplyFilterPrompt` paths to use dialogs.

- [ ] **Step 4: Verify Task 3**

Run:

```powershell
dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --filter "SortDialogTests|AutoFilterDialogTests|AutoFilterDropdownPlannerTests" -m:1
```

Expected: PASS.

## Task 4: Data Tool Dialogs

**Files:**
- Create: `src/FreeX.App.Host/TextToColumnsDialog.cs`
- Create: `src/FreeX.App.Host/RemoveDuplicatesDialog.cs`
- Create: `src/FreeX.App.Host/SubtotalDialog.cs`
- Create: `src/FreeX.App.Host/AdvancedFilterDialog.cs`
- Create: `src/FreeX.App.Host/ConsolidateDialog.cs`
- Create: `src/FreeX.App.Host/DataTableDialog.cs`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Test: `tests/FreeX.App.Host.Tests/DataToolDialogTests.cs`

- [ ] **Step 1: Write failing tests**

Add tests proving each dialog maps UI choices to existing command options:

- Text to Columns delimiter choices: comma, semicolon, tab, space, custom.
- Remove Duplicates column checklist.
- Subtotal group column, subtotal columns, function, replace current subtotals, page break, summary below.
- Advanced Filter list range, criteria range, optional copy-to cell, unique records only.
- Consolidate source ranges, destination, and same-size validation.
- Data Table mode, formula cell, row input cell, and column input cell.

Run: `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --filter DataToolDialogTests -m:1`
Expected: FAIL because the dialog classes do not exist.

- [ ] **Step 2: Implement dialogs**

Use typed result records and existing parser helpers where available. Do not change core command behavior.

- [ ] **Step 3: Route handlers**

Modify:

- `TextToColumnsBtn_Click`
- `RemoveDuplicatesBtn_Click`
- `AdvancedFilterBtn_Click`
- `ConsolidateBtn_Click`
- `SubtotalBtn_Click`
- `DataTableBtn_Click`

- [ ] **Step 4: Verify Task 4**

Run:

```powershell
dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --filter "DataToolDialogTests|TextToColumnsPlannerTests|AdvancedFilterCommandTests" -m:1
```

Expected: PASS.

## Task 5: Scenario and Protection Dialogs

**Files:**
- Create: `src/FreeX.App.Host/ScenarioManagerDialog.cs`
- Create: `src/FreeX.App.Host/ProtectionDialogs.cs`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Test: `tests/FreeX.App.Host.Tests/ScenarioManagerDialogTests.cs`
- Test: `tests/FreeX.App.Host.Tests/ProtectionDialogTests.cs`

- [ ] **Step 1: Write failing tests**

Add tests proving:

- Scenario Manager exposes add/save from current selection, show selected scenario, list, and summary report actions.
- Protect Sheet returns password plus supported action.
- Protect Workbook returns password plus structure protection action.
- Allow Edit Ranges returns a parsed range.

Run: `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --filter "ScenarioManagerDialogTests|ProtectionDialogTests" -m:1`
Expected: FAIL because the dialog classes do not exist.

- [ ] **Step 2: Implement dialogs**

Use simple, Excel-like modals. The scenario dialog should show existing scenario names and return a typed action enum plus optional scenario name. Protection dialogs should keep password handling local to the modal result.

- [ ] **Step 3: Route handlers**

Modify:

- `ScenariosBtn_Click`
- `SaveScenarioFromSelection`
- `ShowScenarioByName`
- `ProtectSheetBtn_Click`
- `ProtectWorkbookBtn_Click`
- `AllowEditRangesBtn_Click`

- [ ] **Step 4: Verify Task 5**

Run:

```powershell
dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --filter "ScenarioManagerDialogTests|ProtectionDialogTests|SheetProtectionWorkflowTests|WorkbookProtectionWorkflowTests" -m:1
```

Expected: PASS.

## Task 6: Data Validation Range Picker Polish and Wave 2 Tracking

**Files:**
- Modify: `src/FreeX.App.Host/DataValidationDialog.xaml`
- Modify: `src/FreeX.App.Host/DataValidationDialog.xaml.cs`
- Create: `docs/superpowers/plans/2026-05-19-excel-dialog-parity-wave2.md`
- Test: `tests/FreeX.App.Host.Tests/DataValidationDialogXamlTests.cs`

- [ ] **Step 1: Write failing tests**

Add tests proving:

- Data Validation has a range-picker style button for each formula/range field.
- The dialog can fill formula fields from the current selection callback without needing live worksheet collapse.

Run: `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --filter DataValidationDialogXamlTests -m:1`
Expected: FAIL because only `Formula1Box` has a simple `Use Selection` button and formula 2 lacks matching range-picker affordance.

- [ ] **Step 2: Implement polish**

Add compact range-picker buttons for `Formula1Box` and `Formula2Box` backed by a current-selection callback. Preserve existing validation behavior.

- [ ] **Step 3: Create Wave 2 plan**

Create `docs/superpowers/plans/2026-05-19-excel-dialog-parity-wave2.md` listing chart/pivot/object panes as a tracked follow-up, including Select Data, Edit Series, Axis Labels, Chart Elements/Styles/Filters, PivotTable Options, PivotChart layout/design, shape/picture/text box format dialogs, and slicer/timeline style polish.

- [ ] **Step 4: Verify Task 6**

Run:

```powershell
dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --filter "DataValidationDialogXamlTests|DataValidationTests" -m:1
```

Expected: PASS.

## Final Verification

- [ ] Run host tests:

```powershell
dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj -m:1
```

- [ ] Run model command tests touched by dialog routing:

```powershell
dotnet test tests/FreeX.Core.Model.Tests/FreeX.Core.Model.Tests.csproj -m:1
```

- [ ] Build the solution:

```powershell
dotnet build FreeX.slnx -m:1
```

- [ ] Confirm git status only contains files owned by this branch and does not include unrelated edits to `docs/PROJECT_STATUS_REPORT_2026-05-19.md`.
