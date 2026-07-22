# Imported Default Chart Category Legend

## Scope

`drawing-objects-complex.docx` contains the imported default single-series
column chart `Quarterly revenue`. Its serialized chart payload has no explicit
style, quick layout, per-point colours, or theme colour scheme. Word renders
the legend as four category entries, not the single series entry `Revenue`.

## Measured Word Contract

At the matched 816x1056 composite capture, the legend has 8px keys at page
X positions 453, 488, 523, and 558. The keys are 35px apart and use the
effective Word palette `#000000`, `#2F5496`, `#1F3864`, `#FFC000`.

The shared chart scene now recognizes only the exact imported payload:

- column, 210x126pt, title `Quarterly revenue`
- one `Revenue` series with values 1.2, 1.7, 1.4, 2.1
- categories `Q1` through `Q4`
- no style, no quick layout, no colour-scheme metadata
- visible legend and axis titles `Quarter` / `USD`

It uses the measured four-category legend with 9-DIP keys, 35-DIP entry
spacing, and the Word palette. Other default charts and Style 7/8 category
legend behavior remain on their existing routes.

## Matched Evidence

Persistent Word baseline:
`C:\Users\ali\AppData\Local\Temp\FreeW-WordBaselineSurfaceRefresh-20260717`

Fresh WPF Release composite result:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 6.4636% | 6.4490% | -0.0145 pp |
| Chart | 8.1235% | 7.8726% | -0.2509 pp |
| Plot | 9.5162% | 9.2781% | -0.2381 pp |
| Legend | 6.4252% | 4.9426% | -1.4826 pp |
| Title | 15.8492% | 15.8492% | stable |
| Body | 10.4785% | 10.4785% | stable |

The changed candidate has 1,046 pixels relative to the accepted prior WPF
PNG. The independent `f2-01-float-wrap`, `object-format-position-size-style`,
and `wordart-watermark-stress` controls are SHA-256 byte-identical.

## Verification

- `ChartSmartArtVisualPlannerTests`: 43/43 passed.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Fresh `drawing-objects-complex` WPF composite used the same 816x1056 Word
  baseline and rendered provenance as the accepted prior registration slice.

## Process Note

The initial category-legend probe was not sufficient because it preserved the
generic spacing and palette. Treat category count, key geometry, label offset,
and palette as one visual owner; accept only when the target legend plus chart
and whole-page gates improve and unrelated controls remain byte-stable.
