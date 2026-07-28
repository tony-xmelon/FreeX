# FreeW Highlight Avalonia Parity - Wave 47

## Resolved mismatch

WPF exposes text highlight as an explicit fourteen-color palette with a `No
Color` action. Avalonia previously registered only a top-level command, so it
could not select the same palette or intentionally clear a highlight. The
Avalonia Font ribbon now presents the WPF-equivalent colors and routes each
choice through the existing `DocumentView.SetHighlightColor` command path.

`No Color` clears the selected run's `HighlightColorHex`; named colors preserve
their exact RGB values. The change uses the existing shared editor operation,
retaining undo/redo and DOCX round-trip behavior.

## Validation

Builds:

`dotnet build freew/FreeW.Ribbon.Definitions/FreeW.Ribbon.Definitions.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`

`dotnet build freew/FreeW.App.Avalonia/FreeW.App.Avalonia.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`

`dotnet build freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`

Result: 0 warnings, 0 errors.

Focused tests:

`dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~ParagraphShadingParityTests" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`

Result: 8 passed, 0 failed, 0 skipped.

## Residual

The command parity covers the existing WPF palette. More elaborate highlight
patterns are model/package concerns and are not exposed by either host's ribbon.
