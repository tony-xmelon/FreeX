# FreeW shared picture insertion parity — 2026-08-13

## Gap closed

WPF Insert Picture accepted SVG and normalized decoded pictures to PNG, while Avalonia excluded SVG,
retained the selected encoding, used a different longest-edge size cap, and did not populate original pixel
metadata used by Reset Size. Insert Icons also duplicated its 72-point sizing rule in both hosts.

## Shared contract

`PictureInsertionPlanner` now owns:

- the supported picture extensions and MIME types used by both file pickers;
- vector raster-surface sizing with aspect-ratio preservation;
- pixel-to-point conversion and the 400-point maximum width;
- PNG `InlineImage` construction and original pixel metadata;
- the 72-point icon insertion cap.

WPF and Avalonia retain only toolkit-specific file selection, decoding, vector drawing, and PNG encoding.
Both routes now insert the same shared model shape. Avalonia's explicit SVG raster surface also preserves
non-square view-box proportions rather than forcing every selected SVG through a square bitmap.

## Verification

- `dotnet test freew/FreeW.App.Presentation.Tests/FreeW.App.Presentation.Tests.csproj --configuration Release --logger "trx;LogFileName=picture-insertion-planner.trx"`
  - 1,445 passed, 0 failed.
- `dotnet build freew/FreeW.App.Avalonia/FreeW.App.Avalonia.csproj --configuration Release`
  - succeeded with 0 warnings and 0 errors.
- `dotnet build freew/FreeW.App.Host/FreeW.App.Host.csproj --configuration Release`
  - succeeded with 0 warnings and 0 errors.
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1`
  - passed.
- `dotnet build FreeX.slnx --configuration Release`
  - succeeded with 0 warnings and 0 errors.

`FreeX.DefaultTests.slnx` was also attempted because repository guidance labels it the non-UI lane. Its
current membership unexpectedly includes capture/startup projects: 22 result files completed before the
command timed out in `FreeX.App.Host.Logic.Tests`, with six unrelated existing failures. The two orphaned
owned test PIDs were terminated specifically. This broad run is not used as acceptance evidence, and no
explicit UI test solution or capture command was run.
