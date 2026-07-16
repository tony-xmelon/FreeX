# FreeW to Word header/footer positioning

## Baseline

The Word COM production corpus exposed a compositor-only drift in the composite FreeW evidence
renderer. Headers were painted inside the body top margin and the body paginator reserved an extra
25 DIP header band. Footers were overlaid without matching the Word footer band, which moved the
last complete body paragraph across a page boundary.

## Fix

`FreeW.FidelityRender` now keeps body flow at the document top margin, paints headers in the upper
half-inch band, paints footers in the lower band, and applies a small footer-margin overlap so WPF's
paragraph-bottom margin matches Word's final-line fit. The model and DOCX field content remain
unchanged. When the body paginator produces table pages beyond the `PaginatedEditorPanel` page-box
list, the compositor resolves the same section header/footer slots as a fallback. Pages with an
explicit Word header distance also receive the matching reserved body band, preventing the fallback
header from overlapping a table.

## Verification

- Field page-number fixture: 4 FreeW pages, 4 Word pages; first-page body boundary matches through
  paragraph 15.
- First-page header/footer fixture: header, body, and footer bands align with the Word PNG baseline.
- Odd/even header/footer fixture: even-page chrome remains on the correct page and aligns with Word.
- Table page-composition fixture: all three pages retain border, watermark, header, footer, and the
  explicit header-distance body reserve, including pages emitted beyond the page-box list.
- Full production corpus: 30/30 FreeW renders succeeded; all page counts matched Word except the
  pre-existing `legal-reference-section-page-numbers` fixture (FreeW 3, Word 2), whose Word page 1
  contains the authoritative `Error! Bookmark not defined.` field result.
