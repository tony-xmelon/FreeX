# FreeX Avalonia parity Wave 143: Change Chart Type

## Scope

This slice revisits `dialog.ChangeChartType`, the highest remaining FreeX paired-dialog outlier
after the Wave 139 geometry alignment. The retained WPF authority is nonblank but historical: it
has an empty subtype-gallery column and was captured at 144 DPI (`960x585`, logical `640x390`).
The current-source WPF recapture is not part of this slice and no blank WPF output was promoted.

## Correction

- The shared `ChartTypeChangePlanner` now owns the 76-unit picker action-button width alongside the
  existing dialog, list, column, and preview geometry.
- WPF and Avalonia chart-type pickers consume that shared button contract.
- The Avalonia picker now uses the WPF two-row panel geometry: shared heading/help in row one,
  category and subtype lists in row two with the WPF 24-unit top inset, and the preview spanning
  both rows.
- The Avalonia Change Chart Type window now applies the shared compact dialog chrome, including
  WPF-aligned list borders, selection styling, inherited typography, and button treatment.
- The route uses the chart-dialog keyboard lifecycle, preserving subtype-gallery initial focus,
  tab cycling, and Escape cancellation for the production picker.
- Avalonia OK/Cancel buttons now expose localized automation names in addition to their stable ids.

The shared category catalog, current-type selection, subtype gallery, preview, and command/planner
validation remain unchanged. No unsupported chart family was surfaced and no command behavior was
relaxed to improve a pixel score.

## Evidence

Before: `docs/parity/dialog-visual-assets/avalonia-capture/dialog.ChangeChartType.png` was the
Wave 139 `640x390` nonblank capture, compared against the retained WPF frame at logical `640x390`.
The committed summary recorded a triage score of `0.084227`; the WPF frame's empty gallery was an
evidence-state residual, not a valid current-source semantic target.

After: the fresh Docker/Xvfb capture was written under
`artifacts/wave143-linux-change-chart-type-run2/`, reported `app_exit=0` and
`capture_validated=true`, and passed the exact `640x390` and nonblank PNG checks. The verified PNG
was promoted to `docs/parity/dialog-visual-assets/avalonia-capture/dialog.ChangeChartType.png`.
The regenerated paired summary records triage `0.077239`, with zero nonblank, logical-size, and
expected-size failures across all `94/94` paired surfaces.

## Residuals

The WPF authority remains an older empty-gallery frame, so the numeric comparison is not a final
semantic parity verdict. A valid current-source WPF Change Chart Type capture is still needed before
the remaining pixel difference can be attributed between shell rendering and authority provenance.
The fresh Avalonia evidence itself is exact-size, populated, and nonblank.

## Verification

- `dotnet test tests/FreeX.App.Presentation.Tests/FreeX.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~ChartEditingPlannerTests"` - 179 passed.
- `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~ChangeChartTypeDialog"` - 4 passed.
- `dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~AvaloniaChartFormatDialogSourceTests" --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - 10 passed.
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-LinuxParityCapture.ps1 -OutputDir artifacts/wave143-linux-change-chart-type-run2 -SurfaceId dialog.ChangeChartType -Width 640 -Height 390 -TimeoutSeconds 180` - `app_exit=0`, `capture_validated=true`.
- `tools/Generate-DialogVisualEvidenceSummary.ps1` - 94 paired surfaces, 0 nonblank failures, 0 logical/expected-size mismatches.
