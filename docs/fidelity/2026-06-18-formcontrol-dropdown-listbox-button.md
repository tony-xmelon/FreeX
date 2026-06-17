# Form-control chrome: DropDown, ListBox, Button (2026-06-18)

## Gap
`FormControlRenderPlanner.IsRenderable` returned `false` for `DropDown`, `ListBox`,
and `Button`, so those legacy Excel form controls drew nothing on the GridView even
though the model (`FormControlModel`) already carried their `Kind`, `Anchor`,
`AnchorOffsets`, `SelectedIndex`, `ListFillRange`, and `Caption`.

Driver: `ExcelExamples1.xlsx` sheet **highlight-options** (sheet20) has a DropDown
form control (`objectType="Drop"`) at the top-left ("How do you want to highlight?")
plus option buttons. Ground truth: `gaps-gt/highlight-options.png` shows the dropdown
as a white box with the selected text ("Due in next 14 days") and a grey drop-down
button bearing a down-triangle on the right.

## Change
Three kinds now render; only `Unknown` stays unrendered.

- **DropDown** (`DrawFormDropDown`): white field + thin grey border, a grey 3-D raised
  drop-down button sized to the control height (clamped to half-width on narrow boxes)
  flush against the right edge, with a down-triangle glyph. The selected-item text is
  best-effort: drawn from the model caption when present, otherwise left blank.
- **ListBox** (`DrawFormListBox`): bordered white well with faint (224,224,224) row
  separators every ~15px.
- **Button** (`DrawFormButton`): 3-D raised push-button face (reusing
  `DrawFormControlRaisedButton`) with the `Caption` centered and clipped.

### Selected-item text limitation
The GridView render path has no live sheet-cell access — `FormControls` is just a list
of `FormControlModel`. The model carries `SelectedIndex` (1-based) and `ListFillRange`
(a range *reference* string), but **not the resolved list items**, so the chosen text
cannot be looked up at render time. Per the task's explicit allowance, the dropdown
draws box + button + arrow and leaves the text area blank when no caption is set.
Resolving `ListFillRange[SelectedIndex]` against the sheet model would require plumbing
cell access into the form-control layer and is deferred.

## Layout helpers (planner)
Added to `FormControlRenderPlanner` (pure, unit-tested):
- `GetDropDownButtonRect(Rect)` — square button = `min(height, width/2)`, flush right.
- `GetDropDownTextRect(Rect, button)` — the field left of the button.

## Files changed
- `src/FreeX.App.UI/FormControlRenderPlanner.cs` — `IsRenderable` now true for
  Drop/List/Button; added `GetDropDownButtonRect` / `GetDropDownTextRect`.
- `src/FreeX.App.UI/GridView.FormControls.cs` — dispatch + `DrawFormDropDown`,
  `DrawFormListBox`, `DrawFormButton`; added `FormControlListRowPen`.
- `tests/FreeX.App.UI.Tests/FormControlRenderPlannerTests.cs` — IsRenderable theory
  updated; dropdown button/text-rect layout tests.
- `tests/FreeX.App.UI.Tests/GridViewFormControlRenderTests.cs` — replaced the stale
  "Button draws nothing" test with positive render tests for Drop/List/Button and a
  new `UnknownControl_DrawsNothing`.

## Verification
- `dotnet build FreeX.slnx -c Release` — succeeded, 0 warnings/errors.
- `dotnet test FreeX.DefaultTests.slnx -c Release --no-build` — all passed
  (e.g. Core.IO.Tests 2627 passed / 53 skipped).
- `dotnet test tests/FreeX.App.UI.Tests` — 741 passed, 27 skipped, 0 failed.
- Rendered highlight-options via `tools/FreeX.SheetGridImageCompare`:
  `freex_20_highlight-options.png` now shows the dropdown as a white box with a grey
  drop-down button + down-arrow (text area blank, see limitation above), converging
  toward the Excel ground truth. Whole-sheet diff stayed ~18.7% (dominated by the
  large conditional-format / table fill area, not the control chrome).
