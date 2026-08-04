# Avalonia/WPF Parity Wave 137: FreeX Select Data Source

Date: 2026-08-04

## Scope

The highest current FreeX Avalonia paired dialog outlier was
`dialog.SelectDataSource`. The committed WPF PNG remains the authority for
this pass because the Windows host can intermittently emit blank fresh
RenderTargetBitmap frames. No fresh WPF frame was promoted or used as a
replacement authority.

The strongest app-owned mismatch was the Avalonia dialog's content
registration: explicit 500 px lists plus 100 px side buttons overflowed the
588 px inner content area, while the WPF authority uses a star-sized list,
92 px side buttons, and 72 px list heights. The Avalonia route also retained
visible mnemonic underscores and did not opt this dialog into the existing
shared WPF-like window/text-rendering chrome.

## Change

- Added a FreeX-dialog-specific `AvaloniaCompactDialogChromeStyle` override:
  22 px controls, 22 px text boxes/buttons, 22 px list-item minimum height,
  and compact button padding.
- Applied the existing `AvaloniaCompactDialogChrome.ApplyWindow` only to
  Select Data Source, preserving shared helper defaults and all existing
  keyboard/accessibility wiring.
- Removed fixed list widths so the two list panels use the available star
  column; matched the WPF 72 px list heights and 92 px side actions.
- Stripped display-only mnemonic markers from the visible range and checkbox
  labels. Automation IDs, planner calls, event handlers, and result behavior
  are unchanged.

## Evidence and metrics

The fresh current-source Avalonia capture was produced in Ubuntu 24.04
Docker/Xvfb at the exact 620x500 logical target. The committed WPF authority
is 930x750 pixels at approximately 144 DPI, equivalent to 620x500 logical
pixels. Lower is better:

| Pair | Triage | Sample mean | Luma delta | Non-background delta |
| --- | ---: | ---: | ---: | ---: |
| Existing canonical pair | 0.075491 | 0.036019 | 0.005998 | 0.033371 |
| Wave 137 fresh Avalonia | **0.028971** | **0.025350** | **0.001976** | **0.001542** |

The capture passed `app_exit=0`, `capture_validated=true`, nonblank PNG
validation, and exact 620x500 dimensions. The improved PNG and manifest row
were promoted under `docs/parity/dialog-visual-assets/avalonia-capture/`.
The global dialog summary and cross-app dashboard were intentionally left for
integration.

## Verification

- `dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~SelectChartDataDialog_UsesScopedWpfChromeAndInnerWidthMetrics|FullyQualifiedName~SelectChartDataDialog_UsesSharedSelectDataSourcePlanner" --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - 2 passed.
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\Run-LinuxParityCapture.ps1 -OutputDir artifacts\wave137-freex-select-data-source-after -PublishDir artifacts\wave137-freex-select-data-source-after\publish -SurfaceId dialog.SelectDataSource -Width 620 -Height 500 -TimeoutSeconds 180 -ContainerName freex-wave137-select-data-source-after` - passed.
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\Generate-DialogVisualEvidenceSummary.ps1 -MarkdownPath artifacts\wave137-freex-select-data-source-after\summary.md -JsonPath artifacts\wave137-freex-select-data-source-after\summary.json -WpfManifestPath docs\parity\dialog-visual-assets\wpf-capture\manifest.json -AvaloniaManifestPath artifacts\wave137-freex-select-data-source-after\manifest.json` - focused pair passed nonblank and expected-size gates.

## Residual limitations

The pair still includes expected cross-toolkit glyph rasterization and native
control rendering differences. This note records the focused pair only; the
repository-wide dialog summary and cross-app dashboard require the integration
owner to regenerate them.
