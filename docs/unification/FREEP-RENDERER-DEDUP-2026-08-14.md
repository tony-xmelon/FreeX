# FreeP Renderer Dedup Campaign - 2026-08-14

> **Status: COMPLETE; PRACTICAL SCOPE EXHAUSTED AND CERTIFIED.** This campaign reopened the FreeP renderer
> boundary after later shared-shell and presentation-policy work made additional WPF/Avalonia extraction
> practical. The campaign baseline is `d30813abf43b3700a559cf2775e2512b2d135957` on `origin/main`.

## Objective

Reduce FreeP's remaining WPF/Avalonia renderer duplication while preserving behavior and visual parity. Move
portable state, workflow, projection, geometry, validation, and accessibility decisions into
`FreeP.App.Presentation` or an appropriate shared project. Keep native control construction, framework event
translation, drawing APIs, accessibility attachment, window lifetime, and platform effects in thin renderers.

The working target is 9-11% exact duplicate coverage across the four measured FreeP renderer roots. A lower
number is welcome only where the resulting contract remains simpler than the duplicated native realization.

## Baseline

The deterministic residual measurement at the campaign baseline reports:

| Root | Renderer code lines | Exact duplicate lines | Exact coverage |
|---|---:|---:|---:|
| FreeP WPF app | 15,036 | 2,982 | 19.832402% |
| FreeP WPF rendering | 5,621 | 698 | 12.417719% |
| FreeP Avalonia app | 16,789 | 2,997 | 17.850974% |
| FreeP Avalonia rendering | 6,747 | 714 | 10.582481% |
| **FreeP combined** | **44,193** | **7,391** | **16.724368%** |
| All measured renderer roots | 250,936 | 8,516 | 3.393694% |

The generated [residual metrics](dedup-residual-metrics.md) are the source of truth. They are regenerated after
each integrated wave and at final certification.

## Initial work lanes

| Lane | Baseline matched lines | Intended portable owner | Status |
|---|---:|---|---|
| Main window pane, state, command, and accessibility projection | 1,204 | FreeP presentation workarea/frame policies | Exhausted |
| Slideshow, Presenter View, and media orchestration | 891 | FreeP slideshow/presenter sessions and plans | Exhausted |
| Dialog and pane families | about 850 | FreeP dialog schemas, sessions, and projection plans | Exhausted |
| Canvas, chart execution, gesture, selection, and automation projection | 743 | FreeP rendering-neutral plans and sessions | Exhausted |
| Cross-product startup/localization normalized matches | Whole-file normalized matches only | Shared shell where a useful contract exists | Intentional thin composition |

## First integrated checkpoint

The first integrated checkpoint through `498856d2af` contains nine focused commits. It centralizes dialog and
pane adapters, canvas orchestration, media-pane projection, visual-evidence host policy, slideshow/presenter
actions, paired render-comparison tooling, palette and Avalonia geometry adapters, rich-text edit transactions,
and MainWindow pane accessibility state.

| Measure | Baseline `d30813abf4` | First checkpoint | Delta |
|---|---:|---:|---:|
| FreeP renderer code lines | 44,193 | 43,695 | -498 |
| FreeP exact duplicate lines | 7,391 | 6,635 | -756 |
| FreeP exact coverage | 16.724368% | 15.184804% | -1.539564 points |
| FreeP normalized duplicate lines | 7,789 | 7,287 | -502 |
| FreeP normalized coverage | 17.624963% | 16.676965% | -0.947998 points |
| Repository exact duplicate lines | 8,516 | 7,760 | -756 |
| Repository exact coverage | 3.393694% | 3.099413% | -0.294281 points |

The first checkpoint is not the target. A second extraction wave is addressing the remaining large MainWindow,
SlideCanvas, slideshow/presenter, and dialog/pane block families.

## Intentional thin composition

The normalized whole-file matches in FreeP/FreeW Avalonia `Program.cs` and WPF `AppLocalization.cs` remain
product-owned. Each entry point is already an eight-line adapter over `SisterAvaloniaStandardDesktopFactory`,
and each localization facade is an eight-line binding from product resources and culture resolution to
`WpfAppLocalizationBootstrap`. Moving either into another wrapper would hide product composition without
removing policy or behavior.

Native rich-text document realization, native visual-capture primitives, OLE/clipboard/print/media backends,
window lifetime, and framework accessibility attachment also remain renderer responsibilities. Their portable
transactions, orchestration, state, and metadata are campaign scope; their native effects are not.

## Final measured result

The synchronized exhaustion checkpoint reports:

| Measure | Baseline `d30813abf4` | Exhaustion checkpoint | Delta |
|---|---:|---:|---:|
| FreeP renderer code lines | 44,193 | 42,426 | -1,767 |
| FreeP exact duplicate lines | 7,391 | 5,372 | -2,019 |
| FreeP exact coverage | 16.724368% | 12.662047% | -4.062321 points |
| FreeP normalized duplicate lines | 7,789 | 5,950 | -1,839 |
| FreeP normalized coverage | 17.624963% | 14.024419% | -3.600544 points |
| Repository exact duplicate lines | 8,516 | 6,549 | -1,967 |
| Repository exact coverage | 3.393694% | 2.628938% | -0.764756 points |

Renderer-root exact coverage is 15.408022% for the WPF app, 13.860896% for the Avalonia app, 8.397790% for
WPF rendering, and 7.011476% for Avalonia rendering. The final synchronization incorporated upstream shared
table-edit transaction work, adding paired native table-cell editor realization after the earlier exhaustion
checkpoint. The campaign also removed duplicated visual-evidence,
render-comparison, ownership-test, and MSBuild variant plumbing outside the measured renderer roots.

The original 9-11% working target was not reached. Repeated implementation attempts established that reaching
it would require a generalized WPF/Avalonia control-tree or rendering schema, source-linked/generated native
window APIs, or compatibility-surface removal. Those mechanisms would add more indirection and risk than the
remaining lexical duplication warrants.

## Residual ownership

| Residual family | Approximate paired matched lines | Classification |
|---|---:|---|
| MainWindow | 860 | Native control inventory/construction, media chrome, recursive menu realization, platform event/focus/UIA wiring, and ribbon endpoint composition around shared policies. |
| SlideShowWindow | 453 | Public compatibility facade, native transitions/storyboards, framework timers, ink/media overlays, monitor and window lifetime. |
| SlideCanvas plus chart/gesture/adorner/table-editor files | about 486 | Native text/drawing artifacts, chart clipping/geometry, automation inheritance/events, cursors, coordinate conversion, and native table-cell controls around shared render sequences and edit transactions. |
| PresenterViewWindow and media controllers | 323 | Native Grid/control/preview construction, window chrome/events, monitor and media backend realization. |
| Dialog and pane pairs | about 544 | Native control trees, styling, event wiring, focus and modal lifetime around shared schemas, sessions, validation and action routing. |
| Small normalized startup/localization pairs | Whole-file matches | Intentional product composition over existing shared factories/bootstrap. |

The final MainWindow tail audit also rejected a layout-picker adapter, domain context-menu adapter, and ribbon
profile facade: each replaced direct native loops or endpoint binding with delegate plumbing without moving any
additional policy.

## Certification

Repository certification was run from the isolated campaign worktree after synchronizing with `origin/main`.

- Repository preflight and generated-document checks pass.
- `FreeX.slnx` Release build passes with zero warnings and zero errors.
- The complete default test solution passes serially; FreeP Presentation alone reports 4,935 passing tests.
- The UI solution contents pass as direct, non-duplicated partitions: 5,132 WPF host tests, 1,055 app UI tests,
  and 51 shared WPF ribbon/shell tests pass. There are 51 declared benchmark or live-E2E skips and no failures.
- Current whole-window FreeP evidence passes all 33 scenarios on WPF and Avalonia with no mismatch, limitation,
  or duplicate scenario. Dialog/pane evidence captures all 28 paired scenarios with no capture limitation.
- The stabilized whole-window baseline and candidate each pass 33/33. Of 168 compared PNGs, 163 are byte-identical;
  the five Account-pane artifacts differ only in displayed commit/version text (client mean pixel difference
  0.0780% WPF and 0.0720% Avalonia).
- The stabilized pre-campaign and pre-sync dedup dialog captures are byte-identical across all 123 PNG artifacts.
  Both live reports classify the same 19 comparisons as passes and the same nine as known semantic/parity
  mismatches. After the final upstream compact-dialog synchronization, a clean recapture again paired 28/28 with
  no limitation and no classification change: 93 artifacts remain byte-identical, while 15 Avalonia targets and
  their 15 derived diffs reflect the synchronized shared-token refinements (0.9698% average and 2.8583% maximum
  mean-channel delta).
- A post-sync whole-window recapture again passes 33/33. Of its 168 PNGs, 160 are byte-identical to baseline; five
  Account artifacts contain commit/version text and three Recent artifacts contain the harness-opened corpus path.

Certification also repaired two pre-existing UI-lane defects found while closing the campaign: authored print
scales above 100% are no longer canceled by residual-fit clamping, and redirected PowerShell test processes drain
stdout and stderr concurrently instead of deadlocking on expected-error fixtures. Final live capture additionally
rejected brittle Avalonia button/ComboBox control-tree replacement in favor of native templates over shared visual
tokens, and added headless editable/non-editable ComboBox coverage.

## Completion rule - met

The campaign is complete when repeated residual audits find no remaining stable renderer-neutral contract with
meaningful duplication reduction, all accepted slices pass focused and repository-wide verification, and FreeP
WPF/Avalonia visual evidence remains equivalent to the baseline within documented native rendering tolerances.
Residual native matches will be listed with their ownership reason and estimated cost so the final percentage is
not mistaken for unexamined scope.

## Independent re-verification - 2026-08-15

Re-checked from outside the campaign, at `origin/main` after the campaign closed, using a method the campaign
did not use: duplicated **regions** (overlapping sliding windows merged into contiguous spans) rather than raw
window counts, plus cross-tier measurement that includes the neutral and shared tiers.

**Drift since certification is noise, not regression.**

| Measure | Certified checkpoint | 2026-08-15 | Drift |
|---|---:|---:|---:|
| FreeP renderer code lines | 42,426 | 42,377 | -49 |
| FreeP exact duplicate lines | 5,372 | 5,389 | +17 |
| FreeP exact coverage | 12.662047% | 12.716800% | +0.055 points |

Per root: WPF app +0.036, Avalonia app +0.021, WPF rendering +0.008, Avalonia rendering +0.236 points. The
movement tracks upstream work merged after the exhaustion checkpoint; no lane reopened.

**The residual classification holds.** Measured as distinct regions, FreeP's renderer duplication is 76 regions
covering 1,526 lines. Sampling every region and matching it against the shared tiers:

- Roughly half reference a shared model by name in the duplicated span itself -- `SlideShowWindowLaunchPlan`,
  `PresentationPresenterViewVisualMetrics`, `SlideShowPresenterViewField`, `PresentationAltTextPaneHostCoordinator`,
  `SlideShowPresenterToolPlan`. These are two frameworks realizing one shared decision.
- Of the regions that name no shared type, the surviving cases are explicit `ISlideShowDisplayRenderer`
  implementations wrapping per-framework timers (the interface *is* the sharing mechanism), the ribbon-profile
  delegate table binding shared command slots to per-shell dialog openers, and parameter forwarding into shared
  records. All three are the categories the extraction rule keeps native.

**A caution for anyone re-opening this on the numbers alone.** A normalized/structural matcher (identifiers and
literals folded to placeholders) reports far more FreeP "duplication" than exists: C# declaration shapes repeat
everywhere, so FreeP enum members match FreeW record parameters, and two Backstage text catalogs match because
both are lists of `const string` with necessarily app-specific values. The exact column is the signal; treat the
normalized column as a lead, not a finding. Likewise, raw window counts overstate by roughly 8x on this codebase
because one region is recounted at every sliding offset.

**Coverage gap that existed during the campaign is now closed.** `Measure-DedupResiduals.ps1` only compared
renderer roots against each other, so neither neutral<->neutral nor neutral<->renderer duplication was visible to
it. The neutral tiers and `shared/` are now measured roots. `FreeP.Presentation` reports 0.013% exact coverage,
so FreeP's portable tier is tracked from here on rather than assumed.

**Verdict: closed.** The certified conclusion is independently reproducible, the stated reason for stopping above
the 9-11% target is sound, and the remaining lexical duplication is native realization of shared decisions.
