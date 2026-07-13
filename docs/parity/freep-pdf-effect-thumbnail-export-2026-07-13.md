# FreeP PDF Effect Thumbnail Export Evidence

## Scope

This slice tightens FreeP fixed-layout PDF export for slide thumbnails embedded in notes-page and handout PDFs. The preferred shape fill/outline transparency gap remains blocked by current model support: `ShapeFill` and `ShapeOutline` do not yet carry authored fill or line opacity. Rather than expanding the model or host renderers, this slice closes the next narrow PDF-only effect gap that already exists in shared export output.

Modeled shape shadow/glow effects already reach the full-slide `PresentationPdfExporter` as shared `PdfOpacityGroup` draw ops. Notes-page and handout PDF thumbnail remappers now preserve those opacity groups and their scaled child geometry instead of dropping them.

## Evidence

- `PresentationNotesPagePdfExporter` recursively maps existing shared slide PDF ops into the notes-page thumbnail, including `PdfOpacityGroup`, `PdfRotationGroup`, `PdfImage`, and `PdfFilledTriangle`.
- `PresentationHandoutPdfExporter` applies the same recursive mapping for handout slide thumbnails.
- `PresentationExportPlannerTests.NotesAndHandoutPdfRenderPlans_PreserveEffectOpacityGroups` proves modeled outer-shadow alpha reaches both notes-page and handout PDF render plans without PowerPoint COM.

## Limits

This is no-COM shared WPF/Avalonia export evidence, not a PowerPoint-authoritative visual baseline. Shape fill/outline transparency remains deferred until the FreeP model preserves authored fill/line opacity. Broader shadow/glow/soft-edge visual parity and real-deck PDF comparison against PowerPoint still require a COM-capable machine.
