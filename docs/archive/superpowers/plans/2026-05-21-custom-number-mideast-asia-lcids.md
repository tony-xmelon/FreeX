# Custom Number Middle East / Southeast Asia LCIDs

## Scope

Expand the deterministic custom-number LCID separator catalog for another small group of visible locale tokens without adding runtime OS-culture lookup.

## Checklist

- [x] Add red formatter coverage for LCID tokens that currently fall back to invariant separators.
- [x] Add deterministic catalog entries for `40D`, `41E`, `421`, `42A`, and `43E`.
- [x] Preserve visible currency symbols from the format token and keep localized currency/accounting names out of scope.
- [x] Update command parity and architecture documentation.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` reported failing Vietnam `42A` and Indonesia `421` separator expectations before timing out.
- Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` passed 81 tests.

## Architectural Decision

`NumberFormatter` continues to use a static resolved-separator table. The new LCID entries store decimal, group, and date separators directly, so rendering remains stable across machines and does not depend on the current Windows culture.
