# Pivot Value Format Code To Built-In

## Goal

Keep Value Field Settings number formats as built-in IDs when the nested Format Cells editor returns a code that exactly matches a known built-in preset.

## Decisions

- Add code-to-built-in-ID resolution alongside the existing preset label-to-ID and label-to-code catalog.
- Use a `TryResolve...` API internally so General can be recognized as a built-in match even though its `numFmtId` is null.
- In `NumberFormatButton_Click`, store the built-in ID and clear the custom-code handoff for known codes; only unknown codes are promoted to the workbook custom number-format catalog path.

## Verification

- Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "ResolveBuiltInNumberFormatIdForCode_MapsKnownPresetCodes" -v minimal` failed to compile because the resolver did not exist.
- Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "ResolveBuiltInNumberFormatIdForCode_MapsKnownPresetCodes" -v minimal` passed 8 tests.
