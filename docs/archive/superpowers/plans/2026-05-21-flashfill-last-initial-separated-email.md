# Flash Fill Last Initial Separated Email Plan

- [x] Identify that two-column Flash Fill generated compact `lastf@example.com` aliases but not separated `last.f@example.com` variants.
- [x] Add failing service coverage for `last.f@domain`, `last_f@domain`, and `last-f@domain` learned from examples.
- [x] Extend the last-name/first-initial email detector to learn one modeled separator while preserving compact aliases.
- [x] Update architecture and command parity documentation.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter FullyQualifiedName~FlashFillServiceTests.FillFromColumns_LastFirstInitialSeparatedEmail -v minimal` failed for all three separator cases before implementation.
- Green: `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter FullyQualifiedName~FlashFillServiceTests.FillFromColumns_LastFirstInitialSeparatedEmail --logger "console;verbosity=minimal"` passed 3 tests.
