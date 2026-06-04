# Custom Number Latin American LCIDs

## Scope

Extend the deterministic custom-number LCID separator catalog for common Latin American Spanish locales and the
Spanish traditional-sort alias.

## Tasks

- [x] Add failing formatter tests for Latin American Spanish LCID decimal/group/date separators.
- [x] Add table-driven separator entries without adding formatter branches or OS-culture calls.
- [x] Update architecture and command parity docs to reflect the broader modeled LCID set.

## Verification Log

- Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed for Latin American Spanish LCIDs that still used invariant separators.
- Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 55 tests.

## Architecture Decisions

- LCID behavior remains a small static separator table so rendering is deterministic and independent of the user's OS culture.
- This slice covers decimal/group/date separator fidelity only; localized currency/accounting names and exact accounting layout widths remain out of scope.
