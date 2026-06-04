# Custom Number Indian Grouping

## Scope

- [x] Add deterministic LCID `4009` (`en-IN`) custom-number formatting.
- [x] Preserve visible rupee currency tokens.
- [x] Apply Indian grouping sizes for grouped number and percent output.
- [x] Keep OS locale services, localized currency names, and broader LCID coverage out of scope.

## Architectural Decision

`NumberFormatter` continues to use an internal table-driven locale catalog rather than OS culture lookup. The catalog now carries optional number-group-size metadata in addition to decimal, group, and date separators. This keeps rendering deterministic while allowing locales like `en-IN` to use `3,2` grouping without changing all existing Western-grouped LCIDs.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because `[$₹-4009]#,##0.00` rendered Western grouping as `₹1,234,567.89`.
- Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 45 tests.
