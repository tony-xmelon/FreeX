# FreeX Avalonia parity Wave 139: Change Chart Type

## Scope

This slice addressed the top valid FreeX paired dialog residual, `dialog.ChangeChartType`.
The committed WPF authority was inspected first and found to be an older nonblank capture with
an empty middle subtype-gallery column. That frame is not a valid semantic authority for the
current source: the current WPF dialog explicitly populates the gallery, and the Avalonia route
already resolves the same shared presentation planner and current `Column` chart state.

## Implementation

The shared `ChartTypeChangePlanner` now owns the picker geometry contract used by both desktop
shells: the 290-unit picker panel, 150/180/180 content widths, 162/192 fixed columns, 12-unit
column gap, and 230-unit list height. WPF consumes those constants in its existing picker helpers;
Avalonia uses fixed columns and the same content sizes instead of platform-dependent `Auto` sizing.
The category/subtype data and current-type selection remain shared and unchanged.

## Evidence

The fresh Avalonia Docker/Xvfb capture at `640x390` was nonblank, reported `app_exit=0`, and passed
the exact-size capture guard. It shows the populated Column subtype gallery (`Clustered Column`,
`Stacked Column`, `100% Stacked Column`, `3-D Column`) beside the category list and preview.
The frame was promoted to `docs/parity/dialog-visual-assets/avalonia-capture/dialog.ChangeChartType.png`.

The current-source WPF full capture was attempted as an authority refresh. Its manifest reported
`captured:false` because the rendered PNG was fully transparent, so no WPF image was promoted or
used to tune Avalonia. The retained WPF PNG remains historical evidence and is explicitly marked
as such in its manifest.

The scoped comparison generator reports a triage score of `0.084227` for the fresh Avalonia frame
against that retained historical WPF PNG, versus the previous `0.069584`. This numeric movement is
not treated as a product regression: the two images contain different semantic states, and the
current WPF authority could not be refreshed without a nonblank capture. The concrete gain in this
slice is the shared, deterministic populated picker state and matching current-source geometry;
integration should recompute the global ranking after a valid WPF authority refresh.

## Verification

- `dotnet test tests/FreeX.App.Presentation.Tests/FreeX.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~ChartEditingPlannerTests"` - 179 passed.
- `dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~AvaloniaChartFormatDialogSourceTests"` - 10 passed.
- `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~ChangeChartTypeDialog"` - 4 passed.
- `tools/Run-LinuxParityCapture.ps1 -OutputDir artifacts/wave139-linux-change-chart-type-run1 -SurfaceId dialog.ChangeChartType -Width 640 -Height 390 -TimeoutSeconds 180` - `app_exit=0`, `capture_validated=true`.
- `dotnet build src/FreeX.App.Host/FreeX.App.Host.csproj --configuration Release --no-restore` - 0 warnings, 0 errors before the final shared-geometry edit; focused WPF tests and the fresh Docker publish rebuilt the edited paths successfully.

Global dialog summaries and dashboards are intentionally left for integration.
