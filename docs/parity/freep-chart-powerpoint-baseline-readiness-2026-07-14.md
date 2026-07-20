# FreeP Chart PowerPoint Baseline Readiness - 2026-07-14

This no-COM slice prepares PowerPoint-authoritative chart visual baselines by adding a shared capture-readiness contract for the existing `22-chart-baseline-depth.pptx` corpus deck.

Shared status:

- `ChartRenderPlanner.BuildVisualBaselineReadinessPlan` now projects stable PowerPoint, WPF, and Avalonia chart-surface capture requests from shared `ChartShape` models.
- The readiness plan covers four high-value chart-family decisions already present in the corpus: stock high-low/open-close ticks, 3-D surface projected facets/wireframe/contours, smooth scatter Bezier paths, and 100% stacked normalized axis/series extents.
- The same no-COM readiness contract now distinguishes standard, marker, and filled radar chart decisions from the shared model, so WPF/Avalonia requests carry the same renderer-neutral spoke, ring, marker, fill-opacity, and blank-point evidence before PowerPoint PNGs are available.
- PowerPoint requests are explicitly marked as COM-required readiness contracts, while WPF and Avalonia requests remain deterministic shared-planner evidence on machines without desktop PowerPoint COM.
- Stable capture IDs include the scenario, slide, chart index, chart type, and host, so a COM-capable baseline machine can capture Microsoft PowerPoint PNGs and compare them against the same WPF/Avalonia chart surfaces.

Verification:

- `freep/FreeP.App.Presentation.Tests/ChartBaselineCorpusTests.cs` loads `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx` and covers the PowerPoint/WPF/Avalonia capture matrix, stable capture IDs, COM-required flags, and chart-family decision summaries.
- The radar style-specific test builds filled and marker radar models in memory, asserts their shared primitive plans, and verifies that WPF/Avalonia capture requests do not require PowerPoint COM while the paired PowerPoint request remains an explicit COM-required readiness row.

Follow-up COM evidence:

- Fresh PowerPoint exports now cover `22-chart-baseline-depth.pptx` (1/1),
  `18-chart-types.pptx` (4/4), and `19-chart-labels.pptx` (3/3) at 1280x720.
- Current mean WPF/Avalonia diffs are 2.6046%/1.0906% for the baseline-depth
  deck, 0.7585%/0.3122% for chart-types, and 1.2707%/0.6103% for chart-labels.
- Detailed provenance and residual ownership are recorded in
  `docs/parity/freep-chart-powerpoint-com-baseline-20260720.md`.

Remaining blockers are now narrower: exact Surface3D mesh/camera/facet
ownership, WPF chart-label rasterization, broader real-deck radar/stock/
doughnut/bubble coverage, and family-specific pixel-diff thresholds still
require additional authoritative captures and scoped renderer work.
