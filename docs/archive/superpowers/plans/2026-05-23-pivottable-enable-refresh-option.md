# PivotTable Enable Refresh Option

## Goal

Expose the already-modeled `PivotCacheModel.EnableRefresh` flag through PivotTable Options so cache refresh enablement is editable, undoable, and consistent with the existing XLSX load/save path.

## Scope

- Add an `EnableRefresh` result value and checkbox to `PivotTableOptionsDialog`.
- Thread the option through `MainWindow.PivotCommands` into `ConfigurePivotTableOptionsCommand`.
- Let the command update and undo `PivotCacheModel.EnableRefresh` alongside refresh-on-open and save-source-data.
- Reuse existing XLSX cache-definition read/write support for `enableRefresh`.

## Verification

- `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~ConfigurePivotTableOptionsCommand_UpdatesPivotCacheDataOptionsAndUndoRestores" -v minimal` passed 1 test.
- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~PivotTableOptionsDialog_CreateResult_CapturesModeledLayoutAndStyleSettings|FullyQualifiedName~PivotTableOptionsDialog_FromPivotTable_UsesConnectedCacheDataOptions|FullyQualifiedName~PivotTableOptionsDialog_UsesExcelStyleTabbedOptionShell|FullyQualifiedName~PivotTableOptionsDialog_ExposesAccessKeysForModeledCheckboxes|FullyQualifiedName~PivotTableOptionsDialog_ResultIncludesPrintingAndAltText" -v minimal` passed 5 tests.
