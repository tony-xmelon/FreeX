# Phase 5a — Editing UX Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add full editing UX to FreeX: formatting toolbar, merged cells, insert/delete rows & columns, autofill, right-click context menu, Format Cells dialog, and status bar.

**Architecture:** All mutations continue to flow through `ICommandBus` + `IWorkbookCommand`. New model types (`StyleDiff`, `Sheet.MergedRegions`) live in `Core.Model`. New commands (`ApplyStyleCommand`, `MergeCellsCommand`, `InsertRowsCommand`, etc.) live in `Core.Commands`. UI additions are in `App.UI` (GridView) and `App.Host` (MainWindow, dialogs).

**Tech Stack:** C# 12 / .NET 10, WPF, xUnit + FluentAssertions, ClosedXML 0.105.0.

**Test runner:** `dotnet test tests/FreeX.Core.Model.Tests/ --no-build` (after first build with `dotnet build`)

---

## File Map

| File | Action |
|---|---|
| `src/FreeX.Core.Model/CellStyle.cs` | Add `Strikethrough` property + `StyleDiff` record |
| `src/FreeX.Core.Model/Sheet.cs` | Add `MergedRegions`, `GetMergeRegion`, `IsMerged` |
| `src/FreeX.Core.Commands/ApplyStyleCommand.cs` | New command |
| `src/FreeX.Core.Commands/MergeCellsCommand.cs` | New — `MergeCellsCommand` + `UnmergeCellsCommand` |
| `src/FreeX.Core.Commands/InsertDeleteRowsCommand.cs` | New — `InsertRowsCommand` + `DeleteRowsCommand` |
| `src/FreeX.Core.Commands/InsertDeleteColumnsCommand.cs` | New — `InsertColumnsCommand` + `DeleteColumnsCommand` |
| `src/FreeX.Core.Commands/AutofillCommand.cs` | New command |
| `src/FreeX.Core.IO/XlsxFileAdapter.cs` | Add merged region save/load |
| `src/FreeX.App.UI/GridView.cs` | Merged rendering, autofill handle, Shift+click, context menu event |
| `src/FreeX.App.Host/MainWindow.xaml` | Add formatting toolbar row + updated status bar |
| `src/FreeX.App.Host/MainWindow.xaml.cs` | Toolbar handlers, insert/delete, autofill, context menu, status bar |
| `src/FreeX.App.Host/FormatCellsDialog.xaml` | New dialog |
| `src/FreeX.App.Host/FormatCellsDialog.xaml.cs` | New dialog |
| `src/FreeX.App.Host/StatusBarCalculator.cs` | New static helper |
| `tests/FreeX.Core.Model.Tests/ApplyStyleCommandTests.cs` | New |
| `tests/FreeX.Core.Model.Tests/MergeCellsCommandTests.cs` | New |
| `tests/FreeX.Core.Model.Tests/InsertDeleteRowsTests.cs` | New |
| `tests/FreeX.Core.Model.Tests/InsertDeleteColumnsTests.cs` | New |
| `tests/FreeX.Core.Model.Tests/AutofillCommandTests.cs` | New |
| `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs` | Add merged cells round-trip test |

---

## Task 1: StyleDiff record + Strikethrough + Sheet.MergedRegions

**Files:**
- Modify: `src/FreeX.Core.Model/CellStyle.cs`
- Modify: `src/FreeX.Core.Model/Sheet.cs`

- [ ] **Step 1: Add Strikethrough to CellStyle and add StyleDiff record**

Open `src/FreeX.Core.Model/CellStyle.cs`. After the `Underline` property (line 80), add:

```csharp
/// <summary>Strikethrough text.</summary>
public bool Strikethrough { get; set; }
```

Update `Clone()` to include `Strikethrough = Strikethrough,`.

Update `Equals(CellStyle? other)` to add `&& Strikethrough == other.Strikethrough`.

Update `GetHashCode()` to add `h.Add(Strikethrough);`.

At the end of the file (before the closing `}`), add the `StyleDiff` record:

```csharp
/// <summary>
/// A partial style override. Null fields mean "leave unchanged".
/// Apply via ApplyStyleCommand to avoid resetting unrelated properties.
/// </summary>
public record StyleDiff(
    bool? Bold           = null,
    bool? Italic         = null,
    bool? Underline      = null,
    bool? Strikethrough  = null,
    string? FontName     = null,
    double? FontSize     = null,
    CellColor? FontColor = null,
    CellColor? FillColor = null,
    HorizontalAlignment? HAlign = null,
    VerticalAlignment? VAlign   = null,
    bool? WrapText       = null,
    string? NumberFormat = null
)
{
    /// <summary>Apply this diff to a base style, returning a new style with only non-null fields overridden.</summary>
    public CellStyle ApplyTo(CellStyle base_)
    {
        var s = base_.Clone();
        if (Bold           is not null) s.Bold           = Bold.Value;
        if (Italic         is not null) s.Italic         = Italic.Value;
        if (Underline      is not null) s.Underline      = Underline.Value;
        if (Strikethrough  is not null) s.Strikethrough  = Strikethrough.Value;
        if (FontName       is not null) s.FontName       = FontName;
        if (FontSize       is not null) s.FontSize       = FontSize.Value;
        if (FontColor      is not null) s.FontColor      = FontColor.Value;
        if (FillColor      is not null) s.FillColor      = FillColor.Value;
        if (HAlign         is not null) s.HorizontalAlignment = HAlign.Value;
        if (VAlign         is not null) s.VerticalAlignment   = VAlign.Value;
        if (WrapText       is not null) s.WrapText       = WrapText.Value;
        if (NumberFormat   is not null) s.NumberFormat   = NumberFormat;
        return s;
    }
}
```

- [ ] **Step 2: Add MergedRegions + helpers to Sheet**

Open `src/FreeX.Core.Model/Sheet.cs`. After the `HiddenRows` property, add:

```csharp
/// <summary>Merged cell regions on this sheet. Each range's top-left cell holds the display value.</summary>
public List<GridRange> MergedRegions { get; } = [];

/// <summary>Returns the merged region that contains <paramref name="addr"/>, or null if not merged.</summary>
public GridRange? GetMergeRegion(CellAddress addr)
{
    foreach (var r in MergedRegions)
        if (r.Contains(addr)) return r;
    return null;
}

/// <summary>True if <paramref name="addr"/> is inside any merged region.</summary>
public bool IsMerged(CellAddress addr) => GetMergeRegion(addr) is not null;
```

- [ ] **Step 3: Build to confirm no compilation errors**

```
dotnet build src/FreeX.Core.Model/FreeX.Core.Model.csproj
```

Expected: `Build succeeded.` with 0 errors.

- [ ] **Step 4: Commit**

```
git add src/FreeX.Core.Model/CellStyle.cs src/FreeX.Core.Model/Sheet.cs
git commit -m "feat: add StyleDiff record, Strikethrough to CellStyle, MergedRegions to Sheet"
```

---

## Task 2: ApplyStyleCommand

**Files:**
- Create: `src/FreeX.Core.Commands/ApplyStyleCommand.cs`
- Create: `tests/FreeX.Core.Model.Tests/ApplyStyleCommandTests.cs`

- [ ] **Step 1: Write the failing tests**

Create `tests/FreeX.Core.Model.Tests/ApplyStyleCommandTests.cs`:

```csharp
using FreeX.Core.Commands;
using FreeX.Core.Model;
using FluentAssertions;

namespace FreeX.Core.Model.Tests;

public class ApplyStyleCommandTests
{
    private static (Workbook wb, Sheet sheet, ICommandContext ctx) Setup()
    {
        var wb = new Workbook("test");
        var sheet = wb.AddSheet("Sheet1");
        var ctx = new SimpleCtx(wb);
        return (wb, sheet, ctx);
    }

    [Fact]
    public void ApplyBold_SetsBoldOnTargetCell()
    {
        var (wb, sheet, ctx) = Setup();
        var addr = new CellAddress(sheet.Id, 1, 1);
        sheet.SetCell(addr, new NumberValue(1));

        var range = new GridRange(addr, addr);
        var cmd = new ApplyStyleCommand(sheet.Id, range, new StyleDiff(Bold: true));
        cmd.Apply(ctx);

        var style = wb.GetStyle(sheet.GetCell(addr)!.StyleId);
        style.Bold.Should().BeTrue();
    }

    [Fact]
    public void ApplyBold_DoesNotChangeFontColor()
    {
        var (wb, sheet, ctx) = Setup();
        var addr = new CellAddress(sheet.Id, 1, 1);
        var baseStyle = new CellStyle { FontColor = new CellColor(255, 0, 0) };
        var cell = Cell.FromValue(new NumberValue(1));
        cell.StyleId = wb.RegisterStyle(baseStyle);
        sheet.SetCell(addr, cell);

        var range = new GridRange(addr, addr);
        var cmd = new ApplyStyleCommand(sheet.Id, range, new StyleDiff(Bold: true));
        cmd.Apply(ctx);

        var style = wb.GetStyle(sheet.GetCell(addr)!.StyleId);
        style.Bold.Should().BeTrue();
        style.FontColor.Should().Be(new CellColor(255, 0, 0));
    }

    [Fact]
    public void ApplyToRange_AllCellsUpdated()
    {
        var (wb, sheet, ctx) = Setup();
        var a1 = new CellAddress(sheet.Id, 1, 1);
        var b2 = new CellAddress(sheet.Id, 2, 2);
        sheet.SetCell(a1, new NumberValue(1));
        sheet.SetCell(b2, new NumberValue(2));

        var range = new GridRange(a1, b2);
        var cmd = new ApplyStyleCommand(sheet.Id, range, new StyleDiff(Italic: true));
        cmd.Apply(ctx);

        wb.GetStyle(sheet.GetCell(a1)!.StyleId).Italic.Should().BeTrue();
        wb.GetStyle(sheet.GetCell(b2)!.StyleId).Italic.Should().BeTrue();
    }

    [Fact]
    public void Revert_RestoresOriginalStyles()
    {
        var (wb, sheet, ctx) = Setup();
        var addr = new CellAddress(sheet.Id, 1, 1);
        var original = new CellStyle { Bold = true };
        var cell = Cell.FromValue(new NumberValue(1));
        cell.StyleId = wb.RegisterStyle(original);
        sheet.SetCell(addr, cell);
        var originalStyleId = cell.StyleId;

        var range = new GridRange(addr, addr);
        var cmd = new ApplyStyleCommand(sheet.Id, range, new StyleDiff(Italic: true));
        cmd.Apply(ctx);
        cmd.Revert(ctx);

        sheet.GetCell(addr)!.StyleId.Should().Be(originalStyleId);
    }

    [Fact]
    public void Apply_CreatesNewCellIfMissing()
    {
        var (wb, sheet, ctx) = Setup();
        var addr = new CellAddress(sheet.Id, 5, 5);  // no cell here

        var range = new GridRange(addr, addr);
        var cmd = new ApplyStyleCommand(sheet.Id, range, new StyleDiff(Bold: true));
        cmd.Apply(ctx);

        // Cell should be created (as blank) with the style applied
        var cell = sheet.GetCell(addr);
        cell.Should().NotBeNull();
        wb.GetStyle(cell!.StyleId).Bold.Should().BeTrue();
    }

    private sealed class SimpleCtx(Workbook wb) : ICommandContext
    {
        public Workbook Workbook { get; } = wb;
        public Sheet GetSheet(SheetId id) => Workbook.GetSheet(id)!;
    }
}
```

- [ ] **Step 2: Run tests — confirm they fail**

```
dotnet test tests/FreeX.Core.Model.Tests/ --filter "ApplyStyleCommandTests"
```

Expected: compilation error or `ApplyStyleCommand` not found.

- [ ] **Step 3: Implement ApplyStyleCommand**

Create `src/FreeX.Core.Commands/ApplyStyleCommand.cs`:

```csharp
using FreeX.Core.Model;

namespace FreeX.Core.Commands;

/// <summary>
/// Applies a partial style override to every cell in a range.
/// Only non-null StyleDiff fields are changed; others are preserved.
/// </summary>
public sealed class ApplyStyleCommand : IWorkbookCommand
{
    private readonly SheetId _sheetId;
    private readonly GridRange _range;
    private readonly StyleDiff _diff;
    private List<(CellAddress Address, StyleId OldStyleId)>? _snapshot;

    public string Label => "Apply Style";

    public ApplyStyleCommand(SheetId sheetId, GridRange range, StyleDiff diff)
    {
        _sheetId = sheetId;
        _range   = range;
        _diff    = diff;
    }

    public CommandOutcome Apply(ICommandContext ctx)
    {
        var sheet = ctx.GetSheet(_sheetId);
        _snapshot = [];

        foreach (var addr in _range.AllCells())
        {
            var cell = sheet.GetCell(addr);

            // Create a blank cell if none exists so the style can be set
            if (cell is null)
            {
                cell = Cell.FromValue(BlankValue.Instance);
                sheet.SetCell(addr, cell);
            }

            _snapshot.Add((addr, cell.StyleId));

            var baseStyle = ctx.Workbook.GetStyle(cell.StyleId);
            var newStyle  = _diff.ApplyTo(baseStyle);
            cell.StyleId  = ctx.Workbook.RegisterStyle(newStyle);
        }

        return new CommandOutcome(true);
    }

    public void Revert(ICommandContext ctx)
    {
        if (_snapshot is null) return;
        var sheet = ctx.GetSheet(_sheetId);
        foreach (var (addr, oldStyleId) in _snapshot)
        {
            var cell = sheet.GetCell(addr);
            if (cell is not null)
                cell.StyleId = oldStyleId;
        }
    }
}
```

- [ ] **Step 4: Run tests — confirm they pass**

```
dotnet test tests/FreeX.Core.Model.Tests/ --filter "ApplyStyleCommandTests"
```

Expected: `5 passed`.

- [ ] **Step 5: Commit**

```
git add src/FreeX.Core.Commands/ApplyStyleCommand.cs tests/FreeX.Core.Model.Tests/ApplyStyleCommandTests.cs
git commit -m "feat: ApplyStyleCommand with StyleDiff partial override"
```

---

## Task 3: MergeCellsCommand + UnmergeCellsCommand

**Files:**
- Create: `src/FreeX.Core.Commands/MergeCellsCommand.cs`
- Create: `tests/FreeX.Core.Model.Tests/MergeCellsCommandTests.cs`

- [ ] **Step 1: Write the failing tests**

Create `tests/FreeX.Core.Model.Tests/MergeCellsCommandTests.cs`:

```csharp
using FreeX.Core.Commands;
using FreeX.Core.Model;
using FluentAssertions;

namespace FreeX.Core.Model.Tests;

public class MergeCellsCommandTests
{
    private static (Workbook wb, Sheet sheet, ICommandContext ctx) Setup()
    {
        var wb = new Workbook("test");
        var sheet = wb.AddSheet("Sheet1");
        return (wb, sheet, new SimpleCtx(wb));
    }

    [Fact]
    public void Merge_AddsRegionToSheet()
    {
        var (_, sheet, ctx) = Setup();
        var range = new GridRange(
            new CellAddress(sheet.Id, 1, 1),
            new CellAddress(sheet.Id, 2, 3));

        new MergeCellsCommand(sheet.Id, range).Apply(ctx);

        sheet.MergedRegions.Should().ContainSingle().Which.Should().Be(range);
    }

    [Fact]
    public void Merge_ClearsNonTopLeftCells()
    {
        var (_, sheet, ctx) = Setup();
        var a1 = new CellAddress(sheet.Id, 1, 1);
        var b1 = new CellAddress(sheet.Id, 1, 2);
        sheet.SetCell(a1, new NumberValue(99));
        sheet.SetCell(b1, new NumberValue(42));

        var range = new GridRange(a1, b1);
        new MergeCellsCommand(sheet.Id, range).Apply(ctx);

        sheet.GetCell(a1)!.Value.Should().Be(new NumberValue(99)); // top-left preserved
        sheet.GetCell(b1).Should().BeNull();  // non-top-left cleared
    }

    [Fact]
    public void Merge_RejectsOverlappingRegion()
    {
        var (_, sheet, ctx) = Setup();
        var r1 = new GridRange(
            new CellAddress(sheet.Id, 1, 1),
            new CellAddress(sheet.Id, 3, 3));
        var r2 = new GridRange(
            new CellAddress(sheet.Id, 2, 2),
            new CellAddress(sheet.Id, 4, 4));

        new MergeCellsCommand(sheet.Id, r1).Apply(ctx);
        var outcome = new MergeCellsCommand(sheet.Id, r2).Apply(ctx);

        outcome.Success.Should().BeFalse();
        sheet.MergedRegions.Should().HaveCount(1);
    }

    [Fact]
    public void MergeRevert_RemovesRegionAndRestoresCells()
    {
        var (_, sheet, ctx) = Setup();
        var a1 = new CellAddress(sheet.Id, 1, 1);
        var b1 = new CellAddress(sheet.Id, 1, 2);
        sheet.SetCell(a1, new NumberValue(99));
        sheet.SetCell(b1, new NumberValue(42));

        var range = new GridRange(a1, b1);
        var cmd = new MergeCellsCommand(sheet.Id, range);
        cmd.Apply(ctx);
        cmd.Revert(ctx);

        sheet.MergedRegions.Should().BeEmpty();
        sheet.GetCell(b1)!.Value.Should().Be(new NumberValue(42));
    }

    [Fact]
    public void Unmerge_RemovesExistingRegion()
    {
        var (_, sheet, ctx) = Setup();
        var range = new GridRange(
            new CellAddress(sheet.Id, 1, 1),
            new CellAddress(sheet.Id, 2, 2));

        sheet.MergedRegions.Add(range);
        new UnmergeCellsCommand(sheet.Id, range).Apply(ctx);

        sheet.MergedRegions.Should().BeEmpty();
    }

    [Fact]
    public void UnmergeRevert_RestoresRegion()
    {
        var (_, sheet, ctx) = Setup();
        var range = new GridRange(
            new CellAddress(sheet.Id, 1, 1),
            new CellAddress(sheet.Id, 2, 2));
        sheet.MergedRegions.Add(range);

        var cmd = new UnmergeCellsCommand(sheet.Id, range);
        cmd.Apply(ctx);
        cmd.Revert(ctx);

        sheet.MergedRegions.Should().ContainSingle().Which.Should().Be(range);
    }

    private sealed class SimpleCtx(Workbook wb) : ICommandContext
    {
        public Workbook Workbook { get; } = wb;
        public Sheet GetSheet(SheetId id) => Workbook.GetSheet(id)!;
    }
}
```

- [ ] **Step 2: Run tests — confirm they fail**

```
dotnet test tests/FreeX.Core.Model.Tests/ --filter "MergeCellsCommandTests"
```

Expected: compile error — types not yet defined.

- [ ] **Step 3: Implement MergeCellsCommand and UnmergeCellsCommand**

Create `src/FreeX.Core.Commands/MergeCellsCommand.cs`:

```csharp
using FreeX.Core.Model;

namespace FreeX.Core.Commands;

/// <summary>Merges a rectangular range into a single cell region.</summary>
public sealed class MergeCellsCommand : IWorkbookCommand
{
    private readonly SheetId _sheetId;
    private readonly GridRange _range;
    private List<(CellAddress Address, Cell? OldCell)>? _snapshot;

    public string Label => "Merge Cells";

    public MergeCellsCommand(SheetId sheetId, GridRange range)
    {
        _sheetId = sheetId;
        _range   = range;
    }

    public CommandOutcome Apply(ICommandContext ctx)
    {
        var sheet = ctx.GetSheet(_sheetId);

        // Reject if range overlaps any existing merge
        foreach (var existing in sheet.MergedRegions)
        {
            if (Overlaps(_range, existing))
                return new CommandOutcome(false, "Range overlaps an existing merged region.");
        }

        // Snapshot all cells in range for undo
        _snapshot = [];
        foreach (var addr in _range.AllCells())
            _snapshot.Add((addr, sheet.GetCell(addr)?.Clone()));

        // Clear all non-top-left cells
        var topLeft = _range.Start;
        foreach (var addr in _range.AllCells())
        {
            if (addr == topLeft) continue;
            sheet.ClearCell(addr);
        }

        sheet.MergedRegions.Add(_range);
        return new CommandOutcome(true);
    }

    public void Revert(ICommandContext ctx)
    {
        if (_snapshot is null) return;
        var sheet = ctx.GetSheet(_sheetId);

        sheet.MergedRegions.Remove(_range);

        foreach (var (addr, oldCell) in _snapshot)
        {
            if (oldCell is null)
                sheet.ClearCell(addr);
            else
                sheet.SetCell(addr, oldCell.Clone());
        }
    }

    private static bool Overlaps(GridRange a, GridRange b) =>
        a.Start.Row <= b.End.Row && a.End.Row >= b.Start.Row &&
        a.Start.Col <= b.End.Col && a.End.Col >= b.Start.Col;
}

/// <summary>Removes a merged cell region (makes cells independent again).</summary>
public sealed class UnmergeCellsCommand : IWorkbookCommand
{
    private readonly SheetId _sheetId;
    private readonly GridRange _range;

    public string Label => "Unmerge Cells";

    public UnmergeCellsCommand(SheetId sheetId, GridRange range)
    {
        _sheetId = sheetId;
        _range   = range;
    }

    public CommandOutcome Apply(ICommandContext ctx)
    {
        var sheet = ctx.GetSheet(_sheetId);
        sheet.MergedRegions.Remove(_range);
        return new CommandOutcome(true);
    }

    public void Revert(ICommandContext ctx)
    {
        var sheet = ctx.GetSheet(_sheetId);
        if (!sheet.MergedRegions.Contains(_range))
            sheet.MergedRegions.Add(_range);
    }
}
```

- [ ] **Step 4: Run tests — confirm they pass**

```
dotnet test tests/FreeX.Core.Model.Tests/ --filter "MergeCellsCommandTests"
```

Expected: `6 passed`.

- [ ] **Step 5: Commit**

```
git add src/FreeX.Core.Commands/MergeCellsCommand.cs tests/FreeX.Core.Model.Tests/MergeCellsCommandTests.cs
git commit -m "feat: MergeCellsCommand and UnmergeCellsCommand"
```

---

## Task 4: InsertRowsCommand + DeleteRowsCommand

**Files:**
- Create: `src/FreeX.Core.Commands/InsertDeleteRowsCommand.cs`
- Create: `tests/FreeX.Core.Model.Tests/InsertDeleteRowsTests.cs`

- [ ] **Step 1: Write the failing tests**

Create `tests/FreeX.Core.Model.Tests/InsertDeleteRowsTests.cs`:

```csharp
using FreeX.Core.Commands;
using FreeX.Core.Model;
using FluentAssertions;

namespace FreeX.Core.Model.Tests;

public class InsertDeleteRowsTests
{
    private static (Workbook wb, Sheet sheet, ICommandContext ctx) Setup()
    {
        var wb = new Workbook("test");
        var sheet = wb.AddSheet("Sheet1");
        return (wb, sheet, new SimpleCtx(wb));
    }

    [Fact]
    public void InsertRow_ShiftsCellsDown()
    {
        var (_, sheet, ctx) = Setup();
        var addr = new CellAddress(sheet.Id, 3, 1);
        sheet.SetCell(addr, new NumberValue(100));

        new InsertRowsCommand(sheet.Id, beforeRow: 3, count: 1).Apply(ctx);

        // Original row 3 data now at row 4
        sheet.GetValue(4, 1).Should().Be(new NumberValue(100));
        sheet.GetCell(3, 1).Should().BeNull();
    }

    [Fact]
    public void InsertRowRevert_RestoresOriginalState()
    {
        var (_, sheet, ctx) = Setup();
        var addr = new CellAddress(sheet.Id, 3, 1);
        sheet.SetCell(addr, new NumberValue(100));

        var cmd = new InsertRowsCommand(sheet.Id, beforeRow: 3, count: 1);
        cmd.Apply(ctx);
        cmd.Revert(ctx);

        sheet.GetValue(3, 1).Should().Be(new NumberValue(100));
        sheet.GetCell(4, 1).Should().BeNull();
    }

    [Fact]
    public void DeleteRow_RemovesCellsAndShiftsUp()
    {
        var (_, sheet, ctx) = Setup();
        sheet.SetCell(new CellAddress(sheet.Id, 2, 1), new NumberValue(20));
        sheet.SetCell(new CellAddress(sheet.Id, 3, 1), new NumberValue(30));

        new DeleteRowsCommand(sheet.Id, startRow: 2, count: 1).Apply(ctx);

        // Row 3 now at row 2
        sheet.GetValue(2, 1).Should().Be(new NumberValue(30));
        sheet.GetCell(3, 1).Should().BeNull();
    }

    [Fact]
    public void DeleteRowRevert_RestoresCells()
    {
        var (_, sheet, ctx) = Setup();
        sheet.SetCell(new CellAddress(sheet.Id, 2, 1), new NumberValue(20));
        sheet.SetCell(new CellAddress(sheet.Id, 3, 1), new NumberValue(30));

        var cmd = new DeleteRowsCommand(sheet.Id, startRow: 2, count: 1);
        cmd.Apply(ctx);
        cmd.Revert(ctx);

        sheet.GetValue(2, 1).Should().Be(new NumberValue(20));
        sheet.GetValue(3, 1).Should().Be(new NumberValue(30));
    }

    [Fact]
    public void InsertRow_ShiftsMergedRegions()
    {
        var (_, sheet, ctx) = Setup();
        var mergeRange = new GridRange(
            new CellAddress(sheet.Id, 3, 1),
            new CellAddress(sheet.Id, 4, 2));
        sheet.MergedRegions.Add(mergeRange);

        new InsertRowsCommand(sheet.Id, beforeRow: 2, count: 1).Apply(ctx);

        sheet.MergedRegions[0].Start.Row.Should().Be(4);
        sheet.MergedRegions[0].End.Row.Should().Be(5);
    }

    private sealed class SimpleCtx(Workbook wb) : ICommandContext
    {
        public Workbook Workbook { get; } = wb;
        public Sheet GetSheet(SheetId id) => Workbook.GetSheet(id)!;
    }
}
```

- [ ] **Step 2: Run tests — confirm they fail**

```
dotnet test tests/FreeX.Core.Model.Tests/ --filter "InsertDeleteRowsTests"
```

Expected: compile error.

- [ ] **Step 3: Implement InsertRowsCommand and DeleteRowsCommand**

Create `src/FreeX.Core.Commands/InsertDeleteRowsCommand.cs`:

```csharp
using FreeX.Core.Model;

namespace FreeX.Core.Commands;

/// <summary>Inserts <paramref name="count"/> blank rows before <paramref name="beforeRow"/>.</summary>
public sealed class InsertRowsCommand : IWorkbookCommand
{
    private readonly SheetId _sheetId;
    private readonly uint _beforeRow;
    private readonly uint _count;
    private List<(CellAddress Addr, Cell Cell)>? _movedSnapshot;
    private List<GridRange>? _mergeSnapshot;

    public string Label => $"Insert {_count} Row(s)";

    public InsertRowsCommand(SheetId sheetId, uint beforeRow, uint count = 1)
    {
        _sheetId   = sheetId;
        _beforeRow = beforeRow;
        _count     = count;
    }

    public CommandOutcome Apply(ICommandContext ctx)
    {
        var sheet = ctx.GetSheet(_sheetId);

        // Snapshot cells that will be shifted
        _movedSnapshot = sheet.EnumerateCells()
            .Where(p => p.Address.Row >= _beforeRow)
            .Select(p => (p.Address, p.Cell.Clone()))
            .ToList();

        // Remove those cells from their current positions (process desc to avoid clobber)
        foreach (var (addr, _) in _movedSnapshot.OrderByDescending(p => p.Addr.Row))
            sheet.ClearCell(addr);

        // Re-place at shifted position
        foreach (var (addr, cell) in _movedSnapshot)
        {
            var newAddr = new CellAddress(addr.Sheet, addr.Row + _count, addr.Col);
            sheet.SetCell(newAddr, cell.Clone());
        }

        // Shift hidden rows
        var hiddenToShift = sheet.HiddenRows.Where(r => r >= _beforeRow).ToList();
        foreach (var r in hiddenToShift) sheet.HiddenRows.Remove(r);
        foreach (var r in hiddenToShift) sheet.HiddenRows.Add(r + _count);

        // Snapshot and shift merged regions
        _mergeSnapshot = sheet.MergedRegions.ToList();
        for (int i = 0; i < sheet.MergedRegions.Count; i++)
        {
            var m = sheet.MergedRegions[i];
            if (m.Start.Row >= _beforeRow)
            {
                sheet.MergedRegions[i] = new GridRange(
                    new CellAddress(m.Start.Sheet, m.Start.Row + _count, m.Start.Col),
                    new CellAddress(m.End.Sheet,   m.End.Row   + _count, m.End.Col));
            }
        }

        return new CommandOutcome(true);
    }

    public void Revert(ICommandContext ctx)
    {
        if (_movedSnapshot is null) return;
        var sheet = ctx.GetSheet(_sheetId);

        // Remove all shifted cells
        foreach (var (addr, _) in _movedSnapshot)
            sheet.ClearCell(new CellAddress(addr.Sheet, addr.Row + _count, addr.Col));

        // Restore originals
        foreach (var (addr, cell) in _movedSnapshot)
            sheet.SetCell(addr, cell.Clone());

        // Restore hidden rows
        var shifted = sheet.HiddenRows.Where(r => r >= _beforeRow + _count).ToList();
        foreach (var r in shifted) sheet.HiddenRows.Remove(r);
        foreach (var r in shifted) sheet.HiddenRows.Add(r - _count);

        // Restore merged regions
        if (_mergeSnapshot is not null)
        {
            sheet.MergedRegions.Clear();
            sheet.MergedRegions.AddRange(_mergeSnapshot);
        }
    }
}

/// <summary>Deletes <paramref name="count"/> rows starting at <paramref name="startRow"/>.</summary>
public sealed class DeleteRowsCommand : IWorkbookCommand
{
    private readonly SheetId _sheetId;
    private readonly uint _startRow;
    private readonly uint _count;
    private List<(CellAddress Addr, Cell Cell)>? _deletedSnapshot;
    private List<(CellAddress Addr, Cell Cell)>? _shiftedSnapshot;
    private List<GridRange>? _mergeSnapshot;

    public string Label => $"Delete {_count} Row(s)";

    public DeleteRowsCommand(SheetId sheetId, uint startRow, uint count = 1)
    {
        _sheetId  = sheetId;
        _startRow = startRow;
        _count    = count;
    }

    public CommandOutcome Apply(ICommandContext ctx)
    {
        var sheet = ctx.GetSheet(_sheetId);
        uint endRow = _startRow + _count - 1;

        // Snapshot deleted and to-be-shifted cells
        _deletedSnapshot = sheet.EnumerateCells()
            .Where(p => p.Address.Row >= _startRow && p.Address.Row <= endRow)
            .Select(p => (p.Address, p.Cell.Clone()))
            .ToList();
        _shiftedSnapshot = sheet.EnumerateCells()
            .Where(p => p.Address.Row > endRow)
            .Select(p => (p.Address, p.Cell.Clone()))
            .ToList();

        // Delete rows in range
        foreach (var (addr, _) in _deletedSnapshot)
            sheet.ClearCell(addr);

        // Shift rows above (process ascending to avoid clobber)
        foreach (var (addr, _) in _shiftedSnapshot.OrderBy(p => p.Addr.Row))
            sheet.ClearCell(addr);
        foreach (var (addr, cell) in _shiftedSnapshot)
        {
            var newAddr = new CellAddress(addr.Sheet, addr.Row - _count, addr.Col);
            sheet.SetCell(newAddr, cell.Clone());
        }

        // Shift hidden rows
        var belowHidden = sheet.HiddenRows.Where(r => r > endRow).ToList();
        var inRangeHidden = sheet.HiddenRows.Where(r => r >= _startRow && r <= endRow).ToList();
        foreach (var r in inRangeHidden) sheet.HiddenRows.Remove(r);
        foreach (var r in belowHidden) { sheet.HiddenRows.Remove(r); sheet.HiddenRows.Add(r - _count); }

        // Snapshot and remove/shift merged regions
        _mergeSnapshot = sheet.MergedRegions.ToList();
        sheet.MergedRegions.RemoveAll(m => m.Start.Row >= _startRow && m.End.Row <= endRow);
        for (int i = 0; i < sheet.MergedRegions.Count; i++)
        {
            var m = sheet.MergedRegions[i];
            if (m.Start.Row > endRow)
            {
                sheet.MergedRegions[i] = new GridRange(
                    new CellAddress(m.Start.Sheet, m.Start.Row - _count, m.Start.Col),
                    new CellAddress(m.End.Sheet,   m.End.Row   - _count, m.End.Col));
            }
        }

        return new CommandOutcome(true);
    }

    public void Revert(ICommandContext ctx)
    {
        if (_deletedSnapshot is null || _shiftedSnapshot is null) return;
        var sheet = ctx.GetSheet(_sheetId);
        uint endRow = _startRow + _count - 1;

        // Remove shifted cells
        foreach (var (addr, _) in _shiftedSnapshot)
            sheet.ClearCell(new CellAddress(addr.Sheet, addr.Row - _count, addr.Col));

        // Restore shifted cells to original positions
        foreach (var (addr, cell) in _shiftedSnapshot)
            sheet.SetCell(addr, cell.Clone());

        // Restore deleted cells
        foreach (var (addr, cell) in _deletedSnapshot)
            sheet.SetCell(addr, cell.Clone());

        // Restore merged regions
        if (_mergeSnapshot is not null)
        {
            sheet.MergedRegions.Clear();
            sheet.MergedRegions.AddRange(_mergeSnapshot);
        }
    }
}
```

- [ ] **Step 4: Run tests — confirm they pass**

```
dotnet test tests/FreeX.Core.Model.Tests/ --filter "InsertDeleteRowsTests"
```

Expected: `5 passed`.

- [ ] **Step 5: Commit**

```
git add src/FreeX.Core.Commands/InsertDeleteRowsCommand.cs tests/FreeX.Core.Model.Tests/InsertDeleteRowsTests.cs
git commit -m "feat: InsertRowsCommand and DeleteRowsCommand"
```

---

## Task 5: InsertColumnsCommand + DeleteColumnsCommand

**Files:**
- Create: `src/FreeX.Core.Commands/InsertDeleteColumnsCommand.cs`
- Create: `tests/FreeX.Core.Model.Tests/InsertDeleteColumnsTests.cs`

- [ ] **Step 1: Write the failing tests**

Create `tests/FreeX.Core.Model.Tests/InsertDeleteColumnsTests.cs`:

```csharp
using FreeX.Core.Commands;
using FreeX.Core.Model;
using FluentAssertions;

namespace FreeX.Core.Model.Tests;

public class InsertDeleteColumnsTests
{
    private static (Workbook wb, Sheet sheet, ICommandContext ctx) Setup()
    {
        var wb = new Workbook("test");
        var sheet = wb.AddSheet("Sheet1");
        return (wb, sheet, new SimpleCtx(wb));
    }

    [Fact]
    public void InsertColumn_ShiftsCellsRight()
    {
        var (_, sheet, ctx) = Setup();
        sheet.SetCell(new CellAddress(sheet.Id, 1, 3), new NumberValue(100));

        new InsertColumnsCommand(sheet.Id, beforeCol: 3, count: 1).Apply(ctx);

        sheet.GetValue(1, 4).Should().Be(new NumberValue(100));
        sheet.GetCell(1, 3).Should().BeNull();
    }

    [Fact]
    public void InsertColumnRevert_RestoresOriginalState()
    {
        var (_, sheet, ctx) = Setup();
        sheet.SetCell(new CellAddress(sheet.Id, 1, 3), new NumberValue(100));

        var cmd = new InsertColumnsCommand(sheet.Id, beforeCol: 3, count: 1);
        cmd.Apply(ctx);
        cmd.Revert(ctx);

        sheet.GetValue(1, 3).Should().Be(new NumberValue(100));
        sheet.GetCell(1, 4).Should().BeNull();
    }

    [Fact]
    public void DeleteColumn_RemovesAndShiftsLeft()
    {
        var (_, sheet, ctx) = Setup();
        sheet.SetCell(new CellAddress(sheet.Id, 1, 2), new NumberValue(20));
        sheet.SetCell(new CellAddress(sheet.Id, 1, 3), new NumberValue(30));

        new DeleteColumnsCommand(sheet.Id, startCol: 2, count: 1).Apply(ctx);

        sheet.GetValue(1, 2).Should().Be(new NumberValue(30));
        sheet.GetCell(1, 3).Should().BeNull();
    }

    [Fact]
    public void DeleteColumnRevert_RestoresCells()
    {
        var (_, sheet, ctx) = Setup();
        sheet.SetCell(new CellAddress(sheet.Id, 1, 2), new NumberValue(20));
        sheet.SetCell(new CellAddress(sheet.Id, 1, 3), new NumberValue(30));

        var cmd = new DeleteColumnsCommand(sheet.Id, startCol: 2, count: 1);
        cmd.Apply(ctx);
        cmd.Revert(ctx);

        sheet.GetValue(1, 2).Should().Be(new NumberValue(20));
        sheet.GetValue(1, 3).Should().Be(new NumberValue(30));
    }

    private sealed class SimpleCtx(Workbook wb) : ICommandContext
    {
        public Workbook Workbook { get; } = wb;
        public Sheet GetSheet(SheetId id) => Workbook.GetSheet(id)!;
    }
}
```

- [ ] **Step 2: Run tests — confirm they fail**

```
dotnet test tests/FreeX.Core.Model.Tests/ --filter "InsertDeleteColumnsTests"
```

Expected: compile error.

- [ ] **Step 3: Implement InsertColumnsCommand and DeleteColumnsCommand**

Create `src/FreeX.Core.Commands/InsertDeleteColumnsCommand.cs`:

```csharp
using FreeX.Core.Model;

namespace FreeX.Core.Commands;

/// <summary>Inserts <paramref name="count"/> blank columns before <paramref name="beforeCol"/>.</summary>
public sealed class InsertColumnsCommand : IWorkbookCommand
{
    private readonly SheetId _sheetId;
    private readonly uint _beforeCol;
    private readonly uint _count;
    private List<(CellAddress Addr, Cell Cell)>? _movedSnapshot;
    private List<GridRange>? _mergeSnapshot;

    public string Label => $"Insert {_count} Column(s)";

    public InsertColumnsCommand(SheetId sheetId, uint beforeCol, uint count = 1)
    {
        _sheetId   = sheetId;
        _beforeCol = beforeCol;
        _count     = count;
    }

    public CommandOutcome Apply(ICommandContext ctx)
    {
        var sheet = ctx.GetSheet(_sheetId);

        _movedSnapshot = sheet.EnumerateCells()
            .Where(p => p.Address.Col >= _beforeCol)
            .Select(p => (p.Address, p.Cell.Clone()))
            .ToList();

        foreach (var (addr, _) in _movedSnapshot.OrderByDescending(p => p.Addr.Col))
            sheet.ClearCell(addr);

        foreach (var (addr, cell) in _movedSnapshot)
            sheet.SetCell(new CellAddress(addr.Sheet, addr.Row, addr.Col + _count), cell.Clone());

        _mergeSnapshot = sheet.MergedRegions.ToList();
        for (int i = 0; i < sheet.MergedRegions.Count; i++)
        {
            var m = sheet.MergedRegions[i];
            if (m.Start.Col >= _beforeCol)
            {
                sheet.MergedRegions[i] = new GridRange(
                    new CellAddress(m.Start.Sheet, m.Start.Row, m.Start.Col + _count),
                    new CellAddress(m.End.Sheet,   m.End.Row,   m.End.Col   + _count));
            }
        }

        return new CommandOutcome(true);
    }

    public void Revert(ICommandContext ctx)
    {
        if (_movedSnapshot is null) return;
        var sheet = ctx.GetSheet(_sheetId);

        foreach (var (addr, _) in _movedSnapshot)
            sheet.ClearCell(new CellAddress(addr.Sheet, addr.Row, addr.Col + _count));

        foreach (var (addr, cell) in _movedSnapshot)
            sheet.SetCell(addr, cell.Clone());

        if (_mergeSnapshot is not null)
        {
            sheet.MergedRegions.Clear();
            sheet.MergedRegions.AddRange(_mergeSnapshot);
        }
    }
}

/// <summary>Deletes <paramref name="count"/> columns starting at <paramref name="startCol"/>.</summary>
public sealed class DeleteColumnsCommand : IWorkbookCommand
{
    private readonly SheetId _sheetId;
    private readonly uint _startCol;
    private readonly uint _count;
    private List<(CellAddress Addr, Cell Cell)>? _deletedSnapshot;
    private List<(CellAddress Addr, Cell Cell)>? _shiftedSnapshot;
    private List<GridRange>? _mergeSnapshot;

    public string Label => $"Delete {_count} Column(s)";

    public DeleteColumnsCommand(SheetId sheetId, uint startCol, uint count = 1)
    {
        _sheetId  = sheetId;
        _startCol = startCol;
        _count    = count;
    }

    public CommandOutcome Apply(ICommandContext ctx)
    {
        var sheet = ctx.GetSheet(_sheetId);
        uint endCol = _startCol + _count - 1;

        _deletedSnapshot = sheet.EnumerateCells()
            .Where(p => p.Address.Col >= _startCol && p.Address.Col <= endCol)
            .Select(p => (p.Address, p.Cell.Clone()))
            .ToList();
        _shiftedSnapshot = sheet.EnumerateCells()
            .Where(p => p.Address.Col > endCol)
            .Select(p => (p.Address, p.Cell.Clone()))
            .ToList();

        foreach (var (addr, _) in _deletedSnapshot) sheet.ClearCell(addr);

        foreach (var (addr, _) in _shiftedSnapshot.OrderBy(p => p.Addr.Col))
            sheet.ClearCell(addr);
        foreach (var (addr, cell) in _shiftedSnapshot)
            sheet.SetCell(new CellAddress(addr.Sheet, addr.Row, addr.Col - _count), cell.Clone());

        _mergeSnapshot = sheet.MergedRegions.ToList();
        sheet.MergedRegions.RemoveAll(m => m.Start.Col >= _startCol && m.End.Col <= endCol);
        for (int i = 0; i < sheet.MergedRegions.Count; i++)
        {
            var m = sheet.MergedRegions[i];
            if (m.Start.Col > endCol)
            {
                sheet.MergedRegions[i] = new GridRange(
                    new CellAddress(m.Start.Sheet, m.Start.Row, m.Start.Col - _count),
                    new CellAddress(m.End.Sheet,   m.End.Row,   m.End.Col   - _count));
            }
        }

        return new CommandOutcome(true);
    }

    public void Revert(ICommandContext ctx)
    {
        if (_deletedSnapshot is null || _shiftedSnapshot is null) return;
        var sheet = ctx.GetSheet(_sheetId);
        uint endCol = _startCol + _count - 1;

        foreach (var (addr, _) in _shiftedSnapshot)
            sheet.ClearCell(new CellAddress(addr.Sheet, addr.Row, addr.Col - _count));

        foreach (var (addr, cell) in _shiftedSnapshot) sheet.SetCell(addr, cell.Clone());
        foreach (var (addr, cell) in _deletedSnapshot) sheet.SetCell(addr, cell.Clone());

        if (_mergeSnapshot is not null)
        {
            sheet.MergedRegions.Clear();
            sheet.MergedRegions.AddRange(_mergeSnapshot);
        }
    }
}
```

- [ ] **Step 4: Run tests — confirm they pass**

```
dotnet test tests/FreeX.Core.Model.Tests/ --filter "InsertDeleteColumnsTests"
```

Expected: `4 passed`.

- [ ] **Step 5: Commit**

```
git add src/FreeX.Core.Commands/InsertDeleteColumnsCommand.cs tests/FreeX.Core.Model.Tests/InsertDeleteColumnsTests.cs
git commit -m "feat: InsertColumnsCommand and DeleteColumnsCommand"
```

---

## Task 6: AutofillCommand

**Files:**
- Create: `src/FreeX.Core.Commands/AutofillCommand.cs`
- Create: `tests/FreeX.Core.Model.Tests/AutofillCommandTests.cs`

- [ ] **Step 1: Write the failing tests**

Create `tests/FreeX.Core.Model.Tests/AutofillCommandTests.cs`:

```csharp
using FreeX.Core.Commands;
using FreeX.Core.Model;
using FluentAssertions;

namespace FreeX.Core.Model.Tests;

public class AutofillCommandTests
{
    private static (Workbook wb, Sheet sheet, ICommandContext ctx) Setup()
    {
        var wb = new Workbook("test");
        var sheet = wb.AddSheet("Sheet1");
        return (wb, sheet, new SimpleCtx(wb));
    }

    [Fact]
    public void FillValue_Down_RepeatsSourceValue()
    {
        var (_, sheet, ctx) = Setup();
        var source = new CellAddress(sheet.Id, 1, 1);
        sheet.SetCell(source, new NumberValue(42));

        var sourceRange = new GridRange(source, source);
        var fillRange = new GridRange(
            new CellAddress(sheet.Id, 2, 1),
            new CellAddress(sheet.Id, 4, 1));

        new AutofillCommand(sheet.Id, sourceRange, fillRange).Apply(ctx);

        sheet.GetValue(2, 1).Should().Be(new NumberValue(42));
        sheet.GetValue(3, 1).Should().Be(new NumberValue(42));
        sheet.GetValue(4, 1).Should().Be(new NumberValue(42));
    }

    [Fact]
    public void FillFormula_Down_IncrementsRowReferences()
    {
        var (_, sheet, ctx) = Setup();
        var source = new CellAddress(sheet.Id, 1, 1);
        sheet.SetCell(source, Cell.FromFormula("A1+B1"));

        var sourceRange = new GridRange(source, source);
        var fillRange = new GridRange(
            new CellAddress(sheet.Id, 2, 1),
            new CellAddress(sheet.Id, 3, 1));

        new AutofillCommand(sheet.Id, sourceRange, fillRange).Apply(ctx);

        sheet.GetCell(2, 1)!.FormulaText.Should().Be("A2+B2");
        sheet.GetCell(3, 1)!.FormulaText.Should().Be("A3+B3");
    }

    [Fact]
    public void FillFormula_PreservesAbsoluteRefs()
    {
        var (_, sheet, ctx) = Setup();
        var source = new CellAddress(sheet.Id, 1, 1);
        sheet.SetCell(source, Cell.FromFormula("$A$1+B1"));

        var sourceRange = new GridRange(source, source);
        var fillRange = new GridRange(
            new CellAddress(sheet.Id, 2, 1),
            new CellAddress(sheet.Id, 2, 1));

        new AutofillCommand(sheet.Id, sourceRange, fillRange).Apply(ctx);

        sheet.GetCell(2, 1)!.FormulaText.Should().Be("$A$1+B2");
    }

    [Fact]
    public void FillRevert_RestoresOriginalCells()
    {
        var (_, sheet, ctx) = Setup();
        var source = new CellAddress(sheet.Id, 1, 1);
        var target = new CellAddress(sheet.Id, 2, 1);
        sheet.SetCell(source, new NumberValue(10));
        sheet.SetCell(target, new NumberValue(99));

        var cmd = new AutofillCommand(
            sheet.Id,
            new GridRange(source, source),
            new GridRange(target, target));
        cmd.Apply(ctx);
        cmd.Revert(ctx);

        sheet.GetValue(2, 1).Should().Be(new NumberValue(99));
    }

    private sealed class SimpleCtx(Workbook wb) : ICommandContext
    {
        public Workbook Workbook { get; } = wb;
        public Sheet GetSheet(SheetId id) => Workbook.GetSheet(id)!;
    }
}
```

- [ ] **Step 2: Run tests — confirm they fail**

```
dotnet test tests/FreeX.Core.Model.Tests/ --filter "AutofillCommandTests"
```

Expected: compile error.

- [ ] **Step 3: Implement AutofillCommand**

Create `src/FreeX.Core.Commands/AutofillCommand.cs`:

```csharp
using System.Text.RegularExpressions;
using FreeX.Core.Model;

namespace FreeX.Core.Commands;

/// <summary>
/// Fills a range by repeating the last cell of <paramref name="sourceRange"/>.
/// Formulas have relative cell references incremented by the fill offset.
/// </summary>
public sealed partial class AutofillCommand : IWorkbookCommand
{
    private readonly SheetId _sheetId;
    private readonly GridRange _sourceRange;
    private readonly GridRange _fillRange;
    private List<(CellAddress Addr, Cell? OldCell)>? _snapshot;

    public string Label => "Autofill";

    public AutofillCommand(SheetId sheetId, GridRange sourceRange, GridRange fillRange)
    {
        _sheetId     = sheetId;
        _sourceRange = sourceRange;
        _fillRange   = fillRange;
    }

    public CommandOutcome Apply(ICommandContext ctx)
    {
        var sheet = ctx.GetSheet(_sheetId);

        // Source cell is the last cell in source range (bottom-right)
        var sourceAddr = _sourceRange.End;
        var sourceCell = sheet.GetCell(sourceAddr);

        _snapshot = [];

        foreach (var addr in _fillRange.AllCells())
        {
            _snapshot.Add((addr, sheet.GetCell(addr)?.Clone()));

            if (sourceCell is null)
            {
                sheet.ClearCell(addr);
                continue;
            }

            int rowOffset = (int)addr.Row - (int)sourceAddr.Row;
            int colOffset = (int)addr.Col - (int)sourceAddr.Col;

            Cell newCell;
            if (sourceCell.HasFormula && sourceCell.FormulaText is not null)
            {
                var shifted = ShiftFormula(sourceCell.FormulaText, rowOffset, colOffset);
                newCell = Cell.FromFormula(shifted);
            }
            else
            {
                newCell = Cell.FromValue(sourceCell.Value);
            }

            newCell.StyleId = sourceCell.StyleId;
            sheet.SetCell(addr, newCell);
        }

        return new CommandOutcome(true);
    }

    public void Revert(ICommandContext ctx)
    {
        if (_snapshot is null) return;
        var sheet = ctx.GetSheet(_sheetId);
        foreach (var (addr, oldCell) in _snapshot)
        {
            if (oldCell is null) sheet.ClearCell(addr);
            else sheet.SetCell(addr, oldCell.Clone());
        }
    }

    /// <summary>
    /// Shift relative cell references in a formula by rowOffset / colOffset.
    /// Pattern: (\$?)([A-Z]{1,3})(\$?)(\d{1,7})
    /// Group 1 = optional $ before column (absolute col marker)
    /// Group 2 = column letters
    /// Group 3 = optional $ before row (absolute row marker)
    /// Group 4 = row digits
    /// </summary>
    private static string ShiftFormula(string formula, int rowOffset, int colOffset)
    {
        return CellRefPattern().Replace(formula, m =>
        {
            bool absCol = m.Groups[1].Value == "$";
            bool absRow = m.Groups[3].Value == "$";
            var colLetters = m.Groups[2].Value;
            uint rowNum = uint.Parse(m.Groups[4].Value);
            uint colNum = CellAddress.ColumnNameToNumber(colLetters);

            if (!absCol && colOffset != 0)
                colNum = (uint)Math.Max(1, (int)colNum + colOffset);
            if (!absRow && rowOffset != 0)
                rowNum = (uint)Math.Max(1, (int)rowNum + rowOffset);

            return m.Groups[1].Value
                 + CellAddress.NumberToColumnName(colNum)
                 + m.Groups[3].Value
                 + rowNum;
        });
    }

    [GeneratedRegex(@"(\$?)([A-Z]{1,3})(\$?)(\d{1,7})")]
    private static partial Regex CellRefPattern();
}
```

Note: `AutofillCommand` uses `[GeneratedRegex]` so the class must be `partial`. The file has `public sealed partial class AutofillCommand`.

- [ ] **Step 4: Run tests — confirm they pass**

```
dotnet test tests/FreeX.Core.Model.Tests/ --filter "AutofillCommandTests"
```

Expected: `4 passed`.

- [ ] **Step 5: Commit**

```
git add src/FreeX.Core.Commands/AutofillCommand.cs tests/FreeX.Core.Model.Tests/AutofillCommandTests.cs
git commit -m "feat: AutofillCommand with formula reference shifting"
```

---

## Task 7: XLSX MergedRegions round-trip

**Files:**
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Modify: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`

- [ ] **Step 1: Write the failing test**

In `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`, add this test inside the `FileAdapterSmokeTests` class after the existing tests:

```csharp
[Fact]
public void XlsxAdapter_RoundTrip_MergedRegions_Survive()
{
    var workbook = new Workbook("MergeTest");
    var sheet = workbook.AddSheet("S1");

    sheet.SetCell(new CellAddress(sheet.Id, 1, 1), new TextValue("merged"));
    sheet.MergedRegions.Add(new GridRange(
        new CellAddress(sheet.Id, 1, 1),
        new CellAddress(sheet.Id, 2, 3)));

    var ms = new MemoryStream();
    new XlsxFileAdapter().Save(workbook, ms);
    ms.Position = 0;
    var loaded = new XlsxFileAdapter().Load(ms);

    var loadedSheet = loaded.GetSheetAt(0);
    loadedSheet.MergedRegions.Should().HaveCount(1);
    loadedSheet.MergedRegions[0].Start.Row.Should().Be(1);
    loadedSheet.MergedRegions[0].Start.Col.Should().Be(1);
    loadedSheet.MergedRegions[0].End.Row.Should().Be(2);
    loadedSheet.MergedRegions[0].End.Col.Should().Be(3);
}
```

- [ ] **Step 2: Run test — confirm it fails**

```
dotnet test tests/FreeX.Core.IO.Tests/ --filter "XlsxAdapter_RoundTrip_MergedRegions_Survive"
```

Expected: `FAIL` — MergedRegions count is 0.

- [ ] **Step 3: Add merge save/load to XlsxFileAdapter**

In `src/FreeX.Core.IO/XlsxFileAdapter.cs`, in the `Load` method, after the `LoadDataValidations` call and before the closing `}` of the sheet loop, add:

```csharp
// Load merged regions
try { LoadMergedRegions(xlSheet, sheet); }
catch { /* ignore merge load failures */ }
```

In the `Save` method, after `SaveDataValidations` call, add:

```csharp
// Save merged regions
foreach (var region in sheet.MergedRegions)
{
    var startRow = (int)region.Start.Row;
    var startCol = (int)region.Start.Col;
    var endRow   = (int)region.End.Row;
    var endCol   = (int)region.End.Col;
    xlSheet.Range(startRow, startCol, endRow, endCol).Merge();
}
```

At the end of the class, add the `LoadMergedRegions` private method:

```csharp
private static void LoadMergedRegions(IXLWorksheet xlSheet, Sheet sheet)
{
    foreach (var mergedRange in xlSheet.MergedRanges)
    {
        var start = new CellAddress(sheet.Id,
            (uint)mergedRange.FirstCell().Address.RowNumber,
            (uint)mergedRange.FirstCell().Address.ColumnNumber);
        var end = new CellAddress(sheet.Id,
            (uint)mergedRange.LastCell().Address.RowNumber,
            (uint)mergedRange.LastCell().Address.ColumnNumber);
        sheet.MergedRegions.Add(new GridRange(start, end));
    }
}
```

Also add `using ClosedXML.Excel;` if not already present (it should be).

- [ ] **Step 4: Run test — confirm it passes**

```
dotnet test tests/FreeX.Core.IO.Tests/ --filter "XlsxAdapter_RoundTrip_MergedRegions_Survive"
```

Expected: `1 passed`.

- [ ] **Step 5: Run all IO tests to check for regressions**

```
dotnet test tests/FreeX.Core.IO.Tests/
```

Expected: all tests pass.

- [ ] **Step 6: Commit**

```
git add src/FreeX.Core.IO/XlsxFileAdapter.cs tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs
git commit -m "feat: XLSX merged regions round-trip save and load"
```

---

## Task 8: GridView — merged cell rendering, autofill handle, Shift+click

**Files:**
- Modify: `src/FreeX.App.UI/GridView.cs`

This task is UI-only; there are no unit tests (GridView requires WPF rendering context). Manual verification: build and run.

- [ ] **Step 1: Add AutofillRequested event and ContextMenuRequested event**

In `src/FreeX.App.UI/GridView.cs`, after the existing `RowResized`/`ColumnResized` events at line 87, add:

```csharp
/// <summary>Fired when the user drags the autofill handle and releases.</summary>
public event Action<GridRange, GridRange>? AutofillRequested;

/// <summary>Fired on right mouse button down with the clicked cell address.</summary>
public event Action<CellAddress, System.Windows.Point>? ContextMenuRequested;
```

- [ ] **Step 2: Add autofill drag state fields**

After the resize drag state fields (around line 84), add:

```csharp
// Autofill drag state
private bool _autofillDragging;
private CellAddress? _autofillSource;
private CellAddress? _autofillTarget;
```

- [ ] **Step 3: Render autofill handle in RenderSelection**

In `GridView.cs`, find the `RenderSelection` method. After the existing selection rectangle is drawn (after the `dc.DrawRectangle` and `dc.DrawRectangle` border calls), add the autofill handle:

```csharp
// Autofill handle: 6×6 green square at bottom-right of selection
if (right.HasValue && bottom.HasValue)
{
    const double handleSize = 6;
    double hx = right.Value - handleSize / 2;
    double hy = bottom.Value - handleSize / 2;
    dc.DrawRectangle(Brushes.White, SelectionPen,
        new Rect(hx, hy, handleSize, handleSize));
    dc.DrawRectangle(
        new SolidColorBrush(Color.FromRgb(33, 115, 70)), null,
        new Rect(hx + 1, hy + 1, handleSize - 2, handleSize - 2));
}
```

Place this immediately after the existing `dc.DrawRectangle(null, SelectionPen, selRect);` line.

- [ ] **Step 4: Render merged cells in RenderCells**

The `RenderCells` method iterates `Viewport.Cells`. Merged cell info needs to flow through `ViewportModel`. For Phase 5a, pass `MergedRegions` from `Sheet` as a dependency property on GridView:

Add a new dependency property after `ChartsProperty`:

```csharp
public static readonly DependencyProperty MergedRegionsProperty =
    DependencyProperty.Register(nameof(MergedRegions), typeof(IReadOnlyList<GridRange>), typeof(GridView),
        new FrameworkPropertyMetadata(null, FrameworkPropertyMetadataOptions.AffectsRender));

public IReadOnlyList<GridRange>? MergedRegions
{
    get => (IReadOnlyList<GridRange>?)GetValue(MergedRegionsProperty);
    set => SetValue(MergedRegionsProperty, value);
}
```

In `RenderCells`, before drawing each cell's background/text, add a skip check:

```csharp
private void RenderCells(DrawingContext dc)
{
    if (Viewport == null) return;

    foreach (var cell in Viewport.Cells)
    {
        // Skip cells that are interior to a merge (not the top-left)
        var addr = new CellAddress(default, cell.Row, cell.Col);  // SheetId not needed for Contains check
        var mergeRegion = MergedRegions?.FirstOrDefault(r =>
            cell.Row >= r.Start.Row && cell.Row <= r.End.Row &&
            cell.Col >= r.Start.Col && cell.Col <= r.End.Col);

        bool isInMerge = mergeRegion.HasValue;
        bool isMergeTopLeft = mergeRegion.HasValue &&
            cell.Row == mergeRegion.Value.Start.Row &&
            cell.Col == mergeRegion.Value.Start.Col;

        if (isInMerge && !isMergeTopLeft)
            continue;  // skip — drawn by top-left cell

        // Find cell bounds
        var rowM = Viewport.RowMetrics.FirstOrDefault(r => r.Row == cell.Row);
        var colM = Viewport.ColMetrics.FirstOrDefault(c => c.Col == cell.Col);
        if (rowM == null || colM == null) continue;

        double x = colM.LeftOffset + HeaderSize;
        double y = rowM.TopOffset  + HeaderSize;
        double w = colM.Width;
        double h = rowM.Height;

        // Expand rect for merged cells
        if (isMergeTopLeft && mergeRegion.HasValue)
        {
            var mr = mergeRegion.Value;
            for (uint c2 = mr.Start.Col + 1; c2 <= mr.End.Col; c2++)
            {
                var cm2 = Viewport.ColMetrics.FirstOrDefault(cm => cm.Col == c2);
                if (cm2 != null) w += cm2.Width;
            }
            for (uint r2 = mr.Start.Row + 1; r2 <= mr.End.Row; r2++)
            {
                var rm2 = Viewport.RowMetrics.FirstOrDefault(rm => rm.Row == r2);
                if (rm2 != null) h += rm2.Height;
            }
        }

        // ... rest of existing cell draw code using (x, y, w, h) ...
    }
}
```

**Important:** The existing `RenderCells` code uses its own local x/y/w/h variables derived from `RowMetrics`/`ColMetrics`. You need to refactor it to use the approach above, replacing the existing rect calculation. The existing cell-drawing logic (fill, border, text) remains the same — only the rect dimensions change for merged cells.

- [ ] **Step 5: Wire autofill mouse handling**

In `OnMouseLeftButtonDown`, add autofill hit-test before the resize check:

```csharp
// Hit-test autofill handle (6×6 px at bottom-right of selection)
if (SelectedRange.HasValue && IsOnAutofillHandle(pos))
{
    _autofillDragging = true;
    _autofillSource   = SelectedRange.Value.End;
    _autofillTarget   = SelectedRange.Value.End;
    CaptureMouse();
    Cursor = Cursors.Cross;
    e.Handled = true;
    return;
}
```

Add the helper method:

```csharp
private bool IsOnAutofillHandle(Point pos)
{
    if (Viewport == null || !SelectedRange.HasValue) return false;
    var range = SelectedRange.Value;
    var endRow = Viewport.RowMetrics.FirstOrDefault(r => r.Row == range.End.Row);
    var endCol = Viewport.ColMetrics.FirstOrDefault(c => c.Col == range.End.Col);
    if (endRow == null || endCol == null) return false;

    const double handleSize = 6;
    double hx = endCol.LeftOffset + endCol.Width + HeaderSize - handleSize / 2;
    double hy = endRow.TopOffset  + endRow.Height + HeaderSize - handleSize / 2;
    return pos.X >= hx - 3 && pos.X <= hx + handleSize + 3
        && pos.Y >= hy - 3 && pos.Y <= hy + handleSize + 3;
}
```

In `OnMouseMove`, before the resize section, add:

```csharp
if (_autofillDragging && Viewport != null)
{
    // Determine target cell under cursor
    foreach (var rm in Viewport.RowMetrics)
    {
        double top = rm.TopOffset + HeaderSize;
        if (pos.Y >= top && pos.Y < top + rm.Height)
        {
            foreach (var cm in Viewport.ColMetrics)
            {
                double left = cm.LeftOffset + HeaderSize;
                if (pos.X >= left && pos.X < left + cm.Width)
                {
                    _autofillTarget = new CellAddress(default, rm.Row, cm.Col);
                    break;
                }
            }
            break;
        }
    }
    InvalidateVisual();
    return;
}
```

In `OnMouseLeftButtonUp`, before the resize section, add:

```csharp
if (_autofillDragging)
{
    _autofillDragging = false;
    ReleaseMouseCapture();
    Cursor = null;

    if (_autofillSource.HasValue && _autofillTarget.HasValue && SelectedRange.HasValue)
    {
        var src = SelectedRange.Value;
        var target = _autofillTarget.Value;
        // Build fill range: from one cell past source to target
        var fillStart = new CellAddress(src.Start.Sheet,
            target.Row < src.Start.Row ? target.Row : src.End.Row + 1,
            target.Col < src.Start.Col ? target.Col : src.End.Col + 1);
        // Simplified: just use target if it's below the source
        if (target.Row > src.End.Row || target.Col > src.End.Col)
        {
            var fillRange = new GridRange(
                new CellAddress(src.Start.Sheet,
                    target.Row > src.End.Row ? src.End.Row + 1 : src.Start.Row,
                    target.Col > src.End.Col ? src.End.Col + 1 : src.Start.Col),
                target);
            AutofillRequested?.Invoke(src, fillRange);
        }
    }

    _autofillSource = null;
    _autofillTarget = null;
    e.Handled = true;
    return;
}
```

- [ ] **Step 6: Add Shift+click multi-select in OnMouseLeftButtonDown**

In the hit-test logic in `MainWindow.SheetGrid_MouseDown` (not in GridView itself — MainWindow handles cell selection), after finding `hitRow` and `hitCol`, check for Shift:

In `MainWindow.xaml.cs`, in `SheetGrid_MouseDown`, replace:

```csharp
if (hitRow.HasValue && hitCol.HasValue)
{
    SetActiveCell(new CellAddress(_currentSheetId, hitRow.Value, hitCol.Value));
    if (e.ClickCount == 2)
        EnterEditMode();
}
```

With:

```csharp
if (hitRow.HasValue && hitCol.HasValue)
{
    var newAddr = new CellAddress(_currentSheetId, hitRow.Value, hitCol.Value);
    if ((Keyboard.Modifiers & ModifierKeys.Shift) != 0 && SheetGrid.SelectedRange.HasValue)
    {
        // Extend selection from existing anchor to new address
        var anchor = SheetGrid.SelectedRange.Value.Start;
        SheetGrid.SelectedRange = new GridRange(
            new CellAddress(_currentSheetId,
                Math.Min(anchor.Row, newAddr.Row), Math.Min(anchor.Col, newAddr.Col)),
            new CellAddress(_currentSheetId,
                Math.Max(anchor.Row, newAddr.Row), Math.Max(anchor.Col, newAddr.Col)));
        CellAddressBox.Text = $"{anchor.ToA1()}:{newAddr.ToA1()}";
    }
    else
    {
        SetActiveCell(newAddr);
        if (e.ClickCount == 2)
            EnterEditMode();
    }
}
```

- [ ] **Step 7: Wire MergedRegions DP in UpdateViewport**

In `MainWindow.cs`, in `UpdateViewport()`, after `SheetGrid.Charts = sheet?.Charts;`, add:

```csharp
SheetGrid.MergedRegions = sheet?.MergedRegions;
```

- [ ] **Step 8: Wire AutofillRequested event in MainWindow constructor**

In `MainWindow.xaml.cs`, in the constructor after `SheetGrid.RowResized += OnRowResized;`, add:

```csharp
SheetGrid.AutofillRequested += OnAutofillRequested;
```

Add the handler method:

```csharp
private void OnAutofillRequested(GridRange sourceRange, GridRange fillRange)
{
    var cmd = new AutofillCommand(_currentSheetId, sourceRange, fillRange);
    _commandBus.Execute(_workbook.Id, cmd);
    _recalcEngine.Recalculate(_workbook, fillRange.AllCells().ToList());
    UpdateViewport();
    RefreshStatusBar();
}
```

- [ ] **Step 9: Render Strikethrough in FormattedText**

In the existing `RenderCells` code that creates `FormattedText` for cell text, after setting bold/italic, add:

```csharp
// Apply strikethrough text decoration if set
if (cell.Style?.Strikethrough == true)
    ft.SetTextDecorations(TextDecorations.Strikethrough);
```

This sits alongside the existing Bold/Italic typeface application (where `FormattedText` is constructed).

- [ ] **Step 10: Build and verify**

```
dotnet build src/FreeX.App.UI/FreeX.App.UI.csproj
dotnet build src/FreeX.App.Host/FreeX.App.Host.csproj
```

Expected: `Build succeeded.` with 0 errors.

- [ ] **Step 11: Commit**

```
git add src/FreeX.App.UI/GridView.cs src/FreeX.App.Host/MainWindow.xaml.cs
git commit -m "feat: GridView merged cell rendering, autofill handle, Shift+click multi-select, strikethrough"
```

---

## Task 9: Formatting toolbar + keyboard shortcuts

**Files:**
- Modify: `src/FreeX.App.Host/MainWindow.xaml`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`

- [ ] **Step 1: Add formatting toolbar row to MainWindow.xaml**

In `MainWindow.xaml`, the `Grid.RowDefinitions` currently has 5 rows. Change to 6 rows by inserting a new row after the Ribbon (row 0):

```xml
<!-- Formatting toolbar -->
<RowDefinition Height="Auto"/>
```

Add `Grid.Row` numbers: Ribbon stays at 0, new toolbar at 1, formula bar at 2, grid at 3, tabs at 4, status bar at 5. Update all `Grid.Row` attributes on existing children to add 1.

Then add the toolbar `Border` after the ribbon `Border`:

```xml
<!-- Formatting toolbar -->
<Border Grid.Row="1" Background="White" BorderBrush="#D0D0D0" BorderThickness="0,0,0,1" Padding="4,3">
    <StackPanel Orientation="Horizontal">
        <ComboBox x:Name="FontNameBox" Width="110" Height="22" Margin="2,0"
                  SelectionChanged="FontNameBox_SelectionChanged"/>
        <ComboBox x:Name="FontSizeBox" Width="46" Height="22" Margin="2,0" IsEditable="True"
                  SelectionChanged="FontSizeBox_SelectionChanged"/>
        <Separator Width="1" Background="#D0D0D0" Margin="4,2"/>
        <ToggleButton x:Name="BoldButton"          Content="B"  Width="24" Height="22" Margin="1,0"
                      FontWeight="Bold"   Click="BoldButton_Click"/>
        <ToggleButton x:Name="ItalicButton"        Content="I"  Width="24" Height="22" Margin="1,0"
                      FontStyle="Italic"  Click="ItalicButton_Click"/>
        <ToggleButton x:Name="UnderlineButton"     Content="U"  Width="24" Height="22" Margin="1,0"
                      Click="UnderlineButton_Click">
            <ToggleButton.TextDecorations><TextDecorationCollection><TextDecoration Location="Underline"/></TextDecorationCollection></ToggleButton.TextDecorations>
        </ToggleButton>
        <ToggleButton x:Name="StrikeButton"        Content="S"  Width="24" Height="22" Margin="1,0"
                      Click="StrikeButton_Click">
            <ToggleButton.TextDecorations><TextDecorationCollection><TextDecoration Location="Strikethrough"/></TextDecorationCollection></ToggleButton.TextDecorations>
        </ToggleButton>
        <Separator Width="1" Background="#D0D0D0" Margin="4,2"/>
        <Button x:Name="FontColorBtn"  Content="A" Width="24" Height="22" Margin="1,0"
                Click="FontColorBtn_Click" ToolTip="Font Color"/>
        <Button x:Name="FillColorBtn"  Content="🖊" Width="24" Height="22" Margin="1,0"
                Click="FillColorBtn_Click" ToolTip="Fill Color"/>
        <Separator Width="1" Background="#D0D0D0" Margin="4,2"/>
        <ToggleButton x:Name="AlignLeftBtn"   Content="≡L" Width="28" Height="22" Margin="1,0"
                      Click="AlignLeftBtn_Click"/>
        <ToggleButton x:Name="AlignCenterBtn" Content="≡C" Width="28" Height="22" Margin="1,0"
                      Click="AlignCenterBtn_Click"/>
        <ToggleButton x:Name="AlignRightBtn"  Content="≡R" Width="28" Height="22" Margin="1,0"
                      Click="AlignRightBtn_Click"/>
        <ToggleButton x:Name="WrapTextBtn"    Content="↵"  Width="24" Height="22" Margin="1,0"
                      Click="WrapTextBtn_Click" ToolTip="Wrap Text"/>
        <Separator Width="1" Background="#D0D0D0" Margin="4,2"/>
        <Button Content="Merge" Width="44" Height="22" Margin="1,0" Click="MergeCenterBtn_Click"/>
        <Separator Width="1" Background="#D0D0D0" Margin="4,2"/>
        <ComboBox x:Name="NumberFormatBox" Width="90" Height="22" Margin="2,0"
                  SelectionChanged="NumberFormatBox_SelectionChanged"/>
    </StackPanel>
</Border>
```

- [ ] **Step 2: Populate toolbar controls and add toolbar sync in MainWindow.xaml.cs**

In `MainWindow.xaml.cs`, in `MainWindow_Loaded`, populate the font and format lists:

```csharp
// Populate font name list
var fonts = new[] { "Calibri", "Arial", "Times New Roman", "Courier New", "Segoe UI", "Verdana", "Georgia" };
FontNameBox.ItemsSource = fonts;
FontNameBox.SelectedItem = "Calibri";

// Populate font sizes
var sizes = new[] { "8", "9", "10", "11", "12", "14", "16", "18", "20", "24", "28", "36", "48", "72" };
FontSizeBox.ItemsSource = sizes;
FontSizeBox.SelectedItem = "11";

// Populate number formats
var formats = new[] { "General", "Number (0.00)", "Currency ($#,##0.00)", "Percentage (0%)", "Date (yyyy-MM-dd)", "Time (HH:mm:ss)", "Text (@)" };
NumberFormatBox.ItemsSource = formats;
NumberFormatBox.SelectedIndex = 0;
```

Add a `_suppressToolbarSync` flag and `RefreshToolbar()` method:

```csharp
private bool _suppressToolbarSync;

private void RefreshToolbar()
{
    if (SheetGrid.SelectedRange is not { } range) return;
    var sheet = _workbook.GetSheet(_currentSheetId);
    if (sheet is null) return;
    var topLeft = range.Start;
    var style = _workbook.GetStyle(sheet.GetCell(topLeft)?.StyleId ?? StyleId.Default);

    _suppressToolbarSync = true;
    BoldButton.IsChecked          = style.Bold;
    ItalicButton.IsChecked        = style.Italic;
    UnderlineButton.IsChecked     = style.Underline;
    StrikeButton.IsChecked        = style.Strikethrough;
    AlignLeftBtn.IsChecked        = style.HorizontalAlignment == HorizontalAlignment.Left;
    AlignCenterBtn.IsChecked      = style.HorizontalAlignment == HorizontalAlignment.Center;
    AlignRightBtn.IsChecked       = style.HorizontalAlignment == HorizontalAlignment.Right;
    WrapTextBtn.IsChecked         = style.WrapText;
    if (FontNameBox.Items.Contains(style.FontName))
        FontNameBox.SelectedItem  = style.FontName;
    var sizeStr = style.FontSize.ToString("0.#");
    if (FontSizeBox.Items.Contains(sizeStr))
        FontSizeBox.SelectedItem  = sizeStr;
    _suppressToolbarSync = false;
}
```

Add this to `SetActiveCell` — call `RefreshToolbar()` at the end.

Add the `ApplyStyleDiff` helper:

```csharp
private void ApplyStyleDiff(StyleDiff diff)
{
    if (SheetGrid.SelectedRange is not { } range) return;
    _commandBus.Execute(_workbook.Id, new ApplyStyleCommand(_currentSheetId, range, diff));
    _recalcEngine.Recalculate(_workbook, range.AllCells().ToList());
    UpdateViewport();
    RefreshStatusBar();
}
```

Add all toolbar click handlers:

```csharp
private void BoldButton_Click(object sender, RoutedEventArgs e)
{
    if (_suppressToolbarSync) return;
    ApplyStyleDiff(new StyleDiff(Bold: BoldButton.IsChecked == true));
}

private void ItalicButton_Click(object sender, RoutedEventArgs e)
{
    if (_suppressToolbarSync) return;
    ApplyStyleDiff(new StyleDiff(Italic: ItalicButton.IsChecked == true));
}

private void UnderlineButton_Click(object sender, RoutedEventArgs e)
{
    if (_suppressToolbarSync) return;
    ApplyStyleDiff(new StyleDiff(Underline: UnderlineButton.IsChecked == true));
}

private void StrikeButton_Click(object sender, RoutedEventArgs e)
{
    if (_suppressToolbarSync) return;
    ApplyStyleDiff(new StyleDiff(Strikethrough: StrikeButton.IsChecked == true));
}

private void AlignLeftBtn_Click(object sender, RoutedEventArgs e)
{
    if (_suppressToolbarSync) return;
    ApplyStyleDiff(new StyleDiff(HAlign: HorizontalAlignment.Left));
}

private void AlignCenterBtn_Click(object sender, RoutedEventArgs e)
{
    if (_suppressToolbarSync) return;
    ApplyStyleDiff(new StyleDiff(HAlign: HorizontalAlignment.Center));
}

private void AlignRightBtn_Click(object sender, RoutedEventArgs e)
{
    if (_suppressToolbarSync) return;
    ApplyStyleDiff(new StyleDiff(HAlign: HorizontalAlignment.Right));
}

private void WrapTextBtn_Click(object sender, RoutedEventArgs e)
{
    if (_suppressToolbarSync) return;
    ApplyStyleDiff(new StyleDiff(WrapText: WrapTextBtn.IsChecked == true));
}

private void MergeCenterBtn_Click(object sender, RoutedEventArgs e)
{
    if (SheetGrid.SelectedRange is not { } range) return;
    var outcome = _commandBus.Execute(_workbook.Id, new MergeCellsCommand(_currentSheetId, range));
    if (!outcome.Success)
    {
        MessageBox.Show(outcome.ErrorMessage ?? "Cannot merge.", "Merge Cells", MessageBoxButton.OK, MessageBoxImage.Warning);
        return;
    }
    ApplyStyleDiff(new StyleDiff(HAlign: HorizontalAlignment.Center));
    UpdateViewport();
}

private void FontNameBox_SelectionChanged(object sender, System.Windows.Controls.SelectionChangedEventArgs e)
{
    if (_suppressToolbarSync) return;
    if (FontNameBox.SelectedItem is string name)
        ApplyStyleDiff(new StyleDiff(FontName: name));
}

private void FontSizeBox_SelectionChanged(object sender, System.Windows.Controls.SelectionChangedEventArgs e)
{
    if (_suppressToolbarSync) return;
    var text = FontSizeBox.Text;
    if (double.TryParse(text, out var size) && size > 0)
        ApplyStyleDiff(new StyleDiff(FontSize: size));
}

private void FontColorBtn_Click(object sender, RoutedEventArgs e)
{
    var picker = new System.Windows.Forms.ColorDialog();
    if (picker.ShowDialog() == System.Windows.Forms.DialogResult.OK)
    {
        var c = picker.Color;
        ApplyStyleDiff(new StyleDiff(FontColor: new CellColor(c.R, c.G, c.B)));
    }
}

private void FillColorBtn_Click(object sender, RoutedEventArgs e)
{
    var picker = new System.Windows.Forms.ColorDialog();
    if (picker.ShowDialog() == System.Windows.Forms.DialogResult.OK)
    {
        var c = picker.Color;
        ApplyStyleDiff(new StyleDiff(FillColor: new CellColor(c.R, c.G, c.B)));
    }
}

private void NumberFormatBox_SelectionChanged(object sender, System.Windows.Controls.SelectionChangedEventArgs e)
{
    if (_suppressToolbarSync) return;
    if (NumberFormatBox.SelectedIndex < 0) return;
    var codes = new[] { "General", "0.00", "$#,##0.00", "0%", "yyyy-MM-dd", "HH:mm:ss", "@" };
    if (NumberFormatBox.SelectedIndex < codes.Length)
        ApplyStyleDiff(new StyleDiff(NumberFormat: codes[NumberFormatBox.SelectedIndex]));
}
```

Note: `System.Windows.Forms.ColorDialog` requires adding the `<UseWindowsForms>true</UseWindowsForms>` property to `FreeX.App.Host.csproj`. Alternatively, use a simple `MessageBox`-prompted RGB input for Phase 5a:

```csharp
private void FontColorBtn_Click(object sender, RoutedEventArgs e)
{
    var input = PromptForInput("Font color (R,G,B e.g. 255,0,0):", "0,0,0");
    if (input is null) return;
    var parts = input.Split(',');
    if (parts.Length == 3 && byte.TryParse(parts[0].Trim(), out var r)
        && byte.TryParse(parts[1].Trim(), out var g) && byte.TryParse(parts[2].Trim(), out var b))
        ApplyStyleDiff(new StyleDiff(FontColor: new CellColor(r, g, b)));
}

private void FillColorBtn_Click(object sender, RoutedEventArgs e)
{
    var input = PromptForInput("Fill color (R,G,B e.g. 255,255,0):", "255,255,255");
    if (input is null) return;
    var parts = input.Split(',');
    if (parts.Length == 3 && byte.TryParse(parts[0].Trim(), out var r)
        && byte.TryParse(parts[1].Trim(), out var g) && byte.TryParse(parts[2].Trim(), out var b))
        ApplyStyleDiff(new StyleDiff(FillColor: new CellColor(r, g, b)));
}
```

- [ ] **Step 3: Add keyboard shortcuts Ctrl+B / Ctrl+I / Ctrl+U in MainWindow_KeyDown**

In `MainWindow_KeyDown`, before the existing Ctrl+F handler, add:

```csharp
if (e.Key == Key.B && (Keyboard.Modifiers & ModifierKeys.Control) != 0)
{
    BoldButton.IsChecked = !(BoldButton.IsChecked == true);
    ApplyStyleDiff(new StyleDiff(Bold: BoldButton.IsChecked == true));
    e.Handled = true;
    return;
}
if (e.Key == Key.I && (Keyboard.Modifiers & ModifierKeys.Control) != 0)
{
    ItalicButton.IsChecked = !(ItalicButton.IsChecked == true);
    ApplyStyleDiff(new StyleDiff(Italic: ItalicButton.IsChecked == true));
    e.Handled = true;
    return;
}
if (e.Key == Key.U && (Keyboard.Modifiers & ModifierKeys.Control) != 0)
{
    UnderlineButton.IsChecked = !(UnderlineButton.IsChecked == true);
    ApplyStyleDiff(new StyleDiff(Underline: UnderlineButton.IsChecked == true));
    e.Handled = true;
    return;
}
```

- [ ] **Step 4: Build and verify**

```
dotnet build src/FreeX.App.Host/FreeX.App.Host.csproj
```

Expected: `Build succeeded.` with 0 errors.

- [ ] **Step 5: Commit**

```
git add src/FreeX.App.Host/MainWindow.xaml src/FreeX.App.Host/MainWindow.xaml.cs
git commit -m "feat: formatting toolbar with Bold/Italic/Underline/Strike/Align/Merge/NumberFormat"
```

---

## Task 10: Right-click context menu + Insert/Delete UI

**Files:**
- Modify: `src/FreeX.App.UI/GridView.cs`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`

- [ ] **Step 1: Add ContextMenuRequested event handling to GridView**

In `GridView.cs`, override `OnMouseRightButtonDown`:

```csharp
protected override void OnMouseRightButtonDown(MouseButtonEventArgs e)
{
    var pos = e.GetPosition(this);
    if (Viewport == null) { base.OnMouseRightButtonDown(e); return; }

    uint? hitRow = null, hitCol = null;
    foreach (var rm in Viewport.RowMetrics)
    {
        double top = rm.TopOffset + HeaderSize;
        if (pos.Y >= top && pos.Y < top + rm.Height) { hitRow = rm.Row; break; }
    }
    foreach (var cm in Viewport.ColMetrics)
    {
        double left = cm.LeftOffset + HeaderSize;
        if (pos.X >= left && pos.X < left + cm.Width) { hitCol = cm.Col; break; }
    }

    if (hitRow.HasValue && hitCol.HasValue)
    {
        var addr = new CellAddress(default, hitRow.Value, hitCol.Value);
        ContextMenuRequested?.Invoke(addr, PointToScreen(pos));
        e.Handled = true;
    }

    base.OnMouseRightButtonDown(e);
}
```

The `CellAddress` here uses `default` for SheetId since GridView doesn't know the current SheetId. MainWindow will fill in the correct SheetId.

- [ ] **Step 2: Wire ContextMenuRequested in MainWindow**

In `MainWindow.xaml.cs`, in the constructor after `SheetGrid.AutofillRequested += OnAutofillRequested;`, add:

```csharp
SheetGrid.ContextMenuRequested += OnGridContextMenuRequested;
```

Add the handler:

```csharp
private void OnGridContextMenuRequested(CellAddress clickedCell, System.Windows.Point screenPos)
{
    var actualAddr = new CellAddress(_currentSheetId, clickedCell.Row, clickedCell.Col);
    if (SheetGrid.SelectedRange is null)
        SetActiveCell(actualAddr);

    var menu = new ContextMenu();

    void AddItem(string header, Action action)
    {
        var item = new MenuItem { Header = header };
        item.Click += (_, _) => action();
        menu.Items.Add(item);
    }

    AddItem("Cut",   () => { ExecuteCopy(); ExecuteClearSelection(); });
    AddItem("Copy",  ExecuteCopy);
    AddItem("Paste", ExecutePaste);
    menu.Items.Add(new Separator());
    AddItem("Insert Row Above",    () => InsertRows(actualAddr.Row));
    AddItem("Insert Row Below",    () => InsertRows(actualAddr.Row + 1));
    AddItem("Insert Column Left",  () => InsertColumns(actualAddr.Col));
    AddItem("Insert Column Right", () => InsertColumns(actualAddr.Col + 1));
    menu.Items.Add(new Separator());
    AddItem("Delete Row(s)",    DeleteSelectedRows);
    AddItem("Delete Column(s)", DeleteSelectedColumns);
    menu.Items.Add(new Separator());
    AddItem("Format Cells...",  OpenFormatCellsDialog);
    menu.Items.Add(new Separator());
    AddItem("Clear Contents",   ExecuteClearSelection);

    menu.IsOpen = true;
}

private void InsertRows(uint beforeRow)
{
    _commandBus.Execute(_workbook.Id, new InsertRowsCommand(_currentSheetId, beforeRow));
    UpdateViewport();
}

private void InsertColumns(uint beforeCol)
{
    _commandBus.Execute(_workbook.Id, new InsertColumnsCommand(_currentSheetId, beforeCol));
    UpdateViewport();
}

private void DeleteSelectedRows()
{
    if (SheetGrid.SelectedRange is not { } range) return;
    uint count = range.End.Row - range.Start.Row + 1;
    _commandBus.Execute(_workbook.Id, new DeleteRowsCommand(_currentSheetId, range.Start.Row, count));
    UpdateViewport();
}

private void DeleteSelectedColumns()
{
    if (SheetGrid.SelectedRange is not { } range) return;
    uint count = range.End.Col - range.Start.Col + 1;
    _commandBus.Execute(_workbook.Id, new DeleteColumnsCommand(_currentSheetId, range.Start.Col, count));
    UpdateViewport();
}
```

- [ ] **Step 3: Stub OpenFormatCellsDialog (will be filled in Task 11)**

```csharp
private void OpenFormatCellsDialog()
{
    // Implemented in Task 11
    MessageBox.Show("Format Cells dialog coming in Task 11.");
}
```

- [ ] **Step 4: Build and verify**

```
dotnet build src/FreeX.App.Host/FreeX.App.Host.csproj
```

Expected: `Build succeeded.`

- [ ] **Step 5: Commit**

```
git add src/FreeX.App.UI/GridView.cs src/FreeX.App.Host/MainWindow.xaml.cs
git commit -m "feat: right-click context menu with insert/delete row/column, cut/copy/paste, format cells"
```

---

## Task 11: Format Cells dialog

**Files:**
- Create: `src/FreeX.App.Host/FormatCellsDialog.xaml`
- Create: `src/FreeX.App.Host/FormatCellsDialog.xaml.cs`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs` (replace `OpenFormatCellsDialog` stub)

- [ ] **Step 1: Create FormatCellsDialog.xaml**

```xml
<Window x:Class="FreeX.App.Host.FormatCellsDialog"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Format Cells" Width="420" Height="400"
        WindowStartupLocation="CenterOwner" ResizeMode="NoResize">
    <Grid Margin="12">
        <Grid.RowDefinitions>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <TabControl Grid.Row="0">
            <!-- Number -->
            <TabItem Header="Number">
                <StackPanel Margin="8">
                    <TextBlock Text="Format code:" Margin="0,4,0,2"/>
                    <ComboBox x:Name="NumberFormatCombo" IsEditable="True" Height="24"
                              SelectionChanged="NumberFormatCombo_SelectionChanged"/>
                    <TextBlock Text="Preview:" Margin="0,8,0,2"/>
                    <TextBlock x:Name="NumberPreview" FontWeight="Bold"/>
                </StackPanel>
            </TabItem>

            <!-- Font -->
            <TabItem Header="Font">
                <StackPanel Margin="8">
                    <TextBlock Text="Font:" Margin="0,4,0,2"/>
                    <ComboBox x:Name="DlgFontNameBox" Height="24"/>
                    <TextBlock Text="Size:" Margin="0,8,0,2"/>
                    <ComboBox x:Name="DlgFontSizeBox" IsEditable="True" Height="24"/>
                    <StackPanel Orientation="Horizontal" Margin="0,8,0,0">
                        <CheckBox x:Name="DlgBoldCheck"          Content="Bold"          Margin="0,0,12,0"/>
                        <CheckBox x:Name="DlgItalicCheck"        Content="Italic"        Margin="0,0,12,0"/>
                        <CheckBox x:Name="DlgUnderlineCheck"     Content="Underline"     Margin="0,0,12,0"/>
                        <CheckBox x:Name="DlgStrikeCheck"        Content="Strikethrough"/>
                    </StackPanel>
                    <TextBlock Text="Font Color (R,G,B):" Margin="0,8,0,2"/>
                    <TextBox x:Name="DlgFontColorBox" Height="24" Text="0,0,0"/>
                </StackPanel>
            </TabItem>

            <!-- Fill -->
            <TabItem Header="Fill">
                <StackPanel Margin="8">
                    <TextBlock Text="Background Color (R,G,B, or empty for none):" Margin="0,4,0,2"/>
                    <TextBox x:Name="DlgFillColorBox" Height="24"/>
                </StackPanel>
            </TabItem>

            <!-- Alignment -->
            <TabItem Header="Alignment">
                <StackPanel Margin="8">
                    <TextBlock Text="Horizontal alignment:" Margin="0,4,0,2"/>
                    <ComboBox x:Name="DlgHAlignBox" Height="24"/>
                    <TextBlock Text="Vertical alignment:" Margin="0,8,0,2"/>
                    <ComboBox x:Name="DlgVAlignBox" Height="24"/>
                    <CheckBox x:Name="DlgWrapTextCheck" Content="Wrap text" Margin="0,8,0,0"/>
                </StackPanel>
            </TabItem>
        </TabControl>

        <StackPanel Grid.Row="1" Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,8,0,0">
            <Button Content="OK"     Width="70" Height="26" Margin="4,0" IsDefault="True" Click="OkButton_Click"/>
            <Button Content="Cancel" Width="70" Height="26" Margin="4,0" IsCancel="True"/>
        </StackPanel>
    </Grid>
</Window>
```

- [ ] **Step 2: Create FormatCellsDialog.xaml.cs**

```csharp
using System.Windows;
using System.Windows.Controls;
using FreeX.Core.Model;

namespace FreeX.App.Host;

public partial class FormatCellsDialog : Window
{
    public StyleDiff? Result { get; private set; }

    private static readonly string[] NumberFormatCodes =
        { "General", "0.00", "$#,##0.00", "0%", "yyyy-MM-dd", "HH:mm:ss", "@" };

    private static readonly string[] NumberFormatLabels =
        { "General", "Number (0.00)", "Currency ($#,##0.00)", "Percentage (0%)",
          "Date (yyyy-MM-dd)", "Time (HH:mm:ss)", "Text (@)" };

    public FormatCellsDialog(CellStyle current)
    {
        InitializeComponent();
        Loaded += (_, _) => Populate(current);
    }

    private void Populate(CellStyle s)
    {
        // Number tab
        NumberFormatCombo.ItemsSource  = NumberFormatLabels;
        var idx = Array.IndexOf(NumberFormatCodes, s.NumberFormat);
        NumberFormatCombo.SelectedIndex = idx >= 0 ? idx : 0;
        if (idx < 0) NumberFormatCombo.Text = s.NumberFormat;

        // Font tab
        DlgFontNameBox.ItemsSource  = new[] { "Calibri", "Arial", "Times New Roman", "Courier New", "Segoe UI", "Verdana" };
        DlgFontNameBox.SelectedItem = s.FontName;
        DlgFontSizeBox.ItemsSource  = new[] { "8", "9", "10", "11", "12", "14", "16", "18", "20", "24", "28", "36" };
        DlgFontSizeBox.Text         = s.FontSize.ToString("0.#");
        DlgBoldCheck.IsChecked      = s.Bold;
        DlgItalicCheck.IsChecked    = s.Italic;
        DlgUnderlineCheck.IsChecked = s.Underline;
        DlgStrikeCheck.IsChecked    = s.Strikethrough;
        DlgFontColorBox.Text        = $"{s.FontColor.R},{s.FontColor.G},{s.FontColor.B}";

        // Fill tab
        DlgFillColorBox.Text = s.FillColor.HasValue
            ? $"{s.FillColor.Value.R},{s.FillColor.Value.G},{s.FillColor.Value.B}"
            : "";

        // Alignment tab
        DlgHAlignBox.ItemsSource   = Enum.GetNames(typeof(HorizontalAlignment));
        DlgHAlignBox.SelectedItem  = s.HorizontalAlignment.ToString();
        DlgVAlignBox.ItemsSource   = Enum.GetNames(typeof(VerticalAlignment));
        DlgVAlignBox.SelectedItem  = s.VerticalAlignment.ToString();
        DlgWrapTextCheck.IsChecked = s.WrapText;
    }

    private void NumberFormatCombo_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        // Preview not implemented in Phase 5a
    }

    private void OkButton_Click(object sender, RoutedEventArgs e)
    {
        // Parse font color
        CellColor? fontColor = TryParseColor(DlgFontColorBox.Text);
        CellColor? fillColor = TryParseColor(DlgFillColorBox.Text);

        // Parse number format
        string? numFmt = null;
        if (NumberFormatCombo.SelectedIndex >= 0 && NumberFormatCombo.SelectedIndex < NumberFormatCodes.Length)
            numFmt = NumberFormatCodes[NumberFormatCombo.SelectedIndex];
        else if (!string.IsNullOrWhiteSpace(NumberFormatCombo.Text))
            numFmt = NumberFormatCombo.Text;

        // Parse font size
        double? fontSize = null;
        if (double.TryParse(DlgFontSizeBox.Text, out var fs) && fs > 0) fontSize = fs;

        // Parse alignments
        HorizontalAlignment? hAlign = null;
        if (DlgHAlignBox.SelectedItem is string ha && Enum.TryParse(ha, out HorizontalAlignment h)) hAlign = h;
        VerticalAlignment? vAlign = null;
        if (DlgVAlignBox.SelectedItem is string va && Enum.TryParse(va, out VerticalAlignment v)) vAlign = v;

        Result = new StyleDiff(
            Bold:          DlgBoldCheck.IsChecked,
            Italic:        DlgItalicCheck.IsChecked,
            Underline:     DlgUnderlineCheck.IsChecked,
            Strikethrough: DlgStrikeCheck.IsChecked,
            FontName:      DlgFontNameBox.SelectedItem as string,
            FontSize:      fontSize,
            FontColor:     fontColor,
            FillColor:     fillColor,
            HAlign:        hAlign,
            VAlign:        vAlign,
            WrapText:      DlgWrapTextCheck.IsChecked,
            NumberFormat:  numFmt
        );

        DialogResult = true;
    }

    private static CellColor? TryParseColor(string text)
    {
        if (string.IsNullOrWhiteSpace(text)) return null;
        var parts = text.Split(',');
        if (parts.Length == 3
            && byte.TryParse(parts[0].Trim(), out var r)
            && byte.TryParse(parts[1].Trim(), out var g)
            && byte.TryParse(parts[2].Trim(), out var b))
            return new CellColor(r, g, b);
        return null;
    }
}
```

- [ ] **Step 3: Replace OpenFormatCellsDialog stub in MainWindow.xaml.cs**

Replace the stub with:

```csharp
private void OpenFormatCellsDialog()
{
    if (SheetGrid.SelectedRange is not { } range) return;
    var sheet = _workbook.GetSheet(_currentSheetId);
    if (sheet is null) return;
    var topLeft = range.Start;
    var currentStyle = _workbook.GetStyle(sheet.GetCell(topLeft)?.StyleId ?? StyleId.Default);

    var dlg = new FormatCellsDialog(currentStyle) { Owner = this };
    if (dlg.ShowDialog() == true && dlg.Result is { } diff)
    {
        ApplyStyleDiff(diff);
    }
}
```

Also add `OpenFormatCellsDialog` call to the right-click menu (already done in Task 10 step 2).

- [ ] **Step 4: Build and verify**

```
dotnet build src/FreeX.App.Host/FreeX.App.Host.csproj
```

Expected: `Build succeeded.`

- [ ] **Step 5: Commit**

```
git add src/FreeX.App.Host/FormatCellsDialog.xaml src/FreeX.App.Host/FormatCellsDialog.xaml.cs src/FreeX.App.Host/MainWindow.xaml.cs
git commit -m "feat: Format Cells dialog with Number/Font/Fill/Alignment tabs"
```

---

## Task 12: Status bar

**Files:**
- Create: `src/FreeX.App.Host/StatusBarCalculator.cs`
- Modify: `src/FreeX.App.Host/MainWindow.xaml` (update status bar content)
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`

- [ ] **Step 1: Create StatusBarCalculator**

Create `src/FreeX.App.Host/StatusBarCalculator.cs`:

```csharp
using FreeX.Core.Model;

namespace FreeX.App.Host;

/// <summary>Calculates aggregate statistics for a selection, for the status bar.</summary>
public static class StatusBarCalculator
{
    public record Stats(double Sum, int Count, double? Average, double? Min, double? Max);

    public static Stats Calculate(Sheet sheet, GridRange range)
    {
        double sum = 0;
        int count = 0;
        double? min = null, max = null;

        foreach (var addr in range.AllCells())
        {
            if (sheet.GetValue(addr) is NumberValue nv)
            {
                sum += nv.Value;
                count++;
                min = min is null ? nv.Value : Math.Min(min.Value, nv.Value);
                max = max is null ? nv.Value : Math.Max(max.Value, nv.Value);
            }
        }

        double? average = count > 0 ? sum / count : null;
        return new Stats(sum, count, average, min, max);
    }
}
```

- [ ] **Step 2: Update status bar XAML**

In `MainWindow.xaml`, replace the existing status bar `Border` content with:

```xml
<!-- Status bar -->
<Border Grid.Row="5" Background="#217346" Padding="8,4">
    <Grid>
        <TextBlock x:Name="StatusReadyText" Text="Ready" Foreground="White" FontSize="12" VerticalAlignment="Center"/>
        <StackPanel x:Name="StatusStatsPanel" Orientation="Horizontal"
                    HorizontalAlignment="Center" VerticalAlignment="Center" Visibility="Collapsed">
            <TextBlock x:Name="StatusSumText"   Foreground="White" FontSize="12" Margin="0,0,16,0"/>
            <TextBlock x:Name="StatusCountText" Foreground="White" FontSize="12" Margin="0,0,16,0"/>
            <TextBlock x:Name="StatusAvgText"   Foreground="White" FontSize="12" Margin="0,0,16,0"/>
            <TextBlock x:Name="StatusMinText"   Foreground="White" FontSize="12" Margin="0,0,16,0"/>
            <TextBlock x:Name="StatusMaxText"   Foreground="White" FontSize="12"/>
        </StackPanel>
        <TextBlock Text="100%" Foreground="White" FontSize="12"
                   HorizontalAlignment="Right" VerticalAlignment="Center"/>
    </Grid>
</Border>
```

Note: `Grid.Row` for this border should be 5 (after the row offset introduced in Task 9).

- [ ] **Step 3: Add RefreshStatusBar in MainWindow.xaml.cs**

```csharp
private void RefreshStatusBar()
{
    if (SheetGrid.SelectedRange is not { } range)
    {
        StatusStatsPanel.Visibility = Visibility.Collapsed;
        StatusReadyText.Visibility  = Visibility.Visible;
        return;
    }

    var sheet = _workbook.GetSheet(_currentSheetId);
    if (sheet is null) return;

    var stats = StatusBarCalculator.Calculate(sheet, range);

    if (stats.Count == 0)
    {
        StatusStatsPanel.Visibility = Visibility.Collapsed;
        StatusReadyText.Visibility  = Visibility.Visible;
        return;
    }

    StatusReadyText.Visibility  = Visibility.Collapsed;
    StatusStatsPanel.Visibility = Visibility.Visible;

    StatusSumText.Text   = $"Sum: {stats.Sum:N2}";
    StatusCountText.Text = $"Count: {stats.Count}";
    StatusAvgText.Text   = stats.Average.HasValue ? $"Average: {stats.Average.Value:N2}" : "";
    StatusMinText.Text   = stats.Min.HasValue ? $"Min: {stats.Min.Value:N2}" : "";
    StatusMaxText.Text   = stats.Max.HasValue ? $"Max: {stats.Max.Value:N2}" : "";
}
```

Call `RefreshStatusBar()` from:
- `SetActiveCell` (at the end)
- `CommitEdit` (after `UpdateViewport()`)
- All command handler paths that change selection (ApplyStyleDiff, OnAutofillRequested, etc.)

- [ ] **Step 4: Build and verify**

```
dotnet build src/FreeX.App.Host/FreeX.App.Host.csproj
```

Expected: `Build succeeded.`

- [ ] **Step 5: Run all tests to verify no regressions**

```
dotnet test
```

Expected: all tests pass (all previous test suites).

- [ ] **Step 6: Commit**

```
git add src/FreeX.App.Host/StatusBarCalculator.cs src/FreeX.App.Host/MainWindow.xaml src/FreeX.App.Host/MainWindow.xaml.cs
git commit -m "feat: status bar showing Sum/Count/Average/Min/Max for selection"
```

---

## Final verification

- [ ] **Build the full solution**

```
dotnet build
```

Expected: 0 errors.

- [ ] **Run all tests**

```
dotnet test
```

Expected: all tests pass.

- [ ] **Launch the app and verify manually:**
  - Select a range, apply Bold (Ctrl+B) — cells become bold
  - Select A1:B2, click Merge — cells merge, display A1 value centered
  - Right-click a cell → Insert Row Above — row inserted
  - Drag the autofill handle from A1 down to A4 — A2:A4 fills with A1's value
  - Select cells with numbers — status bar shows Sum/Count/Average/Min/Max
  - Open Format Cells dialog (right-click → Format Cells) — dialog appears with correct tabs
  - Save as XLSX, reopen — merged cells, styles preserved
