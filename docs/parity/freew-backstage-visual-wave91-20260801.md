# FreeW Backstage Visual Parity Wave 91

Date: 2026-08-01
Base: `0ffec009b42f328f68cf3fe5251c591d1c4e32bf` (`Complete Avalonia parity Wave 90 integration`)

## Scope And Authority

This slice uses the real FreeW WPF and Avalonia Backstage builders as the
authority and keeps the existing five paired harness scenarios:

- `backstage-home.open`
- `backstage-export.open`
- `backstage-open.open`
- `backstage-save-as.open`
- `backstage-print.open`

The paired harness captures the pane in a neutral 560x600 host. The outer
Backstage rail is outside these comparisons. Comparison thresholds and
classifications were not changed.

## Implementation

- Matched WPF Open tab composition by placing the document and folder panels
  in `TabItem.Content`, removing the extra Avalonia content host, and applying
  the existing classic Windows tab chrome with Segoe UI 12 px and 24 px tab
  metrics.
- Removed Avalonia-only 4 px and 6 px stack spacing from Open and Print rows;
  matched the WPF Print evidence margin and row spacing.
- Matched WPF Print action rows with an outer stack containing a direct link
  button and a sibling 11 px description, and stretched Home action buttons as
  WPF does.
- Reduced Save As text and type controls to the WPF compact metrics: 18 px
  filename input and 22 px type selector, with compact padding and centered
  selector content.
- Kept Export action geometry unchanged after source audit because its current
  Avalonia builder already matches the WPF action-row layout, typography,
  colors, and wrapping; the fresh metric is stable rather than artificially
  perturbed.
- Added headless assertions for Open tab ownership and spacing, Print row
  structure, Home action stretch, and Save As control metrics.

## Fresh Paired Evidence

Fresh WPF authority captures are in
`artifacts/freew-backstage-wave91-before-wpf`.
Fresh final Avalonia captures are in
`artifacts/freew-backstage-wave91-final-avalonia2`.
The focused five-scenario comparison is in
`artifacts/freew-backstage-wave91-final-compare2`.

The Before columns are the checked Wave 90 final metrics from
`freew-backstage-visual-wave90-20260801.md`, using the same 560x600 harness
contract. After columns are the fresh Wave 91 pair from this worktree.

| Scenario | Before changed ratio | After changed ratio | Before mean delta | After mean delta | Mean improvement |
| --- | ---: | ---: | ---: | ---: | ---: |
| `backstage-home.open` | 14.486% | 13.068% | 12.326 | 11.315 | 1.011 |
| `backstage-export.open` | 15.291% | 15.291% | 12.282 | 12.282 | 0.000 |
| `backstage-open.open` | 19.002% | 16.370% | 16.872 | 14.078 | 2.794 |
| `backstage-save-as.open` | 14.372% | 14.333% | 11.405 | 11.339 | 0.066 |
| `backstage-print.open` | 13.199% | 9.516% | 10.289 | 7.913 | 2.376 |

All ten fresh captures are 560x600 and pass both WPF and Avalonia content
gates. All five paired rows remain `genuine-visual-mismatch`. The remaining
delta is framework text rasterization, native control templating, scrollbar
chrome, and other toolkit rendering variance; it is not classified as a
threshold or platform exemption.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~FreeW.App.Avalonia.Tests.BackstageViewTests --logger "console;verbosity=minimal"` - 34 passed.
- `dotnet build freew/tools/FreeW.DialogVisualHarness.Wpf/FreeW.DialogVisualHarness.Wpf.csproj --configuration Release` - succeeded, 0 warnings, 0 errors.
- Five targeted WPF captures through `FreeW.DialogVisualHarness.Wpf` - 5/5 captured.
- `dotnet build freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj --configuration Release --no-restore` - succeeded, 0 warnings, 0 errors.
- Five targeted Avalonia captures through `FreeW.DialogVisualHarness.Avalonia` - 5/5 captured.
- Focused comparison through `FreeW.DialogVisualHarness` - 5/5 paired rows captured and classified `genuine-visual-mismatch`; the command returns exit code 2 because genuine mismatches are intentionally non-zero.

## Residuals

- Export is unchanged in this slice because the current WPF/Avalonia action
  row structures are already aligned; its row remains a genuine visual
  mismatch from raster and native template variance.
- No attempt was made to change comparison math, thresholds, or
  classifications.
- The full inventory comparison was not used as the acceptance command because
  only these five paired scenarios were captured; the focused inventory keeps
  unrelated uncaptured routes out of the result.
