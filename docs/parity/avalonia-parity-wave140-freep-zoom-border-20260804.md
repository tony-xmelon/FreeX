# Avalonia Parity Wave 140: FreeP Zoom Border Authoring

## Audit

Wave 139 completed the shared Zoom transition toggle. A source audit of the existing
`ZoomObjectProperties` model, `ZoomObjectPropertiesPlanner`, native reader, format command,
and both `ZoomObjectPropertiesDialog` hosts showed that Zoom insertion and formatting already
covered target navigation, image source, transition, destination background, crop, and Summary
tile layout. The remaining user-visible style operation in this bounded route was Zoom frame
border color: the native frame was retained as opaque `zmPr/spPr` XML, but neither host could
author it and the compositor ignored it.

The native location is source-backed by the Microsoft
[CT_ZoomObjectProperties schema](https://learn.microsoft.com/en-us/openspecs/office_standards/ms-pptx/059e3722-139d-4e41-9841-d53eecaf73f6):
`zmPr` has ordered `blipFill` then `spPr` children, and `spPr` carries the DrawingML `a:ln`
outline. The round-trip fixture asserts this exact generated shape rather than assuming a
top-level sibling `p:spPr`.

## Implementation

- `ZoomObjectProperties.FrameBorderColor` projects a supported six-digit solid RGB border.
- The shared planner validates and normalizes `#RRGGBB` / `RRGGBB` input.
- `ZoomFrameBorderXml` is the single native mutation helper used by single Zoom and Summary tile
  commands; undo restores the complete preserved XML.
- The native reader and compositor read only `zmPr/spPr/a:ln/a:solidFill/a:srgbClr`.
- WPF and Avalonia expose the same `Use Zoom border` control and color validation.
- Clearing removes only a recognized solid RGB fill. Unsupported gradient/pattern/no-fill line
  content remains preserved, and unrecognized line content is never projected as a guessed color.

## Evidence

- Shared planner: `PresentationViewZoomPlannerTests`, 23/23 passed.
- Shared compositor: Zoom preview border projection covered by `SlideCompositorTests`.
- WPF host and native XML/undo/round-trip: 34/34 focused tests passed.
- Avalonia host route: `ZoomAuthoringParityTests`, 2/2 passed.

## Inventory and residuals

No command or workflow inventory row was added. This is authoring depth for the existing
`freep.zoom.format` route; generated inventory remains 648/648 shared commands. Gradient,
pattern, theme-derived, width/dash, and effect authoring remain unsupported and are preserved
as native XML rather than guessed.
