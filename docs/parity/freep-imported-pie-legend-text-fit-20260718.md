# FreeP imported pie legend text fit - 2026-07-18

## Scope

The earlier imported pie/doughnut legend slice aligned PowerPoint's 14x14
swatches and 37-DIP row spacing, but the legend glyphs still rendered lower
and narrower. This slice keeps the swatch plan unchanged and applies a
text-only imported-pie label fit shared by WPF and Avalonia.

## Change

Imported pie/doughnut legend labels now use the measured PowerPoint label
offset, Arial fallback, and 1.07 horizontal text scale. The scale is carried
on `ChartTextPlan` and applied only while drawing the matching legend label;
all other chart labels and all non-pie legends retain the default scale.

## Evidence

Fresh 1280x720 PowerPoint COM comparisons:

| Fixture / slide | Backend | Prior current baseline | Candidate |
| --- | --- | ---: | ---: |
| `19-chart-labels` / 2 | WPF | 0.7785% | 0.6895% |
| `19-chart-labels` / 2 | Avalonia | 0.8102% | 0.6709% |
| `18-chart-types` / 1 | WPF | 0.5831% | 0.5004% |
| `18-chart-types` / 1 | Avalonia | 0.5557% | 0.4610% |
| `06-charts` / 3 | WPF | 0.6260% | 0.5543% |
| `06-charts` / 3 | Avalonia | 0.5751% | 0.4805% |

On `19-chart-labels` slide 2, the exact swatch bboxes remain aligned at
`(1090,341)-(1102,354)`, `(1090,378)-(1102,391)`,
`(1090,415)-(1102,428)`, and `(1090,452)-(1102,465)`. The first-row black
label ink moved from WPF `(1113,345)-(1205,360)` to
`(1112,340)-(1211,355)`, against PowerPoint `(1111,339)-(1209,354)`.

Non-pie legend routes and unrelated chart geometry are unchanged by the
signature guard.

## Verification

- `ChartBaselineCorpusTests` + `ChartRenderPlannerTests`: 198/198
- `SlideCanvasTests`: 34/34
- WPF, Avalonia, and RenderCompare Release builds: 0 warnings, 0 errors
- Fresh COM exports completed for all 3/3 slides of `19-chart-labels`, 4/4
  slides of `18-chart-types`, and 4/4 slides of `06-charts`.
