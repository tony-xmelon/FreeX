# Custom Number Commonwealth LCIDs

## Goal

Expand the deterministic custom-number LCID separator catalog for common missing English/French-Canadian locales without introducing runtime OS-culture dependency.

## Scope

- [x] Add visible regression coverage for French Canada `C0C` and South Africa `1C09`.
- [x] Add catalog entries for `809` (en-GB), `C09` (en-AU), `C0C` (fr-CA), `1409` (en-NZ), `1809` (en-IE), and `1C09` (en-ZA).
- [x] Preserve the existing table-driven `LocaleFormatCatalog` architecture.
- [x] Keep localized currency/accounting names and exact Excel accounting layout widths out of scope.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` failed because `C0C` and `1C09` rendered with invariant separators.
- Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` passed 63 tests.
