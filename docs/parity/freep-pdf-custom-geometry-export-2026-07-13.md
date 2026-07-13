# FreeP PDF Custom Geometry Export Slice - 2026-07-13

## Scope

This slice improves FreeP fixed-layout PDF export for PowerPoint custom/freeform shape geometry without requiring PowerPoint COM.

The implementation stays shared-first:

- `PdfPath` extends the shared PDF draw-op model for arbitrary filled/stroked contours.
- `PortablePdfWriter` emits real PDF path operators for line and cubic Bezier segments.
- `SkiaPdfWriter` renders the same shared path primitive through Skia.
- `PresentationPdfExporter` maps `SlideShape.CustomGeometry` to vector `PdfPath` ops instead of falling back to rectangle geometry.
- Notes-page and handout PDF thumbnail remappers preserve custom path ops when scaling slide content into print layouts.

## Evidence

- `PortablePdfWriterTests.Write_EmitsFilledAndStrokedCustomPath`
- `PresentationPdfExporterTests.BuildDocument_ExportsCustomGeometryAsPdfPath`
- `PresentationExportPlannerTests.NotesAndHandoutPdfRenderPlans_PreserveCustomGeometrySlideOps`

## Remaining PDF Export Gaps

- This is no-COM shared WPF/Avalonia PDF evidence, not a PowerPoint-authoritative visual baseline.
- The slice preserves authored move/line/cubic geometry and elevates quadratic curves to cubic output. Full curved arc emission, advanced effects, crop masks, transparency nuance, and broader real-deck PDF comparison against PowerPoint remain future work.
