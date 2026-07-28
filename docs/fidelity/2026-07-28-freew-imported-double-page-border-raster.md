# Imported Double Page-Border Raster Fidelity

## Scope

The matched Word reference for `table-page-composition-stress.docx` uses an imported
`w:pgBorders` double frame: `w:sz=12`, `w:space=24`, color `#24536B`, and
`w:offsetFrom="page"`. Word paints two two-pixel strokes at the 24-point page inset.

FreeW already used the right source color, width, and page-relative inset, but placed the
second WPF stroke only `4/3` of the authored width inward. Fractional WPF coverage collapsed
that second stroke toward the first one.

## Change

The WPF fidelity compositor now offsets the second double-frame stroke by exactly two
authored border widths. This keeps the initial page-edge stroke unchanged and places the
second stroke at the Word-matched raster band.

## Matched Word Evidence

Reference: manually exported Word PDF rasterized at 96 DPI to 816x528, from
`freew-fidelity-corpus/runs/current-chart-word-baseline-20260715/fixtures/f2/table-page-composition-stress.docx`.

| Page | Whole page before | Whole page after | Frame ROI before | Frame ROI after |
| --- | ---: | ---: | ---: | ---: |
| 1 | 8.0325% | 7.0339% | 9.3806% | 8.2144% |
| 2 | 9.9092% | 8.9106% | 11.5723% | 10.4062% |
| 3 | 7.6605% | 6.6619% | 8.9462% | 7.7801% |

The candidate changes 9,525-9,527 pixels per page, all in frame bands. The interior
`(50,50)-(765,480)` is pixel-identical on all three pages.

## Verification

- `FreeW.FidelityRender` Release build completed with 0 warnings and 0 errors.
- The focused composite and visual-evidence source tests assert the shared 24-point
  page inset and two-width double-frame spacing.

## Guard

Keep this calibration limited to `BorderLineStyle.Double`. A single border uses its authored
width directly; do not apply the second-stroke offset to other line styles.
