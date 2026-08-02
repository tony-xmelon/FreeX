# Avalonia Parity Wave113: FreeX Add-ins

## Scope

- FreeX `dialog.Options.AddIns` against the WPF `OptionsDialog` authority.
- Options dialog implementation, shared planner metrics, focused tests, and AddIns-specific visual evidence only.

## Delivered

- Added shared AddIns section and button metrics to `OptionsDialogPlanner`.
- Matched Avalonia's AddIns header/rule rhythm and explicit description/button spacing to the WPF XAML.
- Restored WPF-equivalent black description text and an enabled 70x26 `Go...` button.
- Routed Avalonia activation to the localized Office Add-ins deferred message in an owned modal and assigned `AddInsGoButton` automation metadata.
- Enabled focused WPF capture selection for `dialog.Options.AddIns`.
- Added focused WPF and Avalonia source-contract coverage for geometry, state, routing, and capture selection.

## Fresh Evidence

- WPF: `docs/parity/dialog-visual-assets/wpf-capture/dialog.Options.AddIns.png`, captured from current `FreeX.App.Host --parity-capture --parity-capture-target dialog.Options.AddIns`.
- Avalonia: `docs/parity/dialog-visual-assets/avalonia-capture/dialog.Options.AddIns.png`, captured from the current self-contained Linux app in Ubuntu 24.04 Docker/Xvfb with `--parity-capture --parity-capture-surface dialog.Options.AddIns`.
- Both captures are nonblank and `744x521` pixels at the canonical 96-DPI logical frame.
- Regenerated summary: `docs/parity/dialog-visual-evidence-summary.json` and `.md`.

| Metric | Before | Wave113 | Change |
| --- | ---: | ---: | ---: |
| AddIns triage score | 0.097051 | 0.012806 | -86.8% |
| Sample mean delta | 0.015054 | 0.007436 | lower |
| Luma delta | 0.005817 | 0.001722 | lower |
| Non-background delta | 0.075901 | 0.003369 | lower |
| Logical dimensions | 744x521 / 744x521 | 744x521 / 744x521 | matched |

## Verification

- Avalonia focused source test passed: `AddIns_UsesWpfGeometryAndEnabledOwnedDeferredRoute`.
- WPF focused source test passed: `OptionsDialog_AddInsMatchesTheWpfSectionAndDeferredActionContract`.
- WPF host Release build passed with 0 warnings and 0 errors.
- Generated dialog evidence summary passed: 94/94 paired surfaces, 0 nonblank failures, 0 dimension mismatches.

## Remaining

The remaining `0.012806` triage score is consistent with Linux versus WPF text rasterization and native control rendering. The paired frame is dimension-matched, the AddIns structure and enabled action state are aligned, and no further AddIns layout discrepancy was evident in the fresh captures.
