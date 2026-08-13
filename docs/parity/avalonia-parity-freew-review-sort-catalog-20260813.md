# FreeW Reviewing Pane shared sort catalog (2026-08-13)

## Gap

WPF retained a host-local `RevisionSortOrder` enum and `RevisionSortComparer` facade even after the
sort implementation moved to Presentation. Both renderers also independently hardcoded the four
sort labels and Avalonia carried its own enum-to-index switch. That left renderer code authoritative
for the same user-visible menu and allowed the two menus to drift.

## Change

`ReviewRevisionSortPlanner` now publishes the ordered option catalog, labels, enum values, index
resolution, and comparator. WPF and Avalonia only create their native `ComboBoxItem` controls from
that catalog and pass the selected shared enum back to the planner.

The WPF compatibility enum/facade and its host test file were removed. Their null-date, empty-list,
single-entry, stable ordering, and no-copy sequence cases now live in the pure Presentation suite.
This leaves toolkit code responsible only for rendering and selection events.

## Verification

- `dotnet test freew/FreeW.App.Presentation.Tests/FreeW.App.Presentation.Tests.csproj --configuration Release --no-build` — 1469 passed.
- `dotnet build freew/FreeW.App.Host/FreeW.App.Host.csproj --configuration Release` — passed, 0 warnings.
- `dotnet build freew/FreeW.App.Avalonia/FreeW.App.Avalonia.csproj --configuration Release` — passed, 0 warnings.

No UI, app-startup, screenshot, capture, or headless-Avalonia tests were run on this machine.
