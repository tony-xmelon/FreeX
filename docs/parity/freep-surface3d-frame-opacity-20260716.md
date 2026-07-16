# FreeP imported Surface3D frame opacity - 2026-07-16

## Scope

The imported `Surface3D` chart in `22-chart-baseline-depth.pptx` uses a light
projected frame behind its opaque facets. FreeP was drawing that frame with the
authored-surface opacity (`alpha 220`), making the frame nearly black in both
renderers. The imported path now uses `alpha 48`; authored Surface3D keeps
`alpha 220`.

## Evidence

PowerPoint COM reference pixels on the imported frame measured around `#9F`
to `#BF`, while the prior FreeP frame was around `#2B`. The retained imported
frame remains visible, but its opacity is aligned with the reference instead of
removing the frame altogether.

| Backend | Before | After |
| --- | ---: | ---: |
| WPF | 4.3367% | 4.2669% |
| Avalonia | 4.2562% | 4.1944% |

The comparison used the local PowerPoint COM export at 1280x720. Candidate
renders are retained under:

- `artifacts/freep-chart-baseline-depth-frame48-20260716/wpf/`
- `artifacts/freep-chart-baseline-depth-frame48-20260716/avalonia/`

## Verification

- The imported corpus planner test asserts frame alpha `48`.
- The authored-surface planner test asserts the existing frame alpha `220`.
- `dotnet build tools\\FreeP.RenderCompare\\FreeP.RenderCompare.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` passed with 0 warnings and 0 errors.
- WPF and Avalonia renders were compared against the PowerPoint COM export at 1280x720.
