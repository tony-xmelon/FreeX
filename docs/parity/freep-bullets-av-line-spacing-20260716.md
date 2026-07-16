# FreeP Avalonia bullet/autofit line spacing parity - 2026-07-16

## Target

`tools/FreeP.RenderCompare/corpus/17-bullets-autofit.pptx`, slides 1 and 2, compared with the checked-in PowerPoint exports at 1280x720.

## Change

Avalonia `FormattedText` now uses a calibrated PowerPoint paragraph line height of `1.18 * em` instead of Avalonia's automatic leading. The change is centralized in `SlideCanvas.ResolvePowerPointLineHeight` and applies to the existing Avalonia text-rendering path without changing the shared text model or WPF metrics.

## Evidence

| Backend | Slide 1 before | Slide 1 after | Slide 2 before | Slide 2 after |
| --- | ---: | ---: | ---: | ---: |
| WPF | 1.0779% | 1.0779% | 3.5904% | 3.5904% |
| Avalonia | 1.2726% | 1.1992% | 4.6622% | 3.8667% |

The final paired renders and heatmaps are retained under:

- `artifacts/freep-bullet-autofit-final-20260716/wpf/`
- `artifacts/freep-bullet-autofit-final-20260716/avalonia/`
- `artifacts/freep-bullet-autofit-final-20260716/wpf-diff-01.png`
- `artifacts/freep-bullet-autofit-final-20260716/wpf-diff-02.png`
- `artifacts/freep-bullet-autofit-final-20260716/avalonia-diff-01.png`
- `artifacts/freep-bullet-autofit-final-20260716/avalonia-diff-02.png`

## Verification

- `dotnet test freep\\FreeP.App.Rendering.Avalonia.Tests\\FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~SlideCanvasLineSpacingTests|FullyQualifiedName~SlideCanvasMathBaselineTests" --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - passed, 41 tests.
- `dotnet build tools\\FreeP.RenderCompare\\FreeP.RenderCompare.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - passed, 0 warnings, 0 errors.
- WPF and Avalonia renders were generated and diffed against the checked-in PowerPoint references at 1280x720.
