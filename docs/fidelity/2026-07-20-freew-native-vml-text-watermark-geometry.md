# Native VML Text Watermark Geometry

## Scope

FreeW now retains the Word-visible `v:shape` width and height for imported text
watermarks. FreeW custom properties remain authoritative for editable text,
font, colour, layout, and opacity; the VML text-path shape supplies the
serialized footprint that those properties do not carry.

The geometry is preserved through `DocxReader`, `WatermarkOptions`,
`WatermarkVisualPlanner`, and `DocxWriter`. This mirrors the existing native
VML picture-watermark ownership rule and keeps noncanonical Word-authored
text-watermark extents from being rewritten as FreeW's canonical 468 by 117
point shape.

## Verification

- `WatermarkOptionsRoundTripTests`: 20/20 passed. The focused contract mutates
  a Word-visible VML shape to `512.5pt` by `240.25pt`, verifies that FreeW
  retains those values without replacing the authoritative custom text, then
  verifies the saved header emits the same footprint.
- Release builds: `FreeW.App.Presentation`, `FreeW.App.Host`, and
  `FreeW.FidelityRender` completed with 0 warnings and 0 errors.
- Fresh matching-compositor control renders at 816 by 1056 were pixel-stable:
  `f2-border-watermark` and `wordart-watermark-stress` each changed 0 pixels
  from their pre-slice WPF PNGs.

## Follow-up

This is source-authority work, not a claim that WPF now rasterizes Word's VML
`fitshape` text path exactly. The remaining visual residual needs a
text-path geometry/raster model and must be gated against the existing Word
COM PNGs, including table fill and glyph-layer controls.
