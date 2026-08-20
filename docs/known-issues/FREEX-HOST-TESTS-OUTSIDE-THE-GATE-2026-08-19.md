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

## Also fixed: four backplane-refactor guards

Rounds 142-144 moved per-command ribbon writes into shared publishers both renderers consume. Four
guards still asserted the host-local calls and were repointed at the code that now owns the
behaviour, keeping what each was actually protecting:

- `RefreshToolbar_AvoidsRepeatedDependencyPropertyWrites` and
  `FontDropdownSelection_SyncsThroughStyleDiffToolbarStateAndGridTypeface` wanted
  `SetRibbonComboValue`, which no longer exists anywhere. Bold and Font now go through
  `WorkbookHomeFormatRibbonStatePublisher`, so the routing is asserted here and the writes where
  they moved to.
- `SplitRibbonCommand_ReflectsActiveSplitState` wanted a direct `SetChecked`. Split flows through
  `WorkbookViewRibbonStatePlanner` now, still from `viewState` and never the shared `Sheet` -- the
  per-window guarantee the guard existed for.
- `PageLayoutHandlers_RouteThroughExpectedThemePageSetupAndPrintCommands` wanted
  `new PageLayoutCommandSession([_currentSheetId])`. The shared `CreatePageLayoutCommandSession()`
  composes from `CurrentGroupedEditSheetIds()`, so a grouped-sheet selection applies to the whole
  group; the old assertion would have forbidden that.

## Remaining (1)

`MainWindowRenderedPageLayoutComboTests.RenderedScaleWidthCombo_CommitText_AppliesFitToPagesWide`.
Not a stale guard -- it found two real defects. See
`FREEX-PAGELAYOUT-SCALE-COMBO-ENTER-2026-08-19.md`.

## Instability worth knowing

This suite's full-run failure count swung **5 -> 9 -> 12 -> 16** across consecutive runs on
identical code, with keytip, grouped-sheet and clipboard tests appearing and disappearing. Judge a
failure here by re-running it alone before believing it, and treat any narrow change as unverifiable
against a full-suite count until that instability is addressed.

## Workflow gotcha worth knowing

`docs/parity/freep-whole-window-visual-evidence/artifact-manifest.json` records a sha256 for the
**source files** behind the evidence, not just the PNGs -- including
`shared/Free.Shared.Ribbon.Wpf/RibbonWpfRenderer.cs`. So editing a tracked source invalidates the
manifest and the generated-docs preflight fails until it is regenerated. That happened twice in
this session: the manifest was refreshed, then a later ribbon fix in a tracked file made it stale
again. The generator itself is deterministic (verified: two consecutive runs, identical hash), so
this is expected coupling rather than flakiness -- but it means "regenerate the manifest" belongs
at the end of a change that touches those sources, not the start.

## Recommendation

Add `FreeX.App.Host.Tests` to `FreeX.DefaultTests.slnx` once those five are resolved. Adding it
before then turns the gate red on day one, which is why it is not done here. Until it is in the
gate, run it explicitly after touching the WPF host.

## Resolved: the exclusion is deliberate, and adding the project breaks the gate

Tried on 2026-08-20 -- `tests/FreeX.App.Host.Tests` added to `FreeX.DefaultTests.slnx`, built
clean, full gate run. **Reverted.** Two independent reasons, either sufficient:

1. **The lane split is codified, not accidental.**
   `FreeX.Core.Model.Tests.TestLaneSolutionTests.DefaultTestLane_ExcludesUiTestProjects` asserts
   the default lane against an exact expected project list, precisely so UI projects stay in
   `FreeX.UiTests.slnx`. Adding the project fails that guard. This document's earlier
   "add it once stable" recommendation was written without noticing the guard, and was wrong:
   the right way to change the lanes is to change that test deliberately, not to drift the .slnx.

2. **The suite is not green.** The run finished 5180 passed / 8 failed / 24 skipped in 23m04s.
   None of the eight are the keytip tests fixed the same day; they are unrelated pre-existing
   failures, listed below. A gate that fails on every run trains people to ignore it.

```
R152_NameBoxCanonicalDisplayAfterEnterTests.NameBoxEnter_WithDefinedName...
R129_DrawingObjectKeyboardFamilyTests.ArrowKey_WithShapeSelected_NudgesObj...
R129_DrawingObjectKeyboardFamilyTests.EscapeKey_WithPictureSelected_Desele...
R51_MergedCellSelectionNavTests.ArrowKey_OnTallMergedCell_MovesPastFarEdge...
R74_NameBoxFormulaCollisionTests.NameBoxEnter_WithExistingNamedRangeName_S...
MainWindowFormulaBarSyncTests.FormulaBarPointMode_SelectedReferenceText_Re...
GeneratedDocsPreflightTests.GeneratedDocsPreflight_PassesFromOutsideReposi...
R123_BackspaceDrawingObjectTests.BackspaceKey_WithNoObjectSelected_StillCl...
MainWindowOutlineCommandLifecycleTests.OutlineGutterToggle_UsesMutationLif...
GoToNavigationR1C1RegressionTests.F4_InInlineEditor_WhenR1C1ModeEnabled_Cy...
```

So "host tests are outside the gate" is **by design**. The real gap it was pointing at -- that
nothing routinely runs these ~5,200 tests -- is better closed by running `FreeX.UiTests.slnx`
on a schedule, or by fixing the eight above so the suite is green enough to be worth gating on.
Do not re-add the project to the default lane without doing both.
