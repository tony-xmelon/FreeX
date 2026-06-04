# PivotTable Empty-Value Options UI

## Scope

Make the existing `PivotTableModel.EmptyValueText` feature editable through the PivotTable Options command surface.
The model and refresh renderer already support missing-intersection text; this slice wires the dialog and command path.

## Tasks

- [x] Add red host tests proving `PivotTableOptionsDialogResult` carries the empty-value text from manual creation and
  `PivotTableModel`.
- [x] Add red command test proving `ConfigurePivotTableOptionsCommand` updates the model, refreshes missing intersections,
  and restores previous rendered output on undo.
- [x] Thread the value through `PivotTableOptionsDialog`, `MainWindow.PivotCommands`, and
  `ConfigurePivotTableOptionsCommand`.
- [x] Document the command-owned mutation boundary in architecture and parity docs.

## Verification Log

- Red: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter "PivotTableOptionsDialog" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because `CreateResult` had no `emptyValueText` parameter and `PivotTableOptionsDialogResult` had no matching constructor.
- Red: `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --filter "ConfigurePivotTableOptionsCommand" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because `ConfigurePivotTableOptionsCommand` had no `emptyValueText` parameter.
- Green: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter "PivotTableOptionsDialog" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 6 tests.
- Green: `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --filter "ConfigurePivotTableOptionsCommand" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 2 tests.
