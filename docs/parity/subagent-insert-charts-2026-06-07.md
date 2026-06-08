# Insert Charts Parity Validation - 2026-06-07

## Scope

Validated the Insert tab chart/charting command surfaces that route chart insertion and chart-type selection:

- Insert > Charts ribbon buttons and collapsed-group keytip routing.
- Insert Chart / Change Chart Type picker categories and subtype galleries.
- Chart command routing through `AddChartCommand` / `ChangeChartTypeCommand`.
- Obvious contextual chart-ribbon parity gaps visible from the existing source and tests.

## Excel Behavior Checked

- Microsoft Support documents the Excel path as `Insert > Recommended Charts`, opening an Insert Chart dialog with a Recommended Charts tab and an All Charts path for all chart types: https://support.microsoft.com/en-gb/office/create-a-chart-with-recommended-charts-cd131b77-79c7-4537-a438-8db20cea84c0
- Microsoft Support lists advanced chart families such as Histogram/Pareto, Box and Whisker, Waterfall, Funnel, and Combo, and documents `Chart Design > Change Chart Type` for existing charts: https://support.microsoft.com/en-us/office/available-chart-types-in-office-a6187218-807e-4103-9e0a-27cdb19afb90
- Microsoft Support confirms Waterfall can also be created through the All Charts tab in Recommended Charts, and that chart selection exposes Chart Design / Format contextual tabs: https://support.microsoft.com/en-us/office/create-a-waterfall-chart-8de1ece4-ff21-4d37-acd7-546f5527f185
- Microsoft Support confirms Funnel insertion from the Insert tab and Chart Design / Format contextual tabs after selection: https://support.microsoft.com/en-us/office/create-a-funnel-chart-based-on-excel-data-ba21bcba-f325-4d9f-93df-97074589a70e

## Findings

- FreeX already had XAML buttons and command handlers for supported 3D and chartEx insertion commands, including Treemap, Sunburst, Histogram, Pareto, Box and Whisker, Waterfall, Funnel, 3D Column/Bar/Line/Pie/Area, Surface, and 3D Surface.
- Runtime Insert-ribbon normalization only whitelisted classic chart insert names plus Surface/3D Surface, so supported 3D and chartEx buttons were collapsed out of Insert > Charts and out of the collapsed Charts keytip menu.
- The Insert Chart / Change Chart Type picker only listed classic/renderable chart families through Surface, despite `ChartAuthoringPlanner.CanAuthor` returning true for the supported chartEx families.
- Map remains correctly hidden/deferred because the model recognizes it as non-authorable preservation scope.

## Changes Made

- Expanded the Insert-ribbon chart command whitelist to include all authorable 3D and chartEx insert commands while keeping Map excluded.
- Added Treemap, Sunburst, Histogram/Pareto, Box and Whisker, Waterfall, and Funnel to the shared Insert Chart / Change Chart Type picker catalog using existing localized chart labels.
- Added focused tests for command-source metadata, picker categories, picker advanced galleries, runtime insert-chart command classification, and collapsed Insert > Charts keytip access.

## Remaining Chart Gaps

- Recommended Charts still uses a fixed small recommendation set rather than Excel's proprietary data-pattern recommendation heuristics.
- Combo remains available through existing chart layout/series commands, but it is not yet represented as an All Charts picker category like Excel.
- FreeX does not yet expose dedicated Excel-style Chart Design and Format contextual tabs; chart edit commands exist through the current chart command surface and dialogs.
- Map chart authoring remains deferred/hidden.
- Full live UI mutation/render evidence for advanced chart picker selections remains a broader UI-test/catalog task.
