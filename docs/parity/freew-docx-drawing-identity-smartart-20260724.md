# DOCX Drawing Identity Parity for Charts and SmartArt

## Defect

The generated `chart-smartart-complex.docx` package assigned `wp:docPr` IDs
independently per drawing family. Its charts used IDs `1,2`, and its SmartArt
objects reused `1,2`. Microsoft Word omitted those duplicate-identity SmartArt
drawings during fixed-format export even though the diagram parts and
relationships were present.

## Fix

`DocxWriter` now reserves one document-wide drawing ID sequence:

1. image parts, including embedded-object icons;
2. chart parts;
3. SmartArt parts; and
4. subsequently authored DrawingML shapes.

The package writer emits the embedded-object icon parts before allocating the
chart and SmartArt ranges, so icon drawing IDs cannot collide with either.

## Verification

- The mixed chart/SmartArt package contract verifies `wp:docPr` IDs `1,2` and
  uniqueness.
- Regenerated `chart-smartart-complex.docx` from the actual FidelityRender
  consumer emits `wp:docPr=1,2,3,4`, all unique.
- SmartArt and shape writer contracts: 84/84 passed.
- FidelityRender Release build: 0 warnings, 0 errors.

## Remaining Visual Gate

The prior Word PNG baseline belongs to the invalid duplicate-ID package and is
not admissible for post-fix visual scoring. The regenerated fixture needs one
fresh Word-visible PDF/PNG export before chart and SmartArt raster parity is
measured again.
