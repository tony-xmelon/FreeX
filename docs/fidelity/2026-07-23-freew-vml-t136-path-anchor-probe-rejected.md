# FreeW VML `t136` path-anchor probe rejected (2026-07-23)

## Scope

`f2-border-watermark.docx` uses Word's native VML `_x0000_t136` text-path
prototype for its diagonal `DRAFT` watermark. The current WPF renderer centers a
small ordinary glyph run. Raw Word pixels showed that its visible watermark has
a substantially larger footprint and a lower-left path-oriented center.

The probe raised the existing VML glyph scale from `0.50` to `1.70` and moved the
shared plan `-100` DIPs X and `+70` DIPs Y. This deliberately tested the narrow
hypothesis that the residual was a centered-text versus path-anchor mismatch.

## Matched evidence

The consuming `FreeW.FidelityRender` Release artifact was rebuilt and rendered
the unchanged 816 by 1056 Word PNG baseline.

| Metric | Baseline | Candidate |
| --- | ---: | ---: |
| Whole page | 3.9108% | 4.2706% |
| Watermark ROI `(120,280)-(620,800)` | 7.2604% | 8.1723% |
| Exact `#CCCCCC` watermark pixels | 1,602 | 23,375 |

The candidate did move its exact-color centroid from `(404,531)` toward Word's
`(298,613)` (candidate `(289,618)`), but the glyph fill became far denser than
Word's 9,038 exact-color pixels. Product code was reverted and the renderer was
rebuilt to the accepted state.

## Conclusion

Matching the `_x0000_t136` path anchor does not make ordinary WPF glyph geometry
equivalent to Word's VML text-path raster. Do not retry uniform glyph-scale plus
translation calibration. A future renderer slice needs a glyph-outline deformation
or text-path raster model and must gate target ROI plus whole-page evidence.
