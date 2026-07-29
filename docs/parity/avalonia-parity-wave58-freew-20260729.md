# Wave 58 FreeW Avalonia/WPF Parity

Date: 2026-07-29
Base: `affa565fec4b037323c051205d54cd72f31564d6`

## Scope

This slice targets the shared FreeW dialog typography family. The WPF dialogs inherit the
shared compact shell font, while 38 Avalonia dialog-chrome declarations constructed a style
from `FontFamily.Default`. That lets the Linux host resolve a platform font with different
widths and rasterization, which is a direct source of cross-host visual drift in dialog labels,
button text, and field values.

The Avalonia dialogs now reuse `AvaloniaCompactDialogChrome.WindowsStyle`, preserving each
dialog's existing control-height, padding, and layout overrides. The WPF and Avalonia action
row contract is also consolidated in `AvaloniaDialogButtonRowFactory`; the FreeW page-layout
dialog family consumes that factory for OK/Cancel ordering, default/cancel semantics,
automation names, spacing, and metrics.

## Before / After

| Measure | Before | After |
| --- | ---: | ---: |
| Checked-in FreeW paired scenarios classified `genuine-visual-mismatch` | 171 | 171 |
| Mean changed-pixel ratio in checked-in comparison | 9.2775% | not regenerated |
| Mean absolute channel delta in checked-in comparison | 7.156 | not regenerated |
| Platform-default dialog-chrome font declarations | 38 | 0 |
| Avalonia source files normalized | 0 | 27 |
| Shared Avalonia OK/Cancel row implementation | local/shared helper split | one shared factory |

The 171-row and pixel values are the existing baseline from
`docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.json`. The paired capture
payloads are not present in this worktree, so this slice does not claim an after-capture pixel
reduction or relabel any comparison row. A fresh WPF/Avalonia capture run should be used to
measure the typography delta on the affected routes.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj -c Release --no-restore --filter "FullyQualifiedName~CommonDialogChromeParityTests|FullyQualifiedName~DialogChromeDedupSourceGuardTests"` - 13 passed.
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj -c Release --no-restore` - 1,420 passed, 0 failed, 0 skipped.
- `dotnet build freew/FreeW.App.Host/FreeW.App.Host.csproj -c Release` - succeeded, 0 warnings, 0 errors.

The full FreeW Avalonia test project rebuilt the affected shared shell and Avalonia application
projects successfully. No WPF behavior was changed; WPF remains the authority for the shared
dialog contract. A solution-wide `dotnet build FreeW.slnx -c Release --no-restore` was also
attempted but could not run to completion because 27 unrelated projects in the fresh worktree
had no restore assets; the direct WPF host build above restored and verified the WPF graph.

## Remaining Work

- Regenerate paired WPF/Avalonia captures when the capture payloads are available and record
  per-route pixel metrics for the normalized typography family.
- Continue with the remaining dialog visual families and the 171-row cross-host comparison;
  this slice does not claim overall FreeW visual parity.
