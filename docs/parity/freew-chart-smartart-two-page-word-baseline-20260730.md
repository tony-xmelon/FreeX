# Chart and SmartArt Two-Page Word Baseline

## Scope

`chart-smartart-complex.docx` naturally paginates to two physical pages in Word.
Page 1 contains the chart and hierarchy SmartArt; page 2 contains the Basic Pyramid
and the concluding paragraph.

The earlier Avalonia PageLayoutShot route captured only page 1. This was an evidence
coverage gap, not a missing pyramid-rendering path.

## Provenance

- Fixture SHA-256: `27B713C819480F4C15DD90DDD13EF3CAB39A705D2E6B6DE3A631D81D53C19B9D`
- Word COM export: `freew-fidelity-corpus/runs/chart-smartart-word-baseline-20260730/word`
- Avalonia capture: `freew-fidelity-corpus/runs/chart-smartart-word-baseline-20260730/avalonia-paged-20260730b`
- Raster dimensions: `816x1056` for every compared page.

The Word COM wrapper opened the fixture read-only, staged a short PDF path under
`C:\Temp`, rasterized the PDF, deleted the staging PDF, then closed the document and
quit its owned Word process.

## Current Matched Results

| Page | WPF vs Word | Avalonia vs Word |
| --- | ---: | ---: |
| 1 | 2.3898% | 4.2274% |
| 2 | 1.0987% | 2.0918% |

Both host captures include the Basic Pyramid and final paragraph on page 2. Remaining
visual work is therefore geometry/raster fidelity, not page omission.

## Guard

`chart-smartart-complex` now requires two visual-evidence outputs for both hosts, and
PageLayoutShot emits `chart-smartart-complex_p1.png` and
`chart-smartart-complex_p2.png`. This prevents page-1-only evidence from being treated
as sufficient coverage for the pyramid fixture.
