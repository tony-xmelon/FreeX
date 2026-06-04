# Pivot Value Number Format Plan

- [x] Identify value-field number format application as a model-backed PivotTable fidelity gap.
- [x] Add a failing refresh test proving materialized value cells keep `NumberFormatId` while visual PivotStyles remain applied.
- [x] Resolve supported built-in Excel `numFmtId` values to `CellStyle.NumberFormat` codes.
- [x] Route generated PivotTable value cells through a formatter-aware write helper.
- [x] Preserve existing value number formats when applying PivotTable visual styles.
- [x] Add built-in Accounting/Comma mapping for `numFmtId` values 41-44 after spec review.
- [x] Update parity docs and architecture notes.
- [ ] Run final verification, review, commit, merge, and sync.

## Verification

- `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal --filter "FullyQualifiedName~PivotTableRefreshServiceTests.Refresh_AppliesValueFieldNumberFormatToMaterializedValueCells"` - failed before implementation because value cells remained `General`.
- `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal --filter "FullyQualifiedName~PivotTableRefreshServiceTests.Refresh_AppliesValueFieldNumberFormatToMaterializedValueCells"` - 1 passed.
- `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal --filter "FullyQualifiedName~PivotTableRefreshServiceTests.Refresh_MapsAccountingBuiltInValueFieldNumberFormats"` - 4 passed.
- `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal --filter "FullyQualifiedName~PivotTableRefreshServiceTests|FullyQualifiedName~PivotTableCommandTests"` - 93 passed.

## Review Notes

- Spec review finding: common built-in Accounting/Comma `numFmtId` values 41-44 were not mapped. Added focused coverage and mapped them to the existing bounded accounting format subset.
