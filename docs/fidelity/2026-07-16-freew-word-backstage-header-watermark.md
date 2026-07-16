# FreeW Word Backstage Header And Watermark - 2026-07-16

## Finding

The Word backstage/PDF fixture exposed two FreeW layout mismatches:

- the VML watermark paragraph in `header1.xml` was read as an empty header paragraph, consuming the header editor's height and hiding the visible header text;
- the composite evidence renderer painted the header at the page edge and did not reserve the compact header band before laying out body columns.

Word also ignored FreeW text watermarks whose emitted VML text path lacked activation attributes.

## Fix

- `DocxReader` now filters only FreeW's stable watermark shape IDs from header/footer paragraph enumeration, preserving ordinary Word VML and image paragraphs;
- `FreeW.FidelityRender` reserves a 25 DIP header band and places header/footer overlays in the document margins, matching the Word baseline's body origin;
- `DocxWriter` emits `on="t"` and `fitshape="t"` on the actual VML watermark text path.

## Evidence

The refreshed backstage page now places the header at the top margin, starts the blue heading at Word's y-position, and keeps the footer inside the bottom margin. A fresh Word export of the border/watermark fixture renders its diagonal `DRAFT` watermark after the VML text-path fix.

The backstage sample still differs where Word's visible PDF output omits the very-low-opacity (`0.18`) `PRINT COPY` watermark; the custom opacity value is retained rather than silently changed.

## Verification

- `WatermarkOptionsRoundTripTests`: 12/12
- fresh FreeW backstage render: 4 pages
- fresh visible Word export: 1/1 for the watermark probe
