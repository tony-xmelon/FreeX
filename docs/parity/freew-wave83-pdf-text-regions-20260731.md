# FreeW Wave 83: PDF Text-Region Parity

## Scope

This slice audits the WPF and Avalonia document print/export paths for deep document content that is
not visible in command inventory: page chrome and note regions. It is limited to the shared PDF draw-op
adapter; table, image, and decoration fidelity remain separate work.

## Verified divergence

WPF's `PrintLayout.BuildPaginator` wraps the body paginator in `HeaderFooterPaginator`, which composites
headers, footers, footnote bodies, and their separator into the printed page. Avalonia's
`DocumentView.BuildPdfContent` previously serialized only body glyphs even though its live Print Layout
already computed `_headerFooterItems`, `_noteItems`, and `_noteSeparators`. Exporting a document with a
header/footer or footnote therefore silently dropped user-authored page content.

## Change

Avalonia PDF assembly now converts the existing, already-paginated header/footer and note render items
into `PdfText` operations and note separators into `PdfLine` operations. The existing body glyph export
and page geometry remain unchanged, and fields are exported using the text already resolved by the live
layout. This makes PDF output retain the text regions shown by Print Preview without introducing a second
pagination implementation.

## Evidence

- WPF: `FreeW.App.Host.Tests/HeaderFooterPaginatorTests.cs` covers normal header/footer pagination,
  single-page footnote composition, and multi-page footnote placement/reservation.
- Avalonia: `FreeW.App.Avalonia.Tests/DocumentViewPdfExportTests.cs` verifies exported `PdfText` for
  header, footer, and footnote content plus the `PdfLine` separator.
- Source: `freew/FreeW.App.Avalonia/Editing/DocumentView.cs` now exports the live page-region render items
  after body glyph emission.

## Nearby gaps

Avalonia's PDF draw-op adapter still does not export tables, images, floating objects, or other page
decorations. Those remain bounded follow-up slices rather than being implied as covered by this change.
