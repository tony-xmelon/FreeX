# FreeP PDF Ellipse Export Slice - 2026-07-13

## Scope

This slice improves FreeP fixed-layout PDF export for ordinary PowerPoint oval/ellipse shapes without requiring PowerPoint COM.

The implementation stays shared-first:

- `PdfFillEllipse` and `PdfStrokeEllipse` extend the shared PDF draw-op model.
- `PortablePdfWriter` emits real Bezier ellipse paths for dependency-free PDF output.
- `SkiaPdfWriter` renders the same shared ellipse ops through Skia.
- `PresentationPdfExporter` maps `DrawingShapeKind.Ellipse` shapes to ellipse fill/stroke ops instead of rectangular fallback geometry.
- Notes-page and handout PDF thumbnail remappers preserve ellipse ops when scaling slide content into print layouts.

## Evidence

- `PortablePdfWriterTests.Write_EmitsFilledAndStrokedEllipsePaths`
- `PresentationPdfExporterTests.BuildDocument_ExportsEllipseShapesAsPdfEllipses`
- `PresentationExportPlannerTests.NotesAndHandoutPdfRenderPlans_PreserveEllipseSlideOps`

## Remaining PDF Export Gaps

- Ellipse support is bounded to axis-aligned oval geometry plus existing whole-shape rotation grouping.
- Broader freeform/custom geometry, crop masks, transparency, effects, and PowerPoint-authoritative PDF visual baselines remain future slices.
