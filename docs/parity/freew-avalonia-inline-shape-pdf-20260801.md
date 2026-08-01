# FreeW Avalonia inline shapes and PDF export

Date: 2026-08-01

## Gap

Inline AutoShapes were retained in the model/package but omitted from Avalonia live layout and direct PDF
export. Paragraph dispatch was also split by inline object family: an inline image could select the image-only
path and silently hide an AutoShape or chart in the same paragraph.

## Slice

- Route paragraphs containing inline shapes, charts, WordArt, or SmartArt through one non-text flow owner.
- Extend that owner to consume inline images too, so mixed image/shape/chart paragraphs retain every object.
- Reserve each inline shape's authored box, scale it only when it exceeds the text column, emit an atomic
  caret band, and retain its exact block/run identity.
- Build the live shape from the shared `DrawingObjectVisualPlanner`, including fill, outline, custom geometry,
  rotation/flips, effects, and planned text layout.
- Reuse the same resolved rectangle, source model, visual plan, text layout, and existing vector shape PDF
  builder for direct PDF export.
- Paint inline shapes with the other inline drawing objects before body glyphs. Floating-shape ownership and
  z-order remain unchanged.

## Evidence

The new mixed fixture places a red inline image, a 150x60-point blue text-box AutoShape, and an inline column
chart in one paragraph, followed by ordinary body text. It requires:

- one live inline shape and one live inline chart with non-empty resolved rectangles;
- the exact authored blue shape frame and shape text in the PDF operation tree;
- shape geometry before shape text, shape text before chart title, and chart before trailing body text;
- valid portable PDF bytes and a nonblank Skia raster.

## Verification

- Focused mixed inline shape/PDF contract: 1/1.
- `DocumentViewPdfExportTests|DocumentViewInlineFO4Tests|DocumentViewFloatingShapeTests`: 99/99.
- Avalonia product and test builds: 0 warnings, 0 errors.
- The complete Avalonia test assembly exceeded the four-minute command timeout without a failure summary;
  only the three processes owned by that run were stopped. The focused and owner gates above are the
  acceptance evidence for this narrow slice.

## Residuals

- Inline drawing families use non-overlapping flow boxes; their existing family paint bands remain stable
  rather than introducing a new cross-family z-order model.
- The portable text writer still uses built-in font faces instead of embedding exact Office fonts.
- This is functional/vector/raster evidence, not a claim of pixel identity with a Word PDF baseline.
