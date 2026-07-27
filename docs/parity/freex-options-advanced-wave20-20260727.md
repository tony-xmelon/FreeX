# FreeX Options Advanced Wave 20

## Scope

This slice aligns the Avalonia Options Advanced page with the current WPF authority and closes two functional host differences.

- AutoComplete for cell values is editable and persisted.
- Objects display is editable and persisted.
- WPF and Avalonia consume shared category, content, footer, control, and Advanced-page geometry metrics.
- The WPF parity harness captures the shared client frame rather than the native outer window.

The fill-handle setting remains disabled in both hosts because that option is not yet represented by the shared application options model.

## Evidence

- WPF: `docs/parity/dialog-visual-assets/wpf-capture/dialog.Options.Advanced.png`
- Avalonia: `docs/parity/dialog-visual-assets/avalonia-capture/dialog.Options.Advanced.png`
- Both promoted frames are fresh, nonblank, and 744x521 logical pixels at 96 DPI.
- WPF was captured directly on Windows after measuring native window chrome and sizing the Options client frame.
- Avalonia was captured from the production Linux app in Ubuntu 24.04 Docker/Xvfb with `--parity-capture-surface dialog.Options.Advanced`.

The deterministic visual triage score improved from **0.122002** to **0.041042**, a **66.4% reduction**. Final components are:

- sample mean delta: `0.027753`
- luma delta: `0.004056`
- non-background delta: `0.008955`
- logical dimension match: `true`

## Verification

- Options planner and source tests: 37 passed.
- WPF capture contract tests: 3 passed.
- WPF Release build: 0 warnings, 0 errors.
- Avalonia self-contained `linux-x64` publish: succeeded.
- Linux Docker/Xvfb production capture: succeeded.
- WPF capture footer evidence includes the full 46 px footer and visible 80x26 OK and Cancel buttons.

## Residuals

The remaining image delta is primarily native WPF/Avalonia text rasterization, checkbox and combo-box chrome, and small category-row metric differences. The generated score is a review-prioritization metric, not a pixel-parity pass threshold.
