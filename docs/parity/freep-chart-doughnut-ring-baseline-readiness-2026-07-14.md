# FreeP Chart Doughnut Ring Baseline Readiness - 2026-07-14

This no-COM slice adds deterministic shared evidence for doughnut chart visual-baseline readiness before Microsoft PowerPoint screenshots are available.

Shared status:

- `ChartRenderPlanner.BuildDoughnutSlicePrimitives` already produces renderer-neutral doughnut slice primitives consumed by WPF and Avalonia through the shared chart surface.
- The focused readiness test now proves authored hole size, first-slice angle, and series-zero-as-innermost ring ordering from the shared planner without touching either host renderer.
- `ChartRenderPlanner.BuildVisualBaselineReadinessPlan` projects stable PowerPoint, WPF, and Avalonia capture requests for the same doughnut chart scenario.
- PowerPoint capture rows remain explicit COM-required contracts, while WPF and Avalonia rows are deterministic shared-host evidence that can run on machines without desktop PowerPoint COM.

Verification:

- `freep/FreeP.App.Presentation.Tests/ChartBaselineCorpusTests.cs` covers the doughnut hole-size/ring-order primitive decisions plus WPF/Avalonia capture request IDs and COM flags.
- `freep/FreeP.App.Presentation.Tests/ChartRenderPlannerTests.cs` continues to cover doughnut ring ordering, first-slice angle, and null/nonpositive slice behavior at the render-planner level.

Remaining blockers:

- This slice does not capture Microsoft PowerPoint screenshots locally.
- PowerPoint-authoritative doughnut visual baselines, broader real-deck doughnut corpus coverage, pie3D behavior, and pixel-diff thresholds still require a COM-capable baseline host.
