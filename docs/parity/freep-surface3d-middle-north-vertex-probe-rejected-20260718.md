# FreeP imported Surface3D middle-North vertex probe rejected

This probe tested the shared middle-row/North vertex in the imported 3-by-3
Surface3D mesh from `22-chart-baseline-depth.pptx`. The imported correction was
increased from `20` to `35` DIP downward, leaving facet colors, triangulation,
boundary faces, painter order, and all other chart families unchanged.

## Fresh matched COM evidence

Candidate and baseline used current Release artifacts, a fresh `1280x720`
PowerPoint COM export, and `composite/wpf-composite-renderer` provenance.

| ROI | Before | Candidate | Delta |
| --- | ---: | ---: | ---: |
| WPF whole page | 2.6185% | 2.6484% | +0.0299 pp |
| Surface `(560,90)-(1030,310)` | 5.2317% | 5.4980% | +0.2663 pp |
| Tight mesh `(590,105)-(980,300)` | 6.4325% | 6.7947% | +0.3622 pp |
| Blue/low fold `(590,190)-(790,290)` | 8.9799% | 10.0777% | +1.0978 pp |
| High band `(670,110)-(960,190)` | 6.6250% | 6.8658% | +0.2408 pp |
| Rear green `(780,125)-(970,270)` | 4.6507% | 4.6635% | +0.0128 pp |

Stock, scatter, and 100%-stacked chart controls were byte-stable. The probe
was rejected and reverted: the apparent blue-face vertical mismatch cannot be
corrected by moving this shared vertex without worsening the coupled mesh.

## Verification

- Focused chart/planner tests: 197 passed; 1 expected source-contract failure
  locked to the accepted `20` DIP correction.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh `--avalonia-compare` export completed with PowerPoint COM export 1/1.
