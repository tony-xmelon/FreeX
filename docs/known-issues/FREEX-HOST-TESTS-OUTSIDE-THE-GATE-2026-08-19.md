# FreeX.App.Host.Tests is not in the gate, and failures accumulated there

## The systemic finding

`dotnet test FreeX.DefaultTests.slnx` does not include `tests/FreeX.App.Host.Tests` -- about
5,160 tests over the WPF host. Eighteen test projects sit outside the gate in total:

```
freew/*.Tests                      (7 projects)
tests/FreeX.App.Host.Tests         (+ Batch1..Batch7)
tests/FreeX.App.UI.Tests
tests/Free.Shared.Ribbon.Wpf.Tests
tools/FreeP.RenderCompare.Tests
```

Nothing runs them routinely, so drift piles up unnoticed. When first run in this session the
FreeX host project had **12 failures**; none were caused by the work in this session (which
touched no `src/FreeX.App.Host/` file).

## Fixed (12 -> 5)

- **Stale generated artifacts**, each regenerated with its own documented generator: the
  cross-app parity dashboard, the FreeP whole-window visual evidence manifest (173 artifacts),
  the FreeW shell visual evidence, and the FreeW command inventory. The generated-docs preflight
  chains these, so they had to be refreshed in order.
- **Double-encoded documentation text** -- an em-dash written as UTF-8, misread as CP1252 and
  re-encoded, which the mojibake guard catches. Repaired by round-tripping the file.
- **The workbook-close clipboard guard.** Round 143 routed two direct calls behind
  `ClearClipboardMarqueeIfOwnedByThisWindow`, which does both but only when this window owns the
  marquee -- so closing one window cannot destroy another's still-pasteable copy. The guard
  asserted the old direct calls, which would have forbidden that routing.

## Remaining (5)

All trace to the in-flight ribbon backplane refactor (`MainWindow.RibbonBackplane.g.cs` is
generated) landed across Rounds 142-144:

- `MainWindowSourceHygieneTests.FontDropdownSelection_SyncsThroughStyleDiffToolbarStateAndGridTypeface`
- `MainWindowSourceHygieneTests.RefreshToolbar_AvoidsRepeatedDependencyPropertyWrites`
- `MainWindowSourceHygieneTests.SplitRibbonCommand_ReflectsActiveSplitState`
- `MainWindowRenderedPageLayoutComboTests.RenderedScaleWidthCombo_CommitText_AppliesFitToPagesWide`
- `PageLayoutCommandSourceTests.PageLayoutHandlers_RouteThroughExpectedThemePageSetupAndPrintCommands`

The guards assert `SetRibbonComboValue(...)`, which **no longer exists anywhere in production** --
the font combo is now driven declaratively through `RibbonBackplaneControlNames["Font"] =
"FontNameBox"`. Rewriting them means deciding what the new mechanism should be guaranteed to do,
which belongs to whoever is doing that refactor. Guessing would just encode a different wrong
expectation.

## Recommendation

Add `FreeX.App.Host.Tests` to `FreeX.DefaultTests.slnx` once those five are resolved. Adding it
before then turns the gate red on day one, which is why it is not done here. Until it is in the
gate, run it explicitly after touching the WPF host.
