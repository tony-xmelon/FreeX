# FreeP 3-D Pie Depth Rendering Evidence - 2026-07-14

## Scope

This no-COM slice moves a bounded 3-D pie rendering decision into paired
WPF/Avalonia evidence. PowerPoint-authored `pie3DChart` data already maps to the
FreeP pie chart model with `ChartThreeDStyle.Pie`; this slice makes both
renderers consume the shared compressed top-face and lower depth-pass policy.

## Evidence

- `ChartRenderPlanner.BuildPieSlicePrimitives` emits `ChartPieSlicePrimitive`
  values with the shared 3-D pie vertical scale, depth offset, and depth-fill
  alpha.
- WPF and Avalonia slide canvases now draw a lower depth pass from the same
  `ChartPieSlicePrimitive` before drawing the top slice face.
- `ChartRenderPlanner.BuildVisualBaselineReadinessPlan` now describes 3-D pie
  readiness rows as a compressed top-face plus lower depth-pass decision.
- The WPF and Avalonia capture rows remain deterministic no-COM shared-host
  evidence; the paired PowerPoint row remains a COM-required readiness contract.

## Verification

- `freep/FreeP.App.Presentation.Tests/ChartRenderPlannerTests.cs` covers the
  shared 3-D pie vertical scale, depth offset, depth alpha, and slice primitive
  contract.
- `freep/FreeP.App.Presentation.Tests/RendererNeutralDedupPlannerTests.cs`
  verifies both WPF and Avalonia renderers consume `DepthOffsetY` and
  `ThreeDPieDepthFillAlpha` from shared planner output.
- `freep/FreeP.App.Presentation.Tests/ChartBaselineCorpusTests.cs` covers paired
  WPF/Avalonia 3-D pie baseline-readiness capture IDs without requiring
  PowerPoint COM.

## Limits

This is not a Microsoft PowerPoint PNG baseline. Exact PowerPoint 3-D pie
side-wall lighting, camera/perspective, beveling, pixel-diff thresholds, and
broader real-deck 3-D pie baselines still require a COM-capable baseline host.
