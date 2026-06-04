# PivotTable Cache Options UI

## Scope

Expose modeled PivotCache data options through PivotTable Options and make them undoable.

## Checklist

- [x] Add failing command coverage for updating and undoing `RefreshOnLoad` and `SaveData`.
- [x] Add failing dialog coverage for cache-backed defaults and result fields.
- [x] Thread PivotTable Options dialog results into `ConfigurePivotTableOptionsCommand`.
- [x] Keep cache options on `PivotCacheModel` instead of duplicating them onto `PivotTableModel`.
- [x] Update command parity and architecture documentation.

## Verification

- Red: `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "ConfigurePivotTableOptionsCommand_UpdatesPivotCacheDataOptionsAndUndoRestores" -v minimal` failed because `ConfigurePivotTableOptionsCommand` had no `refreshOnOpen` parameter.
- Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "PivotTableOptionsDialog_FromPivotTable_UsesConnectedCacheDataOptions|PivotTableOptionsDialog_CreateResult_CapturesModeledLayoutAndStyleSettings" -v minimal` failed because the dialog result did not expose cache data options.
- Green: `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "ConfigurePivotTableOptionsCommand_UpdatesPivotCacheDataOptionsAndUndoRestores" -v minimal` passed 1 test.
- Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "PivotTableOptionsDialog_FromPivotTable_UsesConnectedCacheDataOptions|PivotTableOptionsDialog_CreateResult_CapturesModeledLayoutAndStyleSettings" -v minimal` passed 2 tests.

## Architectural Decision

Pivot cache data options belong to `PivotCacheModel` because they round-trip as cache metadata in XLSX. `PivotTableOptionsDialog` reads the connected cache by `PivotTableModel.CacheId`, and the existing options command snapshots and updates cache flags with the rest of the PivotTable option mutation.
