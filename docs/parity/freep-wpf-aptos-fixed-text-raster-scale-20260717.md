# FreeP WPF Aptos fixed-text raster scale - 2026-07-17

## Target

`tools/FreeP.RenderCompare/corpus/17-bullets-autofit.pptx`, rendered at
1280x720 and compared with the matching persistent PowerPoint COM PNGs.

## Change

The WPF text-box path now applies a renderer-local `0.95` horizontal raster
scale to text whose resolved font family is Aptos. The scale is centered for
center-aligned paragraphs and left-anchored for body text; layout measurement,
line breaks, vertical placement, and the shared model remain unchanged.

## Evidence

| Surface | Before | After | Delta |
| --- | ---: | ---: | ---: |
| Slide 1 whole-page control | 1.0803% | 1.0520% | -0.0284 pp |
| Slide 2 whole page | 3.5999% | 3.3067% | -0.2933 pp |
| Slide 2 text ROI `(60,95)-(560,590)` | 11.8697% | 11.2349% | -0.6348 pp |
| Slide 2 title ROI `(400,10)-(880,75)` | 12.1785% | 8.5514% | -3.6270 pp |
| Independent `08-effects.pptx` control | 1.5290% | 1.4827% | -0.0463 pp |

Slides 1 and 2 use the matching WPF composite path; the control deck uses the
same renderer and capture dimensions. The change is WPF-local; Avalonia and
shared planning are untouched.

## Verification

- `dotnet test freep\\FreeP.App.Host.Tests\\FreeP.App.Host.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~SlideCanvasTests"` - passed, 34 tests.
- `dotnet test freep\\FreeP.App.Presentation.Tests\\FreeP.App.Presentation.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~BulletsAutofitTests|FullyQualifiedName~TextLayoutPlannerTests"` - passed, 83 tests.
- `dotnet build tools\\FreeP.RenderCompare\\FreeP.RenderCompare.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - passed, 0 warnings, 0 errors.
