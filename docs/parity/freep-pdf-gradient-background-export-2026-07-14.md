# FreeP PDF Gradient Background Export Evidence

This slice tightens the shared FreeP fixed-layout PDF path for linear-gradient slide content:

- Linear-gradient slide backgrounds now export as `PdfFillRectLinearGradient` draw ops instead of flattening to the first stop's solid fallback color.
- Notes-page and handout PDF thumbnail remappers preserve scaled linear-gradient rectangle, ellipse, line, and custom-path ops when embedding slide content into print layouts.
- The policy stays in the shared FreeP export layer used by WPF/Avalonia hosts; no host-specific renderer or PowerPoint automation path was added.

## Evidence

- `PresentationPdfExporterTests.BuildDocument_MapsLinearGradientSlideBackgroundToPdfGradientOp`
- `PresentationExportPlannerTests.NotesAndHandoutPdfRenderPlans_PreserveLinearGradientSlideOps`

This is no-COM shared WPF/Avalonia export evidence, not a PowerPoint-authoritative visual baseline. Gradient-stop alpha, radial-gradient PDF output, native print-driver output, and broad real-deck PDF comparisons against PowerPoint remain follow-up fidelity work.
