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
