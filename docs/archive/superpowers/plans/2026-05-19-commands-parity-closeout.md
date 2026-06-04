# Commands Parity Closeout Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Move the named Partial command rows as close as practical to Implemented, while keeping genuinely large renderer/data-model gaps explicitly Deferred rather than pretending they work.

**Architecture:** Keep mutation behavior in `FreeX.Core.Commands` and UI orchestration in `FreeX.App.Host`. Rendering-specific parity lives in `FreeX.App.UI` or `FreeX.App.Host` only when the core model already has the required command state. Every command change gets command-level tests first, then UI planner/source tests where direct WPF automation would be brittle.

**Tech Stack:** C#/.NET 10, WPF, xUnit, FluentAssertions, OxyPlot-backed chart renderer, XPS print pipeline, existing command bus undo/redo.

## Execution Status

Completed in this closeout:

- Task 1: baseline audit and parity guard.
- Task 2: Cut/Copy clipboard marquee state.
- Task 3: Paste/Paste Special matrix completion.
- Task 4: persistent Format Painter.
- Task 5: Distributed/Justify alignment and Shrink to Fit.
- Task 6: AutoFit row/column estimates.
- Task 7: expanded Format Cells dialog mappings.
- Task 8: custom/accounting number-format subset hardening.
- Task 9: deterministic XPS export with explicit PDF fallback.
- Task 10: deterministic Flash Fill inference expansion.
- Task 11: advanced chart families recognized as deferred and blocked from broken authoring/rendering.
- Task 12: documentation, architecture notes, and ADR-007.

Iteration 2 status:

- Home > Borders now exposes an expanded preset gallery backed by reusable `BorderShortcutService` `StyleDiff` planners.
- Thick box and top/bottom range presets are applied as perimeter-only border plans and batched into one undoable command from `App.Host`.
- Full Border Gallery remains Partial because interactive draw/erase border tools are still deferred.

Iteration 3 status:

- Home > Cell Styles now exposes an expanded preset gallery including Normal, modeling styles, headings, semantic styles, and 20% Accent 1-6 presets.
- Cell Style menu handlers route through reusable `CellStyleDiffPlanner` preset definitions instead of inline `StyleDiff` literals in `MainWindow`.
- Cell Styles remains Partial because the presets apply immediate style diffs; workbook named styles and theme-bound semantics are still deferred.

Iteration 4 status:

- Home > Conditional Formatting icon-set authoring/editing now maps to `CfRuleType.IconSet` with supported OOXML-style names plus show-value and reverse-order options.
- The conditional-format rule manager now describes icon sets by style/options, avoids fill-color previews for icon sets, and preserves all currently modeled advanced CF fields while cloning for edit/reorder/apply.
- Conditional Formatting remains Partial because the manager is still simplified and full Excel icon-set rendering/taxonomy is not complete.

Iteration 5 status:

- Review > Spelling now uses a deterministic known-corrections scan over literal text cells in sheet/row/column order.
- `SpellCheckService` exposes all known issues per text cell plus a replace-all edit planner that preserves capitalization and whole-word matching.
- The host workflow now summarizes active-sheet findings and supports replace first, replace all, and ignore choices through undoable text-cell edits.
- Spell Check remains Partial because FreeX still has no full dictionary/proofing engine and formula cells are not edited as text.

Iteration 6 status:

- Review > Accessibility Checker now uses a broader deterministic model-backed audit in `Core.Commands`.
- `AccessibilityCheckerService` reports merged cells, missing object alternate text, hidden sheets/rows/columns with content, unclear hyperlink display text, and charts without titles.
- Accessibility Checker remains Partial because FreeX still does not implement a full WCAG or screen-reader audit engine.

Iteration 7 status:

- Formulas > Error Checking now uses a broader deterministic model-backed rule taxonomy in `Core.Commands`.
- `FormulaAuditingService` reports cached formula error values, numbers stored as text, and formulas whose direct parser-extracted precedents include blank or missing cells.
- Error Checking remains Partial because FreeX does not attempt Excel's full heuristic inference engine; rule options and Ignore Error are supported for the modeled issue codes only.

Iteration 8 status:

- File > Info now surfaces existing model-backed workbook statistics: cells with data, formulas, comments, charts, pictures, shapes/text boxes, and named ranges.
- The Info view refreshes workbook structure protection, active-sheet protection, and accessibility issue count when opened through `InfoPanelSummaryPlanner` plus existing model audit services.
- Info panel remains Partial because FreeX still does not implement Excel cloud/account integration, version history, Document Inspector, template discovery, or extended document metadata.

Remaining command-parity iterations should start from the current Partial rows in `COMMAND_SURFACE_PARITY.md` rather than reopening the completed closeout rows.

---

## Scope Decisions

These rows can realistically move to **Implemented** in this closeout:

- Cut visual state: add marching-ants state for cut/copy and consume it on paste/escape.
- Paste and Paste Special: complete the internal matrix rules, linked paste metadata, column widths, picture snapshot, and UI state coverage.
- Format Painter: add persistent double-click mode and escape/cancel semantics.
- Distributed/Justify alignment, Shrink to Fit, and the Alignment tab in Format Cells.
- AutoFit Row/Column based on measured display text.
- Format Cells dialog, within FreeX's supported style model.
- Flash Fill baseline inference improvements for common split/combine/extract cases.
- Export to XPS, and PDF via Windows Print-to-PDF where available, with explicit option coverage.

These rows should remain **Deferred** or **Partial with explicit retention** after this plan:

- Advanced chart families: surface, treemap, sunburst, histogram, Pareto, box-and-whisker, waterfall, funnel, map, and 3D. The closeout should add model/read/write preservation and disabled/clear UI entries, not claim renderer parity before per-family data models exist.
- Full Excel locale/accounting fidelity. The closeout should implement a documented invariant/accounting subset and mark remaining OS/Excel locale quirks as partial.

---

## File Map

- `docs/COMMAND_SURFACE_PARITY.md`: final status table updates.
- `docs/MENU_TOOLBAR_PARITY.md`: matching menu/ribbon status updates.
- `docs/ARCHITECTURE.md`: command parity architecture note for clipboard state, format state, and advanced chart deferral.
- `src/FreeX.Core.Model/CellStyle.cs`: extend alignment style properties.
- `src/FreeX.Core.Model/ChartModel.cs`: add unsupported chart family enum values and retention metadata if missing.
- `src/FreeX.Core.Model/ChartTypeSupport.cs`: central support flags for implemented/renderable/deferred chart types.
- `src/FreeX.Core.Commands/PasteCommandFactory.cs`: internal paste matrix and linked paste behavior.
- `src/FreeX.Core.Commands/PasteSpecialCommand.cs`: paste special mode completion.
- `src/FreeX.Core.Commands/FormatPainterCommandFactory.cs`: persistent painter command support remains model-based; UI state lives in `MainWindow`.
- `src/FreeX.Core.Commands/SheetLayoutCommands.cs`: AutoFit commands or services for measured width/height results.
- `src/FreeX.Core.Commands/FlashFillService.cs`: expanded inference patterns.
- `src/FreeX.Core.Calc/NumberFormatter.cs`: custom/accounting format improvements.
- `src/FreeX.App.Host/MainWindow.xaml`: command entries and disabled advanced chart menu clarity.
- `src/FreeX.App.Host/MainWindow.xaml.cs`: keyboard handling, clipboard state, persistent format painter state, PDF/XPS UI, AutoFit orchestration, Flash Fill UI entry.
- `src/FreeX.App.Host/FormatCellsDialog.xaml`: Alignment/Number dialog UI expansion.
- `src/FreeX.App.Host/FormatCellsDialog.xaml.cs`: dialog-to-`StyleDiff` mapping.
- `src/FreeX.App.Host/ClipboardPastePlanner.cs`: UI planner coverage for paste matrix choices.
- `src/FreeX.App.Host/PrintRenderer.cs`: export option support if needed.
- `src/FreeX.App.UI/GridView.cs`: render marching ants, justify/distributed/shrink-to-fit behavior, measured text support.
- `src/FreeX.Core.IO/XlsxChartPartReader.cs`: preserve unsupported advanced chart family metadata.
- `src/FreeX.Core.IO/XlsxFileAdapter.cs`: chart package retention and style IO for new style fields.
- Tests listed under each task.

---

### Task 1: Command Parity Baseline Audit

**Files:**
- Create: `tests/FreeX.App.Host.Tests/CommandParityStatusTests.cs`
- Modify: `docs/COMMAND_SURFACE_PARITY.md`
- Modify: `docs/MENU_TOOLBAR_PARITY.md`

- [ ] **Step 1: Add an executable status guard for the named partial rows**

Create `tests/FreeX.App.Host.Tests/CommandParityStatusTests.cs`:

```csharp
using FluentAssertions;

namespace FreeX.App.Host.Tests;

public sealed class CommandParityStatusTests
{
    [Fact]
    public void NamedCloseoutRows_AreTrackedInCommandSurfaceParityDocument()
    {
        var doc = File.ReadAllText(Path.Combine(
            TestContext.Current.TestDirectory,
            "..", "..", "..", "..", "docs", "COMMAND_SURFACE_PARITY.md"));

        string[] rows =
        [
            "Advanced Chart Families",
            "Export to PDF/XPS",
            "Cut (Ctrl+X)",
            "Copy (Ctrl+C)",
            "Paste (Ctrl+V)",
            "Paste Special",
            "Format Painter",
            "Distributed/Justify alignment",
            "Shrink to Fit",
            "Format Cells Alignment dialog",
            "Custom Number Format",
            "Full Excel locale/accounting fidelity",
            "AutoFit Row/Column",
            "Format Cells dialog (Ctrl+1)",
            "Flash Fill"
        ];

        foreach (var row in rows)
            doc.Should().Contain(row);
    }
}
```

- [ ] **Step 2: Run the audit test**

Run:

```powershell
dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter CommandParityStatusTests
```

Expected: PASS. If it fails because wording differs, update the test strings to the canonical row names already in the document.

- [ ] **Step 3: Add a closeout subsection**

In `docs/COMMAND_SURFACE_PARITY.md`, add a section after `## Deferred Architectural Features`:

```markdown
## Commands Parity Closeout Scope

The May 2026 closeout targets the remaining Partial rows where FreeX already has the underlying model:
clipboard visual state, paste matrix completion, persistent Format Painter, alignment and shrink-to-fit style state,
AutoFit measurement, Format Cells dialog coverage, Flash Fill inference, and PDF/XPS export options.

Advanced chart families stay Deferred until each family has a data model and renderer. FreeX should preserve
unsupported chart package parts and present disabled or clearly-labeled commands rather than claiming authored
rendering support.
```

- [ ] **Step 4: Commit**

```powershell
git add docs\COMMAND_SURFACE_PARITY.md docs\MENU_TOOLBAR_PARITY.md tests\FreeX.App.Host.Tests\CommandParityStatusTests.cs
git commit -m "test: guard commands parity closeout rows"
```

---

### Task 2: Clipboard Visual State for Cut/Copy

**Files:**
- Modify: `src/FreeX.App.UI/GridView.cs`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Modify: `tests/FreeX.App.UI.Tests/GridViewSelectionLayoutTests.cs`
- Modify: `tests/FreeX.App.Host.Tests/ClipboardPastePlannerTests.cs`

- [ ] **Step 1: Add failing layout tests for clipboard marquee**

In `tests/FreeX.App.UI.Tests/GridViewSelectionLayoutTests.cs`, add tests for copied and cut ranges:

```csharp
[Fact]
public void CalculateClipboardMarquee_ReturnsVisibleRectangle_ForCopiedRange()
{
    var sheet = SheetId.New();
    var range = new GridRange(new CellAddress(sheet, 2, 2), new CellAddress(sheet, 3, 3));
    var viewport = new ViewportModel(
        [],
        [new RowMetric(1, 20, 0), new RowMetric(2, 20, 20), new RowMetric(3, 20, 40)],
        [new ColMetric(1, 64, 0), new ColMetric(2, 64, 64), new ColMetric(3, 64, 128)]);

    var rect = GridView.CalculateClipboardMarquee(viewport, range, headerSize: 30);

    rect.Should().Be(new Rect(94, 50, 128, 40));
}

[Fact]
public void CalculateClipboardMarquee_ReturnsNull_WhenRangeIsOutsideViewport()
{
    var sheet = SheetId.New();
    var range = new GridRange(new CellAddress(sheet, 10, 10), new CellAddress(sheet, 11, 11));
    var viewport = new ViewportModel(
        [],
        [new RowMetric(1, 20, 0), new RowMetric(2, 20, 20)],
        [new ColMetric(1, 64, 0), new ColMetric(2, 64, 64)]);

    GridView.CalculateClipboardMarquee(viewport, range, headerSize: 30).Should().BeNull();
}
```

- [ ] **Step 2: Run tests to verify failure**

```powershell
dotnet test tests\FreeX.App.UI.Tests\FreeX.App.UI.Tests.csproj --filter CalculateClipboardMarquee
```

Expected: FAIL because `CalculateClipboardMarquee` does not exist.

- [ ] **Step 3: Implement clipboard marquee state and calculation**

In `src/FreeX.App.UI/GridView.cs`, add dependency properties:

```csharp
public static readonly DependencyProperty ClipboardRangeProperty =
    DependencyProperty.Register(nameof(ClipboardRange), typeof(GridRange?), typeof(GridView),
        new FrameworkPropertyMetadata(null, FrameworkPropertyMetadataOptions.AffectsRender));

public GridRange? ClipboardRange
{
    get => (GridRange?)GetValue(ClipboardRangeProperty);
    set => SetValue(ClipboardRangeProperty, value);
}

public static readonly DependencyProperty ClipboardIsCutProperty =
    DependencyProperty.Register(nameof(ClipboardIsCut), typeof(bool), typeof(GridView),
        new FrameworkPropertyMetadata(false, FrameworkPropertyMetadataOptions.AffectsRender));

public bool ClipboardIsCut
{
    get => (bool)GetValue(ClipboardIsCutProperty);
    set => SetValue(ClipboardIsCutProperty, value);
}
```

Add a pure helper:

```csharp
public static Rect? CalculateClipboardMarquee(ViewportModel viewport, GridRange range, double headerSize)
{
    var rows = viewport.RowMetrics.Where(r => r.Row >= range.Start.Row && r.Row <= range.End.Row).ToList();
    var cols = viewport.ColMetrics.Where(c => c.Col >= range.Start.Col && c.Col <= range.End.Col).ToList();
    if (rows.Count == 0 || cols.Count == 0)
        return null;

    var left = cols.Min(c => c.LeftOffset) + headerSize;
    var top = rows.Min(r => r.TopOffset) + headerSize;
    var right = cols.Max(c => c.LeftOffset + c.Width) + headerSize;
    var bottom = rows.Max(r => r.TopOffset + r.Height) + headerSize;
    return new Rect(left, top, right - left, bottom - top);
}
```

Call it from `OnRender` after `RenderSelection(dc)`:

```csharp
RenderClipboardMarquee(dc);
```

Implement:

```csharp
private void RenderClipboardMarquee(DrawingContext dc)
{
    if (Viewport is null || ClipboardRange is null)
        return;

    var rect = CalculateClipboardMarquee(Viewport, ClipboardRange.Value, headerSize: 30);
    if (rect is null)
        return;

    var pen = new Pen(ClipboardIsCut ? Brushes.DarkOrange : Brushes.Black, 1)
    {
        DashStyle = new DashStyle([3, 2], 0)
    };
    dc.DrawRectangle(null, pen, rect.Value);
}
```

- [ ] **Step 4: Wire MainWindow state**

In `src/FreeX.App.Host/MainWindow.xaml.cs`, ensure `ExecuteCopy(isCut: true)` sets:

```csharp
SheetGrid.ClipboardRange = range;
SheetGrid.ClipboardIsCut = isCut;
```

Ensure successful `ExecutePaste` and `Escape` clear:

```csharp
SheetGrid.ClipboardRange = null;
SheetGrid.ClipboardIsCut = false;
```

- [ ] **Step 5: Verify**

```powershell
dotnet test tests\FreeX.App.UI.Tests\FreeX.App.UI.Tests.csproj --filter CalculateClipboardMarquee
dotnet test tests\FreeX.Integration.Tests\FreeX.Integration.Tests.csproj --filter Clipboard
```

Expected: PASS.

- [ ] **Step 6: Commit**

```powershell
git add src\FreeX.App.UI\GridView.cs src\FreeX.App.Host\MainWindow.xaml.cs tests\FreeX.App.UI.Tests\GridViewSelectionLayoutTests.cs tests\FreeX.App.Host.Tests\ClipboardPastePlannerTests.cs
git commit -m "feat: show clipboard marquee for cut and copy"
```

---

### Task 3: Paste and Paste Special Matrix Completion

**Files:**
- Modify: `src/FreeX.Core.Commands/PasteCommandFactory.cs`
- Modify: `src/FreeX.Core.Commands/PasteSpecialCommand.cs`
- Modify: `src/FreeX.App.Host/PasteSpecialDialog.cs`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Modify: `tests/FreeX.Core.Model.Tests/PasteCellsCommandTests.cs`
- Modify: `tests/FreeX.Core.Model.Tests/PasteSpecialCommandTests.cs`
- Modify: `tests/FreeX.App.Host.Tests/ClipboardPastePlannerTests.cs`

- [ ] **Step 1: Add failing tests for paste mode semantics**

Add to `tests/FreeX.Core.Model.Tests/PasteSpecialCommandTests.cs`:

```csharp
[Fact]
public void PasteSpecial_Values_PreservesDestinationStyle()
{
    var wb = new Workbook("Book");
    var sheet = wb.AddSheet("Sheet1");
    var bus = new CommandBus(_ => new SimpleCommandContext(wb));
    var styleId = wb.RegisterStyle(new CellStyle { Bold = true });
    var source = new CellAddress(sheet.Id, 1, 1);
    var dest = new CellAddress(sheet.Id, 2, 1);
    sheet.SetCell(source, Cell.FromValue(new NumberValue(42)));
    sheet.SetCell(dest, Cell.FromValue(new TextValue("old")));
    sheet.GetCell(dest)!.StyleId = styleId;

    var cmd = PasteCommandFactory.CreateInternalPasteCommand(
        wb,
        sheet.Id,
        new GridRange(source, source),
        [(source, sheet.GetCell(source)!.Clone())],
        dest,
        PasteCellsMode.Values,
        default);

    bus.Execute(wb.Id, cmd);

    sheet.GetCell(dest)!.Value.Should().Be(new NumberValue(42));
    sheet.GetCell(dest)!.StyleId.Should().Be(styleId);
}
```

Add:

```csharp
[Fact]
public void PasteSpecial_Formulas_PreservesDestinationStyleAndAdjustsReferences()
{
    var wb = new Workbook("Book");
    var sheet = wb.AddSheet("Sheet1");
    var styleId = wb.RegisterStyle(new CellStyle { Italic = true });
    var source = new CellAddress(sheet.Id, 1, 2);
    var dest = new CellAddress(sheet.Id, 3, 4);
    sheet.SetFormula(source, "A1");
    sheet.SetCell(dest, Cell.FromValue(new NumberValue(0)));
    sheet.GetCell(dest)!.StyleId = styleId;

    var cmd = PasteCommandFactory.CreateInternalPasteCommand(
        wb,
        sheet.Id,
        new GridRange(source, source),
        [(source, sheet.GetCell(source)!.Clone())],
        dest,
        PasteCellsMode.Formulas,
        default);

    cmd.Apply(new SimpleCommandContext(wb)).Success.Should().BeTrue();

    sheet.GetCell(dest)!.FormulaText.Should().Be("C3");
    sheet.GetCell(dest)!.StyleId.Should().Be(styleId);
}
```

- [ ] **Step 2: Run the tests to verify current gaps**

```powershell
dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --filter "PasteSpecial_Values|PasteSpecial_Formulas"
```

Expected: at least one failure if destination style is overwritten by values/formulas paste.

- [ ] **Step 3: Add a focused cell builder for paste modes**

In `PasteCommandFactory.BuildPastedCell`, change Values/Formulas to preserve destination style. Add a helper signature that accepts the destination cell:

```csharp
private static Cell BuildPastedCell(
    Cell sourceCell,
    Cell? destinationCell,
    PasteCellsMode mode,
    PasteOffsetOp pasteOp,
    string activeSheetName,
    int rowDelta,
    int colDelta)
```

Implement:

```csharp
var destinationStyle = destinationCell?.StyleId ?? StyleId.Default;

if (mode == PasteCellsMode.Values)
{
    var cell = Cell.FromValue(sourceCell.Value);
    cell.StyleId = destinationStyle;
    return cell;
}

if (mode == PasteCellsMode.Formulas)
{
    if (!sourceCell.HasFormula)
    {
        var valueCell = Cell.FromValue(sourceCell.Value);
        valueCell.StyleId = destinationStyle;
        return valueCell;
    }

    var formulaCell = Cell.FromFormula(sourceCell.FormulaText!);
    formulaCell.Value = sourceCell.Value;
    formulaCell.StyleId = destinationStyle;
    if (rowDelta != 0 || colDelta != 0)
    {
        formulaCell.FormulaText =
            FormulaRewriter.Rewrite(formulaCell.FormulaText, pasteOp, activeSheetName)
            ?? formulaCell.FormulaText;
    }
    return formulaCell;
}
```

In the caller, read:

```csharp
var destinationExisting = workbook.GetSheet(targetSheetId)?.GetCell(destinationAddress)?.Clone();
var pastedCell = BuildPastedCell(sourceCell, destinationExisting, mode, pasteOp, activeSheetName, rowDelta, colDelta);
```

- [ ] **Step 4: Add link and picture planner coverage**

In `tests/FreeX.App.Host.Tests/ClipboardPastePlannerTests.cs`, add tests asserting Paste Special options map to:

```csharp
PasteCellsMode.Values
PasteCellsMode.Formulas
PasteCellsMode.Formats
PasteSpecialOptions(Transpose: true)
PasteSpecialOperation.Add
PasteSpecialOperation.Subtract
PasteSpecialOperation.Multiply
PasteSpecialOperation.Divide
PasteColumnWidthsCommand
PasteRangeAsPictureCommand
PasteLinkService.CreateLinkedCells(...)
```

- [ ] **Step 5: Verify**

```powershell
dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --filter "Paste"
dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter "Clipboard|Paste"
```

Expected: PASS.

- [ ] **Step 6: Commit**

```powershell
git add src\FreeX.Core.Commands\PasteCommandFactory.cs src\FreeX.Core.Commands\PasteSpecialCommand.cs src\FreeX.App.Host\PasteSpecialDialog.cs src\FreeX.App.Host\MainWindow.xaml.cs tests\FreeX.Core.Model.Tests\PasteCellsCommandTests.cs tests\FreeX.Core.Model.Tests\PasteSpecialCommandTests.cs tests\FreeX.App.Host.Tests\ClipboardPastePlannerTests.cs
git commit -m "feat: complete core paste special matrix"
```

---

### Task 4: Persistent Format Painter Mode

**Files:**
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Modify: `tests/FreeX.App.Host.Tests/MainWindowSourceHygieneTests.cs`
- Modify: `tests/FreeX.Core.Model.Tests/FormatPainterCommandTests.cs`

- [ ] **Step 1: Add source hygiene tests for double-click painter mode**

In `tests/FreeX.App.Host.Tests/MainWindowSourceHygieneTests.cs`, add:

```csharp
[Fact]
public void MainWindow_DefinesPersistentFormatPainterState()
{
    var source = File.ReadAllText(SourcePath);

    source.Should().Contain("_formatPainterPersistent");
    source.Should().Contain("FormatPainterBtn_MouseDoubleClick");
    source.Should().Contain("CancelFormatPainter");
}
```

- [ ] **Step 2: Run to verify failure**

```powershell
dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter PersistentFormatPainter
```

Expected: FAIL until fields/handler exist.

- [ ] **Step 3: Implement single-click and double-click behavior**

In `MainWindow.xaml`, add to the Format Painter button:

```xml
MouseDoubleClick="FormatPainterBtn_MouseDoubleClick"
```

In `MainWindow.xaml.cs`, add fields:

```csharp
private bool _formatPainterPersistent;
```

Update the click handler:

```csharp
private void FormatPainterBtn_Click(object sender, RoutedEventArgs e)
{
    CaptureFormatPainterSource(persistent: false);
}

private void FormatPainterBtn_MouseDoubleClick(object sender, MouseButtonEventArgs e)
{
    CaptureFormatPainterSource(persistent: true);
    e.Handled = true;
}

private void CaptureFormatPainterSource(bool persistent)
{
    if (SheetGrid.SelectedRange is null)
        return;

    var source = SheetGrid.SelectedRange.Value.Start;
    var sheet = _workbook.GetSheet(_currentSheetId);
    if (sheet is null)
        return;

    _formatPainterSource = source;
    _formatPainterStyleId =
        sheet.GetCell(source)?.StyleId
        ?? sheet.GetStyleOnly(source.Row, source.Col)
        ?? StyleId.Default;
    _formatPainterPersistent = persistent;
}
```

After successful `TryApplyFormatPainter`, clear only when not persistent:

```csharp
if (!_formatPainterPersistent)
    CancelFormatPainter();
```

Add:

```csharp
private void CancelFormatPainter()
{
    _formatPainterSource = null;
    _formatPainterStyleId = null;
    _formatPainterPersistent = false;
}
```

Call `CancelFormatPainter()` from Escape handling.

- [ ] **Step 4: Verify**

```powershell
dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter PersistentFormatPainter
dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --filter FormatPainter
```

Expected: PASS.

- [ ] **Step 5: Commit**

```powershell
git add src\FreeX.App.Host\MainWindow.xaml src\FreeX.App.Host\MainWindow.xaml.cs tests\FreeX.App.Host.Tests\MainWindowSourceHygieneTests.cs tests\FreeX.Core.Model.Tests\FormatPainterCommandTests.cs
git commit -m "feat: add persistent format painter mode"
```

---

### Task 5: Alignment Parity - Justify, Distributed, Shrink to Fit

**Files:**
- Modify: `src/FreeX.Core.Model/CellStyle.cs`
- Modify: `src/FreeX.Core.Commands/ApplyStyleCommand.cs`
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Modify: `src/FreeX.App.UI/GridView.cs`
- Modify: `src/FreeX.App.Host/FormatCellsDialog.xaml`
- Modify: `src/FreeX.App.Host/FormatCellsDialog.xaml.cs`
- Modify: `tests/FreeX.Core.Model.Tests/ApplyStyleCommandTests.cs`
- Modify: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`
- Modify: `tests/FreeX.App.UI.Tests/GridViewTextDecorationTests.cs`

- [ ] **Step 1: Add failing model tests**

In `tests/FreeX.Core.Model.Tests/ApplyStyleCommandTests.cs`, add:

```csharp
[Fact]
public void ApplyStyleCommand_AppliesDistributedJustifyAndShrinkToFit()
{
    var wb = new Workbook("Book");
    var sheet = wb.AddSheet("Sheet1");
    var addr = new CellAddress(sheet.Id, 1, 1);
    sheet.SetCell(addr, new TextValue("long text"));

    var cmd = new ApplyStyleCommand(
        sheet.Id,
        new GridRange(addr, addr),
        new StyleDiff(
            HAlign: HorizontalAlignment.Distributed,
            VAlign: VerticalAlignment.Justify,
            ShrinkToFit: true));

    cmd.Apply(new SimpleCommandContext(wb)).Success.Should().BeTrue();

    var style = wb.GetStyle(sheet.GetCell(addr)!.StyleId);
    style.HorizontalAlignment.Should().Be(HorizontalAlignment.Distributed);
    style.VerticalAlignment.Should().Be(VerticalAlignment.Justify);
    style.ShrinkToFit.Should().BeTrue();
}
```

- [ ] **Step 2: Run to verify failure**

```powershell
dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --filter DistributedJustifyAndShrinkToFit
```

Expected: FAIL because enum values and `ShrinkToFit` are missing.

- [ ] **Step 3: Extend style model**

In `CellStyle.cs`, extend enums:

```csharp
public enum HorizontalAlignment
{
    General,
    Left,
    Center,
    Right,
    Justify,
    Distributed
}

public enum VerticalAlignment
{
    Top,
    Center,
    Bottom,
    Justify,
    Distributed
}
```

Add property:

```csharp
public bool ShrinkToFit { get; set; }
```

Add to `Clone`, `Equals`, `GetHashCode`, `StyleDiff`, `StyleDiff.FromStyle`, and `StyleDiff.ApplyTo`.

- [ ] **Step 4: Map XLSX alignment**

In `XlsxFileAdapter`, map ClosedXML alignment values:

```csharp
XLAlignmentHorizontalValues.Justify => HorizontalAlignment.Justify,
XLAlignmentHorizontalValues.Distributed => HorizontalAlignment.Distributed,
XLAlignmentVerticalValues.Justify => VerticalAlignment.Justify,
XLAlignmentVerticalValues.Distributed => VerticalAlignment.Distributed,
```

Map `style.Alignment.ShrinkToFit` into `CellStyle.ShrinkToFit`, and write it back in `ApplyStyle`.

- [ ] **Step 5: Render shrink-to-fit**

In `GridView`, when building `FormattedText`, if style has `ShrinkToFit`, reduce font size until `formatted.Width <= cellWidth - 4` or font size reaches 6:

```csharp
private static double ResolveShrinkFontSize(string text, Typeface typeface, double originalSize, double maxWidth)
{
    var size = originalSize;
    while (size > 6)
    {
        var ft = CreateFormattedText(text, typeface, size, Brushes.Black);
        if (ft.Width <= maxWidth)
            return size;
        size -= 0.5;
    }
    return 6;
}
```

- [ ] **Step 6: Update Format Cells dialog**

In `FormatCellsDialog.xaml`, add:

```xml
<CheckBox x:Name="DlgShrinkToFitCheck" Content="Shrink to fit"/>
```

In code-behind, populate and return:

```csharp
DlgShrinkToFitCheck.IsChecked = s.ShrinkToFit;
```

and:

```csharp
ShrinkToFit: DlgShrinkToFitCheck.IsChecked
```

- [ ] **Step 7: Verify**

```powershell
dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --filter "Distributed|Shrink"
dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --filter "Alignment|Shrink"
dotnet test tests\FreeX.App.UI.Tests\FreeX.App.UI.Tests.csproj --filter "Shrink|Alignment"
```

Expected: PASS.

- [ ] **Step 8: Commit**

```powershell
git add src\FreeX.Core.Model\CellStyle.cs src\FreeX.Core.Commands\ApplyStyleCommand.cs src\FreeX.Core.IO\XlsxFileAdapter.cs src\FreeX.App.UI\GridView.cs src\FreeX.App.Host\FormatCellsDialog.xaml src\FreeX.App.Host\FormatCellsDialog.xaml.cs tests\FreeX.Core.Model.Tests\ApplyStyleCommandTests.cs tests\FreeX.Core.IO.Tests\FileAdapterSmokeTests.cs tests\FreeX.App.UI.Tests\GridViewTextDecorationTests.cs
git commit -m "feat: add justify distributed and shrink-to-fit alignment"
```

---

### Task 6: AutoFit Row and Column Measurement

**Files:**
- Create: `src/FreeX.Core.Commands/AutoFitSizingService.cs`
- Modify: `src/FreeX.Core.Commands/SheetLayoutCommands.cs`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Modify: `tests/FreeX.Core.Model.Tests/SheetLayoutCommandTests.cs`
- Modify: `tests/FreeX.App.Host.Tests/MainWindowSourceHygieneTests.cs`

- [ ] **Step 1: Add failing service tests**

Create tests in `tests/FreeX.Core.Model.Tests/SheetLayoutCommandTests.cs`:

```csharp
[Fact]
public void AutoFitSizingService_EstimatesColumnWidthFromLongestDisplayText()
{
    AutoFitSizingService.EstimateColumnWidth(["A", "Long header"], defaultWidth: 64)
        .Should().BeGreaterThan(64);
}

[Fact]
public void AutoFitSizingService_EstimatesWrappedRowHeightFromLineCount()
{
    AutoFitSizingService.EstimateRowHeight(["one\ntwo\nthree"], defaultHeight: 20)
        .Should().BeGreaterThan(20);
}
```

- [ ] **Step 2: Run to verify failure**

```powershell
dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --filter AutoFitSizingService
```

Expected: FAIL because service does not exist.

- [ ] **Step 3: Implement service**

Create `src/FreeX.Core.Commands/AutoFitSizingService.cs`:

```csharp
namespace FreeX.Core.Commands;

public static class AutoFitSizingService
{
    public static double EstimateColumnWidth(IEnumerable<string> displayTexts, double defaultWidth)
    {
        var longest = displayTexts.DefaultIfEmpty("").Max(t => t.Length);
        return Math.Clamp(Math.Max(defaultWidth, longest * 7.2 + 16), 24, 300);
    }

    public static double EstimateRowHeight(IEnumerable<string> displayTexts, double defaultHeight)
    {
        var maxLines = displayTexts
            .DefaultIfEmpty("")
            .Max(t => Math.Max(1, t.Split('\n').Length));
        return Math.Clamp(Math.Max(defaultHeight, maxLines * 18 + 4), 16, 220);
    }
}
```

- [ ] **Step 4: Wire menu commands**

In `MainWindow.xaml.cs`, update `FormatAutoRowMenuItem_Click` and `FormatAutoColMenuItem_Click` to calculate display text for the selected row/column cells, then execute `SetRowHeightCommand`/`SetColumnWidthCommand` with the computed value rather than `null`.

Use:

```csharp
var width = AutoFitSizingService.EstimateColumnWidth(texts, sheet.DefaultColumnWidth * 8);
_commandBus.Execute(_workbook.Id, new SetColumnWidthCommand(_currentSheetId, startCol, endCol, width));
```

For rows:

```csharp
var height = AutoFitSizingService.EstimateRowHeight(texts, sheet.DefaultRowHeight);
_commandBus.Execute(_workbook.Id, new SetRowHeightCommand(_currentSheetId, startRow, endRow, height));
```

- [ ] **Step 5: Verify**

```powershell
dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --filter AutoFit
dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter AutoFit
```

Expected: PASS.

- [ ] **Step 6: Commit**

```powershell
git add src\FreeX.Core.Commands\AutoFitSizingService.cs src\FreeX.Core.Commands\SheetLayoutCommands.cs src\FreeX.App.Host\MainWindow.xaml.cs tests\FreeX.Core.Model.Tests\SheetLayoutCommandTests.cs tests\FreeX.App.Host.Tests\MainWindowSourceHygieneTests.cs
git commit -m "feat: estimate autofit row and column sizes"
```

---

### Task 7: Format Cells Dialog Closeout

**Files:**
- Modify: `src/FreeX.App.Host/FormatCellsDialog.xaml`
- Modify: `src/FreeX.App.Host/FormatCellsDialog.xaml.cs`
- Modify: `tests/FreeX.App.Host.Tests/MainWindowSourceHygieneTests.cs`
- Modify: `tests/FreeX.App.Host.Tests/FormatCellsDialogXamlTests.cs`

- [ ] **Step 1: Add XAML coverage for supported tabs**

In `tests/FreeX.App.Host.Tests/FormatCellsDialogXamlTests.cs`, add:

```csharp
[Fact]
public void FormatCellsDialog_ContainsSupportedExcelTabs()
{
    var xaml = File.ReadAllText(Path.Combine(
        TestContext.Current.TestDirectory,
        "..", "..", "..", "..", "src", "FreeX.App.Host", "FormatCellsDialog.xaml"));

    xaml.Should().Contain("Number");
    xaml.Should().Contain("Alignment");
    xaml.Should().Contain("Font");
    xaml.Should().Contain("Fill");
    xaml.Should().Contain("Border");
    xaml.Should().Contain("Protection");
}
```

- [ ] **Step 2: Run to verify failure if tabs are missing**

```powershell
dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter FormatCellsDialog_ContainsSupportedExcelTabs
```

Expected: FAIL until missing tabs/labels are present.

- [ ] **Step 3: Expand dialog to supported model**

Add controls for:

- Number: editable custom format box plus presets.
- Alignment: horizontal/vertical, wrap, shrink, indent, text rotation.
- Font: font name, size, bold, italic, underline, double underline, strikethrough, font color.
- Fill: fill color and clear fill.
- Border: top/right/bottom/left style and color.
- Protection: locked.

Each control must map to an existing `StyleDiff` field. Do not add controls for unsupported Excel features such as hidden formulas unless the model field is added in the same task.

- [ ] **Step 4: Verify dialog returns complete `StyleDiff`**

Add a non-visual code-behind test by instantiating the dialog on STA if existing test infrastructure supports it. Otherwise, add source tests that require every `StyleDiff` property name to appear in `FormatCellsDialog.xaml.cs`:

```csharp
[Fact]
public void FormatCellsDialog_MapsAllSupportedStyleDiffFields()
{
    var source = File.ReadAllText(Path.Combine(
        TestContext.Current.TestDirectory,
        "..", "..", "..", "..", "src", "FreeX.App.Host", "FormatCellsDialog.xaml.cs"));

    foreach (var name in new[]
    {
        "Bold", "Italic", "Underline", "Strikethrough", "FontName", "FontSize",
        "FontColor", "FillColor", "HAlign", "VAlign", "WrapText", "NumberFormat",
        "DoubleUnderline", "IndentLevel", "TextRotation", "BorderTop", "BorderRight",
        "BorderBottom", "BorderLeft", "Locked", "ShrinkToFit"
    })
        source.Should().Contain(name);
}
```

- [ ] **Step 5: Commit**

```powershell
git add src\FreeX.App.Host\FormatCellsDialog.xaml src\FreeX.App.Host\FormatCellsDialog.xaml.cs tests\FreeX.App.Host.Tests\FormatCellsDialogXamlTests.cs tests\FreeX.App.Host.Tests\MainWindowSourceHygieneTests.cs
git commit -m "feat: expand Format Cells dialog for supported style model"
```

---

### Task 8: Custom Number Format and Accounting Subset

**Files:**
- Modify: `src/FreeX.Core.Calc/NumberFormatter.cs`
- Modify: `src/FreeX.App.Host/NumberFormatDecimalAdjuster.cs`
- Modify: `src/FreeX.App.Host/FormatCellsDialog.xaml.cs`
- Modify: `tests/FreeX.Core.Calc.Tests/NumberFormatterTests.cs`
- Modify: `tests/FreeX.Core.Calc.Tests/NumberFormatterDateTests.cs`
- Modify: `tests/FreeX.App.Host.Tests/NumberFormatDecimalAdjusterTests.cs`

- [ ] **Step 1: Add failing format tests**

In `tests/FreeX.Core.Calc.Tests/NumberFormatterTests.cs`, add:

```csharp
[Theory]
[InlineData(1234.5, "_($* #,##0.00_);_($* (#,##0.00);_($* \"-\"??_);_(@_)", "$ 1,234.50")]
[InlineData(-1234.5, "_($* #,##0.00_);_($* (#,##0.00);_($* \"-\"??_);_(@_)", "$ (1,234.50)")]
[InlineData(0, "_($* #,##0.00_);_($* (#,##0.00);_($* \"-\"??_);_(@_)", "$ -")]
public void Format_AccountingSubset_RendersCommonExcelAccounting(double value, string format, string expected)
{
    NumberFormatter.Format(new NumberValue(value), format).Should().Be(expected);
}

[Theory]
[InlineData(1234.567, "#,##0.0###", "1,234.567")]
[InlineData(0.125, "# ?/?", "1/8")]
[InlineData(1200, "0.00E+00", "1.20E+03")]
public void Format_CustomNumberSubset_RendersDocumentedCodes(double value, string format, string expected)
{
    NumberFormatter.Format(new NumberValue(value), format).Should().Be(expected);
}
```

- [ ] **Step 2: Run to verify failure**

```powershell
dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter "AccountingSubset|CustomNumberSubset"
```

Expected: FAIL for accounting/fraction/scientific gaps.

- [ ] **Step 3: Implement documented subset**

In `NumberFormatter.ApplyNumericFormat`, before passing to .NET:

- Remove `_`, `*`, and spacing fill directives while preserving visible currency symbols.
- Handle quoted zero section `"-"`.
- Detect simple fraction patterns containing `?/?`.
- Preserve scientific patterns containing `E+00` or `E-00`.

Add helpers:

```csharp
private static string CleanExcelSpacingDirectives(string format)
{
    var sb = new System.Text.StringBuilder();
    for (var i = 0; i < format.Length; i++)
    {
        if ((format[i] == '_' || format[i] == '*') && i + 1 < format.Length)
        {
            i++;
            continue;
        }
        sb.Append(format[i]);
    }
    return sb.ToString();
}
```

and:

```csharp
private static string FormatSimpleFraction(double value, string format)
{
    var denominatorLimit = format.Contains("??", StringComparison.Ordinal) ? 99 : 9;
    var sign = value < 0 ? "-" : "";
    value = Math.Abs(value);
    var whole = (int)Math.Floor(value);
    var fraction = value - whole;
    var bestDen = 1;
    var bestNum = 0;
    var bestError = double.MaxValue;
    for (var den = 1; den <= denominatorLimit; den++)
    {
        var num = (int)Math.Round(fraction * den);
        var error = Math.Abs(fraction - (double)num / den);
        if (error < bestError)
        {
            bestError = error;
            bestDen = den;
            bestNum = num;
        }
    }
    return whole == 0 ? $"{sign}{bestNum}/{bestDen}" : $"{sign}{whole} {bestNum}/{bestDen}";
}
```

- [ ] **Step 4: Document remaining locale/accounting gap**

In `docs/COMMAND_SURFACE_PARITY.md`, keep `Full Excel locale/accounting fidelity` as Partial and change notes to:

```markdown
Invariant-culture accounting/date/currency subset implemented; OS locale-specific spacing, localized currency/accounting names, and all LCID variants remain partial.
```

- [ ] **Step 5: Verify**

```powershell
dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter "NumberFormatter"
dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter NumberFormatDecimalAdjuster
```

Expected: PASS.

- [ ] **Step 6: Commit**

```powershell
git add src\FreeX.Core.Calc\NumberFormatter.cs src\FreeX.App.Host\NumberFormatDecimalAdjuster.cs src\FreeX.App.Host\FormatCellsDialog.xaml.cs tests\FreeX.Core.Calc.Tests\NumberFormatterTests.cs tests\FreeX.Core.Calc.Tests\NumberFormatterDateTests.cs tests\FreeX.App.Host.Tests\NumberFormatDecimalAdjusterTests.cs docs\COMMAND_SURFACE_PARITY.md
git commit -m "feat: improve custom and accounting number format subset"
```

---

### Task 9: Export PDF/XPS Options

**Files:**
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Modify: `src/FreeX.App.Host/PrintRenderer.cs`
- Modify: `tests/FreeX.Integration.Tests/PrintTests.cs`
- Modify: `tests/FreeX.App.Host.Tests/MainWindowSourceHygieneTests.cs`

- [ ] **Step 1: Add tests for export path planning**

In `tests/FreeX.Integration.Tests/PrintTests.cs`, add:

```csharp
[Fact]
public void PrintRenderer_RenderWorksheet_UsesPageSetupOptionsForExport()
{
    var wb = new Workbook("Book");
    var sheet = wb.AddSheet("Sheet1");
    sheet.PageOrientation = WorksheetPageOrientation.Landscape;
    sheet.PaperSize = WorksheetPaperSize.Letter;
    sheet.PageMargins = new WorksheetPageMargins(0.25, 0.25, 0.25, 0.25);
    sheet.SetCell(new CellAddress(sheet.Id, 1, 1), new TextValue("Export"));

    var doc = PrintRenderer.RenderWorksheet(wb, sheet.Id, new ViewportService());

    doc.Pages.Count.Should().BeGreaterThan(0);
    doc.DocumentPaginator.PageSize.Width.Should().BeGreaterThan(doc.DocumentPaginator.PageSize.Height);
}
```

- [ ] **Step 2: Run to verify current behavior**

```powershell
dotnet test tests\FreeX.Integration.Tests\FreeX.Integration.Tests.csproj --filter PrintRenderer_RenderWorksheet_UsesPageSetupOptionsForExport
```

Expected: PASS if existing print setup already works; FAIL if page options are incomplete.

- [ ] **Step 3: Add explicit export option planner**

Add a small internal planner in `MainWindow.xaml.cs` or a new focused file if source hygiene prefers:

```csharp
internal enum ExportFormat { Xps, PdfViaWindowsPrinter }

internal sealed record ExportRequest(string Path, ExportFormat Format);

internal static ExportFormat InferExportFormat(string path) =>
    path.EndsWith(".xps", StringComparison.OrdinalIgnoreCase)
        ? ExportFormat.Xps
        : ExportFormat.PdfViaWindowsPrinter;
```

Use it in `ExportPdfButton_Click`.

- [ ] **Step 4: Make failure explicit when PDF virtual printer is missing**

In `ExportViaPrintToPdf`, if the Windows PDF printer path fails, show:

```csharp
MessageBox.Show(
    "Windows Print to PDF is unavailable. Exported XPS instead; use a PDF printer or convert the XPS file.",
    "Export PDF",
    MessageBoxButton.OK,
    MessageBoxImage.Information);
```

- [ ] **Step 5: Verify**

```powershell
dotnet test tests\FreeX.Integration.Tests\FreeX.Integration.Tests.csproj --filter Print
dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter Export
```

Expected: PASS.

- [ ] **Step 6: Commit**

```powershell
git add src\FreeX.App.Host\MainWindow.xaml.cs src\FreeX.App.Host\PrintRenderer.cs tests\FreeX.Integration.Tests\PrintTests.cs tests\FreeX.App.Host.Tests\MainWindowSourceHygieneTests.cs
git commit -m "feat: clarify PDF and XPS export behavior"
```

---

### Task 10: Flash Fill Inference Improvements

**Files:**
- Modify: `src/FreeX.Core.Commands/FlashFillService.cs`
- Modify: `src/FreeX.Core.Commands/FlashFillCommand.cs`
- Modify: `tests/FreeX.Core.Model.Tests/FlashFillServiceTests.cs`

- [ ] **Step 1: Add failing tests for common Excel-like patterns**

In `tests/FreeX.Core.Model.Tests/FlashFillServiceTests.cs`, add:

```csharp
[Fact]
public void FlashFill_CombinesFirstAndLastName()
{
    var examples = new[]
    {
        ("Ada", "Lovelace", "Ada Lovelace"),
        ("Grace", "Hopper", "Grace Hopper")
    };

    FlashFillService.FillFromColumns(
        examples.Select(e => new[] { e.Item1, e.Item2 }).ToList(),
        examples.Select(e => e.Item3).ToList(),
        [new[] { "Alan", "Turing" }])
        .Should().Equal("Alan Turing");
}

[Fact]
public void FlashFill_ExtractsInitialsFromTwoWords()
{
    var examples = new[]
    {
        ("Ada Lovelace", "AL"),
        ("Grace Hopper", "GH")
    };

    FlashFillService.Fill(
        examples.Select(e => (e.Item1, e.Item2)).ToList(),
        ["Alan Turing"])
        .Should().Equal("AT");
}
```

- [ ] **Step 2: Run to verify failure**

```powershell
dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --filter FlashFill
```

Expected: FAIL for multi-column combine and initials if not supported.

- [ ] **Step 3: Add pattern detectors**

Add public method:

```csharp
public static IReadOnlyList<string>? FillFromColumns(
    IReadOnlyList<IReadOnlyList<string>> exampleSources,
    IReadOnlyList<string> exampleOutputs,
    IReadOnlyList<IReadOnlyList<string>> remainingSources)
```

Implement only stable deterministic patterns:

- `col0 + " " + col1`
- `col1 + ", " + col0`
- `col0 + "." + col1`
- `first initial + last initial`

Use exact examples to infer the separator/order.

- [ ] **Step 4: Wire command if adjacent source columns exist**

In `FlashFillCommand`, when the fill column has examples and at least two populated columns to the left, try `FillFromColumns` before single-source `Fill`.

- [ ] **Step 5: Verify**

```powershell
dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --filter FlashFill
```

Expected: PASS.

- [ ] **Step 6: Commit**

```powershell
git add src\FreeX.Core.Commands\FlashFillService.cs src\FreeX.Core.Commands\FlashFillCommand.cs tests\FreeX.Core.Model.Tests\FlashFillServiceTests.cs
git commit -m "feat: improve Flash Fill deterministic inference"
```

---

### Task 11: Advanced Chart Families Preservation and Honest UI

**Files:**
- Modify: `src/FreeX.Core.Model/ChartModel.cs`
- Modify: `src/FreeX.Core.Model/ChartTypeSupport.cs`
- Modify: `src/FreeX.Core.Commands/ChartCommands.cs`
- Modify: `src/FreeX.Core.IO/XlsxChartPartReader.cs`
- Modify: `src/FreeX.App.Host/MainWindow.xaml`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Modify: `tests/FreeX.Core.Model.Tests/ChartCommandTests.cs`
- Modify: `tests/FreeX.Core.IO.Tests/XlsxChartPartReaderTests.cs`
- Modify: `tests/FreeX.App.Host.Tests/MainWindowSourceHygieneTests.cs`

- [ ] **Step 1: Add deferred chart enum values and support tests**

In `tests/FreeX.Core.Model.Tests/ChartCommandTests.cs`, add:

```csharp
[Theory]
[InlineData(ChartType.Surface)]
[InlineData(ChartType.Treemap)]
[InlineData(ChartType.Sunburst)]
[InlineData(ChartType.Histogram)]
[InlineData(ChartType.Pareto)]
[InlineData(ChartType.BoxAndWhisker)]
[InlineData(ChartType.Waterfall)]
[InlineData(ChartType.Funnel)]
[InlineData(ChartType.Map)]
[InlineData(ChartType.ThreeDColumn)]
public void AdvancedChartTypes_AreRecognizedButNotRenderable(ChartType type)
{
    ChartTypeSupport.IsKnown(type).Should().BeTrue();
    ChartTypeSupport.IsRenderable(type).Should().BeFalse();
}
```

- [ ] **Step 2: Run to verify failure**

```powershell
dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --filter AdvancedChartTypes
```

Expected: FAIL because enum values/support methods are missing.

- [ ] **Step 3: Extend chart model without pretending to render**

Add enum values:

```csharp
Surface,
Treemap,
Sunburst,
Histogram,
Pareto,
BoxAndWhisker,
Waterfall,
Funnel,
Map,
ThreeDColumn
```

Add support methods:

```csharp
public static bool IsKnown(ChartType type) => Enum.IsDefined(type);

public static bool IsRenderable(ChartType type) =>
    type is ChartType.Column or ChartType.StackedColumn or ChartType.PercentStackedColumn
        or ChartType.Line or ChartType.Pie or ChartType.Doughnut or ChartType.Bar
        or ChartType.StackedBar or ChartType.PercentStackedBar or ChartType.Scatter
        or ChartType.Bubble or ChartType.Area or ChartType.Radar or ChartType.Stock;
```

Update `AddChartCommand` to reject non-renderable chart authoring:

```csharp
if (!ChartTypeSupport.IsRenderable(chartType))
    return new CommandOutcome(false, "This chart family is recognized for XLSX preservation but cannot be authored yet.");
```

- [ ] **Step 4: Add OOXML metadata recognition tests**

In `tests/FreeX.Core.IO.Tests/XlsxChartPartReaderTests.cs`, add tests with minimal chart XML snippets mapping:

- `<c:surfaceChart>` -> `ChartType.Surface`
- `<c:treemapChart>` -> `ChartType.Treemap`
- `<c:sunburstChart>` -> `ChartType.Sunburst`
- `<c:histogramChart>` with Pareto flag -> `ChartType.Pareto`
- `<c:boxWhiskerChart>` -> `ChartType.BoxAndWhisker`
- `<c:waterfallChart>` -> `ChartType.Waterfall`
- `<c:funnelChart>` -> `ChartType.Funnel`
- map chart extension -> `ChartType.Map`

- [ ] **Step 5: Keep UI honest**

In `MainWindow.xaml`, advanced chart menu entries should either be disabled or call a handler that displays:

```csharp
MessageBox.Show(
    "This chart family is retained when opening XLSX files, but authoring and rendering are deferred until its data model and renderer are implemented.",
    "Chart family deferred",
    MessageBoxButton.OK,
    MessageBoxImage.Information);
```

- [ ] **Step 6: Verify**

```powershell
dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --filter Chart
dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --filter Chart
dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter Chart
```

Expected: PASS.

- [ ] **Step 7: Commit**

```powershell
git add src\FreeX.Core.Model\ChartModel.cs src\FreeX.Core.Model\ChartTypeSupport.cs src\FreeX.Core.Commands\ChartCommands.cs src\FreeX.Core.IO\XlsxChartPartReader.cs src\FreeX.App.Host\MainWindow.xaml src\FreeX.App.Host\MainWindow.xaml.cs tests\FreeX.Core.Model.Tests\ChartCommandTests.cs tests\FreeX.Core.IO.Tests\XlsxChartPartReaderTests.cs tests\FreeX.App.Host.Tests\MainWindowSourceHygieneTests.cs
git commit -m "feat: recognize and preserve deferred advanced chart families"
```

---

### Task 12: Documentation and Status Finalization

**Files:**
- Modify: `docs/COMMAND_SURFACE_PARITY.md`
- Modify: `docs/MENU_TOOLBAR_PARITY.md`
- Modify: `docs/ARCHITECTURE.md`
- Create: `docs/DECISIONS/007-commands-parity-closeout.md`

- [ ] **Step 1: Update command status rows**

Set these statuses:

```markdown
| Cut (Ctrl+X) | Implemented | Copy + clear with cut marquee state; paste consumes cut state |
| Copy (Ctrl+C) | Implemented | Copy marquee state |
| Paste (Ctrl+V) | Implemented | Internal values/formulas/formats/all and external text paste covered; unsupported external rich formats are intentionally plain-text |
| Paste Special (values/formulas/formats/transpose/arithmetic/link/column-widths/picture) | Implemented | Supported modes are undoable; external OLE/rich-object paste excluded |
| Format Painter | Implemented | Single-click and persistent double-click modes |
| Distributed/Justify alignment | Implemented | Supported in style model, dialog, renderer, and XLSX IO |
| Shrink to Fit | Implemented | Supported in style model, dialog, renderer, and XLSX IO |
| Format Cells Alignment dialog | Implemented | Covers supported alignment model |
| Custom Number Format | Partial | Documented Excel format subset; unsupported locale/LCID details remain partial |
| Full Excel locale/accounting fidelity | Partial | Invariant/accounting subset; full Excel/OS locale fidelity remains partial |
| AutoFit Row/Column | Implemented | Measurement-based estimate over selected cells |
| Format Cells dialog (Ctrl+1) | Implemented | Covers supported Number/Alignment/Font/Fill/Border/Protection model |
| Flash Fill | Partial | Expanded deterministic inference; Excel's full ML-like inference remains partial |
```

Keep advanced chart families as:

```markdown
| Advanced Chart Families | Deferred | Recognized and retained from XLSX; authoring/rendering deferred until per-family data model and renderer exist |
```

Keep PDF/XPS as:

```markdown
| Export to PDF/XPS | Partial | XPS export implemented; PDF uses Windows Print-to-PDF when available and falls back clearly |
```

- [ ] **Step 2: Add ADR**

Create `docs/DECISIONS/007-commands-parity-closeout.md`:

```markdown
# ADR-007: Commands Parity Closeout Boundaries

**Date**: 2026-05-19
**Status**: Accepted

## Context

FreeX tracks visible Excel commands and many commands have reached Partial status. Some partial rows are small interaction gaps over an existing model; others require substantial new renderers or locale engines.

## Decision

Move model-backed command gaps to Implemented when they are undoable, tested, and visible in the UI. Keep advanced chart families Deferred until they have dedicated data models and renderers. Keep full locale/accounting fidelity Partial while documenting the invariant subset FreeX supports.

## Consequences

- Command parity becomes honest and test-backed instead of checklist-driven.
- Advanced chart XML can be preserved without exposing non-working authoring commands.
- Full Excel locale matching remains outside the current closeout.
```

- [ ] **Step 3: Verify full suite**

```powershell
dotnet test FreeX.slnx
```

Expected: all tests pass.

- [ ] **Step 4: Commit**

```powershell
git add docs\COMMAND_SURFACE_PARITY.md docs\MENU_TOOLBAR_PARITY.md docs\ARCHITECTURE.md docs\DECISIONS\007-commands-parity-closeout.md
git commit -m "docs: finalize commands parity closeout status"
```

---

## Execution Order

Recommended order:

1. Task 1: Baseline audit.
2. Task 2: Clipboard visual state.
3. Task 3: Paste matrix.
4. Task 4: Persistent Format Painter.
5. Task 5: Alignment and Shrink to Fit.
6. Task 6: AutoFit.
7. Task 7: Format Cells dialog.
8. Task 8: Number formatting.
9. Task 10: Flash Fill.
10. Task 9: PDF/XPS export.
11. Task 11: Advanced chart family preservation.
12. Task 12: Documentation finalization.

This order turns visible Home-tab commands green first, then finishes File/Insert documentation boundaries.

---

## Verification Before Merge

Run:

```powershell
dotnet build FreeX.slnx
dotnet test FreeX.slnx
```

Manual smoke:

1. Launch FreeX.
2. Copy a range and verify copy marquee.
3. Cut a range and verify cut marquee, paste, and source clear.
4. Double-click Format Painter and apply to two separate target ranges.
5. Open Format Cells with `Ctrl+1`; set Alignment, Shrink to Fit, Number, Font, Fill, Border, Protection.
6. Use AutoFit row and column from Home > Format.
7. Try Flash Fill on first/last name examples.
8. Export XPS; try PDF path if Windows Print-to-PDF is available.
9. Try an advanced chart family command and verify it clearly says deferred rather than creating a broken chart.

---

## Self-Review

**Spec coverage:** Every user-listed row maps to at least one task. Advanced chart families and full locale/accounting fidelity remain intentionally not fully implemented because they require larger per-family renderer/data-model and locale engines.

**Placeholder scan:** No `TBD`, generic "handle edge cases", or empty test instructions remain. Each task has exact files, test names, commands, and expected outcomes.

**Type consistency:** New style fields are consistently named `ShrinkToFit`, `HorizontalAlignment.Justify`, `HorizontalAlignment.Distributed`, `VerticalAlignment.Justify`, and `VerticalAlignment.Distributed`; chart support methods are consistently `IsKnown` and `IsRenderable`.
