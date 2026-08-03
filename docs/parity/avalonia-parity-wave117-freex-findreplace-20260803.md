# Avalonia Find/Replace Parity Wave117 - 2026-08-03

## Scope

FreeX Find/Replace now models the WPF tab host's natural height per selected tab through
`FindReplaceDialogPlanner`: 74 DIPs for Find and 108 DIPs for Replace. Avalonia updates
the fixed host height when the tab changes; WPF XAML and Find/Replace behavior remain the
authority and are unchanged.

## Current evidence

Fresh current-source captures were taken at the shared 720x430 client size:

- WPF: `docs/parity/dialog-visual-assets/wpf-capture/`
- Avalonia: `docs/parity/dialog-visual-assets/avalonia-capture/`, from Ubuntu 24.04 Docker/Xvfb
- Manifest provenance: `docs/parity/dialog-visual-assets/{wpf-capture,avalonia-capture}/manifest.json`

All three surfaces (`dialog.FindReplace`, `.Find`, `.Replace`) are present, nonblank, and
dimension-matched. The focused visual compare measured 1.569230% for default/Find and
2.277002% for Replace, with zero hard regressions at the 5% threshold. The pre-fix fresh
pair measured 2.311486%, 2.311486%, and 2.277002%; the intermediate single-height attempt
was rejected because it clipped the Replace tab and was not promoted.

## Verification

- `FreeX.App.Services.Tests`: 33 focused planner tests passed.
- `FreeX.App.Avalonia.Tests`: 8 focused dialog visual-source tests passed.
- WPF Release build and Avalonia Linux self-contained publish: zero warnings/errors.
- Generated dialog summary: 94 paired surfaces, zero nonblank failures, zero expected-size mismatches.

## Residuals

Remaining deltas are native Avalonia/WPF text, textbox, button, tab, and list-control
rasterization differences. The focused three-surface compare intentionally lacks the
repository-wide `popup.nameBoxDropdown` pair, so its name-box contract reports a failure;
that is a harness-scope limitation, not a Find/Replace surface absence.
