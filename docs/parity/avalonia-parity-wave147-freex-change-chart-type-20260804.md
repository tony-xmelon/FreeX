# FreeX Avalonia parity Wave 147: Change Chart Type

## Scope

This bounded slice aligns the Avalonia Change Chart Type preview's internal vertical geometry with
the current WPF `CreatePreviewPanel` source contract. The outer dialog size, picker columns, list
selection, preview bars, and command behavior are unchanged.

## Correction

Avalonia now uses the WPF preview element gaps directly: 12 units after the preview title, 14 after
the body text, and 8 after the sample label. This replaces the previous generic 10-unit stack
spacing, which placed the preview text at different vertical offsets despite matching outer chrome.

## Evidence

The retained WPF authority is the historical 144-DPI capture described by Wave 143. The bounded
current-source Avalonia Docker/Xvfb capture completed with `app_exit=0` and
`capture_validated=true` at `640x390`, and its PNG was exact-size and nonblank. The target triage
score improved from `0.077239` to `0.076982`; the target mean-pixel diff was `4.520%`. The fresh
PNG remains in `artifacts/wave147-linux-change-chart-type/` and was not promoted over canonical
evidence.

## Verification

- Focused Avalonia source test: `ChangeChartTypePreview_UsesWpfElementSpacingContract`.
- `dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~AvaloniaChartFormatDialogSourceTests"` - focused source class passed.
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Run-LinuxParityCapture.ps1 -OutputDir artifacts/wave147-linux-change-chart-type -SurfaceId dialog.ChangeChartType -Width 640 -Height 390 -TimeoutSeconds 180` - `app_exit=0`, `capture_validated=true`.
- Target-only summary comparison against the retained WPF PNG - triage `0.076982`, mean-pixel diff `4.520%`, logical-size match, nonblank match. The partial comparer run also reports the expected name-box contract failure because only this one Linux surface was supplied.
