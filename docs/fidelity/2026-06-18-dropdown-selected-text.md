# DropDown form control — selected-item text (2026-06-18)

## Gap
FreeX rendered legacy Excel **DropDown** form-control chrome (white field + grey
drop-button + arrow) but the field was **blank**: the UI render layer (`FreeX.App.UI`)
had no way to resolve the selected item. The model carries the source range
(`FormControlModel.ListFillRange`) and the 1-based Excel `sel`
(`FormControlModel.SelectedIndex`); the selected text is the `SelectedIndex`-th cell
value of `ListFillRange`.

Driver: `ExcelExamples1.xlsx` sheet **highlight-options** (sheet20). Its
`ctrlProp1.xml` (Drop Down 1) has `fmlaRange="high.choices"`, `sel="2"`, where the
defined name `high.choices = 'highlight-options'!$I$6:$I$10`. `I6:I10` =
`["Due in next 7 days", "Due in next 14 days", "Last 7 days", "Last 14 days",
"Custom date Range"]`, so item 2 = **"Due in next 14 days"** — matching the Excel
ground truth render.

## Fix / layering
- **`FormControlModel.SelectedText`** (new, `FreeX.Core.Model`): render-time projection
  of the resolved selected-item text. `null` when nothing is selected / unresolvable.
- **`FormControlListResolver`** (new, `FreeX.Core.Commands`): resolves a list control's
  `ListFillRange` (plain A1 range, sheet-qualified ref, single cell, or defined name)
  against the `Sheet`/`Workbook`, then returns the `SelectedIndex`-th cell value as
  text. Reuses the same `Lexer`/`Parser`/`RangeRefNode`/`NamedRangeNode` +
  `Workbook.TryGetNamedRange` pattern as `DataValidationService.ListSources`.
  - `PopulateSelectedText(sheet, workbook)` fills `SelectedText` for every list control
    (DropDown/ListBox); non-list controls untouched. Unresolvable → `null` (blank).
- **Host wiring** (no raw workbook access in the UI layer):
  - `MainWindow.Viewport.cs` calls `PopulateSelectedText` right before
    `SheetGrid.FormControls = sheet.FormControls`.
  - `tools/FreeX.SheetGridImageCompare/Program.cs` calls it before building the GridView
    (it assigns `sheet.FormControls` directly, bypassing MainWindow).
- **Renderer**: `FormControlRenderPlanner.GetSelectedText` (new) + `DrawFormDropDown` now
  draws `SelectedText` (left-aligned, vertically centered, clipped) instead of the
  caption. A drop-down has no authored caption in Excel — its field shows the selection.
- **Cache**: `CalculateFormControlLayerStamp` now hashes `SelectedIndex` + `SelectedText`
  so a selection change invalidates the cached drawing layer.

## Resolution rule
`SelectedIndex` is 1-based; `sel="0"`/absent = nothing selected → blank. The range is
walked row-major: cell n = `(Start + (n-1)/colCount rows, (n-1)%colCount cols)`. Out-of-
range index → blank. Cell value → text via Text / Number (current culture) / Bool;
Blank/Error → blank.

## Verification
- `dotnet build FreeX.slnx -c Release` — succeeded, 0 warnings/errors.
- `dotnet test FreeX.DefaultTests.slnx -c Release --no-build` — Passed (exit 0); no
  teardown flake this run.
- `dotnet test tests/FreeX.App.UI.Tests/... --no-build` — Passed 747/747.
- New tests: `FormControlListResolverTests` (10, Core.Model.Tests: plain range, defined
  name, sheet-qualified, first index, no-selection, beyond-range, unresolvable name,
  empty range, non-list control, populate) + 3 `FormControlRenderPlannerTests`
  (`GetSelectedText`).
- Visual: re-rendered highlight-options via `FreeX.SheetGridImageCompare`; the top-left
  drop-down now shows **"Due in next 14 days"**, matching the Excel ground truth
  (`gaps-gt/highlight-options.png`). Previously blank.

## Deferred
- Interactivity (clicking the drop-down) remains out of scope — render-only.
- Number/date cells in a list-fill range use invariant-ish current-culture number text,
  not the source cell's display number format. The driver's list is plain text, so this
  is not exercised; revisit if a date/number-sourced drop-down surfaces.
