# PivotTable Style Gallery Fidelity

## Goal

Improve PivotTable command parity for style selection without implementing the full Excel PivotStyle theme/style XML engine.

## Scope

- [x] Expose the built-in `PivotStyleLight1..28`, `PivotStyleMedium1..28`, and `PivotStyleDark1..28` names in the PivotTable Options style picker.
- [x] Preserve a workbook's current authored/custom style name when it is outside the built-in list, so opening and accepting options does not fall back to `PivotStyleLight16`.
- [x] Add an explicit modeled renderer palette for `PivotStyleMedium2`, which was already offered by the dialog but previously rendered through the generic medium fallback.
- [x] Keep exact full-gallery theme/style semantics out of scope.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~PivotTableOptionsDialog_ExposesBroaderPivotStyleGalleryAndPreservesCurrentStyle" -v normal` failed with the four-style picker missing `PivotStyleMedium10` and `PivotStyleDark7`.
- Red: `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~PivotTableRefreshServiceTests.Refresh_MapsAdditionalBuiltInPivotStyleFamilies" -v minimal` failed because `PivotStyleMedium2` used the generic medium palette.
- Green: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~PivotTableOptionsDialog_ExposesBroaderPivotStyleGalleryAndPreservesCurrentStyle" -v minimal` passed 1 test.
- Green: `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~PivotTableRefreshServiceTests.Refresh_MapsAdditionalBuiltInPivotStyleFamilies" -v minimal` passed 5 tests.
