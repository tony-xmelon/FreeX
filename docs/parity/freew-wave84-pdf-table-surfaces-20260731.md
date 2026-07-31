# FreeW Wave 84: PDF Table Surfaces

## Verified divergence

WPF print/PDF composition paints table cell fills and borders beneath the already-laid-out cell
text. Avalonia `DocumentView.BuildPdfContent` previously exported the cell glyphs but omitted the
cell surfaces, so a table exported as PDF lost its shading and grid/border geometry even though the
live Print Layout renderer already had each cell rectangle and border plan.

## Change and evidence

Avalonia PDF assembly now reuses `_rects`, the existing page-space table-cell render items, to emit
`PdfFillRect`, `PdfStrokeRect`, and `PdfLine` operations before text. Items are assigned to the page
whose media box they intersect and clipped to that page, with double borders preserved and unsupported
dash/wave styles using a solid-line PDF fallback. No second paginator was introduced.

`FreeW.App.Avalonia.Tests/DocumentViewPdfExportTests.cs` verifies table fills, borders, per-edge
colour, under-text ordering, multi-page ownership, and page-box clipping through the shared PDF ops.

Images, floating objects, inline drawings/charts/WordArt/SmartArt, paragraph/character decorations,
page borders, watermarks, and line-number decorations remain explicit follow-up layers.
