# FreeW live paged-editor endnote ownership

Date: 2026-07-31

## Scope

FreeW's live paged editor previously appended a synthetic endnote page whenever a
document contained any endnotes. Word keeps fitting endnotes on the final body
page and creates another physical page only when the final body plus endnote
region exceeds the available page height.

The live `PaginatedEditorPanel` now consumes the same measured overflow decision
as `HeaderFooterPaginator`. Its direct scratch flow applies authored section-break
flags without entering the recursive section-aware paginator factory, so fitting
multi-section endnotes also remain on the final body page. The decision is applied
consistently during initial construction, repagination, and undo rebuild.

## Functional evidence

- Short in-memory document with two fitting endnotes: 1 body page, no synthetic
  page, endnote IDs 1 and 2 owned by the final body page.
- Generated `f2-endnotes.docx`: 2/2 composite pages, with the endnotes on page 2.
- Imported `freew-fidelity-corpus/files/review/endnotes.docx`: 3 page boxes, with
  endnote IDs 1 and 2 on the dedicated final page.
- The fitting and overflow ownership decisions survive `Repaginate()` and
  `Rebuild()`.
- A dedicated page in a portrait-to-landscape document now inherits the final
  section's width, height, orientation, and four margins during construction,
  repagination, and undo rebuild. The old path incorrectly reused a document-
  default local despite its final-section ownership comment.
- Focused live-editor and print-paginator tests: 23/23 passed.
- `FreeW.App.Host` Release build: 0 warnings, 0 errors.

The follow-up final-section geometry and section-break-aware fit gate passed 29/29
focused live-note, section-geometry, and print-paginator tests. A short
portrait-to-landscape document keeps its fitting endnote on the final landscape
body page across construction, repagination, and undo rebuild; an oversized
endnote still creates a dedicated page with that same final-section geometry.

`PageBox` note planning now also consumes the owning page's resolved content
width instead of recomputing it from the document's final section. A narrow
earlier-section footnote contract verifies that its separator uses the narrow
section width; the focused note suite passes 18/18.

## Fresh Word comparison

The exact imported fixture was exported through Word COM at 816x1056. Word and
FreeW both produced 3/3 pages.

Word PNG SHA-256:

- page 1: `25BA55CB1A97FA9B2ECB2A56A2210A436D292C96D3DF965E8FF0599B030E1094`
- page 2: `92053B505556E3296E0A448D74278A005F3AF0CF752F4F9A4D93FA7D977011F8`
- page 3: `F52AF49A7081883AE9EFB197217592F4BAED988CC2B3867E079446BCC9E93052`

Page 3, the newly represented physical endnote page, measured a mean absolute
RGB channel delta of 1.5093 on the 0-255 scale (0.5919%) and 0.8611% of pixels
with maximum-channel delta at least 32. Pages 1 and 2 retain broader pre-existing
body-layout residuals and were not changed by this ownership slice.

## Process

The Word target was exported to the short temporary root `C:\FW4` to avoid the
previous long-path COM failure. After scoring, the temporary corpus, PDFs/PNGs,
and generated controls were deleted; Word and build-server processes were shut
down.
