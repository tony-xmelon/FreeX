# FreeW export page-border parity - Wave94

## Evidence

The WPF PDF path calls `PrintLayout.BuildPaginator` and rasterizes each WPF paginator page. The
paginator page visual includes the page border rendered by the WPF document surface, so a WPF PDF
export preserves `PageSettings.PageBorder`.

The Avalonia PDF path builds `PdfContentDocument` directly from `DocumentView` layout operations.
Before this slice it emitted body text, table surfaces, inline and floating objects, headers/footers,
footnotes, and endnotes, but no page-border operation. A document with a page border therefore
looked correct in Avalonia Print Layout but lost that border in exported PDF (and in the shared XPS
fallback that consumes the same content model).

## Change

`DocumentView.BuildPdfContent()` now emits the page border before body content for every laid-out page.
The adapter follows the existing Avalonia page-chrome geometry: page-relative and text-relative
frames, the serialized `SpacePt` inset, solid/dashed/dotted strokes, and the second rail for double
borders. Art borders and wave borders remain outside this bounded slice and retain the existing
Avalonia live-render fallback behavior.

## Verification

`DocumentViewPdfExportTests.BuildPdfContent_IncludesPageBorderBeforeBodyAndMatchesPageChromeGeometry`
asserts the two double-border rails, color, dimensions, inset, line width, and ordering before body
text. The test uses the shared PDF operation tree consumed by both the Skia PDF writer and portable
XPS writer.

## Residuals

Watermarks and line numbers are still visible in Avalonia Print Layout but are not yet represented in
the Avalonia PDF operation tree. WPF PDF rasterization also preserves their full visual treatment.
Those are separate export parity slices because their shared PDF representations require text/image
placement and opacity decisions beyond a page-border stroke.
