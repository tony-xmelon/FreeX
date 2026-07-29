# Avalonia Review Copy ArchUp Registration

## Scope

The `wordart-watermark-stress.docx` fixture contains a floating `Review Copy`
WordArt object using the FillGold and ArchUp signature. This change is restricted
to that exact imported object: 25-27 pt text, FillGold style, and ArchUp warp.

## Evidence

The cached matching Word raster is 816x1056. Before this adjustment, the dark
glyph mask was too far right and low, and it was wider than Word's visible
lettering. The accepted Avalonia calibration translates the warped text by
`(-24, -19)` DIPs and fits the glyph run to 64 percent of its rect width.

| Metric | Before | After |
| --- | ---: | ---: |
| Whole page mean RGB difference | 5.0188% | 4.9885% |
| Review Copy ROI, (430,350)-(710,440) | 3.8619% | 2.8242% |

The independent `wordart-picture-watermark-layout.docx` control was re-rendered
with the consuming Release artifact and retained the same SHA-256:
`4F6A48CFBD568A5BDED52B71AA929A2640D58F423920CC6DB839EBDDE2CAFAE7`.

## Rejected Probe

Scaling the same glyphs vertically by 1.35 increased the whole-page difference
from 4.9885% to 4.9934% and the Review Copy ROI from 2.8242% to 2.9944%.
The accepted slice therefore preserves the existing vertical text path model.

## Verification

- `dotnet build freew/tools/FreeW.PageLayoutShot/FreeW.PageLayoutShot.csproj --configuration Release`
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~DocumentViewFloatingFO3Tests"`
- The same focused test with `--no-build`: 46 passed.
