# FreeP Zoom Theme Border Resolution - 2026-08-04

## Scope

Native Zoom frame borders may use DrawingML `a:schemeClr` rather than a literal
`a:srgbClr`. The shared compositor previously recognized only literal RGB and
could omit an imported theme-based Zoom border. This slice resolves the native
scheme token through the owning slide/master theme and the effective color map,
including `lumMod`, `lumOff`, `tint`, and `shade` transforms.

Width and dash edits remain source-preserving: the existing native theme fill is
left intact when an edit changes only line geometry. Explicit RGB authoring keeps
the existing dialog and model behavior.

## Verification

- `SlideCompositorTests`: 92/92, including transformed `schemeClr` Zoom border
  composition.
- `ModernObjectsRoundTripTests.ZoomFrameBorder`: 3/3, including width/dash edit
  preservation of the native theme fill.
- Release consuming WPF project graph built successfully as part of the host
  test run.

PowerPoint-authoritative visual baselines remain a separate evidence boundary;
this slice closes native theme resolution and source-preserving authoring rather
than making a new raster calibration claim.
