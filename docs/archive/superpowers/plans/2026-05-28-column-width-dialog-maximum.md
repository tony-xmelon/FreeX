# Column Width Dialog Maximum Parity

## Goal

Align the Column Width dialog and column-width command validation with Excel's `255` maximum column width.

## Completed

- [x] Keep Column Width dialog validation and warning text on the inclusive Excel range from `0` through `255`.
- [x] Keep `SetColumnWidthCommand` rejecting values above `255` so dialog acceptance and command execution share the same maximum.
- [x] Add focused dialog coverage for negative, zero, maximum, oversized, and non-finite width input.

## Verification

- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~RemainingDialogTests.ColumnWidthDialog|FullyQualifiedName~WorksheetSizeInputParserTests" -v:minimal`

