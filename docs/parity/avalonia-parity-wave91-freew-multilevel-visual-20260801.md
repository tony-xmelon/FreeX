# FreeW Multilevel List Visual Parity Wave 91

Date: 2026-08-01

Scope: the FreeW Define New Multilevel List dialog only. The WPF prompt in
`freew/FreeW.App.Host/MultilevelListDialog.cs` remains the visual authority;
the shared planner and comparison thresholds were not changed.

## Change

The Avalonia route now reapplies its route-owned chrome after the base dialog
window's shared chrome hook, so the rendered controls retain the WPF-sized
metrics instead of being expanded by the default Avalonia template. The route
uses 22-pixel combo boxes, 18-pixel text boxes, 20-pixel buttons, WPF field
spacing, a WPF-style combo gradient and border, and the authority's terminal
action-row alignment. Accessibility names, default/cancel actions, validation
focus and planner behavior are unchanged.

The Avalonia harness has a route-scoped one-pixel client-width compensation for
this static prompt. This accounts for the right-edge client pixel retained by
the WPF RenderTargetBitmap capture and does not alter shared frame handling or
comparison logic.

## Fresh Metrics

Fresh paired captures were generated under:

- Before: `C:\Users\anton\AppData\Local\Temp\frex-wave91-multilevel-baseline-20260801-01`
- After: `C:\Users\anton\AppData\Local\Temp\frex-wave91-multilevel-after-20260801-06`

The WPF authority was captured fresh before the before/after comparison. The
baseline reproduced the reported genuine mismatches:

| Scenario | Before classification | Before changed ratio | Before mean delta | After classification | After changed ratio | After mean delta |
| --- | --- | ---: | ---: | --- | ---: | ---: |
| `initial` | genuine-visual-mismatch | 13.50% | 8.65 | pass | 2.77% | 2.45 |
| `populated` | genuine-visual-mismatch | 13.50% | 8.65 | pass | 2.77% | 2.45 |
| `validation-error` | genuine-visual-mismatch | 13.65% | 8.85 | pass | 2.92% | 2.65 |

The final comparison exited successfully with all three rows classified as
`pass`. WPF content bounds remained `x=0,y=0,366x366`; Avalonia painted bounds
were `x=14,y=18,337x333`. The latter residual reflects the transparent native
frame reserved by the Avalonia capture and the dialog's 14-pixel content
margin, not a row/control displacement.

## Verification

Focused test:

`dotnet test freew\\FreeW.App.Avalonia.Tests\\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~MultilevelListDialogVisualParityTests`

Result: 3 passed.

The focused WPF/Avalonia capture and comparison commands were run through
`FreeW.DialogVisualHarness` for the three multilevel-list states. No Docker or
background process was used.
