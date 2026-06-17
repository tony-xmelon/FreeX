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
| chartex | 2 / 3 | 0.900¹ | now multi-series + type-correct + legend (fixed this session) |
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

- **Charts — FIXED this session.** Originally FreeW drew a single-series column chart regardless of kind
  (the `chartex` line chart rendered as columns, series 2–3 absent, no axis/legend). `BuildChartRun` now
  renders **all** series and honours the kind (grouped columns / horizontal bars / line / pie–doughnut),
  with an Office palette, category-axis labels, a baseline, and a legend. Verified: `chartex`'s 3-series
  column chart and 3-series line chart now both match Word.

Remaining gaps (require larger, multi-layer work — see [follow-ups](#suggested-follow-ups)):

1. **Pagination density differs from Word.** FreeW consistently produces *fewer* pages: `stress010`
   59 vs 118, `stress004` 55 vs more, `saut_page` 1 vs 3, `chartex` 2 vs 3. `saut_page` (a page-break
   stress fixture) collapses to a single FreeW page. FreeW's line-height / page-fill metrics pack more
   content per page than Word, and empty page-break-only pages are not reproduced. **This is what drags
   the multi-page SSIM scores down** (the per-page diff misaligns once page counts diverge).
2. **Header content + header images dropped** (`stress010`, an RTL Arabic CEDAW report). Word renders the
   "CEDAW" letterhead block and the UN emblem in the page header; FreeW's first page omits the entire
   header block and emblem. Matches the round-trip doc's header-read and images-in-header gaps. (Simple
   single-section headers/footers *do* render and match — `headerFooter` SSIM 0.994.)
3. **RTL / bidirectional alignment** (`stress010`). Word right-aligns the Arabic content and TOC; FreeW
   does not mirror to RTL. Newly surfaced here; needs **model + reader + writer + view** support
   (`w:bidi`/`w:rtl` are not modelled today), so it is a feature, not a render tweak.
4. **Footnote / endnote text not shown at page foot** (`footnotes`, `endnotes`, `table_footnotes`). The
   superscript reference marker renders correctly, but the note *body* Word prints at the bottom of the
   page (with separator) is absent — a `FlowDocument` limitation; reproducing it needs a custom
   page-foot paginator pass that maps notes to the page their markers fall on.
5. **Content-control checkbox glyphs not drawn** (`checkboxes`). The reader *does* recognise `w14:checkbox`
   SDTs, but the wrapped run's text/font doesn't yield a visible ☐/☒; needs render-time glyph synthesis
   from the checked state in a symbol font.
6. **Line-spacing vertical drift** (`delins`). Content matches (tracked-change insertions in red underline,
   deletions in red strikethrough, blue hyperlinks all correct), but FreeW's slightly tighter line spacing
   makes the two renders drift apart progressively down the page — the main reason its SSIM is 0.75 despite
   matching content. (Same root cause as pagination density.)

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

All four are committed with `FreeW.slnx` building 0-warning and the App.Host test lane green. **Chart
rendering** (all series + correct type + legend) was also fixed this session — see
[Visual fidelity gaps](#visual-fidelity-gaps-rendered-docs).

## Suggested follow-ups (priority order)

*(Everything that blocked rendering — the four crashes and the single-series/wrong-type chart — was fixed
this session. FreeW now renders 26/26 corpus docs. The remaining items are larger multi-layer features,
not quick fixes.)*

1. **Pagination density** — FreeW packs ≈ half Word's page count on the stress docs (line-height /
   page-fill metrics; empty page-break-only pages not reproduced). This is what drags the multi-page SSIM
   scores down; closing it would both improve fidelity and make the per-page diff meaningful. The single
   biggest remaining lever, but deep (WPF line-metric tuning).
2. **RTL / bidirectional layout** — not modelled at all today; needs model + reader (`w:bidi`/`w:rtl`) +
   writer + view (`FlowDirection`) support.
3. **Header content/images on multi-section docs** and **footnote/endnote body text at the page foot** —
   reader/paginator work already partly tracked in the round-trip doc.
4. **Checkbox glyph synthesis** — render `w14:checkbox` controls with a state-derived ☐/☒ in a symbol font.
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
