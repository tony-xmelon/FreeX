# Code Review Fixes Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix all issues identified in the comprehensive code review: 3 critical formula-engine bugs, the ApplyStyleCommand dictionary-bloat defect, 5 performance optimizations, 2 architecture improvements, 1 IO correctness fix, and a batch of minor cleanups — then expand the integration test suite.

**Architecture:** Changes are isolated by layer: formula-engine fixes touch only `FreeX.Core.Formula`; model/style fixes touch `FreeX.Core.Model` and `FreeX.Core.Commands`; viewport and recalc fixes touch `FreeX.Core.Calc`; IO fixes touch `FreeX.Core.IO`; minor fixes and tests touch several layers but never cross dependency boundaries.

**Tech Stack:** C# 13 / .NET 10, xUnit, FluentAssertions, ClosedXML, System.IO.Compression.

---

## Task 1: Fix IF/IFERROR/IFNA eager evaluation + SUM() zero-arg validation

**Files:**
- Modify: `src/FreeX.Core.Formula/FormulaEvaluator.cs`
- Test: `tests/FreeX.Core.Formula.Tests/FormulaEvaluatorTests.cs`

- [ ] **Step 1: Write failing tests**

Add to `FormulaEvaluatorTests.cs` — these must all fail before the fix:

```csharp
[Fact]
public void IF_ErrorInFalseBranch_DoesNotEvaluateFalseBranchWhenConditionIsTrue()
{
    var wb = new Workbook("T"); var sheet = wb.AddSheet("S");
    var evaluator = new FormulaEvaluator();
    // 1/0 in false branch must NOT be evaluated when condition is TRUE
    var result = evaluator.Evaluate("=IF(1>0,\"yes\",1/0)", sheet, wb);
    result.Should().Be(new TextValue("yes"));
}

[Fact]
public void IF_ErrorInTrueBranch_DoesNotEvaluateTrueBranchWhenConditionIsFalse()
{
    var wb = new Workbook("T"); var sheet = wb.AddSheet("S");
    var evaluator = new FormulaEvaluator();
    var result = evaluator.Evaluate("=IF(1>2,1/0,\"no\")", sheet, wb);
    result.Should().Be(new TextValue("no"));
}

[Fact]
public void IFERROR_DoesNotEvaluateFallback_WhenValueSucceeds()
{
    var wb = new Workbook("T"); var sheet = wb.AddSheet("S");
    var evaluator = new FormulaEvaluator();
    var result = evaluator.Evaluate("=IFERROR(42,1/0)", sheet, wb);
    result.Should().Be(new NumberValue(42));
}

[Fact]
public void IFERROR_ReturnsFallback_WhenValueErrors()
{
    var wb = new Workbook("T"); var sheet = wb.AddSheet("S");
    var evaluator = new FormulaEvaluator();
    var result = evaluator.Evaluate("=IFERROR(1/0,\"err\")", sheet, wb);
    result.Should().Be(new TextValue("err"));
}

[Fact]
public void IFNA_ReturnsFallback_OnlyForNA()
{
    var wb = new Workbook("T"); var sheet = wb.AddSheet("S");
    var evaluator = new FormulaEvaluator();
    evaluator.Evaluate("=IFNA(NA(),\"caught\")", sheet, wb)
        .Should().Be(new TextValue("caught"));
    evaluator.Evaluate("=IFNA(1/0,\"caught\")", sheet, wb)
        .Should().Be(ErrorValue.DivByZero, "IFNA should only catch #N/A, not other errors");
}

[Fact]
public void SUM_WithZeroArguments_ReturnsValueError()
{
    var wb = new Workbook("T"); var sheet = wb.AddSheet("S");
    var evaluator = new FormulaEvaluator();
    // SUM() with no arguments is a #VALUE! error in Excel
    var result = evaluator.Evaluate("=SUM()", sheet, wb);
    result.Should().Be(ErrorValue.Value);
}
```

- [ ] **Step 2: Run tests to verify they fail**

```
dotnet test tests/FreeX.Core.Formula.Tests/FreeX.Core.Formula.Tests.csproj --filter "IF_ErrorInFalseBranch|IF_ErrorInTrueBranch|IFERROR_DoesNotEvaluateFallback|IFERROR_ReturnsFallback|IFNA_ReturnsFallback|SUM_WithZeroArguments"
```

Expected: all 6 FAIL.

- [ ] **Step 3: Fix eager evaluation — add short-circuit dispatch before the arg-expansion loop in `EvaluateFunction`**

In `FormulaEvaluator.cs`, at the top of `EvaluateFunction` (after the `!BuiltInFunctions.Exists` check, before the `expandedArgs` list is created), add:

```csharp
// Short-circuit functions evaluate arguments lazily to avoid propagating errors from untaken branches.
if (node.FunctionName is "IF" or "IFERROR" or "IFNA")
    return EvaluateShortCircuit(node, context);
```

Then add the three private methods at the bottom of the class (before the nested `SheetEvalContext`):

```csharp
private ScalarValue EvaluateShortCircuit(FunctionCallNode node, IEvalContext context)
{
    return node.FunctionName switch
    {
        "IF"      => EvaluateIf(node, context),
        "IFERROR" => EvaluateIfError(node, context),
        "IFNA"    => EvaluateIfNa(node, context),
        _         => ErrorValue.Value
    };
}

private ScalarValue EvaluateIf(FunctionCallNode node, IEvalContext context)
{
    if (node.Arguments.Count is < 2 or > 3) return ErrorValue.Value;
    var cond = EvaluateNode(node.Arguments[0], context);
    if (cond is ErrorValue e) return e;
    bool taken = cond switch
    {
        BoolValue b   => b.Value,
        NumberValue n => n.Value != 0,
        _             => false
    };
    if (taken)  return EvaluateNode(node.Arguments[1], context);
    if (node.Arguments.Count == 3) return EvaluateNode(node.Arguments[2], context);
    return new BoolValue(false);
}

private ScalarValue EvaluateIfError(FunctionCallNode node, IEvalContext context)
{
    if (node.Arguments.Count != 2) return ErrorValue.Value;
    var value = EvaluateNode(node.Arguments[0], context);
    return value is ErrorValue ? EvaluateNode(node.Arguments[1], context) : value;
}

private ScalarValue EvaluateIfNa(FunctionCallNode node, IEvalContext context)
{
    if (node.Arguments.Count != 2) return ErrorValue.Value;
    var value = EvaluateNode(node.Arguments[0], context);
    return value == ErrorValue.NA ? EvaluateNode(node.Arguments[1], context) : value;
}
```

- [ ] **Step 4: Fix SUM() zero-arg validation**

In `EvaluateFunction`, replace the arg-count check block (the `if (node.Arguments.Count < minArgs || node.Arguments.Count > maxArgs)` block) with:

```csharp
// Always enforce minimum arg count for every function, including aggregates.
if (node.Arguments.Count < minArgs)
    return ErrorValue.Value;
// Enforce maximum only for non-aggregate functions (aggregates accept unbounded ranges).
if (!IsAggregateFunction(node.FunctionName) && node.Arguments.Count > maxArgs)
    return ErrorValue.Value;
```

- [ ] **Step 5: Run tests to verify all 6 pass**

```
dotnet test tests/FreeX.Core.Formula.Tests/FreeX.Core.Formula.Tests.csproj
```

Expected: all tests PASS.

- [ ] **Step 6: Commit**

```
git add src/FreeX.Core.Formula/FormulaEvaluator.cs tests/FreeX.Core.Formula.Tests/FormulaEvaluatorTests.cs
git commit -m "fix: IF/IFERROR/IFNA short-circuit evaluation and SUM() zero-arg validation"
```

---

## Task 2: CellAddress.Parse bounds validation + Lexer correctness fixes

**Files:**
- Modify: `src/FreeX.Core.Model/CellAddress.cs`
- Modify: `src/FreeX.Core.Formula/Lexer.cs`
- Test: `tests/FreeX.Core.Model.Tests/ModelTests.cs`
- Test: `tests/FreeX.Core.Formula.Tests/LexerTests.cs`

- [ ] **Step 1: Write failing tests**

In `ModelTests.cs`, add:

```csharp
[Fact]
public void CellAddress_Parse_ThrowsForRowZero()
{
    var sheet = SheetId.New();
    Action act = () => CellAddress.Parse("A0", sheet);
    act.Should().Throw<FormatException>("row 0 is below the valid range");
}

[Fact]
public void CellAddress_Parse_ThrowsForRowAboveMax()
{
    var sheet = SheetId.New();
    Action act = () => CellAddress.Parse("A1048577", sheet);
    act.Should().Throw<FormatException>("row 1048577 exceeds MaxRow");
}

[Fact]
public void CellAddress_Parse_ThrowsForColumnAboveMax()
{
    var sheet = SheetId.New();
    // XFE is column 16385, one past the maximum XFD (16384)
    Action act = () => CellAddress.Parse("XFE1", sheet);
    act.Should().Throw<FormatException>("column XFE exceeds MaxCol");
}
```

In `LexerTests.cs`, add:

```csharp
[Fact]
public void Lexer_TabWhitespace_IsSkippedLikespace()
{
    var tokens = new Lexer("=1\t+\t2").Tokenize();
    tokens.Select(t => t.Type).Should().Contain(TokenType.Number).And.Contain(TokenType.Plus);
}

[Fact]
public void Lexer_TruePlusDigits_IsNotACellReference()
{
    // "TRUE1" should be tokenized as a NamedRange, not a CellRef
    var tokens = new Lexer("=TRUE1").Tokenize();
    tokens.Should().ContainSingle(t => t.Type == TokenType.NamedRange && t.Value == "TRUE1");
}

[Fact]
public void Lexer_FourLetterColumnLikeWord_IsNotACellReference()
{
    // "ABCD1" has 4 letters — exceeds max column XFD (3 letters), should be NamedRange
    var tokens = new Lexer("=ABCD1").Tokenize();
    tokens.Should().ContainSingle(t => t.Type == TokenType.NamedRange);
}
```

- [ ] **Step 2: Run tests to verify they fail**

```
dotnet test tests/FreeX.Core.Model.Tests/FreeX.Core.Model.Tests.csproj --filter "CellAddress_Parse_Throws"
dotnet test tests/FreeX.Core.Formula.Tests/FreeX.Core.Formula.Tests.csproj --filter "Lexer_Tab|Lexer_TruePlus|Lexer_FourLetter"
```

Expected: all FAIL.

- [ ] **Step 3: Fix `CellAddress.Parse` to validate bounds**

Replace the `Parse` method body (lines 21–31 of `CellAddress.cs`) with:

```csharp
public static CellAddress Parse(string a1, SheetId sheet)
{
    var match = A1Regex().Match(a1.Trim());
    if (!match.Success)
        throw new FormatException($"Invalid A1 notation: '{a1}'");

    var col = ColumnNameToNumber(match.Groups[1].Value);
    if (!uint.TryParse(match.Groups[2].Value, out var row) || row == 0 || row > MaxRow || col == 0 || col > MaxCol)
        throw new FormatException($"Cell address '{a1}' is outside the valid range (A1:XFD1048576).");

    return new CellAddress(sheet, row, col);
}
```

- [ ] **Step 4: Fix `Lexer.IsCellReference` to reject column names > 3 characters**

Replace the `IsCellReference` method in `Lexer.cs` (lines 256–274):

```csharp
private static bool IsCellReference(string value)
{
    var clean = value.Replace("$", "").ToUpperInvariant();

    int i = 0;
    while (i < clean.Length && char.IsLetter(clean[i])) i++;

    // Column names can be at most 3 letters (A–XFD = columns 1–16384)
    if (i == 0 || i > 3 || i == clean.Length) return false;

    int digitStart = i;
    while (i < clean.Length && char.IsDigit(clean[i])) i++;

    return i == clean.Length && digitStart < clean.Length;
}
```

- [ ] **Step 5: Fix `Lexer.SkipWhitespace` to handle tabs**

Replace the `SkipWhitespace` method body (lines 312–316 of `Lexer.cs`):

```csharp
private void SkipWhitespace()
{
    while (_pos < _text.Length && char.IsWhiteSpace(_text[_pos]))
        _pos++;
}
```

- [ ] **Step 6: Run tests to verify all pass**

```
dotnet test tests/FreeX.Core.Model.Tests/FreeX.Core.Model.Tests.csproj --filter "CellAddress_Parse_Throws"
dotnet test tests/FreeX.Core.Formula.Tests/FreeX.Core.Formula.Tests.csproj
```

Expected: all PASS.

- [ ] **Step 7: Commit**

```
git add src/FreeX.Core.Model/CellAddress.cs src/FreeX.Core.Formula/Lexer.cs tests/FreeX.Core.Model.Tests/ModelTests.cs tests/FreeX.Core.Formula.Tests/LexerTests.cs
git commit -m "fix: CellAddress.Parse bounds check, Lexer tab whitespace, IsCellReference 3-letter column cap"
```

---

## Task 3: ApplyStyleCommand — style-only cells (no blank-cell materialisation)

The current `ApplyStyleCommand` creates a blank `Cell` for every styled empty address, bloating the sparse `_cells` dictionary. Fix: store style-only overrides in a separate `_styleOnly` dictionary on `Sheet`, and update `ViewportService` to render them.

**Files:**
- Modify: `src/FreeX.Core.Model/Sheet.cs`
- Modify: `src/FreeX.Core.Commands/ApplyStyleCommand.cs`
- Modify: `src/FreeX.Core.Calc/ViewportService.cs`
- Test: `tests/FreeX.Core.Model.Tests/ApplyStyleCommandTests.cs`
- Test: `tests/FreeX.Core.Calc.Tests/ViewportStyleTests.cs`

- [ ] **Step 1: Write a failing test that proves no blank cells are created**

In `ApplyStyleCommandTests.cs`, add:

```csharp
[Fact]
public void ApplyStyle_ToEmptyRange_DoesNotCreateBlankCells()
{
    var wb = new Workbook("T");
    var sheet = wb.AddSheet("S");
    var ctx = new TestCommandContext(wb, sheet);
    var range = new GridRange(
        new CellAddress(sheet.Id, 1, 1),
        new CellAddress(sheet.Id, 100, 26)); // 2600 empty cells

    var cmd = new ApplyStyleCommand(sheet.Id, range,
        new StyleDiff(FillColor: new CellColor(255, 0, 0)));
    cmd.Apply(ctx);

    sheet.CellCount.Should().Be(0,
        "styling empty cells must not materialise blank entries in the sparse cell dictionary");
}

[Fact]
public void ApplyStyle_ToEmptyRange_ThenUndo_LeavesNoTrace()
{
    var wb = new Workbook("T");
    var sheet = wb.AddSheet("S");
    var ctx = new TestCommandContext(wb, sheet);
    var addr = new CellAddress(sheet.Id, 1, 1);
    var range = new GridRange(addr, addr);

    var cmd = new ApplyStyleCommand(sheet.Id, range,
        new StyleDiff(FillColor: new CellColor(255, 0, 0)));
    cmd.Apply(ctx);
    cmd.Revert(ctx);

    sheet.CellCount.Should().Be(0);
    sheet.GetStyleOnly(1, 1).Should().BeNull("undo must remove the style-only entry");
}
```

- [ ] **Step 2: Run tests to verify they fail**

```
dotnet test tests/FreeX.Core.Model.Tests/FreeX.Core.Model.Tests.csproj --filter "ApplyStyle_ToEmptyRange"
```

Expected: FAIL.

- [ ] **Step 3: Add `_styleOnly` dictionary and accessor methods to `Sheet`**

In `Sheet.cs`, add the private field after `_spillAnchors`:

```csharp
private readonly Dictionary<(uint Row, uint Col), StyleId> _styleOnly = [];
```

Add these public methods after `GetMergeRegion`:

```csharp
/// <summary>Get the style override for a cell that has no content, or null if none.</summary>
public StyleId? GetStyleOnly(uint row, uint col)
    => _styleOnly.TryGetValue((row, col), out var s) ? s : null;

/// <summary>Record a style override for an address that has no cell content.</summary>
public void SetStyleOnly(uint row, uint col, StyleId styleId)
    => _styleOnly[(row, col)] = styleId;

/// <summary>Remove any style-only override at the given address.</summary>
public void ClearStyleOnly(uint row, uint col)
    => _styleOnly.Remove((row, col));

/// <summary>Enumerate all style-only overrides (address, styleId) pairs.</summary>
public IEnumerable<((uint Row, uint Col) Key, StyleId StyleId)> GetStyleOnlyEntries()
    => _styleOnly.Select(kv => (kv.Key, kv.Value));
```

Also update `SetCell(CellAddress, Cell)` to clear the style-only entry when real content arrives:

```csharp
public void SetCell(CellAddress address, Cell cell)
{
    _cells[(address.Row, address.Col)] = cell;
    _styleOnly.Remove((address.Row, address.Col)); // real cell supersedes style-only override
}
```

- [ ] **Step 4: Update `ApplyStyleCommand` to use style-only path for empty cells**

In `ApplyStyleCommand.Apply`, replace the block that creates blank cells:

```csharp
// OLD:
// if (cell is null)
// {
//     cell = Cell.FromValue(BlankValue.Instance);
//     sheet.SetCell(addr, cell);
// }

// NEW:
if (cell is null)
{
    var baseStyle = ctx.Workbook.GetStyle(StyleId.Default);
    var newStyle  = _diff.ApplyTo(baseStyle);
    var newStyleId = ctx.Workbook.RegisterStyle(newStyle);
    sheet.SetStyleOnly(addr.Row, addr.Col, newStyleId);
    continue; // skip the normal cell-update path below
}
```

The full updated `Apply` method:

```csharp
public CommandOutcome Apply(ICommandContext ctx)
{
    var sheet = ctx.GetSheet(_sheetId);
    if (CommandGuards.RejectIfProtected(sheet) is { } protectedOutcome)
        return protectedOutcome;
    if (StyleDiffValidator.Validate(_diff) is { } validationOutcome)
        return validationOutcome;

    _snapshot = [];

    foreach (var addr in _range.AllCells())
    {
        var cell = sheet.GetCell(addr);

        if (cell is null)
        {
            // Snapshot: record the old style-only value (may be null)
            _snapshot.Add((addr, null, sheet.GetStyleOnly(addr.Row, addr.Col)));

            var baseStyle  = ctx.Workbook.GetStyle(StyleId.Default);
            var newStyle   = _diff.ApplyTo(baseStyle);
            var newStyleId = ctx.Workbook.RegisterStyle(newStyle);
            sheet.SetStyleOnly(addr.Row, addr.Col, newStyleId);
        }
        else
        {
            _snapshot.Add((addr, cell.Clone(), null));

            var baseStyle = ctx.Workbook.GetStyle(cell.StyleId);
            var newStyle  = _diff.ApplyTo(baseStyle);
            cell.StyleId  = ctx.Workbook.RegisterStyle(newStyle);
        }
    }

    return new CommandOutcome(true);
}
```

Update the snapshot field type to carry the optional old style-only ID:

```csharp
// Change the field declaration from:
// private List<(CellAddress Address, Cell? OldCell)>? _snapshot;
// to:
private List<(CellAddress Address, Cell? OldCell, StyleId? OldStyleOnly)>? _snapshot;
```

Update `Revert`:

```csharp
public void Revert(ICommandContext ctx)
{
    if (_snapshot is null) return;
    var sheet = ctx.GetSheet(_sheetId);
    foreach (var (addr, oldCell, oldStyleOnly) in _snapshot)
    {
        if (oldCell is null)
        {
            // Was a style-only entry — restore or clear
            if (oldStyleOnly.HasValue)
                sheet.SetStyleOnly(addr.Row, addr.Col, oldStyleOnly.Value);
            else
                sheet.ClearStyleOnly(addr.Row, addr.Col);
        }
        else
        {
            sheet.SetCell(addr, oldCell.Clone());
        }
    }
}
```

- [ ] **Step 5: Update `ViewportService.GetViewport` to render style-only cells**

In `ViewportService.cs`, inside the nested `foreach (var rowMetric in rowMetrics)` / `foreach (var colMetric in colMetrics)` loop, add an `else` branch after the existing `if (cell != null)` block:

```csharp
var cell = sheet.GetCell(rowMetric.Row, colMetric.Col);
if (cell != null)
{
    // ... existing code ...
}
else
{
    var styleOnlyId = sheet.GetStyleOnly(rowMetric.Row, colMetric.Col);
    if (styleOnlyId.HasValue)
    {
        var style = workbook.GetStyle(styleOnlyId.Value);
        var addr  = new CellAddress(sheetId, rowMetric.Row, colMetric.Col);
        var cfStyle = EvaluateConditionalFormats(sheet, addr, BlankValue.Instance, workbook);
        if (cfStyle != null) style = MergeStyles(style, cfStyle);
        cells.Add(new DisplayCell(
            rowMetric.Row, colMetric.Col,
            BlankValue.Instance,
            "",
            null,
            styleOnlyId.Value,
            null,
            style));
    }
}
```

Apply the same change inside `BuildSplitPaneCells` if it has its own inner loop (check the method and mirror the same pattern).

- [ ] **Step 6: Run all affected tests**

```
dotnet test tests/FreeX.Core.Model.Tests/FreeX.Core.Model.Tests.csproj --filter "ApplyStyle"
dotnet test tests/FreeX.Core.Calc.Tests/FreeX.Core.Calc.Tests.csproj --filter "Viewport"
```

Expected: all PASS.

- [ ] **Step 7: Commit**

```
git add src/FreeX.Core.Model/Sheet.cs src/FreeX.Core.Commands/ApplyStyleCommand.cs src/FreeX.Core.Calc/ViewportService.cs tests/FreeX.Core.Model.Tests/ApplyStyleCommandTests.cs tests/FreeX.Core.Calc.Tests/ViewportStyleTests.cs
git commit -m "fix: ApplyStyleCommand uses style-only dictionary instead of materialising blank cells"
```

---

## Task 4: Workbook.RegisterStyle — O(1) hash-dictionary lookup

**Files:**
- Modify: `src/FreeX.Core.Model/Workbook.cs`
- Test: `tests/FreeX.Core.Model.Tests/ModelTests.cs`

- [ ] **Step 1: Write a failing performance/correctness test**

In `ModelTests.cs`:

```csharp
[Fact]
public void RegisterStyle_DuplicateStyle_ReturnsSameId()
{
    var wb = new Workbook("T");
    var s1 = new CellStyle { Bold = true };
    var s2 = new CellStyle { Bold = true }; // structurally equal, different instance
    var id1 = wb.RegisterStyle(s1);
    var id2 = wb.RegisterStyle(s2);
    id1.Should().Be(id2, "structurally identical styles should share a StyleId");
    wb.StyleCount.Should().Be(2, "one for Default plus one for Bold");
}

[Fact]
public void RegisterStyle_ManyDuplicates_DoesNotGrowRegistry()
{
    var wb = new Workbook("T");
    var bold = new CellStyle { Bold = true };
    for (int i = 0; i < 10_000; i++)
        wb.RegisterStyle(new CellStyle { Bold = true });
    wb.StyleCount.Should().Be(2, "10,000 identical bold styles collapse to one entry");
}
```

- [ ] **Step 2: Run tests to verify they pass (they should already pass for correctness, may be slow)**

```
dotnet test tests/FreeX.Core.Model.Tests/FreeX.Core.Model.Tests.csproj --filter "RegisterStyle"
```

Note: the `ManyDuplicates` test will be slow (O(n²)) before the fix and fast after.

- [ ] **Step 3: Add `_styleIndex` dictionary to `Workbook`**

In `Workbook.cs`, change the style storage fields from:

```csharp
private readonly List<CellStyle> _styles = [CellStyle.Default];
```

to:

```csharp
private readonly List<CellStyle> _styles = [CellStyle.Default];
private readonly Dictionary<CellStyle, int> _styleIndex = new() { [CellStyle.Default] = 0 };
```

Replace the `RegisterStyle` method:

```csharp
public StyleId RegisterStyle(CellStyle style)
{
    if (_styleIndex.TryGetValue(style, out var idx))
        return new StyleId(idx);

    var clone = style.Clone();
    var newIdx = _styles.Count;
    _styles.Add(clone);
    _styleIndex[clone] = newIdx;
    return new StyleId(newIdx);
}
```

- [ ] **Step 4: Run all model tests**

```
dotnet test tests/FreeX.Core.Model.Tests/FreeX.Core.Model.Tests.csproj
```

Expected: all PASS, `ManyDuplicates` runs in < 100 ms.

- [ ] **Step 5: Commit**

```
git add src/FreeX.Core.Model/Workbook.cs tests/FreeX.Core.Model.Tests/ModelTests.cs
git commit -m "perf: Workbook.RegisterStyle uses O(1) hash lookup instead of O(n) linear scan"
```

---

## Task 5: Sheet.GetMergeRegion — lazy index for O(1) lookup

**Files:**
- Modify: `src/FreeX.Core.Model/Sheet.cs`
- Test: `tests/FreeX.Core.Model.Tests/ModelTests.cs`

- [ ] **Step 1: Write a test that documents the O(1) behaviour**

In `ModelTests.cs`:

```csharp
[Fact]
public void GetMergeRegion_FindsMergeInLargeList()
{
    var wb = new Workbook("T");
    var sheet = wb.AddSheet("S");
    // Add 500 merge regions
    for (uint r = 1; r <= 500; r++)
    {
        var start = new CellAddress(sheet.Id, r * 2, 1);
        var end   = new CellAddress(sheet.Id, r * 2, 2);
        sheet.MergedRegions.Add(new GridRange(start, end));
        sheet.InvalidateMergeIndex();
    }
    var target = new CellAddress(sheet.Id, 500, 1);
    var found  = sheet.GetMergeRegion(target);
    found.Should().NotBeNull("cell at row 500 col 1 is inside the last merge region");
    found!.Value.Start.Row.Should().Be(500);
}
```

- [ ] **Step 2: Run test (should pass with current code but confirm)**

```
dotnet test tests/FreeX.Core.Model.Tests/FreeX.Core.Model.Tests.csproj --filter "GetMergeRegion_Finds"
```

- [ ] **Step 3: Add lazy index to `Sheet`**

In `Sheet.cs`, add the private nullable index field after `_styleOnly`:

```csharp
private Dictionary<(uint Row, uint Col), GridRange>? _mergeIndex;
```

Add the index maintenance methods after `GetStyleOnlyEntries()`:

```csharp
/// <summary>Invalidate the merge-region lookup index. Call after any mutation to MergedRegions.</summary>
public void InvalidateMergeIndex() => _mergeIndex = null;

private void EnsureMergeIndex()
{
    if (_mergeIndex is not null) return;
    _mergeIndex = new Dictionary<(uint, uint), GridRange>(MergedRegions.Count * 4);
    foreach (var region in MergedRegions)
        for (var r = region.Start.Row; r <= region.End.Row; r++)
            for (var c = region.Start.Col; c <= region.End.Col; c++)
                _mergeIndex[(r, c)] = region;
}
```

Replace `GetMergeRegion` and `IsMerged`:

```csharp
public GridRange? GetMergeRegion(CellAddress addr)
{
    EnsureMergeIndex();
    return _mergeIndex!.TryGetValue((addr.Row, addr.Col), out var r) ? r : null;
}

public bool IsMerged(CellAddress addr) => GetMergeRegion(addr) is not null;
```

- [ ] **Step 4: Grep for all `MergedRegions.Add`, `.Remove`, `.Clear` call sites and add `InvalidateMergeIndex()` after each**

Run:
```
grep -rn "MergedRegions\.\(Add\|Remove\|Clear\)" src/ tests/
```

For each found location, add `sheet.InvalidateMergeIndex();` (or `copy.InvalidateMergeIndex();`) immediately after the mutation. Key locations expected:
- `Commands.cs` — `CloneSheet` body (line ~384: `copy.MergedRegions.Add(...)`)
- `MergeCellsCommand.cs` — when adding/removing merges
- `XlsxFileAdapter.cs` — when loading merges from XLSX

- [ ] **Step 5: Run all tests**

```
dotnet test tests/FreeX.Core.Model.Tests/FreeX.Core.Model.Tests.csproj
dotnet test tests/FreeX.Core.Calc.Tests/FreeX.Core.Calc.Tests.csproj
```

Expected: all PASS.

- [ ] **Step 6: Commit**

```
git add src/FreeX.Core.Model/Sheet.cs src/FreeX.Core.Commands/MergeCellsCommand.cs src/FreeX.Core.Commands/Commands.cs src/FreeX.Core.IO/XlsxFileAdapter.cs
git commit -m "perf: Sheet.GetMergeRegion uses lazy O(1) index instead of O(n) linear scan per call"
```

---

## Task 6: Cell AST caching — eliminate re-parse on every recalc

**Files:**
- Modify: `src/FreeX.Core.Model/Cell.cs`
- Modify: `src/FreeX.Core.Calc/RecalcEngine.cs`
- Test: `tests/FreeX.Core.Calc.Tests/DependencyGraphTests.cs`

- [ ] **Step 1: Write a correctness test (AST cache must be invalidated when formula changes)**

In `DependencyGraphTests.cs` (or a new `RecalcEngineTests.cs`):

```csharp
[Fact]
public void RecalcEngine_FormulaChange_UsesNewAstNotCached()
{
    var wb = new Workbook("T");
    var sheet = wb.AddSheet("S");
    var graph = new DependencyGraph();
    var engine = new RecalcEngine(graph, new FormulaEvaluator());

    var a1 = new CellAddress(sheet.Id, 1, 1);
    sheet.SetCell(a1, new NumberValue(5));

    var b1 = new CellAddress(sheet.Id, 1, 2);
    sheet.SetFormula(b1, "A1*2");
    engine.RebuildFormulaDependencies(wb);
    engine.Recalculate(wb, [a1]);
    sheet.GetValue(b1).Should().Be(new NumberValue(10));

    // Change the formula
    sheet.SetFormula(b1, "A1*3");
    engine.RebuildFormulaDependencies(wb);
    engine.Recalculate(wb, [a1]);
    sheet.GetValue(b1).Should().Be(new NumberValue(15),
        "after formula change the cached AST must be invalidated");
}
```

- [ ] **Step 2: Run test to verify it currently passes (it should — caching should not break correctness)**

```
dotnet test tests/FreeX.Core.Calc.Tests/FreeX.Core.Calc.Tests.csproj --filter "RecalcEngine_FormulaChange"
```

- [ ] **Step 3: Add `CachedAst` property to `Cell` with auto-clearing setter**

In `Cell.cs`, replace the auto-property `FormulaText` with a manual backing field and add `CachedAst`:

```csharp
private string? _formulaText;

/// <summary>
/// The formula text (without leading '='), or null if this cell has a literal value.
/// Setting this property clears the cached AST so the next recalc re-parses.
/// </summary>
public string? FormulaText
{
    get => _formulaText;
    set { _formulaText = value; CachedAst = null; }
}

/// <summary>Pre-parsed AST, cached after first recalc. Cleared whenever FormulaText changes.</summary>
internal FormulaNode? CachedAst { get; set; }
```

Also update `Clone()` to NOT copy the cached AST (it must re-parse in the new context):

```csharp
public Cell Clone() => new()
{
    Value             = Value,
    FormulaText       = FormulaText,   // setter clears CachedAst on the clone
    IgnoreFormulaError = IgnoreFormulaError,
    StyleId           = StyleId
};
```

- [ ] **Step 4: Update `RecalcEngine.Recalculate` to use cached AST**

In `RecalcEngine.cs`, find the line inside the `foreach (var addr in toEvaluate)` loop:

```csharp
var result = _evaluator.Evaluate("=" + cell.FormulaText, sheet, workbook);
```

Replace it with:

```csharp
if (cell.CachedAst is null)
    cell.CachedAst = new Parser(new Lexer("=" + cell.FormulaText).Tokenize()).Parse();
var result = _evaluator.Evaluate(cell.CachedAst, sheet, workbook);
```

Add the required using at the top of `RecalcEngine.cs` (if not already present):
`using FreeX.Core.Formula;`

- [ ] **Step 5: Run all tests**

```
dotnet test tests/FreeX.Core.Calc.Tests/FreeX.Core.Calc.Tests.csproj
dotnet test tests/FreeX.Core.Formula.Tests/FreeX.Core.Formula.Tests.csproj
```

Expected: all PASS.

- [ ] **Step 6: Commit**

```
git add src/FreeX.Core.Model/Cell.cs src/FreeX.Core.Calc/RecalcEngine.cs
git commit -m "perf: cache parsed formula AST on Cell to eliminate re-parse on every recalc pass"
```

---

## Task 7: ViewportService — pre-compute CF aggregates once per frame

**Files:**
- Modify: `src/FreeX.Core.Calc/ViewportService.cs`
- Test: `tests/FreeX.Core.Calc.Tests/ViewportStyleTests.cs`

- [ ] **Step 1: Write a test that verifies CF colours are still correct after refactor**

In `ViewportStyleTests.cs`, add (or verify existing tests cover):

```csharp
[Fact]
public void GetViewport_AboveAverageCF_HighlightsCellsAboveAverage()
{
    var wb = new Workbook("T");
    var sheet = wb.AddSheet("S");
    var sheetId = sheet.Id;

    sheet.SetCell(new CellAddress(sheetId, 1, 1), new NumberValue(10));
    sheet.SetCell(new CellAddress(sheetId, 2, 1), new NumberValue(20));
    sheet.SetCell(new CellAddress(sheetId, 3, 1), new NumberValue(30));

    var cf = new ConditionalFormat
    {
        AppliesTo   = new GridRange(new CellAddress(sheetId, 1, 1), new CellAddress(sheetId, 3, 1)),
        RuleType    = CfRuleType.AboveAverage,
        AboveAverage = true,
        FormatIfTrue = new CellStyle { Bold = true }
    };
    sheet.ConditionalFormats.Add(cf);

    var svc     = new ViewportService();
    var request = new ViewportRequest(1, 1, 500, 500);
    var vp      = svc.GetViewport(wb, sheetId, request);

    var cell30  = vp.Cells.Single(c => c.Row == 3 && c.Col == 1);
    cell30.Style.Bold.Should().BeTrue("30 is above average (20), so CF should apply");
    var cell10  = vp.Cells.Single(c => c.Row == 1 && c.Col == 1);
    cell10.Style.Bold.Should().BeFalse("10 is below average, CF should not apply");
}
```

- [ ] **Step 2: Run test to confirm it passes before refactor**

```
dotnet test tests/FreeX.Core.Calc.Tests/FreeX.Core.Calc.Tests.csproj --filter "AboveAverageCF"
```

- [ ] **Step 3: Add `CfAggregateCache` record and `PrecomputeCfAggregates` to `ViewportService`**

In `ViewportService.cs`, add a private sealed record and a helper method before `EvaluateConditionalFormats`:

```csharp
private sealed record CfAggregateCache(double Average, double Min, double Max);

private static Dictionary<ConditionalFormat, CfAggregateCache> PrecomputeCfAggregates(Sheet sheet)
{
    var result = new Dictionary<ConditionalFormat, CfAggregateCache>(ReferenceEqualityComparer.Instance);
    foreach (var cf in sheet.ConditionalFormats)
    {
        if (cf.RuleType is not (CfRuleType.AboveAverage or CfRuleType.ColorScale))
            continue;

        double sum = 0, min = double.MaxValue, max = double.MinValue;
        int count = 0;
        foreach (var a in cf.AppliesTo.AllCells())
        {
            var v = sheet.GetValue(a);
            if (!TryGetDouble(v, out double x)) continue;
            sum += x;
            if (x < min) min = x;
            if (x > max) max = x;
            count++;
        }
        if (count > 0)
            result[cf] = new CfAggregateCache(sum / count, min, max);
    }
    return result;
}
```

- [ ] **Step 4: Thread the cache through `GetViewport` and update the two consuming methods**

At the top of `GetViewport`, before the `foreach (var rowMetric in rowMetrics)` loop, add:

```csharp
var cfCache = PrecomputeCfAggregates(sheet);
```

Change the `EvaluateConditionalFormats` call signature from:

```csharp
private static CellStyle? EvaluateConditionalFormats(Sheet sheet, CellAddress addr, ScalarValue value, Workbook workbook)
```

to:

```csharp
private static CellStyle? EvaluateConditionalFormats(
    Sheet sheet, CellAddress addr, ScalarValue value, Workbook workbook,
    Dictionary<ConditionalFormat, CfAggregateCache> cfCache)
```

Update all call sites to pass `cfCache`.

In `MatchesAboveAverage`, replace the in-method sum/count loop with:

```csharp
private static bool MatchesAboveAverage(
    ConditionalFormat cf, CellAddress addr, ScalarValue value,
    Dictionary<ConditionalFormat, CfAggregateCache> cfCache)
{
    if (!TryGetDouble(value, out double cellVal)) return false;
    if (!cfCache.TryGetValue(cf, out var cache)) return false;
    return cf.AboveAverage ? cellVal > cache.Average : cellVal < cache.Average;
}
```

In `ComputeColorScaleStyle`, replace the in-method `nums.Min()`/`nums.Max()` with:

```csharp
private static CellStyle? ComputeColorScaleStyle(
    ConditionalFormat cf, CellAddress addr, ScalarValue value,
    Dictionary<ConditionalFormat, CfAggregateCache> cfCache)
{
    if (!TryGetDouble(value, out double cellVal)) return null;
    if (!cfCache.TryGetValue(cf, out var cache)) return null;
    double min = cache.Min, max = cache.Max;
    if (max == min) return new CellStyle { FillColor = cf.MinColor.ToCellColor() };

    double t = (cellVal - min) / (max - min);
    // ... rest of interpolation unchanged ...
}
```

- [ ] **Step 5: Run tests**

```
dotnet test tests/FreeX.Core.Calc.Tests/FreeX.Core.Calc.Tests.csproj
```

Expected: all PASS.

- [ ] **Step 6: Commit**

```
git add src/FreeX.Core.Calc/ViewportService.cs tests/FreeX.Core.Calc.Tests/ViewportStyleTests.cs
git commit -m "perf: ViewportService pre-computes CF aggregates once per frame instead of per-cell"
```

---

## Task 8: ViewportService HitTest — O(1) fast path for uniform row/column heights

**Files:**
- Modify: `src/FreeX.Core.Calc/ViewportService.cs`
- Test: `tests/FreeX.Core.Calc.Tests/ViewportLayoutTests.cs`

- [ ] **Step 1: Write tests that verify HitTest returns correct results for scrolled sheets**

In `ViewportLayoutTests.cs`, add:

```csharp
[Fact]
public void HitTest_UniformRowHeights_ScrolledDown_ReturnsCorrectRow()
{
    var wb = new Workbook("T");
    var sheet = wb.AddSheet("S");
    // Default row height is 20px. Clicking at y=1980 (no zoom) should hit row 99.
    var svc    = new ViewportService();
    var result = svc.HitTest(wb, sheet.Id, 35, 1980, 1.0); // x past header width
    result.Should().NotBeNull();
    result!.Value.Row.Should().Be(99);
}
```

- [ ] **Step 2: Run to verify it currently passes**

```
dotnet test tests/FreeX.Core.Calc.Tests/FreeX.Core.Calc.Tests.csproj --filter "HitTest_Uniform"
```

- [ ] **Step 3: Add fast-path logic to `HitTestRow` and `HitTestColumn`**

In `ViewportService.cs`, replace `HitTestRow`:

```csharp
private static uint? HitTestRow(Sheet sheet, double y)
{
    // Fast path: no custom row heights or hidden rows — use direct arithmetic.
    if (sheet.RowHeights.Count == 0 && sheet.HiddenRows.Count == 0 &&
        sheet.FilterHiddenRows.Count == 0 && sheet.GroupHiddenRows.Count == 0)
    {
        if (sheet.DefaultRowHeight <= 0) return null;
        var row = (uint)(y / sheet.DefaultRowHeight) + 1;
        return row <= CellAddress.MaxRow ? row : null;
    }

    // Slow path: iterate with custom heights / hidden rows.
    double top = 0;
    for (uint row = 1; row <= CellAddress.MaxRow; row++)
    {
        if (IsRowHidden(sheet, row)) continue;
        var height = sheet.RowHeights.GetValueOrDefault(row, sheet.DefaultRowHeight);
        if (y < top + height) return row;
        top += height;
        if (top > y + sheet.DefaultRowHeight * 1000) return null; // past any reasonable viewport
    }
    return null;
}
```

Apply the same pattern to `HitTestColumn`:

```csharp
private static uint? HitTestColumn(Sheet sheet, double x)
{
    if (sheet.ColumnWidths.Count == 0 && sheet.HiddenCols.Count == 0 &&
        sheet.GroupHiddenCols.Count == 0)
    {
        if (sheet.DefaultColumnWidth <= 0) return null;
        // DefaultColumnWidth is in characters; ViewportService uses pixels elsewhere.
        // Treat it as pixels here (consistent with BuildColMetrics).
        var col = (uint)(x / sheet.DefaultColumnWidth) + 1;
        return col <= CellAddress.MaxCol ? col : null;
    }

    double left = 0;
    for (uint col = 1; col <= CellAddress.MaxCol; col++)
    {
        if (sheet.IsColEffectivelyHidden(col)) continue;
        var width = sheet.ColumnWidths.GetValueOrDefault(col, sheet.DefaultColumnWidth);
        if (x < left + width) return col;
        left += width;
        if (left > x + sheet.DefaultColumnWidth * 1000) return null;
    }
    return null;
}
```

- [ ] **Step 4: Run all layout tests**

```
dotnet test tests/FreeX.Core.Calc.Tests/FreeX.Core.Calc.Tests.csproj
```

Expected: all PASS.

- [ ] **Step 5: Commit**

```
git add src/FreeX.Core.Calc/ViewportService.cs tests/FreeX.Core.Calc.Tests/ViewportLayoutTests.cs
git commit -m "perf: ViewportService HitTest fast path for sheets with uniform row/column sizes"
```

---

## Task 9: Sheet.Clone() — move CloneSheet from Commands to model, fix missing fields

`DuplicateSheetCommand.CloneSheet` misses `BackgroundImage`, `RowOutlineLevels`, `ColOutlineLevels`, `GroupHiddenRows`, and `GroupHiddenCols`. Moving the method to `Sheet.Clone` also makes future regressions self-evident.

**Files:**
- Modify: `src/FreeX.Core.Model/Sheet.cs`
- Modify: `src/FreeX.Core.Commands/Commands.cs`
- Test: `tests/FreeX.Core.Model.Tests/ModelTests.cs`

- [ ] **Step 1: Write tests for the missing fields**

In `ModelTests.cs`:

```csharp
[Fact]
public void Sheet_Clone_CopiesBackgroundImage()
{
    var wb = new Workbook("T");
    var src = wb.AddSheet("S");
    src.BackgroundImage = new WorksheetBackgroundImage(new byte[] { 1, 2, 3 }, "image/png");
    var copy = src.Clone(SheetId.New(), "Copy");
    copy.BackgroundImage.Should().NotBeNull();
    copy.BackgroundImage!.ImageBytes.Should().Equal(new byte[] { 1, 2, 3 });
}

[Fact]
public void Sheet_Clone_CopiesOutlineLevels()
{
    var wb = new Workbook("T");
    var src = wb.AddSheet("S");
    src.RowOutlineLevels[5] = 2;
    src.ColOutlineLevels[3] = 1;
    src.GroupHiddenRows.Add(5);
    src.GroupHiddenCols.Add(3);
    var copy = src.Clone(SheetId.New(), "Copy");
    copy.RowOutlineLevels.Should().ContainKey(5).WhoseValue.Should().Be(2);
    copy.ColOutlineLevels.Should().ContainKey(3).WhoseValue.Should().Be(1);
    copy.GroupHiddenRows.Should().Contain(5u);
    copy.GroupHiddenCols.Should().Contain(3u);
}
```

- [ ] **Step 2: Run tests to verify they fail**

```
dotnet test tests/FreeX.Core.Model.Tests/FreeX.Core.Model.Tests.csproj --filter "Sheet_Clone"
```

Expected: fail (method doesn't exist yet).

- [ ] **Step 3: Add `Sheet.Clone(SheetId, string)` to `Sheet.cs`**

At the bottom of `Sheet.cs`, before the `WorksheetViewMode` enum, add:

```csharp
/// <summary>
/// Create a deep copy of this sheet with a new id and name.
/// All cells, styles, charts, CFs, outline levels, and background image are copied.
/// </summary>
public Sheet Clone(SheetId newId, string newName)
{
    var copy = new Sheet(newId, newName)
    {
        DefaultColumnWidth  = DefaultColumnWidth,
        DefaultRowHeight    = DefaultRowHeight,
        FrozenRows          = FrozenRows,
        FrozenCols          = FrozenCols,
        SplitRow            = SplitRow,
        SplitColumn         = SplitColumn,
        ShowGridlines       = ShowGridlines,
        ShowHeadings        = ShowHeadings,
        ShowRulers          = ShowRulers,
        ZoomPercent         = ZoomPercent,
        ShowFormulas        = ShowFormulas,
        PrintArea           = PrintArea.HasValue ? RemapRange(PrintArea.Value, newId) : null,
        PageOrientation     = PageOrientation,
        PaperSize           = PaperSize,
        PageMargins         = PageMargins,
        HeaderMargin        = HeaderMargin,
        FooterMargin        = FooterMargin,
        PrintGridlines      = PrintGridlines,
        PrintHeadings       = PrintHeadings,
        ScaleToFit          = ScaleToFit,
        PrintTitleRows      = PrintTitleRows,
        PrintTitleColumns   = PrintTitleColumns,
        PageHeader          = PageHeader,
        PageFooter          = PageFooter,
        FirstPageHeader     = FirstPageHeader,
        FirstPageFooter     = FirstPageFooter,
        EvenPageHeader      = EvenPageHeader,
        EvenPageFooter      = EvenPageFooter,
        DifferentFirstPageHeaderFooter  = DifferentFirstPageHeaderFooter,
        DifferentOddEvenHeaderFooter    = DifferentOddEvenHeaderFooter,
        HeaderFooterScaleWithDocument   = HeaderFooterScaleWithDocument,
        HeaderFooterAlignWithMargins    = HeaderFooterAlignWithMargins,
        CenterHorizontallyOnPage = CenterHorizontallyOnPage,
        CenterVerticallyOnPage   = CenterVerticallyOnPage,
        PageOrder            = PageOrder,
        FirstPageNumber      = FirstPageNumber,
        PrintBlackAndWhite   = PrintBlackAndWhite,
        PrintDraftQuality    = PrintDraftQuality,
        PrintQualityDpi      = PrintQualityDpi,
        PrintErrorValue      = PrintErrorValue,
        PrintComments        = PrintComments,
        ViewMode             = ViewMode,
        IsHidden             = false,
        TabColor             = TabColor,
        IsProtected          = IsProtected,
        ProtectionPassword   = ProtectionPassword,
        BackgroundImage      = BackgroundImage is null ? null
            : new WorksheetBackgroundImage(BackgroundImage.ImageBytes?.ToArray(), BackgroundImage.ContentType),
    };

    foreach (var (col, width)   in ColumnWidths)         copy.ColumnWidths[col]          = width;
    foreach (var (row, height)  in RowHeights)            copy.RowHeights[row]            = height;
    foreach (var (row, level)   in RowOutlineLevels)      copy.RowOutlineLevels[row]      = level;
    foreach (var (col, level)   in ColOutlineLevels)      copy.ColOutlineLevels[col]      = level;
    foreach (var row            in HiddenRows)             copy.HiddenRows.Add(row);
    foreach (var row            in FilterHiddenRows)       copy.FilterHiddenRows.Add(row);
    foreach (var row            in GroupHiddenRows)        copy.GroupHiddenRows.Add(row);
    foreach (var col            in HiddenCols)             copy.HiddenCols.Add(col);
    foreach (var col            in GroupHiddenCols)        copy.GroupHiddenCols.Add(col);
    foreach (var rowBreak       in RowPageBreaks)          copy.RowPageBreaks.Add(rowBreak);
    foreach (var colBreak       in ColumnPageBreaks)       copy.ColumnPageBreaks.Add(colBreak);

    foreach (var (address, cell) in EnumerateCells())
        copy.SetCell(RemapAddress(address, newId), cell.Clone());

    foreach (var region         in MergedRegions)  { copy.MergedRegions.Add(RemapRange(region, newId)); copy.InvalidateMergeIndex(); }
    foreach (var (addr, comment) in Comments)      copy.Comments[RemapAddress(addr, newId)]    = comment;
    foreach (var (addr, link)    in Hyperlinks)    copy.Hyperlinks[RemapAddress(addr, newId)]  = link;
    foreach (var range           in AllowEditRanges) copy.AllowEditRanges.Add(RemapRange(range, newId));

    foreach (var cf in ConditionalFormats)
        copy.ConditionalFormats.Add(new ConditionalFormat
        {
            AppliesTo        = RemapRange(cf.AppliesTo, newId),
            Priority         = cf.Priority,
            RuleType         = cf.RuleType,
            Operator         = cf.Operator,
            Value1           = cf.Value1,
            Value2           = cf.Value2,
            FormatIfTrue     = cf.FormatIfTrue?.Clone(),
            MinColor         = cf.MinColor,
            MidColor         = cf.MidColor,
            MaxColor         = cf.MaxColor,
            UseThreeColorScale = cf.UseThreeColorScale,
            DataBarColor     = cf.DataBarColor,
            AboveAverage     = cf.AboveAverage
        });

    foreach (var dv in DataValidations)
        copy.DataValidations.Add(new DataValidation
        {
            AppliesTo    = RemapRange(dv.AppliesTo, newId),
            Type         = dv.Type,
            Operator     = dv.Operator,
            Formula1     = dv.Formula1,
            Formula2     = dv.Formula2,
            AllowBlank   = dv.AllowBlank,
            ShowDropdown = dv.ShowDropdown,
            ErrorTitle   = dv.ErrorTitle,
            ErrorMessage = dv.ErrorMessage,
            PromptTitle  = dv.PromptTitle,
            PromptMessage = dv.PromptMessage
        });

    // Charts, text boxes, shapes, pictures, sparklines — delegated to Commands layer helpers.
    // (These involve types only known to Core.Commands; call those helpers from DuplicateSheetCommand.)

    return copy;

    static CellAddress RemapAddress(CellAddress a, SheetId id) => new(id, a.Row, a.Col);
    static GridRange   RemapRange  (GridRange   r, SheetId id) =>
        new(new CellAddress(id, r.Start.Row, r.Start.Col), new CellAddress(id, r.End.Row, r.End.Col));
}
```

Note: charts, text boxes, shapes, pictures, and sparklines contain types only visible in `Core.Commands` (they reference things like `CloneChart`), so `DuplicateSheetCommand.Apply` still copies them — but now uses `source.Clone(copyId, name)` first and then appends those collections.

- [ ] **Step 4: Update `DuplicateSheetCommand` to delegate to `Sheet.Clone` then copy remaining collections**

In `Commands.cs`, replace `CloneSheet(source, copyId, name)` call in `Apply` with:

```csharp
var copy = source.Clone(copyId, name);
// Append chart/shape/picture/sparkline collections (types only known in this layer):
foreach (var chart in source.Charts)
    copy.Charts.Add(CloneChart(chart, copyId));
foreach (var tb in source.TextBoxes)
    copy.TextBoxes.Add(new TextBoxModel { Anchor = new CellAddress(copyId, tb.Anchor.Row, tb.Anchor.Col), Text = tb.Text, Width = tb.Width, Height = tb.Height, RotationDegrees = tb.RotationDegrees, FillColor = tb.FillColor, OutlineColor = tb.OutlineColor, AltText = tb.AltText });
foreach (var shape in source.DrawingShapes)
    copy.DrawingShapes.Add(new DrawingShapeModel { Anchor = new CellAddress(copyId, shape.Anchor.Row, shape.Anchor.Col), Kind = shape.Kind, Width = shape.Width, Height = shape.Height, RotationDegrees = shape.RotationDegrees, FillColor = shape.FillColor, OutlineColor = shape.OutlineColor, AltText = shape.AltText });
foreach (var pic in source.Pictures)
{
    var p = new PictureModel { Anchor = new CellAddress(copyId, pic.Anchor.Row, pic.Anchor.Col), Kind = pic.Kind, SourceRowCount = pic.SourceRowCount, SourceColumnCount = pic.SourceColumnCount, ImageBytes = pic.ImageBytes?.ToArray(), ContentType = pic.ContentType, Width = pic.Width, Height = pic.Height, RotationDegrees = pic.RotationDegrees, AltText = pic.AltText };
    foreach (var cell in pic.Cells) p.Cells.Add(cell);
    copy.Pictures.Add(p);
}
foreach (var sp in source.Sparklines)
    copy.Sparklines.Add(new SparklineModel { DataRange = new GridRange(new CellAddress(copyId, sp.DataRange.Start.Row, sp.DataRange.Start.Col), new CellAddress(copyId, sp.DataRange.End.Row, sp.DataRange.End.Col)), Location = new CellAddress(copyId, sp.Location.Row, sp.Location.Col), Kind = sp.Kind });
```

Delete the private `CloneSheet` method and the private `RemapAddress`/`RemapRange` methods from `Commands.cs` (they are now inlined into `Sheet.Clone`).

- [ ] **Step 5: Run all tests**

```
dotnet test tests/FreeX.Core.Model.Tests/FreeX.Core.Model.Tests.csproj
```

Expected: all PASS including the new `Sheet_Clone_*` tests.

- [ ] **Step 6: Commit**

```
git add src/FreeX.Core.Model/Sheet.cs src/FreeX.Core.Commands/Commands.cs tests/FreeX.Core.Model.Tests/ModelTests.cs
git commit -m "refactor: move CloneSheet to Sheet.Clone(), fix missing BackgroundImage/OutlineLevels fields"
```

---

## Task 10: CsvFileAdapter — RFC 4180 multi-line quoted field support

**Files:**
- Modify: `src/FreeX.Core.IO/CsvFileAdapter.cs`
- Test: `tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`

- [ ] **Step 1: Write failing tests**

In `FileAdapterSmokeTests.cs`:

```csharp
[Fact]
public void CsvLoad_MultilineQuotedField_IsReadAsOneCell()
{
    var csv = "\"line1\nline2\",second\r\nrow2a,row2b\r\n";
    using var stream = new MemoryStream(Encoding.UTF8.GetBytes(csv));
    var adapter  = new CsvFileAdapter();
    var workbook = adapter.Load(stream);
    var sheet    = workbook.Sheets[0];

    sheet.GetValue(new CellAddress(sheet.Id, 1, 1))
        .Should().Be(new TextValue("line1\nline2"),
            "RFC 4180 allows newlines inside quoted fields");
    sheet.GetValue(new CellAddress(sheet.Id, 1, 2))
        .Should().Be(new TextValue("second"));
    sheet.GetValue(new CellAddress(sheet.Id, 2, 1))
        .Should().Be(new TextValue("row2a"));
}

[Fact]
public void CsvRoundTrip_MultilineField_PreservesContent()
{
    var wb    = new Workbook("T");
    var sheet = wb.AddSheet("S");
    sheet.SetCell(new CellAddress(sheet.Id, 1, 1), new TextValue("a\nb"));
    sheet.SetCell(new CellAddress(sheet.Id, 1, 2), new TextValue("c"));

    var adapter = new CsvFileAdapter();
    using var ms = new MemoryStream();
    adapter.Save(wb, ms);
    ms.Position = 0;
    var wb2    = adapter.Load(ms);
    var sheet2 = wb2.Sheets[0];
    sheet2.GetValue(new CellAddress(sheet2.Id, 1, 1)).Should().Be(new TextValue("a\nb"));
    sheet2.GetValue(new CellAddress(sheet2.Id, 1, 2)).Should().Be(new TextValue("c"));
}
```

- [ ] **Step 2: Run tests to verify they fail**

```
dotnet test tests/FreeX.Core.IO.Tests/FreeX.Core.IO.Tests.csproj --filter "CsvLoad_Multiline|CsvRoundTrip_Multiline"
```

Expected: FAIL.

- [ ] **Step 3: Replace the line-based CSV loader with a stateful character reader**

In `CsvFileAdapter.cs`, replace the `Load` method and the `ParseCsvLine` helper:

```csharp
public Workbook Load(Stream stream)
{
    var workbook = new Workbook("Untitled");
    var sheet    = workbook.AddSheet("Sheet1");

    using var reader = new StreamReader(stream, Encoding.UTF8, detectEncodingFromByteOrderMarks: true);
    uint row = 1;
    while (TryReadRecord(reader, out var fields))
    {
        for (int i = 0; i < fields.Count; i++)
        {
            var field = fields[i];
            if (field.Length == 0) continue;
            ScalarValue value = double.TryParse(field, NumberStyles.Any, CultureInfo.InvariantCulture, out var num)
                ? new NumberValue(num)
                : new TextValue(field);
            sheet.SetCell(new CellAddress(sheet.Id, row, (uint)(i + 1)), value);
        }
        row++;
    }
    return workbook;
}

private static bool TryReadRecord(TextReader reader, out List<string> fields)
{
    fields = [];
    var current   = new System.Text.StringBuilder();
    bool inQuotes = false;

    int ch;
    while ((ch = reader.Read()) != -1)
    {
        char c = (char)ch;

        if (inQuotes)
        {
            if (c == '"')
            {
                if (reader.Peek() == '"') { reader.Read(); current.Append('"'); } // escaped ""
                else inQuotes = false;
            }
            else
            {
                current.Append(c); // may be \n — allowed inside quoted fields (RFC 4180)
            }
        }
        else
        {
            switch (c)
            {
                case '"':  inQuotes = true;  break;
                case ',':  fields.Add(current.ToString()); current.Clear(); break;
                case '\r': break; // skip CR; LF below ends the record
                case '\n': fields.Add(current.ToString()); return true;
                default:   current.Append(c); break;
            }
        }
    }

    // End of stream — flush the last record if any data remains
    if (current.Length > 0 || fields.Count > 0)
    {
        fields.Add(current.ToString());
        return true;
    }
    return false;
}
```

Delete the old `ParseCsvLine` method.

- [ ] **Step 4: Run all IO tests**

```
dotnet test tests/FreeX.Core.IO.Tests/FreeX.Core.IO.Tests.csproj
```

Expected: all PASS.

- [ ] **Step 5: Commit**

```
git add src/FreeX.Core.IO/CsvFileAdapter.cs tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs
git commit -m "fix: CsvFileAdapter supports RFC 4180 multi-line quoted fields"
```

---

## Task 11: Minor fixes batch

**Files:**
- Modify: `src/FreeX.Core.Model/Cell.cs`
- Modify: `src/FreeX.Core.Model/Sheet.cs`
- Modify: `src/FreeX.Core.Calc/NumberFormatter.cs`
- Modify: `src/FreeX.App.UI/GridView.cs`
- Modify: `src/FreeX.App.Host/RecentFilesStore.cs`

No new failing tests needed — existing tests must stay green after each sub-step.

- [ ] **Step 1: Use `BlankValue.Instance` everywhere**

In `Cell.cs` line 10:
```csharp
// Change: public ScalarValue Value { get; set; } = new BlankValue();
public ScalarValue Value { get; set; } = BlankValue.Instance;
```

In `Sheet.cs`, in `GetValue(uint row, uint col)`:
```csharp
// Change: return new BlankValue();
return BlankValue.Instance;
```

Also grep for remaining `new BlankValue()` in the `FreeX.Core.Formula` and `FreeX.Core.Commands` projects and replace each one with `BlankValue.Instance`:
```
grep -rn "new BlankValue()" src/
```

- [ ] **Step 2: Fix `NumberFormatter.FormatNumberGeneral` to use `InvariantCulture` consistently**

In `NumberFormatter.cs`, in `FormatNumberGeneral`:

```csharp
private static string FormatNumberGeneral(double value)
{
    if (double.IsNaN(value) || double.IsInfinity(value))
        return value.ToString(CultureInfo.InvariantCulture);
    if (value == Math.Truncate(value) && Math.Abs(value) < 1e15)
        return ((long)value).ToString(CultureInfo.InvariantCulture);  // was CurrentCulture
    return value.ToString("G10", CultureInfo.InvariantCulture);       // was CurrentCulture
}
```

- [ ] **Step 3: Fix `ToNetDateFormat` so `hh`/`h` map to lowercase when `AM/PM` is present**

In `NumberFormatter.cs`, find `ToNetDateFormat` and add a pre-scan at the top of the method:

```csharp
private static string ToNetDateFormat(string excelFmt)
{
    bool hasAmPm = excelFmt.IndexOf("AM/PM", StringComparison.OrdinalIgnoreCase) >= 0;
    string hourToken2 = hasAmPm ? "hh" : "HH";
    string hourToken1 = hasAmPm ? "h"  : "H";
    // ...
```

Then in the `TryConsume` chain, change the two `hh`/`h` lines:

```csharp
// Old:
// TryConsume(excelFmt, i, "hh",   "HH",   sb, out ni) ||
// TryConsume(excelFmt, i, "h",    "H",    sb, out ni) ||
// New:
TryConsume(excelFmt, i, "hh", hourToken2, sb, out ni) ||
TryConsume(excelFmt, i, "h",  hourToken1, sb, out ni) ||
```

- [ ] **Step 4: Freeze all static `SolidColorBrush` fields in `GridView`**

In `GridView.cs`, add a `static SolidColorBrush MakeBrush(byte r, byte g, byte b)` helper near the `MakePen` helpers:

```csharp
private static SolidColorBrush MakeBrush(byte r, byte g, byte b)
{
    var brush = new SolidColorBrush(Color.FromRgb(r, g, b));
    brush.Freeze();
    return brush;
}

private static SolidColorBrush MakeBrushAlpha(byte a, byte r, byte g, byte b)
{
    var brush = new SolidColorBrush(Color.FromArgb(a, r, g, b));
    brush.Freeze();
    return brush;
}
```

Replace the direct `new SolidColorBrush(...)` field initialisers with calls to these helpers:

```csharp
private static readonly Brush GridLineBrush             = MakeBrush(220, 220, 220);
private static readonly Brush HeaderBackgroundBrush     = MakeBrush(242, 242, 242);
private static readonly Brush HeaderHighlightBrush      = MakeBrush(218, 232, 218);
private static readonly Brush SelectionBrush            = MakeBrushAlpha(32, 33, 115, 70);
private static readonly Brush PageBreakPreviewBrush     = MakeBrushAlpha(28, 0, 103, 192);
private static readonly Brush SplitScrollbarTrackBrush  = MakeBrush(244, 244, 244);
private static readonly Brush SplitScrollbarThumbBrush  = MakeBrush(188, 188, 188);
private static readonly Brush FormulaTraceArrowBrush    = MakeBrush(0, 102, 204);
private static readonly Brush PageMarginRulerHandleBrush = MakeBrush(238, 238, 238);
```

Also freeze the `SelectionPen`, `SplitScrollbarPen`, and `PageMarginRulerHandlePen` by converting them to factory methods like the other pens.

- [ ] **Step 5: Add diagnostic logging to `RecentFilesStore`**

In `RecentFilesStore.cs`, in both `catch` blocks, add a `Debug.WriteLine`:

```csharp
// In Load():
catch (Exception ex)
{
    System.Diagnostics.Debug.WriteLine($"[RecentFiles] Failed to load: {ex.Message}");
}

// In Save():
catch (Exception ex)
{
    System.Diagnostics.Debug.WriteLine($"[RecentFiles] Failed to save: {ex.Message}");
}
```

- [ ] **Step 6: Run the full suite**

```
dotnet test FreeX.slnx
```

Expected: all 1,266+ tests PASS.

- [ ] **Step 7: Commit**

```
git add src/FreeX.Core.Model/Cell.cs src/FreeX.Core.Model/Sheet.cs src/FreeX.Core.Calc/NumberFormatter.cs src/FreeX.App.UI/GridView.cs src/FreeX.App.Host/RecentFilesStore.cs
git commit -m "fix: BlankValue.Instance, NumberFormatter InvariantCulture+hh AM/PM, freeze GridView brushes, log RecentFilesStore failures"
```

---

## Task 12: Expand integration test suite

**Files:**
- Modify: `tests/FreeX.Integration.Tests/EndToEndTests.cs`
- Create: `tests/FreeX.Integration.Tests/IoRoundTripTests.cs`
- Create: `tests/FreeX.Integration.Tests/UndoRedoTests.cs`

- [ ] **Step 1: Add IF short-circuit and cross-sheet tests to `EndToEndTests.cs`**

```csharp
[Fact]
public void CrossSheet_FormulaReference_RecalculatesWhenSourceChanges()
{
    var wb     = new Workbook("T");
    var sheet1 = wb.AddSheet("Sheet1");
    var sheet2 = wb.AddSheet("Sheet2");
    var graph  = new DependencyGraph();
    var engine = new RecalcEngine(graph, new FormulaEvaluator());

    var src  = new CellAddress(sheet1.Id, 1, 1);
    var dest = new CellAddress(sheet2.Id, 1, 1);

    sheet1.SetCell(src, new NumberValue(42));
    sheet2.SetFormula(dest, "Sheet1!A1*2");

    engine.RebuildFormulaDependencies(wb);
    engine.Recalculate(wb, [src]);

    sheet2.GetValue(dest).Should().Be(new NumberValue(84));

    sheet1.SetCell(src, new NumberValue(10));
    engine.Recalculate(wb, [src]);
    sheet2.GetValue(dest).Should().Be(new NumberValue(20));
}

[Fact]
public void IF_ErrorGuardPattern_DoesNotPropagateError()
{
    var wb    = new Workbook("T"); var sheet = wb.AddSheet("S");
    var a1    = new CellAddress(sheet.Id, 1, 1);
    var b1    = new CellAddress(sheet.Id, 1, 2);
    var eval  = new FormulaEvaluator();

    // =IF(A1="","empty",1/A1) — when A1 is blank, 1/0 must NOT be evaluated
    sheet.SetCell(a1, BlankValue.Instance);
    eval.Evaluate("=IF(A1=\"\",\"empty\",1/A1)", sheet, wb)
        .Should().Be(new TextValue("empty"));

    sheet.SetCell(a1, new NumberValue(4));
    eval.Evaluate("=IF(A1=\"\",\"empty\",1/A1)", sheet, wb)
        .Should().Be(new NumberValue(0.25));
}
```

- [ ] **Step 2: Create `IoRoundTripTests.cs`**

```csharp
using System.IO;
using FluentAssertions;
using FreeX.Core.IO;
using FreeX.Core.Model;

namespace FreeX.Integration.Tests;

public class IoRoundTripTests
{
    [Fact]
    public void Csv_RoundTrip_PreservesNumbersAndText()
    {
        var wb    = new Workbook("T");
        var sheet = wb.AddSheet("S");
        sheet.SetCell(new CellAddress(sheet.Id, 1, 1), new NumberValue(3.14));
        sheet.SetCell(new CellAddress(sheet.Id, 1, 2), new TextValue("hello"));
        sheet.SetCell(new CellAddress(sheet.Id, 2, 1), new TextValue("a,b")); // needs quoting

        var adapter = new CsvFileAdapter();
        using var ms = new MemoryStream();
        adapter.Save(wb, ms);
        ms.Position = 0;

        var wb2    = adapter.Load(ms);
        var sheet2 = wb2.Sheets[0];

        sheet2.GetValue(new CellAddress(sheet2.Id, 1, 1)).Should().Be(new NumberValue(3.14));
        sheet2.GetValue(new CellAddress(sheet2.Id, 1, 2)).Should().Be(new TextValue("hello"));
        sheet2.GetValue(new CellAddress(sheet2.Id, 2, 1)).Should().Be(new TextValue("a,b"),
            "comma inside a cell should survive CSV round-trip via RFC 4180 quoting");
    }

    [Fact]
    public void Json_RoundTrip_PreservesFormulasAndStyles()
    {
        var wb    = new Workbook("Book1");
        var sheet = wb.AddSheet("Sheet1");
        var a1    = new CellAddress(sheet.Id, 1, 1);
        var b1    = new CellAddress(sheet.Id, 1, 2);

        sheet.SetCell(a1, new NumberValue(5));
        sheet.SetFormula(b1, "A1*2");
        sheet.GetCell(a1)!.StyleId = wb.RegisterStyle(new CellStyle { Bold = true });

        var adapter = new NativeJsonAdapter();
        using var ms = new MemoryStream();
        adapter.Save(wb, ms);
        ms.Position = 0;

        var wb2    = adapter.Load(ms);
        var sheet2 = wb2.Sheets[0];

        sheet2.GetCell(new CellAddress(sheet2.Id, 1, 1))!.StyleId
            .Should().NotBe(StyleId.Default, "bold style must survive JSON round-trip");
        sheet2.GetCell(new CellAddress(sheet2.Id, 1, 2))!.FormulaText
            .Should().Be("A1*2", "formula text must survive JSON round-trip");
    }
}
```

- [ ] **Step 3: Create `UndoRedoTests.cs`**

```csharp
using FluentAssertions;
using FreeX.Core.Calc;
using FreeX.Core.Commands;
using FreeX.Core.Formula;
using FreeX.Core.Model;

namespace FreeX.Integration.Tests;

public class UndoRedoTests
{
    private static (Workbook Wb, Sheet Sheet, CommandBus Bus, RecalcEngine Engine)
        CreateHarness()
    {
        var wb    = new Workbook("T");
        var sheet = wb.AddSheet("S");
        var graph = new DependencyGraph();
        var engine = new RecalcEngine(graph, new FormulaEvaluator());

        CommandOutcome? lastOutcome = null;
        var bus = new CommandBus(id => new SimpleContext(wb, sheet));

        return (wb, sheet, bus, engine);
    }

    [Fact]
    public void Undo_EditCell_RestoresPreviousValue()
    {
        var (wb, sheet, bus, _) = CreateHarness();
        var addr = new CellAddress(sheet.Id, 1, 1);
        sheet.SetCell(addr, new NumberValue(10));

        bus.Execute(wb.Id, new EditCellsCommand(sheet.Id, addr, new NumberValue(99)));
        sheet.GetValue(addr).Should().Be(new NumberValue(99));

        bus.Undo(wb.Id);
        sheet.GetValue(addr).Should().Be(new NumberValue(10), "undo must restore the original value");
    }

    [Fact]
    public void Redo_AfterUndo_ReappliesEdit()
    {
        var (wb, sheet, bus, _) = CreateHarness();
        var addr = new CellAddress(sheet.Id, 1, 1);
        sheet.SetCell(addr, new NumberValue(10));

        bus.Execute(wb.Id, new EditCellsCommand(sheet.Id, addr, new NumberValue(99)));
        bus.Undo(wb.Id);
        bus.Redo(wb.Id);

        sheet.GetValue(addr).Should().Be(new NumberValue(99), "redo must re-apply the edit");
    }

    [Fact]
    public void Undo_StyleCommand_RemovesAppliedStyle()
    {
        var (wb, sheet, bus, _) = CreateHarness();
        var addr  = new CellAddress(sheet.Id, 1, 1);
        var range = new GridRange(addr, addr);

        bus.Execute(wb.Id, new ApplyStyleCommand(sheet.Id, range, new StyleDiff(Bold: true)));
        wb.GetStyle(sheet.GetCell(addr)!.StyleId).Bold.Should().BeTrue();

        bus.Undo(wb.Id);
        sheet.GetCell(addr).Should().BeNull("undo of a style-only cell must remove the cell entirely");
    }

    private sealed class SimpleContext(Workbook wb, Sheet sheet) : ICommandContext
    {
        public Workbook Workbook => wb;
        public Sheet GetSheet(SheetId id) => sheet;
    }
}
```

- [ ] **Step 4: Run all integration tests**

```
dotnet test tests/FreeX.Integration.Tests/FreeX.Integration.Tests.csproj
```

Expected: all PASS.

- [ ] **Step 5: Run full suite**

```
dotnet test FreeX.slnx
```

Expected: all tests PASS.

- [ ] **Step 6: Commit**

```
git add tests/FreeX.Integration.Tests/EndToEndTests.cs tests/FreeX.Integration.Tests/IoRoundTripTests.cs tests/FreeX.Integration.Tests/UndoRedoTests.cs
git commit -m "test: expand integration suite with IO round-trips, undo/redo, cross-sheet formulas, IF error-guard"
```

---

## Final: Verify green suite and trigger second code review

- [ ] **Run the full test suite one last time**

```
dotnet test FreeX.slnx
```

Expected: all tests PASS, zero failures.

- [ ] **Second comprehensive code review**

Ask the user: "All tasks complete — ready to run the second code review?"
