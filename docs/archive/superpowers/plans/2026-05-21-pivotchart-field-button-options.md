# PivotChart Field Button Options

## Scope

Close the command-surface gap where PivotChart field-button visibility existed in the model/rendering layer but the
PivotChart Options command and dialog only exposed the master toggle.

## Tasks

- [x] Add red tests for per-button report-filter, axis-field, and value-field visibility in dialog result creation.
- [x] Add red tests for undoable command mutation of the per-button visibility flags.
- [x] Thread the per-button booleans through `PivotChartOptionsDialog`, `MainWindow.PivotCommands`, and
  `ConfigurePivotChartOptionsCommand`.
- [x] Update architecture and parity docs to document the command-owned mutation boundary.

## Verification Log

- Red: `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --filter "ConfigurePivotChartOptionsCommand" -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because `ConfigurePivotChartOptionsCommand` had no `showReportFilterButtons` parameter.
- Green: `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --filter "ConfigurePivotChartOptionsCommand" -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 2 tests.
- Green: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter "PivotChartOptionsDialog" -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 3 tests.
