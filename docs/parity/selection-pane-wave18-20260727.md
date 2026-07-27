# Selection Pane Wave 18 Evidence

Fresh same-size captures were produced on 2026-07-27 from the current WPF and Avalonia sources:

- WPF: `dialog.SelectionPane.png`, 520x440 px at 96 DPI.
- Avalonia: `dialog.SelectionPane.png`, 520x440 px at 96 DPI.

The fresh pair was compared with `FreeX.ParityCompare` using the same surface manifests. The checked-in pair measured `3.0179%` changed pixels; the fresh pair measured `2.2279%`, an absolute reduction of `0.7900` percentage points (`26.18%` relative). This is a visual diff metric, not a claim of pixel identity; framework text rasterization and control rendering still account for the residual.

The WPF focused selector does not support Selection Pane, so the WPF image came from the full parity capture lane. Avalonia used the focused `dialog.SelectionPane` capture selector.
