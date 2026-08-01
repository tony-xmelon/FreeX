# FreeW Backstage Visual Parity Wave 93

Date: 2026-08-01

## Scope

This slice covers the five paired Backstage pane scenarios in the fixed
560x600 neutral host:

- `backstage-home.open`
- `backstage-export.open`
- `backstage-open.open`
- `backstage-save-as.open`
- `backstage-print.open`

The WPF builders and captures remain the visual authority. Comparison math,
dimensions, thresholds, and classifications were unchanged.

## Implementation

- Reapplied the WPF flush content-pane margin to the Avalonia Open tab's
  native `PART_SelectedContentHost` after attachment, including the required
  left/top alignment and zero padding.
- Kept the Open tab bodies at the WPF width and left/top alignment while
  retaining the existing vertical-only scroll route and action callbacks.
- Added an attached-window layout regression test for the native selected-tab
  body and retained the constrained-host tab layout assertions.

## Fresh Evidence

Temporary evidence:
`C:\Users\anton\AppData\Local\Temp\freex-wave93-freew-backstage`

Each row has a fresh WPF authority capture and a fresh Avalonia final capture;
all ten captures are 560x600 and pass both host content gates. The baseline
column is a fresh pre-edit Avalonia capture from this Wave 93 session, using
the same WPF authority capture as the final column.

| Scenario | Baseline changed ratio | Final changed ratio | Baseline mean delta | Final mean delta | Classification |
| --- | ---: | ---: | ---: | ---: | --- |
| `backstage-home.open` | 14.049% | 14.049% | 11.442 | 11.442 | `genuine-visual-mismatch` |
| `backstage-export.open` | 13.543% | 13.543% | 11.506 | 11.506 | `genuine-visual-mismatch` |
| `backstage-open.open` | 18.421% | 18.259% | 15.943 | 15.807 | `genuine-visual-mismatch` |
| `backstage-save-as.open` | 9.829% | 9.829% | 8.302 | 8.302 | `genuine-visual-mismatch` |
| `backstage-print.open` | 8.586% | 8.586% | 7.262 | 7.262 | `genuine-visual-mismatch` |

For reference, Wave 92's recorded baseline-to-final ratios were Home
`14.401% -> 14.029%`, Export `15.291% -> 13.543%`, Open `20.374% -> 18.497%`,
Save As `14.333% -> 9.829%`, and Print `9.516% -> 8.586%`.

## Residuals

The five rows remain genuine visual mismatches. Avalonia native control
templates and text rasterization still differ from WPF; Open's long recent
file rows remain visibly clipped by the intentionally fixed 560x600 viewport.
Avalonia Print continues to truthfully show deferred native-printer
capability instead of claiming WPF printer availability.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~FreeW.App.Avalonia.Tests.BackstageViewTests` - 35 passed.
- `dotnet build freew/tools/FreeW.DialogVisualHarness.Wpf/FreeW.DialogVisualHarness.Wpf.csproj --configuration Release --no-build` - succeeded, 0 warnings, 0 errors.
- `dotnet build freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj --configuration Release --no-restore` - succeeded, 0 warnings, 0 errors.
- Focused WPF authority capture - 5/5 captured.
- Focused Avalonia final capture - 5/5 captured.
- Focused comparison - 5/5 paired rows captured and classified `genuine-visual-mismatch`; the comparison tool's intentional exit code was 2.
