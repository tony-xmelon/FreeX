# Built-In Number Format Catalog

## Goal

Remove duplicate built-in number-format mappings from the PivotTable refresh path and Value Field Settings dialog so a built-in `numFmtId` resolves to one canonical format code everywhere.

## Decisions

- Put common Excel built-in number-format IDs in `Core.Model.BuiltInNumberFormatCatalog`, because the catalog is model data shared by command refresh, UI presets, and future IO paths.
- Keep the host dialog's current canonical values for the recently added presets, including `$#,##0.00` for built-in 7 and `m/d/yy` for built-in 14.
- Keep duplicate label aliases, such as Date and Short Date, in the host preset list only; the shared catalog stores IDs and codes, not UI labels.
- Preserve custom PivotTable number-format lookup through `Workbook.NumberFormatCatalog` for `numFmtId >= 164`.

## Verification

- Red: `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "BuiltInNumberFormatCatalogTests" -v minimal` failed to compile because `BuiltInNumberFormatCatalog` did not exist.
- Green: `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "BuiltInNumberFormatCatalogTests|PivotTableRefreshServiceTests" -v minimal` passed 80 tests.
