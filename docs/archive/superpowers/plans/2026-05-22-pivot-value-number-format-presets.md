# Pivot Value Number Format Presets

## Goal

Close a small PivotTable fidelity gap by making the Value Field Settings number-format preset catalog closer to Excel's built-in `numFmtId` surface while preserving custom-code editing and raw ID overrides.

## Decisions

- Keep `PivotValueFieldSettingsInputParser.NumberFormatPresets` as the single host catalog for the dialog combo box and label-to-ID resolution.
- Add common built-in IDs for integer/decimal number formats, comma and red-negative variants, currency/accounting, date/time, elapsed-time, percentage, fraction, scientific, and text formats.
- Preserve `Short Date` as the canonical label for built-in ID 14 by keeping it before the duplicate `Date` alias.

## Verification

- Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "PivotValueFieldSettingsInputParserTests" -v minimal` failed for the newly expected labels and ID mappings.
- Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "PivotValueFieldSettingsInputParserTests" -v minimal` passed 40 tests.
