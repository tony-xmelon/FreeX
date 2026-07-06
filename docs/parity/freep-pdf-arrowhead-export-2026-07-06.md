# FreeP PDF Arrowhead Export Slice - 2026-07-06

## Scope

- Added DrawingML line-end metadata to FreeP shape outlines for connector and line shapes.
- Read `a:headEnd` and `a:tailEnd` triangle markers from PPTX visible and gradient outlines.
- Wrote triangle line-end markers back to PPTX for connectors and line-like shapes.
- Extended the shared PDF draw-op model and both shared writers with filled triangle marker support.
- Mapped FreeP straight line/connectors and authored elbow connector routes to shared filled-triangle arrowheads in PDF coordinates.

## Evidence

- `PortablePdfWriterTests.Write_EmitsFilledTrianglePath`
- `PptxRoundTripTests.RoundTrip_ConnectorTriangleLineEnds_WritesAndReadsVisibleOutline`
- `PptxRoundTripTests.RoundTrip_LineTriangleLineEnds_WritesAndReadsGradientOutline`
- `PresentationPdfExporterTests.BuildDocument_ExportsStraightConnectorTriangleArrowheads`
- `PresentationPdfExporterTests.BuildDocument_ExportsElbowConnectorTriangleArrowheadsAtRouteEnds`

## Remaining PDF Export Gaps

- Connector arrowhead support is currently bounded to filled triangle markers.
- Rotated shape/text export remains a deeper fixed-layout fidelity slice.
- Broader PowerPoint-authoritative PDF visual baselines remain future evidence work.
