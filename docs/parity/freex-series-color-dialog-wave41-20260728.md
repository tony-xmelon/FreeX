# FreeX Series Color Dialog Parity Wave 41

Date: 2026-07-28

## Closed functional mismatch

The WPF Chart Format > Shape Styles > Series Color command opens the full
`ChartSeriesFormatDialog`. That dialog lets the user select a series and edit
fill color, line color/width/dash, marker style, and marker size through the
shared `ChartSeriesFormatPlanner`.

Avalonia previously routed the same command to a color-only picker that edited
only the first series fill color. It therefore could not perform the WPF
workflow or edit the remaining series-format fields. Avalonia now routes
Series Color through its existing planner-backed `ShowChartSeriesFormatDialog`,
matching the WPF command path while retaining the host-native dialog chrome.

## Evidence

- Shared chart workflow/planner authority: **1 focused test passed**.
  `dotnet test tests/FreeX.App.Presentation.Tests/FreeX.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~ChartWorkflowDescriptorPlannerTests.FormatDataSeries_UsesSharedPlannerForEverySeriesField" --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
- WPF command authority: **1 focused test passed**.
  `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~ChartDialogTests.ChartSeriesColorCommand_UsesTheFullSeriesFormatDialog" --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
- Avalonia route authority: **1 focused test passed**.
  `dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~AvaloniaChartQuickCommandSourceTests.SeriesColorRibbonRoute_MatchesWpfFullSeriesFormatDialog" --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
- Existing shared series-format planner suite remains the authority for parsing,
  normalization, per-series replacement, and undoable layout application.

## Residuals

The WPF and Avalonia dialogs still use their native control toolkits, so exact
text rasterization and native popup pixels remain visual evidence work. The
Series Color functional route is now shared-planner-backed in both hosts.
