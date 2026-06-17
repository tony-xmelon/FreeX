# Fidelity — Form-control sub-cell anchor offsets (placement follow-up) (2026-06-17)

Branch: `worktree-agent-a51f1e14f302ead32`

Follow-up to the "What remains / Sub-cell offsets" gap noted in
`docs/fidelity/2026-06-17-formcontrol-rendering.md`. Legacy Excel form controls were already
loaded (`FormControlModel`) and drawn as static chrome on the GridView, but the per-cell EMU
sub-cell offsets from the control's anchor were **dropped at load**, so control rects snapped to
whole-cell spans (a checkbox Excel places mid-cell rendered flush to the cell grid). This pass
preserves those offsets and uses them at render.

## What was implemented

### Load — preserve sub-cell offsets
`FormControlModel` gains `AnchorOffsets` (`DrawingAnchorRange?`, 0-based cells + EMU offsets),
mirroring how pictures/slicers carry a `DrawingAnchorRange`. `XlsxFormControlMapper` now populates it
from two sources:

1. **Primary — worksheet `controlPr/anchor`** (`ReadAnchorOffsets`). Modern Excel writes the
   control anchor in the spreadsheetDrawing namespace with `xdr:colOff`/`xdr:rowOff` in **EMU**
   for both the from- and to-cell. These are read verbatim into the model (EMU preserved).
2. **Fallback — VML `x:ClientData/x:Anchor`** (`ParseVmlAnchor` + `ReadVmlAnchorOffsets`). Legacy
   form controls anchor via `xl/drawings/vmlDrawingN.vml`. The `<x:Anchor>` is comma-separated
   `leftCol,leftColOff,topRow,topRowOff,rightCol,rightColOff,bottomRow,bottomRowOff` with cells
   0-based and offsets in **pixels**; the parser converts pixels → EMU (×9525). The VML drawing is
   resolved off the worksheet `legacyDrawing` relationship and the shape matched by `shapeId`
   (encoded as `_x0000_s{shapeId}`). Used only when the controlPr anchor carries no offsets.

`AnchorOffsets` has no SheetId, so it passes through the existing load-applier sheet-rebind
(`XlsxFileAdapter.LoadSheetXmlLayoutApplication`) unchanged.

### Render — use the offsets
`FormControlRenderPlanner.TryCreateAnchorRange` now prefers `AnchorOffsets` (already a 0-based
EMU `DrawingAnchorRange`) when present, otherwise falls back to deriving a whole-cell 0-based range
from the 1-based `Anchor`. New `HasSubCellOffsets(control)` gates the render path:
`GridView.RenderFormControls` uses the **offset-aware** `GridDrawingObjectPlanner.TryCreateDrawingAnchorRect`
(the same path pictures/slicers use — it already applies `EmusToPixels` to from/to offsets) when
offsets exist, and falls back to the whole-cell `TryCreateSpanningAnchorRect` otherwise.
`CalculateFormControlLayerStamp` includes `AnchorOffsets` so the cached layer invalidates correctly.

## Files changed
- `src/FreeX.Core.Model/FormControlModel.cs` — new `AnchorOffsets` property.
- `src/FreeX.Core.IO/XlsxFormControlMapper.cs` — `ReadAnchorOffsets`, `ParseVmlAnchor`,
  `ReadVmlAnchorOffsets`/`ResolveVmlDrawingPath`; populate `AnchorOffsets` (controlPr + VML fallback).
- `src/FreeX.App.UI/FormControlRenderPlanner.cs` — prefer offsets in `TryCreateAnchorRange`;
  `HasSubCellOffsets`.
- `src/FreeX.App.UI/GridView.FormControls.cs` — offset-aware rect with whole-cell fallback.
- `src/FreeX.App.UI/GridView.DrawingObjectLayerCache.cs` — stamp includes `AnchorOffsets`.
- `tests/FreeX.Core.IO.Tests/XlsxFormControlMapperTests.cs` — VML/controlPr offset parse tests.
- `tests/FreeX.App.UI.Tests/FormControlRenderPlannerTests.cs` — planner prefer-offsets/fallback +
  offset-aware rect-within-cell tests.
- `tools/FreeX.SheetGridImageCompare/Program.cs` — wire `grid.FormControls = sheet.FormControls`
  (the GridView render-compare tool never pushed form controls, so they were invisible in its
  output; needed to eyeball-verify placement).

## Before / after (eyeball render via `tools/FreeX.SheetGridImageCompare`, PNGs in
`%TEMP%/excelexamples1-gridview/`, vs Excel reference `%TEMP%/deferred-gt/todo_sheet.png`)

- **todo** (`freex_25_todo.png`) — the 12 checkboxes now render in the "check" column (F), each
  aligned to its activity row at the correct sub-cell position (from col F +18px, ~32×22px box),
  with Check Box 1 & 2 showing the check glyph. Matches the Excel reference layout (one checkbox per
  row, checks on rows 1–2). Previously (whole-cell span) the box snapped to the full cell grid.
- **highlight-options** (`freex_20_highlight-options.png`) — the three option buttons sit in the
  top "How do you want to highlight?" row at their true sub-cell positions.
- **Shift Calendar** (`freex_21_Shift_Calendar.png`) — the horizontal scroll bar spans B2 across to
  column H precisely (VML anchor `2,0,7,0,15,63,8,1` → into col H +63px), no longer snapping to a
  whole-cell boundary.

Controls now sit correctly within/across their anchor cells rather than flush to the grid.

## Verification
- `dotnet build FreeX.slnx -c Release` — 0 warnings / 0 errors.
- `dotnet test FreeX.DefaultTests.slnx -c Release --no-build` — all green (Core.IO 2617, Core.Model
  3969, Formula 2944, Calc 783, Services 1080, Host.Logic 1558, Avalonia 294, Integration 78, … no
  failures).
- `dotnet test tests/FreeX.App.UI.Tests/... --no-build` — 727 passed / 27 skipped (was 717; +10 new
  render-planner offset tests).
- New IO mapper tests (8 total incl. 4 new offset tests) and App.UI planner tests pass.

## What remains
- **Checkbox/option captions** — the renderer draws the control `Name` ("Check Box N") as a caption
  to the right of the glyph, so a truncated "C.." appears next to each checkbox. Excel's caption for
  these is empty (`autoFill`/no text). Suppressing the caption when the control has no authored
  display text (vs. its shape name) would match Excel more closely. Out of scope for placement.
- **Rotation / non-axis-aligned anchors** — not applicable to form controls (always axis-aligned).
