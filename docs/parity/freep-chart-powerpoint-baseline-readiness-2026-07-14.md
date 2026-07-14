# FreeP Chart PowerPoint Baseline Readiness - 2026-07-14

This no-COM slice prepares PowerPoint-authoritative chart visual baselines by adding a shared capture-readiness contract for the existing `22-chart-baseline-depth.pptx` corpus deck.

Shared status:

- `ChartRenderPlanner.BuildVisualBaselineReadinessPlan` now projects stable PowerPoint, WPF, and Avalonia chart-surface capture requests from shared `ChartShape` models.
- The readiness plan covers four high-value chart-family decisions already present in the corpus: stock high-low/open-close ticks, 3-D surface projected facets/wireframe/contours, smooth scatter Bezier paths, and 100% stacked normalized axis/series extents.
- PowerPoint requests are explicitly marked as COM-required readiness contracts, while WPF and Avalonia requests remain deterministic shared-planner evidence on machines without desktop PowerPoint COM.
- Stable capture IDs include the scenario, slide, chart index, chart type, and host, so a COM-capable baseline machine can capture Microsoft PowerPoint PNGs and compare them against the same WPF/Avalonia chart surfaces.

Verification:

- `freep/FreeP.App.Presentation.Tests/ChartBaselineCorpusTests.cs` loads `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx` and covers the PowerPoint/WPF/Avalonia capture matrix, stable capture IDs, COM-required flags, and chart-family decision summaries.

Remaining blockers:

- This slice does not capture Microsoft PowerPoint screenshots locally; the PowerPoint rows are readiness contracts for a COM-capable baseline host.
- Exact Microsoft PowerPoint visual baselines, pixel-diff thresholds, and any remaining chart-type-specific rendering decisions beyond the stock, 3-D surface, smooth scatter, and 100% stacked-column fixture coverage still require the authoritative capture run.
