# Phase 5a — Editing UX Design Spec

**Date:** 2026-05-13  
**Goal:** Full Excel-fidelity editing experience — formatting toolbar, merged cells, autofill, right-click menus, insert/delete rows & columns, status bar.

---

## 1. Scope

This phase adds the editing surface that makes FreeX feel like a real spreadsheet rather than a read-only viewer. Everything here is pure editing UX; XLSX structural fidelity (hyperlinks, rich comments) is Phase 5b.

**In scope:**
- `ApplyStyleCommand` with `StyleDiff` partial-override pattern
- Formatting toolbar: font, size, bold/italic/underline/strikethrough, font color, fill color, alignment, wrap text, number format, merge-and-center
- Right-click context menu: cut/copy/paste, insert/delete row+column, format cells, clear contents
- Merged cells: model (`Sheet.MergedRegions`), commands (Merge/Unmerge), GridView rendering, XLSX round-trip
- Insert/delete rows and columns commands (cell-data shift only; formula-ref rewriting deferred to Phase 5b)
- Autofill: drag bottom-right handle to fill value/formula across a range
- Status bar: Sum / Count / Average / Min / Max for current selection

**Out of scope this phase:** formula ref rewriting on insert/delete, hyperlinks, comments, sparklines, pivot tables.

---

## 2. Architecture

| Layer | Change |
|---|---|
| `Core.Model` | Add `StyleDiff` record; add `Sheet.MergedRegions: List<GridRange>` |
| `Core.Commands` | New: `ApplyStyleCommand`, `InsertRowsCommand`, `DeleteRowsCommand`, `InsertColumnsCommand`, `DeleteColumnsCommand`, `MergeCellsCommand`, `UnmergeCellsCommand` |
| `Core.IO` | `XlsxFileAdapter`: save/load `MergedRegions` via ClosedXML |
| `App.UI / GridView` | Merged cell rendering; autofill handle rendering + drag; Shift+click multi-select; expose `AutofillDrag` event |
| `App.Host / MainWindow` | Formatting toolbar; right-click menu; status bar; keyboard shortcuts (Ctrl+B/I/U); `FormatCellsDialog` |

The Core ↔ App dependency rule is unchanged: no Core project references App.*.

---

## 3. StyleDiff and ApplyStyleCommand

### 3.1 StyleDiff (Core.Model)

```csharp
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
    VerticalAlignment?   VAlign = null,
    bool? WrapText       = null,
    string? NumberFormat = null
);
```

Each null field means "leave as-is." This prevents toggling Bold from accidentally resetting FontColor.

### 3.2 ApplyStyleCommand (Core.Commands)

Constructor: `ApplyStyleCommand(SheetId sheetId, GridRange range, StyleDiff diff)`

**Apply logic (per cell in range):**
1. Snapshot `(CellAddress, oldStyleId)` for all cells.
2. Resolve `CellStyle base = workbook.GetStyle(cell.StyleId)` (or `CellStyle.Default`).
3. Merge: produce `CellStyle merged` — start from `base`, override every non-null diff field.
4. `cell.StyleId = workbook.RegisterStyle(merged)` (returns existing id if already registered — no duplicates).

**Revert:** restore each cell's old `StyleId` from snapshot.

**Label:** `"Apply Style"` (always, regardless of which fields changed).

---

## 4. Merged Cells

### 4.1 Model

`Sheet.MergedRegions: List<GridRange>` — mutable list owned by sheet. Not validated at the model level; commands enforce invariants.

Helper method on `Sheet`:
```csharp
public GridRange? GetMergeRoot(CellAddress addr)
    // returns the GridRange whose Start == addr (addr is top-left of a merge),
    // or null if addr is interior to a merge,
    // or null if addr is not merged.
```
Actually simpler: two helpers:
- `bool IsMerged(CellAddress addr)` — addr appears anywhere in any region.
- `GridRange? GetMergeRegion(CellAddress addr)` — returns the region containing addr, or null.

### 4.2 MergeCellsCommand

Constructor: `MergeCellsCommand(SheetId sheetId, GridRange range)`

**Apply:**
1. Reject if `range` overlaps any existing `MergedRegion` (return `CommandOutcome(false, "Range overlaps existing merge")`).
2. Snapshot top-left cell value; snapshot all other cells in range.
3. Clear all non-top-left cells in the range.
4. Add `range` to `sheet.MergedRegions`.

**Revert:**
1. Remove `range` from `MergedRegions`.
2. Restore all snapshotted cells.

### 4.3 UnmergeCellsCommand

Constructor: `UnmergeCellsCommand(SheetId sheetId, GridRange range)`

Finds and removes the exact `GridRange` from `MergedRegions` that matches `range`. Revert re-adds it.

### 4.4 GridView Rendering

When drawing cell at `(r, c)`:
1. Check if `(r, c)` is in a merged region.
   - If yes **and** `(r, c)` == region.Start → draw the cell spanning the full merge extent (`colWidth * spanCols`, `rowHeight * spanRows`). Clip text within.
   - If yes **and** `(r, c)` != region.Start → skip drawing (the top-left already covers this pixel area).
2. Selection highlight must also be aware: selecting any cell in a merge selects the whole merge region.

### 4.5 XLSX Round-Trip

`XlsxFileAdapter.Save`: for each `GridRange` in `sheet.MergedRegions`, call `xlSheet.Range(...).Merge()`.

`XlsxFileAdapter.Load`: iterate `xlSheet.MergedRanges`, convert each to `GridRange`, add to `sheet.MergedRegions`.

---

## 5. Insert / Delete Rows and Columns

### 5.1 InsertRowsCommand

Constructor: `InsertRowsCommand(SheetId sheetId, uint beforeRow, uint count = 1)`

**Apply:**
1. Snapshot all cells with `Row >= beforeRow` (plus snapshot MergedRegions for update).
2. Move all cell entries: new row = old row + count (process in reverse order to avoid clobbering).
3. Shift MergedRegions: any region whose `Start.Row >= beforeRow` gets shifted down by count; any region straddling `beforeRow` expands by count rows.
4. Shift `sheet.HiddenRows` accordingly.

**Revert:** restore snapshot (shift back by count).

**Formula rewriting:** deferred. Cells that have formulas referencing shifted rows will produce stale results until Phase 5b adds reference adjustment.

### 5.2 DeleteRowsCommand

Constructor: `DeleteRowsCommand(SheetId sheetId, uint startRow, uint count = 1)`

**Apply:**
1. Snapshot cells in `[startRow, startRow+count)`.
2. Delete those cells.
3. Shift cells with `Row > startRow+count-1`: new row = old row - count.
4. Remove MergedRegions fully within deleted rows; shrink regions straddling the boundary.
5. Shift `HiddenRows`.

**Revert:** restore snapshot (reverse the shift).

### 5.3 InsertColumnsCommand / DeleteColumnsCommand

Mirror of InsertRows / DeleteRows for the column axis.

---

## 6. Autofill

### 6.1 Model

No new model types. Autofill operates on existing cell data.

### 6.2 Autofill Gesture

`GridView` renders a 6×6 px solid-green square at the bottom-right corner of the active-cell or selection bounding rect.

When the user `MouseDown` on that handle:
- Set `_autofillDragging = true`; capture mouse.

On `MouseMove` while dragging:
- Determine the target cell under the cursor.
- Render a dashed-border preview of the fill range.

On `MouseUp`:
- Fire `AutofillRequested` event with `(sourceRange, fillRange)`.

### 6.3 AutofillCommand (Core.Commands)

Constructor: `AutofillCommand(SheetId sheetId, GridRange sourceRange, GridRange fillRange)`

Rules:
- If `sourceRange` is a single row and the fill extends downward: fill each target row with the source row's last cell value (or formula with row-offset applied).
- If `sourceRange` is a single column extending rightward: fill each target column.
- Formula fill: for each target cell, parse formula, increment all relative row/column references by the offset, re-serialize. (Simple regex-based approach: `([A-Z]+)(\d+)` → increment number by rowOffset.) Only relative refs are shifted; absolute refs (`$A$1`) are left unchanged.
- Non-formula fill: repeat the source value.

---

## 7. Formatting Toolbar

Placed between the menu bar and the grid in `MainWindow.xaml`. Binds to `MainWindow` handlers.

### 7.1 Controls (left to right)

| Control | Type | Action |
|---|---|---|
| Font family | ComboBox | `ApplyStyleDiff(new StyleDiff(FontName: selected))` |
| Font size | ComboBox / editable | `ApplyStyleDiff(new StyleDiff(FontSize: parsed))` |
| Bold | ToggleButton (Ctrl+B) | `ApplyStyleDiff(new StyleDiff(Bold: !current))` |
| Italic | ToggleButton (Ctrl+I) | `ApplyStyleDiff(new StyleDiff(Italic: !current))` |
| Underline | ToggleButton (Ctrl+U) | `ApplyStyleDiff(new StyleDiff(Underline: !current))` |
| Strikethrough | ToggleButton | `ApplyStyleDiff(new StyleDiff(Strikethrough: !current))` |
| Font color | ColorPickerButton | `ApplyStyleDiff(new StyleDiff(FontColor: chosen))` |
| Fill color | ColorPickerButton | `ApplyStyleDiff(new StyleDiff(FillColor: chosen))` |
| Align Left | ToggleButton | `ApplyStyleDiff(new StyleDiff(HAlign: Left))` |
| Align Center | ToggleButton | `ApplyStyleDiff(new StyleDiff(HAlign: Center))` |
| Align Right | ToggleButton | `ApplyStyleDiff(new StyleDiff(HAlign: Right))` |
| Wrap Text | ToggleButton | `ApplyStyleDiff(new StyleDiff(WrapText: !current))` |
| Merge & Center | Button | `MergeCellsCommand` + `ApplyStyleDiff(HAlign: Center)` |
| Number format | ComboBox | `ApplyStyleDiff(new StyleDiff(NumberFormat: code))` |

`ApplyStyleDiff` is a private `MainWindow` helper:
```csharp
void ApplyStyleDiff(StyleDiff diff)
{
    var range = SheetGrid.SelectedRange ?? return;
    _commandBus.Execute(new ApplyStyleCommand(_currentSheetId, range, diff));
    Refresh();
}
```

Toolbar state (bold indicator lit, font name displayed) refreshes on `SelectionChanged` by reading the style of the top-left cell in the selection.

### 7.2 Color picker

Simple popup containing a 10×6 color palette grid (standard Excel colors). Selecting a color closes the popup and fires the command. "More colors..." opens a `System.Windows.Media.Color` dialog.

### 7.3 Number format codes

| Label | Format string |
|---|---|
| General | (empty) |
| Number | `0.00` |
| Currency | `$#,##0.00` |
| Percentage | `0%` |
| Date | `yyyy-MM-dd` |
| Time | `HH:mm:ss` |
| Text | `@` |

---

## 8. Right-Click Context Menu

`GridView` exposes `ContextMenuRequested` event (fired on right `MouseDown` with the clicked `CellAddress`). `MainWindow` subscribes and opens a `ContextMenu`:

```
Cut              (Ctrl+X)
Copy             (Ctrl+C)
Paste            (Ctrl+V)
─────────────────
Insert Row Above
Insert Row Below
Insert Column Left
Insert Column Right
─────────────────
Delete Row(s)
Delete Column(s)
─────────────────
Format Cells...
─────────────────
Clear Contents
```

**Format Cells dialog** (`FormatCellsDialog`) — modal WPF dialog with tabs:
- **Number**: format code (same as toolbar dropdown + free-text entry)
- **Alignment**: HAlign, VAlign, WrapText, Merge
- **Font**: FontName, FontSize, Bold, Italic, Underline, Strikethrough, FontColor
- **Fill**: FillColor

On OK, dispatches `ApplyStyleCommand` with a fully-composed `StyleDiff`.

---

## 9. Status Bar

Thin strip at the bottom of `MainWindow`. Displays for current selection (recalculates on `SelectionChanged`):

```
Ready    |  Sum: 1,234    Count: 10    Average: 123.4    Min: 5    Max: 200
```

Only shown when the selection contains at least one numeric value. Blank / text cells excluded from Sum/Average/Min/Max but included in Count.

Implementation: `StatusBarCalculator` static helper in `App.Host`:
```csharp
StatusBarStats Calculate(Sheet sheet, GridRange range)
```

Returns: `Sum, Count, Average?, Min?, Max?` (Average/Min/Max nullable — null if no numeric cells).

---

## 10. Error Handling

- `ApplyStyleCommand` on an empty selection: no-op (range validation in `MainWindow.ApplyStyleDiff`).
- `MergeCellsCommand` overlap: returns `CommandOutcome(false, ...)`. `MainWindow` shows `MessageBox` with the error.
- `InsertRowsCommand` beyond sheet bounds (row > 1,048,576): return `CommandOutcome(false, ...)`.
- `AutofillCommand` with `fillRange` not adjacent to `sourceRange`: return `CommandOutcome(false, ...)`.

---

## 11. Testing Strategy

All new commands get unit tests in `FreeX.Core.Commands.Tests` (or existing model/calc test projects).

### 11.1 `ApplyStyleCommandTests`
- Single cell: Bold applied, others unchanged.
- Range: all cells in range get new style.
- Undo: original styles restored.
- Null fields: applying `StyleDiff(Bold: true)` does not change FontColor.

### 11.2 `MergeCellsCommandTests`
- Merge, then verify `GetMergeRegion` returns region.
- Undo removes region, restores cell values.
- Overlap rejected with `Success = false`.

### 11.3 `InsertRowsCommandTests`
- Insert 1 row: cells shifted down correctly.
- Undo: cells shifted back.
- MergedRegion shifts with data.

### 11.4 `DeleteRowsCommandTests`
- Delete 1 row: deleted cells gone, rest shifted up.
- Undo: deleted cells restored.

### 11.5 `AutofillCommandTests`
- Fill constant value down: all target cells have source value.
- Fill formula down: row references incremented per offset.
- Fill absolute formula: `$A$1` not modified.

### 11.6 `XlsxMergedCellsRoundTripTests`
- Merge A1:B2, save to XLSX, reload, verify `MergedRegions` contains A1:B2.

### 11.7 `InsertColumnsCommandTests` / `DeleteColumnsCommandTests`
- Mirror of row tests for the column axis.

---

## 12. Implementation Notes

- `StyleDiff` lives in `Core.Model` (it is a pure data record with no App dependencies).
- `Sheet.MergedRegions` — initialized to `[]` (empty list) so existing code that doesn't use it is unaffected.
- `InsertRowsCommand` processes rows in **descending** order to avoid overwriting data during the shift.
- Formula increment in `AutofillCommand` uses a regex `([A-Z]{1,3})(\d{1,7})` to find relative cell references; does not touch `$`-prefixed parts.
- The color picker is a simple inline control (no external library); a `Popup` containing a `UniformGrid` of `Button`s with colored backgrounds is sufficient for Phase 5a.
- `FormatCellsDialog` is a new WPF Window in `App.Host`.
- Toolbar toggle-button state (Bold indicator, etc.) must be refreshed after `SetActiveCell` — read `CellStyle` for the top-left of selection and update accordingly without triggering command dispatch. Use a `bool _suppressToolbarSync` field: set it to `true` before updating toolbar controls, then `false` after; all toolbar event handlers return early when it's `true`.
- Shift+click multi-select: in `GridView.MouseDown`, if `Shift` is held, extend `SelectedRange` to form a rectangle from the existing `SelectedRange.Start` to the clicked cell, rather than starting a new single-cell selection.
