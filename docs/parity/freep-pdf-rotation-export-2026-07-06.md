# FreeP PDF Rotation Export Slice - 2026-07-06

## Scope

- Added a shared `PdfRotationGroup` draw op for fixed-layout PDF children that need a common rotation transform.
- Extended `PortablePdfWriter` to emit grouped save/transform/restore content streams while discovering text and image resources inside groups.
- Extended `SkiaPdfWriter` to render the same grouped rotation primitive through Skia canvas transforms.
- Mapped FreeP non-image shape geometry/text and connector/line geometry into rotated shared PDF groups around the authored shape-bounds center.
- Preserved the existing `PdfImage.RotationDegrees` path for picture export.

## Evidence

- `PortablePdfWriterTests.Write_EmitsRotationGroupSaveTransformAndRestore`
- `PortablePdfWriterTests.Write_EmitsRotatedImagePlacement`
- `PresentationPdfExporterTests.BuildDocument_ExportsRotatedRectangleAndTextThroughPdfRotationGroup`
- `PresentationPdfExporterTests.BuildDocument_ExportsRotatedConnectorThroughPdfRotationGroup`
- `PresentationPdfExporterTests.BuildDocument_ExportsPictureShapesAsPdfImages`

## Remaining PDF Export Gaps

- Rotation support is bounded to whole-shape fixed-layout groups around authored bounds; deeper PowerPoint visual fidelity for complex shape effects remains.
- Broader PowerPoint-authoritative PDF visual baselines remain future evidence work.
- Picture crop, transparency, non-rectangular picture frames, and color effects remain deeper fidelity work.
