# FreeP PDF Shape Transparency Export Evidence

## Scope

This slice closes a bounded shared fixed-layout gap for ordinary vector shape transparency. DrawingML color `a:alpha` is now modeled on `ThemeAwareColor`, preserved through PPTX read/write for fills and outlines, and consumed by the shared `PresentationPdfExporter` as portable `PdfOpacityGroup` draw ops.

## Evidence

- `PresentationPdfExporterTests.BuildDocument_CarriesShapeFillAndOutlineAlphaAsPdfOpacityGroups`
- `PresentationPdfExporterTests.ExportToBytes_EmitsShapeAlphaExtGStateForVectorGeometry`
- `PptxRoundTripTests.RoundTrip_SolidFillAndOutlineAlpha_Preserved`

## Remaining Work

This is not a PowerPoint-authoritative visual baseline. Gradient-stop alpha, per-fill/per-stroke alpha on combined custom path fill+stroke, native print-driver output, and broad PowerPoint PDF visual comparisons remain follow-up fidelity work.
