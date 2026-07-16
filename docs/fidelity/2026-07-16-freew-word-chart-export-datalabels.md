# FreeW Word Chart Export Data Labels - 2026-07-16

## Finding

The `chart-smartart-complex` fixture requested Chart Style 7 and Quick Layout
9. FreeW rendered the requested plot fill and data labels from its model, but
the DOCX writer only persisted those choices in a FreeW extension. Word
therefore rendered a white plot and omitted the labels.

## Fix

The chart writer now emits standard DrawingML for the requested appearance:

- `c:dLbls` with value-only label switches when the selected style/layout
  requests data labels;
- explicit `c:plotArea/c:spPr` light-blue fill for filled chart styles;
- the existing single-series Word-style category legend is mirrored by the
  shared FreeW chart scene for styles 7 and 8.

## Word proof

A fresh fixture was generated, opened in the running Word process, published
through the visible Word PDF path, and rasterized at `816x1056`. Word now shows
the light-blue plot and value-only labels (`1.4`, `1.8`, `1.6`, `2.2`), matching
FreeW's chart scene. The remaining measured delta is plot-area geometry: Word
uses a narrower, shorter plot region when both axis titles and the legend are
present. That is the next chart-renderer target.

## Verification

- `ChartRoundTripTests`: 23/23
- `ChartSmartArtVisualPlannerTests`: 38/38
- fresh visible Word export: 1/1

## Renderer follow-up

The shared chart scene now follows the Word baseline's compact plot layout when
axis titles are visible, positions the category title and legend in the same
annotation band, and uses the resolved major unit for value-axis labels. The
scatter scene also pads its numeric category axis and emits minor/major axis
geometry from the Word-shaped range, including the small intermediate scatter
axis ticks.

Inline object paragraphs in the WPF host keep their caption text with the
chart, SmartArt, WordArt, or image when the object crosses a page boundary. In
the refreshed `chart-smartart-complex` proof, the page means against Word are
`6.50` (chart page) and `3.05` (pyramid page); the pyramid caption and bands
now begin together on page 2.

Additional verification:

- `ChartSmartArtVisualPlannerTests`: 40/40
- `ChartRenderingTests`: 18/18

## Follow-up: standard palette and Word-sized columns

The next live Word comparison found two remaining chart-page deltas. FreeW's
single-series columns occupied about 80% of each category slot while Word used
about 40%, and Word ignored the FreeW-only colour-scheme extension. The shared
chart scene now uses the Word-sized 30% category inset. The writer also emits
standard `c:ser/c:spPr` or per-point `c:dPt` colour overrides, with the series
property elements ordered before the category/value caches so Word's chart and
SmartArt parts remain stable across repeated visible-publish exports.

A fresh COM export from the current fixture is retained under
`freew-fidelity-corpus/runs/word-orgchart-render-next-20260716-orgchart/`.
Against the matching FreeW page, page 1 improved from mean channel delta
`6.50` to `5.72`; page 2 remained `3.05`. Repeated Word exports consistently
render the four pyramid bands, and the chart page now preserves the selected
mono-blue per-category palette.
