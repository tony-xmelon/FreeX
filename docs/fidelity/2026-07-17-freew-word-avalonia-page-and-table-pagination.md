# FreeW Word Page Surface and Table Pagination

## Scope

The Word-capable machine produced a fresh visible-Word baseline from the generated fixture corpus at
`freew-fidelity-corpus/runs/word-baseline-evidence-20260717`. All 30 fixture DOCX files exported through
the visible Publish dialog; this note concerns the Avalonia comparison lane rather than DOCX open/export.

## Capture Normalization

`FreeW.PageLayoutShot` now crops the actual document surface for the additional generated fixture scenarios
that map to Word PNGs. The evidence therefore compares physical Word-sized pages instead of a large desktop
viewport against a page image. This removes false dimension mismatches from header/footer, review, field,
table, drawing, and backstage scenarios.

## Table Result

The `table-page-composition-stress` fixture exposed three renderer defects:

- Avalonia ignored `TableRowHeightRule.Exact` and sized rows from their wrapped text.
- Legacy built-in paragraph styles carried nonzero spacing without explicit-set flags, which the display
  cascade discarded even though Word applies it.
- `tblCellSpacing` was recorded in evidence but did not occupy visual or pagination space, and repeated
  headers relied on an estimate rather than the measured page break.

Avalonia now honors exact row boxes, applies legacy nonzero style spacing, accounts for vertical cell spacing
in the shared pagination estimate and renderer, and repeats a table header when measured layout moves a row
to another page. In the live Word baseline both engines now show two data rows on page 1 and header plus rows
3-6 on page 2; both report three pages for this fixture.

The strict PNG comparison remains outside tolerance because typography, watermark composition, and fine
table border/cell geometry still differ. The remaining delta is now a renderer-fidelity problem rather than
a capture-size or page-break problem.

## Watermark Interoperability Follow-up

The live Word probe exposed one additional DOCX-format defect in the table fixture: its VML
`fillcolor` and `v:fill/@color` values omitted the CSS `#` prefix. Word therefore interpreted the
configured gray text watermark as white (`Fill.ForeColor.RGB = 16777215`), making it nearly invisible
in the PDF, while FreeW rendered the model's intended gray. The writer now emits `#RRGGBB` VML colors.
A regenerated fixture reports Word's configured gray (`8355711`) through COM and produces a visible
watermark in the visible-publish PDF.

Avalonia also now uses the same fixed `468pt x 117pt` VML text-path box that FreeW writes, centered
relative to the page/margin frame, with Word's non-bold text effect and `fitshape`-style width fitting.
This removes the prior small bold-label approximation. The remaining strict raster delta still includes
header/body typography and table-cell vertical geometry, so this did not claim a full visual pass.

Picture watermarks need a different OOXML representation. Word did not reliably display the old VML
`v:fill` image watermark, and its VML image fallback ignored the model opacity. The writer now emits the
watermark image as a centered, behind-document DrawingML header anchor. It derives the image aspect ratio
from PNG, GIF, BMP, or JPEG bytes, applies the model scale with the same page-size bounds as the Avalonia
planner, and writes the requested opacity as `a:alphaModFix`. A fresh visible-Word PDF of
`wordart-picture-watermark-layout.docx` shows the translucent generated image behind the body text and
below the foreground WordArt. The strict whole-page channel delta improved from `38.564` to `36.851`;
remaining difference is dominated by the known renderer typography and pagination variance rather than a
missing or opaque DOCX watermark.

## Floating WordArt Calibration

The refreshed visible-Word corpus also isolated a renderer gap in the floating WordArt fixtures. Avalonia
had recorded glow metadata but never drew it for WordArt, and it used a single 80% text-width fit for every
DrawingML warp. Word uses a wider fill for the `Wave1` text path while retaining the narrower side margins
for `ArchUp` and straight text. Avalonia now draws the same two-pass blue/gold glow used for floating shapes
and uses a 94% text-box target only for `Wave1`; the existing 80% target remains for the other paths.

The fresh `wordart-watermark-stress` capture visibly matches Word's filled Wave1 label and halo more closely,
while `wordart-picture-watermark-layout` retains its correctly sized ArchUp label. The strict WordArt stress
channel delta improved from `25.553` to `25.441`; the whole-page comparator remains dominated by typography,
body flow, and other drawing differences.

## Verification

- `dotnet test freew\\FreeW.App.Presentation.Tests\\FreeW.App.Presentation.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~DocumentViewLayoutPlannerTests"`
  - 27 passed.
- `dotnet test freew\\FreeW.App.Avalonia.Tests\\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~DocumentViewTableStructureTests|FullyQualifiedName~VisualEvidencePageLayoutShotSourceTests"`
  - 34 passed.
- Re-ran `FreeW.PageLayoutShot` and `FreeW.VisualEvidenceSummary` against the fresh visible-Word PNG baseline.
  - The overall strict summary remains nonzero by design; this slice fixed structural pagination and preserved
    the remaining visual deltas for follow-up work.
- `WatermarkOptionsRoundTripTests`: 12 passed.
- Live Word COM probe of the regenerated `table-page-composition-stress.docx`:
  - `Fill.ForeColor.RGB = 8355711`, `Transparency = 0.7799988`, and `Text = TABLE REVIEW`.
- `TextWatermarkLayoutPlanner`: passed, plus the Avalonia table/evidence source lane (35 passed).
- `WatermarkOptionsRoundTripTests`: 12 passed, including the behind-document DrawingML anchor, calculated
  extent, centered alignment, and `alphaModFix` opacity assertions for a picture watermark.
- `VisualEvidenceDocxSchemaTests|WatermarkVisualPlanner`: 5 passed.
- Regenerated the 30-file corpus, exported `wordart-picture-watermark-layout.docx` through the running
  visible Word instance, and rasterized its PDF for the visual confirmation above.
- `DocumentViewFloatingFO3Tests`: 49 passed, including a headless capture proving `GlowBlue` WordArt paints
  the expected blue halo.
- Regenerated the Avalonia page-shot corpus and compared it against the fresh visible-Word 30-document PNG
  baseline after the floating WordArt calibration.
