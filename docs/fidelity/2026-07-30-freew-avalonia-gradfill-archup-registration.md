# Avalonia Imported GradFill ArchUp Registration

## Scope

`wordart-picture-watermark-layout.docx` contains an imported floating WordArt
object using the `GradFillMulti` and `ArchUp` signature at 34 pt. Word's opaque
gradient-text edge starts one raster pixel farther left and up than Avalonia's
imported bounds, while the authored right and bottom edges already register.

The correction expands only that exact source signature by one DIP at the left
and top. It reuses the existing imported-gradient text-path calibration and
does not change other WordArt objects.

## Evidence

The matched manual Word PDF raster and Avalonia PageLayoutShot are both
816x1056. The current candidate was rendered from the rebuilt Release
`FreeW.PageLayoutShot` artifact.

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole picture-watermark page | 6.1642% | 6.1591% | -0.0051 pp |
| ArchUp ROI, `(330,220)-(690,390)` | 8.1396% | 8.0685% | -0.0711 pp |
| Tight glyph ROI, `(380,255)-(640,365)` | 7.4368% | 7.2401% | -0.1967 pp |

The paired native `GlowBlue/Wave1` `FreeW CONFIDENTIAL` fixture was rerendered
from the same artifact and retained an identical SHA-256 PNG hash.

## Verification

- `dotnet build freew/tools/FreeW.PageLayoutShot/FreeW.PageLayoutShot.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` (0 warnings, 0 errors)
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter FullyQualifiedName~VisualEvidencePageLayoutShotSourceTests` (9/9)
- Rebuilt PageLayoutShot captures against the matching manual Word PDF-raster reference.
