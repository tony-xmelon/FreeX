# Custom Number Swiss LCIDs Plan

- [x] Identify Swiss German/French LCIDs as a small custom-number locale gap with visible currency already preserved.
- [x] Add failing formatter coverage for `807` and `100C` CHF number formats using apostrophe grouping.
- [x] Map those LCIDs to deterministic decimal/group/date separators without OS culture dependency.
- [x] Update architecture and command parity documentation.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter FullyQualifiedName~NumberFormatterTests.CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators -v minimal` failed for the new `807` and `100C` cases before implementation.
- Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter FullyQualifiedName~NumberFormatterTests.CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators --logger "console;verbosity=minimal"` passed 12 tests.
