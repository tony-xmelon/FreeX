# FreeP SmartArt Org Chart Assistant Geometry - 2026-07-13

## Scope

This slice adds bounded no-COM geometry evidence for PowerPoint `orgChart`
SmartArt assistant nodes after the picture-caption admission work.

The reader already imports `dgm:pt type="asst"` into `SmartArtNode.IsAssistant`.
This change keeps the existing `orgChart` live-layout admission and gives those
assistant nodes a distinct shared layout path: assistants render as smaller
side-slot boxes below the manager, and regular reports move to the next row.
The behavior is gated to `orgChart`; `basicHierarchy` and other hierarchy
layouts keep the existing generic child-row geometry.

## Shared Behavior

- `SmartArtLayoutEngine` computes org-chart depth and width without letting
  assistants consume regular report columns.
- Assistant boxes are emitted as ordinary shared rounded-rectangle shapes, and
  relationships remain ordinary shared connector ops.
- WPF and Avalonia consume the same compositor draw ops; no renderer-local
  SmartArt policy is introduced.

## Evidence

- `SmartArtLayoutTests` covers assistant side-slot placement, report-row
  displacement, smaller assistant width, connector count, and the
  `basicHierarchy` gate.
- `SmartArtTests` builds a synthetic PPTX with `type="asst"`, proves the reader
  preserves `IsAssistant`, and proves composed output uses shared live shapes
  and connector DrawOps.

## Residual Limitations

The planner still approximates PowerPoint org charts with renderer-neutral boxes
and straight connectors. Exact PowerPoint assistant connector routing,
co-worker/manager branch styling, interactive SmartArt authoring and editing,
and PowerPoint-authoritative visual baselines remain deferred.
