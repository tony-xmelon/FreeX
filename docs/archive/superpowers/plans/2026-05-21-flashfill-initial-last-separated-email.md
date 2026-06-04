# Flash Fill Initial Last Separated Email Plan

- [x] Identify that two-column Flash Fill generated compact `flast@example.com` aliases but not common separated aliases.
- [x] Add failing service coverage for `f.last@domain`, `f_last@domain`, and `f-last@domain` learned from examples.
- [x] Extend the first-initial/last email detector to learn one modeled separator while preserving compact aliases.
- [x] Update architecture and command parity documentation.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter FullyQualifiedName~FlashFillServiceTests.FillFromColumns_FirstInitialLastSeparatedEmail -v minimal` failed for all three separator cases before implementation.
- Green: `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter FullyQualifiedName~FlashFillServiceTests.FillFromColumns_FirstInitialLastSeparatedEmail --logger "console;verbosity=minimal"` passed 3 tests.
