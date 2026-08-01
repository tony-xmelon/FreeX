# FreeW Backstage Visual Parity Wave 92

Date: 2026-08-01

## Scope

This slice keeps the five paired Backstage pane scenarios in a neutral
560x600 host:

- `backstage-home.open`
- `backstage-export.open`
- `backstage-open.open`
- `backstage-save-as.open`
- `backstage-print.open`

The WPF builders remain the authority. No comparison thresholds, math, or
classifications changed.

## Implementation

- Applied the shared compact WPF input chrome to Open search and Save As file
  type controls, including their effective min/max heights and padding.
- Kept Open tab bodies directly owned by their `TabItem`, with explicit WPF
  body width and left/top content alignment.
- Made Backstage pane scrolling reserve a visible scrollbar and use left/top
  content alignment, matching WPF width and wrapping behavior while retaining
  vertical-only scrolling.
- Added headless assertions for tab ownership/layout, input metrics, and the
  Backstage scroll contract.

## Fresh Evidence

The focused temporary evidence is under
`C:\Users\anton\AppData\Local\Temp\freex-wave92-freew-backstage-base`:

- WPF authority: `wpf/wpf_dialog_capture_manifest.json`
- Avalonia final: `avalonia-final/avalonia_dialog_capture_manifest.json`
- Comparison: `C:\Users\anton\AppData\Local\Temp\freex-wave92-freew-backstage-final-compare`

All ten captures are 560x600 and pass both host content gates. All five rows
remain `genuine-visual-mismatch`, with no threshold or platform exemption.

| Scenario | Baseline changed ratio | Final changed ratio | Baseline mean delta | Final mean delta |
| --- | ---: | ---: | ---: | ---: |
| `backstage-home.open` | 14.401% | 14.029% | 12.300 | 11.470 |
| `backstage-export.open` | 15.291% | 13.543% | 12.282 | 11.506 |
| `backstage-open.open` | 20.374% | 18.497% | 18.044 | 16.013 |
| `backstage-save-as.open` | 14.333% | 9.829% | 11.339 | 8.302 |
| `backstage-print.open` | 9.516% | 8.586% | 7.913 | 7.262 |

## Residuals

Avalonia native control templates, text rasterization, semantic action-order
metadata, and the Open tab rendering still differ from WPF. The Open crop
retains a visible tab/body template truncation for long rows; its content and
scroll routing remain present and functional. Direct Print also remains
capability-backed rather than being made to claim WPF printer availability.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~FreeW.App.Avalonia.Tests.BackstageViewTests --logger "console;verbosity=minimal"` - 34 passed.
- `dotnet build freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj --configuration Release --no-restore` - succeeded, 0 warnings, 0 errors.
- Focused WPF authority capture - 5/5 captured.
- Focused Avalonia final capture - 5/5 captured.
- Focused comparison - 5/5 paired rows captured and classified `genuine-visual-mismatch`; intentional non-zero exit code 2.
