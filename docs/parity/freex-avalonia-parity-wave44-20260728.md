# FreeX Avalonia Parity Wave 44

Date: 2026-07-28

## Functional slice

The shared FreeX application options model now persists
`EnableFillHandleAndCellDragAndDrop`, defaulting to enabled for compatibility with
existing settings. WPF and Avalonia Options > Advanced controls read and save the
same setting.

Both hosts now apply the setting to the actual pointer gestures:

- the autofill handle is hidden and cannot be hit or dragged when disabled;
- selection-border cell move/copy dragging is unavailable when disabled;
- keyboard and ribbon fill commands remain available;
- WPF and Avalonia consume the same persisted option rather than maintaining
  separate host-local policy.

## Validation

- `FreeX.App.Services.Tests` AppOptionsStore lane: 7/7 passed.
- `FreeX.App.Host.Tests` options/persistence lane: 70/70 passed.
- `FreeX.App.UI.Tests` GridView autofill lane: 7/7 passed.
- `FreeX.App.Avalonia.Tests` options/input lane: 15/15 passed.
- Release compilation completed for every focused test project with the
  low-resource foreground command policy.

## Residuals

This slice does not claim full visual parity for the broader FreeX application;
remaining work is the established paired WPF/Avalonia visual review and deeper
interactive evidence outside this option and its two pointer gesture paths.
