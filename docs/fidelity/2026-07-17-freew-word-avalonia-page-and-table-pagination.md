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

The follow-up visible-Word probe found that the VML watermark anchor paragraph itself was part of the
remaining page-flow drift. The writer had placed it before real header content, which gave Word a leading
empty line; even after ordering it last and constraining it to one twip, Word still reserved a header line
for its separate paragraph. The writer now appends the VML or DrawingML watermark run to the final visible
header paragraph. Watermark-only headers retain a minimal one-twip anchor paragraph. The reader strips only
FreeW's recognized watermark run, so visible header text and ordinary header images survive the round trip.

A fresh visible-Word export confirms one header paragraph rather than two, keeps the watermark visible, and
moves the repeated table's page-2/page-3 first row from `90.6pt` to `84.6pt`. Avalonia also now aligns a
footer's line-box bottom, rather than its text origin, with `w:pgMar/@w:footer`. Against this corrected
Word baseline, the Avalonia mean channel deltas are `27.0948`, `32.9496`, and `25.7533` on pages 1-3. The
strict comparison remains intentionally failing for renderer typography and fine table geometry, not DOCX
header or watermark flow.

A follow-up COM inspection established the remaining header/footer renderer boundary precisely: Word reads
the fixture's `18pt` header/footer distances, `42pt` top/bottom margins, and the model-default `8pt`
paragraph after-spacing in both stories. Avalonia now applies `SpaceBefore`/`SpaceAfter` while flowing
header/footer paragraphs and anchors the entire footer story (including trailing spacing) at the configured
bottom distance. This makes multi-paragraph header/footer geometry and footer placement model-correct;
reserving the corresponding header collision extent for body pagination remains the next renderer task.

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

## Landscape Table Baseline

The Word baseline rasterizer had been forcing every PDF page into the dimensions of the first FreeW evidence
image. That stretched the landscape table fixture into a portrait PNG. It now accepts a width-only mode that
derives each PDF page height from its native aspect ratio; the baseline runner uses that mode, producing the
correct `816 x 528` Word surfaces for the table fixture.

The fixture is now explicitly three pages in its expected-output contract and Avalonia publishes page three.
A fresh visible-Word export confirmed that both engines place rows 7-8, the caption, and closing paragraph on
page three. `GridTable1Light` was also corrected to use Word's pale `#D9E2F3` header fill rather than the
incorrect saturated accent blue used by the on-screen catalog.

Finally, the DOCX reader recognizes the writer's generated `#D9E2F3` header and `#F2F2F2` band fills as
style-derived when reading a named table style. That keeps the serialized WPF evidence and direct Avalonia
evidence semantically aligned. The refreshed normalizer now reports only strict Word PNG deltas, rather than
an additional table-plan or fill-signature mismatch between the two FreeW renderers.

## Field Page Count Correction

The fresh full-corpus Word capture found that `field-page-number-variants.docx` is four pages, while the
shared evidence contract and Avalonia capture had been capped at three. WPF had already produced the fourth
page, so the capped Avalonia run emitted `NUMPAGES=3` and silently omitted the final even-page header/footer.

The field fixture now caches `NUMPAGES=4`, the shared scenario requires four outputs, the Avalonia shot
captures page four at the next document-surface offset, and the Word baseline planner captures up to four
pages per generated fixture. A regenerated DOCX exported through the running Word process as four PDF/PNG
pages. The focused normalizer now records eight matched Word comparisons (four WPF and four Avalonia) with no
missing-page or cross-renderer field-signature failure. Strict raster deltas remain, including `11.3028` for
Avalonia page four and `5.9292` for WPF page four, and remain renderer typography/layout follow-up work.

## WPF Page Border Calibration

The focused WordArt/picture-watermark comparison exposed a WPF evidence-capture conversion error: the page
border thickness converted points to DIPs twice. A `2.25pt` Word border was therefore painted as `4 DIP`
instead of the expected `3 DIP`. The capture path now uses the shared `PageLayout.PointsToDip` conversion and
also paints the inner stroke for the model's `Double` page-border style, matching the existing Avalonia
preview behavior.

The refreshed visible-Word comparison keeps the page-edge inset and two-stroke border visually aligned with
Word. Its whole-page mean channel delta for `wordart-picture-watermark-layout` improved from `18.2110` to
`17.4986`; it remains outside the strict threshold because body text, floating WordArt placement, and image
composition still differ at page scale. This is a renderer calibration change only, not a DOCX validity issue.

## WPF Explicit Header and Footer Distances

The table-composition fixture revealed a second WPF evidence-capture anchor error. When a document specified
`HeaderDistancePt` or `FooterDistancePt`, the capture compositor used the page margins instead of Word's
page-edge distance. Its page-one header therefore overprinted the title, and its footer was too close to the
bottom edge. The compositor now anchors explicit headers at `HeaderDistancePt` from the page top and reserves
the header/footer band above the configured footer distance; the existing margin-based fallback is retained
for implicit distances.

On the fresh visible-Word comparison for `table-page-composition-stress`, WPF mean channel deltas improved
from `23.0846`, `36.2661`, and `27.7128` to `21.3800`, `34.5094`, and `25.9561` across pages 1-3. The strict
comparison remains outside tolerance because the remaining table text, row height, and page-flow differences
are independent of the header/footer placement correction.

## WPF Multilevel Outline Indentation

The visible-Word field fixture showed that WPF's synthetic multilevel marker was using the default `ListItem`
gutter and did not inherit its heading run's colour and weight. The generated DOCX establishes the intended
numbering geometry explicitly: level zero is `720` twips left with `360` twips hanging, then each deeper level
adds `720` twips. WPF now collapses the unused built-in marker gutter, compensates for its retained `36 DIP`
content inset, and applies that hanging-indent geometry to each synthetic-marker paragraph. The marker also
inherits the leading run's font family, size, stretch, style, weight, and foreground.

On `field-page-number-variants` page one, the first blue heading pixel now lands at `x=121` in both Word and
WPF. The whole-page mean channel delta improved from `26.6138` to `26.4073`; the remaining page-scale
difference is largely body typography and line-flow outside the corrected list heading.

## Verification

- `dotnet test freew\\FreeW.App.Presentation.Tests\\FreeW.App.Presentation.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~DocumentViewLayoutPlannerTests"`
  - 27 passed.
- `dotnet test freew\\FreeW.App.Avalonia.Tests\\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~DocumentViewTableStructureTests|FullyQualifiedName~VisualEvidencePageLayoutShotSourceTests"`
  - 34 passed.
- Re-ran `FreeW.PageLayoutShot` and `FreeW.VisualEvidenceSummary` against the fresh visible-Word PNG baseline.
  - The overall strict summary remains nonzero by design; this slice fixed structural pagination and preserved
    the remaining visual deltas for follow-up work.
- `WatermarkOptionsRoundTripTests`: 12 passed.
- `WatermarkOptionsRoundTripTests`: 13 passed after the anchor-order/one-twip regression guard.
- `WatermarkOptionsRoundTripTests`: 14 passed after the inline-anchor and picture-watermark header-content
  regression guards.
- `DocumentViewHeaderFooterTests`: 11 passed, including footer line-box anchoring.
- `DocumentViewHeaderFooterTests`: 13 passed after header/footer paragraph spacing and trailing-footer
  extent coverage.
- Live Word COM probe of the regenerated `table-page-composition-stress.docx`:
  - `Fill.ForeColor.RGB = 8355711`, `Transparency = 0.7799988`, and `Text = TABLE REVIEW`.
  - Default header paragraph count is `1`; repeated table rows begin at `84.6pt` on pages 2 and 3.
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
- `VisualEvidencePlannerTests`: 122 passed after the four-page field contract update.
- `VisualEvidencePageLayoutShotSourceTests`: 4 passed, including the page-four capture guard.
- Rebuilt `FreeW.PageLayoutShot`, regenerated the focused fixture, and exported
  `field-page-number-variants.docx` through the running visible Word process: 4 PDF/PNG pages.
- `VisualEvidenceFidelityRenderSourceTests|FidelityRenderCompositeTests`: 11 passed after the WPF point-to-DIP
  and double-border guards.
- Regenerated `wordart-picture-watermark-layout` through `FreeW.FidelityRender` and compared it with the
  existing visible-Word PNG baseline: mean channel delta `17.4986` (strict comparison remains expected to
  fail for the known typography and drawing differences).
- `VisualEvidenceFidelityRenderSourceTests`: 2 passed after the explicit header/footer page-edge-distance
  guards; `FreeW.FidelityRender` rebuilt successfully.
- Regenerated `table-page-composition-stress` through `FreeW.FidelityRender` and compared all three pages
  with the existing visible-Word PNG baseline: `21.3800`, `34.5094`, and `25.9561` mean channel deltas.
- `MultiLevelMarkerTests`: 12 passed, including the Word outline hanging-indent and marker-style regression
  guard; `FreeW.FidelityRender` rebuilt successfully.
- Regenerated the four-page `field-page-number-variants` fixture through `FreeW.FidelityRender`: its page-one
  first blue heading pixel matched Word at `x=121`, and its mean channel delta was `26.4073`.
