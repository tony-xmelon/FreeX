# FreeW Render Fidelity Triage — Review / References / Headers
**Date:** 2026-06-25
**Branch:** codex/freew-fid-review
**Corpus:** 12 .docx files under `freew-fidelity-corpus/files/review/`
**Render tool:** `FreeW.FidelityRender` (FidelityRender path — continuous/scroll FlowDocument paginator)
**Pages rendered:** up to 3 per document
**Ground-truth baseline:** Word COM baseline NOT run (orchestrator constraint); this report is FreeW-side-only

---

## Critical render-path caveat

**FidelityRender uses the continuous/scroll FlowDocument paginator** (`DocumentView` → `FlowDocument` → `IDocumentPaginatorSource.GetPage`), **not the PagedEdit view**. Headers and footers are only wired into the PagedEdit render path (implemented in W17–W18). This is a known architectural split — flagged explicitly per file where it matters. All header/footer absences below are render-path gaps, not missing model data (DocxReader/DocxWriter handle headers/footers correctly per `SectionHeaderFooterRoundTripTests`).

---

## Per-file triage

### 1. `header-footer-basic.docx` — Header + footer with page number across 3 pages

| Feature | Verdict | Detail |
|---|---|---|
| Header visible in page margin | ABSENT | No header band rendered on any of pages 1–3 |
| Footer visible in page margin | ABSENT | No footer band rendered on any of pages 1–3 |
| Page number field in header | N/A | Header not rendered |
| Body text / heading flow | PASS | Heading1 "Introduction" + 30 Lorem body paragraphs paginate correctly across 3 pages |

**Issues:**
- **[BLOCKER] B1** — `header-footer-basic`: Header and footer are completely absent on all pages in the FidelityRender path. Suspected cause: `FreeW.FidelityRender/Program.cs` renders only `FlowDocument` body content via `DocumentView`; header/footer regions require the `PagedEdit` page-box layout (`PagedDocumentView`, `PageBoxPanel`). This is a render-path nuance — headers/footers exist in the model and round-trip correctly (W17–W18 wired them into PagedEdit). **VS-WORD: yes** — Word shows header/footer on every page.

---

### 2. `header-firstpage.docx` — Different first-page header

| Feature | Verdict | Detail |
|---|---|---|
| First-page-only header on page 1 | ABSENT | Cover page body ("Cover Page" Title + filler) renders but no header band |
| Subsequent-page header on pages 2–3 | ABSENT | Same — no header on any subsequent page |
| `DifferentFirstPage` flag respected | N/A | Can't assess without header rendering |
| Body layout | PASS | Title paragraph and filler flow correctly |

**Issues:**
- **[BLOCKER] B1 (shared)** — same root cause as above; first-page header differentiation is also a PagedEdit-only feature.

---

### 3. `header-odd-even.docx` — Odd/even (mirror) headers

| Feature | Verdict | Detail |
|---|---|---|
| Odd-page header | ABSENT | No header on page 1 (odd) |
| Even-page header | ABSENT | No header on page 2 (even) |
| `DifferentOddEvenPages` respected | N/A | Cannot assess |
| Body layout | PASS | "Odd/Even Headers Demo" heading + filler correct |

**Issues:**
- **[BLOCKER] B1 (shared)** — same render-path root cause.

---

### 4. `footnotes.docx` — Multiple footnotes (3 refs across 2 pages)

| Feature | Verdict | Detail |
|---|---|---|
| Footnote reference marks in body | PASS | Superscript marks ¹ ² ³ visible inline in correct positions |
| Footnote separator rule at page bottom | ABSENT | No rule line rendered |
| Footnote content at page bottom | ABSENT | Footnote text not rendered at foot of any page |
| Multi-page footnote flow (fn 3 on page 2) | N/A | Footnote content absent; pagination of reference marks is correct |

**Issues:**
- **[BLOCKER] B2** — `footnotes`: Footnote body text not rendered at the bottom of pages. Footnote reference marks in the body superscript correctly (model correctly emits `w:footnoteReference`; DocxReader loads them into `Run.FootnoteId`), but `DocumentView`/`FlowDocument` layout does not insert footnote content at the foot of the page column. This is a layout-engine gap — FlowDocument has no native footnote region. The footnote content exists in `TextDocument.Footnotes` (dict) but nothing renders it. **VS-WORD: yes** — Word renders footnote text below a short separator rule at the bottom of the page where the reference occurs.

---

### 5. `endnotes.docx` — Endnotes at document end

| Feature | Verdict | Detail |
|---|---|---|
| Endnote reference marks in body | PASS | Superscript marks ¹ ² visible correctly |
| Endnote section at document end | ABSENT | Last page (p2) shows only remaining filler; no "Endnotes" section appended |
| Endnote separator | ABSENT | Not rendered |

**Issues:**
- **[BLOCKER] B3** — `endnotes`: Endnote content not appended to the document end. Same root cause as B2 — `TextDocument.Endnotes` is populated but no render path injects it into the FlowDocument. **VS-WORD: yes** — Word collects endnotes at document end after all body content.

---

### 6. `table-of-contents.docx` — TOC with heading entries

| Feature | Verdict | Detail |
|---|---|---|
| "Contents" heading | PASS | Blue `TOCHeading`-styled "Contents" heading renders correctly |
| TOC entry paragraphs (5 entries) | PASS | All 5 entries render with correct text and indentation levels (Heading2 indented deeper) |
| Page numbers in entries | PASS | Tab-separated page numbers (1–5) appear; rendered with a plain tab stop, not a right-aligned tab with dot leaders |
| Dot leaders (. . . . .) | ABSENT | No leader characters between entry text and page number |
| Body headings (Introduction, Background, Methodology, Results, Conclusion) | PASS | All styled correctly in body; multi-page layout works |

**Issues:**
- **[MINOR] M1** — `table-of-contents`: TOC entries render page numbers without dot leaders. Entries use a plain tab character (`\t`) between text and page number; no right-aligned tab stop with a period leader is set on the `TOC1`/`TOC2` paragraph formatting. Suspected location: `FreeW.Core.Model/TableOfContents.cs` line ~61 — `ParagraphFormatting.Default with { IndentLeftPt = ... }` does not set `TabStops` with a leader style. **VS-WORD: yes** — Word renders `…… 1`-style dot leaders.

---

### 7. `citation-bibliography.docx` — In-text citations + bibliography

| Feature | Verdict | Detail |
|---|---|---|
| In-text citation text | PASS | `(Smith, John, 2020)` and `(Jones, Alice, 2022)` rendered inline as plain text |
| "References" heading | PASS | Blue styled heading renders |
| Bibliography entries | PASS | Both entries render with correct author, year, title, journal data in APA format |
| Citation formatting style | RESOLVED 2026-07-03 | Original review found APA full-name output `(Smith, John, 2020)` vs Word's `(Smith, 2020)`; shared `Citations.FormatInText` now renders clear personal authors by family name. |

**Issues:**
- **[RESOLVED 2026-07-03] M2** — `citation-bibliography`: APA in-text citation originally included full author name `Smith, John` rather than surname only `Smith`. Resolved by `ed973aa4` / merge `419eeb8ea`: shared `FreeW.Core.Model.Citations.FormatInText` now renders clear personal authors by family name for in-text citations while preserving corporate or ambiguous author strings. **VS-WORD: yes** — Word's APA style uses surname only for in-text citations.

---

### 8. `cross-reference.docx` — Cross-reference field

| Feature | Verdict | Detail |
|---|---|---|
| REF field cached text | PASS | "Results Section" resolves correctly |
| Hyperlink styling on cross-reference | PASS | "Results Section" renders in blue hyperlink colour |
| PAGEREF cached text | PASS | "See page 1 for results." renders correctly |
| Live field update (actual page number) | N/A — expected | Cached value used; no live field evaluation in this render path |

**Issues:**
- No issues. Cross-reference renders correctly for the FidelityRender path (cached-value display). PASS.

---

### 9. `tracked-changes-inline.docx` — Tracked insertions + deletions (All Markup view)

| Feature | Verdict | Detail |
|---|---|---|
| Tracked insertion underlined | PASS | "important" underlined in red/pink |
| Tracked deletion struck-through | PASS | "This redundant clause is being removed by the reviewer." struck through in red |
| Combined ins+del on same paragraph | PASS | "old" struck through, "new" underlined adjacent; both visible |
| Author/date attribution | ABSENT | No balloon or tooltip; no colour-per-author differentiation visible |
| Right-margin balloons for revisions | ABSENT | No balloon callouts in right margin |
| Change bar in left margin (Simple Markup indicator) | ABSENT | No vertical bar in left margin |

**Issues:**
- **[MAJOR] MA1** — `tracked-changes`: No right-margin balloons for tracked changes. All markup is rendered inline only. Word's "All Markup" view shows balloons in a right-margin track with connector lines to the in-text anchor, displaying author name + date + content. Suspected location: `FreeW.App.Host/Editing/DocumentView.cs` (or similar WPF adorner layer) — the balloon/margin overlay is not implemented in the continuous scroll view. May exist only partially in the Review pane (W62). **VS-WORD: yes.**
- **[MINOR] M3** — `tracked-changes`: All tracked changes render in the same red/pink colour regardless of author. Word colour-codes revisions per author (author 1 = blue, author 2 = green, etc.). Colour-per-author differentiation is not implemented.

---

### 10. `comment-anchored.docx` — Anchored comments

| Feature | Verdict | Detail |
|---|---|---|
| Comment anchor highlight | PASS | Anchored runs highlighted in yellow/amber colour for both comments |
| Comment content visible | ABSENT | No balloon or sidebar showing comment text |
| Comment reference marker (¹ glyph / icon) | ABSENT | No visible comment marker in margin or inline |
| Right-margin comment balloon | ABSENT | No balloon in right margin with author, date, text |
| Connector line balloon→anchor | ABSENT | Not present |

**Issues:**
- **[BLOCKER] B4** — `comment-anchored`: Comment content is completely absent from the rendered output. Only the anchor highlight (yellow background on the commented text span) is visible. No balloon, no comment reference marker, no sidebar. The comment model is populated (`TextDocument.Comments` keyed dict), DocxWriter emits `word/comments.xml`, but the render path does not display comment content anywhere. In Word's "All Markup" view, a comment balloon appears in the right margin with author name, initials, date, and the comment text. **VS-WORD: yes.**

---

### 11. `tracked-changes-with-comments.docx` — Combined tracked changes + comments

| Feature | Verdict | Detail |
|---|---|---|
| Tracked insertion underlined | PASS | "a comprehensive statistical analysis framework" underlined in red/pink |
| Tracked deletion struck-through | PASS | "detailed implementation specifics…" struck through in red |
| Comment anchor highlight | PASS | Anchored runs highlighted yellow/amber |
| Comment balloons in right margin | ABSENT | Same as file 10 — no balloons |
| Combined ins+comment on same run | PASS | Both underline and highlight apply to the same span |

**Issues:**
- **[BLOCKER] B4 (shared)** — same as above; comment balloons absent.
- **[MAJOR] MA1 (shared)** — tracked change balloons absent.

---

### 12. `multipage-headers-repeating.docx` — Multi-page, per-section repeating headers

| Feature | Verdict | Detail |
|---|---|---|
| Section 1 header on pages 1–3 | ABSENT | No header on any page of section 1 |
| Section 2 header (with page number field) | ABSENT | Not assessed — 3-page limit stays in section 1 |
| Section break boundary | PASS | Body content of section 1 flows across pages correctly |
| Per-section header differentiation | N/A | Headers absent; cannot assess differentiation |

**Issues:**
- **[BLOCKER] B1 (shared)** — same render-path cause as files 1–3.

---

## Prioritized summary table

| Rank | ID | Severity | Feature | Issue | Files |
|---|---|---|---|---|---|
| 1 | B1 | BLOCKER | Headers / Footers | Not rendered in FidelityRender path — FlowDocument paginator has no header/footer region; PagedEdit path (W17–W18) has them but FidelityRender does not use it | 1, 2, 3, 12 |
| 2 | B4 | BLOCKER | Comment balloons | Comment content completely absent; only anchor highlight visible; no balloon, marker, or connector | 10, 11 |
| 3 | B2 | BLOCKER | Footnotes | Footnote content not rendered at page bottom; reference superscripts present in body | 4 |
| 4 | B3 | BLOCKER | Endnotes | Endnote content not appended at document end; reference superscripts present in body | 5 |
| 5 | MA1 | MAJOR | Tracked change balloons | No right-margin balloons; inline ins/del markup renders correctly (underline/strikethrough) but no author/date balloon | 9, 11 |
| 6 | M1 | MINOR | TOC dot leaders | No dot leaders between TOC entry text and page number; tab is plain, not right-aligned with period leader | 6 |
| 7 | M2 | RESOLVED 2026-07-03 | APA citation format | Shared in-text formatter now uses family-name display for clear personal authors; original review showed full author name inline `(Smith, John, 2020)` vs `(Smith, 2020)` | 7 |
| 8 | M3 | MINOR | Tracked change colour-per-author | All revision markup is same red colour; no per-author colour differentiation | 9, 11 |

---

## Feature-by-feature render-path verdict

| Feature | FidelityRender path? | PagedEdit path? | VS-WORD? |
|---|---|---|---|
| Headers / footers (default) | NO — render-path gap | YES (W17–W18) | Yes |
| First-page header | NO — render-path gap | YES (W18) | Yes |
| Odd/even headers | NO — render-path gap | Likely yes (model + writer wired) | Yes |
| Footnote reference marks | YES | YES | Yes |
| Footnote content at page bottom | NO — layout gap | NO (not implemented in either path) | Yes |
| Endnote reference marks | YES | YES | Yes |
| Endnote content at document end | NO — layout gap | NO (not implemented in either path) | Yes |
| TOC entries with text + page numbers | YES (partial — no leaders) | YES (partial — no leaders) | Partial |
| TOC dot leaders | NO | NO | Yes |
| In-text citation text | YES | YES | Yes |
| Bibliography formatted entries | YES | YES | Yes |
| Cross-reference cached text | YES | YES | Yes |
| Cross-reference hyperlink style | YES | YES | Yes |
| Tracked insertion (underline) | YES | YES | Yes |
| Tracked deletion (strikethrough) | YES | YES | Yes |
| Tracked change balloons (margin) | NO | NO (reviewing pane only) | Yes |
| Comment anchor highlight | YES | YES | Yes |
| Comment balloon (margin) | NO | NO (reviewing pane only) | Yes |

---

## Top 5 issues

1. **B1 — Headers/footers absent in FidelityRender path** (4 files). Root cause: `FreeW.FidelityRender/Program.cs` uses raw `FlowDocument` paginator which has no concept of header/footer regions. Fix requires either (a) switching FidelityRender to use the PagedEdit render path (`PagedDocumentView`) or (b) prepending/appending header/footer content as synthetic paragraphs in the render tool. The underlying model + PagedEdit rendering is correct per W17–W18.

2. **B4 — Comment content never displayed** (2 files). Root cause: `TextDocument.Comments` dict is populated and written to `word/comments.xml` by DocxWriter, but no overlay or balloon layer exists in the continuous render path. The comment anchor highlight is applied (via `Run.CommentId`) but nothing renders the balloon. Both PagedEdit and FidelityRender share this gap. Fix: add a comment balloon/sidebar layer to the WPF document view.

3. **B2 — Footnote content absent from page bottom** (1 file). Root cause: WPF `FlowDocument` has no native footnote section. The footnote store (`TextDocument.Footnotes`) is populated but `DocumentView.LoadModel` does not inject footnote content into the flow. Fix requires either appending footnote paragraphs at end-of-body (endnote-style approximation) or implementing a proper foot-of-page column in the paginator.

4. **B3 — Endnote content absent from document end** (1 file). Same root cause as B2; fix is symmetric (append endnote paragraphs after the last body paragraph in `DocumentView.LoadModel`).

5. **MA1 — Tracked-change balloons absent** (2 files). Root cause: The balloon/connector overlay for tracked changes is not implemented in the continuous view. The Reviewing Pane (W62) partially surfaces this data. Fix: implement a margin balloon layer analogous to Word's change-tracking balloon panel.

---

## Notes on FidelityRender render-path

The FidelityRender tool renders via the continuous/print FlowDocument path (`DocumentView.LoadModel` → `RichTextBox.Document` → `IDocumentPaginatorSource`). This path:
- **Does** render: body paragraphs, heading styles, list numbering, footnote/endnote reference superscripts, tracked-change inline markup (underline/strikethrough), comment anchor highlights, cross-reference cached text, TOC styled paragraphs, bibliography.
- **Does NOT** render: header/footer regions (PagedEdit only), footnote/endnote content at page margins/end, comment balloons, tracked-change balloons, TOC dot leaders.

Headers and footers showing in PagedEdit (W17–W18) is separately verified and is NOT a gap in that path. The gap is solely that FidelityRender does not exercise PagedEdit.
