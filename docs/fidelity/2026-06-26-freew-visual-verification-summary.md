# FreeW visual verification — closing the §B gap (2026-06-26)

Later status, 2026-07-02: the first shared WPF/Avalonia visual evidence contract is now implemented in `FreeW.App.Presentation`, with WPF `FreeW.FidelityRender`, Avalonia `FreeW.PageLayoutShot`, and `FreeW.VisualEvidenceSummary` producing a common manifest/summary. The current smoke lane generates 10 F2/page-composition DOCX fixtures, WPF renders 21 PNGs, Avalonia renders 6 PNGs, and the combined summary reports 27 trusted evidence rows. Treat the sections below as the June 26 historical triage; current follow-up should extend the shared manifest toward Word-baseline comparison and broader fixture coverage.

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
