# FreeP Wave174 Surface3D shared facet parity

Date: 2026-08-22

## Scope

This slice promotes the existing measured alternate Surface3D facet plan to a
shared WPF/Avalonia render path. The scene now names the collection
`AlternateRenderFacets`, and both `ChartRenderExecutionProfile.Wpf` and
`ChartRenderExecutionProfile.Avalonia` select it when it is available. No new
chart signature, renderer-specific coordinate, comparison threshold, or
PowerPoint reference was added.

The change covers the tracked 1280x720 PowerPoint references for:

- `22-chart-baseline-depth`, slide 1
- `25-chart-surface3d-view3d`, slide 1
- `26-chart-surface3d-default-tall-frame`, slide 1

## Evidence

The rows below were rendered with the existing `FreeP.RenderCompare`
`--freep-render` and `--avalonia-render` modes and compared with the checked-in
references under `tools/FreeP.RenderCompare/corpus/pptx-ref`.

| Deck | WPF before | WPF after | Avalonia before | Avalonia after | Avalonia improvement |
| --- | ---: | ---: | ---: | ---: | ---: |
| `22-chart-baseline-depth` | 2.3911% | 2.3911% | 2.2482% | 2.1353% | -0.1129 pp |
| `25-chart-surface3d-view3d` | 2.7438% | 2.7438% | 2.9238% | 2.6220% | -0.3018 pp |
| `26-chart-surface3d-default-tall-frame` | 2.4757% | 2.4757% | 2.2991% | 2.2723% | -0.0268 pp |

The WPF rows are byte-stable because WPF already selected this alternate
facet plan. The Avalonia improvement is shared scene/command planning: both
platforms now consume the same measured facet ownership and paint ordering.

## Verification

- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -p:BuildInParallel=false /nr:false -m:1`: passed, 0 warnings, 0 errors.
- `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~ChartRenderCommandPlannerTests|FullyQualifiedName~ChartBaselineCorpusTests" --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -p:BuildInParallel=false /nr:false -m:1`: passed, 40/40.
- Final six 1280x720 WPF/Avalonia renders and six PowerPoint-reference diffs: all completed with exit code 0 and matching dimensions.
- Generated evidence root: `artifacts/freep-wave174-surface3d-20260822`.

## Remaining gap

The measured alternate facet plan is still derived from the three imported
Surface3D cases above. Other camera angles, mesh sizes, blank-cell patterns,
and chart styles continue to use the generic shared projection and need
independent PowerPoint evidence before further promotion.
