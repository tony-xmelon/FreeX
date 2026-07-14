# FreeP SmartArt Basic Pyramid - 2026-07-14

## Scope

This slice records the bounded FreeP SmartArt `basicPyramid` live-layout path as a shared WPF/Avalonia parity family. The layout stays in `FreeP.App.Presentation` so both hosts consume ordinary renderer-neutral slide shape draw ops.

## Shared Behavior

- `SmartArtLayoutEngine` recognizes `basicPyramid` layout IDs and emits one shared live segment per parsed node.
- The top node is represented as a triangle cap and lower nodes are represented as trapezoid segments.
- Segment placement is top-to-bottom and widths widen toward the base.
- The planner intentionally emits no connector ops for this layout family.
- Unsupported or unreadable SmartArt still falls back to cached drawing through the existing compositor path.

## Evidence

- `freep/FreeP.App.Presentation.Tests/SmartArtLayoutTests.cs`
  - `BasicPyramid_ReturnsCenteredWideningSegmentsWithoutConnectors`
  - `Compositor_BasicPyramid_UsesLiveLayoutOverCachedDrawing`
- `freep/FreeP.App.Host.Tests/SmartArtTests.cs`
  - `Reader_ParsesBasicPyramidAsLiveLayoutSupported`
  - `Compositor_BasicPyramidSmartArt_RendersSharedLiveSegments`
- `freep/FreeP.App.Avalonia.Tests/MainWindowHeadlessTests.cs`
  - `SmartArt_basic_pyramid_shape_composes_shared_live_draw_ops`

## Remaining Work

This is not full SmartArt parity. Exact PowerPoint pyramid segment contours, bevels, effects, merged segment borders, PowerPoint-authoritative visual baselines, broader pyramid siblings, and SmartArt authoring/editing polish remain deferred.
