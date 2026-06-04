# Row Height Dialog Maximum Parity

## Goal

Align the Row Height dialog and row-height command validation with Excel's `409.5` maximum row height.

## Status

- [x] Update the Row Height dialog validation and warning text to accept values from `0` through `409.5`.
- [x] Update `SetRowHeightCommand` so dialog acceptance and command execution share the same Excel maximum.
- [x] Cover the dialog parser, generic worksheet-size parser, and command boundary with focused tests.

## Verification

- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "RowHeightDialog|WorksheetSizeInputParser" -v minimal`
- `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "SetRowHeightCommand" -v minimal`
