# FreeW Find/Replace Parity Wave 94

Scope: bounded Avalonia alignment for the WPF-authoritative Find/Replace dialog and its modeless reactivation path.

## Changes

- Matched the WPF dialog width at 420px.
- Matched WPF outer, action-row, section, separator, and status spacing.
- Matched WPF status text treatment and removed Avalonia-only empty-field placeholder text.
- Reused `AvaloniaCompactDialogChrome.FocusAndSelect` when switching between Find and Replace modes, matching WPF `DialogFocus.FocusAndSelect`.
- Added a source guard covering the shared visible metrics and reactivation contract.

## Evidence

Fresh paired WPF/Avalonia captures were rendered at the harness target of 560x600 logical pixels. Each host passed the nonblank/content gate.

| State | Prior checked baseline | Wave 94 fresh result | Mean channel delta | P95 delta |
| --- | ---: | ---: | ---: | ---: |
| initial | 7.8673% | 7.2280% | 4.5234 | 22 |
| populated | not previously recorded for this slice | 7.2777% | 4.5832 | 26 |
| validation-error | not previously recorded for this slice | 7.3369% | 4.6724 | 29 |

The prior checked baseline is recorded in `docs/parity/freew-find-replace-wave29-20260727.md`. The remaining delta is a genuine visual mismatch, primarily Avalonia/WPF text rasterization and native control template rendering.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~FindReplaceDialogPolicySourceGuardTests|FullyQualifiedName~RevealFormattingAndFindReplaceTests.FindReplaceDialog_reuse_updates_open_mode_for_both_shortcuts" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
- Result: 3 passed, 0 failed.
- Focused WPF/Avalonia harness captures and comparison completed for all three states under `artifacts/freew-find-replace-wave94-20260801`.

## Residuals

- The paired screenshots remain above a strict pixel-parity threshold because Avalonia and WPF rasterize text and native controls differently.
- No broader dialog-family changes are included in this slice.
