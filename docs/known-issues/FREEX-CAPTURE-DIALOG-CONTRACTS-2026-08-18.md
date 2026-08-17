# FreeX capture batches: 12 dialog contract and pixel failures

These surfaced only after two fixes made the batches able to fail honestly:

- the batches asserted PNG bytes while running under Avalonia's lightweight headless
  drawing, which does not rasterize. `RenderTargetBitmap.Save` wrote **no file at all**
  (verified with a direct probe on a plain 40x20 border), so every capture read back
  empty and no assertion could pass. Batch6 alone had opted into Skia; the rest now do.
- the capture id invariant was mixed in both directions. `CaptureParitySurfacesAsync`
  filters on `ParityInteractionDialogRoute.CatalogId` (keeps the `Dialog` suffix) and
  records contracts under `SurfaceId` (drops it). Tests filtered by surface id (so
  captured nothing) or looked up by catalog id (so missed a recorded contract).

What remains is genuine. `FreeX.App.Avalonia.Tests` is 2072/2072; the batches are at 12.

## Focus and ownership contracts

`PivotChartTypeDialog`, `ManageConditionalFormatsDialog`, `ChartFormatFamily`,
`WatchWindowDialog`, `PivotDialogs`.

Three leads, each established by measurement. **The third is the most likely and the
least explored.**

1. `FocusFirstOwnedDialogControl` (MainWindow.DialogInteractionValidation.cs) stops
   searching when `IsFocusInside(dialog, focused)` is true, and the **window itself
   satisfies that**. So when Avalonia parks initial focus on the Window, the helper
   concludes focus is fine and never focuses a control. Requiring an actual control
   does change the observed target -- `initial=passed:Window#ChangeChartTypeDialog`
   becomes `initial=passed:ListBoxItem` -- but moves no test, and costs two dialogs
   their focus entirely (`initial=failed:no-focus-inside-dialog`). Reverted.
2. `SettleDialogInteractionAsync` is `Task.Delay(75)` with **no dispatcher pump**, and
   it sits between sending Tab and reading focus. Avalonia applies focus through the
   dispatcher, and nothing dispatches during a bare delay in the headless session.
   Adding `RunJobs(Loaded)` + `RunJobs(Input)` changed nothing measurable. Reverted.
3. `NormalizeDialogTabStop` maps any control to its ancestor `ListBox`. That is correct
   for counting stops -- a list is one tab stop, arrows move within it -- but it means
   `tab=failed:focus-did-not-move` is plausibly an **accurate report**: Tab is not
   leaving the list. If so the defect is in the dialogs' focus configuration (their
   lists trapping Tab), not in the probe, and the fix belongs in the dialogs. Untested.

Note `initial=passed:Window#...` **passes** the initial-focus check; only `tab` fails.
Reading the failure as an initial-focus problem sends you to the wrong assertion.

## Pixel and colour assertions

`GoToSpecial` fixed-size clipping, `ScenarioManager` canonical frame, `PageSetup` tabs,
`FormatCells` alignment tab. These compare rendered pixels and could not run at all
while the batches produced empty PNGs, so they have never been green under Skia. Expect
genuine parity differences rather than harness faults.
