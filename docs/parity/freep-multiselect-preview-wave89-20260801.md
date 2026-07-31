# FreeP multi-selection transform preview parity Wave 89

Date: 2026-08-01

## Implemented

FreeP WPF and Avalonia now render live per-member resize and rotate preview outlines from
the shared `CanvasMultiTransformPlan`. The planner publishes one screen-space preview frame
per selected shape, including its target bounds and target rotation. Both hosts pass that
same contract to their selection adorner, while the source shapes remain visible and
unmodified until the existing one-step transform command commits.

The existing group preview box, drag thresholds, snapping, Escape/capture-loss cleanup,
stale-release handling, selected-member outlines, and undo batching are preserved. Shared
rotated-envelope geometry now also lets selection chrome include the rendered footprint of
rotated members instead of only their unrotated source frames.

## Proof

- Shared planner tests assert per-member resize and rotate preview bounds and rotations,
  plus the 90-degree oriented envelope calculation.
- WPF host tests feed real resize and rotate plans to `SelectionAdorner`, assert both
  member preview frames, and verify selected-member rectangles remain present.
- Avalonia host tests feed real rotate and resize plans to `SelectionAdornerLayer`, assert
  both member preview frames, and verify selected-member rectangles remain present.

Focused verification:

- `dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --configuration Release --filter FullyQualifiedName~CanvasGesturePlannerTests`
  passed: 16/16.
- `dotnet test freep\FreeP.App.Host.Tests\FreeP.App.Host.Tests.csproj --configuration Release --filter FullyQualifiedName~CanvasEditingTests`
  passed: 41/41.
- `dotnet test freep\FreeP.App.Rendering.Avalonia.Tests\FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~SelectionAdornerLayer_RendersPerMemberMultiTransformPreviewGeometry --no-restore`
  passed: 1/1.
- The existing focused Avalonia `SlideCanvasAvaloniaTests` filter also passed: 81/81.

## Residuals

- The live member preview is selection chrome (rotated dashed member frames), not a second
  compositor paint of each filled shape. This keeps model state and source rendering stable
  during drag while making every planned member's geometry inspectable.
- Group handles remain the existing axis-aligned handle model; rotated member envelopes now
  contribute to the selection bounds, but there is no separate oriented group-handle frame.
- Full repository/default and Docker validation lanes were not run. No Docker command was run.
