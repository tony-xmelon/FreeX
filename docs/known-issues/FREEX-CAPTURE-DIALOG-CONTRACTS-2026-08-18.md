# FreeX capture batches: 12 dialog contract and pixel failures

## Status

**RESOLVED.** All twelve pass. Every capture batch is green (Batch2 6/6, Batch3 8/8,
Batch4, Batch5 6/6, Batch6, Batch7 4/4), and all 34 tests excluded from the main assembly
by its `VSTestTestCaseFilter` are selected by some batch filter, so coverage is complete.

Resolved by: `f3ac016069` (inspection auto-close raced the contract probe),
`a103978c5c` (chrome normalization erased explicit group-box borders),
`bf6e939a9e` (the backstage overlay stayed open and covered every ribbon capture),
and `d9b99390ef` (two assertions rebased onto what they were protecting).

The notes below are kept for the diagnosis and the killed leads.

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


## contextual.PivotTableAnalyze renders as tab.Home — what is ruled out

The capture writes a PNG byte-identical to `tab.Home.png`, so nothing changed visually
at all, not even the tab-strip highlight. Four explanations have been tested and killed:

1. **Dispatcher timing.** `LayoutWindow` pumps only `RunJobs(Render)`, which runs jobs
   at Render and above, so content realized at Loaded/Background is still pending.
   Draining Background and Loaded first changes nothing.
2. **Context never applied.** The capture does call
   `_ribbonContextSource.SetParityCaptureContext(activationKey)` and re-finds the tab
   control afterwards, so the contextual tab is present when selection runs.
3. **Selection reset by a rebuild.** Re-asserting `SelectedIndex` against the rebuilt
   control after `LayoutWindow` changes nothing.
4. **Tabs not identified by `Tag`.** They are: `AvaloniaRibbonRenderer` builds each
   `TabItem` "tagged with the tab id", and its rebuild path diffs by that tag and
   restores the previously selected id (`AvaloniaRibbonRenderer.cs` ~565 and ~1074).

So the tab is present, correctly tagged, and selected, and the window still renders
Home. The next thing to check is whether the *capture* reads the same visual the
selection affected -- `CaptureWindowSurface` renders `this` (the shell window), while
the ribbon may be hosted in a surface that the selection updates independently. Compare
the captured bitmap against the ribbon control's own bounds rather than the window's.
