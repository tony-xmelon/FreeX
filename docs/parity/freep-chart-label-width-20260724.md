# FreeP chart label width parity, 2026-07-24

## Scope

The imported `19-chart-labels.pptx` corpus uses PowerPoint chart style 2, imported text metrics, and value labels on the clustered column charts. PowerPoint's bar faces are one DIP wider than the generic FreeP primitive calculation, which left a narrow white strip beside each labeled bar.

The planner now preserves the full computed series slot only for that exact signature: style 2, imported text metrics, `ColumnClustered`, and non-null data labels. Generic charts, unlabeled charts, combo charts, and other chart families keep their existing geometry.

## Evidence

Fresh 1280x720 comparison against PowerPoint COM:

| Slide | WPF before | WPF after | Avalonia after |
| --- | ---: | ---: | ---: |
| 1 | 1.5195% | 1.3784% | 0.5416% |
| 2 | 0.6240% | 0.6240% | 0.4838% |
| 3 | 1.6685% | 1.6479% | 0.8015% |
| Mean | 1.2707% | 1.2168% | 0.6090% |

The PowerPoint export completed 3/3 slides. Slide 2 and the non-column chart route remained unchanged. The focused planner contract `BuildColumnPrimitives_ImportedLabeledStyle2ColumnsUseFullSeriesSlot` protects the ownership guard.

## Verification

- RenderCompare Release build: 0 warnings, 0 errors.
- Focused chart planner tests: 8/8 `ChartLabelsCorpus` tests, including the WPF grid hint contract.
- Focused WPF host chart tests: 2/2 `ChartGridLinePen` tests.

## Follow-up Grid Raster Slice, 2026-07-23

The planner already carried the correct imported `#898989` grid stroke and
half-pixel geometry. WPF's stroked `DrawingContext.DrawLine` rasterized most
of those rows as blended gray bands, while PowerPoint emitted solid one-pixel
rows. The exact labeled-column signature now uses a WPF-only one-pixel filled
band for horizontal grid lines; Avalonia and all other chart routes retain the
shared line primitive.

Fresh 1280x720 comparison against PowerPoint COM:

| Slide | Before | After | Change |
| --- | ---: | ---: | ---: |
| 1 | 1.3784% | 1.3504% | -0.0280 pp |
| 2 | 0.6240% | 0.6240% | 0.0000 pp |
| 3 | 1.6479% | 1.5106% | -0.1373 pp |
| Mean | 1.2168% | 1.1616% | -0.0552 pp |

The PowerPoint export completed 3/3 slides. A fresh Avalonia companion render
was unchanged by the WPF-only flag (0.6646%, 0.4838%, 0.9511%). Current-main
control renders for `18-chart-types` and `22-chart-baseline-depth` were
byte-identical to the candidate.
