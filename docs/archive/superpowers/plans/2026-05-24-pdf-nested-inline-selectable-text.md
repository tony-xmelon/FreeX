# PDF Nested Inline Selectable Text

## Goal

Improve PDF selectable text extraction for `TextBlock` content that uses nested WPF inline containers such as `Bold`, `Italic`, or `Span`.

## Steps

1. Add an exporter-level regression test with nested `TextBlock` inlines.
2. Verify the generated PDF lacks the nested inline text.
3. Make `PdfTextOverlayExtractor` recursively flatten inline containers while preserving existing direct `Run` and `LineBreak` behavior.
4. Update architecture and command parity docs to include nested inline support.
5. Run focused overlay tests and a full build, then commit and sync.
