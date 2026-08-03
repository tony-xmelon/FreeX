# Avalonia/WPF Parity Wave 118: FreeX Zoom

Date: 2026-08-03

## Audit Decision

The stale/current audit confirmed `dialog.Zoom` was a real product mismatch, so this wave stayed on Zoom rather than pivoting to Page Setup. The current Avalonia route was a plain vertical stack with clipped actions; the current WPF authority is a fixed `300x240` client surface with a Magnification group, two-column choices, compact radio rows, and a shared right-aligned action row.

## Production Change

- Added the WPF Zoom geometry contract to `ZoomDialogPlanner` and reused it in the Avalonia route and WPF client capture sizing.
- Corrected WPF client capture sizing to count the content element's margins as part of the client area instead of native window chrome. The live WPF layout now fits the declared `300x240` contract without cropping.
- Rebuilt Avalonia Zoom around the shared compact dialog chrome: WPF-style window, group box, compact radios, text box, button styling, and action row.
- Added a shared compact-radio height style metric. Zoom uses the WPF-aligned `16px` row height; the shared default remains `20px` for existing dialogs.
- Preserved preset, fit-selection, custom validation, keyboard, automation, and session-update behavior.

## Capture Provenance

Fresh captures were made from the current source before trusting the comparison. The Avalonia capture ran in Ubuntu 24.04 Docker with a manually managed Xvfb `:99` display. The final WPF and Avalonia frames are both `300x240` pixels at `96 DPI`, with matching logical dimensions.

- WPF final: `artifacts/wave118-final/wpf-full/dialog.Zoom.png`
- Avalonia final: `artifacts/wave118-final/avalonia/dialog.Zoom.png`
- Promoted WPF evidence: `docs/parity/dialog-visual-assets/wpf-capture/dialog.Zoom.png`
- Promoted Avalonia evidence: `docs/parity/dialog-visual-assets/avalonia-capture/dialog.Zoom.png`
- Final manifests record the 2026-08-03 WPF and Ubuntu 24.04 Docker/Xvfb provenance.

An intermediate Wave118 capture cropped the WPF authority to `300x240` and was rejected during integration review. Its metrics are withdrawn. The accepted evidence instead corrects the live WPF client geometry, then captures the complete surface directly at `300x240`; no authority image is cropped or post-processed.

## Metrics

The repository triage score is the normalized sample/luma/non-background/logical-size review score from `Generate-DialogVisualEvidenceSummary.ps1`; the parity comparer percentage is its separate mean-pixel-diff metric.

| Capture pair | Triage score | Mean pixel diff |
| --- | ---: | ---: |
| Committed Wave117/Round120 reference | `0.092952` | historical metric; WPF was `450x360@144 DPI` |
| Rejected cropped Wave118 intermediate | withdrawn | withdrawn |
| Final complete `300x240@96 DPI` pair | `0.035278` | `2.9664%` |

Generated evidence now reports the final Zoom row at `0.035278`, with equal raw and logical dimensions and no nonblank or expected-size failures.

## Residuals

- Both final images retain the full Magnification border and both action buttons inside the `300x240` frame; no clipping residual remains.
- Font rasterization and native-control antialiasing remain platform-specific.
- Avalonia's custom radio/text-box template retains a few pixels of horizontal spacing difference from WPF.
- The full parity comparer was run in `--skip-capture` mode against focused one-surface directories; its unrelated missing-surface and NameBox contract diagnostics are not Zoom failures.

## Verification

- `ZoomDialogPlannerTests`: 6 passed.
- `RemainingDialogTests.Zoom`: 10 passed, including a live-raster regression that checks the right group border and both buttons.
- `ZoomDialogSourceTests`: 2 passed.
- Dialog inventory, visual evidence summary, and cross-app dashboard generator checks passed.
