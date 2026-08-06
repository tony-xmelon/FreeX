# Avalonia Parity Wave 165: FreeP Zoom Reflection Blur

Date: 2026-08-06

## Selected residual

The authoritative FreeP Zoom reflection note documented native DrawingML
`a:reflection/@blurRad` as preserved but not authorable or consumed by the
picture renderers. This is a reproducible property-level boundary: the reader,
`ZoomFrameBorderReflection`, shared Zoom command, and native XML writer already
carried the field, while both Zoom Format dialogs omitted it and both picture
renderers ignored the resolved blur value.

## Implementation

- Added a shared reflection-blur formatter/parser and a Reflection blur field to
  the WPF and Avalonia Zoom Format dialogs.
- Kept the existing `SetZoomObjectPropertiesCommand` and
  `ZoomFrameBorderXml` path as the single undo/native XML boundary. Existing
  reflection siblings and unsupported native XML remain preserved.
- Added `PictureReflectionRenderPlanner`, a bounded renderer-neutral halo-pass
  plan for the authored radius. WPF and Avalonia consume the same pass list;
  blur-free reflections retain the original single-pass path.

## Evidence

- `PresentationViewZoomPlannerTests`: `71/71` focused tests passed, including
  normalization, invalid blur rejection, compositor projection, and shared
  reflection-pass planning.
- `ModernObjectsRoundTripTests.ZoomFrameBorder_ReflectionIsUndoableAndRoundTripsNativeEffect`:
  native `blurRad`, undo removal, redo, and package reopen passed.
- WPF Zoom authoring/source lane: `5/5` passed.
- Avalonia Zoom authoring/source lane: `4/4` passed.
- The package assertion verifies native `blurRad="12700"` and the reopened
  `ZoomFrameBorderReflection.BlurRadiusEmu` value.

## Remaining residuals

This closes only Zoom frame reflection blur. PowerPoint-specific raster metrics,
other unsupported native Zoom effect families, and unrelated presentation
parity gaps remain outside this slice. Native XML that is not modeled by the
existing Zoom projection continues to round-trip through the preserved raw
payload rather than being guessed into the new blur state.
