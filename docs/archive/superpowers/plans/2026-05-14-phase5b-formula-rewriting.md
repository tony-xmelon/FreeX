# Phase 5b — Formula Reference Rewriting Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Full Excel-fidelity formula reference rewriting: $-anchors preserved, all references updated on insert/delete rows/columns across every sheet, relative references adjusted on paste.

**Architecture:** Fix the lexer to stop stripping `$`, add absolute-reference flags to `CellRefNode`, then build `FormulaSerializer` (AST → string) and `FormulaRewriter` (AST rewrite by operation). The insert/delete commands call the rewriter over all cells in all sheets and snapshot original formulas for undo. Paste stores an internal clipboard of raw `Cell` objects and applies a `PasteOffsetOp` on each formula before committing.

**Tech Stack:** C# 12 / .NET 10; xUnit + FluentAssertions; existing `Core.Formula`, `Core.Commands`, `App.Host` projects.

---

## File map

| File | Action |
|---|---|
| `src/FreeX.Core.Formula/Lexer.cs` | Modify — stop stripping `$` from CellRef tokens |
| `src/FreeX.Core.Formula/FormulaNode.cs` | Modify — add `IsColAbsolute`, `IsRowAbsolute` to `CellRefNode`; add `ErrorNode` |
| `src/FreeX.Core.Formula/FormulaEvaluator.cs` | Modify — handle `ErrorNode` in switch |
| `src/FreeX.Core.Formula/Parser.cs` | Modify — extract `$` flags in `ParseCellRef` |
| `src/FreeX.Core.Formula/FormulaSerializer.cs` | **Create** — AST → formula string |
| `src/FreeX.Core.Formula/FormulaRewriter.cs` | **Create** — `RewriteOperation` union + rewriter |
| `src/FreeX.Core.Commands/InsertDeleteRowsCommand.cs` | Modify — call rewriter; snapshot formulas for undo |
| `src/FreeX.Core.Commands/InsertDeleteColumnsCommand.cs` | Modify — same |
| `src/FreeX.App.Host/MainWindow.xaml.cs` | Modify — internal clipboard + paste formula adjustment |
| `tests/FreeX.Core.Formula.Tests/LexerTests.cs` | Modify — add $ token tests |
| `tests/FreeX.Core.Formula.Tests/FormulaSerializerTests.cs` | **Create** |
| `tests/FreeX.Core.Formula.Tests/FormulaRewriterTests.cs` | **Create** |
| `tests/FreeX.Core.Commands.Tests/FormulaRewriteCommandTests.cs` | **Create** |

---

## Task 1: Fix Lexer — preserve `$` in CellRef tokens

**Files:**
- Modify: `src/FreeX.Core.Formula/Lexer.cs:188`
- Modify: `tests/FreeX.Core.Formula.Tests/LexerTests.cs`

**Background:** Line 188 of `Lexer.cs` reads:
```csharp
return new Token(TokenType.CellRef, value.Replace("$", "").ToUpperInvariant(), start);
```
This strips `$`, so `$A$1` becomes `A1`. We stop stripping it.

- [ ] **Step 1: Write failing tests**

Add to `tests/FreeX.Core.Formula.Tests/LexerTests.cs`:

```csharp
[Fact]
public void Tokenizes_AbsoluteCellRef_BothAnchors()
{
    var tokens = new Lexer("=$A$1").Tokenize();
    tokens[0].Type.Should().Be(TokenType.CellRef);
    tokens[0].Value.Should().Be("$A$1");
}

[Fact]
public void Tokenizes_AbsoluteCellRef_ColOnly()
{
    var tokens = new Lexer("=$B3").Tokenize();
    tokens[0].Type.Should().Be(TokenType.CellRef);
    tokens[0].Value.Should().Be("$B3");
}

[Fact]
public void Tokenizes_AbsoluteCellRef_RowOnly()
{
    var tokens = new Lexer("=C$5").Tokenize();
    tokens[0].Type.Should().Be(TokenType.CellRef);
    tokens[0].Value.Should().Be("C$5");
}

[Fact]
public void Tokenizes_RelativeCellRef_Unchanged()
{
    var tokens = new Lexer("=D10").Tokenize();
    tokens[0].Type.Should().Be(TokenType.CellRef);
    tokens[0].Value.Should().Be("D10");
}
```

- [ ] **Step 2: Run tests to confirm they fail**

```
cd e:\Users\anton\Documents\Claude\FreeX
dotnet test tests/FreeX.Core.Formula.Tests --filter "Tokenizes_AbsoluteCellRef" -v normal
```

Expected: FAIL — values are `A1`, `B3`, `C5` (stripped).

- [ ] **Step 3: Fix the lexer**

In `src/FreeX.Core.Formula/Lexer.cs`, change line 188 from:
```csharp
return new Token(TokenType.CellRef, value.Replace("$", "").ToUpperInvariant(), start);
```
to:
```csharp
return new Token(TokenType.CellRef, value.ToUpperInvariant(), start);
```

- [ ] **Step 4: Run all formula tests**

```
dotnet test tests/FreeX.Core.Formula.Tests -v normal
```

Expected: all pass (the new tests now pass; existing tests use relative refs, so no `$` to strip).

- [ ] **Step 5: Commit**

```
git add src/FreeX.Core.Formula/Lexer.cs tests/FreeX.Core.Formula.Tests/LexerTests.cs
git commit -m "feat: lexer preserves $ anchors in CellRef tokens"
```

---

## Task 2: Update `CellRefNode` + add `ErrorNode` + evaluator support

**Files:**
- Modify: `src/FreeX.Core.Formula/FormulaNode.cs`
- Modify: `src/FreeX.Core.Formula/FormulaEvaluator.cs:40-52`

**Background:** `CellRefNode` is a positional record. New fields are added with defaults so all existing `new CellRefNode("A", 1)` callers keep compiling. `ErrorNode` is new — needed by the rewriter to encode `#REF!`.

- [ ] **Step 1: Update `FormulaNode.cs`**

Replace the `CellRefNode` declaration and add `ErrorNode`:

```csharp
/// <summary>A cell reference (e.g. A1, $B$3, Sheet2!A1).</summary>
public sealed record CellRefNode(
    string  ColumnName,
    uint    Row,
    bool    IsColAbsolute = false,
    bool    IsRowAbsolute = false,
    string? SheetName = null
) : FormulaNode
{
    /// <summary>Get the column as a 1-based number.</summary>
    public uint ColumnNumber => Model.CellAddress.ColumnNameToNumber(ColumnName);
}

/// <summary>A formula-level error literal produced by reference rewriting (e.g. #REF!).</summary>
public sealed record ErrorNode(ErrorValue Error) : FormulaNode;
```

Full updated `FormulaNode.cs` after the change:

```csharp
namespace FreeX.Core.Formula;

/// <summary>Base class for all AST nodes in a parsed formula.</summary>
public abstract record FormulaNode;

/// <summary>A numeric literal (e.g. 42, 3.14).</summary>
public sealed record NumberNode(double Value) : FormulaNode;

/// <summary>A string literal (e.g. "hello").</summary>
public sealed record StringNode(string Value) : FormulaNode;

/// <summary>A boolean literal (TRUE or FALSE).</summary>
public sealed record BooleanNode(bool Value) : FormulaNode;

/// <summary>A cell reference (e.g. A1, $B$3, Sheet2!A1).</summary>
public sealed record CellRefNode(
    string  ColumnName,
    uint    Row,
    bool    IsColAbsolute = false,
    bool    IsRowAbsolute = false,
    string? SheetName = null
) : FormulaNode
{
    /// <summary>Get the column as a 1-based number.</summary>
    public uint ColumnNumber => Model.CellAddress.ColumnNameToNumber(ColumnName);
}

/// <summary>A range reference (e.g. A1:C3, Sheet2!A1:A10).</summary>
public sealed record RangeRefNode(CellRefNode Start, CellRefNode End, string? SheetName = null) : FormulaNode;

/// <summary>A binary operation (e.g. A1 + B1).</summary>
public sealed record BinaryOpNode(FormulaNode Left, BinaryOperator Operator, FormulaNode Right) : FormulaNode;

/// <summary>A unary operation (e.g. -A1).</summary>
public sealed record UnaryOpNode(UnaryOperator Operator, FormulaNode Operand) : FormulaNode;

/// <summary>A function call (e.g. SUM(A1:A3)).</summary>
public sealed record FunctionCallNode(string FunctionName, IReadOnlyList<FormulaNode> Arguments) : FormulaNode;

/// <summary>
/// A named range reference (e.g. MyData). Resolved to a GridRange at evaluation time.
/// </summary>
public sealed record NamedRangeNode(string Name) : FormulaNode;

/// <summary>A formula-level error literal produced by reference rewriting (e.g. #REF!).</summary>
public sealed record ErrorNode(ErrorValue Error) : FormulaNode;

/// <summary>Binary operators.</summary>
public enum BinaryOperator
{
    Add, Subtract, Multiply, Divide, Power, Concatenate,
    Equal, NotEqual, LessThan, GreaterThan, LessOrEqual, GreaterOrEqual
}

/// <summary>Unary operators.</summary>
public enum UnaryOperator { Negate, Percent }
```

- [ ] **Step 2: Add `ErrorNode` case in `FormulaEvaluator.cs`**

In `FormulaEvaluator.cs`, in the `EvaluateNode` switch (around line 40), add `ErrorNode` before the default throw:

```csharp
ErrorNode err => err.Error,
```

The full switch should look like:

```csharp
return node switch
{
    NumberNode n    => new NumberValue(n.Value),
    StringNode s    => new TextValue(s.Value),
    BooleanNode b   => new BoolValue(b.Value),
    ErrorNode err   => err.Error,
    CellRefNode cell when cell.SheetName is not null
        => context.GetCellValue(cell.SheetName, cell.Row, cell.ColumnNumber),
    CellRefNode cell => context.GetCellValue(cell.Row, cell.ColumnNumber),
    RangeRefNode range => EvaluateRange(range, context),
    NamedRangeNode named => EvaluateNamedRange(named, context),
    BinaryOpNode binary => EvaluateBinaryOp(binary, context),
    UnaryOpNode unary => EvaluateUnaryOp(unary, context),
    FunctionCallNode func => EvaluateFunction(func, context),
    _ => throw new FormulaEvalException("#VALUE!", $"Unknown node type: {node.GetType().Name}")
};
```

- [ ] **Step 3: Build to confirm no compile errors**

```
dotnet build --no-incremental -v quiet
```

Expected: 0 errors, 0 warnings.

- [ ] **Step 4: Run all tests**

```
dotnet test -v quiet
```

Expected: all pass.

- [ ] **Step 5: Commit**

```
git add src/FreeX.Core.Formula/FormulaNode.cs src/FreeX.Core.Formula/FormulaEvaluator.cs
git commit -m "feat: add IsColAbsolute/IsRowAbsolute to CellRefNode and add ErrorNode"
```

---

## Task 3: Update Parser — extract `$` flags in `ParseCellRef`

**Files:**
- Modify: `src/FreeX.Core.Formula/Parser.cs:272-288`
- Modify: `tests/FreeX.Core.Formula.Tests/FormulaEvaluatorTests.cs` (add $ parse tests)

**Background:** `ParseCellRef` currently ignores `$` by scanning only letters then digits. We update it to detect and consume the `$` flags.

- [ ] **Step 1: Write failing tests**

Add to `tests/FreeX.Core.Formula.Tests/FormulaEvaluatorTests.cs`:

```csharp
[Fact]
public void Parse_AbsoluteRef_BothAnchors_IsColAbsolute_And_IsRowAbsolute()
{
    var tokens = new Lexer("=$A$1").Tokenize();
    var ast = new Parser(tokens).Parse();
    var cell = ast.Should().BeOfType<CellRefNode>().Subject;
    cell.IsColAbsolute.Should().BeTrue();
    cell.IsRowAbsolute.Should().BeTrue();
    cell.ColumnName.Should().Be("A");
    cell.Row.Should().Be(1);
}

[Fact]
public void Parse_AbsoluteRef_ColOnly_IsColAbsolute_True_RowAbsolute_False()
{
    var tokens = new Lexer("=$B3").Tokenize();
    var ast = new Parser(tokens).Parse();
    var cell = ast.Should().BeOfType<CellRefNode>().Subject;
    cell.IsColAbsolute.Should().BeTrue();
    cell.IsRowAbsolute.Should().BeFalse();
    cell.ColumnName.Should().Be("B");
    cell.Row.Should().Be(3);
}

[Fact]
public void Parse_AbsoluteRef_RowOnly_IsColAbsolute_False_RowAbsolute_True()
{
    var tokens = new Lexer("=C$5").Tokenize();
    var ast = new Parser(tokens).Parse();
    var cell = ast.Should().BeOfType<CellRefNode>().Subject;
    cell.IsColAbsolute.Should().BeFalse();
    cell.IsRowAbsolute.Should().BeTrue();
    cell.ColumnName.Should().Be("C");
    cell.Row.Should().Be(5);
}

[Fact]
public void Parse_RelativeRef_BothFlags_False()
{
    var tokens = new Lexer("=D10").Tokenize();
    var ast = new Parser(tokens).Parse();
    var cell = ast.Should().BeOfType<CellRefNode>().Subject;
    cell.IsColAbsolute.Should().BeFalse();
    cell.IsRowAbsolute.Should().BeFalse();
}
```

- [ ] **Step 2: Run to confirm they fail**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Parse_AbsoluteRef" -v normal
```

Expected: FAIL — IsColAbsolute is always false (not yet extracted).

- [ ] **Step 3: Update `ParseCellRef` in `Parser.cs`**

Replace the existing `ParseCellRef` method (lines 272–282):

```csharp
private static CellRefNode ParseCellRef(Token token)
{
    var value = token.Value;   // e.g. "$B$3", "$B3", "B$3", "B3"
    var i = 0;

    bool isColAbs = false;
    if (i < value.Length && value[i] == '$') { isColAbs = true; i++; }

    int colStart = i;
    while (i < value.Length && char.IsLetter(value[i])) i++;
    var colName = value[colStart..i];

    bool isRowAbs = false;
    if (i < value.Length && value[i] == '$') { isRowAbs = true; i++; }

    var row = uint.Parse(value[i..]);

    return new CellRefNode(colName, row, isColAbs, isRowAbs);
}
```

`ParseCellRefWithSheet` is unchanged — it uses `with { SheetName = sheetName }` which works fine with the new fields.

- [ ] **Step 4: Run all formula tests**

```
dotnet test tests/FreeX.Core.Formula.Tests -v normal
```

Expected: all pass.

- [ ] **Step 5: Commit**

```
git add src/FreeX.Core.Formula/Parser.cs tests/FreeX.Core.Formula.Tests/FormulaEvaluatorTests.cs
git commit -m "feat: parser extracts dollar-anchor flags into CellRefNode"
```

---

## Task 4: FormulaSerializer

**Files:**
- Create: `src/FreeX.Core.Formula/FormulaSerializer.cs`
- Create: `tests/FreeX.Core.Formula.Tests/FormulaSerializerTests.cs`

**Background:** New static class. Walks an AST and produces a formula string (without leading `=`). This is the inverse of `Parser` and the primitive that `FormulaRewriter` depends on.

- [ ] **Step 1: Create the test file first**

Create `tests/FreeX.Core.Formula.Tests/FormulaSerializerTests.cs`:

```csharp
using FreeX.Core.Formula;
using FreeX.Core.Model;
using FluentAssertions;

namespace FreeX.Core.Formula.Tests;

public class FormulaSerializerTests
{
    private static string RoundTrip(string formula)
    {
        var tokens = new Lexer(formula).Tokenize();
        var ast = new Parser(tokens).Parse();
        return FormulaSerializer.Serialize(ast);
    }

    [Fact]
    public void Serialize_Number() => RoundTrip("=42").Should().Be("42");

    [Fact]
    public void Serialize_Decimal() => RoundTrip("=3.14").Should().Be("3.14");

    [Fact]
    public void Serialize_String() => RoundTrip("=\"hello\"").Should().Be("\"hello\"");

    [Fact]
    public void Serialize_StringWithEmbeddedQuote()
    {
        RoundTrip("=\"say \"\"hi\"\"\"").Should().Be("\"say \"\"hi\"\"\"");
    }

    [Fact]
    public void Serialize_BoolTrue() => RoundTrip("=TRUE").Should().Be("TRUE");

    [Fact]
    public void Serialize_BoolFalse() => RoundTrip("=FALSE").Should().Be("FALSE");

    [Fact]
    public void Serialize_RelativeCellRef() => RoundTrip("=A1").Should().Be("A1");

    [Fact]
    public void Serialize_BothAbsoluteCellRef() => RoundTrip("=$A$1").Should().Be("$A$1");

    [Fact]
    public void Serialize_ColAbsoluteCellRef() => RoundTrip("=$B3").Should().Be("$B3");

    [Fact]
    public void Serialize_RowAbsoluteCellRef() => RoundTrip("=C$5").Should().Be("C$5");

    [Fact]
    public void Serialize_RangeRef() => RoundTrip("=A1:C3").Should().Be("A1:C3");

    [Fact]
    public void Serialize_AbsoluteRangeRef() => RoundTrip("=$A$1:$C$3").Should().Be("$A$1:$C$3");

    [Fact]
    public void Serialize_SheetQualifiedRef() => RoundTrip("=Sheet2!A1").Should().Be("Sheet2!A1");

    [Fact]
    public void Serialize_SheetQualifiedRange() => RoundTrip("=Sheet2!A1:B2").Should().Be("Sheet2!A1:B2");

    [Fact]
    public void Serialize_FunctionCall() => RoundTrip("=SUM(A1:A3)").Should().Be("SUM(A1:A3)");

    [Fact]
    public void Serialize_FunctionNoArgs() => RoundTrip("=NOW()").Should().Be("NOW()");

    [Fact]
    public void Serialize_BinaryAdd() => RoundTrip("=A1+B1").Should().Be("A1+B1");

    [Fact]
    public void Serialize_BinarySubtract() => RoundTrip("=A1-B1").Should().Be("A1-B1");

    [Fact]
    public void Serialize_BinaryMultiply() => RoundTrip("=A1*B1").Should().Be("A1*B1");

    [Fact]
    public void Serialize_BinaryDivide() => RoundTrip("=A1/B1").Should().Be("A1/B1");

    [Fact]
    public void Serialize_BinaryPower() => RoundTrip("=A1^2").Should().Be("A1^2");

    [Fact]
    public void Serialize_BinaryConcat() => RoundTrip("=A1&B1").Should().Be("A1&B1");

    [Fact]
    public void Serialize_ComparisonEqual() => RoundTrip("=A1=B1").Should().Be("A1=B1");

    [Fact]
    public void Serialize_ComparisonNotEqual() => RoundTrip("=A1<>B1").Should().Be("A1<>B1");

    [Fact]
    public void Serialize_ComparisonLessThan() => RoundTrip("=A1<B1").Should().Be("A1<B1");

    [Fact]
    public void Serialize_ComparisonGreaterThan() => RoundTrip("=A1>B1").Should().Be("A1>B1");

    [Fact]
    public void Serialize_UnaryNegate() => RoundTrip("=-A1").Should().Be("-A1");

    [Fact]
    public void Serialize_UnaryPercent() => RoundTrip("=A1%").Should().Be("A1%");

    [Fact]
    public void Serialize_ComplexFormula()
    {
        RoundTrip("=IF(A1>0,SUM(B1:B10),0)").Should().Be("IF(A1>0,SUM(B1:B10),0)");
    }

    [Fact]
    public void Serialize_ErrorNode()
    {
        var node = new ErrorNode(ErrorValue.Ref);
        FormulaSerializer.Serialize(node).Should().Be("#REF!");
    }
}
```

- [ ] **Step 2: Run to confirm they fail**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "FormulaSerializerTests" -v normal
```

Expected: FAIL — `FormulaSerializer` does not exist yet.

- [ ] **Step 3: Create `FormulaSerializer.cs`**

Create `src/FreeX.Core.Formula/FormulaSerializer.cs`:

```csharp
using System.Globalization;
using System.Text;
using FreeX.Core.Model;

namespace FreeX.Core.Formula;

/// <summary>
/// Converts a formula AST back to a formula string (without leading '=').
/// This is the inverse of Parser and is used by FormulaRewriter.
/// </summary>
public static class FormulaSerializer
{
    private static readonly Dictionary<BinaryOperator, string> OpSymbols = new()
    {
        [BinaryOperator.Add]            = "+",
        [BinaryOperator.Subtract]       = "-",
        [BinaryOperator.Multiply]       = "*",
        [BinaryOperator.Divide]         = "/",
        [BinaryOperator.Power]          = "^",
        [BinaryOperator.Concatenate]    = "&",
        [BinaryOperator.Equal]          = "=",
        [BinaryOperator.NotEqual]       = "<>",
        [BinaryOperator.LessThan]       = "<",
        [BinaryOperator.GreaterThan]    = ">",
        [BinaryOperator.LessOrEqual]    = "<=",
        [BinaryOperator.GreaterOrEqual] = ">=",
    };

    public static string Serialize(FormulaNode node)
    {
        var sb = new StringBuilder();
        WriteNode(node, sb);
        return sb.ToString();
    }

    private static void WriteNode(FormulaNode node, StringBuilder sb)
    {
        switch (node)
        {
            case NumberNode n:
                sb.Append(n.Value.ToString(CultureInfo.InvariantCulture));
                break;

            case StringNode s:
                sb.Append('"');
                sb.Append(s.Value.Replace("\"", "\"\""));
                sb.Append('"');
                break;

            case BooleanNode b:
                sb.Append(b.Value ? "TRUE" : "FALSE");
                break;

            case ErrorNode e:
                sb.Append(e.Error.Code);
                break;

            case CellRefNode cr:
                WriteCellRef(cr, sb);
                break;

            case RangeRefNode rr:
                WriteRangeRef(rr, sb);
                break;

            case NamedRangeNode nr:
                sb.Append(nr.Name);
                break;

            case FunctionCallNode f:
                sb.Append(f.FunctionName);
                sb.Append('(');
                for (int i = 0; i < f.Arguments.Count; i++)
                {
                    if (i > 0) sb.Append(',');
                    WriteNode(f.Arguments[i], sb);
                }
                sb.Append(')');
                break;

            case BinaryOpNode bin:
                WriteNode(bin.Left, sb);
                sb.Append(OpSymbols[bin.Operator]);
                WriteNode(bin.Right, sb);
                break;

            case UnaryOpNode u when u.Operator == UnaryOperator.Negate:
                sb.Append('-');
                WriteNode(u.Operand, sb);
                break;

            case UnaryOpNode u when u.Operator == UnaryOperator.Percent:
                WriteNode(u.Operand, sb);
                sb.Append('%');
                break;
        }
    }

    private static void WriteCellRef(CellRefNode cr, StringBuilder sb)
    {
        if (cr.SheetName is not null)
        {
            sb.Append(cr.SheetName);
            sb.Append('!');
        }
        if (cr.IsColAbsolute) sb.Append('$');
        sb.Append(cr.ColumnName);
        if (cr.IsRowAbsolute) sb.Append('$');
        sb.Append(cr.Row);
    }

    private static void WriteRangeRef(RangeRefNode rr, StringBuilder sb)
    {
        var sheetName = rr.SheetName ?? rr.Start.SheetName;
        if (sheetName is not null)
        {
            sb.Append(sheetName);
            sb.Append('!');
        }
        // Write start without its SheetName prefix (already written above)
        WriteRefPart(rr.Start, sb);
        sb.Append(':');
        WriteRefPart(rr.End, sb);
    }

    private static void WriteRefPart(CellRefNode cr, StringBuilder sb)
    {
        if (cr.IsColAbsolute) sb.Append('$');
        sb.Append(cr.ColumnName);
        if (cr.IsRowAbsolute) sb.Append('$');
        sb.Append(cr.Row);
    }
}
```

- [ ] **Step 4: Run serializer tests**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "FormulaSerializerTests" -v normal
```

Expected: all pass.

- [ ] **Step 5: Run all tests**

```
dotnet test -v quiet
```

Expected: all pass.

- [ ] **Step 6: Commit**

```
git add src/FreeX.Core.Formula/FormulaSerializer.cs tests/FreeX.Core.Formula.Tests/FormulaSerializerTests.cs
git commit -m "feat: FormulaSerializer — AST to formula string"
```

---

## Task 5: FormulaRewriter

**Files:**
- Create: `src/FreeX.Core.Formula/FormulaRewriter.cs`
- Create: `tests/FreeX.Core.Formula.Tests/FormulaRewriterTests.cs`

**Background:** The rewriter parses a formula string, walks the AST adjusting `CellRefNode`s per the operation, then serializes back. Returns `null` if no refs changed (callers skip write-back).

- [ ] **Step 1: Create test file**

Create `tests/FreeX.Core.Formula.Tests/FormulaRewriterTests.cs`:

```csharp
using FreeX.Core.Formula;
using FluentAssertions;

namespace FreeX.Core.Formula.Tests;

public class FormulaRewriterTests
{
    // ── InsertRowsOp ──────────────────────────────────────────────────────────

    [Fact]
    public void InsertRows_RelativeRef_AtInsertPoint_ShiftsDown()
    {
        // Insert 1 row before row 3. =A3 is on "Sheet1" (same sheet) → =A4
        var result = FormulaRewriter.Rewrite("A3", new InsertRowsOp("Sheet1", 3, 1), "Sheet1");
        result.Should().Be("A4");
    }

    [Fact]
    public void InsertRows_RelativeRef_AboveInsertPoint_Unchanged()
    {
        var result = FormulaRewriter.Rewrite("A2", new InsertRowsOp("Sheet1", 3, 1), "Sheet1");
        result.Should().BeNull(); // no change
    }

    [Fact]
    public void InsertRows_AbsoluteRowRef_Unchanged()
    {
        // $A$3 — row is absolute, must not shift
        var result = FormulaRewriter.Rewrite("$A$3", new InsertRowsOp("Sheet1", 3, 1), "Sheet1");
        result.Should().BeNull();
    }

    [Fact]
    public void InsertRows_ColAbsoluteRowRelative_ShiftsRow()
    {
        // $A3 — col absolute, row relative → row shifts
        var result = FormulaRewriter.Rewrite("$A3", new InsertRowsOp("Sheet1", 3, 1), "Sheet1");
        result.Should().Be("$A4");
    }

    [Fact]
    public void InsertRows_MultipleRows_ShiftsByCount()
    {
        var result = FormulaRewriter.Rewrite("A5", new InsertRowsOp("Sheet1", 3, 3), "Sheet1");
        result.Should().Be("A8");
    }

    [Fact]
    public void InsertRows_DifferentSheet_NoChange()
    {
        // Cell lives on Sheet2, op is on Sheet1 — no change
        var result = FormulaRewriter.Rewrite("A3", new InsertRowsOp("Sheet1", 3, 1), "Sheet2");
        result.Should().BeNull();
    }

    [Fact]
    public void InsertRows_CrossSheetRef_OnTargetSheet_Shifts()
    {
        // Formula =Sheet1!A3, cell lives on Sheet2, insert on Sheet1 → =Sheet1!A4
        var result = FormulaRewriter.Rewrite("Sheet1!A3", new InsertRowsOp("Sheet1", 3, 1), "Sheet2");
        result.Should().Be("Sheet1!A4");
    }

    [Fact]
    public void InsertRows_RangeRef_BothEndsShift()
    {
        var result = FormulaRewriter.Rewrite("SUM(A3:A10)", new InsertRowsOp("Sheet1", 3, 1), "Sheet1");
        result.Should().Be("SUM(A4:A11)");
    }

    // ── DeleteRowsOp ──────────────────────────────────────────────────────────

    [Fact]
    public void DeleteRows_RefInDeletedRange_BecomesRef()
    {
        // Delete row 3. =A3 → =#REF!
        var result = FormulaRewriter.Rewrite("A3", new DeleteRowsOp("Sheet1", 3, 1), "Sheet1");
        result.Should().Be("#REF!");
    }

    [Fact]
    public void DeleteRows_RefBelowDeletedRange_ShiftsUp()
    {
        // Delete row 3. =A5 → =A4
        var result = FormulaRewriter.Rewrite("A5", new DeleteRowsOp("Sheet1", 3, 1), "Sheet1");
        result.Should().Be("A4");
    }

    [Fact]
    public void DeleteRows_RefAboveDeletedRange_Unchanged()
    {
        var result = FormulaRewriter.Rewrite("A2", new DeleteRowsOp("Sheet1", 3, 1), "Sheet1");
        result.Should().BeNull();
    }

    [Fact]
    public void DeleteRows_AbsoluteRowRef_BelowDeleted_Unchanged()
    {
        // $A$5 — row absolute, must not shift even though it's below deleted range
        var result = FormulaRewriter.Rewrite("$A$5", new DeleteRowsOp("Sheet1", 3, 1), "Sheet1");
        result.Should().BeNull();
    }

    [Fact]
    public void DeleteRows_RangeRef_StartInDeletedRange_BecomesRef()
    {
        var result = FormulaRewriter.Rewrite("SUM(A3:A5)", new DeleteRowsOp("Sheet1", 3, 1), "Sheet1");
        result.Should().Be("SUM(#REF!)");
    }

    // ── InsertColsOp ─────────────────────────────────────────────────────────

    [Fact]
    public void InsertCols_RelativeRef_AtInsertPoint_ShiftsRight()
    {
        // Insert 1 col before col 2 (B). =B1 → =C1
        var result = FormulaRewriter.Rewrite("B1", new InsertColsOp("Sheet1", 2, 1), "Sheet1");
        result.Should().Be("C1");
    }

    [Fact]
    public void InsertCols_AbsoluteColRef_Unchanged()
    {
        var result = FormulaRewriter.Rewrite("$B1", new InsertColsOp("Sheet1", 2, 1), "Sheet1");
        result.Should().BeNull();
    }

    // ── DeleteColsOp ─────────────────────────────────────────────────────────

    [Fact]
    public void DeleteCols_RefInDeletedCol_BecomesRef()
    {
        var result = FormulaRewriter.Rewrite("B1", new DeleteColsOp("Sheet1", 2, 1), "Sheet1");
        result.Should().Be("#REF!");
    }

    [Fact]
    public void DeleteCols_RefRightOfDeletedCol_ShiftsLeft()
    {
        var result = FormulaRewriter.Rewrite("D1", new DeleteColsOp("Sheet1", 2, 1), "Sheet1");
        result.Should().Be("C1");
    }

    // ── PasteOffsetOp ─────────────────────────────────────────────────────────

    [Fact]
    public void PasteOffset_RelativeRef_ShiftsByOffset()
    {
        // Copy from C1, paste to E3 → rowDelta=2, colDelta=2. =A1 → =C3
        var result = FormulaRewriter.Rewrite("A1", new PasteOffsetOp(2, 2), "Sheet1");
        result.Should().Be("C3");
    }

    [Fact]
    public void PasteOffset_AbsoluteRef_Unchanged()
    {
        var result = FormulaRewriter.Rewrite("$A$1", new PasteOffsetOp(2, 2), "Sheet1");
        result.Should().BeNull();
    }

    [Fact]
    public void PasteOffset_ColAbsoluteRowRelative_OnlyRowShifts()
    {
        var result = FormulaRewriter.Rewrite("$A1", new PasteOffsetOp(2, 2), "Sheet1");
        result.Should().Be("$A3");
    }

    [Fact]
    public void PasteOffset_OutOfBounds_BecomesRef()
    {
        // Row 1, offset -2 → row -1 → #REF!
        var result = FormulaRewriter.Rewrite("A1", new PasteOffsetOp(-2, 0), "Sheet1");
        result.Should().Be("#REF!");
    }

    [Fact]
    public void PasteOffset_RangeRef_BothEndsShift()
    {
        var result = FormulaRewriter.Rewrite("SUM(A1:A3)", new PasteOffsetOp(1, 1), "Sheet1");
        result.Should().Be("SUM(B2:B4)");
    }

    [Fact]
    public void Rewrite_ParseFailure_ReturnsNull()
    {
        // Malformed formula should not throw — returns null
        var result = FormulaRewriter.Rewrite("BROKEN(((", new InsertRowsOp("Sheet1", 3, 1), "Sheet1");
        result.Should().BeNull();
    }

    [Fact]
    public void Rewrite_NoRefsInRange_ReturnsNull()
    {
        // Formula has no refs that need changing
        var result = FormulaRewriter.Rewrite("1+2", new InsertRowsOp("Sheet1", 3, 1), "Sheet1");
        result.Should().BeNull();
    }
}
```

- [ ] **Step 2: Run to confirm they fail**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "FormulaRewriterTests" -v normal
```

Expected: FAIL — `FormulaRewriter` does not exist.

- [ ] **Step 3: Create `FormulaRewriter.cs`**

Create `src/FreeX.Core.Formula/FormulaRewriter.cs`:

```csharp
using FreeX.Core.Model;

namespace FreeX.Core.Formula;

// ── Operation types ───────────────────────────────────────────────────────────

public abstract record RewriteOperation;
public sealed record InsertRowsOp(string SheetName, uint BeforeRow, uint Count) : RewriteOperation;
public sealed record DeleteRowsOp(string SheetName, uint StartRow,  uint Count) : RewriteOperation;
public sealed record InsertColsOp(string SheetName, uint BeforeCol, uint Count) : RewriteOperation;
public sealed record DeleteColsOp(string SheetName, uint StartCol,  uint Count) : RewriteOperation;
public sealed record PasteOffsetOp(int RowDelta, int ColDelta)                  : RewriteOperation;

// ── Rewriter ─────────────────────────────────────────────────────────────────

/// <summary>
/// Rewrites cell references in a formula string according to a structural operation
/// (insert/delete rows or columns, or paste offset). Returns null when no references
/// were changed so callers can skip the write-back.
/// </summary>
public static class FormulaRewriter
{
    /// <summary>
    /// Rewrites all CellRefNodes in <paramref name="formulaText"/> according to
    /// <paramref name="op"/>. <paramref name="hostSheetName"/> is the sheet the cell
    /// lives on — used to decide whether sheet-unqualified refs should be adjusted.
    /// Returns null when no refs were modified.
    /// </summary>
    public static string? Rewrite(string formulaText, RewriteOperation op, string hostSheetName)
    {
        try
        {
            var tokens = new Lexer(formulaText).Tokenize();
            var ast    = new Parser(tokens).Parse();
            bool changed = false;
            var rewritten = RewriteNode(ast, op, hostSheetName, ref changed);
            return changed ? FormulaSerializer.Serialize(rewritten) : null;
        }
        catch
        {
            return null;   // malformed formula — leave untouched
        }
    }

    private static FormulaNode RewriteNode(
        FormulaNode node, RewriteOperation op, string hostSheetName, ref bool changed)
    {
        return node switch
        {
            CellRefNode cr  => RewriteCellRef(cr, op, hostSheetName, ref changed),
            RangeRefNode rr => RewriteRange(rr, op, hostSheetName, ref changed),
            BinaryOpNode b  => b with
            {
                Left  = RewriteNode(b.Left,  op, hostSheetName, ref changed),
                Right = RewriteNode(b.Right, op, hostSheetName, ref changed)
            },
            UnaryOpNode u => u with
            {
                Operand = RewriteNode(u.Operand, op, hostSheetName, ref changed)
            },
            FunctionCallNode f => f with
            {
                Arguments = f.Arguments
                    .Select(a => RewriteNode(a, op, hostSheetName, ref changed))
                    .ToList()
            },
            _ => node   // NumberNode, StringNode, BooleanNode, NamedRangeNode, ErrorNode
        };
    }

    private static FormulaNode RewriteCellRef(
        CellRefNode cr, RewriteOperation op, string hostSheetName, ref bool changed)
    {
        if (!Matches(cr, op, hostSheetName))
            return cr;

        return op switch
        {
            InsertRowsOp ins => RewriteCellRefInsertRows(cr, ins, ref changed),
            DeleteRowsOp del => RewriteCellRefDeleteRows(cr, del, ref changed),
            InsertColsOp ins => RewriteCellRefInsertCols(cr, ins, ref changed),
            DeleteColsOp del => RewriteCellRefDeleteCols(cr, del, ref changed),
            PasteOffsetOp paste => RewriteCellRefPaste(cr, paste, ref changed),
            _ => cr
        };
    }

    private static FormulaNode RewriteRange(
        RangeRefNode rr, RewriteOperation op, string hostSheetName, ref bool changed)
    {
        var start = RewriteCellRef(rr.Start, op, hostSheetName, ref changed);
        var end   = RewriteCellRef(rr.End,   op, hostSheetName, ref changed);

        if (start is ErrorNode || end is ErrorNode)
        {
            changed = true;
            return new ErrorNode(ErrorValue.Ref);
        }

        return rr with { Start = (CellRefNode)start, End = (CellRefNode)end };
    }

    // ── Row insert ────────────────────────────────────────────────────────────

    private static FormulaNode RewriteCellRefInsertRows(
        CellRefNode cr, InsertRowsOp op, ref bool changed)
    {
        if (cr.IsRowAbsolute || cr.Row < op.BeforeRow)
            return cr;

        changed = true;
        return cr with { Row = cr.Row + op.Count };
    }

    // ── Row delete ────────────────────────────────────────────────────────────

    private static FormulaNode RewriteCellRefDeleteRows(
        CellRefNode cr, DeleteRowsOp op, ref bool changed)
    {
        if (cr.IsRowAbsolute)
            return cr;

        uint endRow = op.StartRow + op.Count - 1;

        if (cr.Row >= op.StartRow && cr.Row <= endRow)
        {
            changed = true;
            return new ErrorNode(ErrorValue.Ref);
        }

        if (cr.Row > endRow)
        {
            changed = true;
            return cr with { Row = cr.Row - op.Count };
        }

        return cr;
    }

    // ── Column insert ─────────────────────────────────────────────────────────

    private static FormulaNode RewriteCellRefInsertCols(
        CellRefNode cr, InsertColsOp op, ref bool changed)
    {
        if (cr.IsColAbsolute || cr.ColumnNumber < op.BeforeCol)
            return cr;

        changed = true;
        var newCol = CellAddress.NumberToColumnName(cr.ColumnNumber + op.Count);
        return cr with { ColumnName = newCol };
    }

    // ── Column delete ─────────────────────────────────────────────────────────

    private static FormulaNode RewriteCellRefDeleteCols(
        CellRefNode cr, DeleteColsOp op, ref bool changed)
    {
        if (cr.IsColAbsolute)
            return cr;

        uint endCol = op.StartCol + op.Count - 1;

        if (cr.ColumnNumber >= op.StartCol && cr.ColumnNumber <= endCol)
        {
            changed = true;
            return new ErrorNode(ErrorValue.Ref);
        }

        if (cr.ColumnNumber > endCol)
        {
            changed = true;
            var newCol = CellAddress.NumberToColumnName(cr.ColumnNumber - op.Count);
            return cr with { ColumnName = newCol };
        }

        return cr;
    }

    // ── Paste offset ──────────────────────────────────────────────────────────

    private static FormulaNode RewriteCellRefPaste(
        CellRefNode cr, PasteOffsetOp op, ref bool changed)
    {
        var newRow = cr.Row;
        var newColNum = cr.ColumnNumber;
        bool rowChanged = false, colChanged = false;

        if (!cr.IsRowAbsolute && op.RowDelta != 0)
        {
            long r = (long)cr.Row + op.RowDelta;
            if (r < 1 || r > CellAddress.MaxRow)
            {
                changed = true;
                return new ErrorNode(ErrorValue.Ref);
            }
            newRow = (uint)r;
            rowChanged = true;
        }

        if (!cr.IsColAbsolute && op.ColDelta != 0)
        {
            long c = (long)cr.ColumnNumber + op.ColDelta;
            if (c < 1 || c > CellAddress.MaxCol)
            {
                changed = true;
                return new ErrorNode(ErrorValue.Ref);
            }
            newColNum = (uint)c;
            colChanged = true;
        }

        if (!rowChanged && !colChanged)
            return cr;

        changed = true;
        var newColName = colChanged
            ? CellAddress.NumberToColumnName(newColNum)
            : cr.ColumnName;
        return cr with { Row = newRow, ColumnName = newColName };
    }

    // ── Sheet matching ────────────────────────────────────────────────────────

    private static bool Matches(CellRefNode cr, RewriteOperation op, string hostSheetName)
    {
        if (op is PasteOffsetOp) return true;   // paste always adjusts

        var opSheet = op switch
        {
            InsertRowsOp ins => ins.SheetName,
            DeleteRowsOp del => del.SheetName,
            InsertColsOp ins => ins.SheetName,
            DeleteColsOp del => del.SheetName,
            _ => null
        };

        if (opSheet is null) return false;

        var refSheet = cr.SheetName ?? hostSheetName;
        return string.Equals(refSheet, opSheet, StringComparison.OrdinalIgnoreCase);
    }
}
```

- [ ] **Step 4: Run rewriter tests**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "FormulaRewriterTests" -v normal
```

Expected: all pass.

- [ ] **Step 5: Run all tests**

```
dotnet test -v quiet
```

Expected: all pass.

- [ ] **Step 6: Commit**

```
git add src/FreeX.Core.Formula/FormulaRewriter.cs tests/FreeX.Core.Formula.Tests/FormulaRewriterTests.cs
git commit -m "feat: FormulaRewriter and RewriteOperation types"
```

---

## Task 6: InsertRows / DeleteRows — call rewriter + snapshot for undo

**Files:**
- Modify: `src/FreeX.Core.Commands/InsertDeleteRowsCommand.cs`
- Create: `tests/FreeX.Core.Model.Tests/FormulaRewriteCommandTests.cs`

**Background:** After shifting cell data, each command iterates all cells on all sheets and rewrites formulas. Original formula texts are stored in `_formulaSnapshot` for undo. `ICommandContext` already exposes `Workbook Workbook { get; }` — confirmed in `ICommandBus.cs:43`. Tests follow the existing pattern in `InsertDeleteRowsTests.cs`: use a local `SimpleCtx` and call `cmd.Apply(ctx)` / `cmd.Revert(ctx)` directly.

- [ ] **Step 1: Create test file**

Create `tests/FreeX.Core.Model.Tests/FormulaRewriteCommandTests.cs`:

```csharp
using FreeX.Core.Commands;
using FreeX.Core.Model;
using FluentAssertions;

namespace FreeX.Core.Model.Tests;

public class FormulaRewriteCommandTests
{
    private static (Workbook wb, Sheet sheet, ICommandContext ctx) Setup()
    {
        var wb    = new Workbook("test");
        var sheet = wb.AddSheet("Sheet1");
        return (wb, sheet, new SimpleCtx(wb));
    }

    private sealed class SimpleCtx(Workbook wb) : ICommandContext
    {
        public Workbook Workbook { get; } = wb;
        public Sheet GetSheet(SheetId id) => Workbook.GetSheet(id)!;
    }

    // ── InsertRows ────────────────────────────────────────────────────────────

    [Fact]
    public void InsertRows_ShiftsRelativeFormulaRef()
    {
        var (_, sheet, ctx) = Setup();
        sheet.SetFormula(new CellAddress(sheet.Id, 1, 2), "A5");

        var cmd = new InsertRowsCommand(sheet.Id, 3, 1);
        cmd.Apply(ctx);

        sheet.GetCell(1, 2)!.FormulaText.Should().Be("A6");
    }

    [Fact]
    public void InsertRows_AbsoluteRowRef_NotShifted()
    {
        var (_, sheet, ctx) = Setup();
        sheet.SetFormula(new CellAddress(sheet.Id, 1, 2), "$A$5");

        new InsertRowsCommand(sheet.Id, 3, 1).Apply(ctx);

        sheet.GetCell(1, 2)!.FormulaText.Should().Be("$A$5");
    }

    [Fact]
    public void InsertRows_Undo_RestoresOriginalFormula()
    {
        var (_, sheet, ctx) = Setup();
        sheet.SetFormula(new CellAddress(sheet.Id, 1, 2), "A5");

        var cmd = new InsertRowsCommand(sheet.Id, 3, 1);
        cmd.Apply(ctx);
        sheet.GetCell(1, 2)!.FormulaText.Should().Be("A6");

        cmd.Revert(ctx);
        sheet.GetCell(1, 2)!.FormulaText.Should().Be("A5");
    }

    [Fact]
    public void InsertRows_CrossSheetFormula_ShiftedOnCorrectSheet()
    {
        var (wb, sheet, _) = Setup();
        var ctx = new SimpleCtx(wb);
        var sheet2 = wb.AddSheet("Sheet2");
        sheet2.SetFormula(new CellAddress(sheet2.Id, 1, 2), "Sheet1!A5");

        new InsertRowsCommand(sheet.Id, 3, 1).Apply(ctx);

        sheet2.GetCell(1, 2)!.FormulaText.Should().Be("Sheet1!A6");
    }

    // ── DeleteRows ───────────────────────────────────────────────────────────

    [Fact]
    public void DeleteRows_RefInDeletedRow_BecomesRefError()
    {
        var (_, sheet, ctx) = Setup();
        sheet.SetFormula(new CellAddress(sheet.Id, 1, 2), "A3");

        new DeleteRowsCommand(sheet.Id, 3, 1).Apply(ctx);

        sheet.GetCell(1, 2)!.FormulaText.Should().Be("#REF!");
    }

    [Fact]
    public void DeleteRows_RefBelowDeleted_ShiftsUp()
    {
        var (_, sheet, ctx) = Setup();
        sheet.SetFormula(new CellAddress(sheet.Id, 1, 2), "A5");

        new DeleteRowsCommand(sheet.Id, 3, 1).Apply(ctx);

        sheet.GetCell(1, 2)!.FormulaText.Should().Be("A4");
    }

    [Fact]
    public void DeleteRows_Undo_RestoresOriginalFormula()
    {
        var (_, sheet, ctx) = Setup();
        sheet.SetFormula(new CellAddress(sheet.Id, 1, 2), "A5");

        var cmd = new DeleteRowsCommand(sheet.Id, 3, 1);
        cmd.Apply(ctx);
        cmd.Revert(ctx);

        sheet.GetCell(1, 2)!.FormulaText.Should().Be("A5");
    }
}
```

- [ ] **Step 3: Run tests to confirm they fail**

```
dotnet test tests/FreeX.Core.Model.Tests --filter "FormulaRewriteCommandTests" -v normal
```

Expected: FAIL (formulas not rewritten yet).

- [ ] **Step 4: Add `_formulaSnapshot` and `RewriteAllFormulas` to `InsertDeleteRowsCommand.cs`**

Replace the full contents of `src/FreeX.Core.Commands/InsertDeleteRowsCommand.cs`:

```csharp
using FreeX.Core.Formula;
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
    private readonly Dictionary<CellAddress, string> _formulaSnapshot = [];

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

        _movedSnapshot = sheet.EnumerateCells()
            .Where(p => p.Address.Row >= _beforeRow)
            .Select(p => (p.Address, p.Cell.Clone()))
            .ToList();

        foreach (var (addr, _) in _movedSnapshot.OrderByDescending(p => p.Addr.Row))
            sheet.ClearCell(addr);

        foreach (var (addr, cell) in _movedSnapshot)
            sheet.SetCell(new CellAddress(addr.Sheet, addr.Row + _count, addr.Col), cell.Clone());

        var hiddenToShift = sheet.HiddenRows.Where(r => r >= _beforeRow).ToList();
        foreach (var r in hiddenToShift) sheet.HiddenRows.Remove(r);
        foreach (var r in hiddenToShift) sheet.HiddenRows.Add(r + _count);

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

        _formulaSnapshot.Clear();
        RewriteAllFormulas(ctx.Workbook, new InsertRowsOp(sheet.Name, _beforeRow, _count), _formulaSnapshot);

        return new CommandOutcome(true);
    }

    public void Revert(ICommandContext ctx)
    {
        if (_movedSnapshot is null) return;
        var sheet = ctx.GetSheet(_sheetId);

        RestoreFormulas(ctx.Workbook, _formulaSnapshot);

        foreach (var (addr, _) in _movedSnapshot)
            sheet.ClearCell(new CellAddress(addr.Sheet, addr.Row + _count, addr.Col));

        foreach (var (addr, cell) in _movedSnapshot)
            sheet.SetCell(addr, cell.Clone());

        var shifted = sheet.HiddenRows.Where(r => r >= _beforeRow + _count).ToList();
        foreach (var r in shifted) sheet.HiddenRows.Remove(r);
        foreach (var r in shifted) sheet.HiddenRows.Add(r - _count);

        if (_mergeSnapshot is not null)
        {
            sheet.MergedRegions.Clear();
            sheet.MergedRegions.AddRange(_mergeSnapshot);
        }
    }

    internal static void RewriteAllFormulas(
        Workbook workbook, RewriteOperation op, Dictionary<CellAddress, string> snapshot)
    {
        foreach (var sheet in workbook.Sheets)
        {
            foreach (var (addr, cell) in sheet.EnumerateCells())
            {
                if (cell.FormulaText is null) continue;
                var rewritten = FormulaRewriter.Rewrite(cell.FormulaText, op, sheet.Name);
                if (rewritten is null) continue;
                snapshot[addr] = cell.FormulaText;
                cell.FormulaText = rewritten;
            }
        }
    }

    internal static void RestoreFormulas(
        Workbook workbook, Dictionary<CellAddress, string> snapshot)
    {
        foreach (var (addr, original) in snapshot)
        {
            var s = workbook.GetSheet(addr.Sheet);
            var cell = s?.GetCell(addr.Row, addr.Col);
            if (cell is not null)
                cell.FormulaText = original;
        }
        snapshot.Clear();
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
    private readonly Dictionary<CellAddress, string> _formulaSnapshot = [];

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

        _deletedSnapshot = sheet.EnumerateCells()
            .Where(p => p.Address.Row >= _startRow && p.Address.Row <= endRow)
            .Select(p => (p.Address, p.Cell.Clone()))
            .ToList();
        _shiftedSnapshot = sheet.EnumerateCells()
            .Where(p => p.Address.Row > endRow)
            .Select(p => (p.Address, p.Cell.Clone()))
            .ToList();

        foreach (var (addr, _) in _deletedSnapshot)
            sheet.ClearCell(addr);

        foreach (var (addr, _) in _shiftedSnapshot.OrderBy(p => p.Addr.Row))
            sheet.ClearCell(addr);
        foreach (var (addr, cell) in _shiftedSnapshot)
            sheet.SetCell(new CellAddress(addr.Sheet, addr.Row - _count, addr.Col), cell.Clone());

        var inRangeHidden = sheet.HiddenRows.Where(r => r >= _startRow && r <= endRow).ToList();
        var belowHidden   = sheet.HiddenRows.Where(r => r > endRow).ToList();
        foreach (var r in inRangeHidden) sheet.HiddenRows.Remove(r);
        foreach (var r in belowHidden) { sheet.HiddenRows.Remove(r); sheet.HiddenRows.Add(r - _count); }

        _mergeSnapshot = sheet.MergedRegions.ToList();
        sheet.MergedRegions.RemoveAll(m => m.Start.Row <= endRow && m.End.Row >= _startRow);
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

        _formulaSnapshot.Clear();
        InsertRowsCommand.RewriteAllFormulas(
            ctx.Workbook, new DeleteRowsOp(sheet.Name, _startRow, _count), _formulaSnapshot);

        return new CommandOutcome(true);
    }

    public void Revert(ICommandContext ctx)
    {
        if (_deletedSnapshot is null || _shiftedSnapshot is null) return;
        var sheet = ctx.GetSheet(_sheetId);

        InsertRowsCommand.RestoreFormulas(ctx.Workbook, _formulaSnapshot);

        foreach (var (addr, _) in _shiftedSnapshot)
            sheet.ClearCell(new CellAddress(addr.Sheet, addr.Row - _count, addr.Col));

        foreach (var (addr, cell) in _shiftedSnapshot)
            sheet.SetCell(addr, cell.Clone());

        foreach (var (addr, cell) in _deletedSnapshot)
            sheet.SetCell(addr, cell.Clone());

        if (_mergeSnapshot is not null)
        {
            sheet.MergedRegions.Clear();
            sheet.MergedRegions.AddRange(_mergeSnapshot);
        }
    }
}
```

- [ ] **Step 5: Run command tests**

```
dotnet test tests/FreeX.Core.Model.Tests --filter "FormulaRewriteCommandTests" -v normal
```

Expected: all pass.

- [ ] **Step 6: Run all tests**

```
dotnet test -v quiet
```

Expected: all pass.

- [ ] **Step 8: Commit**

```
git add src/FreeX.Core.Commands/InsertDeleteRowsCommand.cs tests/FreeX.Core.Model.Tests/FormulaRewriteCommandTests.cs
git commit -m "feat: insert/delete rows rewrites formula references across all sheets"
```

---

## Task 7: InsertColumns / DeleteColumns — call rewriter + snapshot for undo

**Files:**
- Modify: `src/FreeX.Core.Commands/InsertDeleteColumnsCommand.cs`

- [ ] **Step 1: Add tests to `FormulaRewriteCommandTests.cs`**

Append to `tests/FreeX.Core.Model.Tests/FormulaRewriteCommandTests.cs`:

```csharp
// ── InsertColumns ─────────────────────────────────────────────────────────

[Fact]
public void InsertCols_ShiftsRelativeFormulaRef()
{
    var (_, sheet, ctx) = Setup();
    sheet.SetFormula(new CellAddress(sheet.Id, 1, 1), "B1");

    new InsertColumnsCommand(sheet.Id, 2, 1).Apply(ctx);

    sheet.GetCell(1, 1)!.FormulaText.Should().Be("C1");
}

[Fact]
public void InsertCols_AbsoluteColRef_NotShifted()
{
    var (_, sheet, ctx) = Setup();
    sheet.SetFormula(new CellAddress(sheet.Id, 1, 1), "$B1");

    new InsertColumnsCommand(sheet.Id, 2, 1).Apply(ctx);

    sheet.GetCell(1, 1)!.FormulaText.Should().Be("$B1");
}

[Fact]
public void InsertCols_Undo_RestoresOriginalFormula()
{
    var (_, sheet, ctx) = Setup();
    sheet.SetFormula(new CellAddress(sheet.Id, 1, 1), "B1");

    var cmd = new InsertColumnsCommand(sheet.Id, 2, 1);
    cmd.Apply(ctx);
    cmd.Revert(ctx);

    sheet.GetCell(1, 1)!.FormulaText.Should().Be("B1");
}

// ── DeleteColumns ─────────────────────────────────────────────────────────

[Fact]
public void DeleteCols_RefInDeletedCol_BecomesRefError()
{
    var (_, sheet, ctx) = Setup();
    sheet.SetFormula(new CellAddress(sheet.Id, 1, 1), "B1");

    new DeleteColumnsCommand(sheet.Id, 2, 1).Apply(ctx);

    sheet.GetCell(1, 1)!.FormulaText.Should().Be("#REF!");
}

[Fact]
public void DeleteCols_RefRightOfDeleted_ShiftsLeft()
{
    var (_, sheet, ctx) = Setup();
    sheet.SetFormula(new CellAddress(sheet.Id, 1, 1), "D1");

    new DeleteColumnsCommand(sheet.Id, 2, 1).Apply(ctx);

    sheet.GetCell(1, 1)!.FormulaText.Should().Be("C1");
}

[Fact]
public void DeleteCols_Undo_RestoresOriginalFormula()
{
    var (_, sheet, ctx) = Setup();
    sheet.SetFormula(new CellAddress(sheet.Id, 1, 1), "D1");

    var cmd = new DeleteColumnsCommand(sheet.Id, 2, 1);
    cmd.Apply(ctx);
    cmd.Revert(ctx);

    sheet.GetCell(1, 1)!.FormulaText.Should().Be("D1");
}
```

- [ ] **Step 2: Run to confirm they fail**

```
dotnet test tests/FreeX.Core.Model.Tests --filter "InsertCols|DeleteCols" -v normal
```

Expected: FAIL.

- [ ] **Step 3: Update `InsertDeleteColumnsCommand.cs`**

Replace the full contents with:

```csharp
using FreeX.Core.Formula;
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
    private readonly Dictionary<CellAddress, string> _formulaSnapshot = [];

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

        var hiddenToShift = sheet.HiddenCols.Where(c => c >= _beforeCol).ToList();
        foreach (var c in hiddenToShift) sheet.HiddenCols.Remove(c);
        foreach (var c in hiddenToShift) sheet.HiddenCols.Add(c + _count);

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

        _formulaSnapshot.Clear();
        InsertRowsCommand.RewriteAllFormulas(
            ctx.Workbook, new InsertColsOp(sheet.Name, _beforeCol, _count), _formulaSnapshot);

        return new CommandOutcome(true);
    }

    public void Revert(ICommandContext ctx)
    {
        if (_movedSnapshot is null) return;
        var sheet = ctx.GetSheet(_sheetId);

        InsertRowsCommand.RestoreFormulas(ctx.Workbook, _formulaSnapshot);

        foreach (var (addr, _) in _movedSnapshot)
            sheet.ClearCell(new CellAddress(addr.Sheet, addr.Row, addr.Col + _count));

        foreach (var (addr, cell) in _movedSnapshot)
            sheet.SetCell(addr, cell.Clone());

        var shifted = sheet.HiddenCols.Where(c => c >= _beforeCol + _count).ToList();
        foreach (var c in shifted) sheet.HiddenCols.Remove(c);
        foreach (var c in shifted) sheet.HiddenCols.Add(c - _count);

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
    private readonly Dictionary<CellAddress, string> _formulaSnapshot = [];

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

        var inRangeHidden = sheet.HiddenCols.Where(c => c >= _startCol && c <= endCol).ToList();
        var aboveHidden   = sheet.HiddenCols.Where(c => c > endCol).ToList();
        foreach (var c in inRangeHidden) sheet.HiddenCols.Remove(c);
        foreach (var c in aboveHidden) { sheet.HiddenCols.Remove(c); sheet.HiddenCols.Add(c - _count); }

        _mergeSnapshot = sheet.MergedRegions.ToList();
        sheet.MergedRegions.RemoveAll(m => m.Start.Col <= endCol && m.End.Col >= _startCol);
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

        _formulaSnapshot.Clear();
        InsertRowsCommand.RewriteAllFormulas(
            ctx.Workbook, new DeleteColsOp(sheet.Name, _startCol, _count), _formulaSnapshot);

        return new CommandOutcome(true);
    }

    public void Revert(ICommandContext ctx)
    {
        if (_deletedSnapshot is null || _shiftedSnapshot is null) return;
        var sheet = ctx.GetSheet(_sheetId);

        InsertRowsCommand.RestoreFormulas(ctx.Workbook, _formulaSnapshot);

        foreach (var (addr, _) in _shiftedSnapshot)
            sheet.ClearCell(new CellAddress(addr.Sheet, addr.Row, addr.Col - _count));

        foreach (var (addr, cell) in _shiftedSnapshot)
            sheet.SetCell(addr, cell.Clone());

        foreach (var (addr, cell) in _deletedSnapshot)
            sheet.SetCell(addr, cell.Clone());

        if (_mergeSnapshot is not null)
        {
            sheet.MergedRegions.Clear();
            sheet.MergedRegions.AddRange(_mergeSnapshot);
        }
    }
}
```

- [ ] **Step 4: Run all command tests**

```
dotnet test tests/FreeX.Core.Model.Tests -v normal
```

Expected: all pass.

- [ ] **Step 5: Run all tests**

```
dotnet test -v quiet
```

Expected: all pass.

- [ ] **Step 6: Commit**

```
git add src/FreeX.Core.Commands/InsertDeleteColumnsCommand.cs tests/FreeX.Core.Model.Tests/FormulaRewriteCommandTests.cs
git commit -m "feat: insert/delete columns rewrites formula references across all sheets"
```

---

## Task 8: Internal clipboard + paste formula adjustment

**Files:**
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`

**Background:** `ClipboardSerializer` only stores display text. For paste formula adjustment, we add an in-memory `_internalClipboard` field that stores the raw `Cell` objects (with their formulas) alongside the source range. When pasting internally, we use these cells + apply `PasteOffsetOp`.

- [ ] **Step 1: Add `_internalClipboard` field and record to `MainWindow.xaml.cs`**

Find the field declarations section near the top of `MainWindow.xaml.cs` (look for fields like `_workbook`, `_currentSheetId`). Add:

```csharp
private record InternalClipboard(GridRange SourceRange, List<(CellAddress Source, Cell Cell)> Cells);
private InternalClipboard? _internalClipboard;
```

- [ ] **Step 2: Populate `_internalClipboard` in `ExecuteCopy`**

Find `ExecuteCopy` in `MainWindow.xaml.cs`. After the line that sets `SheetGrid.ClipboardRange = range;`, add:

```csharp
// Capture raw cells (including formulas) for paste formula adjustment
var sheet = _workbook.GetSheet(_currentSheetId);
var clipCells = new List<(CellAddress, Cell)>();
for (uint r = range.Start.Row; r <= range.End.Row; r++)
{
    for (uint c = range.Start.Col; c <= range.End.Col; c++)
    {
        var addr = new CellAddress(_currentSheetId, r, c);
        var cell = sheet?.GetCell(r, c);
        if (cell is not null)
            clipCells.Add((addr, cell.Clone()));
    }
}
_internalClipboard = new InternalClipboard(range, clipCells);
```

- [ ] **Step 3: Use `_internalClipboard` in `ExecutePaste`**

Replace the body of `ExecutePaste` in `MainWindow.xaml.cs`:

```csharp
private void ExecutePaste()
{
    if (SheetGrid.SelectedRange is not { } range) return;

    // If we have an internal clipboard (copied from within this app), use it with formula adjustment
    if (_internalClipboard is { } clip)
    {
        var edits = new List<(CellAddress, Cell)>();
        int rowDelta = (int)range.Start.Row - (int)clip.SourceRange.Start.Row;
        int colDelta = (int)range.Start.Col - (int)clip.SourceRange.Start.Col;
        var pasteOp  = new FreeX.Core.Formula.PasteOffsetOp(rowDelta, colDelta);
        var activeSheetName = _workbook.GetSheet(_currentSheetId)?.Name ?? "";

        foreach (var (sourceAddr, sourceCell) in clip.Cells)
        {
            var destAddr = new CellAddress(_currentSheetId,
                (uint)((int)sourceAddr.Row + rowDelta),
                (uint)((int)sourceAddr.Col + colDelta));

            var destCell = sourceCell.Clone();

            if (destCell.FormulaText is not null && (rowDelta != 0 || colDelta != 0))
            {
                destCell.FormulaText =
                    FreeX.Core.Formula.FormulaRewriter.Rewrite(
                        destCell.FormulaText, pasteOp, activeSheetName)
                    ?? destCell.FormulaText;
            }

            edits.Add((destAddr, destCell));
        }

        if (edits.Count > 0)
        {
            var command = new EditCellsCommand(_currentSheetId, edits);
            _commandBus.Execute(_workbook.Id, command);
            _recalcEngine.Recalculate(_workbook, edits.Select(e => e.Item1).ToList());
        }

        var pastedRowSpan = (uint)(clip.SourceRange.RowCount - 1);
        var pastedColSpan = (uint)(clip.SourceRange.ColCount - 1);
        var pastedEnd     = new CellAddress(_currentSheetId,
            range.Start.Row + pastedRowSpan,
            range.Start.Col + pastedColSpan);
        _selectionAnchor = range.Start;
        _selectionCursor = pastedEnd;
        SheetGrid.SelectedRange = new GridRange(range.Start, pastedEnd);
        SheetGrid.ClipboardRange = null;
        UpdateViewport();
        RefreshToolbar();
        return;
    }

    // Fallback: external clipboard (plain text)
    string text;
    try { text = System.Windows.Clipboard.GetText(); }
    catch { return; }
    if (string.IsNullOrEmpty(text)) return;

    var rows = ClipboardSerializer.Deserialize(text);
    var fallbackEdits = new List<(CellAddress, Cell)>();

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
            fallbackEdits.Add((addr, Cell.FromValue(val)));
        }
    }

    if (fallbackEdits.Count == 0) return;

    var fallbackCommand = new EditCellsCommand(_currentSheetId, fallbackEdits);
    _commandBus.Execute(_workbook.Id, fallbackCommand);
    _recalcEngine.Recalculate(_workbook, fallbackEdits.Select(e => e.Item1).ToList());

    uint pastedRowSpanFallback = rows.Length > 0 ? (uint)(rows.Length - 1) : 0;
    uint pastedColSpanFallback = rows.Length > 0 && rows[0].Length > 0 ? (uint)(rows[0].Length - 1) : 0;
    var pastedEndFallback = new CellAddress(_currentSheetId,
        range.Start.Row + pastedRowSpanFallback,
        range.Start.Col + pastedColSpanFallback);
    _selectionAnchor = range.Start;
    _selectionCursor = pastedEndFallback;
    SheetGrid.SelectedRange = new GridRange(range.Start, pastedEndFallback);
    SheetGrid.ClipboardRange = null;
    UpdateViewport();
    RefreshToolbar();
}
```

- [ ] **Step 4: Build**

```
dotnet build --no-incremental -v quiet
```

Expected: 0 errors, 0 warnings.

- [ ] **Step 5: Run all tests**

```
dotnet test -v quiet
```

Expected: all pass.

- [ ] **Step 6: Commit**

```
git add src/FreeX.App.Host/MainWindow.xaml.cs
git commit -m "feat: paste adjusts relative formula references by copy-to-paste offset"
```

---

## Task 9: Final verification

**Files:** none

- [ ] **Step 1: Full clean build**

```
dotnet build --no-incremental -v quiet
```

Expected: 0 errors, 0 warnings.

- [ ] **Step 2: Full test suite**

```
dotnet test -v quiet
```

Expected: all pass, no failures. New test count should be ≥ 297 + 40 = 337.

- [ ] **Step 3: Done**

All tasks complete. The build and tests passing in Steps 1-2 confirm the full implementation is correct.
