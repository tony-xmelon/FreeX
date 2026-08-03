# FreeW Backstage Export Parity, Wave 117

Date: 2026-08-03

## Scope And Authority

This slice closes the current Export pane renderer/evidence gap against the
WPF authority at the harness contract of 560x600. Export was selected over
Customize Theme Colors because fresh current captures showed a concrete
Backstage Export mismatch, while both current theme-color dialog routes were
already implemented through the shared planner and had no stronger fresh
Backstage-specific residual.

The shared `BackstagePaneSurfacePlanner` remains the semantic authority. Both
hosts expose the same 19 actions, including PDF, XPS, and the editable format
catalog, in the same order.

## Implementation

- Avalonia Export action labels now use explicit `TextBlock` button content,
  matching the `TextBlock` realized by the WPF default button template while
  preserving direct label activation and sibling descriptions.
- The Avalonia capture harness now reserves the observed 14-DIP neutral-host
  inset for this WPF authority surface. The previous 16-DIP compensation left
  two full-height transparent columns in the Avalonia comparison image.
- Focused Avalonia Backstage tests cover the Export labels, descriptions,
  action order, and shared geometry.

## Fresh Paired Evidence

Fresh artifacts are under ignored `artifacts/wave117-backstage-current`:

- WPF authority: `wpf/wpf_dialog_capture_manifest.json`
- Avalonia final: `avalonia-accepted/avalonia_dialog_capture_manifest.json`
- Comparison: `compare-accepted/freew_dialog_visual_comparison.json`

| Scenario | Previous changed pixels | Final changed pixels | Previous mean delta | Final mean delta | Final luminance similarity | Classification |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| `backstage-export.open` | 13.543% | 13.641% | 11.506 | 10.853 | 0.866073 | `genuine-visual-mismatch` |

Both captures are 560x600, pass the content gates, and report matching painted
bounds of 546x563. The final pair has identical action-order semantics and
pHash distance 12. The changed-pixel ratio is effectively flat; the meaningful
movement is the lower mean channel delta and matched painted width after
removing the capture-contract artifact.

## Verification And Residuals

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~FreeW.App.Avalonia.Tests.BackstageViewTests --logger "console;verbosity=minimal" -m:1` - 39 passed.
- `dotnet test freew/FreeW.App.Presentation.Tests/FreeW.App.Presentation.Tests.csproj --configuration Release --filter FullyQualifiedName~Backstage --logger "console;verbosity=minimal" -m:1` - 74 passed.
- WPF harness build - succeeded, 0 warnings, 0 errors.
- Avalonia harness build - succeeded, 0 warnings, 0 errors.
- Fresh WPF Export capture - 1/1 captured.
- Fresh Avalonia Export capture - 1/1 captured.
- Focused comparison - 1/1 paired row captured; expected `genuine-visual-mismatch` exit status.

Remaining pixels are framework text rasterization and native scrollbar-template
differences. No comparison threshold or classification was changed, and no
generated tracked inventory was refreshed because the source-hashed route
inventory remains current for this focused route.
