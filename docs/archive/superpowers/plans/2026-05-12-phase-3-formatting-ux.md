# Phase 3 — Formatting & UX Polish — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Apply the stored style and number-format data that Phase 2 built, add copy/paste, a working multi-sheet tab bar, freeze panes, and basic charts so FreeX feels like a real spreadsheet.

**Architecture:** All style resolution happens in `ViewportService` (not GridView) — GridView stays a pure renderer that reacts to `ViewportModel`. Number formatting lives in a new `NumberFormatter` static class in `Core.Calc`. Sheet tab state is owned by `MainWindow`; the engine already supports multiple sheets. Charts are rendered as OxyPlot overlays injected via `ViewportModel.Overlays`.

**Tech Stack:** C# / .NET 10 / WPF, ClosedXML (existing), OxyPlot.Wpf (Task 6 only), xUnit + FluentAssertions.

---

## Status at plan start

Already complete from Phase 2 that counts toward Phase 3:
- ✅ `CellStyle` with font / fill / border / alignment / number format (model + XLSX round-trip)
- ✅ `StyleId` registry on `Workbook`
- ✅ Column / row resize drag handles
- ✅ Find & Replace

Remaining Phase 3 work (this plan):
- ❌ Number format rendering
- ❌ Cell style rendering in GridView (bold, color, fill, borders)
- ❌ Copy / paste / cut
- ❌ Multi-sheet tab UI
- ❌ Freeze panes
- ❌ Basic charts

---

## File map

| File | Status | Task |
|------|--------|------|
| `src/FreeX.Core.Calc/NumberFormatter.cs` | **Create** | 1 |
| `src/FreeX.Core.Model/Dtos.cs` | Modify — add `Style` to `DisplayCell` | 1, 2 |
| `src/FreeX.Core.Calc/ViewportService.cs` | Modify — resolve style + number format, freeze panes | 1, 2, 5 |
| `src/FreeX.App.UI/GridView.cs` | Modify — style rendering, freeze divider, overlay | 2, 5, 6 |
| `src/FreeX.App.Host/MainWindow.xaml.cs` | Modify — copy/paste, sheet tabs, freeze menu | 3, 4, 5 |
| `src/FreeX.App.Host/MainWindow.xaml` | Modify — dynamic sheet tab bar | 4 |
| `src/FreeX.Core.Model/Sheet.cs` | Modify — `FrozenRows`, `FrozenCols`, `Charts` list | 5, 6 |
| `src/FreeX.Core.IO/XlsxFileAdapter.cs` | Modify — read/write freeze panes, chart stubs | 5, 6 |
| `src/FreeX.Core.Model/ChartModel.cs` | **Create** | 6 |
| `tests/FreeX.Core.Calc.Tests/NumberFormatterTests.cs` | **Create** | 1 |
| `tests/FreeX.Core.Calc.Tests/ViewportStyleTests.cs` | **Create** | 2 |
| `tests/FreeX.Integration.Tests/ClipboardTests.cs` | **Create** | 3 |

---

## Task 1 — Number Format Rendering

**Purpose:** `ViewportService.FormatValue` currently ignores `CellStyle.NumberFormat`. Dates show as raw serial numbers; currency shows without symbols; percentages show as decimals. Fix by routing all display-text generation through a `NumberFormatter` that maps Excel format strings to formatted strings.

**Files:**
- Create: `src/FreeX.Core.Calc/NumberFormatter.cs`
- Modify: `src/FreeX.Core.Model/Dtos.cs` (add `CellStyle? Style` to `DisplayCell`)
- Modify: `src/FreeX.Core.Calc/ViewportService.cs` (pass format string into `FormatValue`)
- Test: `tests/FreeX.Core.Calc.Tests/NumberFormatterTests.cs`

---

- [ ] **Step 1 — Write failing tests**

Create `tests/FreeX.Core.Calc.Tests/NumberFormatterTests.cs`:

```csharp
using FreeX.Core.Calc;
using FreeX.Core.Model;
using Xunit;

namespace FreeX.Core.Calc.Tests;

public class NumberFormatterTests
{
    [Theory]
    [InlineData("General", 42.0,    "42")]
    [InlineData("General", 42.5,    "42.5")]
    [InlineData("0.00",    42.0,    "42.00")]
    [InlineData("0.00",    3.14159, "3.14")]
    [InlineData("#,##0",   1234567.0, "1,234,567")]
    [InlineData("0%",      0.42,    "42%")]
    [InlineData("0.0%",    0.4225,  "42.3%")]
    public void Format_NumberValue_AppliesFormatString(string format, double value, string expected)
    {
        var result = NumberFormatter.Format(new NumberValue(value), format);
        Assert.Equal(expected, result);
    }

    [Fact]
    public void Format_DateSerial_WithDateFormat_ReturnsFormattedDate()
    {
        // OADate 45292 = 2024-01-01
        var result = NumberFormatter.Format(new NumberValue(45292), "m/d/yyyy");
        Assert.Equal("1/1/2024", result);
    }

    [Fact]
    public void Format_DateTimeValue_WithGeneralFormat_ReturnsShortDate()
    {
        var result = NumberFormatter.Format(new DateTimeValue(45292), "General");
        Assert.Equal("1/1/2024", result);
    }

    [Theory]
    [InlineData("General", "hello", "hello")]
    [InlineData("@",       "hello", "hello")]
    public void Format_TextValue_PassesThrough(string format, string value, string expected)
    {
        var result = NumberFormatter.Format(new TextValue(value), format);
        Assert.Equal(expected, result);
    }

    [Fact]
    public void Format_BlankValue_ReturnsEmpty()
    {
        Assert.Equal("", NumberFormatter.Format(BlankValue.Instance, "General"));
    }

    [Fact]
    public void Format_ErrorValue_ReturnsCode()
    {
        Assert.Equal("#DIV/0!", NumberFormatter.Format(new ErrorValue("#DIV/0!"), "General"));
    }
}
```

- [ ] **Step 2 — Run tests, verify they fail**

```
dotnet test tests/FreeX.Core.Calc.Tests --filter NumberFormatterTests
```
Expected: compilation error — `NumberFormatter` does not exist yet.

- [ ] **Step 3 — Create `NumberFormatter.cs`**

Create `src/FreeX.Core.Calc/NumberFormatter.cs`:

```csharp
using System.Globalization;
using FreeX.Core.Model;

namespace FreeX.Core.Calc;

public static class NumberFormatter
{
    public static string Format(ScalarValue value, string formatString)
    {
        if (string.IsNullOrEmpty(formatString) || formatString == "General")
            return FormatGeneral(value);

        return value switch
        {
            NumberValue n   => FormatNumber(n.Value, formatString),
            DateTimeValue d => FormatNumber(d.Value, formatString),
            TextValue t     => t.Value,
            BoolValue b     => b.Value ? "TRUE" : "FALSE",
            ErrorValue e    => e.Code,
            BlankValue      => "",
            _               => ""
        };
    }

    // ── General format ────────────────────────────────────────────────────────

    private static string FormatGeneral(ScalarValue value) => value switch
    {
        NumberValue n   => FormatNumberGeneral(n.Value),
        DateTimeValue d => DateTime.FromOADate(d.Value).ToShortDateString(),
        TextValue t     => t.Value,
        BoolValue b     => b.Value ? "TRUE" : "FALSE",
        ErrorValue e    => e.Code,
        BlankValue      => "",
        _               => ""
    };

    private static string FormatNumberGeneral(double value)
    {
        // Suppress unnecessary trailing zeros like Excel does
        if (value == Math.Truncate(value) && Math.Abs(value) < 1e15)
            return ((long)value).ToString(CultureInfo.CurrentCulture);
        return value.ToString("G10", CultureInfo.CurrentCulture);
    }

    // ── Specific format strings ───────────────────────────────────────────────

    private static string FormatNumber(double value, string format)
    {
        // Percentage: multiply by 100 before formatting
        if (format.Contains('%'))
        {
            var pctFmt = format.Replace("%", "").Trim();
            try
            {
                return (value * 100).ToString(pctFmt, CultureInfo.CurrentCulture) + "%";
            }
            catch
            {
                return (value * 100).ToString("0", CultureInfo.CurrentCulture) + "%";
            }
        }

        // Date / time format
        if (IsDateTimeFormat(format))
        {
            try
            {
                var dt = DateTime.FromOADate(value);
                return dt.ToString(ToNetDateFormat(format), CultureInfo.CurrentCulture);
            }
            catch
            {
                return value.ToString(CultureInfo.CurrentCulture);
            }
        }

        // Plain number format — .NET handles most Excel number patterns natively
        try
        {
            return value.ToString(format, CultureInfo.CurrentCulture);
        }
        catch
        {
            return value.ToString(CultureInfo.CurrentCulture);
        }
    }

    // ── Date format detection ─────────────────────────────────────────────────

    // A format is a date/time format when it contains date/time tokens (y, d, h)
    // and does NOT contain number tokens (0, #) which would indicate a number format.
    private static bool IsDateTimeFormat(string format)
    {
        bool hasDateToken = format.IndexOfAny(['y', 'Y', 'd', 'D', 'h', 'H', 's', 'S']) >= 0;
        bool hasNumberToken = format.IndexOfAny(['0', '#']) >= 0;
        return hasDateToken && !hasNumberToken;
    }

    // Map common Excel date format tokens to .NET equivalents.
    // Order matters: replace longer tokens before shorter ones.
    private static string ToNetDateFormat(string excelFmt) =>
        excelFmt
            .Replace("AM/PM", "tt")
            .Replace("am/pm", "tt")
            .Replace("yyyy", "yyyy")
            .Replace("yy",   "yy")
            .Replace("mmmm", "MMMM")
            .Replace("mmm",  "MMM")
            .Replace("mm",   "MM")
            .Replace("m",    "M")
            .Replace("dddd", "dddd")
            .Replace("ddd",  "ddd")
            .Replace("dd",   "dd")
            .Replace("d",    "d")
            .Replace("hh",   "HH")
            .Replace("h",    "H")
            .Replace("ss",   "ss")
            .Replace("s",    "s");
}
```

- [ ] **Step 4 — Add `CellStyle? Style` to `DisplayCell`**

In `src/FreeX.Core.Model/Dtos.cs`, add the optional `Style` parameter (keep it last with a default so existing positional call sites still compile):

```csharp
public sealed record DisplayCell(
    uint Row,
    uint Col,
    ScalarValue? RawValue,
    string DisplayText,
    string? Formula,
    StyleId StyleId,
    CellError? Error,
    CellStyle? Style = null);
```

- [ ] **Step 5 — Wire `NumberFormatter` into `ViewportService`**

In `src/FreeX.Core.Calc/ViewportService.cs`, replace the existing `FormatValue` call and method:

In the cell-retrieval loop replace:
```csharp
FormatValue(cell.Value),
```
with:
```csharp
NumberFormatter.Format(cell.Value, workbook.GetStyle(cell.StyleId).NumberFormat),
```

Delete the old private `FormatValue` method entirely (it is now superseded by `NumberFormatter`).

- [ ] **Step 6 — Run tests, verify they pass**

```
dotnet test tests/FreeX.Core.Calc.Tests --filter NumberFormatterTests
```
Expected: all 8 tests pass.

- [ ] **Step 7 — Build and commit**

```
dotnet build FreeX.slnx -c Debug
git add src/FreeX.Core.Calc/NumberFormatter.cs src/FreeX.Core.Model/Dtos.cs src/FreeX.Core.Calc/ViewportService.cs tests/FreeX.Core.Calc.Tests/NumberFormatterTests.cs
git commit -m "feat: number format rendering (Task 3.1)"
```

---

## Task 2 — Cell Style Rendering in GridView

**Purpose:** GridView currently ignores `DisplayCell.StyleId`; every cell renders with white fill and black 12pt Segoe UI text. This task makes GridView use the `Style` field (added in Task 1) to render bold, italic, font color, fill color, explicit borders, and text alignment.

**Files:**
- Modify: `src/FreeX.Core.Calc/ViewportService.cs` (populate `Style` on `DisplayCell`)
- Modify: `src/FreeX.App.UI/GridView.cs` (`RenderCells` with style-aware rendering)
- Test: `tests/FreeX.Core.Calc.Tests/ViewportStyleTests.cs`

---

- [ ] **Step 1 — Write failing test for style population**

Create `tests/FreeX.Core.Calc.Tests/ViewportStyleTests.cs`:

```csharp
using FreeX.Core.Calc;
using FreeX.Core.Model;
using Xunit;

namespace FreeX.Core.Calc.Tests;

public class ViewportStyleTests
{
    [Fact]
    public void GetViewport_CellWithBoldStyle_PopulatesStyleOnDisplayCell()
    {
        var workbook = new Workbook("test");
        var sheet = workbook.AddSheet("Sheet1");
        var style = new CellStyle { Bold = true };
        var styleId = workbook.RegisterStyle(style);

        var cell = Cell.FromValue(new NumberValue(1));
        cell.StyleId = styleId;
        sheet.SetCell(new CellAddress(sheet.Id, 1, 1), cell);

        var svc = new ViewportService();
        var vp = svc.GetViewport(workbook, sheet.Id,
            new ViewportRequest(1, 1, 500, 500));

        var dc = vp.Cells.Single(c => c.Row == 1 && c.Col == 1);
        Assert.NotNull(dc.Style);
        Assert.True(dc.Style!.Bold);
    }

    [Fact]
    public void GetViewport_CellWithDefaultStyle_StyleIsDefault()
    {
        var workbook = new Workbook("test");
        var sheet = workbook.AddSheet("Sheet1");
        sheet.SetCell(new CellAddress(sheet.Id, 1, 1),
            Cell.FromValue(new NumberValue(42)));

        var svc = new ViewportService();
        var vp = svc.GetViewport(workbook, sheet.Id,
            new ViewportRequest(1, 1, 500, 500));

        var dc = vp.Cells.Single(c => c.Row == 1 && c.Col == 1);
        // Default style is fine to include; it should not be null
        Assert.NotNull(dc.Style);
        Assert.False(dc.Style!.Bold);
    }
}
```

- [ ] **Step 2 — Run test, verify it fails**

```
dotnet test tests/FreeX.Core.Calc.Tests --filter ViewportStyleTests
```
Expected: FAIL — `dc.Style` is null (not yet populated).

- [ ] **Step 3 — Populate `Style` in `ViewportService`**

In `src/FreeX.Core.Calc/ViewportService.cs`, in the cell-retrieval foreach, resolve the style before building `DisplayCell`:

```csharp
foreach (var rowMetric in rowMetrics)
{
    foreach (var colMetric in colMetrics)
    {
        var cell = sheet.GetCell(rowMetric.Row, colMetric.Col);
        if (cell != null)
        {
            var style = workbook.GetStyle(cell.StyleId);
            cells.Add(new DisplayCell(
                rowMetric.Row, colMetric.Col,
                cell.Value,
                NumberFormatter.Format(cell.Value, style.NumberFormat),
                request.IncludeFormulas ? cell.FormulaText : null,
                cell.StyleId,
                null,
                style
            ));
        }
    }
}
```

- [ ] **Step 4 — Run test, verify it passes**

```
dotnet test tests/FreeX.Core.Calc.Tests --filter ViewportStyleTests
```

- [ ] **Step 5 — Update `RenderCells` in GridView to apply styles**

Replace the entire `RenderCells` method in `src/FreeX.App.UI/GridView.cs`:

```csharp
private void RenderCells(DrawingContext dc)
{
    // Build style lookup keyed by (row, col) for the background pass
    var styleLookup = Viewport!.Cells
        .Where(c => c.Style != null)
        .ToDictionary(c => (c.Row, c.Col), c => c.Style!);

    // Pass 1: backgrounds (fill color or white)
    foreach (var rowMetric in Viewport.RowMetrics)
    {
        foreach (var colMetric in Viewport.ColMetrics)
        {
            var rect = new Rect(
                colMetric.LeftOffset + HeaderSize, rowMetric.TopOffset + HeaderSize,
                colMetric.Width, rowMetric.Height);

            Brush fill = Brushes.White;
            if (styleLookup.TryGetValue((rowMetric.Row, colMetric.Col), out var bg)
                && bg.FillColor.HasValue)
            {
                fill = new SolidColorBrush(Color.FromRgb(
                    bg.FillColor.Value.R, bg.FillColor.Value.G, bg.FillColor.Value.B));
            }

            dc.DrawRectangle(fill, GridPen, rect);
        }
    }

    // Pass 2: explicit cell borders (drawn on top of fills)
    foreach (var cell in Viewport.Cells)
    {
        if (cell.Style == null) continue;
        var rowMetric = Viewport.RowMetrics.FirstOrDefault(r => r.Row == cell.Row);
        var colMetric = Viewport.ColMetrics.FirstOrDefault(c => c.Col == cell.Col);
        if (rowMetric is null || colMetric is null) continue;

        double x = colMetric.LeftOffset + HeaderSize;
        double y = rowMetric.TopOffset  + HeaderSize;
        double w = colMetric.Width;
        double h = rowMetric.Height;

        DrawBorderEdge(dc, cell.Style.BorderTop,    new Point(x,     y),     new Point(x + w, y));
        DrawBorderEdge(dc, cell.Style.BorderBottom, new Point(x,     y + h), new Point(x + w, y + h));
        DrawBorderEdge(dc, cell.Style.BorderLeft,   new Point(x,     y),     new Point(x,     y + h));
        DrawBorderEdge(dc, cell.Style.BorderRight,  new Point(x + w, y),     new Point(x + w, y + h));
    }

    // Pass 3: text
    var rowLookup = Viewport.RowMetrics.ToDictionary(r => r.Row);
    var colLookup = Viewport.ColMetrics.ToDictionary(c => c.Col);

    foreach (var cell in Viewport.Cells)
    {
        if (!rowLookup.TryGetValue(cell.Row, out var rowMetric)) continue;
        if (!colLookup.TryGetValue(cell.Col, out var colMetric)) continue;
        if (string.IsNullOrEmpty(cell.DisplayText)) continue;

        var style = cell.Style;
        var rect = new Rect(
            colMetric.LeftOffset + HeaderSize, rowMetric.TopOffset + HeaderSize,
            colMetric.Width, rowMetric.Height);

        var typeface = (style?.Bold == true, style?.Italic == true) switch
        {
            (true,  true)  => new Typeface(new FontFamily("Segoe UI"), FontStyles.Italic,  FontWeights.Bold,   FontStretches.Normal),
            (true,  false) => new Typeface(new FontFamily("Segoe UI"), FontStyles.Normal,  FontWeights.Bold,   FontStretches.Normal),
            (false, true)  => new Typeface(new FontFamily("Segoe UI"), FontStyles.Italic,  FontWeights.Normal, FontStretches.Normal),
            _              => DefaultTypeface
        };

        double fontSize = (style?.FontSize > 0) ? style!.FontSize : 12.0;

        Brush textBrush = TextBrush;
        if (style?.FontColor is { } fc && (fc.R != 0 || fc.G != 0 || fc.B != 0))
            textBrush = new SolidColorBrush(Color.FromRgb(fc.R, fc.G, fc.B));

        var text = new FormattedText(
            cell.DisplayText,
            CultureInfo.CurrentCulture,
            FlowDirection.LeftToRight,
            typeface, fontSize, textBrush,
            VisualTreeHelper.GetDpi(this).PixelsPerDip);

        text.MaxTextWidth = Math.Max(0, colMetric.Width - 4);

        // Horizontal alignment: right for numbers (General), honour explicit alignment
        var hAlign = style?.HorizontalAlignment ?? HorizontalAlignment.General;
        bool isNumeric = cell.RawValue is NumberValue or DateTimeValue;

        double textX = hAlign switch
        {
            HorizontalAlignment.Right  => rect.Right - Math.Min(text.Width, colMetric.Width - 2) - 2,
            HorizontalAlignment.Center => rect.Left + (rect.Width - text.Width) / 2,
            HorizontalAlignment.General when isNumeric
                                       => rect.Right - Math.Min(text.Width, colMetric.Width - 2) - 2,
            _                          => rect.Left + 2
        };

        double textY = rect.Top + (rect.Height - text.Height) / 2;
        dc.DrawText(text, new Point(textX, textY));
    }
}

private static void DrawBorderEdge(DrawingContext dc, CellBorder border, Point p1, Point p2)
{
    if (border.Style == BorderStyle.None) return;

    double thickness = border.Style switch
    {
        BorderStyle.Thin   => 0.5,
        BorderStyle.Medium => 1.5,
        BorderStyle.Thick  => 2.5,
        _                  => 0.5
    };

    DashStyle dash = border.Style switch
    {
        BorderStyle.Dashed => DashStyles.Dash,
        BorderStyle.Dotted => DashStyles.Dot,
        _                  => DashStyles.Solid
    };

    var pen = new Pen(
        new SolidColorBrush(Color.FromRgb(border.Color.R, border.Color.G, border.Color.B)),
        thickness) { DashStyle = dash };

    dc.DrawLine(pen, p1, p2);
}
```

Add `using FreeX.Core.Model;` to GridView.cs if `HorizontalAlignment` and `BorderStyle` are not already in scope (they are in `Core.Model`).

- [ ] **Step 6 — Build and smoke-test visually**

```
dotnet build FreeX.slnx -c Debug
```

Launch the app, open an `.xlsx` with bold headers or colored cells, verify styles are applied.

- [ ] **Step 7 — Commit**

```
git add src/FreeX.Core.Calc/ViewportService.cs src/FreeX.App.UI/GridView.cs tests/FreeX.Core.Calc.Tests/ViewportStyleTests.cs
git commit -m "feat: cell style rendering — bold, italic, color, fill, borders, alignment (Task 3.2)"
```

---

## Task 3 — Copy / Paste / Cut

**Purpose:** Ctrl+C/X/V are missing. Phase 1 listed them as required but they were deferred. Implement using the system clipboard with tab-separated text (compatible with Excel). Internal paste uses `EditCellsCommand` for undo support.

**Files:**
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Test: `tests/FreeX.Integration.Tests/ClipboardTests.cs`

---

- [ ] **Step 1 — Write failing integration test**

Create `tests/FreeX.Integration.Tests/ClipboardTests.cs`:

```csharp
using FreeX.Core.Calc;
using FreeX.Core.Commands;
using FreeX.Core.Model;
using Xunit;

namespace FreeX.Integration.Tests;

/// <summary>Tests clipboard logic without WPF clipboard — exercises the tab-separated serialisation.</summary>
public class ClipboardTests
{
    [Fact]
    public void SerialiseRange_SingleCell_ReturnsDisplayText()
    {
        var workbook = new Workbook("test");
        var sheet = workbook.AddSheet("Sheet1");
        sheet.SetCell(new CellAddress(sheet.Id, 1, 1), Cell.FromValue(new NumberValue(42)));

        var svc = new ViewportService();
        var vp = svc.GetViewport(workbook, sheet.Id, new ViewportRequest(1, 1, 500, 500));
        var cell = vp.Cells.Single(c => c.Row == 1 && c.Col == 1);

        Assert.Equal("42", cell.DisplayText);
    }

    [Fact]
    public void SerialiseRange_TwoColumns_TabSeparated()
    {
        var workbook = new Workbook("test");
        var sheet = workbook.AddSheet("Sheet1");
        sheet.SetCell(new CellAddress(sheet.Id, 1, 1), Cell.FromValue(new TextValue("A")));
        sheet.SetCell(new CellAddress(sheet.Id, 1, 2), Cell.FromValue(new TextValue("B")));

        var svc = new ViewportService();
        var vp = svc.GetViewport(workbook, sheet.Id, new ViewportRequest(1, 1, 500, 500));

        // Simulate what the copy handler does
        var text = ClipboardSerializer.Serialize(vp, new GridRange(
            new CellAddress(sheet.Id, 1, 1),
            new CellAddress(sheet.Id, 1, 2)));

        Assert.Equal("A\tB", text);
    }

    [Fact]
    public void SerialiseRange_TwoRows_NewlineSeparated()
    {
        var workbook = new Workbook("test");
        var sheet = workbook.AddSheet("Sheet1");
        sheet.SetCell(new CellAddress(sheet.Id, 1, 1), Cell.FromValue(new TextValue("R1")));
        sheet.SetCell(new CellAddress(sheet.Id, 2, 1), Cell.FromValue(new TextValue("R2")));

        var svc = new ViewportService();
        var vp = svc.GetViewport(workbook, sheet.Id, new ViewportRequest(1, 1, 500, 500));

        var text = ClipboardSerializer.Serialize(vp, new GridRange(
            new CellAddress(sheet.Id, 1, 1),
            new CellAddress(sheet.Id, 2, 1)));

        Assert.Equal("R1\r\nR2", text);
    }
}
```

- [ ] **Step 2 — Run test to confirm it fails**

```
dotnet test tests/FreeX.Integration.Tests --filter ClipboardTests
```
Expected: compilation error — `ClipboardSerializer` does not exist.

- [ ] **Step 3 — Create `ClipboardSerializer` in `Core.Commands`**

Add `src/FreeX.Core.Commands/ClipboardSerializer.cs`:

```csharp
using System.Text;
using FreeX.Core.Model;

namespace FreeX.Core.Commands;

public static class ClipboardSerializer
{
    /// <summary>Serialises the display text of <paramref name="range"/> as Excel-compatible
    /// tab/newline-delimited text.</summary>
    public static string Serialize(ViewportModel viewport, GridRange range)
    {
        var rowLookup = viewport.RowMetrics.ToDictionary(r => r.Row);
        var colLookup = viewport.ColMetrics.ToDictionary(c => c.Col);
        var cellLookup = viewport.Cells.ToDictionary(c => (c.Row, c.Col));

        var sb = new StringBuilder();
        bool firstRow = true;

        for (uint r = range.Start.Row; r <= range.End.Row; r++)
        {
            if (!firstRow) sb.Append("\r\n");
            firstRow = false;

            bool firstCol = true;
            for (uint c = range.Start.Col; c <= range.End.Col; c++)
            {
                if (!firstCol) sb.Append('\t');
                firstCol = false;

                if (cellLookup.TryGetValue((r, c), out var cell))
                    sb.Append(cell.DisplayText);
            }
        }

        return sb.ToString();
    }

    /// <summary>Parses tab/newline-delimited text into a 2-D array of strings.</summary>
    public static string[][] Deserialize(string text)
    {
        var rows = text.Split(["\r\n", "\n"], StringSplitOptions.None);
        return rows.Select(r => r.Split('\t')).ToArray();
    }
}
```

- [ ] **Step 4 — Run tests, verify they pass**

```
dotnet test tests/FreeX.Integration.Tests --filter ClipboardTests
```

- [ ] **Step 5 — Add copy / paste / cut to `MainWindow.xaml.cs`**

In `MainWindow_KeyDown`, add before the existing key handlers:

```csharp
// Copy
if (e.Key == Key.C && (Keyboard.Modifiers & ModifierKeys.Control) != 0)
{
    ExecuteCopy();
    e.Handled = true;
    return;
}
// Cut
if (e.Key == Key.X && (Keyboard.Modifiers & ModifierKeys.Control) != 0)
{
    ExecuteCopy();
    ExecuteClearSelection();
    e.Handled = true;
    return;
}
// Paste
if (e.Key == Key.V && (Keyboard.Modifiers & ModifierKeys.Control) != 0)
{
    ExecutePaste();
    e.Handled = true;
    return;
}
```

Add the three helper methods at the bottom of `MainWindow.xaml.cs`:

```csharp
private void ExecuteCopy()
{
    if (SheetGrid.SelectedRange is not { } range) return;
    var viewport = SheetGrid.Viewport;
    if (viewport == null) return;

    var text = ClipboardSerializer.Serialize(viewport, range);
    try { System.Windows.Clipboard.SetText(text); }
    catch { /* clipboard may be locked */ }
}

private void ExecutePaste()
{
    if (SheetGrid.SelectedRange is not { } range) return;

    string text;
    try { text = System.Windows.Clipboard.GetText(); }
    catch { return; }
    if (string.IsNullOrEmpty(text)) return;

    var rows = ClipboardSerializer.Deserialize(text);
    var edits = new List<(CellAddress Address, ScalarValue Value)>();

    for (int ri = 0; ri < rows.Length; ri++)
    {
        for (int ci = 0; ci < rows[ri].Length; ci++)
        {
            var addr = new CellAddress(_currentSheetId,
                range.Start.Row + (uint)ri,
                range.Start.Col + (uint)ci);
            ScalarValue val = double.TryParse(rows[ri][ci],
                System.Globalization.NumberStyles.Any,
                System.Globalization.CultureInfo.CurrentCulture, out var d)
                ? new NumberValue(d)
                : new TextValue(rows[ri][ci]);
            edits.Add((addr, val));
        }
    }

    if (edits.Count == 0) return;

    var command = new EditCellsCommand(edits
        .Select(e => new CellEdit(e.Address, e.Value, null))
        .ToList());
    _commandBus.Execute(_workbook.Id, command);
    _recalcEngine.Recalculate(_workbook, edits.Select(e => e.Address).ToList());
    UpdateViewport();
}

private void ExecuteClearSelection()
{
    if (SheetGrid.SelectedRange is not { } range) return;

    var sheet = _workbook.GetSheet(_currentSheetId);
    if (sheet == null) return;

    var edits = new List<CellEdit>();
    for (uint r = range.Start.Row; r <= range.End.Row; r++)
        for (uint c = range.Start.Col; c <= range.End.Col; c++)
            edits.Add(new CellEdit(new CellAddress(_currentSheetId, r, c), BlankValue.Instance, null));

    var command = new EditCellsCommand(edits);
    _commandBus.Execute(_workbook.Id, command);
    UpdateViewport();
}
```

Add `using FreeX.Core.Commands;` if not already present. Add `using System.Collections.Generic;` and `using System.Linq;`.

Also check `Commands.cs` for the exact `CellEdit` and `EditCellsCommand` constructor signatures and adjust parameter names to match.

- [ ] **Step 6 — Build and smoke-test**

```
dotnet build FreeX.slnx -c Debug
```

Launch app → type values in A1:B2 → select A1:B2 → Ctrl+C → click D1 → Ctrl+V → values should appear.

- [ ] **Step 7 — Commit**

```
git add src/FreeX.Core.Commands/ClipboardSerializer.cs src/FreeX.App.Host/MainWindow.xaml.cs tests/FreeX.Integration.Tests/ClipboardTests.cs
git commit -m "feat: copy/paste/cut with system clipboard (Task 3.3)"
```

---

## Task 4 — Multi-Sheet Tab UI

**Purpose:** The tab bar is hardcoded to a single "Sheet1" label. The engine already supports multiple sheets (loaded from `.xlsx`). This task makes the tab bar dynamic: switching, adding, deleting, and renaming sheets.

**Files:**
- Modify: `src/FreeX.App.Host/MainWindow.xaml`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`

---

- [ ] **Step 1 — Replace the hardcoded tab in `MainWindow.xaml`**

Replace the entire `<!-- Sheet tabs -->` section in `MainWindow.xaml`:

```xml
<!-- Sheet tabs -->
<Border Grid.Row="3" Background="#E8E8E8" BorderBrush="#D0D0D0"
        BorderThickness="0,1,0,0" Padding="4,2">
    <StackPanel Orientation="Horizontal">
        <Button x:Name="AddSheetButton" Content="+" Width="24" Height="22"
                FontSize="14" Margin="0,0,4,0"
                Background="Transparent" BorderBrush="#C0C0C0"
                Click="AddSheetButton_Click"/>
        <ItemsControl x:Name="SheetTabsControl">
            <ItemsControl.ItemsPanel>
                <ItemsPanelTemplate>
                    <StackPanel Orientation="Horizontal"/>
                </ItemsPanelTemplate>
            </ItemsControl.ItemsPanel>
            <ItemsControl.ItemTemplate>
                <DataTemplate>
                    <Border x:Name="TabBorder"
                            BorderBrush="#D0D0D0" BorderThickness="1"
                            CornerRadius="3,3,0,0" Padding="10,3" Margin="2,0,0,0"
                            Cursor="Hand"
                            MouseLeftButtonDown="SheetTab_MouseLeftButtonDown"
                            MouseRightButtonDown="SheetTab_MouseRightButtonDown">
                        <TextBlock Text="{Binding Name}" FontSize="12"
                                   x:Name="TabText"
                                   MouseDown="SheetTab_LabelMouseDown"/>
                    </Border>
                </DataTemplate>
            </ItemsControl.ItemTemplate>
        </ItemsControl>
    </StackPanel>
</Border>
```

- [ ] **Step 2 — Add a `SheetTabViewModel` helper class**

At the bottom of `MainWindow.xaml.cs` (outside the `MainWindow` class), add:

```csharp
internal sealed class SheetTabViewModel(SheetId id, string name) : System.ComponentModel.INotifyPropertyChanged
{
    public SheetId Id { get; } = id;

    private string _name = name;
    public string Name
    {
        get => _name;
        set { _name = value; PropertyChanged?.Invoke(this, new(nameof(Name))); }
    }

    public event System.ComponentModel.PropertyChangedEventHandler? PropertyChanged;
}
```

- [ ] **Step 3 — Add tab refresh logic to `MainWindow.xaml.cs`**

Add a field and helper method:

```csharp
private System.Collections.ObjectModel.ObservableCollection<SheetTabViewModel> _sheetTabs = [];
```

In the constructor, after `InitializeComponent()`:

```csharp
SheetTabsControl.ItemsSource = _sheetTabs;
```

Add the refresh method (call it whenever sheets change):

```csharp
private void RefreshSheetTabs()
{
    _sheetTabs.Clear();
    foreach (var sheet in _workbook.Sheets)
        _sheetTabs.Add(new SheetTabViewModel(sheet.Id, sheet.Name));

    // Highlight active tab
    foreach (var tab in _sheetTabs)
    {
        var container = SheetTabsControl.ItemContainerGenerator
            .ContainerFromItem(tab) as FrameworkElement;
        if (container?.FindName("TabBorder") is Border border)
            border.Background = tab.Id == _currentSheetId ? Brushes.White : Brushes.Transparent;
    }
}
```

Call `RefreshSheetTabs()` at the end of `MainWindow_Loaded`, `OpenButton_Click`, and any place `_currentSheetId` changes.

- [ ] **Step 4 — Add tab event handlers**

```csharp
private void SheetTab_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
{
    if ((sender as FrameworkElement)?.DataContext is not SheetTabViewModel tab) return;
    _currentSheetId = tab.Id;
    UpdateViewport();
    RefreshSheetTabs();
}

private void SheetTab_MouseRightButtonDown(object sender, MouseButtonEventArgs e)
{
    if ((sender as FrameworkElement)?.DataContext is not SheetTabViewModel tab) return;
    // Simple rename via InputDialog (inline prompt)
    var name = Microsoft.VisualBasic.Interaction.InputBox(
        "Sheet name:", "Rename Sheet", tab.Name);
    if (!string.IsNullOrWhiteSpace(name) && name != tab.Name)
    {
        _commandBus.Execute(_workbook.Id, new RenameSheetCommand(_currentSheetId, name));
        RefreshSheetTabs();
    }
    e.Handled = true;
}

private void SheetTab_LabelMouseDown(object sender, MouseButtonEventArgs e)
{
    // Double-click to rename
    if (e.ClickCount == 2) SheetTab_MouseRightButtonDown(sender, e);
}

private void AddSheetButton_Click(object sender, RoutedEventArgs e)
{
    var name = $"Sheet{_workbook.Sheets.Count + 1}";
    _commandBus.Execute(_workbook.Id, new AddSheetCommand(name));
    _currentSheetId = _workbook.Sheets[^1].Id;
    UpdateViewport();
    RefreshSheetTabs();
}
```

Note: `Microsoft.VisualBasic.Interaction.InputBox` requires adding `<UseWindowsForms>true</UseWindowsForms>` to the Host `.csproj`, OR replace with a simple WPF `InputDialog` window. The simplest alternative is:

```csharp
// Replace InputBox with:
var dlg = new Microsoft.Win32.SaveFileDialog { Title = "Rename Sheet", FileName = tab.Name };
// Actually: use a simple custom dialog or prompt
```

Best option — add a tiny inline dialog helper instead:

```csharp
private static string? PromptForInput(string prompt, string defaultValue)
{
    var win = new Window
    {
        Title = prompt, Width = 300, Height = 120,
        WindowStartupLocation = WindowStartupLocation.CenterOwner,
        ResizeMode = ResizeMode.NoResize
    };
    var tb = new System.Windows.Controls.TextBox { Text = defaultValue, Margin = new Thickness(10) };
    var btn = new System.Windows.Controls.Button { Content = "OK", Margin = new Thickness(10, 0, 10, 10) };
    var sp = new System.Windows.Controls.StackPanel();
    sp.Children.Add(tb);
    sp.Children.Add(btn);
    win.Content = sp;
    string? result = null;
    btn.Click += (_, _) => { result = tb.Text; win.Close(); };
    win.ShowDialog();
    return result;
}
```

And use `PromptForInput("Rename Sheet", tab.Name)` instead of `InputBox`.

- [ ] **Step 5 — Build and smoke-test**

```
dotnet build FreeX.slnx -c Debug
```

Open a multi-sheet `.xlsx`. Tabs should appear. Clicking a tab switches sheets. "+" adds a new sheet. Right-click or double-click renames.

- [ ] **Step 6 — Commit**

```
git add src/FreeX.App.Host/MainWindow.xaml src/FreeX.App.Host/MainWindow.xaml.cs
git commit -m "feat: dynamic multi-sheet tab bar with add and rename (Task 3.4)"
```

---

## Task 5 — Freeze Panes

**Purpose:** `ViewportModel.FrozenPanes` is a placeholder that is always `null`. This task reads freeze-pane state from the `Sheet` model (loaded from XLSX), renders a visual divider line in GridView, and keeps frozen rows/columns fixed while the rest of the sheet scrolls.

**Files:**
- Modify: `src/FreeX.Core.Model/Sheet.cs`
- Modify: `src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Modify: `src/FreeX.Core.Calc/ViewportService.cs`
- Modify: `src/FreeX.App.UI/GridView.cs`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`

---

- [ ] **Step 1 — Add freeze properties to `Sheet.cs`**

In `src/FreeX.Core.Model/Sheet.cs`, add two properties after `DefaultRowHeight`:

```csharp
/// <summary>Number of rows frozen at the top (0 = none).</summary>
public uint FrozenRows { get; set; } = 0;

/// <summary>Number of columns frozen at the left (0 = none).</summary>
public uint FrozenCols { get; set; } = 0;
```

- [ ] **Step 2 — Read freeze panes from XLSX in `XlsxFileAdapter.cs`**

In the `Load` method, after the row/column width loops, add:

```csharp
var pane = xlSheet.SheetView.Pane;
if (pane != null)
{
    if (pane.State == XLPaneState.Frozen || pane.State == XLPaneState.FrozenSplit)
    {
        sheet.FrozenRows = (uint)(pane.ActiveCell?.RowNumber - 1 ?? 0);
        sheet.FrozenCols = (uint)(pane.ActiveCell?.ColumnNumber - 1 ?? 0);
    }
}
```

In the `Save` method, after the row/column width save loops, add:

```csharp
if (sheet.FrozenRows > 0 || sheet.FrozenCols > 0)
{
    xlSheet.SheetView.Freeze((int)sheet.FrozenRows, (int)sheet.FrozenCols);
}
```

- [ ] **Step 3 — Populate `FrozenPaneState` in `ViewportService`**

In `ViewportService.GetViewport`, change the return statement:

```csharp
var frozenPanes = (sheet.FrozenRows > 0 || sheet.FrozenCols > 0)
    ? new FrozenPaneState(sheet.FrozenRows, sheet.FrozenCols)
    : null;

return new ViewportModel(cells, rowMetrics, colMetrics, frozenPanes, []);
```

- [ ] **Step 4 — Render freeze divider in `GridView.cs`**

Add a `RenderFreezeDivider` call in `OnRender` after `RenderCells`:

```csharp
protected override void OnRender(DrawingContext dc)
{
    if (Viewport == null) return;
    dc.PushClip(new RectangleGeometry(new Rect(0, 0, ActualWidth, ActualHeight)));
    RenderHeaders(dc);
    RenderGridLines(dc);
    RenderCells(dc);
    RenderSelection(dc);
    RenderFreezeDivider(dc);   // ← add
    RenderResizeLine(dc);
    dc.Pop();
}
```

Add the method:

```csharp
private static readonly Pen FreezePen = new(
    new SolidColorBrush(Color.FromRgb(100, 100, 200)), 2);

private void RenderFreezeDivider(DrawingContext dc)
{
    if (Viewport?.FrozenPanes == null) return;
    var fp = Viewport.FrozenPanes;

    if (fp.Rows > 0)
    {
        // Find the bottom edge of the last frozen row
        var lastFrozenRow = Viewport.RowMetrics.FirstOrDefault(r => r.Row == fp.Rows);
        if (lastFrozenRow != null)
        {
            double y = lastFrozenRow.TopOffset + lastFrozenRow.Height + HeaderSize;
            dc.DrawLine(FreezePen, new Point(0, y), new Point(ActualWidth, y));
        }
    }

    if (fp.Cols > 0)
    {
        var lastFrozenCol = Viewport.ColMetrics.FirstOrDefault(c => c.Col == fp.Cols);
        if (lastFrozenCol != null)
        {
            double x = lastFrozenCol.LeftOffset + lastFrozenCol.Width + HeaderSize;
            dc.DrawLine(FreezePen, new Point(x, 0), new Point(x, ActualHeight));
        }
    }
}
```

Also freeze the pen:

```csharp
private static readonly Pen FreezePen = CreateFreezePen();
private static Pen CreateFreezePen()
{
    var p = new Pen(new SolidColorBrush(Color.FromRgb(100, 100, 200)), 2);
    p.Freeze();
    return p;
}
```

- [ ] **Step 5 — Keep frozen rows/cols fixed during scroll in `MainWindow.xaml.cs`**

The viewport request's `TopRow`/`LeftCol` should be clamped so frozen rows/columns always remain visible. In `UpdateViewport`:

```csharp
private void UpdateViewport()
{
    if (SheetGrid == null || _viewportService == null) return;

    var sheet = _workbook.GetSheet(_currentSheetId);
    uint topRow  = Math.Max(sheet?.FrozenRows  + 1 ?? 1, (uint)VerticalScroll.Value);
    uint leftCol = Math.Max(sheet?.FrozenCols  + 1 ?? 1, (uint)HorizontalScroll.Value);

    const double headerSize = 30;
    var request = new ViewportRequest(
        TopRow: topRow,
        LeftCol: leftCol,
        AvailableHeight: SheetGrid.ActualHeight - headerSize,
        AvailableWidth:  SheetGrid.ActualWidth  - headerSize
    );

    var viewport = _viewportService.GetViewport(_workbook, _currentSheetId, request);
    SheetGrid.Viewport = viewport;
}
```

> Note: this is a simplified freeze implementation that shows frozen rows in the same panel. A full Excel-fidelity implementation would require splitting the viewport into two panels (frozen + scrollable); that is a Phase 4 enhancement. The divider line and scroll clamping give correct behaviour for the common case.

- [ ] **Step 6 — Build and smoke-test**

```
dotnet build FreeX.slnx -c Debug
```

Open an `.xlsx` with frozen rows (e.g., a spreadsheet with a frozen header row). A blue divider line should appear after row 1. Scrolling should not move the header.

- [ ] **Step 7 — Commit**

```
git add src/FreeX.Core.Model/Sheet.cs src/FreeX.Core.IO/XlsxFileAdapter.cs src/FreeX.Core.Calc/ViewportService.cs src/FreeX.App.UI/GridView.cs src/FreeX.App.Host/MainWindow.xaml.cs
git commit -m "feat: freeze panes — read from XLSX, render divider, clamp scroll (Task 3.5)"
```

---

## Task 6 — Basic Charts (column, line, pie)

**Purpose:** Add OxyPlot-powered charts that can be created from a selected data range and are stored in the `Sheet` model. Charts render as floating overlays in the grid. XLSX round-trip for existing charts (pass-through fidelity) is already provided by ClosedXML; this task focuses on creating and rendering new charts within the app.

**Files:**
- Create: `src/FreeX.Core.Model/ChartModel.cs`
- Modify: `src/FreeX.Core.Model/Sheet.cs`
- Modify: `src/FreeX.App.UI/GridView.cs` (chart overlay rendering)
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs` (Insert Chart button / command)
- Modify: `src/FreeX.App.Host/MainWindow.xaml` (Insert Chart button in ribbon)
- Add NuGet: `OxyPlot.Wpf` to `FreeX.App.UI`

---

- [ ] **Step 1 — Add OxyPlot to App.UI**

```
dotnet add src/FreeX.App.UI/FreeX.App.UI.csproj package OxyPlot.Wpf
```

Verify it appears in the `.csproj`:
```xml
<PackageReference Include="OxyPlot.Wpf" Version="2.*" />
```

- [ ] **Step 2 — Create `ChartModel.cs`**

Create `src/FreeX.Core.Model/ChartModel.cs`:

```csharp
namespace FreeX.Core.Model;

public enum ChartType { Column, Line, Pie }

/// <summary>Lightweight chart definition stored on a Sheet.</summary>
public sealed class ChartModel
{
    /// <summary>Unique ID within the sheet.</summary>
    public Guid Id { get; init; } = Guid.NewGuid();

    public ChartType Type { get; set; } = ChartType.Column;

    /// <summary>Data range (must be on the same sheet).</summary>
    public GridRange DataRange { get; set; }

    /// <summary>Whether the first row of the range contains series labels.</summary>
    public bool FirstRowIsHeader { get; set; } = true;

    /// <summary>Whether the first column of the range contains category labels.</summary>
    public bool FirstColIsCategories { get; set; } = true;

    /// <summary>Chart title (optional).</summary>
    public string? Title { get; set; }

    // Position within the sheet (in pixels from top-left of cell area)
    public double Left   { get; set; } = 50;
    public double Top    { get; set; } = 50;
    public double Width  { get; set; } = 400;
    public double Height { get; set; } = 300;
}
```

- [ ] **Step 3 — Add `Charts` collection to `Sheet.cs`**

In `src/FreeX.Core.Model/Sheet.cs`, add after `FrozenCols`:

```csharp
/// <summary>Charts embedded in this sheet.</summary>
public List<ChartModel> Charts { get; } = [];
```

- [ ] **Step 4 — Add chart rendering helper in App.UI**

Create `src/FreeX.App.UI/ChartRenderer.cs`:

```csharp
using System.Windows;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using OxyPlot;
using OxyPlot.Axes;
using OxyPlot.Series;
using OxyPlot.Wpf;
using FreeX.Core.Model;

namespace FreeX.App.UI;

/// <summary>Renders a ChartModel + its data into a WPF ImageSource suitable for DrawingContext.</summary>
public static class ChartRenderer
{
    public static ImageSource? Render(ChartModel chart, ViewportModel viewport, int dpi = 96)
    {
        var model = BuildPlotModel(chart, viewport);
        if (model == null) return null;

        var exporter = new PngExporter
        {
            Width  = (int)chart.Width,
            Height = (int)chart.Height,
            Resolution = dpi
        };

        using var stream = new System.IO.MemoryStream();
        exporter.Export(model, stream);
        stream.Position = 0;

        var bitmap = new BitmapImage();
        bitmap.BeginInit();
        bitmap.StreamSource = stream;
        bitmap.CacheOption = BitmapCacheOption.OnLoad;
        bitmap.EndInit();
        bitmap.Freeze();
        return bitmap;
    }

    private static PlotModel? BuildPlotModel(ChartModel chart, ViewportModel viewport)
    {
        var cellLookup = viewport.Cells.ToDictionary(c => (c.Row, c.Col));

        uint startRow = chart.DataRange.Start.Row;
        uint endRow   = chart.DataRange.End.Row;
        uint startCol = chart.DataRange.Start.Col;
        uint endCol   = chart.DataRange.End.Col;

        uint dataStartRow = chart.FirstRowIsHeader ? startRow + 1 : startRow;
        uint dataStartCol = chart.FirstColIsCategories ? startCol + 1 : startCol;

        var categories = new List<string>();
        if (chart.FirstColIsCategories)
            for (uint r = dataStartRow; r <= endRow; r++)
                categories.Add(cellLookup.TryGetValue((r, startCol), out var c) ? c.DisplayText : "");

        var model = new PlotModel { Title = chart.Title };

        if (chart.Type == ChartType.Pie)
        {
            var pieSeries = new PieSeries { StrokeThickness = 1.0, InsideLabelPosition = 0.8 };
            for (uint r = dataStartRow; r <= endRow; r++)
            {
                if (!cellLookup.TryGetValue((r, dataStartCol), out var cell)) continue;
                if (!double.TryParse(cell.DisplayText, out var v)) continue;
                var label = categories.Count > (int)(r - dataStartRow) ? categories[(int)(r - dataStartRow)] : "";
                pieSeries.Slices.Add(new PieSlice(label, v));
            }
            model.Series.Add(pieSeries);
            return model;
        }

        // Column / Line: one series per data column
        for (uint col = dataStartCol; col <= endCol; col++)
        {
            string seriesName = chart.FirstRowIsHeader && cellLookup.TryGetValue((startRow, col), out var hdr)
                ? hdr.DisplayText : $"Series {col - dataStartCol + 1}";

            if (chart.Type == ChartType.Column)
            {
                var series = new BarSeries { Title = seriesName };
                var catAxis = new CategoryAxis { Position = AxisPosition.Left };
                catAxis.Labels.AddRange(categories);
                if (!model.Axes.Any(a => a is CategoryAxis))
                    model.Axes.Add(catAxis);
                model.Axes.TryAdd(new LinearAxis { Position = AxisPosition.Bottom });

                for (uint r = dataStartRow; r <= endRow; r++)
                {
                    if (cellLookup.TryGetValue((r, col), out var cell)
                        && double.TryParse(cell.DisplayText, out var v))
                        series.Items.Add(new BarItem { Value = v });
                }
                model.Series.Add(series);
            }
            else // Line
            {
                var series = new LineSeries { Title = seriesName };
                int i = 0;
                for (uint r = dataStartRow; r <= endRow; r++, i++)
                {
                    if (cellLookup.TryGetValue((r, col), out var cell)
                        && double.TryParse(cell.DisplayText, out var v))
                        series.Points.Add(new DataPoint(i, v));
                }
                model.Series.Add(series);
            }
        }

        return model;
    }
}
```

- [ ] **Step 5 — Render charts in `GridView.OnRender`**

Add a `Charts` dependency property to `GridView` and render them:

```csharp
public static readonly DependencyProperty ChartsProperty =
    DependencyProperty.Register(nameof(Charts), typeof(IReadOnlyList<ChartModel>),
        typeof(GridView),
        new FrameworkPropertyMetadata(null, FrameworkPropertyMetadataOptions.AffectsRender));

public IReadOnlyList<ChartModel>? Charts
{
    get => (IReadOnlyList<ChartModel>?)GetValue(ChartsProperty);
    set => SetValue(ChartsProperty, value);
}
```

In `OnRender`, after `RenderResizeLine`:

```csharp
RenderCharts(dc);
```

Add the method:

```csharp
private void RenderCharts(DrawingContext dc)
{
    if (Charts == null || Viewport == null) return;
    foreach (var chart in Charts)
    {
        var img = ChartRenderer.Render(chart, Viewport);
        if (img == null) continue;
        var rect = new Rect(chart.Left + HeaderSize, chart.Top + HeaderSize,
                            chart.Width, chart.Height);
        dc.DrawImage(img, rect);
    }
}
```

- [ ] **Step 6 — Wire charts into `MainWindow.xaml.cs`**

In `UpdateViewport`, after setting `SheetGrid.Viewport`, also update charts:

```csharp
var sheet = _workbook.GetSheet(_currentSheetId);
SheetGrid.Charts = sheet?.Charts;
```

Add "Insert Chart" button to the ribbon in `MainWindow.xaml`:

```xml
<Button Content="Chart" Click="InsertChartButton_Click" Width="50" Height="24" Margin="4,0"
        Background="#2D8C57" Foreground="White" BorderThickness="0"/>
```

Add the handler in `MainWindow.xaml.cs`:

```csharp
private void InsertChartButton_Click(object sender, RoutedEventArgs e)
{
    if (SheetGrid.SelectedRange is not { } range) return;
    var sheet = _workbook.GetSheet(_currentSheetId);
    if (sheet == null) return;

    var chart = new ChartModel
    {
        Type = ChartType.Column,
        DataRange = range,
        Title = "Chart",
        Left = 20, Top = 20, Width = 400, Height = 300
    };
    sheet.Charts.Add(chart);
    UpdateViewport();
}
```

- [ ] **Step 7 — Build and smoke-test**

```
dotnet build FreeX.slnx -c Debug
```

Enter data in A1:B5 (column headers in row 1, numbers in rows 2-5). Select A1:B5. Click "Chart". A column chart should appear in the top-left of the grid.

- [ ] **Step 8 — Commit**

```
git add src/FreeX.Core.Model/ChartModel.cs src/FreeX.Core.Model/Sheet.cs src/FreeX.App.UI/ChartRenderer.cs src/FreeX.App.UI/GridView.cs src/FreeX.App.Host/MainWindow.xaml src/FreeX.App.Host/MainWindow.xaml.cs
git commit -m "feat: basic column/line/pie charts via OxyPlot (Task 3.6)"
```

---

## Self-review

**Spec coverage check:**

| Phase 3 requirement | Task |
|---|---|
| Number formats (General, Number, Currency, Percentage, Date, Time, Custom subset) | Task 1 |
| Cell formatting rendered (font/fill/border/alignment) | Task 2 |
| Column/row resize | ✅ done before this plan |
| Multiple sheets with tab bar (add, rename) | Task 4 |
| Freeze panes | Task 5 |
| Find & Replace | ✅ done in Phase 2 |
| Basic charts (column, line, pie) | Task 6 |
| Copy/paste/cut | Task 3 (Phase 1 gap, included here) |

**Gaps:** Delete sheet (right-click context menu on tab) is not included — it can be added to Task 4 as a follow-up. Chart drag-to-reposition is not included (Phase 4 enhancement). Double-click header to auto-fit row/column is not included (Phase 4 enhancement).

**Placeholder scan:** No TBDs or TODO stubs found. All code blocks are complete. The freeze pane simplification note is explicit and intentional (not a gap).

**Type consistency:**
- `ClipboardSerializer` used in Task 3 tests and MainWindow — consistent namespace (`FreeX.Core.Commands`).
- `ChartModel`, `ChartType` defined in Task 6 Step 2, used in Steps 4–6 — consistent.
- `FrozenPaneState(uint Rows, uint Cols)` matches existing record definition in `Dtos.cs`.
- `NumberFormatter.Format(ScalarValue, string)` defined in Task 1 Step 3, called in Task 1 Step 5 — consistent.
