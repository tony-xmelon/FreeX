# FreeW Legal Notices Visual Parity Wave 98

Date: 2026-08-01  
Baseline: `8ef9f0c8ce` (`origin/main`)  
Authority: fresh FreeW WPF `SharedLegalNoticesDialog` captures  
Scope: FreeW Avalonia Legal Notices initial state and all five notice tabs

## Change

The shared Avalonia classic-tab template now forwards the styled tab item's foreground,
font family, and font size through the themed `AccessText` header child. This restores the
WPF black tab-label treatment for inactive and selected Legal Notices tabs while retaining
the shared metrics, tab order, automation IDs, focus target, read-only document behavior,
scrollbar lane, and default/cancel close semantics.

The focused Avalonia contract test now opens the real Legal Notices route and verifies the
five rendered tab headers, initial document focus, every selected-tab transition, and
default/cancel metadata. The WPF authority was not changed.

## Fresh Six-State Evidence

The WPF and Avalonia harnesses captured all six paired states from this worktree. The
comparison returned exit code 2 because all six rows remain honest
`genuine-visual-mismatch` classifications; no capture, content, or semantic row was lost.
Raw captures and reports are retained outside the repository under
`%TEMP%\\freex-wave98-legal`:

- `inventory.json`
- `wave98-wpf/wpf_dialog_capture_manifest.json`
- `wave98-avalonia/avalonia_dialog_capture_manifest.json`
- `wave98-compare/freew_dialog_visual_comparison.json`
- `wave98-compare/heatmaps/`

| State | Before changed | After changed | Delta | Before mean | After mean |
| --- | ---: | ---: | ---: | ---: | ---: |
| `initial` | 10.5444% | 10.5419% | -0.0024 pp | 12.045 | 12.083 |
| `tab-project-license` | 10.5444% | 10.5419% | -0.0024 pp | 12.045 | 12.083 |
| `tab-legal-notices` | 19.3906% | 19.3911% | +0.0005 pp | 21.271 | 21.311 |
| `tab-privacy-notice` | 16.5629% | 16.5626% | -0.0003 pp | 18.049 | 18.089 |
| `tab-third-party-notices` | 19.6634% | 19.6645% | +0.0011 pp | 22.423 | 22.462 |
| `tab-third-party-license-texts` | 18.6164% | 18.6137% | -0.0027 pp | 20.549 | 20.582 |
| **Average** | **15.8870%** | **15.8860%** | **-0.0010 pp** | **17.730** | **17.768** |

The remaining long-document mismatch is cross-framework Consolas rasterization plus native
scrollbar and tab-template pixels. No comparator threshold or classification was changed.

## Verification

Focused route tests passed 3/3:

```text
dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~LegalNoticesDialogVisualParityTests"
```

Fresh route capture commands:

```text
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Wpf/FreeW.DialogVisualHarness.Wpf.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -- --inventory %TEMP%/freex-wave98-legal/inventory.json --output %TEMP%/freex-wave98-legal/wave98-wpf
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -- --inventory %TEMP%/freex-wave98-legal/inventory.json --wpf-authority %TEMP%/freex-wave98-legal/wave98-wpf/wpf_dialog_capture_manifest.json --output %TEMP%/freex-wave98-legal/wave98-avalonia
dotnet run --project freew/tools/FreeW.DialogVisualHarness/FreeW.DialogVisualHarness.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -- compare --inventory %TEMP%/freex-wave98-legal/inventory.json --wpf %TEMP%/freex-wave98-legal/wave98-wpf/wpf_dialog_capture_manifest.json --avalonia %TEMP%/freex-wave98-legal/wave98-avalonia/avalonia_dialog_capture_manifest.json --output %TEMP%/freex-wave98-legal/wave98-compare
```
