# FreeW Avalonia PDF picture borders

Date: 2026-08-02

## Scope

FreeW retained DrawingML picture-border color, width, and dash tokens in the document model, but
Avalonia direct PDF export emitted only the picture bitmap. Word-visible picture frames therefore
disappeared from exported PDFs.

## Implementation

The common image PDF adapter now emits a `PdfStrokeRect` beside a bordered `PdfImage`. Both children
share the image's center-based rotation and flip transform, while the bitmap continues to own crop,
opacity, encoded bytes, and raster-baked effects. Border width follows the existing Word-compatible
0.75-point minimum, and common DrawingML dash presets map to the shared PDF dash vocabulary.

Images without a border retain their prior direct operation path.

## Evidence

The focused Avalonia contract covers a rotated, horizontally flipped image with an authored
2.25-point dark-red `lgDashDot` border. It verifies the shared operation tree, portable PDF output,
and the red frame pixels in a Skia-rendered PDF page.
