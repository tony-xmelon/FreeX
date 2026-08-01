# FreeW Page Setup visual parity, Wave 94

Date: 2026-08-01

## Scope

Aligned the Avalonia Page Setup Layout-tab checkboxes with the WPF authority.
The dialog previously used the default Fluent checkbox template, which rendered
an oversized indicator. It now uses the shared compact WPF-style checkbox
template already used by other compact dialogs: a 13x13 indicator in an 18px
row, with the existing labels, values, margins, and interaction unchanged.

## Fresh paired evidence

The six WPF/Avalonia Page Setup states were recaptured at the harness's 560x600
frame. The report is:

`artifacts/parity-wave94-page-setup-post-20260801b/compare/freew_dialog_visual_comparison.html`

The before comparison reuses the pre-change Avalonia captures from the same
route pass:

`artifacts/parity-wave94-page-setup-post-20260801b/compare-before/freew_dialog_visual_comparison.html`

The Layout state improved from 10.087% to 7.086% changed pixels and from 6.505
to 5.157 mean absolute channel delta. Initial, populated, validation, Margins,
and Paper states were unchanged, as expected because they do not render the
affected controls.

## Verification

- `PageSetupDialogVisualParityTests`, `PageSetupDialogTests`, and
  `CommonDialogChromeParityTests`: **45/45 passed**.
- WPF paired captures: **6/6 captured**.
- Avalonia paired captures: **6/6 captured**.
- All 6 paired captures passed the pixel-content gate.
- `git diff --check`: passed.

## Residuals

All six states remain classified as genuine visual mismatches because native
WPF/Avalonia control rasterization, typography, focus treatment, and the WPF
authority's seeded state still contribute to the comparison. This slice does
not change planner semantics, paper presets, tab geometry, or native window
chrome.
