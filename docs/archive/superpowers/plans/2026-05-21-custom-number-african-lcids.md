# Custom Number African LCIDs

## Scope

Expand deterministic custom-number LCID separator coverage for selected African locale tokens with visible separator differences.

## Checklist

- [x] Add failing formatter coverage for Afrikaans, Xhosa, French Morocco, and French Senegal visible separator gaps.
- [x] Add static separator mappings for `434`, `435`, `436`, `441`, `45E`, `468`, `46A`, `470`, `280C`, and `380C`.
- [x] Preserve visible currency literals and avoid runtime OS-culture lookup.
- [x] Update command parity and architecture documentation.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` failed for five missing African separator mappings.
- Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` passed 137 tests.

## Architectural Decision

African LCID support follows the same table-driven custom-number formatter boundary. Entries store resolved decimal, group, and date separators, including non-breaking and narrow no-break group separators, so formatting stays deterministic across machines.
