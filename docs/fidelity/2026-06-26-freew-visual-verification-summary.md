# FreeW visual verification — closing the §B gap (2026-06-26)

Later status, 2026-07-07: the shared WPF/Avalonia equation visual-planning tranche is integrated. `EquationVisualPlanner` now covers all currently modeled `MathRunKind` structures in the lightweight shared path, and the generated visual-evidence corpus includes `equation-structures`; the no-Word generator path wrote 25 DOCX fixtures including `equation-structures.docx`. Treat equation structures as closed for WPF-vs-Avalonia modeled fallback parity, but not as full Microsoft Word equation visual parity. Remaining equation work is real Word PNG baselines, nested OfficeMath layout, and pixel-faithful geometry/spacing.

Later status, 2026-07-13: `equation-structures` now has a machine-checkable shared geometry evidence contract. The manifest and normalized summary carry equation counts, element/segment/baseline role counts, nested slot count/max depth, and deterministic geometry signatures for scripts, fractions, radicals, n-ary limits/operands, matrices, equation arrays, decorators, delimiters, group characters, and function application. The WPF/Avalonia pair validator fails if those facts are missing or drift between hosts. This narrows the gap to external Word PNG comparison, but still does not provide authoritative Microsoft Word equation pixel parity on no-Word machines.

Later status, 2026-07-03: the shared WPF/Avalonia visual evidence contract is implemented in `FreeW.App.Presentation`, with WPF `FreeW.FidelityRender`, Avalonia `FreeW.PageLayoutShot`, and `FreeW.VisualEvidenceSummary` producing a common manifest/summary. The latest integrated Word-baseline fallback run rendered 18 DOCX fixtures / 28 WPF outputs through explicit software rendering and reported 54 trusted evidence rows plus 54 baseline comparison rows, including existing paired footnote/endnote placement, section geometry, table layout, drawing objects, chart/SmartArt composition, WordArt/watermark stress coverage, and the integrated run-decoration border/shading scenarios. WPF emits true portrait/landscape page dimensions for `f2-section-landscape`; Avalonia consumes the shared section-surface plan for that scenario, rendering separate portrait and landscape page-surface captures with section ownership and mixed page-geometry metadata instead of the old `avalonia-global-page-surface-no-section-page-break` skip. Treat the sections below as the June 26 historical triage; current follow-up should use the shared Word-baseline comparison and tolerance reporting path to prioritize real Word-baseline pixel comparison and deeper renderer-limitation evidence.

Runner status, 2026-07-03: `tools/Run-FreeWWordBaselineEvidence.ps1` is the bounded Word-baseline path for this contract. It regenerates the fixture DOCX corpus, renders WPF/Avalonia evidence, checks `Word.Application` COM availability before launching Word, exports Word PDFs/raster PNGs when available, and calls `FreeW.VisualEvidenceSummary` with `--word-baseline-scope generated-corpus` so baseline comparison is limited to the generated Word-comparable scenarios. CI or local machines without Word can run it with `-AllowMissingWord` to prove the no-Word summary path without opening Word. The summary keeps that no-Word path green while still emitting Word-baseline comparison rows: each row includes a baseline id, mapped baseline scenario/candidate paths, status, skip reason, tolerance limits, and metrics when pixels are actually compared. The integrated no-Word validation produced 54 trusted evidence rows and 54 baseline comparison rows with status counts `skipped=8, word-baseline-unavailable=46`. Word COM is unavailable on this machine, so no real Word PNG baselines were generated.

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
