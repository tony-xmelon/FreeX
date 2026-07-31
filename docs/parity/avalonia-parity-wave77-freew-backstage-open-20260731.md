# Avalonia parity Wave 77: FreeW Backstage Open

Date: 2026-07-31

## Scope

Refresh only the `backstage-open.open` WPF/Avalonia evidence route and lock the
existing WPF-authority Open-pane contract with focused Avalonia coverage.

The production Open surface already uses the WPF-equivalent direct action
buttons, selected-tab materialization, and shared pane planner. The new test
locks the two tab labels, initial selected tab, and selected-content host shape
alongside the existing direct-button action-order assertion.

## Evidence

| Metric | Checked-in report | Fresh route capture |
| --- | ---: | ---: |
| Changed-pixel ratio | 20.6863% | 20.8857% |
| Mean absolute channel delta | 17.820 | 18.104 |
| Luminance similarity | 0.821268 | 0.819674 |
| Perceptual hash distance | 8 | 10 |
| Semantic difference | `action-button-order` | none |
| Classification | `genuine-visual-mismatch` | `genuine-visual-mismatch` |

Both captures passed the 560x600 content gate. WPF and Avalonia expose the
same action order: the eight document actions followed by `This PC`, `Browse`,
and `Recover Unsaved Documents`.

The remaining visual mismatch is an honest cross-toolkit raster/template
residual in text, tab, scrollbar, and anti-aliasing pixels. No visual cutoff
was changed and no unrelated report row was regenerated: all non-Open rows
remain byte-for-byte unchanged.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~FreeW.App.Avalonia.Tests.BackstageViewTests`
- WPF route capture with `--scenario wpf.backstage-open.open`
- Avalonia route capture with `--scenario avalonia.backstage-open.open`
- Comparison merge with `--baseline docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.json --refresh-route backstage-open`
