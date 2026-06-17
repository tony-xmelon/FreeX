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
| FreeW headless page render | **26 / 26** documents rendered to PNG (was 14 on first run; four print/render crashes fixed this session — see [below](#bugs-fixed-this-session)) |
| Word PDF ground truth | **25 / 26** exported for diffing (`deep-table-cell.docx`: Word reports it *corrupted* and refuses to open without a repair dialog — FreeW opens it without complaint) |
| Both sides present → diffable | **25** documents, **310** page-pairs |

FreeW now renders every corpus document; the only doc not diffed is `deep-table-cell` (Word won't open
it). The crashes that initially blocked 12 documents are all fixed — see
[Bugs fixed this session](#bugs-fixed-this-session).

## Quantitative result (SSIM, 1.0 = identical)

25 documents, 310 page-pairs (`deep-table-cell` excluded — Word won't open it).

| Document | Pages F/W | Mean SSIM | Notes |
|---|---|---|---|
| testComment | 1 / 1 | **0.999** | comment anchor text; near-identical |
| FieldCodes | 1 / 1 | **0.998** | field results |
| saut_page | 1 / 3 | 0.997¹ | page-break stress: FreeW collapses to 1 page |
| footnotes | 1 / 1 | **0.995** | footnote *marker* matches; note text differs (below) |
| EmbeddedDocument | 1 / 1 | **0.995** | embedded-object placeholder |
| NumberingWOverrides | 1 / 1 | **0.994** | numbering overrides |
| headerFooter | 1 / 1 | **0.994** | simple header **and** footer render; slight x-offset |
| bookmarks | 1 / 1 | **0.988** | bookmarked list |
| table_footnotes | 1 / 1 | **0.982** | table + footnote markers |
| ComplexNumberedLists | 1 / 1 | **0.969** | numbered lists incl. restart |
| checkboxes | 1 / 1 | 0.959 | checkbox glyphs missing (below) |
| PageSpecificHeadFoot | 1 / ? | 0.948¹ | page-specific header/footer |
| WordWithAttachments | 2 / ? | 0.907¹ | mixed parts + attachments |
| chartex | 2 / 3 | 0.881¹ | chart rendering differs sharply (below) |
| endnotes | 1 / 1 | 0.877 | endnote text at page foot omitted |
| VariousPictures | 1 / ? | 0.857¹ | multiple embedded pictures |
| delins | 1 / 1 | 0.746 | line-spacing drift accumulates (below) |
| stress003 | 20 / ? | 0.679¹ | pagination drift |
| stress023 | 12 / ? | 0.675¹ | pagination drift |
| stress015 | 5 / ? | 0.667¹ | pagination drift |
| stress010 | 59 / 118 | 0.647¹ | header drop + RTL + 2× pagination drift |
| stress018 | 32 / ? | 0.638¹ | pagination drift |
| drawing | 16 / ? | 0.540¹ | DrawingML + media; pagination drift |
| stress004 | 55 / ? | 0.535¹ | pagination drift (FreeW packs ~half the pages) |
| stress008 | 92 / ? | 0.522¹ | pagination drift |

¹ Page-count mismatch: SSIM compares page *i* to page *i*, so once pagination diverges the scores
measure misalignment as much as rendering. Treat multi-page-mismatch rows as lower bounds — the low
stress-doc numbers are dominated by FreeW's denser pagination, not per-page rendering error.

- **Clean single-page text documents (same page count):** mean SSIM **≈ 0.95**.
- **All single-page-compared documents:** mean SSIM **≈ 0.95**.
- **Page-weighted overall (25 docs / 310 pages):** 0.61 — dominated by the multi-page stress documents,
  where FreeW's pagination density (≈ half Word's page count) misaligns the per-page diff; not
  representative of per-page rendering quality.

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

## Bugs fixed this session

The harness renders FreeW pages through the app's real print paginator, so the crashes it hit are crashes
the shipped Print/Print-Preview and editor also hit. Four were fixed this session, taking the FreeW render
from 14 → **26 / 26** corpus documents:

1. **Print / Print-Preview crash — `XamlWriter` cannot serialize non-public `Tag` types** *(highest
   severity; affected most real documents).* `PrintLayout.CloneElement` cloned the editor FlowDocument via
   `XamlWriter.Save`, which throws `Cannot serialize a non-public type
   'DocumentView+ParagraphTag/TableCellTag/HyperlinkInfo/FootnoteMarker/EndnoteMarker'`. A `ParagraphTag`
   is stamped on **every paragraph carrying a StyleId / bookmark / tab stop / page-break-before /
   widow-control** (`DocumentView.cs`), so this fired for essentially any real-world document, and **both
   `MainWindow.Print` and `PrintPreviewWindow` reach it**. **Fixed** by stripping the non-public Tags from
   the source for the duration of serialization and restoring them immediately after. Tests in
   `PrintLayoutTests.cs`.
2. **Header/footer overlay `∞` crash.** `HeaderFooterPaginator.BuildOverlay` set
   `FormattedText.MaxTextWidth = double.PositiveInfinity` when the header/footer content width came out
   ≤ 0 (margins ≥ page width); WPF rejects infinity with `ArgumentOutOfRangeException: paragraphWidth
   ('∞')`. **Fixed** to skip the overlay when there is no usable width. Tests in
   `HeaderFooterPaginatorTests.cs`. Confirms **simple single-section headers and footers render and match
   Word** (`headerFooter` SSIM 0.994).
3. **Negative `Block.Margin` — `ArgumentException: '0;0;-0.4;0' is not a valid value for property
   'Margin'`** (`stress003`). A negative paragraph indent/spacing maps to a negative WPF `Block.Margin`,
   which WPF rejects. **Fixed** by clamping margin components to ≥ 0 (the model keeps the original value, so
   docx round-trip is unaffected; only the live render clamps).
4. **Image-decode `NotSupportedException: No imaging component…`** (`drawing`, `EmbeddedDocument`,
   `stress008`, `WordWithAttachments`). An OLE embedded-object **icon** was decoded via the unguarded
   `DecodePng`, so an undecodable icon (WMF/EMF/uncommon codec) blanked the whole document. **Fixed** by
   decoding through a guarded `TryDecodeRaster` with a ProgID-text fallback, mirroring `DecodeImage`.

All four are committed with `FreeW.slnx` building 0-warning and the App.Host test lane green.

## Suggested follow-ups (priority order)

*(The four crashes that initially blocked rendering — XamlWriter Tag, header/footer `∞`, negative
`Block.Margin`, image-decode — were all fixed this session; see [Bugs fixed](#bugs-fixed-this-session).
The remaining items are visual-fidelity gaps, not crashes.)*

1. **Chart rendering** — honor chart type (line vs column), render all data series, and add value axis +
   legend, or at minimum render additional series. (Highest-impact remaining visual gap.)
2. **Pagination density** — FreeW packs ≈ half Word's page count on the stress docs (line-height /
   page-fill metrics; empty page-break-only pages not reproduced). This is what drags the multi-page SSIM
   scores down; closing it would both improve fidelity and make the per-page diff meaningful.
3. **Header content/images, footnote/endnote body text, checkbox glyphs, RTL alignment** — visual gaps
   already partly tracked in the round-trip doc; this run confirms them against Word ground truth.
4. **Word-rejected `deep-table-cell.docx`** — Word deems it corrupt; FreeW opens it. Not actionable for
   FreeW, noted for completeness.

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
