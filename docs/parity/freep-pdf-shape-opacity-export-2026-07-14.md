# FreeP PDF Shape Opacity Export Evidence

Date: 2026-07-14

## Scope

This slice closes the bounded fixed-layout PDF shape-opacity evidence gap for the shared FreeP export path:

- Authored PPTX shape fill and line alpha already round-trip through `ThemeAwareColor.Alpha`.
- Full-slide fixed-layout PDF export emits semi-transparent shape fill and outline as shared `PdfOpacityGroup` draw ops.
- Notes-page and handout PDF thumbnail export now have focused coverage proving those same opacity groups survive the shared thumbnail remapping path.

The implementation remains renderer-neutral. WPF and Avalonia hosts consume the same FreeP model, `PresentationPdfExporter`, notes-page PDF exporter, handout PDF exporter, and shared portable PDF draw-op model.

## Evidence

Focused regression coverage:

- `freep/FreeP.App.Host.Tests/PptxRoundTripTests.cs`
  - `RoundTrip_SolidFillAndOutlineAlpha_Preserved`
- `freep/FreeP.App.Host.Tests/PresentationPdfExporterTests.cs`
  - `BuildDocument_CarriesShapeFillAndOutlineAlphaAsPdfOpacityGroups`
  - `ExportToBytes_EmitsShapeAlphaExtGStateForVectorGeometry`
- `freep/FreeP.App.Presentation.Tests/PresentationExportPlannerTests.cs`
  - `NotesAndHandoutPdfRenderPlans_PreserveShapeFillAndOutlineOpacityGroups`

These tests prove that PPTX-authored shape transparency reaches the shared FreeP model and is emitted through the same WPF/Avalonia fixed-layout PDF export contracts without requiring PowerPoint COM.

## Remaining Work

This is no-COM shared export evidence, not a PowerPoint-authoritative visual baseline. Broader PDF/export fidelity still needs gradient-stop transparency nuance, soft-edge/blur tuning, richer arbitrary clipping cases, and real-deck PDF comparisons against PowerPoint on a COM-capable machine.
