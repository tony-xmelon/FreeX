# Pivot Value Format Cells Seed

## Goal

Make the PivotTable Value Field Settings "Number Format..." path seed Format Cells with actual number-format codes instead of preset label strings.

## Decisions

- Extend `PivotValueNumberFormatPreset` with `FormatCode` so label-to-ID and label-to-code mappings stay in the same catalog.
- Keep raw `numFmtId` and custom-code handling unchanged; the new code mapping is only used when the nested Format Cells dialog needs an initial style.
- Preserve duplicate labels/aliases for compatibility while using the preset's concrete code for editor seeding.

## Verification

- Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "ResolvePresetNumberFormatCode_MapsExcelStylePresetLabels" -v minimal` failed to compile because the code mapper did not exist.
- Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "PivotValueFieldSettingsInputParserTests" -v minimal` passed 49 tests.
