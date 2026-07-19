# FreeP imported Surface3D rear-green boundary refinement

Date: 2026-07-21
Branch: `codex/freep-parity-surface3d-shading-next-20260716`
Corpus: `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`

## Finding

The imported 3-by-3 Surface3D chart still under-filled the rear green
boundary facet. The authoritative fresh PowerPoint COM raster contained 1,161
exact `#8BAB74` pixels in the surface region, while the accepted FreeP render
contained 777. The facet's measured upper-middle vertex was one source of that
area error.

The imported boundary polygon now uses the normalized points `(201,72)`,
`(232,42)`, and `(306,33)`. The change is limited to the imported Surface3D
boundary-facet path; authored Surface3D charts and other chart families are
unchanged.

## Fresh matched COM evidence

PowerPoint exported the fixture successfully as one slide. The fresh COM
reference retained the expected current-corpus hash:

`162D9EB507140C2E9A593E84B1E0DD0C856208CB7968E8717284DC55671170E4`

| Backend / ROI | Before | After |
| --- | ---: | ---: |
| WPF whole page | `2.6212%` | `2.6199%` |
| WPF Surface `(560,90)-(1030,310)` | `5.2559%` | `5.2442%` |
| WPF tight mesh `(590,105)-(980,300)` | `6.4655%` | `6.4496%` |
| WPF rear-green `(780,125)-(970,270)` | `4.7416%` | `4.6978%` |
| Avalonia vs PowerPoint whole page | `2.3314%` | `2.3302%` |
| Avalonia Surface | `5.2018%` | `5.1916%` |
| Avalonia tight mesh | `6.4549%` | `6.4410%` |
| Avalonia rear-green | `4.5950%` | `4.5567%` |

The WPF exact `#8BAB74` mask increased from 777 to 853 pixels. The fresh
PowerPoint mask contained 1,161 pixels at `(797,139)-(896,174)`; the accepted
FreeP mask is `(801,139)-(896,174)`. Avalonia increased to 852 pixels.
Stock, scatter, and 100%-stacked chart crops changed zero pixels in both
backends.

## Probe discipline

- A one-unit upward back-frame-wall probe worsened WPF `2.6212% -> 2.6274%`
  and Avalonia-vs-PowerPoint `2.3314% -> 2.3385%`; it was reverted.
- A one-unit downward frame-wall probe worsened WPF to `2.6409%` and
  Avalonia-vs-PowerPoint to `2.3497%`; it was reverted.
- Moving the green facet's first vertex left improved the bbox but reduced
  the exact mask to 754 pixels; it was reverted.
- The accepted adjacent-vertex change improved both target ROI and whole page
  while leaving the three chart controls byte-stable.

Process rule: for imported 3-D charts, score exact facet masks and the local
rear/mesh ROI separately from frame-wall geometry. A visually plausible frame
calibration is not evidence for a facet change; keep the smallest polygon
ownership change that improves both backend ROIs and the whole-page metric.

## Verification

- `ChartBaselineCorpusTests|ChartRenderPlannerTests`: `197/197`
- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore`: `0` warnings, `0` errors
- Fresh Release `--avalonia-compare` completed with PowerPoint COM export `1/1`
- Renderer artifacts were rebuilt before all comparisons; the first stale
  Release probe was discarded before scoring.
