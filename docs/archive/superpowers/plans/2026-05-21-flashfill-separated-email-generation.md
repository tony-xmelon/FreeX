# Flash Fill Separated Email Generation Plan

- [x] Identify that two-column Flash Fill generated shared-domain `first.last@example.com` addresses but not common `_` or `-` variants.
- [x] Add failing service coverage for `first_last@domain` and `first-last@domain` learned from examples.
- [x] Generalize the first/last email detector to learn one modeled separator from examples.
- [x] Update architecture and command parity documentation.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter FullyQualifiedName~FlashFillServiceTests -v minimal` failed for both new separator cases before implementation.
- Green: `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter FullyQualifiedName~FlashFillServiceTests.FillFromColumns_FirstLastSeparatedEmail --logger "console;verbosity=minimal"` passed 2 tests.
