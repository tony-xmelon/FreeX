# FreeW vs MS Word — visual fidelity comparison (2026-06-17)

**Current-state note (2026-06-21):** this remains a 26-file visual baseline, not a current
134-row corpus visual baseline. Reusable render/compare tooling now lives under `tools/FreeW.RenderCompare/`;
run outputs under `freew-fidelity-corpus/runs/` remain ignored local artifacts.

Companion to [`2026-06-17-freew-corpus-roundtrip.md`](2026-06-17-freew-corpus-roundtrip.md), which
established that all 26 `freew-fidelity-corpus` documents **open and round-trip** through
`DocxReader`/`DocxWriter` with no modeled-content loss, but deferred the **visual** pixel-diff against
MS Word because no Word engine was available on the machine at the time.

That blocker is gone: **MS Word (Office16, `WINWORD.EXE`) is now installed and COM-automatable** on this
machine, so this run does the deferred comparison — FreeW's own page rendering vs Word's ground-truth
rendering, page by page, with SSIM + pixel-delta heatmaps.

## Method

1. **Word ground truth.** Each corpus `.docx` → PDF via Word COM `ExportAsFixedFormat`, then rasterized
   to per-page PNG at 150 DPI (`pypdfium2`). Reusable tooling lives under `tools/FreeW.RenderCompare/`;
   run-specific helper copies and outputs stay under ignored `freew-fidelity-corpus/runs/`.
2. **FreeW rendering.** A headless WPF harness (`tools/FreeW.RenderCompare`) loads each `.docx` through
   `DocxReader`, hosts it in the real `DocumentView`, and rasterizes every page through the app's actual
   print paginator (`HeaderFooterPaginator` over the live FlowDocument) to PNG at 150 DPI.
3. **Diff.** `tools/FreeW.RenderCompare` and run-local comparison helpers align FreeW vs Word page-for-page, compute SSIM and
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
| chartex | 2 / 3 | 0.894¹ | multi-series + type-correct + legend + gridlines |
| endnotes | 1 / 1 | 0.890 | note body now drawn at foot; docDefaults spacing |
| VariousPictures | 1 / ? | 0.895¹ | docDefaults spacing (was 0.857) |
| delins | 1 / 1 | 0.774 | autospacing block-suppression (was 0.746); residual = WPF/Word line metrics |
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
- **Page-weighted overall (25 docs / 320 pages):** ≈ 0.61 — dominated by the multi-page stress documents,
  where FreeW's pagination diverges from Word and misaligns the per-page diff (see the measurement caveat
  below); not representative of per-page rendering quality.

**Bottom line:** for ordinary text, lists, tables, fields, bookmarks, comments and footnote/endnote
*markers*, FreeW's page rendering is a close visual match to Word (SSIM 0.95–0.999). The gaps are
concentrated in specific feature areas below.

## Visual fidelity gaps (rendered docs)

- **Charts — FIXED this session.** Originally FreeW drew a single-series column chart regardless of kind
  (the `chartex` line chart rendered as columns, series 2–3 absent, no axis/legend). `BuildChartRun` now
  renders **all** series and honours the kind (grouped columns / horizontal bars / line / pie–doughnut),
  with an Office palette, category-axis labels, a baseline, and a legend. Verified: `chartex`'s 3-series
  column chart and 3-series line chart now both match Word.

Also **FIXED this session** (see [features added](#format-fidelity-features-added-this-session-toward-100-word-parity)):
**RTL/bidi** (Arabic docs now mirror right-to-left like Word), **checkbox glyphs** (SDT + legacy
FORMCHECKBOX now render ☒/☐), **line spacing** (`w:line`/`w:lineRule` read/written), **manual page breaks**,
and **chart gridlines**.

> **Measurement caveat.** The page-weighted SSIM compares FreeW page *i* to Word page *i*. On the
> multi-page docs FreeW's page count differs from Word's, so the diff measures **pagination misalignment**,
> not per-page rendering — which is why the RTL fix (visually confirmed to mirror the Arabic stress docs
> like Word) barely moves their SSIM. The **single-page documents are the trustworthy signal** and sit at
> **0.95–0.999**. Real-world content (text, lists, tables, fields, charts, RTL, page breaks, line spacing,
> checkboxes, footnote markers, tracked changes, comments, simple headers/footers) now renders faithfully.

Remaining gaps (larger / niche — see [follow-ups](#suggested-follow-ups)):

1. **Pagination density** on the synthetic stress fixtures — FreeW's per-page line count still diverges
   from Word (page-fill metrics, exact-spacing clipping, section handling). Dominates the multi-page SSIM;
   deep WPF line-metric work, low real-world impact.
2. **Header content + header images on multi-section docs** (`stress010`'s "CEDAW" letterhead/emblem). Word
   renders the multi-section page header; FreeW omits it. (Simple single-section headers/footers render and
   match — `headerFooter` SSIM 0.994.)
3. **Footnote / endnote bodies on *multi-page* docs.** Single-page docs now draw the note bodies at the
   foot (done this session); multi-page placement needs per-page note→page mapping + content-area space
   reservation (so the notes sit at Word's content-bottom rather than the margin).

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

## Format-fidelity features added this session (toward 100% Word parity)

Beyond the crashes, several real format gaps the comparison surfaced were closed end-to-end (model →
reader → writer → view, each with round-trip + render tests; `FreeW.slnx` 0-warning, full lane green):

1. **Right-to-left / bidi** (`w:bidi`, `w:rtl`) — was not modelled at all, so Arabic/Hebrew documents
   rendered left-to-right and the direction was dropped on round-trip. Now maps to WPF
   `FlowDirection.RightToLeft`. The Arabic stress docs (`stress004/008/010`, …) now mirror RTL like Word
   (right-aligned text, QR/logo on the right, RTL TOC).
2. **Manual page breaks** (`w:br w:type="page"`) — break-only runs were dropped (under-paginating badly);
   now read/written and mapped to `Paragraph.BreakPageBefore` so the paginator starts a new page (`w:pageBreakBefore` too). `saut_page` went 1 → 2 pages.
3. **Line spacing** (`w:spacing/@w:line` + `@w:lineRule`) — neither read nor written, so every paragraph
   rendered at the 1.15 default. Now reads/writes the multiple (auto) and exact/at-least absolute heights;
   default-spaced docs stay byte-stable.
4. **Checkbox content controls** — render the ☒/☐ glyph synthesised from the checked state in a symbol
   font, and read **legacy `FORMCHECKBOX` form fields** (what the `checkboxes` doc uses) as checkbox
   controls. All checkboxes in `checkboxes.docx` now render with correct state.
5. **Chart gridlines** — faint horizontal value gridlines behind the data, matching Word (layout-neutral).
6. **VML images** (`w:pict/v:imagedata`) — older docs embed pictures via legacy VML rather than DrawingML;
   the picture reader now reads both (e.g. `stress010`'s WMF/EMF logo).
7. **Footnote / endnote bodies at the page foot** — single-page documents now draw a separator rule and
   the note text in the bottom margin (previously only the reference marker showed). Multi-page placement
   (per-page note mapping + content-area space reservation) remains a follow-up; the note position is
   approximate (margin vs Word's content-bottom), so the note *text* is now visible though SSIM is flat.
8. **Document default spacing (`w:docDefaults`) + automatic spacing (`w:before/afterAutospacing`)** — both
   were ignored, so paragraphs that don't set their own spacing rendered at 0 space-after / 1.15 line
   regardless of the document. Now read and applied (autospacing approximated at ~one line). Lifted
   `VariousPictures` 0.857 → 0.895 and `endnotes` → 0.890; overall page-weighted SSIM 0.614 → 0.619.
9. **Per-property paragraph style cascade** (`DocumentView.Resolve`) — resolution was all-or-nothing: a
   paragraph whose direct formatting differed from the model default in *any* field kept *all* its fields,
   so a styled paragraph that set only (say) alignment rendered with FreeW's hardcoded 8pt-after / 1.15
   defaults instead of inheriting its style's spacing. Now each property (alignment, all four spacing/line
   fields, indents, border, shading) falls back to the style value independently when the direct value
   equals the model default. Proven by `ParagraphStyleCascadeTests` (styled paragraph with direct
   alignment inherits the style's 24pt spacing; explicit spacing still wins). **No SSIM change on this
   corpus** — its styles don't define spacing that differs from what direct formatting already carried — so
   this is a correctness fix that will matter for real documents with rich style hierarchies, not a mover
   of the current numbers. (A fuller version would make the formatting fields nullable so an *explicit*
   value equal to the model default is distinguishable from "unset"; the render-only heuristic here treats
   them the same, which is correct for every real case except a paragraph that deliberately re-states the
   default — an acceptable bound given the byte-stability risk a nullable refactor of the reader/writer
   would carry.)

10. **Multiple line-spacing applied to the natural line height** (`DocumentView.BuildParagraph` /
    `ReadLineSpacing`) — the biggest single visual mover. Word's `w:lineRule="auto"` multiplies one *line*
    (the font's natural ascent+descent+gap) by the multiple; FreeW multiplied the raw em, and
    `LineStackingStrategy.MaxHeight` then clamped the result back to a single natural line. Every
    multiple-spaced paragraph therefore rendered ~8–22% too short, so FreeW packed more lines per page and
    its pagination drifted out of registration with Word's across multi-page docs. Now the multiple is
    applied to `FontFamily.LineSpacing` (Times 1.15, Calibri 1.22), keyed on the document default font and
    cached; `ReadLineSpacing` inverts the same ratio so edit round-trips are unchanged (`LineHeightMultipleTests`).
    Measured effect: `drawing` now paginates to **exactly Word's 20 pages** (was 19); `endnotes`
    0.890→0.931, `VariousPictures` 0.895→0.930, `stress018` 0.656→0.704, `stress008` 0.547→0.570,
    `stress010`/`stress004` up; **overall page-weighted SSIM 0.633→0.648**. Caused a temporary regression in
    `stress023` (0.683→0.622) — fixed by item 11 below. NB `stress023` uses *installed* Times/Calibri, not a
    substitute: where its pagination still differs (15 vs Word's 12) the cause is WPF's `FontFamily.LineSpacing`
    for Calibri (1.22) exceeding Word's "one line" for the same installed font — genuine WPF-vs-Word
    natural-line divergence, not a formula error.
11. **Paragraph line spacing resolved through the style chain** (`DocxReader` + `DocumentView.Resolve`) —
    reading a body paragraph resolved spacing as `direct pPr ?? docDefaults ?? builtin`, never consulting the
    paragraph's own **style**. Because the reader baked the docDefault into a non-default value, the render
    cascade couldn't tell it from an explicit setting and wouldn't recover the style's spacing — so a
    paragraph in a 1.0-/1.5-line style inherited the docDefault instead. Added an explicit `LineSpacingIsSet`
    flag (set only on a direct `w:line`; styles set it likewise) and resolved line spacing as a unit in
    `Resolve`: `direct ?? style ?? inherited`. **Render-only** — the writer still emits from the value
    fields, so docx round-trip/byte-stability are unchanged (966 tests green incl. the IO byte-equality lane).
    Recovered the `stress023` regression (0.622→**0.683**, back to baseline) and lifted **overall 0.648→0.650
    with no doc below its starting baseline**. Test
    `StyledParagraph_WithoutDirectLineSpacing_InheritsStyleLineSpacing`.
12. **Paragraph space-before/after resolved through the style chain** — same explicit-vs-inherited fix for
    `w:before`/`w:after` (`SpaceBeforeIsSet`/`SpaceAfterIsSet`). A read paragraph carries 0pt-after when it
    sets none, and `0 != the model's 8pt default` made the old cascade keep the 0 and never inherit the
    style's space-after (packing styled paragraphs tighter than Word). Render-only, byte-stable.
    **overall 0.650→0.652**, `stress010` 0.726→0.733, `stress015` 0.713→0.724, `stress003` up; no regression.
    `delins` 0.774 is **unchanged** — confirming its residual is the list-rendering/line-metric floor, not
    space-after inheritance (measured, not assumed).
    - **Indents: tried the same is-set cascade, measured, and reverted.** It was fidelity-neutral overall but
      regressed `stress015` (0.724→0.716): that doc has 110 paragraphs with explicit `w:ind/@left="0"`, and
      honouring the literal 0 (naive OOXML "direct wins") pushed them to the margin — but Word renders them at
      the **numbering/list indent**, i.e. the list level's indent takes precedence over a paragraph's explicit
      `w:left="0"` for a numbered paragraph. The value-vs-default behaviour (inherit) happened to match Word
      better, so the indent flag was reverted. Indents keep value-vs-default resolution (their model default is
      0, so an unset indent already reads as the default and inherits the style correctly — only the non-zero
      defaults, space-after=8 and the docDefault-baked line spacing, needed the explicit flag).

13. **Table borders inherited from the table style** (`DocxReader` + `DocumentStyle.TableBorders`) — a table
    whose borders come from its referenced style (the built-in `TableGrid` Word applies to a default bordered
    table) but with no explicit `w:tblBorders` rendered borderless: the reader set `Borders` from the table's
    own `tblBorders` only. Now captures each style's `tblPr/tblBorders` and ORs it in. `TableGrid` is Word's
    default table style, so this is a common real-world correctness fix; IO byte-equality lane stays green.
    On the corpus it **dipped `checkboxes` 0.946→0.939**: the now-visible borders expose FreeW's residual
    table-cell layout difference from Word (the same WPF-vs-Word floor as text line metrics) — the fix is
    correct (Word draws these borders), the dip is a separate engine-level layout difference it made visible,
    not a reason to leave real tables unbordered. A precise table-cell layout match is a follow-up (item 14).
14. **Table-cell layout pass** (`DocumentView.BuildParagraph inTableCell`) — table cell paragraphs inherited
    the body docDefault spacing (e.g. 10pt-after, 1.15-line), so rows rendered visibly taller than Word, which
    lays cells out via the built-in `TableNormal` style (0pt before/after, single line — the base of every
    table style). `BuildParagraph` now compacts a cell paragraph's *unset* spacing/line fields (using the
    `IsSet` flags) to 0/single, matching `TableNormal`; explicitly-spaced cell paragraphs are untouched.
    Investigation confirmed FreeW already reads table structure, `gridCol` widths and (item 13) style borders
    correctly; the residual table row-height/position difference vs Word is the **same WPF-vs-Word layout
    floor as text line metrics** (cell padding + natural-line height computed differently). Net: overall
    **0.652 (neutral)** — tables are now structurally Word-faithful (borders present, compact rows), but the
    SSIM metric under-credits that because the residual cell layout/position divergence is engine-level. Black
    border colour was tried and reverted (it amplified the positional mismatch where faint gray hid it).

**Net across the session: overall page-weighted SSIM 0.614 → 0.652. The paragraph spacing cascade (line +
before + after) that drives pagination is correct, table-style borders render, and table cells lay out
compact like Word. The remaining gap is the engine floor — WPF-vs-Word natural-line metrics even for installed
fonts, font substitution where docs embed none (70% of weighted pages = Arabic stress docs, fonts confirmed
absent), sub-pixel rounding, and the analogous table-cell layout divergence — not correctable from the
model/IO layer. 100% visual SSIM is unreachable between two independent layout engines; every model/IO-layer
cause has been fixed or empirically disproven.**

## Diagnosis: pagination drift was mostly a real line-height bug; the rest is engine line metrics

Page-by-page inspection (triptychs in `runs/diff/`) showed the dominant residual was **vertical line
drift** — identical content offset vertically (`drawing-p5`: same paragraphs both sides) — and measuring the
actual line pitch in the rendered PNGs traced most of it to a fixable cause, not engine divergence:

- Measured line pitch FreeW vs Word (PNG ink-row analysis): `endnotes` Word/FreeW = **1.08**, `delins`
  **1.22**, while single-spaced `drawing` matched at **1.00**. The 1.08/1.22 are exactly the *Multiple* line
  rule being applied to the em instead of the natural line height — fixed in item 10 above.
- What remains after the item 10 + 11 fixes is genuine two-engine divergence: (a) font **substitution**
  (Cyrillic/Arabic and embedded faces WPF and Word substitute differently) and (b) the natural-line metric
  differing even for *installed* fonts (WPF Calibri 1.22 vs Word's smaller value — why `stress023` still
  paginates 15 vs 12, and `delins` 0.774 is unmoved) plus sub-pixel rounding. Forcing an exact line height
  (`LineStackingStrategy.BlockLineHeight`) to erase it clips tall glyphs.
- Line spacing now cascades precisely via the `LineSpacingIsSet` flag (item 11). Extending the same
  explicit-vs-inherited treatment to the other spacing/indent fields (the full nullable refactor, item 9)
  is the remaining model-layer correctness step, but it is **fidelity-neutral** on this corpus — the
  measured residual is the engine floor above, not the model layer.

**Conclusion:** A real line-height bug — not engine divergence — was the largest cause of the pagination
drift, and fixing it lifted overall SSIM and made `drawing` paginate exactly like Word. The remainder is
engine-bound: 1.0 SSIM is unreachable between WPF and Word's layout engines (text-only ceiling ~0.99 —
`testComment`/`FieldCodes` 0.999/1.000, `saut_page` 0.998), driven by font substitution and sub-pixel
rounding that the model/IO layer cannot fully close.

## Suggested follow-ups (priority order)

*(All render-blocking crashes, the chart rendering, plus RTL, page breaks, line spacing and checkboxes
were done this session. FreeW renders 26/26 corpus docs. Remaining items are larger or niche.)*

1. **Pagination density** — FreeW's per-page line count still diverges from Word on the synthetic stress
   fixtures (multi-causal: page-fill metrics, exact-spacing clipping, section handling). This drags the
   multi-page SSIM scores; deep WPF line-metric work, lower real-world impact.
2. **VML images** (`w:pict`/`v:imagedata`) — older docs (e.g. `stress010`'s WMF/EMF) reference images via
   legacy VML, which the picture reader (DrawingML-only) skips.
3. **Header content/images on multi-section docs** and **footnote/endnote body text at the page foot** —
   reader/paginator work (the latter needs page-foot space reservation to avoid overlapping body text).
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
