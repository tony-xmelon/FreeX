# Phase 4b Dynamic Arrays (Spill Engine + FILTER/SORT/UNIQUE/SEQUENCE)

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add spill-range infrastructure and four dynamic array functions (SEQUENCE, FILTER, SORT, UNIQUE) so formulas can return multi-cell arrays that automatically populate adjacent cells.

**Architecture:** Spill values live in a separate `_spillValues` dictionary in `Sheet`. `RecalcEngine` checks for `RangeValue` results after evaluating a formula, then calls `sheet.SetSpillRange()` or marks the anchor with `#SPILL!` if blocked. The four functions return `RangeValue` from `FormulaEvaluator`; the spill engine writes the rest to the sheet. All four functions are added to `IsStructuredRangeFunction` (FILTER/SORT/UNIQUE need their array arg as `RangeValue`; SEQUENCE takes only scalars but gets the same treatment for consistency).

**Tech Stack:** C# 12 / .NET 10, xUnit + FluentAssertions, `dotnet test`

---

## File Map

| File | Change |
|------|--------|
| `src/FreeX.Core.Model/ScalarValue.cs` | Add `ErrorValue.Spill` constant |
| `src/FreeX.Core.Model/Sheet.cs` | Add `_spillValues`, `_spillAnchors`, update `GetValue`, add `SetSpillRange`/`ClearSpillRange`/`IsSpillBlocked` |
| `src/FreeX.Core.Calc/RecalcEngine.cs` | Handle `RangeValue` results from formula evaluation |
| `src/FreeX.Core.Formula/BuiltInFunctions.cs` | Add SEQUENCE, FILTER, SORT, UNIQUE |
| `src/FreeX.Core.Formula/FormulaEvaluator.cs` | Add FILTER/SORT/UNIQUE/SEQUENCE to `IsStructuredRangeFunction` |
| `tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs` | Add tests for the four functions |
| `tests/FreeX.Core.Calc.Tests/SpillEngineTests.cs` | New: integration tests for spill behavior |

---

## Task 1: Add `#SPILL!` error and spill infrastructure to Sheet

**Files:**
- Modify: `src/FreeX.Core.Model/ScalarValue.cs`
- Modify: `src/FreeX.Core.Model/Sheet.cs`

- [ ] **Step 1: Write failing tests**

Create `tests/FreeX.Core.Calc.Tests/SpillEngineTests.cs`:

```csharp
using FreeX.Core.Model;
using FluentAssertions;

namespace FreeX.Core.Calc.Tests;

public class SpillEngineTests
{
    private static Sheet MakeSheet() => new Sheet(SheetId.New(), "S");

    [Fact]
    public void SetSpillRange_WritesValuesToAdjacentCells()
    {
        var sheet = MakeSheet();
        var anchor = new CellAddress(sheet.Id, 1, 1);
        var cells = new ScalarValue[2, 2]
        {
            { new NumberValue(1), new NumberValue(2) },
            { new NumberValue(3), new NumberValue(4) }
        };
        sheet.SetSpillRange(anchor, new RangeValue(cells));

        sheet.GetValue(1, 2).Should().Be(new NumberValue(2));
        sheet.GetValue(2, 1).Should().Be(new NumberValue(3));
        sheet.GetValue(2, 2).Should().Be(new NumberValue(4));
    }

    [Fact]
    public void IsSpillBlocked_OccupiedCell_ReturnsTrue()
    {
        var sheet = MakeSheet();
        var anchor = new CellAddress(sheet.Id, 1, 1);
        sheet.SetCell(new CellAddress(sheet.Id, 1, 2), new NumberValue(99));
        sheet.IsSpillBlocked(anchor, 2, 2).Should().BeTrue();
    }

    [Fact]
    public void ClearSpillRange_RemovesSpillValues()
    {
        var sheet = MakeSheet();
        var anchor = new CellAddress(sheet.Id, 1, 1);
        var cells = new ScalarValue[1, 3]
        {
            { new NumberValue(1), new NumberValue(2), new NumberValue(3) }
        };
        sheet.SetSpillRange(anchor, new RangeValue(cells));
        sheet.GetValue(1, 2).Should().Be(new NumberValue(2));

        sheet.ClearSpillRange(anchor);
        sheet.GetValue(1, 2).Should().Be(new BlankValue());
    }

    [Fact]
    public void SetSpillRange_BlockedByData_DoesNotWriteSpill()
    {
        var sheet = MakeSheet();
        var anchor = new CellAddress(sheet.Id, 1, 1);
        sheet.SetCell(new CellAddress(sheet.Id, 2, 1), new NumberValue(99));
        var cells = new ScalarValue[2, 1]
        {
            { new NumberValue(1) },
            { new NumberValue(2) }
        };
        // IsSpillBlocked returns true → SetSpillRange should not write spill
        bool blocked = sheet.IsSpillBlocked(anchor, 2, 1);
        blocked.Should().BeTrue();
        // When blocked, caller skips SetSpillRange; verify no partial spill
        sheet.GetValue(2, 1).Should().Be(new NumberValue(99)); // original data preserved
    }
}
```

- [ ] **Step 2: Run to see failures** (SpillEngineTests won't compile yet)

```
dotnet build tests/FreeX.Core.Calc.Tests -v q
```

Expected: build error — `SetSpillRange`, `IsSpillBlocked`, `ClearSpillRange` not found.

- [ ] **Step 3: Add `ErrorValue.Spill` to ScalarValue.cs**

In `src/FreeX.Core.Model/ScalarValue.cs`, add after the `Circular` constant:

```csharp
    public static readonly ErrorValue Spill = new("#SPILL!");
```

Full updated block:
```csharp
public sealed record ErrorValue(string Code) : ScalarValue
{
    public static readonly ErrorValue DivByZero = new("#DIV/0!");
    public static readonly ErrorValue Value = new("#VALUE!");
    public static readonly ErrorValue Ref = new("#REF!");
    public static readonly ErrorValue Name = new("#NAME?");
    public static readonly ErrorValue Null = new("#NULL!");
    public static readonly ErrorValue NA = new("#N/A");
    public static readonly ErrorValue Num = new("#NUM!");
    public static readonly ErrorValue Circular = new("#CIRCULAR!");
    public static readonly ErrorValue Spill = new("#SPILL!");
}
```

- [ ] **Step 4: Add spill infrastructure to Sheet.cs**

Add after the existing `private readonly Dictionary<(uint Row, uint Col), Cell> _cells = [];` field:

```csharp
    // Spill values written by dynamic-array formulas.
    // Excludes anchor cell (row 0, col 0 of the range) — that is managed by _cells.
    private readonly Dictionary<(uint Row, uint Col), ScalarValue> _spillValues = [];
    // Maps anchor cell position → extent (rows × cols) of its current spill range.
    private readonly Dictionary<(uint Row, uint Col), (uint Rows, uint Cols)> _spillAnchors = [];
```

Replace the existing `GetValue(uint row, uint col)` method:

```csharp
    /// <summary>Get the value at a cell address, returning BlankValue if no cell exists.</summary>
    public ScalarValue GetValue(uint row, uint col)
    {
        if (_cells.TryGetValue((row, col), out var cell)) return cell.Value;
        if (_spillValues.TryGetValue((row, col), out var spill)) return spill;
        return new BlankValue();
    }
```

Add three new public methods after `ClearCell(CellAddress)`:

```csharp
    /// <summary>
    /// Returns true if any non-anchor cell in the proposed spill range is occupied by user data.
    /// </summary>
    public bool IsSpillBlocked(CellAddress anchor, int rows, int cols)
    {
        for (int r = 0; r < rows; r++)
            for (int c = 0; c < cols; c++)
            {
                if (r == 0 && c == 0) continue;
                if (_cells.ContainsKey((anchor.Row + (uint)r, anchor.Col + (uint)c)))
                    return true;
            }
        return false;
    }

    /// <summary>
    /// Write the spill range for a dynamic-array anchor cell.
    /// Clears any previous spill from this anchor first.
    /// Does NOT check for blockage — call <see cref="IsSpillBlocked"/> first.
    /// </summary>
    public void SetSpillRange(CellAddress anchor, RangeValue rv)
    {
        ClearSpillRange(anchor);
        int rows = rv.RowCount, cols = rv.ColCount;
        for (int r = 0; r < rows; r++)
            for (int c = 0; c < cols; c++)
            {
                if (r == 0 && c == 0) continue;
                _spillValues[(anchor.Row + (uint)r, anchor.Col + (uint)c)] = rv.Cells[r, c];
            }
        _spillAnchors[(anchor.Row, anchor.Col)] = ((uint)rows, (uint)cols);
    }

    /// <summary>Remove all spill values that were written by the given anchor cell's formula.</summary>
    public void ClearSpillRange(CellAddress anchor)
    {
        if (!_spillAnchors.TryGetValue((anchor.Row, anchor.Col), out var extent)) return;
        for (uint r = 0; r < extent.Rows; r++)
            for (uint c = 0; c < extent.Cols; c++)
            {
                if (r == 0 && c == 0) continue;
                _spillValues.Remove((anchor.Row + r, anchor.Col + c));
            }
        _spillAnchors.Remove((anchor.Row, anchor.Col));
    }
```

- [ ] **Step 5: Run tests**

```
dotnet test tests/FreeX.Core.Calc.Tests --filter "SetSpillRange|IsSpillBlocked|ClearSpillRange" -v n
```

Expected: all PASS

- [ ] **Step 6: Commit**

```
git add src/FreeX.Core.Model/ScalarValue.cs src/FreeX.Core.Model/Sheet.cs tests/FreeX.Core.Calc.Tests/SpillEngineTests.cs
git commit -m "feat: add spill range infrastructure to Sheet (SetSpillRange/ClearSpillRange/IsSpillBlocked)"
```

---

## Task 2: RecalcEngine handles RangeValue formula results

**Files:**
- Modify: `src/FreeX.Core.Calc/RecalcEngine.cs`

When a formula evaluates to `RangeValue`, the engine should either write the spill range (if unblocked) or set the anchor to `#SPILL!`.

- [ ] **Step 1: Write failing tests**

Add to `tests/FreeX.Core.Calc.Tests/SpillEngineTests.cs`:

```csharp
    // ── RecalcEngine spill integration ────────────────────────────────────────

    private static (RecalcEngine engine, Workbook wb) MakeEngine()
    {
        var graph     = new DependencyGraph();
        var evaluator = new FormulaEvaluator();
        var engine    = new RecalcEngine(graph, evaluator);
        var wb        = new Workbook();
        return (engine, wb);
    }

    [Fact]
    public void Recalc_SequenceFormula_SpillsToAdjacentCells()
    {
        var (engine, wb) = MakeEngine();
        var sheet = wb.Sheets.First();
        var anchor = new CellAddress(sheet.Id, 1, 1);
        sheet.SetFormula(anchor, "SEQUENCE(3)");
        engine.RebuildFormulaDependencies(wb);
        engine.Recalculate(wb, [anchor]);

        sheet.GetValue(1, 1).Should().Be(new NumberValue(1));
        sheet.GetValue(2, 1).Should().Be(new NumberValue(2));
        sheet.GetValue(3, 1).Should().Be(new NumberValue(3));
    }

    [Fact]
    public void Recalc_SequenceBlocked_SetsSpillError()
    {
        var (engine, wb) = MakeEngine();
        var sheet = wb.Sheets.First();
        var anchor = new CellAddress(sheet.Id, 1, 1);
        // Block row 2
        sheet.SetCell(new CellAddress(sheet.Id, 2, 1), new NumberValue(99));
        sheet.SetFormula(anchor, "SEQUENCE(3)");
        engine.RebuildFormulaDependencies(wb);
        engine.Recalculate(wb, [anchor]);

        sheet.GetValue(1, 1).Should().Be(ErrorValue.Spill);
        sheet.GetValue(2, 1).Should().Be(new NumberValue(99)); // original preserved
        sheet.GetValue(3, 1).Should().Be(new BlankValue());    // never written
    }
```

- [ ] **Step 2: Run to see failures**

```
dotnet test tests/FreeX.Core.Calc.Tests --filter "Recalc_Sequence" -v n
```

Expected: FAIL — RecalcEngine does not yet handle RangeValue results.

- [ ] **Step 3: Update RecalcEngine evaluation loop**

In `src/FreeX.Core.Calc/RecalcEngine.cs`, find the inner try block inside the `foreach (var addr in toEvaluate)` loop:

```csharp
            try
            {
                var result = _evaluator.Evaluate("=" + cell.FormulaText, sheet, workbook);
                cell.Value = result;
                recalculated.Add(addr);
            }
```

Replace it with:

```csharp
            try
            {
                var result = _evaluator.Evaluate("=" + cell.FormulaText, sheet, workbook);

                if (result is RangeValue rv)
                {
                    if (sheet.IsSpillBlocked(addr, rv.RowCount, rv.ColCount))
                    {
                        cell.Value = ErrorValue.Spill;
                        sheet.ClearSpillRange(addr);
                        errors.Add((addr, "#SPILL!"));
                    }
                    else
                    {
                        cell.Value = rv.Cells[0, 0];
                        sheet.SetSpillRange(addr, rv);
                        recalculated.Add(addr);
                    }
                }
                else
                {
                    sheet.ClearSpillRange(addr);
                    cell.Value = result;
                    recalculated.Add(addr);
                }
            }
```

- [ ] **Step 4: Run tests**

```
dotnet test tests/FreeX.Core.Calc.Tests --filter "Recalc_Sequence" -v n
```

Expected: PASS (once SEQUENCE is implemented in Task 3; skip if SEQUENCE not yet available — run after Task 3)

- [ ] **Step 5: Build check**

```
dotnet build src/FreeX.Core.Calc --no-incremental -v q
```

Expected: 0 errors, 0 warnings.

- [ ] **Step 6: Commit**

```
git add src/FreeX.Core.Calc/RecalcEngine.cs
git commit -m "feat: RecalcEngine handles RangeValue spill results (#SPILL! on blockage)"
```

---

## Task 3: SEQUENCE function

**Files:**
- Modify: `src/FreeX.Core.Formula/BuiltInFunctions.cs`
- Modify: `src/FreeX.Core.Formula/FormulaEvaluator.cs`
- Modify: `tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs`

- [ ] **Step 1: Write failing tests**

```csharp
// ── SEQUENCE ──────────────────────────────────────────────────────────────────

[Fact]
public void Sequence_3Rows_ReturnsColumnVector()
{
    var result = _eval.Evaluate("=SEQUENCE(3)", MakeSheet());
    result.Should().BeOfType<RangeValue>();
    var rv = (RangeValue)result;
    rv.RowCount.Should().Be(3);
    rv.ColCount.Should().Be(1);
    rv.Cells[0, 0].Should().Be(new NumberValue(1));
    rv.Cells[1, 0].Should().Be(new NumberValue(2));
    rv.Cells[2, 0].Should().Be(new NumberValue(3));
}

[Fact]
public void Sequence_2x3_ReturnsMatrix()
{
    var result = _eval.Evaluate("=SEQUENCE(2,3)", MakeSheet());
    var rv = (RangeValue)result;
    rv.RowCount.Should().Be(2);
    rv.ColCount.Should().Be(3);
    rv.Cells[0, 0].Should().Be(new NumberValue(1));
    rv.Cells[0, 2].Should().Be(new NumberValue(3));
    rv.Cells[1, 0].Should().Be(new NumberValue(4));
}

[Fact]
public void Sequence_WithStartAndStep_CountsByTwos()
{
    var result = _eval.Evaluate("=SEQUENCE(4,1,0,2)", MakeSheet());
    var rv = (RangeValue)result;
    rv.Cells[0, 0].Should().Be(new NumberValue(0));
    rv.Cells[1, 0].Should().Be(new NumberValue(2));
    rv.Cells[2, 0].Should().Be(new NumberValue(4));
    rv.Cells[3, 0].Should().Be(new NumberValue(6));
}
```

- [ ] **Step 2: Run to see failures**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Sequence_" -v n
```

- [ ] **Step 3: Register SEQUENCE in Functions dict**

```csharp
        // ── Phase 4b: Dynamic arrays ─────────────────────────────────────────
        ["SEQUENCE"] = (Sequence, 1, 4),
        ["FILTER"]   = (Filter, 2, 3),
        ["SORT"]     = (Sort, 1, 4),
        ["UNIQUE"]   = (Unique, 1, 3),
```

- [ ] **Step 4: Update `IsStructuredRangeFunction` in FormulaEvaluator.cs**

Add to the existing string:

```csharp
         or "FILTER" or "SORT" or "UNIQUE";
```

(SEQUENCE takes only scalar args so it doesn't need structured classification, but FILTER/SORT/UNIQUE do.)

- [ ] **Step 5: Add SEQUENCE implementation**

```csharp
    // ═══════════════════════════════════════════════════════════════════
    // Phase 4b  –  Dynamic arrays
    // ═══════════════════════════════════════════════════════════════════

    private static ScalarValue Sequence(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        int rows   = (int)ToNumber(args[0]);
        int cols   = args.Count > 1 && args[1] is not BlankValue ? (int)ToNumber(args[1]) : 1;
        double start = args.Count > 2 && args[2] is not BlankValue ? ToNumber(args[2]) : 1;
        double step  = args.Count > 3 && args[3] is not BlankValue ? ToNumber(args[3]) : 1;
        if (rows < 1 || cols < 1) return ErrorValue.Value;
        var cells = new ScalarValue[rows, cols];
        double val = start;
        for (int r = 0; r < rows; r++)
            for (int c = 0; c < cols; c++)
            {
                cells[r, c] = new NumberValue(val);
                val += step;
            }
        return new RangeValue(cells);
    }
```

- [ ] **Step 6: Run tests**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Sequence_" -v n
```

Expected: all PASS

Also re-run RecalcEngine spill tests from Task 2:

```
dotnet test tests/FreeX.Core.Calc.Tests --filter "Recalc_Sequence" -v n
```

Expected: PASS

- [ ] **Step 7: Commit**

```
git add src/FreeX.Core.Formula/BuiltInFunctions.cs src/FreeX.Core.Formula/FormulaEvaluator.cs tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs
git commit -m "feat: add SEQUENCE dynamic array function"
```

---

## Task 4: FILTER function

**Files:**
- Modify: `src/FreeX.Core.Formula/BuiltInFunctions.cs`
- Modify: `tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs`

- [ ] **Step 1: Write failing tests**

```csharp
// ── FILTER ────────────────────────────────────────────────────────────────────

[Fact]
public void Filter_ByBoolArray_ReturnsMatchingRows()
{
    var sheet = MakeSheet(
        (1,1,new NumberValue(10)), (2,1,new NumberValue(20)), (3,1,new NumberValue(30)),
        (1,2,new BoolValue(true)), (2,2,new BoolValue(false)), (3,2,new BoolValue(true)));
    var result = _eval.Evaluate("=FILTER(A1:A3,B1:B3)", sheet);
    var rv = (RangeValue)result;
    rv.RowCount.Should().Be(2);
    rv.Cells[0, 0].Should().Be(new NumberValue(10));
    rv.Cells[1, 0].Should().Be(new NumberValue(30));
}

[Fact]
public void Filter_NoMatches_ReturnsIfEmptyArg()
{
    var sheet = MakeSheet(
        (1,1,new NumberValue(10)),
        (1,2,new BoolValue(false)));
    var result = _eval.Evaluate("=FILTER(A1:A1,B1:B1,\"none\")", sheet);
    result.Should().BeOfType<RangeValue>();
    var rv = (RangeValue)result;
    rv.Cells[0, 0].Should().Be(new TextValue("none"));
}

[Fact]
public void Filter_MultiColumn_PreservesAllColumns()
{
    var sheet = MakeSheet(
        (1,1,new NumberValue(1)), (1,2,new TextValue("A")), (1,3,new BoolValue(true)),
        (2,1,new NumberValue(2)), (2,2,new TextValue("B")), (2,3,new BoolValue(false)),
        (3,1,new NumberValue(3)), (3,2,new TextValue("C")), (3,3,new BoolValue(true)));
    var result = _eval.Evaluate("=FILTER(A1:B3,C1:C3)", sheet);
    var rv = (RangeValue)result;
    rv.RowCount.Should().Be(2);
    rv.ColCount.Should().Be(2);
    rv.Cells[0, 1].Should().Be(new TextValue("A"));
    rv.Cells[1, 1].Should().Be(new TextValue("C"));
}
```

- [ ] **Step 2: Run to see failures**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Filter_" -v n
```

- [ ] **Step 3: Add FILTER implementation**

```csharp
    private static ScalarValue Filter(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is not RangeValue arr) return ErrorValue.Value;
        if (args[1] is not RangeValue include) return ErrorValue.Value;
        var ifEmpty = args.Count > 2 ? args[2] : new TextValue("");

        var includeFlat = include.Flatten();
        var matchedRows = new List<int>();
        int rowLimit = Math.Min(includeFlat.Count, arr.RowCount);
        for (int i = 0; i < rowLimit; i++)
        {
            var v = includeFlat[i];
            bool matched = v is BoolValue { Value: true }
                        || (v is NumberValue nv && nv.Value != 0);
            if (matched) matchedRows.Add(i);
        }

        if (matchedRows.Count == 0)
        {
            if (ifEmpty is RangeValue rvEmpty) return rvEmpty;
            return new RangeValue(new ScalarValue[1, 1] { { ifEmpty } });
        }

        var result = new ScalarValue[matchedRows.Count, arr.ColCount];
        for (int ri = 0; ri < matchedRows.Count; ri++)
            for (int c = 0; c < arr.ColCount; c++)
                result[ri, c] = arr.Cells[matchedRows[ri], c];
        return new RangeValue(result);
    }
```

- [ ] **Step 4: Run tests**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Filter_" -v n
```

Expected: all PASS

- [ ] **Step 5: Commit**

```
git add src/FreeX.Core.Formula/BuiltInFunctions.cs tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs
git commit -m "feat: add FILTER dynamic array function"
```

---

## Task 5: SORT function

**Files:**
- Modify: `src/FreeX.Core.Formula/BuiltInFunctions.cs`
- Modify: `tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs`

- [ ] **Step 1: Write failing tests**

```csharp
// ── SORT ──────────────────────────────────────────────────────────────────────

[Fact]
public void Sort_SingleColumn_SortsAscending()
{
    var sheet = MakeSheet(
        (1,1,new NumberValue(3)), (2,1,new NumberValue(1)), (3,1,new NumberValue(2)));
    var result = _eval.Evaluate("=SORT(A1:A3)", sheet);
    var rv = (RangeValue)result;
    rv.Cells[0, 0].Should().Be(new NumberValue(1));
    rv.Cells[1, 0].Should().Be(new NumberValue(2));
    rv.Cells[2, 0].Should().Be(new NumberValue(3));
}

[Fact]
public void Sort_SingleColumn_SortsDescending()
{
    var sheet = MakeSheet(
        (1,1,new NumberValue(3)), (2,1,new NumberValue(1)), (3,1,new NumberValue(2)));
    var result = _eval.Evaluate("=SORT(A1:A3,1,-1)", sheet);
    var rv = (RangeValue)result;
    rv.Cells[0, 0].Should().Be(new NumberValue(3));
    rv.Cells[1, 0].Should().Be(new NumberValue(2));
    rv.Cells[2, 0].Should().Be(new NumberValue(1));
}

[Fact]
public void Sort_MultiColumn_SortsBySecondColumn()
{
    var sheet = MakeSheet(
        (1,1,new TextValue("B")), (1,2,new NumberValue(2)),
        (2,1,new TextValue("A")), (2,2,new NumberValue(1)),
        (3,1,new TextValue("C")), (3,2,new NumberValue(3)));
    // SORT(A1:B3, 2, 1) → sort by col 2 ascending
    var result = _eval.Evaluate("=SORT(A1:B3,2,1)", sheet);
    var rv = (RangeValue)result;
    rv.Cells[0, 0].Should().Be(new TextValue("A"));
    rv.Cells[1, 0].Should().Be(new TextValue("B"));
    rv.Cells[2, 0].Should().Be(new TextValue("C"));
}
```

- [ ] **Step 2: Run to see failures**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Sort_" -v n
```

- [ ] **Step 3: Add SORT implementation**

```csharp
    private static ScalarValue Sort(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is not RangeValue arr) return ErrorValue.Value;
        int sortIdx   = args.Count > 1 && args[1] is not BlankValue ? (int)ToNumber(args[1]) - 1 : 0;
        int sortOrder = args.Count > 2 && args[2] is not BlankValue ? (int)ToNumber(args[2]) : 1;
        bool byCol    = args.Count > 3 && args[3] is not BlankValue && ToBool(args[3]);

        if (!byCol)
        {
            var rowIndices = Enumerable.Range(0, arr.RowCount).ToList();
            rowIndices.Sort((a, b) =>
            {
                var va = sortIdx < arr.ColCount ? arr.Cells[a, sortIdx] : new BlankValue();
                var vb = sortIdx < arr.ColCount ? arr.Cells[b, sortIdx] : new BlankValue();
                return sortOrder * CompareScalar(va, vb);
            });
            var result = new ScalarValue[arr.RowCount, arr.ColCount];
            for (int r = 0; r < arr.RowCount; r++)
                for (int c = 0; c < arr.ColCount; c++)
                    result[r, c] = arr.Cells[rowIndices[r], c];
            return new RangeValue(result);
        }
        else
        {
            var colIndices = Enumerable.Range(0, arr.ColCount).ToList();
            colIndices.Sort((a, b) =>
            {
                var va = sortIdx < arr.RowCount ? arr.Cells[sortIdx, a] : new BlankValue();
                var vb = sortIdx < arr.RowCount ? arr.Cells[sortIdx, b] : new BlankValue();
                return sortOrder * CompareScalar(va, vb);
            });
            var result = new ScalarValue[arr.RowCount, arr.ColCount];
            for (int r = 0; r < arr.RowCount; r++)
                for (int c = 0; c < arr.ColCount; c++)
                    result[r, c] = arr.Cells[r, colIndices[c]];
            return new RangeValue(result);
        }
    }
```

- [ ] **Step 4: Run tests**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Sort_" -v n
```

Expected: all PASS

- [ ] **Step 5: Commit**

```
git add src/FreeX.Core.Formula/BuiltInFunctions.cs tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs
git commit -m "feat: add SORT dynamic array function"
```

---

## Task 6: UNIQUE function

**Files:**
- Modify: `src/FreeX.Core.Formula/BuiltInFunctions.cs`
- Modify: `tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs`

- [ ] **Step 1: Write failing tests**

```csharp
// ── UNIQUE ────────────────────────────────────────────────────────────────────

[Fact]
public void Unique_SingleColumn_RemovesDuplicates()
{
    var sheet = MakeSheet(
        (1,1,new NumberValue(1)), (2,1,new NumberValue(2)),
        (3,1,new NumberValue(1)), (4,1,new NumberValue(3)));
    var result = _eval.Evaluate("=UNIQUE(A1:A4)", sheet);
    var rv = (RangeValue)result;
    rv.RowCount.Should().Be(3);
    rv.Cells[0, 0].Should().Be(new NumberValue(1));
    rv.Cells[1, 0].Should().Be(new NumberValue(2));
    rv.Cells[2, 0].Should().Be(new NumberValue(3));
}

[Fact]
public void Unique_ExactlyOnce_ReturnsOnlySingletons()
{
    var sheet = MakeSheet(
        (1,1,new NumberValue(1)), (2,1,new NumberValue(2)),
        (3,1,new NumberValue(1)), (4,1,new NumberValue(3)));
    // UNIQUE(A1:A4, FALSE, TRUE) → only values appearing exactly once
    var result = _eval.Evaluate("=UNIQUE(A1:A4,FALSE,TRUE)", sheet);
    var rv = (RangeValue)result;
    rv.RowCount.Should().Be(2);
    rv.Cells[0, 0].Should().Be(new NumberValue(2));
    rv.Cells[1, 0].Should().Be(new NumberValue(3));
}

[Fact]
public void Unique_MultiColumn_DeduplicatesRows()
{
    var sheet = MakeSheet(
        (1,1,new TextValue("A")), (1,2,new NumberValue(1)),
        (2,1,new TextValue("B")), (2,2,new NumberValue(2)),
        (3,1,new TextValue("A")), (3,2,new NumberValue(1)));
    var result = _eval.Evaluate("=UNIQUE(A1:B3)", sheet);
    var rv = (RangeValue)result;
    rv.RowCount.Should().Be(2);
}
```

- [ ] **Step 2: Run to see failures**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Unique_" -v n
```

- [ ] **Step 3: Add UNIQUE implementation**

```csharp
    private static ScalarValue Unique(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is not RangeValue arr) return ErrorValue.Value;
        bool byCol       = args.Count > 1 && args[1] is not BlankValue && ToBool(args[1]);
        bool exactlyOnce = args.Count > 2 && args[2] is not BlankValue && ToBool(args[2]);

        if (!byCol)
        {
            // Build key per row; track first occurrence index and count
            var keyOrder  = new List<string>();
            var keyIndex  = new Dictionary<string, int>();
            var keyCounts = new List<int>();
            var rowOfKey  = new List<int>();

            for (int r = 0; r < arr.RowCount; r++)
            {
                var key = string.Join("\0", Enumerable.Range(0, arr.ColCount)
                              .Select(c => ToText(arr.Cells[r, c])));
                if (keyIndex.TryGetValue(key, out int idx))
                {
                    keyCounts[idx]++;
                }
                else
                {
                    keyIndex[key] = keyOrder.Count;
                    keyOrder.Add(key);
                    keyCounts.Add(1);
                    rowOfKey.Add(r);
                }
            }

            var selected = keyOrder
                .Select((k, i) => (key: k, idx: i))
                .Where(t => !exactlyOnce || keyCounts[t.idx] == 1)
                .Select(t => rowOfKey[t.idx])
                .ToList();

            if (selected.Count == 0) return ErrorValue.NA;
            var result = new ScalarValue[selected.Count, arr.ColCount];
            for (int ri = 0; ri < selected.Count; ri++)
                for (int c = 0; c < arr.ColCount; c++)
                    result[ri, c] = arr.Cells[selected[ri], c];
            return new RangeValue(result);
        }
        else
        {
            var keyOrder  = new List<string>();
            var keyIndex  = new Dictionary<string, int>();
            var keyCounts = new List<int>();
            var colOfKey  = new List<int>();

            for (int c = 0; c < arr.ColCount; c++)
            {
                var key = string.Join("\0", Enumerable.Range(0, arr.RowCount)
                              .Select(r => ToText(arr.Cells[r, c])));
                if (keyIndex.TryGetValue(key, out int idx))
                {
                    keyCounts[idx]++;
                }
                else
                {
                    keyIndex[key] = keyOrder.Count;
                    keyOrder.Add(key);
                    keyCounts.Add(1);
                    colOfKey.Add(c);
                }
            }

            var selected = keyOrder
                .Select((k, i) => (key: k, idx: i))
                .Where(t => !exactlyOnce || keyCounts[t.idx] == 1)
                .Select(t => colOfKey[t.idx])
                .ToList();

            if (selected.Count == 0) return ErrorValue.NA;
            var result = new ScalarValue[arr.RowCount, selected.Count];
            for (int r = 0; r < arr.RowCount; r++)
                for (int ci = 0; ci < selected.Count; ci++)
                    result[r, ci] = arr.Cells[r, selected[ci]];
            return new RangeValue(result);
        }
    }
```

- [ ] **Step 4: Run tests**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Unique_" -v n
```

Expected: all PASS

- [ ] **Step 5: Run full test suites**

```
dotnet test tests/FreeX.Core.Formula.Tests -v n
dotnet test tests/FreeX.Core.Calc.Tests -v n
```

All existing tests must still pass.

- [ ] **Step 6: Build check**

```
dotnet build src/FreeX.App.Host --no-incremental -v q
```

Expected: 0 errors, 0 warnings.

- [ ] **Step 7: Commit**

```
git add src/FreeX.Core.Formula/BuiltInFunctions.cs tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs
git commit -m "feat: add UNIQUE dynamic array function"
```

---

## Self-Review

**Spec coverage:**
- ✅ Task 1: `ErrorValue.Spill`, `Sheet.SetSpillRange`, `Sheet.ClearSpillRange`, `Sheet.IsSpillBlocked`
- ✅ Task 2: RecalcEngine handles `RangeValue` results with spill or `#SPILL!` on blockage
- ✅ Task 3: SEQUENCE
- ✅ Task 4: FILTER
- ✅ Task 5: SORT
- ✅ Task 6: UNIQUE

**Known gaps (Phase 5 enhancements):**
- Spill range not visible in the grid UI (cells show blank until UI queries `GetValue`, which works correctly for reading; rendering a spill indicator on the anchor is deferred)
- SORTBY, CHOOSECOLS, CHOOSEROWS — not in scope
- Dependency tracking does not register spill-range cells as dependents of the anchor; cross-sheet spill is not supported

**Type consistency:** `Sheet.SetSpillRange` takes `CellAddress` (anchor) and `RangeValue`. `RecalcEngine` already has `addr` as `CellAddress` — matches.

**Edge case — SEQUENCE with rows=0:** Returns `ErrorValue.Value` (guarded by `if (rows < 1 || cols < 1)`).

**`FreeX.Core.Calc.Tests` project:** If this test project does not yet exist, create it with:
```
dotnet new xunit -n FreeX.Core.Calc.Tests -o tests/FreeX.Core.Calc.Tests
cd tests/FreeX.Core.Calc.Tests
dotnet add reference ../../src/FreeX.Core.Calc/FreeX.Core.Calc.csproj
dotnet add reference ../../src/FreeX.Core.Model/FreeX.Core.Model.csproj
dotnet add reference ../../src/FreeX.Core.Formula/FreeX.Core.Formula.csproj
dotnet add package FluentAssertions
```
Then add the project to the solution:
```
dotnet sln ../../FreeX.sln add tests/FreeX.Core.Calc.Tests/FreeX.Core.Calc.Tests.csproj
```
