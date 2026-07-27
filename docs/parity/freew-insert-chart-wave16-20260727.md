# FreeW Insert Chart Parity Wave 16

Date: 2026-07-27

Scope: `insert-chart.initial`, `insert-chart.populated`, and `insert-chart.validation-error`, paired against the WPF dialog authority at 96 DPI. The capture set is target-only and does not change the shared cross-app dashboard.

## Implementation

- Reused `InsertChartDialogPlanner` for the initial state and result validation path.
- Matched the WPF dialog's 500px base width and compact dialog chrome.
- Changed the Avalonia layout to stacked labels and full-width chart type/title controls.
- Replaced the horizontal editor rows with a bordered, fixed-height data-grid-shaped surface using WPF colors, headers, cell metrics, and trailing blank grid area.
- Kept row editing functional; Enter on the last row adds a row, and Delete removes an empty row when more than one row exists.
- Kept the visible action contract to WPF's `OK` and `Cancel` buttons.

## Visual Metrics

| State | Before changed pixels | After changed pixels | Mean channel delta | Hash distance |
| --- | ---: | ---: | ---: | ---: |
| initial | 26.01% | 6.43% | 4.94 | 1 |
| populated | 26.01% | 6.43% | 4.94 | 1 |
| validation-error | 26.00% | 6.41% | 4.91 | 1 |

All six target manifest entries captured successfully, and all three Avalonia captures passed the nonblank and content gates at `560x600`.

## Verification

- `InsertChartDialogVisualParityTests`: 2/2
- `ChartMediaDialogPlannerTests`: 5/5
- `MediaDialogParitySourceTests`: 13/13
- Target-only WPF/Avalonia capture: 3/3 per host
- `git diff --check`: passed
- Remaining visual difference is primarily WPF versus Avalonia control-template and text-rasterization behavior; the report still classifies the rows as genuine visual mismatches rather than claiming exact equality.
