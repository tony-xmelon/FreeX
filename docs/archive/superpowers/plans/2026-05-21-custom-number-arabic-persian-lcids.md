# Custom Number Arabic/Persian LCIDs

## Scope

Expand deterministic custom-number LCID separator coverage for Arabic, Persian, Urdu, Pashto, and Kurdish-Arabic locale tokens.

## Checklist

- [x] Add failing formatter coverage for Persian decimal slash, Pashto comma/period reversal, and Moroccan Arabic date hyphen behavior.
- [x] Add static separator mappings for `401`, `C01`, `3801`, `1801`, `429`, `420`, `463`, and `492`.
- [x] Keep visible currency literals token-driven and localized currency/accounting names out of scope.
- [x] Update command parity and architecture documentation.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` failed for the missing `429`, `463`, and `1801` separator mappings.
- Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` passed 117 tests.

## Architectural Decision

Arabic/Persian LCID support stays in the same static `NumberFormatter` separator catalog as other locale slices. FreeX records the resolved decimal, group, and date separator behavior and does not call OS culture APIs during rendering, keeping display stable across machines.
