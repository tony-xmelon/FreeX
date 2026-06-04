# Custom Number Native Indian LCIDs

## Goal

Reuse the existing deterministic Indian grouping support for common native Indian LCIDs beyond `en-IN`.

## Scope

- [x] Add regression coverage for native Indian LCIDs using `[3,2]` grouping.
- [x] Add catalog entries for `439` (hi-IN), `445` (bn-IN), `447` (gu-IN), `449` (ta-IN), `44A` (te-IN), and `44E` (mr-IN).
- [x] Preserve the table-driven locale catalog and avoid runtime OS-culture lookup during formatting.
- [x] Keep localized currency/accounting labels and full LCID coverage out of scope.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` failed because native Indian LCIDs rendered Western grouping and invariant date separators.
- Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` passed 71 tests.
