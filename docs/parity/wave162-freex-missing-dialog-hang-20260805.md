# Wave162 FreeX Avalonia missing parity dialog lifecycle

Date: 2026-08-06

## Diagnosis

The default Avalonia parity lane stalled on `dialog.ChartStyleDialog` after the preceding
`HeaderFooterPictureFormatDialog` row completed. The isolated Chart Style row reproduced the stall
with a 30-second VSTest hang detector: `dialog.ChartStyle.png` was created but remained zero bytes,
placing the failure in the headless visual capture/save lifecycle while the modal was still open.

WPF authority is `ChartStyleDialog`: its `Loaded` handler focuses the gallery control itself before
the real `ShowDialog()` capture. Avalonia instead focused the checked `RadioButton` inside the
scrollable gallery, which could request a re-entrant bring-into-view/layout pass during
`RenderTargetBitmap` capture.

## Implemented

- Made the Avalonia Chart Style scroll host focusable and focused that gallery host on `Opened`, matching
  the WPF gallery-level focus contract.
- Strengthened `MissingParityDialogsTests` cleanup so every owned modal is closed before its owner, even
  when capture assertions fail. This prevents the preceding theory row from leaking dialog state into the
  next row.

## Evidence

- Pre-fix isolated `DisplayName~ChartStyleDialog` run: reproduced the hang; `--blame-hang-timeout 30s`
  produced a VSTest hang dump and aborted the test host cleanly.
- Post-fix isolated Chart Style row: **1 passed** on the build run, then **1 passed** twice more, each
  with `--blame-hang-timeout 30s`.
- `MissingParityDialogsTests`: **4 passed, 0 failed, 0 skipped**, including Header/Footer Picture,
  Chart Style, and Unhide Window captures.

## Residuals

The full default Avalonia lane was not rerun in this focused fix. The requested bounded remainder proof
excluding `ParityCaptureTests` and `MissingParityDialogsTests` remains a separate broad run; no dialog
surface was skipped or reclassified.
