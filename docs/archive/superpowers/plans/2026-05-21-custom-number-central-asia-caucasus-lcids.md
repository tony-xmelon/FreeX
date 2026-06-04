# Custom Number Central Asia/Caucasus LCIDs

## Scope

Expand deterministic custom-number LCID separator coverage for Central Asia, Caucasus, and adjacent South/Southeast Asian locale tokens.

## Checklist

- [x] Add failing formatter coverage for Kazakh, Kyrgyz, Uzbek Latin, Azerbaijani Latin, Georgian, Armenian, Mongolian, Nepal, Sri Lanka, Lao, Khmer, and Myanmar LCID tokens.
- [x] Add static separator mappings for `42B`, `42C`, `437`, `43F`, `440`, `443`, `450`, `453`, `454`, `455`, `45B`, and `461`.
- [x] Preserve visible currency literals and avoid runtime OS-culture lookup.
- [x] Update command parity and architecture documentation.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` failed 12 cases for missing separator mappings.
- Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` passed 161 tests.

## Architectural Decision

The custom-number formatter remains a deterministic static separator catalog. Central Asia/Caucasus entries store resolved decimal, group, and date separators directly, including non-breaking-space grouping, so rendering is stable across machines.
