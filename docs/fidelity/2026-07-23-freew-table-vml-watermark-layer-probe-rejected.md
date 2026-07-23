# FreeW table VML watermark layer probe rejected (2026-07-23)

## Scope

`table-page-composition-stress.docx` has a text VML watermark that Word paints above opaque table
cell fills and below the table glyphs. The existing WPF page compositor paints the watermark before
the FlowDocument body, so opaque cells erase it.

The probe replaced only planned, filled WPF table-cell backgrounds with a clipped local drawing:
cell fill first, then the existing page-space text watermark geometry, then the ordinary FlowDocument
cell text. Picture watermarks, unplanned tables, transparent cells, and all non-table content remained
on their previous paths.

## Matched evidence

The consuming `FreeW.FidelityRender` Release artifact was rebuilt and rendered the three-page fixture
against the unchanged 816x528 Word COM PNGs. The focused physical-segment host test passed before the
render.

| Page | Baseline whole page | Candidate whole page | Baseline table ROI | Candidate table ROI |
| --- | ---: | ---: | ---: | ---: |
| 1 | 7.1167% | 7.1256% | 9.0062% | 9.0185% |
| 2 | 9.1889% | 9.1848% | 11.9054% | 11.8997% |
| 3 | 7.0188% | 7.0054% | 8.9062% | 8.8876% |

The local layer order was correct, but WPF's reusable text-path geometry remained substantially smaller
than Word's visible VML `TABLE REVIEW` glyph path. It only added a small central fragment of the
watermark to the cells. Page 1 and its table ROI regressed, so the candidate was reverted.

A second probe consumed imported `fitshape="t"` metadata and removed the historical half-scale only
for the width-constrained `TABLE REVIEW` run. It also regressed every affected page: page 1 7.1167% to
7.1479%, page 2 9.1889% to 9.2400%, and page 3 7.0188% to 7.0529%. The larger fragments still did not
match Word's path registration, so width-vs-height fitting alone is not a sufficient VML text-path model.

## Conclusion

The remaining defect is not safely solved by compositing alone. A future slice must first model or
rasterize Word's VML text-path geometry at the visible Word footprint, then apply it at the isolated
fill-to-glyph sublayer. Do not reorder the full document body or overlay a post-body watermark, because
either approach violates Word's table glyph ownership.
