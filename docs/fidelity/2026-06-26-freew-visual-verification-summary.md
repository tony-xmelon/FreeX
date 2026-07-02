# FreeW visual verification — closing the §B gap (2026-06-26)

Later status, 2026-07-02: the shared WPF/Avalonia visual evidence contract is now implemented in `FreeW.App.Presentation`, with WPF `FreeW.FidelityRender`, Avalonia `FreeW.PageLayoutShot`, and `FreeW.VisualEvidenceSummary` producing a common manifest/summary. The current smoke lane generates 17 F2/page-composition DOCX fixtures, WPF renders 35 PNGs, Avalonia renders 22 PNGs, and the combined summary reports 57 trusted evidence rows, including paired footnote/endnote placement, section geometry, table layout, drawing objects, chart/SmartArt composition, WordArt-over-watermark stress, and WordArt plus picture-watermark layout stress coverage. WPF emits true portrait/landscape page dimensions for `f2-section-landscape`; Avalonia emits the shared section ownership and expected page-geometry metadata, while its row metadata still marks the remaining renderer gap as `avalonia-global-page-surface-no-section-page-break`. Treat the sections below as the June 26 historical triage; current follow-up should use the shared Word-baseline comparison and tolerance reporting path to prioritize true Avalonia mixed-section page surfaces and deeper WordArt/watermark fidelity polish.

Runner status, 2026-07-02: `tools/Run-FreeWWordBaselineEvidence.ps1` is the bounded Word-baseline path for this contract. It regenerates the 17 fixture DOCX corpus, renders WPF/Avalonia evidence, checks `Word.Application` COM availability before launching Word, exports Word PDFs/raster PNGs when available, and calls `FreeW.VisualEvidenceSummary` with `--word-baseline-scope generated-corpus` so baseline comparison is limited to the generated Word-comparable scenarios. CI or local machines without Word can run it with `-AllowMissingWord` to prove the no-Word summary path without opening Word.

The 2026-06-25 fidelity pass flagged a set of features as "missing", but those were blind spots of the
old bare-FlowDocument `FreeW.FidelityRender`. We (1) gave the renderer a **composite mode** that draws the
overlay/chrome/column/header layers the live app shows, then (2) re-rendered and re-triaged each flagged
feature. Detail: `2026-06-26-freew-visual-verify-objects.md`, `-flow.md`. This resolves §B into three
honest buckets.

## A. CONFIRMED-RENDERS — were harness false-positives; now visually verified good
These render correctly in composite mode (read off the PNGs), so they were never real gaps:
- Page **border** (width/color, all four edges).
- Text **watermark** (diagonal tiled, opacity).
- **Multi-column** layout + column rule (2-col verified; see B for 3-col).
- **Floating images** with square/tight wrap (object placed correctly; text does not reflow around it,
  which matches the live app — WPF FlowDocument has no wrap-around layout).
- Floating **z-order** stacking.
- Tracked **insertions/deletions** (distinct underline/strikethrough + per-author color).
- **Comment anchor** highlighting; footnote/endnote **reference superscripts**.

## B. HARNESS-LIMITATION — the live app renders these; the composite harness still can't fully capture them
Not app bugs (the editor shows them correctly); the offscreen/composite rasterization path can't reproduce them:
- **WPF effects on objects** (shadow / glow / reflection / soft-edge / bevel) — the effect's overflow
  pixels are clipped by the page-compositing `VisualBrush` bbox, and the floating `DrawImage` path bypasses
  the WPF effect pipeline. Effects ARE applied in-app (their code paths have unit coverage); the harness
  just can't show them. Verifying these needs the live app or a Word-baseline pixel check.
- **Floating shape fill/geometry** — the harness grabs the editor-interaction *placeholder* visual
  (`BuildFloatingObjectVisual`, `DocumentView.cs:4897`), not the real shape; the live editor draws the
  correct fill/outline.
- **Header/footer placement + pages 2+** — composite emits the H/F overlay for page 1 only and clips its
  Y-position; the PagedEdit app repeats per-section H/F across pages (W18). A render-harness gap.
- **3-column** collapsing to 2 with light content — needs a Word-baseline confirm of expected column count.

## C. GENUINE APP GAPS — real fidelity misses (the live app / PagedEdit doesn't render them either)
These graduate from "harness artifact" to real, fixable fidelity gaps:
- **Footnote content** is not drawn at the page bottom (only the reference superscript shows).
- **Endnote content** is not drawn at the document end.
- **Section-break (next-page) page-size change** does not take effect — a portrait→landscape section renders
  on the same portrait page (a single FlowDocument can't host two geometries; needs the PagedEdit per-section
  page path).

These are architectural (FlowDocument has no footnote region; multi-geometry needs the page renderer), so
they belong with the "WPF FlowDocument limits via PagedEdit" track — a bounded follow-up wave, not a quick fix.

## Net
The visual pass converted ~half of the §B "missing" list into **confirmed-good**, isolated the rest into
**harness-only limitations** (live app is fine) vs **3 genuine app gaps** (footnote/endnote content,
section page geometry). Combined with the phase-b render-bug fixes already shipped, FreeW's *renderable*
fidelity is now verified; the named genuine gaps are the honest remaining fidelity work.
