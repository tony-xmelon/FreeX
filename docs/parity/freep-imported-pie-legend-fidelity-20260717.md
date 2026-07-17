# FreeP imported pie legend fidelity

Date: 2026-07-17

## Finding

PowerPoint's imported pie and doughnut legends use 14x14 swatches, 37-pixel
row spacing, black text, and a wider right reservation for charts without data
labels. FreeP previously used 8x8 swatches, 28-pixel rows, gray text, and a
single legend offset. The shared planner now distinguishes the imported
pie/doughnut signature, and both renderers consume the resulting text color and
legend geometry.

## Evidence

Fresh 1280x720 renders against the persistent COM cache:

| Fixture | Backend | Whole page before | Whole page after | Legend ROI before | Legend ROI after |
| --- | --- | ---: | ---: | ---: | ---: |
| `19-chart-labels` slide 2 | WPF | 0.8051% | 0.7924% | 8.1858% | 7.2930% |
| `19-chart-labels` slide 2 | Avalonia | 0.8411% | 0.8102% | 7.7942% | 6.6706% |
| `18-chart-types` slide 1 | WPF | 0.6373% | 0.5831% | 6.0774% | 4.6223% |
| `18-chart-types` slide 1 | Avalonia | 0.6150% | 0.5557% | 5.8356% | 4.2946% |
| `06-charts` slide 3 | WPF | 0.6801% | 0.6260% | 6.0774% | 4.6223% |
| `06-charts` slide 3 | Avalonia | 0.6344% | 0.5751% | 5.8356% | 4.2946% |

The 19-pie body ROI moved by +0.0456 percentage points for WPF and +0.0275
for Avalonia, within the 0.10-point no-regression bound; all whole-page scores
improved.

## Verification

- Focused `ChartBaselineCorpusTests` and `ChartRenderPlannerTests`: 196/196.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh WPF and Avalonia renders completed at 1280x720.
