# FreeP imported Surface3D blue boundary registration

Date: 2026-07-17

## Finding

The imported `22-chart-baseline-depth.pptx` Surface3D blue boundary face was
too narrow and slightly too far right in both renderers. The shared planner
now uses the measured local polygon `(144,167), (172,121), (234,153)` for that
face. The projected frame, authored Surface3D charts, and other boundary faces
are unchanged.

## Evidence

At 1280x720 against the persistent matching COM export:

| Metric | WPF before | WPF after | Avalonia before | Avalonia after |
| --- | ---: | ---: | ---: | ---: |
| Surface ROI `(512,60)-(1024,330)` | 5.7119% | 5.6866% | 4.9145% | 4.8883% |
| Near-left mesh ROI `(610,180)-(760,300)` | 9.1677% | 9.0846% | 9.1571% | 9.0776% |
| Whole page | 2.6557% | 2.6519% | 2.3629% | 2.3590% |

The adjacent frame and label ROIs remained stable or improved. A follow-up
vertical move to `y=170` matched the COM blue bounds exactly but worsened both
Surface ROIs, so the accepted point remains `y=167`.

## Verification

- Focused `ChartBaselineCorpusTests` and `ChartRenderPlannerTests`: 196/196.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh WPF and Avalonia renders completed at 1280x720.
