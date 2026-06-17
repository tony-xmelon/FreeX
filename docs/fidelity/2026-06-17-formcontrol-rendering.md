# Fidelity — Legacy form-control rendering on the GridView (2026-06-17)

Branch: `worktree-agent-ab318359b8217e679`

Follow-up to §2 RENDER of `docs/fidelity/2026-06-15-ExcelExamples1-findings.md`. Legacy Excel
form controls (checkboxes / option buttons / spinners / scroll bars …) were already LOADED and
round-trip-preserved into `Sheet.FormControls` (`FormControlModel`), but were not DRAWN on the
on-screen GridView, so they were invisible. This pass adds a static-chrome render layer.

## What was implemented

A new drawing-object layer that draws static chrome for these `FormControlKind`s from
`Sheet.FormControls`, reading checked/selected state from the model:

- **CheckBox** — white box with grey border + sunken top/left edge; black check glyph when
  `IsChecked`; caption to the right (`Name`, falling back to "Check Box").
- **OptionButton** — radio circle; black filled dot when `IsChecked` (selected); caption to the right.
- **Spinner** — two stacked raised 3-D buttons (up over down) with black triangle glyphs.
- **ScrollBar** — grey track with raised arrow buttons at each end (horizontal if wider than tall,
  else vertical) and black triangle glyphs.
- **GroupBox** — etched rectangle frame with caption breaking the top-left.
- **Label** — caption text only.

Out of scope (not drawn): **Button, DropDown, ListBox, Unknown** — these are interactive-only or
need richer chrome; `FormControlRenderPlanner.IsRenderable` returns false for them. **Interactivity**
(click → linked cell, spin/scroll value changes) is entirely out of scope this pass — static visual only.

## How it's anchored

`FormControlModel.Anchor` is a 1-based `GridRange` (from/to cells; the sub-cell EMU offsets were
dropped at load). The drawing-object anchor planner (`GridDrawingObjectPlanner`) consumes a 0-based
`DrawingAnchorRange`, so `FormControlRenderPlanner.TryCreateAnchorRange` converts (subtract 1 per
endpoint).

The existing `TryCreateDrawingAnchorRect` points the rect at the *to-cell's top-left*, which collapses
to zero size when from==to (common for a 1-cell control), so a new
`GridDrawingObjectPlanner.TryCreateSpanningAnchorRect` was added: it spans from the from-cell's
top-left to the **bottom-right** of the to-cell (LeftOffset+Width / TopOffset+Height), never
degenerating for a one-cell anchor. The form-control layer uses the same off-screen culling pattern
as the slicer/timeline layer (`GetRenderableDrawingAnchorBounds` → `CanAnchoredObjectReachDrawingViewport`
→ rect → `IntersectsDrawingViewport`).

The layer renders after charts/shapes/slicers/pictures/text-boxes in `RenderDrawingObjectLayers`
(so controls sit above cell content), is gated by `ObjectDisplayMode`, and participates in the
drawing-object layer cache (cache key + `CalculateFormControlLayerStamp` over kind/anchor/name/checked/value).

## Files changed

- `src/FreeX.App.UI/FormControlRenderPlanner.cs` (NEW) — anchor conversion + `IsRenderable` + `GetCaption`.
- `src/FreeX.App.UI/GridView.FormControls.cs` (NEW) — `RenderFormControls` + per-kind chrome drawing.
- `src/FreeX.App.UI/GridDrawingObjectPlanner.cs` — `TryCreateSpanningAnchorRect` (viewport + dictionary overloads).
- `src/FreeX.App.UI/GridView.Properties.cs` — `FormControls` dependency property (AffectsRender).
- `src/FreeX.App.UI/GridView.DrawingObjectLayerCache.cs` — wired `RenderFormControls`; cache key + stamp.
- `src/FreeX.App.UI/GridView.RenderDispatch.cs` — `HasDrawingObjectLayerWork` includes FormControls.
- `src/FreeX.App.Host/MainWindow.Viewport.cs` — push `sheet.FormControls` to the GridView on navigation.
- `src/FreeX.App.Host/MainWindow.WorkbookLifecycle.cs` — clear FormControls on workbook close.
- `tests/FreeX.App.UI.Tests/FormControlRenderPlannerTests.cs` (NEW) — planner logic tests.
- `tests/FreeX.App.UI.Tests/GridViewFormControlRenderTests.cs` (NEW) — headless `RenderTargetBitmap` tests.

## Verification

- `dotnet build FreeX.slnx -c Release` — succeeded, 0 warnings / 0 errors.
- `dotnet test FreeX.DefaultTests.slnx -c Release --no-build` — all green. App.UI: 717 passed / 27 skipped.
  Other projects (Model 3965, IO 2611, Formula 2944, Calc 783, Services 1080, Host.Logic 1523, etc.)
  all passed; 0 failures across the gate.
- New tests: 16 planner + 4 render = 20, all pass.

### Eyeball render (headless GridView via `tools/FreeX.SheetGridImageCompare`, sample PNGs in
`%TEMP%/formcontrol-render/`)

NOTE: the 12 checkboxes are on the **todo** sheet (the original task note said "Inputs (12
checkboxes)"; the actual loaded controls are: todo = 12 CheckBoxes, highlight-options = 3
OptionButtons, Shift Calendar / Calendar View = 1 ScrollBar each).

- **todo** (`freex_25_todo.png`) — all 12 checkboxes render in column F: Check Box 1 & 2 show the
  black check glyph (`IsChecked=true` in the model), 3–12 show empty boxes; each with its caption.
- **highlight-options** (`freex_20_highlight-options.png`) — option buttons render near D2:F4 with the
  selected one ("Option Button 3", `IsChecked=true`) drawing a filled dot.
- **Shift Calendar** (`freex_21_Shift_Calendar.png`) — the horizontal scroll bar (B2:I2) renders as a
  grey track with left/right raised arrow buttons and black triangle glyphs.

Appearance closely matches Excel's greyish 3-D form-control chrome. The only minor cosmetic note:
when a checkbox anchor spans several rows (e.g. todo F9:F11), the vertically-centered caption can sit
slightly close to the next control's caption; Excel renders these compactly too.

## What remains

- **Interactivity** — click checkbox/option → write linked cell; spinner/scrollbar value changes. (Out
  of scope this pass.)
- **Button / DropDown / ListBox** static chrome — not drawn (DropDown/ListBox would need their
  list/selected-item rendering; Button needs a 3-D push-button face + caption).
- **Sub-cell offsets** — the model dropped the per-cell EMU offsets at load, so control rects snap to
  whole-cell spans. Exact pixel placement/size within the anchor cells is approximate (acceptable for
  static chrome; would matter for pixel-perfect parity).
