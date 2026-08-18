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

**Unverified hypothesis:** the batch capture projects now reference `Avalonia.Skia` (added
so the PNGs render at all). Real glyph rasterization measures text differently from
`UseHeadlessDrawing`, so expectations authored under the old harness could be 3px off
without the product having changed. This needs checking before anyone edits the constants.

Do **not** rebase the expected bounds to the observed values until that is settled — the X
bounds matching WPF exactly is good evidence the expectations are genuine WPF-derived
numbers, not arbitrary ones.

## Note on test visibility

This test does not run in the main `FreeX.App.Avalonia.Tests` pass. That csproj carries a
`VSTestTestCaseFilter` excluding 35 capture/contract tests, which run only via the
`FreeX.App.Avalonia.CaptureTests.Batch*` projects. A green "2072/2072" on the main
assembly says nothing about these.
