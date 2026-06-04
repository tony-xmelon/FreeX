# Pivot Accounting Format Presets

## Goal

Expose the accounting built-in number-format IDs already supported by PivotTable refresh in the Value Field Settings preset list.

## Decisions

- Keep the preset implementation host-local because labels are UI copy, while each preset's code still comes from `Core.Model.BuiltInNumberFormatCatalog`.
- Add selectable labels for built-ins 41, 42, and 43: no-symbol integer accounting, currency integer accounting, and no-symbol decimal accounting.
- Preserve `Accounting` as the existing decimal currency label for built-in 44.

## Verification

- Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~PivotValueFieldSettingsInputParserTests" -v minimal` failed 7 cases because the new accounting labels were absent.
- Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~PivotValueFieldSettingsInputParserTests" -v minimal` passed 64 tests.
