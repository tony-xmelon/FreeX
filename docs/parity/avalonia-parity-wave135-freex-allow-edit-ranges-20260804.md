# Avalonia parity Wave 135: FreeX Allow Edit Ranges

Date: 2026-08-04

## Scope

The Avalonia Allow Users to Edit Ranges dialog now follows the current WPF
dialog geometry at its fixed 430x420 capture size. It removes the extra inline
range-picker button from the visible layout, uses the shared compact dialog and
GroupBox chrome with WPF-sized text boxes and buttons, left-aligns the range
actions, and keeps the OK/Cancel row in the immediate vertical flow after the
password field. The range field retains the shared worksheet pointing
machinery through an F4 keyboard route backed by a collapsed registered
picker, so pointing,
Enter-to-apply, Escape-to-cancel, and dialog restoration remain functional
without a permanently visible mismatching button. Range parsing, command
routing, password handling, and the WPF dialog were unchanged.

## Evidence and metrics

Fresh matched-size evidence used the full current-source WPF parity capture and
the targeted Ubuntu 24.04 Docker/Xvfb Avalonia capture. The fresh WPF PNG was
byte-identical to the existing canonical WPF authority (SHA-256
`43AB7A7D47A853653CE6F92F0232FD78E15F92A094089A683AACCED01C560DC9`).

| Pair | Triage | Sample mean | Luma delta | Non-background delta |
| --- | ---: | ---: | ---: | ---: |
| Current-main baseline | 0.078735 | 0.022148 | 0.013911 | 0.042398 |
| Wave 135 final | **0.022747** | **0.015483** | **0.003944** | **0.003040** |

Both PNGs are nonblank and exactly 430x420 pixels. WPF is 430.06x420.059
logical pixels at approximately 96 DPI; Avalonia is 430x420 logical pixels at
96 DPI. The canonical Avalonia PNG and its per-surface manifest note were
promoted only after this measured improvement. The point-mode correction was
recaptured byte-for-byte identically (SHA-256
`3ACA1FDA1A7BD925B3796FD951F2956CB3327BC39DA947C50C590855D6DA2943`), proving
the restored behavior adds no visible geometry. The global dialog summary and
cross-app dashboard were intentionally not regenerated.

## Verification

- `dotnet test tests\FreeX.App.Avalonia.Tests\FreeX.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~AllowEditRange --logger "console;verbosity=minimal" --no-restore -m:1`: 4 passed, including the headless F4 point-mode/Enter-apply behavior.
- `dotnet test tests\FreeX.App.Avalonia.Tests\FreeX.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~DialogRangeSelectionTests --logger "console;verbosity=minimal" --no-build --no-restore -m:1`: 6 passed.
- `dotnet build src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release -m:1`: 0 warnings, 0 errors.
- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --filter FullyQualifiedName~AllowEditRangeDialog --logger "console;verbosity=minimal" --no-restore -m:1`: 9 passed.
- Full WPF `FreeX.App.Host.exe --parity-capture artifacts\wave135-wpf-allow-edit-ranges-full`: `dialog.AllowEditRanges` captured at 430x420; fresh PNG hash matched the canonical WPF PNG.
- `tools\Run-LinuxParityCapture.ps1 -OutputDir artifacts\wave135-avalonia-allow-edit-ranges-point-mode -SurfaceId dialog.AllowEditRanges -Width 430 -Height 420`: `app_exit=0`, `capture_validated=true`.
- Temporary `Generate-DialogVisualEvidenceSummary.ps1` pair: 1 paired surface, 0 nonblank failures, 0 dimension mismatches, 0 expected-size mismatches.
- `git diff --check`: passed.

## Residual

The pair still has native WPF/Avalonia text rasterization and a small GroupBox
header/border-template difference. This slice demonstrates a measured visual
improvement; it does not claim full visual parity.
