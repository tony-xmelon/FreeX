# FreeP native ChartEx title overlay parity

## Scope

Native ChartEx titles now preserve the existing `ChartShape.TitleOverlay`
contract through package read/write. The reader maps `cx:title/@overlay` to the
shared nullable model value, and the writer updates preserved titles or emits
the explicit `0`/`1` token for newly authored titles. An absent source token
remains absent, while existing WPF/Avalonia chart-options and undo behavior
continue to use the same model command.

This closes a functional persistence gap: changing the title overlay state on
a native ChartEx chart no longer appears to succeed only in memory and then
silently disappears on save/reopen.

## Verification

- Native ChartEx title style/overlay round-trip: 1/1
- Full WPF `ChartTests`: 122/122
- Presentation ChartEx contracts: 5/5
- WPF Host Release build: 0 warnings/errors
- Avalonia Release build: 0 warnings/errors

The change is package/function parity evidence; it does not claim a new raster
calibration or full ChartEx layout-family implementation.
