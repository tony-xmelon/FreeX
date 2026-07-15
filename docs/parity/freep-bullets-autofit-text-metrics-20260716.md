# FreeP bullet text metrics parity - 2026-07-16

## Target

`tools/FreeP.RenderCompare/corpus/17-bullets-autofit.pptx`, slide 2, compared with the checked-in PowerPoint export at 1280x720.

The body is a fixed-size standalone text box with `a:noAutofit`, eight paragraphs, inherited 18pt body text, and no stored shrink scale. The correction must therefore change measurement metrics only; it must not apply runtime shrink.

## Change

WPF now uses `TextFormattingMode.Ideal` for regular paragraphs in `TextAutoFitKind.None` bodies. Bold paragraphs and `normAutofit` / `spAutoFit` bodies retain the existing `Display` mode. This keeps title and autofit behavior stable while matching PowerPoint's vector text wrapping more closely for fixed text boxes.

The change is in `freep/FreeP.App.Rendering.Wpf/SlideCanvas.cs` and does not alter the shared text model or the Avalonia renderer.

## Evidence

| Backend | Slide 1 control | Slide 2 target |
| --- | ---: | ---: |
| WPF before | 1.0779% | 3.7008% |
| WPF after | 1.0779% | 3.5904% |
| Avalonia control | 1.2726% | 4.6622% |

Retained artifacts:

- `artifacts/freep-bullet-text-metrics-20260716/final/wpf/slide-01.png`
- `artifacts/freep-bullet-text-metrics-20260716/final/wpf/slide-02.png`
- `artifacts/freep-bullet-text-metrics-20260716/final/avalonia/slide-01.png`
- `artifacts/freep-bullet-text-metrics-20260716/final/avalonia/slide-02.png`
- `artifacts/freep-bullet-text-metrics-20260716/final/wpf-slide-02-heatmap.png`

## Verification

- `dotnet build tools\\FreeP.RenderCompare\\FreeP.RenderCompare.csproj --configuration Release --no-restore` - passed, 0 warnings, 0 errors.
- `dotnet test freep\\FreeP.App.Presentation.Tests\\FreeP.App.Presentation.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~BulletsAutofitTests|FullyQualifiedName~TextLayoutPlannerTests" --logger "console;verbosity=minimal"` - passed, 82 tests.
- WPF and Avalonia renders were generated at 1280x720 and diffed against the checked-in PowerPoint references.
