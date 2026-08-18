# Go To Special group bounds drift 3px vertically

`CaptureParitySurfaces_CapturesGoToSpecialAtFixedSizeWithoutClipping` expects the
group-border bounds `(13, 43, 400, 274)`.

## Status

Partially resolved. Two stacked regressions; the first is fixed.

## Fixed: the borders were missing entirely

`a103978c5c`. The chrome normalization pass on `Window.Opened` re-applied
`ApplyGroupBox` without the dialog's explicit border brush, resetting it to the shared
default. The capture found **zero** pixels of `(213, 223, 229)` — bounds came back as
`(430, 438, -1, -1)`, the uninitialised sentinel.

The `Button` case directly below in the same switch already guards against this exact
hazard; `GroupBox` never got the same treatment.

After the fix the borders render and the **X bounds match WPF exactly (13, 400)**.

## Remaining: 3px vertical drift

Actual is now `(13, 46, 400, 280)` — top +3, bottom +6. So the group is 3px taller *and*
sits 3px lower, meaning something above it grew 3px and something inside grew 3px more.

The suspect is text metrics. `content` opens with a SemiBold `TextBlock`
(`MainWindow_Content_Select`, bottom margin 7) directly above `availableGroup`, and the
value-type group's contents are text-driven too. A font-metric change shifts both by
exactly this pattern.

**Root cause (verified):** the expected Y values encode *stub* text metrics.

At `77d4932071` — the commit that authored both the constants and the bounds — the test
ran in `FreeX.App.Avalonia.Tests` with **no `Avalonia.Skia` reference and no
`VSTestTestCaseFilter`**, i.e. under `UseHeadlessDrawing`. The batch capture projects now
reference `Avalonia.Skia` (added this session so the PNGs render at all; without it the
capture produces an empty PNG, which is why those 35 tests are filtered out of the main
assembly today).

Skia measures real glyphs where headless drawing does not, so the SemiBold
`MainWindow_Content_Select` TextBlock above the groups — and the text inside them — take
3px more height each. That is exactly the observed pattern: top +3, bottom +6.

**This is a harness-environment artifact, not a product regression.** The layout is
correct: the X bounds match to the pixel.

Do **not** rebase the expected bounds to the observed values until that is settled — the X
bounds matching WPF exactly is good evidence the expectations are genuine WPF-derived
numbers, not arbitrary ones.

## Killed leads

- **Not the layout constants.** `AvaloniaChoiceGroupTopMargin` (3), `BottomMargin` (13) and
  `AvaloniaContentTopMargin` (12) in `GoToDialogPlanner.cs` are byte-identical to their
  values in `77d4932071`, the commit that tuned the constants and authored the expected
  bounds *together* — so the test did pass at that commit.
- **Not the chrome normalization re-applying `ApplyGroupBox`.** Stubbing the `GroupBox`
  case out of the descendant pass entirely leaves the bounds at `(13, 46, 400, 280)`,
  unchanged.
- **Not the shared metric tokens.** `CompactDialogVisualTokens.FontSize` is 12 and
  `BorderThickness` is 1 — the same literals the chrome used before they were tokenised.

- **Not the TextBlock font normalization.** `645bd68d04` added a pass setting
  `textBlock.FontFamily = style.FontFamily` on TextBlocks without their own. Suppressing it
  for text-bearing TextBlocks leaves the bounds at `(13, 46, 400, 280)`, unchanged.

## The decision required

The test hardcodes stub-metric Y values in five places: the bounds `(13, 43, 400, 274)`,
two `CountExactColorOnRow` calls at rows 43 and 274, and `FindAccentRows` expecting
`[369, 388]`. All of them shift under Skia.

Rebasing them to the observed values would bake **this machine's installed font metrics**
into the assertions. Adding Skia is what made these pixel tests font-dependent in the first
place, so the choice is between rebasing (accepting font sensitivity) and making the Y
assertions tolerant while keeping the exact X checks that genuinely verify layout. That is
a harness-design call, deliberately left to the owner rather than settled unilaterally.

Note the failure messages claim "WPF logical bounds", but these numbers came from an
Avalonia headless capture — no WPF render was involved. Same overstated-authority pattern
as the ScenarioManager `#DDDDDD` assertion.

## Note on test visibility

This test does not run in the main `FreeX.App.Avalonia.Tests` pass. That csproj carries a
`VSTestTestCaseFilter` excluding 35 capture/contract tests, which run only via the
`FreeX.App.Avalonia.CaptureTests.Batch*` projects. A green "2072/2072" on the main
assembly says nothing about these.
