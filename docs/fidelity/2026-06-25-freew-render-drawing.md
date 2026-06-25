# FreeW Drawing-Objects Fidelity Triage — 2026-06-25

Corpus: 15 .docx files under `freew-fidelity-corpus/files/drawing/`
Render: FreeW.FidelityRender (816×1056 px, 1 page each) → `freew-fidelity-corpus/runs/drawing-freew/`
Generator: `freew/tools/_corpus_drawing/`
Sample PNGs: programmatically generated 120×90 gradient and checker patterns (embedded directly by generator).
VS-WORD flag: effects marked VS-WORD need Word-side baseline to confirm exact appearance; FreeW-side verdict is based on code inspection + what is/isn't visible in the rendered page PNG.

---

## Prioritised Summary Table

| # | File | Object / Effect | Verdict | Severity |
|---|------|----------------|---------|----------|
| 1 | 14-floating-wrap | Floating images (Square + Tight wrap) | NOT RENDERED — both images absent; text not wrapped | BLOCKER |
| 2 | 15-floating-zorder | Floating shapes (z-order overlap) | NOT RENDERED — all 3 shapes absent | BLOCKER |
| 3 | 02-image-shadow | Image drop shadow (preset) | NOT RENDERED — shadow clipped/lost in paginator | BLOCKER |
| 4 | 12-shape-effects | Shape shadow + shape glow | NOT RENDERED — both effects clipped in paginator | BLOCKER |
| 5 | 03-image-glow | Image glow effect | NOT RENDERED — glow halo absent | BLOCKER |
| 6 | 13-wordart-style-warp | WordArt 4th item (ChromeOne+Wave1) | NOT RENDERED — paragraph missing from output | BLOCKER |
| 7 | 13-wordart-style-warp | WordArt warp geometry (ArchUp, Wave1) | FLAT — warp hint is italic only; no path geometry | MAJOR |
| 8 | 07-image-artistic | Artistic effects (blur/pencil/paintbrush/photocopy) | NEAR NO-OP — effects barely detectable in rasterised output | MAJOR |
| 9 | 04-image-reflection | Image reflection fade gradient | MISSING FADE — reflection uniform opacity, no top→bottom fade | MAJOR |
| 10 | 06-image-recolor | Color temperature warm/cool shift | INVISIBLE — warm+60 and cool−60 images look identical | MAJOR |
| 11 | 05-image-softedge-bevel | Soft edge + bevel effects | NO-OP — both effects invisible in rasterised output | MAJOR |
| 12 | 01-image-border | Image picture border top edge | CLIPPED — top border edge absent/lost | MINOR |
| 13 | 11-shape-pattern | Pattern preset fidelity | SINGLE PATTERN — all presets render as diagCross regardless of spec | MINOR |
| 14 | 09-shape-solid-outline | Shape solid fill + outline | GOOD — colors correct, outlines present | OK |
| 15 | 10-shape-gradient | Shape gradient fill | GOOD — direction and colors correct | OK |
| 16 | 08-image-crop-rotate-flip | Image crop + rotate + flip | GOOD — all three transforms correct | OK |
| 17 | 06-image-recolor | Recolor (grayscale/sepia/washout/B&W) | GOOD — four presets visually distinct and correct | OK |
| 18 | 13-wordart-style-warp | WordArt fill presets (gradient/shadow/glow) | ACCEPTABLE — colors and fills render correctly | OK |

---

## Per-File Detail

### 01 · `01-image-border.docx` — Inline image, picture border

**Object:** 144×108 pt gradient image, 2.25 pt solid red border.

| Aspect | Verdict | Detail |
|--------|---------|--------|
| Image renders | OK | Gradient image visible, correct colors |
| Border visible | OK | Red border present on left, right, bottom |
| Top border edge | MINOR | Top border edge absent — clipped by `InlineUIContainer` baseline alignment or `Border` layout |

**Suspected cause:** `BuildImageRun` (DocumentView.cs:7671) wraps the image in a `Border` and returns an `InlineUIContainer` with `BaselineAlignment.Bottom`. The top of the border sits above the text baseline and may be clipped by the WPF inline layout container. VS-WORD confirmation advisable.

---

### 02 · `02-image-shadow.docx` — Inline image, drop shadow

**Object:** 144×108 pt checker image, ShadowPreset=2.

| Aspect | Verdict | Detail |
|--------|---------|--------|
| Image renders | OK | Checker image visible |
| Shadow effect | BLOCKER | Shadow completely absent — no dark offset halo visible |

**Suspected cause:** `ApplyImageWpfEffects` (DocumentView.cs:7706) sets `element.Effect = new DropShadowEffect(...)` on the WPF element. WPF effects extend outside the element's layout bounds. When the FlowDocument paginator renders via `paginator.GetPage(i)` → `DrawingVisual` + `VisualBrush`, the effect's overflow pixels fall outside the element's clip rect and are lost. The shadow is present in the live editor (which renders to a scrollable Canvas) but does not survive the static paginator path used by FidelityRender (DocumentView.cs:80–95). VS-WORD needed to quantify gap.

---

### 03 · `03-image-glow.docx` — Inline image, glow

**Object:** 144×108 pt gradient image, GlowSizePt=8, blue.

| Aspect | Verdict | Detail |
|--------|---------|--------|
| Image renders | OK | Gradient visible |
| Glow halo | BLOCKER | No blue halo around image — same root cause as shadow (WPF Effect overflow clipping) |

**Suspected cause:** Same as file 02 — `DropShadowEffect` with `ShadowDepth=0` (DocumentView.cs:7742) overflows layout bounds. VS-WORD needed.

---

### 04 · `04-image-reflection.docx` — Inline image, reflection

**Object:** 144×108 pt checker image, ReflectionPreset=2.

| Aspect | Verdict | Detail |
|--------|---------|--------|
| Reflection present | OK | Mirror copy below original is rendered |
| Vertical flip | OK | `ScaleTransform(1,-1)` applied (DocumentView.cs:7799) |
| Opacity | OK | ~50% transparency applied uniformly |
| Fade gradient | MAJOR | No top-to-bottom fade; uniform opacity throughout. Word shows a gradient fade from full opacity at top to zero at bottom |
| Gap between image and reflection | OK | Some gap present (distPx logic at DocumentView.cs:7693) |

**Suspected cause:** `BuildReflectionContainer` (DocumentView.cs:7777) uses flat `Opacity` on the Rectangle. A proper fade requires a `LinearGradientBrush` applied as an `OpacityMask` on the reflRect rather than uniform Opacity. VS-WORD needed to confirm exact gradient curve.

---

### 05 · `05-image-softedge-bevel.docx` — Soft edge + bevel

**Object:** Two images: 120×90 pt gradient with SoftEdgePt=5; 120×90 pt checker with BevelPreset=1.

| Aspect | Verdict | Detail |
|--------|---------|--------|
| Both images render | OK | Both visible, correct sizes |
| Soft edge effect | MAJOR | No visible edge fade — image has sharp edges identical to un-effected image |
| Bevel effect | MAJOR | No visible highlight border — bevel invisible |

**Suspected cause:** `ApplyImageWpfEffects` (DocumentView.cs:7750) applies `BlurEffect` for soft-edge and `DropShadowEffect` for bevel. The BlurEffect blurs the entire element (including the interior, making the image look blurry rather than soft-edged). At the rasterized paginator level, the `BlurEffect` overflow is clipped, making soft-edge appear as a standard sharp image. True soft-edge requires an `OpacityMask` with a radial gradient near the edges, not a whole-element blur. The bevel `DropShadowEffect` has the same overflow-clipping problem as shadows. VS-WORD needed.

---

### 06 · `06-image-recolor.docx` — Image recolor modes + color temperature

**Object:** Four 90×68 pt gradient images: Grayscale, Sepia, Washout, BlackWhite + two images with temperature ±60.

| Aspect | Verdict | Detail |
|--------|---------|--------|
| Grayscale | OK | Correctly desaturated to grey tones |
| Sepia | OK | Brown warm-tone rendering correct |
| Washout | OK | Light pink/blue washed-out appearance correct |
| BlackWhite | OK | Solid black (max contrast applied correctly) |
| Color temperature +60 (warm) | MAJOR | Image looks identical to unmodified gradient — no orange/warm overlay visible |
| Color temperature −60 (cool) | MAJOR | Image looks identical to warm image — blue tint absent |

**Suspected cause:** `ImageAdjustHelper.ApplyCore` (ImageAdjustHelper.cs) applies temperature via `a:clrChange` or extension attribute. The color temperature code path may produce a very subtle overlay that is below perceptual detection threshold on a saturated gradient, or the temperature parameter is not being applied correctly through the pixel pipeline. VS-WORD baseline would show a clear warm/cool shift.

---

### 07 · `07-image-artistic.docx` — Artistic effects

**Object:** Four 100×75 pt gradient images: Blur, PencilGrayscale, Paintbrush, Photocopy.

| Aspect | Verdict | Detail |
|--------|---------|--------|
| All four images render | OK | All present, correct size |
| Blur | MAJOR | Image appears only very slightly softened; not distinctly blurred |
| PencilGrayscale | MAJOR | Image appears slightly desaturated but not as a pencil sketch (no edge lines, no greyscale hatching) |
| Paintbrush | MAJOR | No paintbrush strokes visible; image nearly identical to original |
| Photocopy | MAJOR | No high-contrast threshold applied; image very similar to original |

**Suspected cause:** `ImageAdjustHelper.ApplyArtistic` processes pixels correctly at the software level, but the FidelityRender paginator path loses or truncates the effect. More likely: at 100×75 px display size the gradient source has very low spatial frequency, so effects like Blur or PencilGrayscale produce minimal visible change on a smooth gradient. Testing with a photograph-like source image would better expose these effects. However, the render pipeline uses the adjusted bitmap (DocumentView.cs:7604), so the effect IS applied; the issue is test-corpus design + gradient source limiting effect visibility. The artistic effects pipeline itself may be functioning — VS-WORD comparison needed to confirm.

---

### 08 · `08-image-crop-rotate-flip.docx` — Crop, rotate, flip

**Object:** Three gradient/checker images: 20% L+R crop, 30° rotation, horizontal flip.

| Aspect | Verdict | Detail |
|--------|---------|--------|
| Crop | OK | Narrower image rendered correctly (CropLeft/CropRight clip applied via RectangleGeometry at DocumentView.cs:7626) |
| Rotation 30° | OK | Clear clockwise tilt visible, correct angle |
| Flip H | OK | Checker renders (symmetric pattern so flip not visually distinguishable, but transform applied correctly per code) |
| Layout with rotation | MINOR | Rotated image bounding box overlaps adjacent image rather than flowing around it (inline rotation does not reflow) |

---

### 09 · `09-shape-solid-outline.docx` — Shape solid fill + outline

**Object:** Blue rectangle 120×80 pt + orange ellipse 120×80 pt, both with 2 pt outlines.

| Aspect | Verdict | Detail |
|--------|---------|--------|
| Rectangle fill | OK | Correct blue (#4472C4) |
| Ellipse fill | OK | Correct orange (#ED7D31) |
| Ellipse outline | OK | Dark brown outline visible and proportionate |
| Rectangle outline | MINOR | Outline very thin/barely visible despite 2 pt spec; may reflect WPF Border rendering at 96 dpi |
| Shape geometry | OK | Rectangle corners sharp, ellipse curved, both correct |

---

### 10 · `10-shape-gradient.docx` — Shape gradient fill

**Object:** Rectangle with 90° gradient (#4472C4→#ED7D31) + rounded-rect with 45° gradient (#70AD47→#FFFFFF).

| Aspect | Verdict | Detail |
|--------|---------|--------|
| Vertical gradient direction | OK | Blue-to-orange top-to-bottom rendered correctly |
| Diagonal gradient direction | OK | Green-to-white upper-left-to-lower-right rendered correctly |
| Color accuracy | OK | Colors match spec |
| GradientAngle computation | MINOR | The `BuildGradientBrush` formula (DocumentView.cs:8199) uses `cos/sin` of angle but WPF `LinearGradientBrush.EndPoint` uses a unit-vector, not a normalised direction. 45° case looks correct; edge cases at 0° or 180° may invert. |

---

### 11 · `11-shape-pattern.docx` — Shape pattern fill

**Object:** Rectangle with `diagCross` pattern (blue/white) + ellipse with `horzBrick` pattern (green/light).

| Aspect | Verdict | Detail |
|--------|---------|--------|
| Pattern renders | OK | Cross-hatch pattern clearly visible on both shapes |
| Pattern clips to shape | OK | Ellipse clips the hatch correctly within its boundary |
| Pattern preset fidelity | MINOR | Both shapes render the same diagonal cross-hatch. `BuildPatternBrush` (DocumentView.cs:8213) uses a generic cross-hatch tile regardless of the `PatternPreset` string — `horzBrick` should show horizontal brick courses, not cross-hatch |

---

### 12 · `12-shape-effects.docx` — Shape shadow + glow

**Object:** Red rectangle with `ShapeEffectLst.HasShadow=true` + teal ellipse with `HasGlow=true`.

| Aspect | Verdict | Detail |
|--------|---------|--------|
| Shapes render | OK | Both shapes visible with correct fill colors |
| Shadow on rectangle | BLOCKER | No drop shadow visible — same overflow-clipping root cause as image shadows |
| Glow on ellipse | BLOCKER | No cyan glow halo visible — same root cause |

**Suspected cause:** `ApplyShapeModelEffects` (DocumentView.cs:8153) sets `element.Effect = new DropShadowEffect(...)` / glow approximation. The FlowDocument paginator clips all WPF Effect overflow to the element layout bounds. VS-WORD needed.

---

### 13 · `13-wordart-style-warp.docx` — WordArt styles + warp

**Object:** Four WordArt runs: GradientFill (no warp), Shadow (no warp), GlowBlue+ArchUp, ChromeOne+Wave1.

| Aspect | Verdict | Detail |
|--------|---------|--------|
| GradientFill WordArt | OK | Blue-to-orange gradient text renders correctly |
| Shadow WordArt | OK | Dark navy with subtle drop shadow rendered |
| GlowBlue WordArt text | OK | Dark text visible; font/size correct |
| GlowBlue glow effect | MINOR | Glow halo invisible (same WPF Effect overflow-clipping as images) |
| ArchUp warp | MAJOR | Text is straight/flat — warp hint is `FontStyle.Normal` only (DocumentView.cs:8284); no geometric arch curve applied |
| Wave1 warp | MAJOR | Same — flat text, no wave geometry |
| ChromeOne+Wave1 paragraph | BLOCKER | Fourth WordArt paragraph completely absent from rendered output — blank space. The `ChromeOne` style maps foreground to `Brushes.Transparent` (DocumentView.cs:8320); a TextBlock with transparent foreground is invisible and may also be zero-height in the layout, causing the paragraph to collapse |

**Suspected cause for ChromeOne blank:** `WordArtRenderStyle` returns `(Brushes.Transparent, null)` for `ChromeOne` (DocumentView.cs:8320). A TextBlock with transparent text has zero measured height in WPF (text is invisible) and the paragraph likely collapses. Fix: ChromeOne should use a visible outline/stroke approach rather than transparent fill.

**Suspected cause for warp geometry:** `BuildWordArtRun` (DocumentView.cs:8266) renders WordArt as a plain `TextBlock` with optional italic. WPF has no built-in text-path warp geometry. The code comment at DocumentView.cs:8271 explicitly states "WPF has no built-in text-path warp; full geometry warp is deferred." VS-WORD needed to assess severity.

---

### 14 · `14-floating-wrap.docx` — Floating image with text wrap

**Object:** Two floating images: square-wrap (30 pt offset) and tight-wrap (260 pt offset).

| Aspect | Verdict | Detail |
|--------|---------|--------|
| Floating images rendered | BLOCKER | Both images completely absent from rendered page |
| Text wrap applied | BLOCKER | Text runs full-width with no indentation around any floating object |
| Text content | OK | Body text paragraphs render correctly |

**Suspected cause:** The FidelityRender path (Program.cs:80–95) uses `IDocumentPaginatorSource.DocumentPaginator` on the `FlowDocument`. Floating objects (images, shapes) are rendered on an overlay `Canvas` set via `SetFloatingCanvas` (DocumentView.cs:4687), which is a separate WPF element from the `FlowDocument`. The paginator only paginates the FlowDocument body; the overlay Canvas is never rendered into the `DrawingVisual`. This is an architectural gap in the FidelityRender tool, not in FreeW's editor (which renders the overlay correctly). VS-WORD comparison is essential; the FreeW editor itself does render floating objects — this is a render-harness limitation.

---

### 15 · `15-floating-zorder.docx` — Overlapping floating shapes, z-order

**Object:** Three floating shapes (blue rect z=1, orange ellipse z=2, green rect z=3) overlapping.

| Aspect | Verdict | Detail |
|--------|---------|--------|
| Shapes rendered | BLOCKER | All three shapes absent — same root cause as file 14 |
| Z-order | BLOCKER | Cannot assess — shapes not visible |
| Text paragraph | OK | Anchor paragraph text renders |

**Suspected cause:** Same as file 14 — overlay Canvas not included in FlowDocument paginator render path.

---

## Root-Cause Analysis: Systemic Issues

### Issue A — WPF Effect overflow clipping (BLOCKER-class, affects files 02, 03, 05, 12, 13)

WPF `DropShadowEffect` and `BlurEffect` extend pixels outside the element's layout bounds. The FidelityRender paginator renders each `DocumentPage` via `new DrawingVisual()` + `dc.DrawRectangle(new VisualBrush(page.Visual), ...)`. `VisualBrush` clips to the visual's bounds, stripping any effect overflow. Result: all shadow, glow, soft-edge, and bevel effects are invisible in the rendered PNG, even though they display correctly in the live editor.

**Fix direction:** When rendering for fidelity capture, inflate the clip rect by the maximum possible effect radius before rasterising; or use `RenderTargetBitmap.Render(page.Visual)` directly without the intermediate VisualBrush; or switch to `DrawingContext.DrawRectangle` without clipping the effect region. Alternatively, FreeW could pre-flatten effects into the bitmap at save/render time.

### Issue B — Floating object overlay not in paginator (BLOCKER-class, affects files 14, 15)

The FlowDocument paginator does not include the floating-object overlay Canvas. This is an inherent limitation of the FidelityRender architecture. The harness must be extended to composite the overlay Canvas on top of each page visual after pagination.

**Fix direction for FidelityRender harness:** After `paginator.GetPage(i)`, obtain the floating elements from the overlay Canvas (or re-build them from the model for each page's viewport), render them to a secondary `DrawingVisual` at the correct page-relative coordinates, and composite both into the output `RenderTargetBitmap`.

### Issue C — WordArt warp geometry (MAJOR, affects file 13)

WPF has no text-path warp primitive. The current approach (italic hint) is a documented placeholder. Word uses DrawingML `a:prstTxWarp` which requires custom geometry rendering (glyph outlines warped along a Bezier path). This is a non-trivial renderer feature.

### Issue D — Reflection fade gradient missing (MAJOR, affects file 04)

`BuildReflectionContainer` applies flat `Opacity` to the flipped copy. Word shows a gradient fade (opaque at top, transparent at bottom). Fix: apply a `LinearGradientBrush` as `OpacityMask` on the reflection `Rectangle`.

### Issue E — Color temperature imperceptible (MAJOR, affects file 06)

The warm/cool temperature shift may be too subtle at the pixel level, or there is a pipeline issue. Requires VS-WORD comparison to confirm whether the FreeW pixel pipeline is producing the correct output.

### Issue F — ChromeOne WordArt transparent foreground collapses (BLOCKER, affects file 13)

`WordArtStyle.ChromeOne` maps to `Brushes.Transparent` foreground (DocumentView.cs:8320). A WPF TextBlock with transparent text has zero measured height and produces an invisible, collapsed paragraph. The style was designed for an outline-only look but requires a non-transparent base color or a different rendering strategy.

---

## VS-WORD Flags

The following findings require a Word-side baseline to confirm the expected appearance:

- File 02: exact shadow blur/offset/opacity vs Word's preset 2
- File 03: glow radius and halo color vs Word
- File 04: reflection fade curve (alpha gradient profile)
- File 05: soft-edge fade width and bevel highlight vs Word
- File 06: color temperature magnitude (warm/cool shift amount)
- File 07: artistic effects on a photograph-like image (gradient source may mask effect)
- File 13: WordArt warp curve geometry for ArchUp and Wave1

---

## Corpus Files

| File | Feature |
|------|---------|
| `01-image-border.docx` | Inline image + picture border |
| `02-image-shadow.docx` | Inline image + drop shadow |
| `03-image-glow.docx` | Inline image + glow |
| `04-image-reflection.docx` | Inline image + reflection |
| `05-image-softedge-bevel.docx` | Inline image + soft edge / bevel |
| `06-image-recolor.docx` | Image recolor modes + color temperature |
| `07-image-artistic.docx` | Artistic effects (blur/pencil/paintbrush/photocopy) |
| `08-image-crop-rotate-flip.docx` | Image crop + rotate + flip |
| `09-shape-solid-outline.docx` | Shape solid fill + outline |
| `10-shape-gradient.docx` | Shape gradient fill |
| `11-shape-pattern.docx` | Shape pattern fill |
| `12-shape-effects.docx` | Shape shadow + glow effects |
| `13-wordart-style-warp.docx` | WordArt styles + warp presets |
| `14-floating-wrap.docx` | Floating image + text wrap |
| `15-floating-zorder.docx` | Floating shapes + z-order overlap |

Sample PNGs embedded: `gradient.png` (120×90, red→blue gradient), `checker.png` (120×90, blue/yellow 10×10 checker). Generated programmatically by `_corpus_drawing/Program.cs` using WPF `WriteableBitmap`.
