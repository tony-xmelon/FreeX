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
