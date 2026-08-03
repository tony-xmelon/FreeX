# Avalonia Parity Wave133: FreeX Sparkline

Date: 2026-08-03
Surface: `dialog.Sparkline`
Capture size: `380x280`

## Change

Aligned the Avalonia insert-Sparkline dialog to the WPF authority's captured client lane and control metrics. The dialog now uses a 333px left-aligned content lane, clipped range-picker rows, WPF-sized 20px action buttons, a 22px type combo, and measured label/row spacing. Existing planner validation, picker lifecycle, automation ids, keyboard focus, default/cancel behavior, and command wiring remain unchanged.

## Fresh Evidence

The WPF authority capture was produced by the owned `FreeX.App.Host.exe` process (PID 15880, exit 0) at:

- `artifacts/parity/wave133-sparkline-final-wpf-owned-20260803/manifest.json`
- `artifacts/parity/wave133-sparkline-final-wpf-owned-20260803/dialog.Sparkline.png`

The Avalonia Linux Docker capture was produced by `Run-LinuxParityCapture.ps1`; the bounded container `freex-wave133-sparkline-final3-20260803` reported `app_exit=0` and `capture_validated=true`:

- `artifacts/parity/wave133-sparkline-final3-avalonia-20260803/manifest.json`
- `artifacts/parity/wave133-sparkline-final3-avalonia-20260803/dialog.Sparkline.png`
- `artifacts/parity/wave133-sparkline-final3-20260803.json`

Both PNGs are nonblank and exactly `380x280`; expected-size checks pass.

## Metrics

Fresh pre-change pair:

- `sampleMeanDelta`: `0.049141`
- `triageScore`: `0.074104`

Fresh final pair:

- `sampleMeanDelta`: `0.030052`
- `triageScore`: `0.055394`
- `logicalDimensionMatch`: `true`
- `rawPixelDimensionMatch`: `true`
- `expectedSizeMismatch`: `false`

The user-supplied prior triage values were `0.053716` sample mean delta and `0.076551` triage score; this note uses the reproducible same-source baseline above for the before/after comparison.

## Verification

- `dotnet build src/FreeX.App.Avalonia/FreeX.App.Avalonia.csproj --configuration Release -m:1 -p:NodeReuse=false /nr:false` passed, 0 warnings, 0 errors.
- `dotnet build tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release -m:1 -p:NodeReuse=false /nr:false` passed, 0 warnings, 0 errors.
- `dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~AvaloniaCompactDialogChromeClusterASourceTests" --logger "trx;LogFileName=wave133-sparkline-source-final3.trx" -m:1 -p:NodeReuse=false /nr:false` passed: 1/1.
- WPF authority Release build passed before the baseline/final captures: `dotnet build src/FreeX.App.Host/FreeX.App.Host.csproj --configuration Release -m:1 -p:NodeReuse=false /nr:false`.
- Final analyzer: `Generate-DialogVisualEvidenceSummary.ps1` with the final WPF/Avalonia manifests; paired surface checks passed with 0 nonblank failures, 0 dimension mismatches, and 0 expected-size mismatches.

## Residuals And Cleanup

The remaining visual delta is primarily platform rasterization and native control rendering: Avalonia reports 1016 distinct colors versus WPF's 166, with `lumaDelta=0.010391` and `nonBackgroundDelta=0.014671`. No product-owned size mismatch remains in the final evidence.

All named Docker capture containers from this task exited and were removed by the bounded capture script. The owned WPF process exited with code 0. No machine-wide process termination was used, and `dotnet build-server shutdown` was intentionally not run because another session has active builds. Intermediate capture/publish directories are retained under `artifacts/parity` as local evidence; no shared or FreeW/FreeP files were edited.
