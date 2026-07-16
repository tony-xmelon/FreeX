# FreeW / Word scatter-marker parity

Date: 2026-07-16

## Scope

This pass compares the marker-only scatter chart in the shared `chart-smartart-complex`
fixture through the live Word COM export and FreeW's chart writer. The fixture uses
four differently shaped and coloured markers with no intended connecting line.

## Word evidence

- Input: `freew-fidelity-corpus/runs/smartart-hierarchy-next-20260716/fixtures-production-final/chart-smartart-complex.docx`
- PDF: `freew-fidelity-corpus/runs/smartart-hierarchy-next-20260716/word-pdf-production-final/chart-smartart-complex.pdf`
- PNG: `freew-fidelity-corpus/runs/smartart-hierarchy-next-20260716/word-png-production-final/chart-smartart-complex_p1.png`

## Finding and fix

Word rendered a connector line even when the chart had `c:scatterStyle val="marker"`
and the series `c:spPr/a:ln/a:noFill` was present. A temporary package probe established
that Word also requires `c:dPt/c:spPr/a:ln/a:noFill` on every per-point shape property.

FreeW now writes both levels for scatter charts:

- the series line is explicitly disabled in `BuildScatterSeries`;
- each palette-driven `c:dPt` line is explicitly disabled in `BuildDataPointProperties`.

The fresh Word PNG shows four independent markers with no connecting line. The generated
package contains four `c:dPt` elements and four matching per-point `a:noFill` elements.

The live Style 4 scatter baseline also has a clean white plot area and reserves a slightly
wider value-axis band than the generic Cartesian layout. FreeW now suppresses gridlines for
that scatter style and uses the measured scatter plot-left reserve.

## Verification

- `ChartRoundTripTests.ScatterChart_EmitsScatterChartWithXValAndYVal`: passed.
- `ChartRoundTripTests`: 23/23 passed.
- Fresh visible Word COM export: passed; 2-page PDF produced.
- PDF rasterization: passed; 2 PNG pages produced at 1020x1320 input raster size.
