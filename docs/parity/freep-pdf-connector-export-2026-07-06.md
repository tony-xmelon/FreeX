# FreeP PDF Connector Export - 2026-07-06

## Scope

This slice improves FreeP fixed-layout PDF export for PowerPoint connector and line shapes.

The implementation stays shared-first:

- `PresentationPdfExporter` maps line and connector shapes to portable `PdfLine` draw operations.
- Authored elbow connector routes emit one PDF line segment per route leg.
- WPF and Avalonia continue to call the same presentation export planner and shared portable PDF writer.

## Behavior

- Straight line and connector shapes are exported as strokes instead of rectangle outlines.
- Connector stroke color and width are preserved through the existing `ShapeOutline` mapping.
- Elbow connector route points are converted from slide EMU coordinates into PDF page coordinates.
- Normal filled/outlined shapes keep the existing rectangle geometry path.

## Evidence

- `PresentationPdfExporterTests.BuildDocument_ExportsLineShapesAsPdfLinesNotRectangleOutlines`
- `PresentationPdfExporterTests.BuildDocument_ExportsElbowConnectorRouteAsMultiplePdfLines`

## Remaining

This is still vector-geometry export depth, not full PowerPoint PDF parity. Picture/image XObjects, rotation, arrowheads, advanced connector routing, and PowerPoint-authoritative visual baselines remain future slices.
