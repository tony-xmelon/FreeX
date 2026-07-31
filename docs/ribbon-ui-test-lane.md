# Ribbon UI test lane

A focused lane for the declarative ribbon's rendering, multi-resolution layout, resize behavior, and
performance. It exists because the ribbon was rewritten to a declarative/adaptive model and that surface
needs its own fast, targeted regression coverage separate from the broad UI lane.

## How to run

```sh
# Functional ribbon lane (runs by default - fast, deterministic):
dotnet test FreeX.RibbonTests.slnx --configuration Release --filter Category=RibbonUiLane

# Performance benchmarks (opt-in: timing is reported and asserted against a generous ceiling):
FREEX_RUN_BENCHMARK_TESTS=1 dotnet test FreeX.RibbonTests.slnx --configuration Release --filter Category=RibbonUiLanePerf
```

`FreeX.RibbonTests.slnx` scopes the build to `FreeX.App.Host.Tests` and
`Free.Shared.Ribbon.Wpf.Tests` (where the lane lives); the
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
- **No clipping** (`*.NoClipping.cs`) — at every width and on every tab the live arranged ribbon content
  fits within its panel (groups fold into overflow buttons) and never overflows the right edge. Guards the
  "resizing clips the ribbon" defect: the adaptive panel seeded each group's full width from its first
  (pre-icon-realization) measure and trusted that stale value, so it under-collapsed and clipped wide
  groups (e.g. Page Setup). `RibbonAdaptivePanel.MeasureOverride` now refreshes each expanded group's
  cached width from its realized size before deciding, so the collapse decision fits the real content.

## Known pre-existing drift in the older `MainWindowAdaptiveRibbonTests`

Fixing the layout loop un-crashed the legacy `MainWindowAdaptiveRibbonTests` (the whole class aborted the
test host before). With the loop gone, ~31 of its 85 tests still fail — these are **pre-existing
harness/test drift from the XAML→declarative cutover, not ribbon defects** (the lane's robust queries and
the live ribbon both work). They fall into two groups:

- **Stale tree-shape assumptions.** Queries like `ActiveRibbonGroupNames`, `CollapsedActiveRibbonGroupNames`,
  and `ActiveRibbonScrollViewer` look for a horizontal `StackPanel` whose direct children are ribbon
  groups, and `CollapsedRibbonGroupNames` reads the (now-empty) `HomeRibbonPanel`. The declarative ribbon
  instead nests each group `Grid` inside a `RibbonGroupHost` inside a `RibbonAdaptivePanel`, so these
  queries find nothing.
- **Missing metadata roles.** `RibbonWpfRenderer.BuildGroup` sets a group `CatalogId` but not the
  `RibbonGroup` role or `GroupName`, and command captions are not tagged `CommandLabel`. Queries that read
  those roles (group discovery, dropdown-chevron / split-button / content-layout checks) come back empty.
  (`GetButtonLabel` was given a caption fallback so the label-list assertions work again.)

A separate batch of older ribbon UI tests (e.g. `RibbonTabParityTests`) fails because they read the
**stripped** `MainWindow.xaml` via `RibbonXamlCatalogSnapshotReader.ReadMainWindow()` — after the
declarative cutover that XAML holds only empty tab headers, so the catalog they assert against is empty.
These are effectively dead (they should be re-pointed at `FreeXRibbon.Build()` or retired); they are
unrelated to the layout fix and to the Help tab (which lives in the declarative definition).

**Recommended follow-up (deliberately not done here to avoid risking the working ribbon):** seed the group
metadata in `RibbonWpfRenderer.BuildGroup` (`SetRole(grid, RibbonGroup)` + `SetGroupName(grid, header)`)
and tag command captions — this also benefits the live adaptive engine and keytips, but the live engine's
group-discovery/collapse then needs visual re-verification — **or** modernize those harness queries to walk
the `RibbonGroupHost`/`RibbonAdaptivePanel` tree. Either is a self-contained pass; track separately. New
ribbon coverage should be added to the `RibbonUiLane` files (which use declarative-aware queries), not the
legacy class.

## Background: the bug this lane was created around

The live FreeX ribbon used `FreeX.App.Host.RibbonAdaptivePanel`, whose `MeasureOverride` reset every group
to its full form and swapped each group's `Content` on **every** measure pass. Mutating the visual tree
mid-measure re-dirtied layout, so at narrow widths the pass never converged and WPF aborted it
("an infinite loop appears to have resulted from cross-dependent views") — surfacing as a blank,
unresponsive ribbon that only relaid out after resize and crashed under live drag. The fix caches each
group's natural width once and flips only the groups whose collapsed/expanded state actually changes, so a
steady-state resize swaps no content and the pass converges (the same approach already shipped in the
shared `Free.Shared.Ribbon.Wpf` panel). This lane locks that behavior in.
