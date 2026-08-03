# Avalonia Parity Wave131: FreeW Legal Notices

Date: 2026-08-03
Scope: FreeW Legal Notices visual family and shared FreeX/FreeW Avalonia ownership
Authority: fresh current-source WPF `SharedLegalNoticesDialog` captures
Decision: bounded shared-component deduplication; visual residuals remain genuine

## Baseline and diagnosis

Fresh baseline evidence was captured before editing in
`%TEMP%/FreeW-Wave131-Legal-Baseline-20260803/`: WPF `190/190`, Avalonia `288/288`,
and all six Legal Notices pairs captured successfully. The WPF and Avalonia structures
preserve the same five ordered tabs, document content, read-only text surface, Close
button, focus target, and automation IDs. The remaining changed pixels are concentrated
in Avalonia/Skia versus WPF text rasterization, native template pixels, and the one-pixel
content registration already documented by Waves 122 and 125.

The ownership audit found shared WPF rendering consumed by FreeX and FreeW, shared
Avalonia rendering consumed by FreeW, and a second FreeX Avalonia Legal Notices dialog
implemented inside `MainWindow.cs`. FreeP has no Legal Notices surface. This wave removes
the FreeX Avalonia duplication without changing FreeW's existing native text-tab behavior.

## Change

- `AvaloniaLegalNoticesDialog` now accepts localized read-only and tab help text plus the
  FreeX `AcceptsTab` choice, and exposes the shared Enter/Escape/Tab-cycle lifecycle.
- FreeX Avalonia now uses a thin localized `LegalNoticesDialog` adapter over the shared
  component; its previous in-`MainWindow.cs` construction, tab factory, and automation-ID
  helper are removed.
- The shared keyboard lifecycle is opt-in. FreeW remains on its established native
  read-only `Tab` behavior; FreeX explicitly enables the lifecycle it previously owned.
- WPF geometry, content, tab order, localization, automation, and semantic behavior are
  unchanged. `semanticDifference` remains null for every refreshed pair.

## Fresh paired metrics

The post-change focused capture is retained at
`%TEMP%/FreeW-Wave131-Legal-Post-20260803/` and refreshed the canonical report at
`docs/parity/freew-dialog-harness/`. The small third-party-license delta is capture
rasterization noise, not a claimed visual improvement.

| State | Fresh baseline changed | Post changed | Baseline mean | Post mean | Classification |
| --- | ---: | ---: | ---: | ---: | --- |
| `initial` | 9.197% | 9.197% | 9.768 | 9.768 | genuine-visual-mismatch |
| `tab-project-license` | 9.197% | 9.197% | 9.768 | 9.768 | genuine-visual-mismatch |
| `tab-legal-notices` | 18.008% | 18.008% | 18.730 | 18.730 | genuine-visual-mismatch |
| `tab-privacy-notice` | 16.682% | 16.682% | 18.674 | 18.674 | genuine-visual-mismatch |
| `tab-third-party-notices` | 17.832% | 17.832% | 19.190 | 19.190 | genuine-visual-mismatch |
| `tab-third-party-license-texts` | 18.193% | 18.191% | 20.033 | 20.028 | genuine-visual-mismatch |

Both focused runs were `6/6` captured. All six rows retain `semanticDifference: null`.
No comparator threshold or classification was changed.

## Verification

- Focused harness restores and Release builds: passed, 0 warnings, 0 errors.
- FreeX Avalonia Release build: passed, 0 warnings, 0 errors.
- `FreeW.App.Avalonia.Tests` filtered `LegalNoticesDialogVisualParityTests`: `12/12` passed.
- `FreeX.App.Avalonia.Tests` filtered `LegalNoticesKeyboardLifecycleTests`: `2/2` passed.
- Fresh focused WPF capture: `6/6` captured.
- Fresh focused Avalonia capture: `6/6` captured.
- Focused comparison: `6` genuine visual mismatches, no semantic differences.
- Canonical comparison refresh: `478` scenarios, `158` genuine visual mismatches,
  `25` passes, `105` Avalonia extensions, `7` state-not-applicable.

Residuals are limited to cross-framework glyph rasterization, native tab/scrollbar/text
template pixels, and the one-pixel content registration. No dashboard or external worktree
was edited, and no build-server shutdown was run.
