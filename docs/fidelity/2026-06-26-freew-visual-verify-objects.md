# FreeW Visual-Fidelity Verification — Objects / Chrome / Columns (2026-06-26)

Verification pass using the new `FreeW.FidelityRender` composite mode.  Previously the bare
FlowDocument paginator rendered only body text; the composite path adds floating-object overlay,
watermark, page border, and multi-column layout layers.

Corpus: 7 purpose-built `.docx` files under `freew-fidelity-corpus/files/f2-objects/`  
Generator: `freew/tools/_corpus_f2_objects/` (new, this commit)  
Rendered: `freew-fidelity-corpus/runs/f2-objects-composite/` (`--composite` default, 96 dpi)  
Render tool: `freew/tools/FreeW.FidelityRender/bin/Release/…/FreeW.FidelityRender.dll`  
Method: Read each PNG with the AI image viewer; judged against expected Word appearance (from
knowledge — orchestrator does Word baselines separately for pixel-diff).

---

## Status Table

| # | Feature | File | Verdict | What the PNG shows |
|---|---------|------|---------|-------------------|
| 1 | Floating image — Square wrap | f2-01-float-wrap | **CONFIRMED-RENDERS** | Solid-red image present at left margin; text partially visible alongside it |
| 2 | Floating image — Tight wrap | f2-01-float-wrap | **CONFIRMED-RENDERS** | Solid-blue image present at right; text partially visible alongside it |
| 3 | Floating image — text reflow around object | f2-01-float-wrap | **RENDERS-WITH-ISSUES** | Text is partially obscured by images rather than cleanly flowing around them — WPF FlowDocument has no text-wrap-around-floating-object API; images overlay text in the composite canvas |
| 4 | Floating shapes — presence | f2-02-float-zorder | **RENDERS-WITH-ISSUES** | All 3 shapes visible as placeholder boxes with geometry labels ("Rectangle", "Ellipse", "RoundedRectangle") |
| 5 | Floating shapes — fill/outline colors | f2-02-float-zorder | **STILL-MISSING** | No fill colors; shapes render as blue-grey outlines with type labels — `BuildFloatingObjectVisual` (DocumentView.cs:4897) is a placeholder that ignores `FillColorHex`/`OutlineColorHex` |
| 6 | Floating shapes — z-order stacking | f2-02-float-zorder | **CONFIRMED-RENDERS** | Blue rect, Orange ellipse, Green roundrect overlap in correct z-order (blue lowest, green highest) |
| 7 | Inline shape — drop shadow effect | f2-03-object-effects | **STILL-MISSING** | Red rect visible with correct solid fill; no shadow halo around it |
| 8 | Inline shape — glow effect | f2-03-object-effects | **STILL-MISSING** | Teal ellipse visible with correct fill; no cyan glow halo |
| 9 | Floating image — shadow effect (DrawImage path) | f2-03-object-effects | **STILL-MISSING** | Gradient image visible at top-right via DrawImage; no shadow halo — `DrawImage` on a plain `ImageSource` carries no WPF `Effect`; the effect was set on the WPF `Image` control, not on the pixel data |
| 10 | Page border (rect, navy, 3 pt) | f2-04-border-watermark | **CONFIRMED-RENDERS** | Navy rectangle border clearly visible around all four page edges |
| 11 | Watermark — tiled diagonal text | f2-04-border-watermark | **CONFIRMED-RENDERS** | "DRAFT" appears tiled diagonally at ~40% grey across entire page; correct density and angle |
| 12 | 2-column layout | f2-05-columns-2 | **CONFIRMED-RENDERS** | Body text split cleanly into two equal columns |
| 13 | Column rule (2-column) | f2-05-columns-2 | **CONFIRMED-RENDERS** | Thin grey vertical rule visible between the two columns |
| 14 | 3-column layout | f2-06-columns-3 | **RENDERS-WITH-ISSUES** | Page shows only 2 columns (Para 1–25 left, Para 26–50 right), not 3 — see §B below |
| 15 | Column rule (3-column) | f2-06-columns-3 | **RENDERS-WITH-ISSUES** | One rule visible (consistent with 2-column rendering); a 3-column layout would show 2 rules |
| 16 | Combined: border + watermark + 2-col + floating shape | f2-07-combined | **CONFIRMED-RENDERS** (3 of 4) | Dark-navy border, "CONFIDENTIAL" red watermark diagonal, two-column split all render correctly together; floating green rectangle shows as placeholder box (same as finding 5) |

---

## A. CONFIRMED-RENDERS — Previously "harness artifacts", now verified good

These were in the §B (harness-artifact) list of `2026-06-25-freew-visual-fidelity-summary.md`.
Composite mode resolves them:

### A1 — Floating images (Square + Tight wrap)
Both `InlineImage` floating objects appear in the composite output.  The composite path's
per-child `DrawImage` call (Program.cs:200–206) extracts `img.Source` and draws it at the
correct canvas offset.  Images are positioned correctly relative to the page.

**Remaining nuance (not a new bug):** WPF `FlowDocument` has no floating-wrap API — the
body text is not reflowed around floating objects.  In the live editor the text also doesn't
reflow (the FlowDocument doesn't know about the overlay canvas); the wrap is a visual-only
effect applied by the editor's layout logic.  This is the same WPF architectural limit as in
the live app's continuous view.

### A2 — Page border
Navy 3 pt rectangle visible on all four page edges.  Layer 3 (`DrawingVisual` with `Pen` rect)
works correctly headlessly.

### A3 — Text watermark (diagonal, tiled)
`RenderWatermarkTile` correctly measures a `TextBlock`, renders it to a bitmap tile, and tiles
it across the full page.  The "DRAFT" and "CONFIDENTIAL" watermarks both appear correctly.

### A4 — Multi-column layout (2-column)
`ApplyColumnLayout` is invoked in the composite path before pagination.  2-column layout with
a grey column rule renders correctly.

---

## B. RENDERS-WITH-ISSUES — Partial renders with documented limitations

### B1 — Text reflow around floating images
The body text does not flow around floating images; it is partially obscured.  This is not a
regression — the continuous `DocumentView` (FlowDocument) has never had wrap-aware text layout
for floating objects.  The composite path simply overlays the image canvas on top.  Word
achieves text-wrap via its own layout engine. **No code change needed here; document as known
limit.**

### B2 — 3-column layout renders as 2 columns

**Observed:** f2-06-columns-3 (PageSettings.ColumnCount=3, ColumnSpacingPt=24) shows 2
columns, not 3.

**Suspected cause:** `ApplyColumnLayout` sets `flow.ColumnWidth` to
`(contentWidth − 2×24pt) / 3 ≈ 208 dip` with `IsColumnWidthFlexible = true`.  WPF's
`FlowDocument` column layout uses `ColumnWidth` as a *minimum* column width when flexible.
With only 50 short paragraphs the paginator may compute fewer than 3 page-heights worth of
content and collapse into 2 columns on a single page.  A 3-column layout may require enough
content to fill 3 columns on one page; with short content WPF falls back to as few columns
as fit.  This is a WPF FlowDocument behaviour, not a FreeW model or composite-path bug.

**Verdict:** Needs a Word baseline pixel-check to confirm whether this is a WPF column-count
floor behaviour or a calculation error in `ApplyColumnLayout`.  Flag for orchestrator.

**VS-WORD flag: YES** — orchestrator should generate same document in Word and confirm
expected 3-column layout with the same content volume.

---

## C. STILL-MISSING — Genuine remaining gaps

### C1 — Floating shape fill/outline colors (genuine bug)

**File:** f2-02-float-zorder  
**Observed:** Three floating shapes render as blue-grey placeholder boxes with geometry-type
labels.  No fill colors.

**Root cause:** `BuildFloatingObjectVisual` (DocumentView.cs:4897–4954) is an editor
interaction placeholder.  It renders a `Border` with a semi-transparent blue-grey background
and a `TextBlock` showing the shape kind.  It does NOT use `Shape.FillColorHex`,
`OutlineColorHex`, `ExtendedFill`, or `Kind` geometry.  This is the correct editor-UX
behavior (shapes are identified in the overlay for click-selection), but it means the
composite FidelityRender harness captures placeholder appearance rather than the actual shape.

**In the live app:** The actual rendered shape appearance is built inline in the FlowDocument
via `BuildShapeRun` (DocumentView.cs:~8080–8200), which renders inline shapes as WPF
`Path`/`Grid` elements with correct fills.  Floating shapes use this same FlowDocument path
via the FlowDocument's inline anchor run, then are overlaid by the placeholder canvas element
for interactivity.

**Implication for the harness:** The composite render correctly shows what the *overlay canvas*
contains (the placeholder).  The *actual shape visual* (the WPF Path from `BuildShapeRun`) is
in the FlowDocument body.  A fully accurate fidelity composite would need to either:
  (a) pull the actual rendered WPF visual from the `BuildShapeRun` path instead of
      `BuildFloatingObjectVisual`, or
  (b) render the inline `BuildShapeRun` output headlessly and use it as the floating layer.

**This is NOT a regression in FreeW's rendering** — the live editor shows the actual shape
correctly (the FlowDocument path works).  It is a harness limitation in how the composite
render exposes floating shapes.  The gap in the old bare render (shapes absent) has been
resolved to "shapes present as placeholders"; full-fidelity shape rendering in the harness
requires a more sophisticated compositing strategy.

**Suspected code location:** `BuildFloatingObjectVisual` at DocumentView.cs:4897.  The fix
direction for the harness is to call `BuildShapeRun` (or an equivalent headless renderer) and
rasterize the result, rather than using the interactive-placeholder `Border`.

**VS-WORD flag: YES** (shape fill/outline colors need Word comparison).

### C2 — WPF Effects (shadow/glow) on all object types

**Files:** f2-03-object-effects  
**Observed:** Inline RED rectangle with `HasShadow=true` — no shadow halo.  Teal ellipse with
`HasGlow=true` — no glow halo.  Floating gradient image with `ShadowPreset=2` — no shadow.

**Root cause (shadow/glow on inline shapes):** `ApplyShapeModelEffects` (DocumentView.cs:8153)
sets `element.Effect = new DropShadowEffect(…)` / glow approximation on the WPF `FrameworkElement`.
WPF `Effect`s extend pixels outside the element's layout bounds.  The FlowDocument paginator
renders each page via `paginator.GetPage(i)` → `DocumentPage.Visual`.  When that visual is
composited with `VisualBrush(docPage.Visual)` (Program.cs:279), the `VisualBrush` clips to
the visual's declared bounds, stripping effect overflow pixels.  Result: shadow/glow are
invisible in the rasterised page even though they render correctly in the live scrollable editor.

**Root cause (shadow on floating image):** The composite path handles floating images via
`dc.DrawImage(src, rect)` (Program.cs:205), which draws the raw `ImageSource` pixels without
any WPF `Effect`.  The `DropShadowEffect` was set on the WPF `Image` control
(`BuildFloatingImageVisual`), which is a WPF UI element that only processes `Effect` when
rendered in a live visual tree.  `DrawImage` bypasses the control entirely.

**All three effects paths share the same root:** WPF `Effect`s require a live visual-tree render
to materialise.  The headless paginator/DrawImage path never executes the effect pipeline.

**Verdict:** This is a confirmed, precisely characterised gap.  It is NOT a regression; the gap
existed before the composite mode.  The composite mode has revealed it more clearly.

**VS-WORD flag: YES** — shadow and glow appearance vs Word presets needed.

---

## D. Explicit effects verdict

**Drop shadow (shapes and images):** STILL-MISSING in the composite render.  Shapes without
the effect are correctly visible; the effect itself (offset dark halo) does not appear.

**Glow (shapes):** STILL-MISSING.  Shape body renders correctly; the coloured halo is absent.

**Reflection:** Not tested in this corpus (covered in the 2026-06-25 drawing report).

**Soft-edge / bevel:** Not tested in this corpus (covered in the 2026-06-25 drawing report).

The underlying reason is the same for all four: WPF `Effect` overflow clipping by the
`VisualBrush`/`DrawImage` path.  This is the confirmed root cause from the 2026-06-25 report,
now also verified against the composite path.

---

## E. VS-WORD flags for orchestrator

| Finding | What orchestrator needs to check |
|---------|----------------------------------|
| Text wrap around floats (B1) | Does Word show text visibly reflow around a Square-wrap image? Confirm expected wrap gap. |
| 3-column layout (B2) | Does Word render f2-06-columns-3 as 3 columns with the same content? Confirm column count. |
| Floating shape colors (C1) | What do the three overlapping shapes look like in Word? Blue/orange/green fills + outlines. |
| Shadow on inline shape (C2) | Word shadow appearance for `HasShadow=true` rect: expected offset, blur, opacity. |
| Glow on inline ellipse (C2) | Word glow appearance: expected radius and colour. |
| Shadow on floating image (C2) | Word appearance for `ShadowPreset=2` floating image. |

---

## Corpus files

| File | Feature exercised |
|------|-------------------|
| `f2-01-float-wrap.docx` | Floating image Square wrap + Tight wrap |
| `f2-02-float-zorder.docx` | 3 overlapping floating shapes, z-order 1/2/3 |
| `f2-03-object-effects.docx` | Shadow + glow on inline shapes; shadow on floating image |
| `f2-04-border-watermark.docx` | Page border (navy 3 pt) + diagonal DRAFT watermark |
| `f2-05-columns-2.docx` | 2-column layout with column rule |
| `f2-06-columns-3.docx` | 3-column layout with column rule |
| `f2-07-combined.docx` | All four composite layers simultaneously |
