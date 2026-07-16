# FreeW Word TA field shape

## Finding

The legal-reference fixture exposed the remaining four-fail/page-count mismatch in the
Word baseline. Its authority marks were written as `w:fldSimple` fields. Word parsed the
first malformed field across most of the document, producing only seven paragraphs and
two pages, including `Error! Bookmark not defined.` on the first page. That older Word
baseline is therefore not a valid comparison artifact.

Word COM inspection of an in-memory authority mark showed the interoperable shape:
`w:fldChar` begin, `w:instrText` containing the `TA` instruction, and `w:fldChar` end,
with no separate/result run. FreeW now emits that complex field shape and the reader
collapses it back to the model's `Citation` run metadata, including fields nested in
hyperlinks, comments, controls, and revisions.

## Verification

The corrected legal-reference DOCX opened through Word COM with 3 pages, 32 paragraphs,
4 fields, and 1 table-of-authorities field. FreeW also rendered 3 pages. Visible Word
PDF publication succeeded, and the normalized 816x1056 PNG comparison measured mean
absolute differences of 0.711% on page 1, 6.886% on page 2, and 1.438% on page 3.

The focused `TableOfAuthoritiesRoundTripTests` suite passes 7/7. The ignored production
baseline folder still contains the older malformed fixture and should be regenerated
before using the full corpus as a release comparison.
