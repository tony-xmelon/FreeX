# Chart Native JSON Design Metadata

## Scope

Persist modeled chart design metadata through Native JSON so FreeX-authored chart and PivotChart state has the same
native-file durability expected from the XLSX path.

## Tasks

- [x] Add a failing Native JSON chart round-trip test for pivot format XML, date-system/language, manual layouts,
  external data, protection, print settings, rounded corners, blank display, labels-over-max, title deletion, and
  hidden-row display flags.
- [x] Extend the chart DTO and mapper with the existing `ChartModel` design metadata fields.
- [x] Update architecture and command parity documentation.

## Verification Log

- Red: `dotnet test FreeX\tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --filter "NativeJsonAdapter_RoundTrip_ChartDesignMetadata" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because `PivotFormatsXml` and related design metadata were not loaded.
- Green: `dotnet test FreeX\tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --filter "NativeJsonAdapter_RoundTrip_ChartDesignMetadata" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 1 test.

## Architecture Decisions

- Native JSON continues to mirror `ChartModel` directly; no separate chart-design DTO hierarchy is introduced for these already-modeled fields.
- Older Native JSON files remain compatible because newly added DTO properties use the same defaults as `ChartModel`.
