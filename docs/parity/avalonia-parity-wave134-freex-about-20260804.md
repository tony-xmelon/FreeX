# Avalonia/WPF Parity Wave 134: FreeX About Dialog

Date: 2026-08-04

## Scope

The shared Avalonia About realization now uses the existing read-only document
chrome for the WPF-sized scrollbar lane and focus treatment, with named About
metrics for the measured Avalonia line box and vertical viewport inset. The
About action button keeps the shared size and border but uses the WPF authority's
white resting surface. WPF source and unrelated dialogs were not changed.

## Evidence and metrics

Fresh matched production captures were generated at 560x420 logical pixels:

| Pair | Triage | Sample mean | Luma delta | Non-background delta |
| --- | ---: | ---: | ---: | ---: |
| Wave 130 baseline | 0.107196 | 0.071472 | 0.013961 | 0.021484 |
| Wave 134 final | **0.077246** | **0.057872** | 0.005549 | 0.013546 |

The pair has zero raw pixel-size mismatch, zero logical-size mismatch, and no
blank capture failures. The fresh WPF PNG is byte-identical to the existing
canonical authority; the fresh Avalonia PNG and manifest provenance are promoted
to the canonical Avalonia capture.

## Verification

- `dotnet test tests\FreeX.App.Avalonia.Tests\FreeX.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~AboutDialogParityTests --logger "console;verbosity=minimal" -m:1 --no-restore`: 1 passed.
- `dotnet build src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release -m:1`: 0 warnings, 0 errors.
- Full WPF `--parity-capture` route: About captured at 560x420, process exit 0.
- `tools\Run-LinuxParityCapture.ps1` for `dialog.About`: `app_exit=0`, `capture_validated=true`, 560x420.
- Fresh paired evidence summary generated in a temporary path; the checked-in global summary was not edited.

## Residual

WPF and Avalonia continue to differ in glyph rasterization, platform-specific
About text, and the realized scrollbar thumb/document length. The remaining
delta is informational rather than a functional or logical-size mismatch.
