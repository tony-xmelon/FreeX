# Avalonia/WPF Parity Wave 124: FreeX Goal Seek Status

Date: 2026-08-03

## Scope

This slice aligns the Avalonia Goal Seek Status dialog with the WPF authority
while preserving the existing result choices, automation IDs, keyboard handling,
and workbook apply/restore behavior.

## Implementation

- Added `GoalSeekStatusDialogPlanner` in shared FreeX presentation code for the
  WPF-authority `380` width, `190/170` result-dependent heights, action widths,
  `20px` button height, `8px` action gap, and status line rhythm.
- Routed the WPF dialog dimensions and action widths through that shared plan.
- Reworked Avalonia's status body from bottom-docked layout to the WPF-equivalent
  natural stack, including the four-line status rhythm, WPF right inset, and
  neutral compact button chrome from the shared Avalonia shell theme.
- Kept the status choice flow, automation metadata, default/cancel behavior,
  and result formatting unchanged.

## Evidence

The canonical pre-Wave124 pair remains the evidence baseline because the targeted
Linux capture harness did not emit a new PNG after the source change. The existing
canonical pair is same-size `380x190` and compares at `3.255188%` mean-pixel
difference with no hard regression. Its generated triage score is `0.088677`.

Two fresh targeted Linux attempts used the named container
`freex-wave124-goalseek-avalonia`. In both attempts `/app/FreeX` exited without
emitting a PNG or manifest, while `xvfb-run` and Xvfb remained; the mounted output
directory stayed empty. Only that exact container was removed. A fresh paired
visual capture remains the follow-up residual for integration.

## Verification

- `dotnet build src/FreeX.App.Host/FreeX.App.Host.csproj --configuration Release --no-restore`: passed, 0 warnings, 0 errors.
- `dotnet build src/FreeX.App.Avalonia/FreeX.App.Avalonia.csproj --configuration Release --no-restore`: passed, 0 warnings, 0 errors.
- `dotnet test tests/FreeX.App.Presentation.Tests/FreeX.App.Presentation.Tests.csproj --configuration Release --filter FullyQualifiedName~GoalSeekStatusDialogPlannerTests`: 1/1 passed.
- `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --configuration Release --filter FullyQualifiedName~RemainingDialogTests.GoalSeekStatus`: 5/5 passed.
- `dotnet test tests/FreeX.App.Services.Tests/FreeX.App.Services.Tests.csproj --configuration Release --filter FullyQualifiedName~AvaloniaShellSourceTests`: 75/75 passed.
- Full existing-canonical `FreeX.ParityCompare` skip-capture comparison: 94/94 dialog surfaces paired, 0 hard regressions; process exit is nonzero only because the dialog-only manifests intentionally omit the Name Box popup contract.
