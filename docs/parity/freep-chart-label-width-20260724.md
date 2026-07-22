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
- Focused chart planner tests: pending final integration verification.
