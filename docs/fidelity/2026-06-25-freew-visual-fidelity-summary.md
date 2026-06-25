# FreeW WPF visual-fidelity pass — consolidated findings (2026-06-25)

Verification pass (a): render FreeW's output for a purpose-built corpus across 5 feature areas
(text/layout, tables, drawing, charts/SmartArt, review/refs/headers), inspect every page, and
compare against MS Word where feasible. Per-area detail: `2026-06-25-freew-render-{text,tables,drawing,charts,review}.md`.

## Method + a critical caveat

The FreeW side was rendered with `FreeW.FidelityRender`, which rasterizes **only the bare
`FlowDocument` flow content** via `DocumentPaginator`. It does NOT composite the layers the real
app renders on top: the floating-object overlay Canvas, page chrome (border/watermark), multi-column
layout, WPF bitmap effects (clipped by the paginator's VisualBrush), and the PagedEdit-only
header/footer/footnote regions. **Anything in those layers shows as "missing" in this harness even
though the live app renders it.** Those are HARNESS ARTIFACTS, not parity bugs, and are listed
separately below. The Word-baseline pixel path (FID-0: `FreeW.PdfRasterize` + `Render-WordBaseline.ps1`)
works and was used to validate the approach (a styled-table comparison confirmed real width/padding/
border gaps), but Word COM is reliable only foreground/inline on this box and too slow to diff the
full corpus, so confirmed bugs below are rooted to source rather than pixel-diffed.

---

## A. CONFIRMED REAL APP RENDER BUGS — actionable (phase b)

### Tables
- **Banded-rows off-by-one** — `IsBandedBodyRow` returns `bodyIndex % 2 == 1`, so the FIRST data row
  is never striped (Word stripes from the first band). `DocumentView.cs:6211`. *Verify the intended
  parity against the specific built-in style before flipping.*
- **Row height ignored in render** — `BuildTable` never applies `TableRow.HeightPt`/`HeightRule` to the
  WPF row (no `MinHeight`/`Height`), so rows are shorter than Word. Render path ~`DocumentView.cs:6044`.
- **Cell vertical alignment ignored in render** — model `TableCell.VerticalAlignment` (settable at
  `DocumentView.cs:1587`) is never pushed onto the rendered `WpfTableCell` in `BuildTable`.
- **Border line styles collapse** — Double/Dotted/Dashed/Wave all render as a single thin solid line
  (partly a WPF FlowDocument limit; see §C).

### Charts / SmartArt
- **Scatter renders as a line** — `case ChartKind.Scatter:` falls into `DrawLineChart`; no discrete
  marker path. `DocumentView.cs:8464`.
- **Chart color scheme not applied** — `ColorSchemeId` ignored; always the default palette.
- **Chart data labels / axis titles absent** even when the style/quick-layout requests them.
- **SmartArt node color cycling broken** — all nodes get Color1 (index bug in the color scheme).
- **SmartArt process arrows invisible** — `MakeArrow` fill equals the adjacent box fill.

### Drawing / text
- **WordArt ChromeOne collapses** — foreground `Brushes.Transparent` ⇒ zero-height TextBlock ⇒ run
  drops out. `DocumentView.cs:8320`.
- **Reflection has no fade** — flipped copy uses flat opacity instead of a gradient OpacityMask.
- **Shape pattern presets all render as diagCross**; picture top border edge clipped (minor).
- **Drop cap not actually dropped** — large/bold letter renders inline, not sunk into the body text.
- **Em-dash mojibake** — `—` renders as `â€"` (UTF-8 mis-decode) in the text render/writer path.

### Possible interop gap (not just render)
- **Built-in styles not seeded by the writer** — a `TextDocument` authored without an explicit style
  set writes no `<w:style>` entries, so heading styles resolve to Normal. `DocxWriter.BuildStyles`.
  Worth confirming whether real-world FreeW save paths seed built-in styles (the editor does); if a
  saved doc can reference a heading style with no definition, Word would also fall back.

---

## B. HARNESS ARTIFACTS — feature works in the live app; FidelityRender can't show it (re-verify, do NOT "fix")

These were flagged BLOCKER by the per-area triage but are limitations of the bare-FlowDocument render
harness, confirmed by the agents' own code reading ("implemented correctly but not invoked by
FidelityRender", "displays correctly in the live editor", "PagedEdit handles this"):
- Floating objects (images/shapes) — live on the overlay Canvas, not composited by the paginator.
- Headers / footers — only wired into PagedEdit (W17–W18), not the continuous paginator.
- Page border + text watermark — XAML layers around the page frame, not in the FlowDocument.
- Multi-column layout — `ApplyColumnLayout` exists but isn't invoked by FidelityRender.
- Shadow / glow / soft-edge / bevel — real `Effect`s, clipped by the paginator's VisualBrush bbox.
- Section-break page-size change — a single FlowDocument can't host two page geometries.

**To verify these properly:** either (1) extend FidelityRender to render via the PagedEdit composite
path (page boxes + overlay), or (2) inspect the live WPF app. Their backing + DOCX round-trip already
have unit coverage from the build waves; what's unverified is the on-screen visual.

### Needs explicit re-check (triage was ambiguous)
- Footnotes/endnotes at page bottom, and comment / tracked-change balloons: the review triage saw none
  in the continuous path. Confirm whether PagedEdit / the W25 balloon overlay renders them; if neither
  does on-screen, these graduate to §A.

---

## C. KNOWN WPF FlowDocument LIMITATIONS (continuous view; hard floor without a custom layout)
- Tab stops & leaders — FlowDocument has no per-paragraph tab-stop API (positions/leaders/alignment).
- Border dash/double styles and per-edge cell border colors — `TableCell` exposes a single
  `BorderBrush`/`BorderThickness`, no dash style or per-edge color.

These are the same class of limitation that motivated the PagedEdit custom renderer; fixing them in the
continuous view is out of proportion to the value.

---

## Recommended phase-b order (highest value, clearly fixable first)
1. Tables: banding off-by-one, row height, cell vertical alignment.
2. Charts/SmartArt: scatter markers, color-scheme application, node color cycling, process arrows, data labels/axis titles.
3. Drawing/text: WordArt ChromeOne, reflection fade, drop cap, em-dash encoding.
4. Re-verify §B via live app or a PagedEdit-composite FidelityRender; promote any genuine misses.
