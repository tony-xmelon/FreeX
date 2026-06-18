# Ribbon UI test lane

A focused lane for the declarative ribbon's rendering, multi-resolution layout, resize behavior, and
performance. It exists because the ribbon was rewritten to a declarative/adaptive model and that surface
needs its own fast, targeted regression coverage separate from the broad UI lane.

## How to run

```sh
# Functional ribbon lane (runs by default — fast, deterministic):
dotnet test FreeX.RibbonTests.slnx -c Release --filter Category=RibbonUiLane

# Performance benchmarks (opt-in: timing is reported and asserted against a generous ceiling):
FREEX_RUN_BENCHMARK_TESTS=1 dotnet test FreeX.RibbonTests.slnx -c Release --filter Category=RibbonUiLanePerf
```

`FreeX.RibbonTests.slnx` scopes the build to `FreeX.App.Host.Tests` (where the lane lives); the
`Category=RibbonUiLane` / `RibbonUiLanePerf` trait filter selects the ribbon tests. The lane is **not** a
substitute for the default merge-gate lane (`FreeX.DefaultTests.slnx`).

## What it covers

All tests are `[Trait("Category","RibbonUiLane")]` (functional) or `RibbonUiLanePerf` (benchmark), in
`tests/FreeX.App.Host.Tests/MainWindowAdaptiveRibbonTests.RibbonLane.*.cs`:

- **Tab rendering** (`*.TabRendering.cs`) — every declarative main tab (Home, Insert, Draw, Page Layout,
  Formulas, Data, Review, View) and every contextual tab renders its groups and expanded commands across a
  ladder of window widths (1500 → 700). Catches "a tab renders blank".
- **Adaptive convergence** (`*.Convergence.cs`) — drives each tab's real adaptive panel, offscreen, through
  a full shrink→grow resize sweep (1500 → 380 → 1500) and asserts the layout pass converges (never throws
  WPF's "cross-dependent views" infinite-loop) and settles deterministically back to the same state at the
  start width. This is the regression guard for the layout loop that blanked/froze the ribbon.
- **Resize performance** (`*.Performance.cs`) — a redundant same-width resize re-applies no adaptive state;
  a back-and-forth resize sweep reuses its measurement caches (no re-measuring on revisited widths); a
  benchmark reports per-step resize timing.

## Background: the bug this lane was created around

The live FreeX ribbon used `FreeX.App.Host.RibbonAdaptivePanel`, whose `MeasureOverride` reset every group
to its full form and swapped each group's `Content` on **every** measure pass. Mutating the visual tree
mid-measure re-dirtied layout, so at narrow widths the pass never converged and WPF aborted it
("an infinite loop appears to have resulted from cross-dependent views") — surfacing as a blank,
unresponsive ribbon that only relaid out after resize and crashed under live drag. The fix caches each
group's natural width once and flips only the groups whose collapsed/expanded state actually changes, so a
steady-state resize swaps no content and the pass converges (the same approach already shipped in the
shared `Free.Shared.Ribbon.Wpf` panel). This lane locks that behavior in.
