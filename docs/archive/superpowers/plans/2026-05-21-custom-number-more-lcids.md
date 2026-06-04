# Custom Number Additional LCIDs Plan

- [x] Identify three more common LCID tokens where FreeX preserved visible currency symbols but fell back to invariant separators.
- [x] Add failing formatter coverage for Dutch `413`, Polish `415`, and Portuguese Brazil `416` number formats.
- [x] Map those LCIDs to deterministic decimal/group/date separators without depending on OS culture.
- [x] Update architecture and command parity documentation.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter FullyQualifiedName~NumberFormatterTests.CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators -v minimal` failed for the new `413`, `415`, and `416` cases before implementation.
- Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter FullyQualifiedName~NumberFormatterTests.CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators --logger "console;verbosity=minimal"` passed 10 tests.
