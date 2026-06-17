# Chart data-label emoji rendered in color (Budget-v-Actual)

Date: 2026-06-18
Branch: `worktree-agent-a3bdf33ef671763ee`
Scope: CHART data-label rendering only (no form-control code touched).

## Gap

The Budget-v-Actual chart (`ExcelExamples1.xlsx` sheet **Budget v Actual**) renders
deviation bars plus "Value From Cells" percent data labels that lead with a 👍 / 👎 / 👌
emoji (Excel `c15:datalabelsRange`). Those emoji rendered as **monochrome** flat
black/gray silhouettes, while Excel shows them as **colored** (its classic
yellow/amber "hand" emoji).

Ground truth: `C:\Users\anton\AppData\Local\Temp\gaps-gt\bva_1.png` (yellow/orange thumbs + OK hands).

## Root cause

Charts render through `ChartRenderer.Render` → OxyPlot `PngExporter` (OxyPlot.Wpf 2.2.0).
Data labels were added as OxyPlot `TextAnnotation`s. OxyPlot.Wpf draws annotation **text**
through a monochrome `GlyphRun` path, so any emoji on that path comes out as a flat
single-color glyph.

### Why true color-font rendering was NOT used

The obvious fix — render the emoji with WPF `FormattedText` + the color font
"Segoe UI Emoji" and composite it — does **not** work. WPF's text stack never adopted
DirectWrite color-glyph (COLR/CPAL) rendering. A direct `DrawText` of 👍 with Segoe UI
Emoji into a `RenderTargetBitmap` comes out **fully monochrome** (verified by probe:
max per-pixel channel spread = 0). So true color-font rendering is impractical on the
WPF path FreeX uses. (This matches the task's documented contingency.)

## Approach used: faithful colored vector approximation

New `src/FreeX.App.UI/ChartEmojiGlyphs.cs`:

- `SplitLeadingEmoji` / `SplitLeadingDrawableEmoji` — peel a leading emoji run off a label,
  absorbing variation selectors / ZWJ / skin-tone modifiers. `SplitLeadingDrawableEmoji`
  only diverts the run when **every** emoji in it is one we can color (👍 U+1F44D,
  👎 U+1F44E, 👌 U+1F44C); anything else stays on the text path so unknown emoji are never
  half-colored or dropped.
- `RenderEmojiPng` — draws each known emoji as a small **amber/yellow vector glyph**
  (matching Excel's yellow-hand palette) to a transparent-background PNG via WPF
  `DrawingVisual` / `RenderTargetBitmap`, cached by (run, pixel size):
  - 👍 thumbs-up: amber rounded fist + thumb capsule pointing up
  - 👎 thumbs-down: same, flipped vertically
  - 👌 OK hand: orange ring (thumb-index) + three amber finger bars

`src/FreeX.App.UI/ChartRenderer.DeviationOverlay.cs` (`AddRangeDataLabelAnnotations`):

- Each label is split. When it leads with a drawable emoji, the emoji is added as an
  OxyPlot **`ImageAnnotation`** (`OxyImage` from the PNG) positioned at the category top,
  and the percent remainder is a `TextAnnotation` offset to its right (screen-unit offset),
  centering the "👍 30%" group over the category like Excel.
- OxyPlot draws `ImageAnnotation` via WPF `DrawImage`, which **preserves color**.
- No drawable emoji (or render failure) → the original single `TextAnnotation` path is kept
  unchanged, so no other chart's labels regress.

## Before / after

- **Before** (`bva-before/freex/Budget_v_Actual_01.png`): tiny monochrome black/gray thumb
  glyphs above each bar; percent text fine.
- **After** (`bva-after/freex/Budget_v_Actual_01.png`): the glyphs render in **amber/orange
  color** (thumbs-up/down amber, OK hand = orange ring + amber fingers) above each category,
  with percent text intact to the right — matching Excel's colored-emoji intent in `bva_1.png`.

The glyph shapes are a simplified colored approximation, not pixel-identical to Segoe UI
Emoji artwork, but they are genuinely colored and recognizable as hand/thumb marks.

## Tests

`tests/FreeX.App.UI.Tests/ChartEmojiGlyphsTests.cs`:
- `SplitLeadingEmoji` / `SplitLeadingDrawableEmoji` cases (peel emoji, absorb variation
  selector, no-emoji passthrough, non-drawable emoji left intact).
- `RenderEmojiPng_ProducesNonEmptyColorBitmap` — decodes the PNG and asserts it contains a
  meaningfully colored (non-gray) pixel, i.e. it is NOT monochrome.

Existing `ChartRendererTests.DeviationOverlay` (range-label text still present) and the full
App.UI suite continue to pass.

## Files changed

- `src/FreeX.App.UI/ChartEmojiGlyphs.cs` (new)
- `src/FreeX.App.UI/ChartRenderer.DeviationOverlay.cs`
- `tests/FreeX.App.UI.Tests/ChartEmojiGlyphsTests.cs` (new)

## Deferred / notes

- Only 👍 👎 👌 have colored drawings (the emoji this chart and Excel's thumbs idiom use).
  Other emoji remain on the monochrome text path. Adding more is a matter of extending the
  `IsDrawableEmoji` switch + a `DrawGlyph` case.
- A future option, if WPF ever gains color-glyph support or a Skia exporter is adopted, is to
  swap the vector approximation for true font glyphs without changing the split/annotation wiring.
