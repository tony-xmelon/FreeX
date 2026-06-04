# Custom Number Central/Eastern LCIDs Plan

- [x] Identify Czech, Hungarian, and Russian LCID tokens as a small custom-number locale gap.
- [x] Add failing formatter coverage for `405`, `40E`, and `419` currency number formats.
- [x] Map those LCIDs to deterministic decimal/group/date separators without depending on OS culture.
- [x] Update architecture and command parity documentation.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter FullyQualifiedName~NumberFormatterTests.CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators -v minimal` failed for the new `405`, `40E`, and `419` cases before implementation.
- Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter FullyQualifiedName~NumberFormatterTests.CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators --logger "console;verbosity=minimal"` passed 18 tests.
