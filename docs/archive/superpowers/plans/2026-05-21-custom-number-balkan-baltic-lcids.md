# Custom Number Balkan/Baltic LCIDs

## Scope

Expand the deterministic custom-number LCID catalog for Balkan and Baltic locale tokens where FreeX previously preserved currency literals but rendered invariant numeric and date separators.

## Checklist

- [x] Add failing formatter coverage for Greek, Romanian, Bulgarian, Croatian, Slovak, Slovenian, Serbian Latin, Lithuanian, Latvian, and Estonian LCID tokens.
- [x] Add static separator mappings for `402`, `408`, `418`, `41A`, `41B`, `424`, `425`, `426`, `427`, and `241A`.
- [x] Preserve visible currency literals and avoid runtime OS-culture lookup.
- [x] Update command parity and architecture documentation.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` failed 19 cases for missing locale separator mappings.
- Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` passed 101 tests.

## Architectural Decision

The custom-number formatter continues to resolve LCID separator behavior through a static catalog. New Balkan/Baltic entries use resolved decimal, group, and date separators, including non-breaking-space group separators, so workbook display remains deterministic across machines.
