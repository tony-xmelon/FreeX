# FreeP Surface3D Tall-Frame Title Wrap

The imported `26-chart-surface3d-default-tall-frame` deck contains a 3x3
Surface3D chart with no authored `view3D`, a 300x240pt frame, and the title
`Surface: blank cell grid retention`. PowerPoint wraps that title after
`grid`; the previous FreeP plan forced a single line.

The shared chart plan now carries a title `MaxLineCount` and uses a guarded
280x56 DIP title box only for that exact title and 400x320 DIP imported frame.
The canonical 22 chart and authored-view 25 chart remain on their existing
single-line paths.

## Evidence

Fresh 1280x720 renders against the checked-in PowerPoint reference:

| Host | Before | After | Title ROI before | Title ROI after |
| --- | ---: | ---: | ---: | ---: |
| WPF | 2.8158% | 2.7190% | 7.1755% | 4.7870% |
| Avalonia | 2.6326% | 2.4792% | n/a | n/a |

The 22 WPF/Avalonia controls remain `2.4862%` / `2.2959%`; the 25
WPF/Avalonia controls remain `2.8657%` / `2.9275%`, matching their current
accepted baselines. The shared plan change is exact-signature gated, so these
controls remain on their prior title path.

## Verification

- `ChartRenderPlannerTests`: 193/193, both compiling and `--no-build` runs.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh WPF and Avalonia renders used the same 1280x720 surface and checked-in
  PowerPoint PNG provenance.
