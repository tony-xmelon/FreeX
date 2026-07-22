# Page Float Height Probe Rejected

## Scope

The current `f2-01-float-wrap.docx` Word COM baseline and WPF composite both
place the two page-anchored image borders at the same page-space locations.
Raw text-band inspection also shows matching line starts. The remaining local
gap is predominantly wider WPF glyph ink, not a missing page-float exclusion
height.

## Probe

The WPF visual-only page-anchor `Figure` height inset was increased from
17 DIPs to 47 DIPs. The focused `FloatingImageRenderTests` suite passed 18/18,
and the actual Release `FreeW.FidelityRender` consumer was rebuilt before the
candidate render.

## Result

Against the matching 816 x 1056 Word PNG, the whole-page delta regressed from
`5.9114%` to `8.8092%`. The probe was reverted.

## Rule

For page-anchored float residuals, inspect raw object masks and text-band
geometry before changing wrap clearance. Matching object edges and line cadence
mean that a scalar `Figure` height change is not an appropriate typography
calibration; keep the existing page-space reservation and trace the text-raster
owner instead.
