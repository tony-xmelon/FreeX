# FreeP imported combo secondary-axis minor ticks

Date: 2026-07-17

## Scope

The imported `19-chart-labels.pptx` combo chart uses a secondary value axis from
0 to 8000 with 1000-unit labels and four unlabeled minor intervals between each
major interval. FreeP previously emitted only the nine labeled major ticks.

The shared chart plan now emits the four intermediate secondary-axis ticks for
each imported combo interval. WPF and Avalonia consume the same renderer-neutral
plan.

## Evidence

At 1280x720 against a fresh PowerPoint COM export:

| Metric | Before | After |
| --- | ---: | ---: |
| WPF slide 3 | 1.8223% | 1.8217% |
| WPF deck average | 1.3774% | 1.3772% |
| Avalonia slide 3 | 0.8604% | 0.8609% |
| Avalonia deck average | 0.6014% | 0.6016% |

The unrelated `22-chart-baseline-depth.pptx` control remained at WPF
`2.9887%`.

## Verification

- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore` passed with 0 warnings and 0 errors.
- `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --no-build --filter FullyQualifiedName~ChartBaselineCorpusTests` passed: 23 tests.
- `git diff --check` passed.
