# PivotChart Native JSON Options

## Scope

Persist PivotChart binding and option state through Native JSON so FreeX-authored workbooks do not lose PivotChart
metadata outside XLSX.

## Tasks

- [x] Add a failing Native JSON round-trip test for PivotChart binding, style, and field-button visibility options.
- [x] Extend the chart DTO and mapper with PivotChart fields while keeping default values backward-compatible for older JSON.
- [x] Update architecture and command parity documentation.

## Verification Log

- Red: `dotnet test FreeX\tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --filter "NativeJsonAdapter_RoundTrip_PivotChartOptions" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because PivotChart flags loaded as default non-PivotChart values.
- Green: `dotnet test FreeX\tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --filter "NativeJsonAdapter_RoundTrip_PivotChartOptions" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 1 test.

## Architecture Decisions

- PivotChart state remains on `ChartModel`; Native JSON mirrors the existing model fields instead of introducing a separate PivotChart DTO.
- Missing fields in older Native JSON files keep model defaults: ordinary chart, no PivotTable binding, and visible field buttons.
