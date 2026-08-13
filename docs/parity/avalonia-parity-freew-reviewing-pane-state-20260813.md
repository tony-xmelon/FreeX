# FreeW Reviewing Pane shared state parity (2026-08-13)

## Gap

The WPF and Avalonia Reviewing Panes independently owned selection retention, Previous/Next
wrapping, and revision-count text. The duplicated policies had already drifted visibly: WPF used
`1 change` / `N changes`, while Avalonia used `1 tracked change` / `N tracked changes`.

## Change

`ReviewingPaneStatePlanner` now owns the renderer-neutral refresh and navigation policy in
`FreeW.App.Presentation`. Both hosts consume the same selected-index, status-text, and wrapping
results. Toolkit code is left with list rendering, selection assignment, and scrolling only.

The shared contract preserves WPF behavior:

- an empty list selects `-1` and reports `No tracked changes`;
- a newly opened or previously unselected non-empty list selects the first change;
- refresh retains the selected slot and clamps it after a removal;
- Previous/Next wraps at both ends;
- count text is `1 change` or `N changes`.

## Verification

- `dotnet test freew/FreeW.App.Presentation.Tests/FreeW.App.Presentation.Tests.csproj --configuration Release --no-build` — 1466 passed.
- `dotnet build freew/FreeW.App.Host/FreeW.App.Host.csproj --configuration Release` — passed, 0 warnings.
- `dotnet build freew/FreeW.App.Avalonia/FreeW.App.Avalonia.csproj --configuration Release` — passed, 0 warnings.

No UI, app-startup, screenshot, capture, or headless-Avalonia tests were run on this machine.
