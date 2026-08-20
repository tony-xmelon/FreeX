# Enter never reaches the Page Layout scale combos' commit handler

`MainWindowRenderedPageLayoutComboTests.RenderedScaleWidthCombo_CommitText_AppliesFitToPagesWide`
types "1 page" into the Scale Width combo, raises Enter, and expects `FitToPagesWide == 1`.

## Status

**RESOLVED** for the failing test. `PlanScalePercentCommit` now treats "Automatic" as a no-op while
fit-to-pages is set, which is what actually reverted the user's value;
`RenderedScaleWidthCombo_CommitText_AppliesFitToPagesWide` passes and two unit tests lock the
semantics both ways.

Blocker 1 below (ComboBox swallowing Enter) is **also fixed**: the combos now subscribe with
`handledEventsToo: true`, so a typed value with no matching list entry commits on Enter.

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

## Correction: the Enter fix does not regress keytips

An earlier revision of this note said `handledEventsToo` regressed
`PageLayoutSetupMenuKeyTips_UpdatePrintSettings`, based on single runs of each arm. **That was
wrong.** Measured over five runs per arm, that test passes **1/5 without** the fix and **2/5 with**
it -- it is intermittent either way, for reasons that have nothing to do with these combos (see
`FREEX-HOST-KEYTIP-TEST-INSTABILITY-2026-08-20.md`). Attributing an intermittent failure to a change
from one run of each is exactly the trap that instability sets.

The same caution applies to the two variants below: they were judged the same way and may also be
fine. They are recorded as *unmeasured*, not as rejected.

## Earlier, single-run judgements (unreliable)

Subscribing with `AddHandler(UIElement.KeyDownEvent, ..., handledEventsToo: true)` does make the
combo see Enter -- and **regresses**
`MainWindowRibbonKeyTipTests.PageLayoutSetupMenuKeyTips_UpdatePrintSettings`, which passes without
it and fails with it. Accepting already-handled Enter means the scale combos also act on Enter
presses that the keytip flow had already consumed.

Two further shapes were tried and **also regress the same keytip test**, each verified in isolation
against the unmodified code (which passes in 2s; each variant fails in ~7s):

1. `PreviewKeyDown` on the combo, gated on `IsKeyboardFocusWithin`. The handler only acts on Enter,
   and the keytip sequence is P,P,A -- letters it returns early for -- yet the menu stops opening.
2. Attaching that same `PreviewKeyDown` handler on `GotKeyboardFocus` and detaching it on
   `LostKeyboardFocus`, so it is not present at all during keytip navigation. Same failure.

The failure is always `Expected ActiveMenuIsOpen to be True because the ribbon keytip sequence
P,P,A should open a menu`. So it is not Enter being intercepted: *any* change to these combos' key
wiring disturbs keytip routing. That points at the keytip input pipeline rather than the combos, and
fixing it needs that pipeline understood rather than another wiring variant.

In practice the common path is covered: typing a value that matches a list entry updates
`SelectedItem`, and `SelectionChanged` commits it. The gap is a typed value with no matching entry.
