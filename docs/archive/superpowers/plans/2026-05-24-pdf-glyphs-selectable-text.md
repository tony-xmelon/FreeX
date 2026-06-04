# PDF Glyphs Selectable Text

## Goal

Improve PDF text overlay fidelity by extracting simple WPF `Glyphs` runs from exported `FixedDocument` pages, so fixed-document text emitted as glyph primitives remains searchable/selectable in PDF output.

## Steps

1. Add an exporter-level regression test with a `FixedPage` containing `Glyphs.UnicodeString`.
2. Verify the test fails because the PDF overlay currently ignores `Glyphs`.
3. Extend `PdfTextOverlayExtractor` to emit overlays for non-empty `Glyphs.UnicodeString`.
4. Update architecture and command parity docs to record the supported glyph overlay case and its fallback font-family semantics.
5. Run focused PDF overlay tests and a full build, then commit and sync.
