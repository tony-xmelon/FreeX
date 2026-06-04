# FreeX Comprehensive Source Review

**Date:** 2026-05-28
**Scope:** `src/` only (1,166 .cs files, ~640 KLOC). Tests excluded.
**Reviewer note:** This is a fresh architectural review separate from the running fix log in `reviews/code-review-log.md`. That file tracks refactor-by-refactor file-split work; this document instead catalogs *new* improvement areas across architecture, performance, stability, consistency, reliability, threading, security, and maintainability.

---

## 1. Executive Summary

FreeX is a structurally ambitious WPF spreadsheet that has converged on a layered design (Model → IO → Calc/Formula → Commands → UI → Host) with strong parity-test coverage. The codebase is internally consistent and culture-safe (442 `InvariantCulture` usages vs. only ~11 raw `Parse` calls, all of which use invariant explicitly), and recent refactor sweeps have done well to extract planners from WPF code-behind.

However, the project has accumulated a set of cross-cutting risks that test coverage does **not** surface:

- **The hot rendering and recalc paths allocate aggressively** — per-frame brush/pen/typeface dictionaries, per-cell `FormattedText`, per-`GetStyle` `Clone()`, per-binary-op `ScalarValue[,]`, and per-formula-cell range expansion to individual deps.
- **`XlsxFileAdapter` silently swallows exceptions** during print-area, conditional-format, data-validation, merge, and named-range load. The only signal is `Debug.WriteLine`, which is stripped in Release. Round-trip fidelity loss is invisible to the user.
- **`CommandBus` is not thread-safe**, `Revert` is not guarded, and `Redo` re-runs `Apply` (re-allocating snapshots).
- **`Workbook` and `Sheet` are god objects** (445 / 786 lines) with public-mutable collections that bypass validation.
- **`CellStyle.Equals` / `GetHashCode` exclude `NativeDifferentialAttributes`** — two styles that differ only in preserved native XML hash-collide into one registry entry, silently losing the fidelity that field exists to preserve.
- **No formula recursion depth limit**, no async recalc, single-threaded throughout.
- **Worksheet/workbook protection passwords are stored and serialized as plain strings** (`Workbook.cs:209`, `Sheet.cs`, `NativeJsonAdapter.Save.cs:33`).

The findings below are ranked by severity. Top-priority items are gathered in §11.

---

## 2. Architecture

### 2.1 God-object models with public-mutable collections

[Sheet.cs](../../src/FreeX.Core.Model/Sheet.cs) at 786 lines bundles cells, comments, hyperlinks, three header/footer picture sets, all page-setup metadata, view state, protection, charts, pivots, tables, drawings, sparklines, conditional formats, data validations, outline levels, page breaks, and twelve `WorksheetXxxMetadataModel` "native attribute" bags.

[Workbook.cs](../../src/FreeX.Core.Model/Workbook.cs) at 445 lines exposes:

```csharp
public Dictionary<string, GridRange> NamedRanges { get; } = new(...);                  // line 105
public Dictionary<string, NamedRangeMetadata> NamedRangeMetadataByName { get; } = ...; // line 109
public List<PivotCacheModel> PivotCaches { get; } = [];
public List<SlicerModel> Slicers { get; } = [];
// ... many more
```

Callers can bypass `DefineNamedRange`'s validation by writing directly into the dictionary, and the two parallel dictionaries can drift apart. Same shape applies to `Sheet.Charts`, `Sheet.PivotTables`, etc. — every mutation point is an opportunity for invariant violation.

**Recommendation:** Expose `IReadOnlyDictionary<...>` / `IReadOnlyList<...>` and mutate via methods. Group page-setup, header/footer, and print options into a `WorksheetPrintSettings` sub-aggregate; group drawing kinds (charts/pictures/shapes/textboxes/sparklines) into a `SheetDrawingsCollection`.

### 2.2 `RemoveSheet` leaves dangling references

[Workbook.RemoveSheet](../../src/FreeX.Core.Model/Workbook.cs#L346-L353):

```csharp
public bool RemoveSheet(SheetId sheetId)
{
    var idx = _sheets.FindIndex(s => s.Id == sheetId);
    if (idx < 0) return false;
    _sheets.RemoveAt(idx);
    _sheetById.Remove(sheetId);
    return true;
}
```

Does not:
- Purge named ranges whose `GridRange.Start.Sheet` matches the removed sheet
- Update `ActiveSheetIndex` / `FirstVisibleSheetIndex` if they pointed at this sheet or one past it
- Clear external-link or pivot-cache references to the removed sheet
- Notify the recalc engine to clear dependency edges into the removed sheet

The result: workbooks with a deleted sheet can save with stale named-range entries pointing at a non-existent `SheetId`, surfacing later as `#REF!` after reload.

### 2.3 Twelve near-identical `WorksheetXxxMetadataModel` classes

`WorksheetProtectionMetadataModel`, `WorksheetPageSetupMetadataModel`, `WorksheetPrintOptionsMetadataModel`, `WorksheetSheetFormatMetadataModel`, `WorksheetDimensionMetadataModel`, `WorksheetSheetPropertiesMetadataModel`, `WorksheetPrimaryViewMetadataModel`, `WorksheetPageBreaksMetadataModel`, `WorksheetCellWatchesMetadataModel`, `WorksheetIgnoredErrorsMetadataModel`, `WorksheetPageMarginsMetadataModel`, `WorksheetHeaderFooterMetadataModel` are all variations on `{ Dictionary<string,string> NativeAttributes; List<string> NativeChildXmls; }` with the occasional second dictionary for per-child attributes.

**Recommendation:** A single `NativeXmlPreserveBag(NativeAttributes, NativeChildXmls, NestedBags)` would collapse twelve types into one, simplify the IO mappers, and make it easy to add new preservation surfaces without inventing yet another model class.

### 2.4 MainWindow.xaml.cs is sliced into 30+ partials that still share the same class

App.Host has 30+ `MainWindow.*.cs` files (`MainWindow.ChartCommands.cs` 930 lines, `MainWindow.Ribbon.cs` 909 lines, `MainWindow.PivotCommands.cs` 866, `MainWindow.RibbonAdaptive.cs` 865, `MainWindow.Selection.cs` 793, `MainWindow.HomeFormatting.cs` 751, `MainWindow.Editing.cs` 737, `MainWindow.CellsCommands.cs` 691, ...). All access the same private fields (`_workbook`, `_currentSheetId`, etc.) and run on the same WPF type instance.

The partial-class split solves a file-size problem but not a coupling problem: any change to "active sheet" or "selection" mental model can break code in any of the 30 files. The 76 direct `MessageBox.Show(this, ...)` calls scattered across 48 dialog files are a symptom — the host has no abstraction for user messaging.

**Recommendation:** Move stateful command handling into controllers (`ChartController`, `RibbonController`, `SelectionController`) that take dependencies via constructor and expose testable methods. Introduce an `IUserMessageService` interface so dialog flows can be unit-tested without WPF.

### 2.5 No event-driven model

Mutations to `Sheet` and `Workbook` do not raise events. UI invalidation is therefore triggered explicitly from each command/dialog by calls into `MainWindow.Viewport.cs` / `UpdateViewport`. This makes it easy to forget invalidation after a programmatic mutation (e.g. paste-from-clipboard), and impossible to add observers (autosave, diagnostics, multi-window sync) without modifying every mutation site.

**Recommendation:** Introduce `Sheet.CellsChanged`, `Sheet.StructureChanged`, `Workbook.SheetsChanged` events. Have GridView subscribe and invalidate. Commands continue to mutate the model directly.

### 2.6 Native JSON serialization uses `WriteIndented = true` and a fresh options instance per save

[NativeJsonAdapter.Save.cs:283](../../src/FreeX.Core.IO/NativeJsonAdapter.Save.cs#L283):

```csharp
JsonSerializer.Serialize(stream, dto, new JsonSerializerOptions { WriteIndented = true });
```

Two issues:
- **`WriteIndented = true` doubles or triples file size** on workbook-scale data (every nested DTO has whitespace + newlines per property). For a workbook with thousands of cells, this is a real disk-space and load-time cost.
- **`new JsonSerializerOptions(...)` per call** bypasses the reflection cache that `JsonSerializer` keeps keyed on the options instance. First-use cost is repaid every time.

**Recommendation:** `private static readonly JsonSerializerOptions s_options = new() { WriteIndented = false };`. If pretty-printing for debugging is wanted, expose it as an option, not the default.

---

## 3. Performance

### 3.1 Per-frame allocations in `GridView.RenderCells`

[GridView.Rendering.cs:163-174](../../src/FreeX.App.UI/GridView.Rendering.cs#L163-L174):

```csharp
private void RenderCells(DrawingContext dc)
{
    var styleLookup = Viewport!.Cells.Where(c => c.Style != null).ToDictionary(...);
    var rowLookupAll = Viewport.RowMetrics.ToDictionary(r => r.Row);
    var colLookupAll = Viewport.ColMetrics.ToDictionary(c => c.Col);
    var pixelsPerDip = VisualTreeHelper.GetDpi(this).PixelsPerDip;
    var brushCache = new Dictionary<CellColor, SolidColorBrush>();
    var borderPenCache = new Dictionary<CellBorder, Pen>();
    var typefaceCache = new Dictionary<CellTypefaceKey, Typeface>();
```

Every paint cycle (which fires on scroll, resize, focus change, selection change) allocates four dictionaries and rebuilds the row/col lookups. The brush cache is throwaway: identical colors across frames re-allocate `SolidColorBrush` instances.

**Recommendation:** Promote the brush/pen/typeface caches to class-level `Dictionary` fields and invalidate them only when the workbook theme changes. Build `rowLookup` / `colLookup` once per viewport update, not per render. Pre-freeze the shared brushes/pens so WPF can skip per-paint dispatcher checks.

### 3.2 `FormattedText` per cell, per render

[GridView.Rendering.cs:123](../../src/FreeX.App.UI/GridView.Rendering.cs#L123) and four other call sites construct `new FormattedText(...)` per cell. For shrink-to-fit ([GridView.Rendering.cs:112-119](../../src/FreeX.App.UI/GridView.Rendering.cs#L112-L119)), `ResolveShrinkFontSize` calls `measureTextWidth(size)` in a loop, each iteration building another `FormattedText`.

A typical viewport renders ~200 visible cells; with shrink-to-fit common in financial sheets, that becomes ~1k–10k `FormattedText` allocations per frame.

**Recommendation:** Cache `FormattedText` keyed on `(text, typeface, fontSize, brush)`. For shrink-to-fit specifically, measure once with a thin geometry/glyph-typeface path instead of constructing a full `FormattedText` per probe size.

### 3.3 `Workbook.GetStyle` clones on every call

[Workbook.cs:394-398](../../src/FreeX.Core.Model/Workbook.cs#L394-L398):

```csharp
public CellStyle GetStyle(StyleId id)
{
    int idx = id.Value;
    return (idx >= 0 && idx < _styles.Count ? _styles[idx] : _styles[0]).Clone();
}
```

Rendering calls `GetStyle` indirectly through `Viewport.Cells[i].Style` resolution. Every visible cell forces a `CellStyle.Clone()` — a 30-property deep copy — every paint. The defensive `Clone()` exists so callers cannot mutate registry state, but the right answer is to make `CellStyle` immutable (record-style) and return references directly.

**Recommendation:** Convert `CellStyle` to a `record` with `init`-only setters, or expose an `IReadOnlyCellStyle` interface for read paths and a `Builder` for mutations. Eliminate per-`GetStyle` allocation entirely.

### 3.4 `CellStyle` mutability collides with its use as a `Dictionary` key

[Workbook.cs:93-94](../../src/FreeX.Core.Model/Workbook.cs#L93-L94):

```csharp
private readonly List<CellStyle> _styles = [CellStyle.Default];
private readonly Dictionary<CellStyle, int> _styleIndex = new() { [CellStyle.Default] = 0 };
```

`CellStyle` is a mutable class but used as a dictionary key. `RegisterStyle` calls `Clone()` before insertion to mitigate this, but the property setters are still publicly exposed (`s.Bold = ...` in [CellStyle.cs:358-399](../../src/FreeX.Core.Model/CellStyle.cs#L358-L399) inside `StyleDiff.ApplyTo`). A future code change that mutates a registered style after registration would corrupt the dictionary's hash bucket.

**Recommendation:** Combine with §3.3 — make `CellStyle` truly immutable.

### 3.5 `FormulaEvaluator` allocates `List<ScalarValue>` per function call

[FormulaEvaluator.cs:419](../../src/FreeX.Core.Formula/FormulaEvaluator.cs#L419):

```csharp
var expandedArgs = new List<ScalarValue>();
for (var argIndex = 0; argIndex < node.Arguments.Count; argIndex++)
```

Every `SUM(A1:A10, B1:B10)` allocates a `List<ScalarValue>`. For workbooks with thousands of formula cells, recalc thrashes the GC. Compounded with `ElementwiseOp` allocating `ScalarValue[rowCount, colCount]` per binary range op ([FormulaEvaluator.cs:242](../../src/FreeX.Core.Formula/FormulaEvaluator.cs#L242), [FormulaEvaluator.cs:254](../../src/FreeX.Core.Formula/FormulaEvaluator.cs#L254)).

**Recommendation:** Use `ArrayPool<ScalarValue>` and `PooledList<>` for transient evaluator buffers. For broadcast operations, materialize lazily via a struct enumerator that yields `(row, col, value)` triples — most binary ops then need only one scalar slot at a time.

### 3.6 `RecalcEngine.CollectReferences` expands ranges to individual cells

[RecalcEngine.cs:252-258](../../src/FreeX.Core.Calc/RecalcEngine.cs#L252-L258):

```csharp
for (var r = r0; r <= r1; r++)
    for (var c = c0; c <= c1; c++)
        refs.Add(new CellAddress(targetSheet.Id, r, c));
```

A formula `=SUM(A:A)` (full column reference) expands into 1,048,576 individual `CellAddress` entries in the dependency graph. Every formula that touches a full column or full row pays this cost. The graph itself, plus per-cell hash lookups when downstream cells change, becomes a major bottleneck on large workbooks.

**Recommendation:** Store dependency edges as `(SheetId, GridRange)` ranges rather than per-cell addresses. The graph then resolves "does change to A5 affect anyone?" by iterating ranges and testing containment. This matches how Excel's recalc engine has worked since the 90s.

### 3.7 Recalc is single-threaded

[RecalcEngine.cs:14](../../src/FreeX.Core.Calc/RecalcEngine.cs#L14):

```csharp
// Single-threaded only. If multi-threaded recalc is added (Phase 4), protect with a lock.
private readonly HashSet<CellAddress> _volatileCells = [];
```

The dep graph already produces a topological plan; independent groups can recalc in parallel. Single-threaded recalc is acceptable for small sheets but is a UX cliff for ~50k-formula workbooks.

**Recommendation:** Parallelize across topological levels using `Parallel.ForEach` once per level (cells within a level have no dependencies on each other by definition). Guard `_volatileCells` with the existing private accessors.

### 3.8 `OpenWorkbookLoader` materializes the entire file into memory

[OpenWorkbookLoader.cs:28-56](../../src/FreeX.App.Host/OpenWorkbookLoader.cs#L28-L56):

```csharp
var bytes = await ReadFileBytesWithProgressAsync(path, progress);
// ...
using var inspectStream = new MemoryStream(bytes, writable: false);
// ...
using var loadStream = new MemoryStream(bytes, writable: false);
return adapter.Load(loadStream);
```

A 1 GB XLSX (rare but real for analytics dumps) allocates 1 GB of `byte[]` plus two `MemoryStream` wrappers. The inspect → load handoff also walks the byte buffer twice.

**Recommendation:** Stream directly from a `FileStream` with progress reported via `Stream.Read` byte counts. Cache the inspect-vs-load distinction at the adapter layer (the inspector should accept a peekable stream or close-and-reopen).

---

## 4. Stability & Reliability

### 4.1 `XlsxFileAdapter` silently swallows multiple data-loss exceptions

[XlsxFileAdapter.cs:271-379](../../src/FreeX.Core.IO/XlsxFileAdapter.cs):

```csharp
try { XlsxWorksheetPageSetupMapper.LoadPrintArea(xlSheet, sheet); }
catch (Exception ex) { System.Diagnostics.Debug.WriteLine($"[XlsxFileAdapter] Print-area load failed: {ex.Message}"); }
// ...
try { XlsxConditionalFormatClosedXmlMapper.Load(xlSheet, sheet, ...); }
catch (Exception ex) { System.Diagnostics.Debug.WriteLine($"[XlsxFileAdapter] CF load failed: {ex.Message}"); }
// ...
try { XlsxDataValidationClosedXmlMapper.Load(xlSheet, sheet); }
catch (Exception ex) { System.Diagnostics.Debug.WriteLine($"[XlsxFileAdapter] DV load failed: {ex.Message}"); }
// ...
try { LoadMergedRegions(xlSheet, sheet); }
catch (Exception ex) { System.Diagnostics.Debug.WriteLine($"[XlsxFileAdapter] Merge load failed: {ex.Message}"); }
// ...
try { XlsxNamedRangeMapper.Load(xlWorkbook, workbook); }
catch (Exception ex) { System.Diagnostics.Debug.WriteLine($"[XlsxFileAdapter] Named-range load failed: {ex.Message}"); }
```

These are best-effort sections that catch all `Exception`s and log to `Debug.WriteLine` — which is stripped from Release builds. A user opens an XLSX, sees no error, saves it back, and silently loses print areas, conditional formats, data validations, merges, or named ranges. The "open succeeded" telemetry event (`workbook_opened`, [MainWindow.Backstage.cs:282](../../src/FreeX.App.Host/MainWindow.Backstage.cs#L282)) fires regardless.

**Recommendation:**
1. Replace `Debug.WriteLine` with a structured diagnostic event that the host renders in `ShowUnsupportedXlsxFeatureOpenWarningIfNeeded` — or a new "Some features could not be loaded" notice.
2. Surface the per-feature failure list in the file's diagnostic report so the user can decide whether to re-save (which would *commit* the loss).
3. Consider promoting some of these to required (named ranges in particular — silent loss of `Names` is a serious fidelity problem).

### 4.2 `FreeXOptions` save/load failures are silent

[FreeXOptions.cs:59,71](../../src/FreeX.App.Host/FreeXOptions.cs#L59):

```csharp
catch (Exception ex) { System.Diagnostics.Debug.WriteLine($"[FreeXOptions] Failed to load: {ex.Message}"); }
// ...
catch (Exception ex) { System.Diagnostics.Debug.WriteLine($"[FreeXOptions] Failed to save: {ex.Message}"); }
return new FreeXOptions();
```

If save fails (read-only profile, disk full, permission denied), user-set preferences vanish at next launch with no warning.

**Recommendation:** At minimum, surface a non-modal status-bar warning the first time after a failed save. Better: write to a `.tmp` and atomically rename, falling back to the previous file on failure.

### 4.3 `RecalcEngine` catches all exceptions as `#VALUE!`

[RecalcEngine.cs:116-122](../../src/FreeX.Core.Calc/RecalcEngine.cs#L116-L122):

```csharp
catch (Exception)
{
    // Defensive: any unhandled exception from the evaluator ...
    cell.Value = ErrorValue.Value;
    errors.Add((addr, "#VALUE!"));
}
```

This is reasonable as a safety net, but it hides real bugs in built-in function implementations behind a generic `#VALUE!`. The bug is invisible in tests that only assert on the cell value — the test passes, the bug ships.

**Recommendation:** In `DEBUG` builds, `throw` from this catch; in `RELEASE` builds, log the unhandled exception via the same diagnostic channel used elsewhere. Tests will then surface invariant violations in built-in functions.

### 4.4 `CommandBus.Undo` doesn't guard `Revert`

[CommandBus.cs:45-56](../../src/FreeX.Core.Commands/CommandBus.cs#L45-L56):

```csharp
public CommandOutcome Undo(WorkbookId workbookId)
{
    var stack = GetOrCreateStack(workbookId);
    if (!stack.CanUndo) return new CommandOutcome(false, "Nothing to undo");

    var ctx = _contextFactory(workbookId);
    var command = stack.PopUndo();
    command.Revert(ctx);

    return new CommandOutcome(true, AffectedCells: GetAffectedCells(command));
}
```

If `Revert` throws (e.g. snapshot references a sheet that was since deleted via a non-undoable path), the command has already been popped from the undo stack and pushed to redo. The user's undo chain is now broken with no rollback.

**Recommendation:**

```csharp
try { command.Revert(ctx); }
catch (Exception ex)
{
    stack.RollbackPopUndo(command);
    return new CommandOutcome(false, $"Undo failed: {ex.Message}");
}
```

### 4.5 `CommandBus.Redo` re-runs `Apply`, re-allocating snapshots

[CommandBus.cs:58-74](../../src/FreeX.Core.Commands/CommandBus.cs#L58-L74):

```csharp
var command = stack.PopRedo();
var outcome = command.Apply(ctx);
```

Calling `Apply` again means commands like `ApplyStyleCommand` re-walk the entire range, re-call `RegisterStyle` per cell, and re-allocate the `_snapshot` list. The redo path is correct only because commands happen to be idempotent — there is no contract requiring this.

**Recommendation:** Add `IWorkbookCommand.Reapply(ICommandContext, IReadOnlyList<...> savedState)` that restores from the original snapshot, separate from `Apply` (which captures snapshots). For commands where `Apply == Reapply`, the default implementation can call `Apply`.

### 4.6 No formula recursion depth limit

[FormulaEvaluator.cs:44-67](../../src/FreeX.Core.Formula/FormulaEvaluator.cs#L44-L67) is a switch over `FormulaNode` types, calling `EvaluateNode` recursively for `BinaryOpNode`, `UnaryOpNode`, and `FunctionCallNode`. A pathological formula like `=1+1+1+...+1` with 10k terms (paste from another tool) will stack-overflow the entire app.

**Recommendation:** Add a depth counter to `IEvalContext` and throw `FormulaEvalException("#NUM!")` past a threshold (Excel uses ~256–1024 depending on the operation). Convert deep-tree evaluation to iterative form for the common left-associative cases.

### 4.7 `RecalculateSheetFormulas` rebuilds workbook-wide dependencies for a single sheet

[RecalcEngine.cs:196-213](../../src/FreeX.Core.Calc/RecalcEngine.cs#L196-L213):

```csharp
public RecalcReport RecalculateSheetFormulas(Workbook workbook, SheetId sheetId)
{
    RebuildFormulaDependencies(workbook);  // walks every formula in every sheet
    var sheet = workbook.GetSheet(sheetId);
    // ...
}
```

Two problems:
- **Performance**: A sheet-scoped recalc walks the entire workbook's formulas to rebuild deps.
- **Correctness**: After rebuilding, only `sheet`'s formulas are added to the changed set, so cross-sheet dependents on other sheets are not recalculated.

**Recommendation:** Take a delta input (changed cells) and recalc only that closure. Reserve full rebuild for explicit "recalculate all" requests.

---

## 5. Consistency

### 5.1 `CellStyle.Equals` / `GetHashCode` exclude `NativeDifferentialAttributes`

[CellStyle.cs:224-287](../../src/FreeX.Core.Model/CellStyle.cs#L224-L287):

```csharp
public bool Equals(CellStyle? other)
{
    // ... compares FontName, FontSize, Bold, ..., Locked, Hidden — but not Native* fields
}

public override int GetHashCode()
{
    // ... same omission
}
```

Two styles that differ only in `NativeDifferentialAttributes` (the native dxf-attribute preservation bag) are considered equal. `Workbook.RegisterStyle` then returns the existing ID, discarding the new style's native metadata. The very fidelity that field exists to preserve is silently lost any time differential conditional-format styles share modeled fields.

**Recommendation:** Include the three `NativeDifferential*` properties in `Equals` and `GetHashCode`, using `IReadOnlyDictionary<string,string>` sequence-equality and ordinal string compare.

### 5.2 Two parallel dictionaries for named ranges

[Workbook.cs:105-110](../../src/FreeX.Core.Model/Workbook.cs#L105-L110):

```csharp
public Dictionary<string, GridRange> NamedRanges { get; } = new(...);
public Dictionary<string, NamedRangeMetadata> NamedRangeMetadataByName { get; } = new(...);
```

`DefineNamedRange` updates both, but `NamedRanges.Remove("foo")` from outside (which is possible because the property is exposed mutably) updates only one. Result: orphaned metadata, or vice versa.

**Recommendation:** Wrap in a single `Dictionary<string, NamedRangeEntry>` and hide it behind the existing methods.

### 5.3 Inconsistent snapshot strategy across commands

`EditCellsCommand` clones full `Cell` objects ([Commands.cs:61](../../src/FreeX.Core.Commands/Commands.cs#L61)); `ApplyStyleCommand` snapshots `(Cell?, StyleId?)` ([ApplyStyleCommand.cs:41,50](../../src/FreeX.Core.Commands/ApplyStyleCommand.cs#L41)); other commands snapshot at column / sheet granularity. Each command rolls its own snapshot type — there is no shared abstraction.

**Recommendation:** Introduce a `SheetSnapshot` type that captures arbitrary diff sets (cells, style overrides, structural changes) and is consumed uniformly by `Revert`. Commands then describe *what* they touched; snapshotting and rollback are mechanism, not policy.

### 5.4 `MessageBox.Show(this, ...)` called 76 times across 48 dialog files

Direct WPF calls in command flows make the host untestable without a UI thread. There is no `IUserNotifier` / `IUserConfirmer` / `IFileDialog` abstraction.

**Recommendation:** Introduce small interfaces (`IUserMessageService.ShowError`, `IUserMessageService.AskYesNoCancel`, `IFileDialogService.PromptOpen`). Inject into MainWindow. Wire WPF implementations at composition root. Tests can then substitute in-memory implementations.

### 5.5 `Workbook.RegisterStyle` called inside command loops

`ApplyStyleCommand.Apply` ([ApplyStyleCommand.cs:43-54](../../src/FreeX.Core.Commands/ApplyStyleCommand.cs#L43-L54)) calls `_diff.ApplyTo(baseStyle)` and `ctx.Workbook.RegisterStyle(...)` per cell. Even when the resulting style is identical for every cell in the range, each iteration allocates a fresh `CellStyle` and does a dictionary lookup.

**Recommendation:** Resolve the target `StyleId` *once* outside the loop when `_diff` reads no per-cell state; only fall back to per-cell registration when the cells start from different base styles.

---

## 6. Threading & Async

### 6.1 `CommandBus` is not thread-safe

[CommandBus.cs:12-13](../../src/FreeX.Core.Commands/CommandBus.cs#L12-L13):

```csharp
private readonly Dictionary<WorkbookId, CommandStack> _stacks = [];
private readonly Dictionary<WorkbookId, Func<IWorkbookCommand>> _repeatableCommandFactories = [];
```

No locking on `Execute` / `Undo` / `Redo`. Single-window UI usage makes this safe today, but background recalc, autosave, or any future multi-window scenario would race.

**Recommendation:** Document the single-threaded contract explicitly, or wrap mutation paths in `lock (_stacks)`.

### 6.2 Almost no async outside of `OpenWorkbookLoader`

A grep finds only ~22 async-related symbols across the entire `src/`. Workbook save ([SaveWorkbookWriter.cs](../../src/FreeX.App.Host/SaveWorkbookWriter.cs)), recalc, and most IO mappers run synchronously on the UI thread. For workbooks larger than a few MB, the UI freezes for the duration of save/recalc/export.

**Recommendation:** Make save async with the same progress pattern as `OpenWorkbookLoader.LoadAsync`. Make recalc async by wrapping `RecalcEngine.Recalculate` in `Task.Run` and marshalling results back via `Dispatcher`.

### 6.3 `Sheet._cells` is a plain `Dictionary` with no concurrency control

If recalc moves to a background thread (recommended above), the grid renderer's iteration over `Viewport.Cells` will race against `sheet.SetCell` from the recalc thread.

**Recommendation:** Either copy-on-snapshot the viewport materialization, or move to `ImmutableDictionary<...>` for cells (with the usual perf tradeoffs).

---

## 7. Security

### 7.1 Protection passwords stored as plain strings

[Workbook.cs:209](../../src/FreeX.Core.Model/Workbook.cs#L209):

```csharp
public string? StructureProtectionPassword { get; set; }
```

[Sheet.cs:559](../../src/FreeX.Core.Model/Sheet.cs#L559) (sheet-level), comment says "Password hash for sheet protection. Null means no password required." but the field is just `string?` — there is no enforcement that callers store a hash. The fields are serialized verbatim by `NativeJsonAdapter`:

[NativeJsonAdapter.Save.cs:33,102](../../src/FreeX.Core.IO/NativeJsonAdapter.Save.cs#L33):

```csharp
StructureProtectionPassword = workbook.IsStructureProtected ? workbook.StructureProtectionPassword : null,
// ...
ProtectionPassword = s.IsProtected ? s.ProtectionPassword : null,
```

Anyone with read access to the `.fxl` file can inspect protection passwords as plaintext.

**Recommendation:** Define `ProtectionPasswordHash` as the only field, hash on the way in (Excel's traditional algorithm or PBKDF2/Argon2 for greenfield), and document the change in `formats/native-json-schema.md`. XLSX round-trip already deals with Excel's hash format; align the native format the same way.

### 7.2 Hyperlink targets stored without scheme validation

[Sheet.cs:550](../../src/FreeX.Core.Model/Sheet.cs#L550):

```csharp
public Dictionary<CellAddress, string> Hyperlinks { get; } = [];
```

Anything that follows a hyperlink (Excel-style "Open hyperlink" command) should refuse `javascript:`, `data:`, `vbscript:`, and unsigned `file:` URIs pointing outside the document directory. The current code stores raw strings; the navigation surface in `MainWindow.HyperlinkNavigationPlanner.cs` is where the check belongs.

**Recommendation:** Whitelist `http://`, `https://`, `mailto:`, `file://` (with same-folder constraint or explicit user prompt), and intra-workbook references. Reject everything else with a "Hyperlink is unsafe to open" message.

### 7.3 No file-size limits on workbook open

`OpenWorkbookLoader` reads the entire file before adapters validate format. A malicious 100 GB XLSX zip with a small dictionary (zip bomb) decompresses inside ClosedXML and exhausts memory.

**Recommendation:** Check `FileInfo.Length` before opening, cap at a configurable limit (default 1 GB), and stream-validate the zip central directory before allowing decompression.

### 7.4 Print and export paths not validated for traversal

The PDF/XPS export flow accepts a `string filePath` from a `SaveFileDialog`. While `SaveFileDialog` is generally safe, programmatic export paths from command-line or scripting hooks (which the app may grow) would need explicit normalization. Document the invariant or add `Path.GetFullPath` + workbook-folder containment check.

---

## 8. Memory & GC

### 8.1 Per-undo-step memory cost is unbounded

`CommandBus.MaxUndoDepth = 100` ([CommandBus.cs:10](../../src/FreeX.Core.Commands/CommandBus.cs#L10)) counts *commands*, not bytes. A single `ApplyStyleCommand` over a full sheet snapshots ~17 billion `(CellAddress, Cell?, StyleId?)` tuples in `_snapshot` ([ApplyStyleCommand.cs:14](../../src/FreeX.Core.Commands/ApplyStyleCommand.cs#L14)) — though `range.AllCells()` enumerates only existing cells in practice, a paste of 10 M cells *will* hold 10 M snapshots × 100 commands = 1 G snapshots.

**Recommendation:** Track snapshot byte-cost via an `IUndoCost` interface on each command. Evict from the bottom of the stack when total cost exceeds a configurable budget (default e.g. 256 MB).

### 8.2 `Cell.Clone()` deep-copies entire cell per snapshot

[Commands.cs:61](../../src/FreeX.Core.Commands/Commands.cs#L61) and many other snapshot sites call `cell.Clone()`. A cell with comments, hyperlinks, formula AST, and validation refs is non-trivial to copy. For style-only edits, snapshotting the whole `Cell` is overkill.

**Recommendation:** Per §5.3, introduce typed diffs (`StyleChangeDelta`, `ValueChangeDelta`, ...) so each command snapshots only what it changes.

### 8.3 `StyleDiff.FromStyle` returns a fully-populated diff

[CellStyle.cs:325-352](../../src/FreeX.Core.Model/CellStyle.cs#L325-L352):

```csharp
public static StyleDiff FromStyle(CellStyle style) => new(
    Bold:    style.Bold,
    Italic:  style.Italic,
    // ... every field set
);
```

The point of `StyleDiff` is "leave unchanged fields null". `FromStyle` defeats this — applying the result via `ApplyTo` overwrites every property. Used in scenarios like Format Painter, this means the painter copies font name and border color even when the user intended only the highlight.

**Recommendation:** Add a `StyleDiff.FromDifference(CellStyle baseStyle, CellStyle targetStyle)` factory that emits only properties where target != base. Format Painter and similar flows should use this.

### 8.4 `BrushForCellColor` allocates per unique color per render

In [GridView.Rendering.cs:172](../../src/FreeX.App.UI/GridView.Rendering.cs#L172):

```csharp
var brushCache = new Dictionary<CellColor, SolidColorBrush>();
```

The cache lives one frame. Across 60 frames/second of scrolling, a sheet with 100 unique fill colors allocates ~6,000 throwaway `SolidColorBrush` objects per second. WPF retain-counts those internally — they are not free.

**Recommendation:** Class-level cache in `GridView`, sized via LRU (e.g. cap at 1024 brushes), invalidated only on theme change.

---

## 9. Maintainability

### 9.1 No TODO/FIXME/HACK markers in any source file

A grep finds zero `// TODO`, `// FIXME`, `// HACK`, or `// XXX` comments. This is either a sign of pristine discipline or — given the size of the codebase — a sign that deferred work has been actively pruned without a tracking surface. If the latter, the `planning/outstanding-build.md` doc carries the load, and code-locality is lost.

**Recommendation:** Allow `// TODO(name): short description (ref: doc.md#section)` markers for genuinely deferred work, with a CI rule that requires a doc reference. Keeps code-locality without turning into a TODO graveyard.

### 9.2 Many ribbon icon fallback drawings are hand-written

[RibbonIconFactory.FallbackDrawings.cs](../../src/FreeX.App.Host/RibbonIconFactory.FallbackDrawings.cs) is 404 lines of imperative `DrawingGroup` construction per icon. This is a maintenance liability: changing the default visual style requires touching every method.

**Recommendation:** Define icons as data (e.g. JSON or compiled-in record arrays of `(path, fill, stroke)` lists) and have one renderer interpret the data. Adding an icon then means adding a record, not writing a method.

### 9.3 Many large `BuiltInFunctions.*.cs` files still have ~1k-line aggregations

`BuiltInFunctions.Financial.cs` (1,850), `BuiltInFunctions.cs` (1,696), `BuiltInFunctions.StatisticalDistributions.cs` (1,355), `BuiltInFunctions.DateTime.cs` (727), `BuiltInFunctions.TextCore.cs` (696). The existing log calls out `BuiltInFunctions.cs` for further extraction. Continuing per-family splits (Financial.Bonds, Financial.Depreciation, etc.) would make individual functions easier to find.

### 9.4 `Workbook.IsR1C1Reference` only recognizes `R1C1` form

[Workbook.cs:330-343](../../src/FreeX.Core.Model/Workbook.cs#L330-L343) parses `R<digits>C<digits>` only. Excel's R1C1 supports `R[1]C[1]` (relative offsets), `R[-1]C`, `RC1`, etc. A named range called `R1C2` is rejected (good); a named range called `R[1]C[1]` would be accepted (likely a bug).

**Recommendation:** Tighten the check to match Excel's R1C1 grammar more completely, with explicit tests for the relative-offset and partial-omission forms.

### 9.5 `DateTime.Now` (local time) used in 10 places

`DateTime.Now` is timezone- and DST-sensitive. For recent-files lists and UI timestamps this is fine; for any serialized timestamp it is a bug waiting for a daylight-savings switch.

**Recommendation:** Audit the 10 call sites ([BackstageRecentFileListPlanner.cs](../../src/FreeX.App.Host/BackstageRecentFileListPlanner.cs), [PrintRenderer.HeaderFooterDrawing.cs](../../src/FreeX.App.Host/PrintRenderer.HeaderFooterDrawing.cs), [RecentFilesStore.cs](../../src/FreeX.App.Host/RecentFilesStore.cs), and others). Switch serialized timestamps to `DateTimeOffset.UtcNow`. Header-footer "date" tokens should follow Excel's behavior, which is locale-formatted local time — keep `.Now` there.

---

## 10. Smaller Findings (Lower Priority)

| # | Area | Finding | File:Line |
|---|------|---------|-----------|
| S1 | Workbook | `MoveSheet` does not update `ActiveSheetIndex` or `FirstVisibleSheetIndex` | [Workbook.cs:404-409](../../src/FreeX.Core.Model/Workbook.cs#L404-L409) |
| S2 | Workbook | `GetSheet(string)` is O(n) — no name-index dictionary | [Workbook.cs:363-366](../../src/FreeX.Core.Model/Workbook.cs#L363-L366) |
| S3 | RecalcEngine | `_volatileCells.Concat(...).Concat(...).Distinct().ToList()` allocates 3 enumerables and a hash set per recalc | [RecalcEngine.cs:59-63](../../src/FreeX.Core.Calc/RecalcEngine.cs#L59-L63) |
| S4 | Formula | `BinaryOpNode` builds left/right as full nodes even for short-circuit operators (AND/OR are handled only via functions, but `=A1=B1` still evaluates both sides) — Excel matches this, so this is correct behaviorally, but the evaluator could detect always-true/false short-circuits | [FormulaEvaluator.cs:98-105](../../src/FreeX.Core.Formula/FormulaEvaluator.cs#L98-L105) |
| S5 | Formula | `EvaluateNode` for `OmittedArgumentNode` returns `BlankValue.Instance` — consumers must check; consider a dedicated `MissingArgument` value | [FormulaEvaluator.cs:51](../../src/FreeX.Core.Formula/FormulaEvaluator.cs#L51) |
| S6 | IO | `NativeJsonAdapter.Load` does not validate `dto.Sheets` count against `dto.ActiveSheetIndex` until later — `Math.Max(0, count-1)` masks invalid indices | [NativeJsonAdapter.cs:35](../../src/FreeX.Core.IO/NativeJsonAdapter.cs#L35) |
| S7 | App.Host | `MainWindow.Backstage.cs` 664 lines mixes Save, Save As, Open, Recent Files, and Start Screen flows — could split into `MainWindow.Backstage.Open.cs` / `.Save.cs` / `.Recents.cs` | [MainWindow.Backstage.cs](../../src/FreeX.App.Host/MainWindow.Backstage.cs) |
| S8 | App.UI | `GridView.SplitPanes.cs` extraction in progress (uncommitted) — finish and commit | [SplitPaneClipLayoutPlanner.cs](../../src/FreeX.App.UI/SplitPaneClipLayoutPlanner.cs) |
| S9 | App.UI | `ConditionalIconGlyphRenderer` creates 9 brushes per call — should freeze + cache | [ConditionalIconGlyphRenderer.cs](../../src/FreeX.App.UI/ConditionalIconGlyphRenderer.cs) |
| S10 | Core.Calc | `NumberFormatter` partials use `CultureInfo.InvariantCulture` for parsing but should consistently use it for *formatting* in places where Excel always emits invariant | (cross-check NumberFormatter.* files) |
| S11 | App.Host | `RibbonIconFactory.FallbackDrawings.cs` and `MainWindow.RibbonAdaptive.cs` together exceed 1,300 lines covering ribbon visual sizing — extract a `RibbonGroupSizingPlanner` | [MainWindow.RibbonAdaptive.cs](../../src/FreeX.App.Host/MainWindow.RibbonAdaptive.cs) |
| S12 | Core.Model | `WatchedCells` is a `List<CellAddress>` — should be `HashSet` to prevent duplicates | [Workbook.cs:137](../../src/FreeX.Core.Model/Workbook.cs#L137) |
| S13 | Core.IO | `XlsxWorkbookMetadataReader.cs` (587 lines) and `XlsxWorksheetMetadataPreserver.cs` (657 lines) sit at the same boundary — split readers further by metadata kind | (large IO files) |
| S14 | Cross | `Math.Clamp(...)` is used liberally in dialog result records (good for input validation) but should be paired with a non-throwing `TryClamp` that reports out-of-range so the dialog can show a warning | (chart format dialog records) |

---

## 11. Prioritized Top-Of-Backlog (Recommended Order)

| Priority | Item | Impact | Effort |
|---|---|---|---|
| **P0** | Replace `Debug.WriteLine` swallowed-exception sites in `XlsxFileAdapter` with structured diagnostics (§4.1) | Silently lost data on every XLSX open | Small |
| **P0** | Hash protection passwords on the way in; never persist plaintext (§7.1) | Security/compliance | Medium |
| **P0** | Fix `CellStyle.Equals`/`GetHashCode` to include `NativeDifferential*` (§5.1) | Silent fidelity loss in conditional-format styles | Small |
| **P1** | Promote per-frame brush/pen/typeface caches in `GridView` to class-level (§3.1, §8.4) | Render-time GC pressure | Small |
| **P1** | Cache `FormattedText` and remove `ResolveShrinkFontSize`'s per-probe allocation (§3.2) | Scroll/render perf on shrink-to-fit sheets | Medium |
| **P1** | Guard `CommandBus.Undo`'s `Revert` with try/catch + rollback (§4.4) | Crash-safety on failed undo | Trivial |
| **P1** | Make `CellStyle` immutable; stop cloning on every `GetStyle` (§3.3, §3.4) | Render-time allocation + safety | Medium |
| **P1** | Store dependency edges as ranges, not per-cell expansion (§3.6) | Major recalc perf on full-column refs | Large |
| **P2** | Move recalc onto background thread + parallel-by-level (§3.7, §6.2) | UI responsiveness on large workbooks | Large |
| **P2** | Add formula recursion depth limit (§4.6) | Crash hardening | Small |
| **P2** | Introduce `IUserMessageService` so MessageBox.Show is testable (§5.4) | Test coverage of host flows | Medium |
| **P2** | Reuse a single `JsonSerializerOptions` and turn off `WriteIndented` for `.fxl` save (§2.6) | Save/load perf + file size | Trivial |
| **P2** | Validate hyperlink schemes before following (§7.2) | Security | Small |
| **P3** | Replace 12 `WorksheetXxxMetadataModel` classes with one `NativeXmlPreserveBag` (§2.3) | Maintainability | Medium |
| **P3** | Bound undo-stack memory by bytes, not commands (§8.1) | Stability on large paste operations | Medium |
| **P3** | Stream-load XLSX rather than buffering whole file (§3.8) | Memory on large files | Medium |
| **P3** | Event-driven model mutations + remove explicit `InvalidateVisual` calls (§2.5) | Architecture cleanliness | Large |

---

## 12. Verification Surface (For Whoever Acts On This)

Before changing anything in §3 (perf), establish a baseline:
- `docs/performance/baseline.md` already exists — extend it with: time-to-render large viewport, recalc time for a 10k-formula workbook, save/load time for the largest XLSX in the corpus.
- Capture `dotnet-trace`/`PerfView` traces and re-run after each P1+ change to confirm.

For §4 (stability), §5 (consistency), and §7 (security):
- Existing parity tests are necessary but not sufficient — add property tests that exercise round-trip XLSX with synthetic feature-failure injection.
- Add a "diagnostic events on open" assertion to the load tests so silently-swallowed exceptions surface.

For §3.6 / §3.7 (recalc topology and parallelism):
- Build the existing dep graph into a benchmark project; record current Recalc(all) ms for the standard fixtures.
- Test correctness with the existing recalc tests + add a property test that compares parallel-recalc results to sequential-recalc results on randomized formula graphs.
