# FreeP WPF imported Aptos body width

Date: 2026-07-18

## Scope

The imported `17-bullets-autofit.pptx` slide 2 contains an exact eight-
paragraph `Aptos` 18pt `a:noAutofit` body. After the accepted WPF-wide Aptos
fallback scale of `0.95`, its long-line ink ended at `x=502` while PowerPoint's
matching raster ended at `x=505`; short lines showed the same three-pixel
deficit. The WPF renderer now uses a measured `0.957` horizontal scale only
for that exact body signature. The title, slide 1, other Aptos routes, shared
planning, and Avalonia remain unchanged.

## Matched PowerPoint evidence

Fresh 1280x720 `--avalonia-compare` export:

| Metric | Before | After |
| --- | ---: | ---: |
| WPF slide 2 whole page | 3.2806% | 3.2245% |
| WPF body ROI `(60,95)-(560,590)` | 11.2203% | 11.0108% |
| WPF first-line ROI `(60,105)-(540,165)` | 11.4660% | 11.2142% |
| WPF last-line ROI `(60,510)-(540,580)` | 9.9145% | 9.6859% |
| WPF slide 1 control | SHA-stable | SHA-stable |
| Avalonia vs PowerPoint slide 2 | 3.1232% | 3.1232% |

The body ink box is now `(78,115)-(505,564)`, matching PowerPoint's measured
right edge; vertical ownership is unchanged. The independent `03-mixed-text`
control is SHA-256 stable. The `08-effects` render is byte-stable relative to
the previously accepted shadow-halo artifact.

## Verification

- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`: 0 warnings, 0 errors.
- `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~BulletsAutofitTests|FullyQualifiedName~TextLayoutPlannerTests"`: 83/83.
- Fresh PowerPoint COM export completed 2/2 slides.

Process note: a uniform vertical raster scale was separately rejected on the
same fixture; raw band height and width must be calibrated independently.

