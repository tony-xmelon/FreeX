# FreeP Radar Style Render Planning - 2026-07-14

## Scope

This no-COM chart slice makes the radar chart type-specific render decision explicit for paired WPF/Avalonia evidence. It covers standard, marker, and filled radar styles from the shared FreeP chart model without claiming Microsoft PowerPoint-native PNG baselines.

## Evidence

- `ChartRenderPlanner.BuildRadarPrimitivePlan` owns radar rings, spokes, category labels, closed standard polygons, filled area opacity, marker points, and blank-point path splitting.
- WPF and Avalonia slide canvases both consume `ChartRenderPlanner.BuildRadarPrimitivePlan(chart, plot, seriesColors, fillPlans)`, draw the shared path list, and draw shared marker primitives.
- WPF and Avalonia render smoke tests cover filled radar charts through their host-specific `SlideCanvas` surfaces.
- The radar baseline-readiness test now projects standard, filled, and marker radar capture requests for WPF/Avalonia while leaving PowerPoint rows as explicit COM-required readiness contracts.

## Validation

- `freep/FreeP.App.Presentation.Tests/ChartRenderPlannerTests.cs`
- `freep/FreeP.App.Presentation.Tests/ChartBaselineCorpusTests.cs`
- `freep/FreeP.App.Presentation.Tests/RendererNeutralDedupPlannerTests.cs`
- `freep/FreeP.App.Host.Tests/SlideCanvasTests.cs`
- `freep/FreeP.App.Rendering.Avalonia.Tests/SlideCanvasAvaloniaTests.cs`

## Remaining Work

Microsoft PowerPoint-authoritative radar PNG captures, pixel-diff thresholds, broader real-deck radar corpus coverage, exact axis/ring labeling nuance, and additional radar subtype visual comparisons remain deferred to a COM-capable baseline host.
