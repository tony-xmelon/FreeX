# Enter never reaches the Page Layout scale combos' commit handler

`MainWindowRenderedPageLayoutComboTests.RenderedScaleWidthCombo_CommitText_AppliesFitToPagesWide`
types "1 page" into the Scale Width combo, raises Enter, and expects `FitToPagesWide == 1`.

## Status

Open. Two independent blockers, the first proven, the second located but not fixed. No code
change is committed for either -- see "Why nothing is committed".

## Blocker 1: ComboBox eats Enter before the handler (proven)

`PopulateAndWireRenderedPageLayoutCombos` wires the commit with
`widthBox.KeyDown += PageLayoutScaleWidthBox_KeyDown`. A CLR event subscription does not receive
already-handled events, and `ComboBox`'s own class handler marks Enter handled first.

Proven by attaching a second probe to the same control with `AddHandler(..., handledEventsToo:
true)`, which logged:

```
INLINE fired key=Return handled=True
```

while the plain `+=` handler never ran at all. So typing a value and pressing Enter cannot commit
it. The same wiring is used for Scale Height and Scale Percent.

The fix is to subscribe with `AddHandler(UIElement.KeyDownEvent, ..., handledEventsToo: true)` (or
to use `PreviewKeyDown`).

## Blocker 2 (corrected): the Percent combo's echo clears fit-to-pages

An earlier revision of this note said the commit "does not reach the asserted workbook". **That was
wrong** -- it read the model *before* the apply. Instrumenting the execution shows the width commit
works and is then undone:

```
exec label=[Scale To Fit] ok=True noop=False wide=1    afterModel=1      <- applied
exec label=[Scale To Fit] ok=True noop=False wide=null afterModel=null   <- reverted
```

The second commit comes from the **Percent** combo, not from focus loss:

```
  selChanged Width   suppress=False     <- real edit, commits wide=1
  selChanged Percent suppress=False     <- echo of our own sync, unsuppressed
  commitPercent text=[auto] lastSynced=[100]
```

`SyncPageLayoutScaleToFitControls` writes all three combos inside `_suppressToolbarSync`, but a
`ComboBox` raises `SelectionChanged` for those writes on a **later dispatcher turn**, by which time
the flag has been reset. The echo is therefore treated as a user edit.

What makes it destructive is the value: with fit-to-pages active the Percent combo correctly reads
`auto`, and `PlanScalePercentCommit` treats `auto` as "switch to automatic percent", which clears
`FitToPagesWide`. A passive display value is being read as an intent to change mode.

## The decision this needs

`auto` in the Percent combo means "percent is not in use because fit-to-pages is", so committing it
while fit-to-pages is set should be a no-op rather than a mode switch. That is a one-line change in
`PlanScalePercentCommit`, but it is a product-semantics call about what an automatic percent commit
means, so it is left to the owner rather than guessed.

## Rejected: echo suppression by value

Tracking what the sync wrote and ignoring a matching `SelectionChanged` looks right but does not
work at that layer, and two attempts are recorded here so they are not repeated. Storing
`state.PercentValue` compares a display label ("100%", "Automatic") against what a commit reads,
which is the choice value ("100", "auto") -- they never match. Storing the post-sync
`GetComboBoxText` instead reads the control *before* the deferred write lands, so it captures the
old value. The echo is only distinguishable at the point where its meaning is decided, which is why
the fix belongs in the percent planner.

## Superseded: the commit does not reach the asserted workbook

With Blocker 1 worked around, the commit runs with the right text and the plan says apply:

```
widthCommit text=[1 page] comboText=[1 page] sel=[Value = 1, Label = 1 page] model=null
  shouldApply=True groupedIds=1
widthCommit text=[Automatic] ...                                             model=null
```

`model` is read through the window's own `_workbook` and stays null **after** a commit that
reported `shouldApply=True` with one grouped sheet id. A second commit then fires from
`LostKeyboardFocus` carrying the refreshed "Automatic" text. So the command executes but does not
mutate the workbook the test asserts on -- the test builds the bus as
`new CommandBus(_ => new TestCommandContext(workbookRef.Current))`, so this is most likely a
harness/wiring question about which workbook instance the command context resolves.

## Killed leads

- **Name re-point.** `RibbonBackplaneControlNames["Scale Width"] = "PageLayoutScaleWidthBox"` is
  mapped and `RepointBackplaneNamesToRenderedControls` runs; instrumenting it showed
  `resolves=rendered`, and the control the test finds is the same instance the wiring saw
  (`widthHash=27424625` at wire time, `test found hash=27424625`).
- **Wiring skipped.** It ran once with `alreadyWired=False`, `hasScaleWidth=True`, `isCombo=True`.
- **`GetComboBoxText` preferring SelectedItem over typed text.** Plausible on inspection, but the
  trace shows `text=[1 page]` already -- WPF had matched the typed text to the item, so changing
  the precedence altered nothing here.
- **Missing combo re-sync after a commit.** Adding `SyncPageLayoutScaleToFitControls` after a
  successful apply did not help, because the apply itself never reached the model.

## Why nothing is committed

Blocker 1's fix is correct in isolation but does not make the test pass on its own, and this
project's full-suite failure count swung 5 -> 9 -> 12 -> 16 across consecutive runs on identical
code, so a regression from a narrow change cannot be distinguished from that noise here. Landing a
change that cannot be verified in the suite it lives in is how a plausible-but-wrong fix gets
buried. The proof above is enough for whoever fixes Blocker 2 to land both together.
