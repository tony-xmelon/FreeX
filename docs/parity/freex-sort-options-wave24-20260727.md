# FreeX Sort Options parity Wave 24

Date: 2026-07-27
Branch: `codex/freex-sort-options-wave24-20260727`
Surface: `dialog.SortOptions`

## Scope

Aligned the Avalonia Sort Options dialog to the authoritative WPF capture while
preserving the existing 330x260 window, localized choices, automation ids,
keyboard handling, and `SortDialogOptions` result mapping.

- Moved OK/Cancel into a real bottom-docked row.
- Matched the measured WPF footer buttons at 75x52 with 8px spacing.
- Replaced the dialog-local checkbox/radio templates with shared compact chrome.
- Reused shared dialog window, combo-box, group-box, and button resources, with
  the WPF-specific footer dimensions applied after shared normalization.

## Evidence

Fresh Avalonia evidence was captured from the production app in Ubuntu 24.04
Docker/Xvfb with `--parity-capture-surface dialog.SortOptions` and promoted to
`docs/parity/dialog-visual-assets/avalonia-capture/dialog.SortOptions.png`.
The frame is nonblank and exact-size at 330x260 pixels and 96 DPI.

The generated triage score improved from **0.110625** to **0.048680** (56.0%
reduction). The generated summary now ranks `dialog.SortOptions` below the top
outlier queue.

## Verification

- Avalonia Release build: 0 warnings, 0 errors.
- `DialogVisualParitySourceTests`: 5 passed.
- Dialog evidence summary generation and `-Check`: passed; 94/94 paired
  captured surfaces, 0 nonblank failures, 0 logical dimension mismatches.

## Residuals

The remaining score is native WPF versus Avalonia text rasterization and small
control-rendering differences. Raw PNG dimensions remain 495x390 for the WPF
144-DPI authority and 330x260 for Avalonia 96-DPI evidence; their logical sizes
match and the summary normalizes that capture-scale difference.
