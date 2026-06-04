# Format Cells Number Live Preview

## Scope

Make the Format Cells Number tab sample preview use the same custom-number formatter as grid display when the dialog controls synthesize a format.

## Checklist

- [x] Add a failing dialog test for synthesized currency, percentage, and custom date previews.
- [x] Route preview rendering through `Core.Calc.NumberFormatter` with representative number/date/text values.
- [x] Preserve the existing number-format resolution and style-diff output behavior.
- [x] Update command parity and architecture documentation.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FormatCellsDialog_NumberTab_UpdatesSamplePreviewFromResolvedNumberFormat" -v minimal` failed because synthesized currency preview showed static `1234.56`.
- Green: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FormatCellsDialog_NumberTab_UpdatesSamplePreviewFromResolvedNumberFormat" -v minimal` passed 1 test.

## Architectural Decision

The Format Cells dialog must not maintain a separate custom-number preview implementation. It now delegates sample text to `NumberFormatter`, using representative values only to choose number/date/text input shape, so dialog previews stay aligned with grid rendering as formatter fidelity improves.
