# FreeW vs MS Word — visual fidelity comparison (2026-06-17)

Companion to [`2026-06-17-freew-corpus-roundtrip.md`](2026-06-17-freew-corpus-roundtrip.md), which
established that all 26 `freew-fidelity-corpus` documents **open and round-trip** through
`DocxReader`/`DocxWriter` with no modeled-content loss, but deferred the **visual** pixel-diff against
MS Word because no Word engine was available on the machine at the time.

That blocker is gone: **MS Word (Office16, `WINWORD.EXE`) is now installed and COM-automatable** on this
machine, so this run does the deferred comparison — FreeW's own page rendering vs Word's ground-truth
rendering, page by page, with SSIM + pixel-delta heatmaps.

## Method

1. **Word ground truth.** Each corpus `.docx` → PDF via Word COM `ExportAsFixedFormat`, then rasterized
   to per-page PNG at 150 DPI (`pypdfium2`). Scripts: `freew-fidelity-corpus/runs/export-word.ps1`.
2. **FreeW rendering.** A headless WPF harness (`tools/FreeW.RenderCompare`) loads each `.docx` through
   `DocxReader`, hosts it in the real `DocumentView`, and rasterizes every page through the app's actual
   print paginator (`HeaderFooterPaginator` over the live FlowDocument) to PNG at 150 DPI.
3. **Diff.** `freew-fidelity-corpus/runs/compare.py` aligns FreeW vs Word page-for-page, computes SSIM and
   mean pixel delta, and writes a FreeW | Word | heatmap triptych per page under `runs/diff/`.

Run artifacts (PDFs, PNGs, triptychs, `scores.csv`) live under the **git-ignored**
`freew-fidelity-corpus/runs/` and are not committed.

## Coverage

| Stage | Result |
|---|---|
| FreeW headless page render | **14 / 26** documents rendered to PNG |
| Word PDF ground truth | **25 / 26** exported (`deep-table-cell.docx`: Word reports it *corrupted* and refuses to open without a repair dialog — FreeW opens it without complaint) |
| Both sides present → diffable | **13** documents, **72** page-pairs |

The other 12 documents could not be rendered by FreeW's page path at all — see
[FreeW render failures](#freew-render-failures-12-26), which are findings in their own right.

## Quantitative result (SSIM, 1.0 = identical)

| Document | Pages F/W | Mean SSIM | Notes |
|---|---|---|---|
| testComment | 1 / 1 | **0.999** | comment anchor text; near-identical |
| FieldCodes | 1 / 1 | **0.998** | field results |
| saut_page | 1 / 3 | 0.997¹ | page-break stress: FreeW collapses to 1 page |
| footnotes | 1 / 1 | **0.995** | footnote *marker* matches; note text differs (below) |
| NumberingWOverrides | 1 / 1 | **0.994** | numbering overrides |
| bookmarks | 1 / 1 | **0.988** | bookmarked list |
| table_footnotes | 1 / 1 | **0.982** | table + footnote markers |
| ComplexNumberedLists | 1 / 1 | **0.969** | numbered lists incl. restart |
| checkboxes | 1 / 1 | 0.959 | checkbox glyphs missing (below) |
| endnotes | 1 / 1 | 0.877 | endnote text at page foot omitted |
| chartex | 2 / 3 | 0.881¹ | chart rendering differs sharply (below) |
| delins | 1 / 1 | 0.746 | line-spacing drift accumulates (below) |
| stress010 | 59 / 118 | 0.647¹ | header drop + RTL + 2× pagination drift |

¹ Page-count mismatch: SSIM compares page *i* to page *i*, so once pagination diverges the scores
measure misalignment as much as rendering. Treat multi-page-mismatch rows as lower bounds.

- **Clean single-page text documents (10 docs, same page count):** mean SSIM **≈ 0.95**.
- **Per-document mean across all 13:** **≈ 0.93**.
- **Page-weighted overall:** 0.70 — dominated by stress010's 59 mismatched pages; not representative.

**Bottom line:** for ordinary text, lists, tables, fields, bookmarks, comments and footnote/endnote
*markers*, FreeW's page rendering is a close visual match to Word (SSIM 0.95–0.999). The gaps are
concentrated in specific feature areas below.

## Visual fidelity gaps (rendered docs)

1. **Charts — only the first series, wrong type, no axes/legend** (`chartex`). Word draws a 3-series
   column chart (legend, value axis, gridlines) and a real 3-series **line** chart. FreeW draws a
   **single-series column chart for both** — the line chart renders as columns, the 2nd and 3rd data
   series are absent, and there is no value axis, no gridlines, and no series legend. Highest-impact
   visual gap found.
2. **Header content + header images dropped** (`stress010`, an RTL Arabic CEDAW report). Word renders
   the "CEDAW" letterhead block and the UN emblem in the page header; FreeW's first page omits the entire
   header block and emblem. Matches the round-trip doc's header-read and images-in-header gaps.
3. **RTL / bidirectional alignment** (`stress010`). Word right-aligns the Arabic content and TOC; FreeW's
   layout does not fully mirror to RTL. Bidi layout is a previously-unflagged visual gap.
4. **Footnote / endnote text not shown at page foot** (`footnotes`, `endnotes`, `table_footnotes`). The
   superscript reference marker renders correctly, but the note *body* that Word prints at the bottom of
   the page (with separator) is absent — a documented `FlowDocument` limitation, confirmed visually.
5. **Content-control checkbox glyphs not drawn** (`checkboxes`). The ☐/☑ glyphs are blank in FreeW;
   surrounding text, table and text-box render faithfully.
6. **Pagination density differs from Word.** FreeW consistently produces *fewer* pages: `stress010`
   59 vs 118, `saut_page` 1 vs 3, `chartex` 2 vs 3. `saut_page` (a page-break stress fixture) collapses
   to a single FreeW page. FreeW's line-height / page-fill metrics pack more content per page than Word,
   and empty page-break-only pages are not reproduced.
7. **Line-spacing vertical drift** (`delins`). Content matches (tracked-change insertions in red
   underline, deletions in red strikethrough, blue hyperlinks all correct), but FreeW's slightly tighter
   line spacing makes the two renders drift apart progressively down the page — the main reason its SSIM
   is 0.75 despite matching content.

## FreeW render failures (12 / 26)

The harness renders FreeW pages through the app's real print paginator. 12 documents threw before
producing any page — each is a genuine defect, not a harness artifact:

- **Print / Print-Preview crash — `XamlWriter` cannot serialize non-public `Tag` types** (the original
  blocker; 7+ docs). `PrintLayout.CloneBlocks` deep-clones the editor FlowDocument via
  `XamlWriter.Save`, which throws `Cannot serialize a non-public type
  'DocumentView+ParagraphTag/TableCellTag/HyperlinkInfo/FootnoteMarker/EndnoteMarker'`. Because a
  `ParagraphTag` is stamped on **every paragraph that carries a StyleId / bookmark / tab stop /
  page-break-before / widow-control** (`DocumentView.cs:2750`), this fires for essentially any real-world
  document. **Both `MainWindow.Print` and `PrintPreviewWindow` reach this path**, so FreeW's Print and
  Print Preview crash on most documents. *Highest-severity finding.* (The harness works around it by
  paginating the live FlowDocument directly, no XAML serialization.)
- **Image-format decode — `NotSupportedException: No imaging component…`** (`drawing`,
  `EmbeddedDocument`, `stress008`, `VariousPictures`, `WordWithAttachments`). An embedded image format
  (likely WMF/EMF or an uncommon codec) fails to decode, taking down the whole page render. Matches the
  round-trip doc's `VariousPictures` note; the reader needs an image-format audit / fallback.
- **Multi-section / header docs — `ArgumentOutOfRangeException: paragraphWidth ('∞')`** (`headerFooter`,
  `PageSpecificHeadFoot`, `stress004`, `stress015`, `stress018`, `stress023`). Pagination of these
  header/footer-heavy, multi-section documents fails with an infinite layout width.
- **Negative `Block.Margin` — `ArgumentException: '0;0;-0.4;0' is not a valid value for property
  'Margin'`** (`stress003`). A negative paragraph spacing/indent maps to a negative WPF `Block.Margin`,
  which WPF rejects (block margins must be non-negative). Needs a clamp at the model→FlowDocument seam.

## Suggested follow-ups (priority order)

1. **Fix the Print / Print-Preview `XamlWriter` crash** — strip/skip the non-public `Tag` values before
   `XamlWriter.Save` (or clone without XAML serialization, as the harness does). This is a user-facing
   crash on the core Print feature.
2. **Chart rendering** — honor chart type (line vs column), render all data series, and add value axis +
   legend, or at minimum render additional series.
3. **Image-format robustness** — audit reader image decoding; fall back gracefully (placeholder) instead
   of throwing so one bad image cannot blank a page.
4. **Multi-section pagination `∞`** and **negative `Block.Margin`** — fix the two layout exceptions so
   header-heavy and negative-spacing documents render.
5. **Header content/images, footnote/endnote body text, checkbox glyphs, RTL alignment** — visual gaps
   already partly tracked in the round-trip doc; this run confirms them against Word ground truth.

## Reproduce

All reusable scripts are committed under `tools/FreeW.RenderCompare/`; they write into the git-ignored
`freew-fidelity-corpus/runs/`.

```powershell
# 0. fetch corpus (writes ignored freew-fidelity-corpus/files/)
powershell -NoProfile -ExecutionPolicy Bypass -File tools\Fetch-FreeWFidelityCorpus.ps1
# 1. Word ground truth — MUST run foreground/interactive (Word COM stalls in a backgrounded or
#    Start-Process/Start-Job child, which lacks an interactive window station)
powershell -NoProfile -ExecutionPolicy Bypass -File tools\FreeW.RenderCompare\Export-WordPdfs.ps1
# 2. FreeW page render
dotnet build tools\FreeW.RenderCompare\FreeW.RenderCompare.csproj -c Release
tools\FreeW.RenderCompare\bin\Release\net10.0-windows10.0.19041.0\FreeW.RenderCompare.exe `
  freew-fidelity-corpus\files freew-fidelity-corpus\runs\freew 150
# 3. diff + triptychs + scores.csv  (needs: pip install pypdfium2 numpy scikit-image pillow)
python tools\FreeW.RenderCompare\compare.py freew-fidelity-corpus\runs 150
```
