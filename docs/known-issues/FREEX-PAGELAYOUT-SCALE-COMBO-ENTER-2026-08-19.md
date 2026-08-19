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

## Blocker 2: the commit does not reach the asserted workbook

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
