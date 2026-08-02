# FreeW Avalonia PDF image flips

Date: 2026-08-02

## Scope

Avalonia direct PDF export already retained image crop, transparency, rotation, and raster effects,
but dropped imported DrawingML `flipH` and `flipV` transforms. The live editor and DOCX package
model retained those flags, so PDF output could disagree with both Word and Print Layout.

## Implementation

`DocumentView.BuildPdfImage` now wraps flipped images in the shared `PdfRotationGroup`, centered on
the resolved page-space image bounds. Rotation and horizontal/vertical flips are therefore applied
as one Office-style transform while the child `PdfImage` continues to own bytes, crop, opacity, and
raster-baked effects. Unflipped images retain the existing direct `PdfImage` operation shape.

The common adapter is used by inline, floating, header/footer, and grouped images.

## Evidence

The focused Avalonia PDF contract covers independent inline horizontal and floating vertical flips,
including a rotated floating image. Both portable and Skia PDF writers consume the resulting shared
transform tree, and a rendered Skia page proves the asymmetric inline bitmap is mirrored at the
pixel level.
