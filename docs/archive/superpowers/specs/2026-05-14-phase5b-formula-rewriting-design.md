# Phase 5b — Formula Reference Rewriting Design Spec

**Date:** 2026-05-14
**Goal:** Full Excel-fidelity formula reference rewriting — absolute/relative $-anchors preserved, references updated on insert/delete rows/columns across all sheets, and relative references adjusted on paste.

---

## 1. Scope

**In scope:**
- Preserve `$`-anchor information in the lexer and AST (`$A$1`, `A$1`, `$A1`, `A1` all distinct)
- `FormulaSerializer`: AST → formula string (inverse of `Parser`)
- `FormulaRewriter`: rewrite formula references for insert/delete rows/cols and paste offset
- Insert/Delete row/column commands call the rewriter on all cells in all sheets; undo restores originals
- Paste adjustment: relative refs shift by paste offset, absolute refs stay fixed

**Out of scope:**
- Named range rewriting (if a named range covers a deleted row, that is a separate problem)
- Dynamic array spill (Phase 5c)
- Formula trace / auditing UI (future)

---

## 2. North-star principle

Every rewrite rule in this phase must match Excel's behavior exactly. When in doubt, test in Excel and match the result — including `#REF!` on deletion of a referenced cell.

---

## 3. Architecture

| Layer | Change |
|---|---|
| `Core.Formula/Lexer.cs` | Stop stripping `$` from `CellRef` tokens |
| `Core.Formula/FormulaNode.cs` | Add `IsColAbsolute`, `IsRowAbsolute` to `CellRefNode`; add `ErrorNode` if not present |
| `Core.Formula/Parser.cs` | Extract `$` flags in `ParseCellRef` |
| `Core.Formula/FormulaSerializer.cs` | **New** — AST → string |
| `Core.Formula/FormulaRewriter.cs` | **New** — rewrite CellRefNodes per operation |
| `Core.Commands/InsertDeleteRowsCommand.cs` | Call rewriter after shifting; snapshot formulas for undo |
| `Core.Commands/InsertDeleteColumnsCommand.cs` | Same |
| `App.Host/MainWindow.xaml.cs` | Apply `PasteOffsetOp` after deserializing clipboard cells |

No `Core.*` project references any `App.*` project. The rewriter lives entirely in `Core.Formula`.

---

## 4. Lexer change

`Lexer.cs` currently strips `$` before emitting a `TokenType.CellRef` token:

```csharp
// BEFORE (strips $):
value.Replace("$", "").ToUpperInvariant()

// AFTER (preserve $):
value.ToUpperInvariant()   // keep $ in token value, e.g. "$B$3"
```

The token value for an absolute ref becomes e.g. `"$B$3"`, `"$B3"`, `"B$3"`.

---

## 5. AST node changes

### 5.1 CellRefNode

```csharp
public record CellRefNode(
    string  ColumnName,
    uint    Row,
    bool    IsColAbsolute,   // true when $ precedes the column letter
    bool    IsRowAbsolute,   // true when $ precedes the row number
    string? SheetName = null
) : FormulaNode;
```

Computed helper (keep existing):
```csharp
public uint ColumnNumber => CellAddress.ColumnNameToNumber(ColumnName);
```

### 5.2 ErrorNode

Add if not already present:

```csharp
public record ErrorNode(ErrorValue Error) : FormulaNode;
```

`FormulaSerializer` renders this as the error code string (e.g. `#REF!`). The evaluator already handles `ErrorValue` — it just needs to recognise `ErrorNode` and return the value directly.

### 5.3 RangeRefNode

No change needed. `Start` and `End` are already `CellRefNode`s that now carry the absolute flags.

---

## 6. Parser changes

`ParseCellRef` currently ignores `$`. Updated logic:

```csharp
private static CellRefNode ParseCellRef(Token token)
{
    var value = token.Value;   // e.g. "$B$3"
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

`ParseCellRefWithSheet` calls `ParseCellRef` and adds `SheetName` via `with` — no change needed there.

---

## 7. FormulaSerializer

New static class in `Core.Formula`:

```csharp
public static class FormulaSerializer
{
    public static string Serialize(FormulaNode node);
}
```

### Serialization rules

| Node | Output |
|---|---|
| `NumberNode(v)` | `v.ToString(InvariantCulture)` |
| `StringNode(s)` | `"\"" + s.Replace("\"","\"\"") + "\""` |
| `BooleanNode(b)` | `"TRUE"` / `"FALSE"` |
| `ErrorNode(e)` | `e.Code` e.g. `"#REF!"` |
| `CellRefNode` | `($)ColName($)Row` with optional `SheetName!` prefix |
| `RangeRefNode` | `SheetName!Start:End` or `Start:End` |
| `NamedRangeNode(n)` | `n` |
| `FunctionCallNode(name, args)` | `NAME(arg1,arg2,...)` |
| `BinaryOpNode(l, op, r)` | `l OP r` — operator symbol from lookup table below |
| `UnaryOpNode(Negate, e)` | `"-" + e` |
| `UnaryOpNode(Percent, e)` | `e + "%"` |

Binary operator symbol lookup:

| BinaryOperator | Symbol |
|---|---|
| Add | `+` |
| Subtract | `-` |
| Multiply | `*` |
| Divide | `/` |
| Power | `^` |
| Concatenate | `&` |
| Equal | `=` |
| NotEqual | `<>` |
| LessThan | `<` |
| GreaterThan | `>` |
| LessOrEqual | `<=` |
| GreaterOrEqual | `>=` |

The serializer does **not** prepend `=`. Callers store `cell.FormulaText = serialized` (without `=`, matching existing convention).

---

## 8. FormulaRewriter

New static class in `Core.Formula`:

```csharp
public static class FormulaRewriter
{
    /// Rewrites all CellRefNodes in formulaText according to op.
    /// hostSheetName: the sheet the cell lives on (used to match sheet-unqualified refs).
    /// Returns null if no refs were changed (caller can skip write-back).
    public static string? Rewrite(string formulaText, RewriteOperation op, string hostSheetName);
}
```

### 8.1 RewriteOperation discriminated union

```csharp
public abstract record RewriteOperation;
public sealed record InsertRowsOp(string SheetName, uint BeforeRow, uint Count) : RewriteOperation;
public sealed record DeleteRowsOp(string SheetName, uint StartRow,  uint Count) : RewriteOperation;
public sealed record InsertColsOp(string SheetName, uint BeforeCol, uint Count) : RewriteOperation;
public sealed record DeleteColsOp(string SheetName, uint StartCol,  uint Count) : RewriteOperation;
public sealed record PasteOffsetOp(int RowDelta, int ColDelta)                  : RewriteOperation;
```

### 8.2 CellRefNode rewrite rules

**Sheet matching:** a `CellRefNode` is only adjusted when:
- Its `SheetName` matches the operation's `SheetName` (case-insensitive), OR
- Its `SheetName` is null AND the `hostSheetName` matches the operation's `SheetName` (case-insensitive).
- `PasteOffsetOp` has no `SheetName` — it always adjusts (paste is always within one sheet context).

**Row adjustments (InsertRowsOp / DeleteRowsOp):**

| Condition | Action |
|---|---|
| `IsRowAbsolute` | No change to row |
| `InsertRowsOp`: relative row ≥ `BeforeRow` | `row += Count` |
| `DeleteRowsOp`: relative row in `[StartRow, StartRow+Count-1]` | Replace node with `ErrorNode(ErrorValue.Ref)` |
| `DeleteRowsOp`: relative row > `StartRow+Count-1` | `row -= Count` |

**Column adjustments (InsertColsOp / DeleteColsOp):** identical logic applied to `ColumnNumber` / `ColumnName`.

**PasteOffsetOp:**

| Condition | Action |
|---|---|
| `IsRowAbsolute` | No change to row |
| `IsColAbsolute` | No change to col |
| Relative row | `row += RowDelta`; if result < 1 or > MaxRow → `ErrorNode(ErrorValue.Ref)` |
| Relative col | `col += ColDelta`; if result < 1 or > MaxCol → `ErrorNode(ErrorValue.Ref)` |

**RangeRefNode:** rewrite `Start` and `End` independently. If either becomes `ErrorNode`, replace the whole `RangeRefNode` with `ErrorNode(ErrorValue.Ref)`.

### 8.3 Implementation sketch

```csharp
private static FormulaNode RewriteNode(FormulaNode node, RewriteOperation op, string hostSheetName)
{
    return node switch
    {
        CellRefNode cr  => RewriteCellRef(cr, op, hostSheetName),
        RangeRefNode rr => RewriteRange(rr, op, hostSheetName),
        BinaryOpNode b  => b with { Left = RewriteNode(b.Left, op, hostSheetName),
                                    Right = RewriteNode(b.Right, op, hostSheetName) },
        UnaryOpNode u   => u with { Operand = RewriteNode(u.Operand, op, hostSheetName) },
        FunctionCallNode f => f with { Args = f.Args.Select(a => RewriteNode(a, op, hostSheetName)).ToList() },
        _ => node   // NumberNode, StringNode, BooleanNode, NamedRangeNode — unchanged
    };
}
```

---

## 9. Command integration

### 9.1 Shared helper

A `static` helper added to `InsertDeleteRowsCommand.cs` (and duplicated/shared with columns):

```csharp
internal static void RewriteAllFormulas(
    Workbook workbook,
    RewriteOperation op,
    Dictionary<CellAddress, string> snapshot)
{
    foreach (var sheet in workbook.Sheets)
    foreach (var cell in sheet.AllCells())
    {
        if (cell.FormulaText is null) continue;
        var rewritten = FormulaRewriter.Rewrite(cell.FormulaText, op, sheet.Name);
        if (rewritten is null) continue;
        var addr = new CellAddress(sheet.Id, cell.Row, cell.Col);
        snapshot[addr] = cell.FormulaText;   // save original for undo
        cell.FormulaText = rewritten;
    }
}
```

`Sheet.AllCells()` is an existing or trivially-added method that enumerates all non-null cells.

### 9.2 InsertRowsCommand

```csharp
// Apply — after existing cell-shifting logic:
var op = new InsertRowsOp(sheet.Name, _beforeRow, _count);
RewriteAllFormulas(workbook, op, _formulaSnapshot);

// Revert — before existing cell-un-shifting logic:
foreach (var (addr, original) in _formulaSnapshot)
    workbook.GetSheet(addr.Sheet)?.GetCell(addr.Row, addr.Col)
        ?.SetFormula(original);
_formulaSnapshot.Clear();
```

Same pattern applies to `DeleteRowsCommand`, `InsertColumnsCommand`, `DeleteColumnsCommand`.

### 9.3 Cell.SetFormula

`Cell` needs a `SetFormula(string? text)` method (or a settable `FormulaText` property) to support the undo write-back. If `FormulaText` is already a settable auto-property this is a no-op.

---

## 10. Paste adjustment

In `MainWindow.ExecutePaste`, after the existing clipboard deserialization loop, for each pasted cell with a formula:

```csharp
// sourceAddr is the original address stored in ClipboardSerializer payload
int rowDelta = (int)destRow - (int)sourceAddr.Row;
int colDelta = (int)destCol - (int)sourceAddr.Col;
if (rowDelta != 0 || colDelta != 0)
{
    var op = new PasteOffsetOp(rowDelta, colDelta);
    cell.FormulaText = FormulaRewriter.Rewrite(cell.FormulaText, op, activeSheet.Name)
                       ?? cell.FormulaText;
}
```

`ClipboardSerializer` already stores `CellAddress` per cell — no format change needed.

---

## 11. Error handling

- **Parse failure during rewrite:** if a cell's `FormulaText` fails to parse (malformed formula stored from an older version), `Rewrite` catches the exception and returns `null` — the formula is left unchanged rather than corrupted.
- **Out-of-bounds after paste offset:** row < 1, row > 1,048,576, col < 1, or col > 16,384 → `ErrorNode(ErrorValue.Ref)`, matching Excel.
- **Delete of a referenced cell:** `ErrorNode(ErrorValue.Ref)`, matching Excel.

---

## 12. Tests

New test classes:

| Class | What it covers |
|---|---|
| `FormulaSerializerTests` | Round-trip: parse then serialize returns original string for all node types; $-anchors preserved |
| `FormulaRewriterTests` | Each `RewriteOperation` type; relative vs absolute; cross-sheet matching; #REF! on deletion; bounds clamping on paste |
| `InsertDeleteRowsRewriteTests` | Insert/delete rows rewrites formulas on same sheet and other sheets; undo restores originals |
| `InsertDeleteColsRewriteTests` | Same for columns |
| `PasteFormulaAdjustmentTests` | Paste with offset adjusts relative refs; absolute refs unchanged |

Minimum test count target: 40 tests across all new classes.
