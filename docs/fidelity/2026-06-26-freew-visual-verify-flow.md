# FreeW Visual Fidelity Report — Flow Features (F2b Pass)
**Date:** 2026-06-26  
**Renderer:** FidelityRender composite mode (`--composite --max-pages 3`)  
**Corpus:** `freew-fidelity-corpus/files/f2-flow/` — 8 documents, 16 pages rendered  
**Branch:** `codex/freew-f2-flow`

## Summary

| Feature | Status | Notes |
|---|---|---|
| Header/Footer — basic (default slot, page 1) | RENDERS-WITH-ISSUES | Slot selected correctly; text clipped at top/bottom edge — content barely visible |
| Header/Footer — basic (pages 2+) | STILL-MISSING | Header and footer absent on page 2 and page 3 |
| Header/Footer — different-first-page (page 1) | RENDERS-WITH-ISSUES | First-page slot correctly selected; same clipping bug |
| Header/Footer — different-first-page (page 2+) | STILL-MISSING | Subsequent-page header/footer absent on page 2 |
| Header/Footer — odd/even (odd page) | RENDERS-WITH-ISSUES | Odd-page slot correctly selected; same clipping bug |
| Header/Footer — odd/even (even page) | STILL-MISSING | Even-page header/footer absent on page 2 |
| Footnote reference superscripts | CONFIRMED-RENDERS | Superscript numbers (¹ ²) render correctly inline in body |
| Footnote content at page bottom | STILL-MISSING | No separator rule, no footnote text at bottom of any page |
| Endnote reference superscripts | CONFIRMED-RENDERS | Superscript numbers (¹ ²) render correctly inline in body |
| Endnote content collected at document end | STILL-MISSING | No endnote section on final page — content absent |
| Section break — next-page page geometry | STILL-MISSING | Section break does not produce a page break; both sections render on single page at portrait dimensions |
| Tracked insertions (underline + color) | CONFIRMED-RENDERS | Insertions shown underlined in crimson; paragraph-level insertions in blue underline |
| Tracked deletions (strikethrough + color) | CONFIRMED-RENDERS | Deletions shown struck-through in crimson |
| Per-author color differentiation | CONFIRMED-RENDERS | Alice/Bob/Carol all render in distinct colors (crimson, blue-teal) |
| Comment anchor highlighting | CONFIRMED-RENDERS | Commented spans highlighted in amber/orange in the body text |
| Comment balloon / reviewing pane content | NOT-APPLICABLE | Balloons are live-UI; not expected in headless composite render |

## Confirmed-Renders (5)

1. **Footnote reference superscripts** (`f2-footnotes_p1`): `¹` and `²` appear inline at the correct position in the sentence, correct superscript rendering.
2. **Endnote reference superscripts** (`f2-endnotes_p1`): same — `¹` and `²` appear inline.
3. **Tracked insertions** (`f2-tracked-changes_p1`): "INSERTED text by Alice." underlined in crimson; "This entire paragraph is a tracked insertion by Carol." underlined blue; "inserted-by-alice" and "inserted-by-carol" underlined. All correct.
4. **Tracked deletions** (`f2-tracked-changes_p1`): "DELETED text by Bob." struck-through in crimson; "deleted-by-bob" struck-through. Correct.
5. **Comment anchor highlighting** (`f2-comments_p1`): "The first commented span" and "Second commented phrase" both highlighted in orange/amber. Correct.

## Renders-With-Issues (3)

### HF clipping bug — page 1 only, text barely visible

Affects: `f2-hf-basic_p1`, `f2-hf-firstpage_p1`, `f2-hf-oddeven_p1`

**Observation:** On every page-1 render, the header slot IS being selected and rendered (the correct slot text is present), but the header content is positioned so high that only the tail end of the text is visible at the very top edge of the page image. The footer is similarly positioned at the very bottom edge with only a fragment of text visible (e.g., lone ":"). The `PaginatedEditorPanel` is compositing the HF overlays but the `Rect` placement puts the header band above the page-top clipping boundary or has an off-by-one in the Y coordinate calculation, making the text appear outside the page area.

**Root cause area:** `PaginatedEditorPanel.Build()` / `RenderHfSlot()` — the header `Rect` is at `y=2` from page top but the page image coordinate system may not include the top margin, so the HF band is placed in the margin zone that gets clipped when the body content area is composited at the correct offset. Alternatively, `hfH=36` is too small and the text flows outside the allocated band.

**Impact:** Headers and footers are effectively invisible in the rendered output despite the slot resolution working correctly.

## Still-Missing (4)

### 1. Headers/footers on pages 2+

**Observation:** Page 2 and page 3 of `f2-hf-basic`, `f2-hf-firstpage`, and `f2-hf-oddeven` have completely blank header and footer areas — no text at all.

**Expected:** Every non-first page should show the default (or even-page) slot. The `PaginatedEditorPanel` must be applying the HF overlay only to page 1 of each section, or the page-loop in `Build()` is not iterating past the first page box.

### 2. Footnote content at page bottom

**Observation:** `f2-footnotes_p1` and `f2-footnotes_p2` — the body text with `FootnoteId` references renders correctly, but the bottom of the page has no footnote separator rule or footnote text whatsoever.

**Expected:** Word renders a short horizontal rule at the bottom of the page containing the reference, followed by the footnote paragraph(s) in smaller text.

**Root cause area:** The FlowDocument/WPF paginator does not natively support footnotes. FreeW would need to inject a footer-zone block into the body `FlowDocument` for each page (similar to how HF are handled), or post-process the page render by appending a footnote strip. Neither is currently implemented.

### 3. Endnote content at document end

**Observation:** `f2-endnotes_p1` and `f2-endnotes_p2` — body renders correctly with endnote references; final page (p2) has no endnote section.

**Expected:** After the last body paragraph, a new section with a separator and numbered endnote paragraphs should appear.

**Root cause area:** No endnote collection/rendering pass in the compositor. The `TextDocument.Endnotes` dictionary is populated by the model but never injected into the FlowDocument.

### 4. Section break next-page page geometry

**Observation:** `f2-section-landscape_p1` — Portrait Section 1 and Landscape Section 2 both appear on the same portrait page. The section break produced no page break; landscape page dimensions (11×8.5 in) were not applied.

**Expected:** Section 2 should start on a new page rendered at landscape dimensions (wider than tall). The text line length for landscape paragraphs should be visibly longer.

**Root cause area:** `SectionBreak = new Section(landscapePage, SectionBreakKind.NextPage)` is stored on the model but the FlowDocument `ApplyColumnLayout` pass does not interpret section breaks as page breaks or switch `PageSettings` mid-document. The single-section page geometry is applied to the whole `FlowDocument`.

## HF Slot Selection — Verified Correct

Despite the clipping rendering bug, slot selection logic is working:

| Document | Page | Expected slot | Rendered slot text (visible fragment) |
|---|---|---|---|
| f2-hf-basic | 1 | Default header | "eader" (end of "My Document Header") |
| f2-hf-firstpage | 1 | First-page header | "ONLY HEADER ===" (first-page slot text) |
| f2-hf-firstpage | 1 | First-page footer | "ONLY FOOTER ===" |
| f2-hf-oddeven | 1 | Odd header | "HEADER (pages 1, 3, ...) ===" |
| f2-hf-oddeven | 1 | Odd footer | "OOTER ===" |

The `DifferentFirstPage` and `DifferentOddEvenPages` flags are both being respected — the correct slot name is resolved. Only the compositing geometry is wrong.

## Recommended Next Steps (Priority Order)

1. **Fix HF clipping (High):** Adjust the header/footer `Rect` Y-coordinate in `PaginatedEditorPanel` so that the header band sits inside the page-image bounds. The body area begins at `marginTop` pixels from the top; the header must be placed in the range `[0, marginTop)`. Increase `hfH` or use the full margin height. Verify footer similarly uses `[pageHeight - marginBottom, pageHeight)`.

2. **Fix HF on pages 2+ (High):** Ensure the `Build()` page-loop emits HF overlays for every page, not just the first. Verify the page-count enumeration covers all pages produced by the paginator.

3. **Section break page geometry (Medium):** Teach `ApplyColumnLayout` (or the paginator wrapper) to honour `SectionBreakKind.NextPage` by forcing a page break in the `FlowDocument`, and apply the new section's `PageSettings` (width, height, margins) to subsequent pages. This likely requires splitting the content into per-section `FlowDocument` instances rendered at different page sizes.

4. **Footnotes at page bottom (Medium):** After paginating the body `FlowDocument`, post-process each `DocumentPage` to identify which footnote references landed on it, then render a footnote strip (separator + footnote paragraphs) and composite it above the footer zone.

5. **Endnotes at document end (Low):** After the last page, append an endnote page: render `TextDocument.Endnotes` values as paragraphs into a new `FlowDocument` and append as an additional composited page.

## Corpus Files

| File | Pages rendered | Feature tested |
|---|---|---|
| `f2-hf-basic.docx` | 3 | Default header + footer |
| `f2-hf-firstpage.docx` | 2 | Different-first-page HF |
| `f2-hf-oddeven.docx` | 2 | Odd/even page HF |
| `f2-footnotes.docx` | 2 | Footnote references + content |
| `f2-endnotes.docx` | 2 | Endnote references + content |
| `f2-section-landscape.docx` | 1 | Section break + landscape page |
| `f2-tracked-changes.docx` | 2 | Tracked insertions + deletions |
| `f2-comments.docx` | 2 | Comment anchor highlighting |

Output PNGs: `freew-fidelity-corpus/output/f2-flow/` (16 files)
