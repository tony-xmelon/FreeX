# FreeW Legal Notices Visual Parity Wave 90

Date: 2026-08-01
Authority: FreeW WPF `SharedLegalNoticesDialog`
Scope: shared Avalonia Legal Notices template adapter and FreeW parity tests

## Change

The shared Avalonia Legal Notices adapter now disables Fluent scrollbar auto-hide for the
read-only notice documents. Long notice tabs therefore retain a visible vertical scrollbar
while preserving the existing shared WPF/Avalonia metrics, padding, font, line height, tab
geometry, and keyboard contract.

The shared Legal Notices close button also reapplies the neutral WPF default-state border after
the shared Avalonia chrome pass. Its `IsDefault` and `IsCancel` automation behavior is unchanged.

## Six-State Paired Evidence

WPF was captured once as the authority and reused for the before and after Avalonia comparisons.
Both hosts captured all six states with no unsupported rows. Raw captures and comparison reports
are under `%TEMP%\\freex-wave90-legal`.

| State | Before changed | After changed | Delta | Before mean | After mean |
| --- | ---: | ---: | ---: | ---: | ---: |
| `initial` | 9.7358% | 9.6933% | -0.0425 pp | 11.068 | 11.013 |
| `tab-legal-notices` | 19.3315% | 19.8567% | +0.5253 pp | 22.481 | 22.452 |
| `tab-privacy-notice` | 16.8981% | 17.0145% | +0.1164 pp | 18.902 | 18.860 |
| `tab-project-license` | 9.7358% | 9.6933% | -0.0425 pp | 11.068 | 11.013 |
| `tab-third-party-license-texts` | 19.7325% | 19.0567% | -0.6758 pp | 21.863 | 21.671 |
| `tab-third-party-notices` | 20.6876% | 20.0780% | -0.6097 pp | 23.660 | 23.437 |
| **Average** | **16.0202%** | **15.8987%** | **-0.1215 pp** |  |  |

The net changed-pixel ratio improves across the six-state cluster. The `tab-legal-notices`
row is the only material changed-pixel increase; its mean channel delta decreases slightly,
and no state loses capture, semantic, or content validation.

## Verification

Focused tests passed: 2/2 in `LegalNoticesDialogVisualParityTests`.

Capture commands:

```powershell
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Wpf/FreeW.DialogVisualHarness.Wpf.csproj -c Release --no-restore -- --inventory %TEMP%/freex-wave90-legal/inventory.json --output %TEMP%/freex-wave90-legal/before-wpf
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj -c Release --no-restore -- --inventory %TEMP%/freex-wave90-legal/inventory.json --wpf-authority %TEMP%/freex-wave90-legal/before-wpf/wpf_dialog_capture_manifest.json --output %TEMP%/freex-wave90-legal/after-avalonia-autohide-only
dotnet run --project freew/tools/FreeW.DialogVisualHarness/FreeW.DialogVisualHarness.csproj -c Release --no-restore -- compare --inventory %TEMP%/freex-wave90-legal/inventory.json --wpf %TEMP%/freex-wave90-legal/before-wpf/wpf_dialog_capture_manifest.json --avalonia %TEMP%/freex-wave90-legal/after-avalonia-autohide-only/avalonia_dialog_capture_manifest.json --output %TEMP%/freex-wave90-legal/after-compare-autohide-only
```
