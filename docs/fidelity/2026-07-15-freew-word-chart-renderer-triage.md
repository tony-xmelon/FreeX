# FreeW Word Chart Renderer Triage - 2026-07-15

## Scope

This slice continues the FreeW parity lane on the Word-capable machine. It targets
the shared chart visual proof fixture, `chart-smartart-complex`, while preserving
the native SmartArt cached-drawing work already merged on `main`.

## Changes

- Rounded chart value-axis bounds to Word-style major units. The fixture's column
  chart now uses `0..3` and its scatter chart uses `0..80` instead of exposing
  raw extrema such as `2.2` and `66`.
- Increased chart title and axis-title typography and reserved the compact plot
  area used by Word for category labels and the legend.
- Restored Word's single-series per-category palette progression in both WPF and
  Avalonia renderers.
- Added the colorful scatter marker sequence used by Word: diamond, square,
  triangle, and X, with no connecting polyline.

### Imported scatter marker palette

The live Word baseline for `chart-smartart-complex.docx` is a marker-only
scatter chart. Although its package contains the `colorful1` color-scheme
extension and blue, orange, grey, and yellow `c:dPt` fills, Word does not use
those per-point fills when the series has no explicit `c:marker` shape
properties. FreeW retains the authored fills for package round-tripping, but
its visual plan follows the observed Word style-4 `colorful1` blue/grey point
palette: `#234075`, `#2B4E8C`, `#7180AA`, and `#B0B7CB`.

The regression test
`ChartPlan_ImportedNativeScatterStyle_UsesWordBlueGrayPointPalette` locks this
palette. `ChartScene_LineAreaAndScatter_UseSharedPointAndMarkerPrimitives`
separately locks the Word marker cycle (diamond, square, triangle, cross) and
the absence of a connecting line.

## Verification

Focused tests passed:

- `dotnet test freew/FreeW.App.Presentation.Tests/FreeW.App.Presentation.Tests.csproj --configuration Release --filter FullyQualifiedName~ChartSmartArtVisualPlannerTests`
  - 29 passed.
- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~ChartRenderingTests`
  - 17 passed.
- `dotnet build freew/FreeW.App.Avalonia/FreeW.App.Avalonia.csproj --configuration Release --no-restore`
  - succeeded with 0 warnings and 0 errors.

The final focused visual run is retained at:

`freew-fidelity-corpus/runs/current-chart-word-baseline-20260715-r3`

Against the cached real-Word PNGs from the earlier baseline, page 1 improved from
mean channel deltas of `15.1455` Avalonia and `12.0072` WPF to `10.716` and
`8.392`. The comparison still fails the strict `word-png-default` threshold,
which is expected: the cached page 1 contains a pre-scaffold SmartArt rendering,
and page 2 remains the pre-scaffold pyramid capture. This run is evidence of
renderer improvement, not a final parity claim.

## Word automation note

The fresh full Word export could not be used as authoritative evidence in this
run. The export path opened the generated documents but Word was held by a modal
privacy/first-run dialog and returned `RPC_E_CALL_REJECTED` to subsequent COM
calls. The user's `field-page-number-variants.docx` remained open and untouched.
Several pre-existing parity exporters were also connected to the shared Word
process, so generated windows were not forcibly removed from that user-owned
session.

## Next backed target

Refresh the chart and SmartArt Word PNG baseline from a quiet Word process after
the native cached drawing scaffold is present. Then rerun this same strict proof;
only after that comparison should the remaining SmartArt page deltas be treated
as product fidelity failures rather than stale-baseline differences.
