# FreeW WPF Native Print Page Range

## Scope

FreeW opened the Windows `PrintDialog` but never enabled its user page-range control and always sent
the complete document paginator to the printer. Word users therefore could not print an inclusive
custom physical page range from the native dialog.

## Change

- FreeW composes the authoritative print-preview paginator before showing the native dialog.
- The dialog receives exact `MinPage`/`MaxPage` bounds and enables `UserPageRange` for multi-page
  documents.
- Accepted `UserPages` requests are applied through `PageRangeDocumentPaginator`.
- The adapter maps physical page indices only; it never rebuilds or copies document content.

The physical ownership distinction matters for documents with odd/even section blanks, long-note
continuation pages, mixed section geometry, headers/footers, and page borders. A request for pages
2-3 returns those exact composed pages in order rather than a newly paginated two-page document.

## Verification

- Inclusive range 2-4 from five pages returns source pages 2, 3, and 4 in order.
- An out-of-bounds high range clamps to the final physical page.
- A complete normalized range returns the original paginator without an extra wrapper.
- Invalid zero or descending input is rejected defensively; the native dialog itself supplies a
  positive ascending range.
- An `OddPage` section fixture proves pages 2-3 select the synthetic blank followed by the next body
  page, and both materialize through `DocumentPaginator.GetPage`.
- Focused WPF print/range/shortcut gate: 18/18.
- Consuming host and test assemblies build with 0 warnings and 0 errors.

This slice intentionally enables Word-style custom page ranges only. Native current-page and
selected-text printing require separate caret/selection-to-print-surface ownership and are not
represented by guessed page numbers or temporary documents.
