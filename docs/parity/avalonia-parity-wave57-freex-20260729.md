# FreeX Avalonia/WPF Parity Wave 57

Formula point-entry now supports Excel-style 3-D worksheet spans in both hosts. In formula Point
mode, click the first sheet tab, Shift-click the last sheet tab, then select a cell, range, whole
row, or whole column. The shared planner emits `Sheet1:Sheet3!A1` (or the corresponding range) and
quotes the complete sheet qualifier when either sheet name requires quoting.

Existing A1/R1C1 references, F4 cycling, F8/Shift+F8 multi-area selection, Ctrl+Arrow navigation,
cross-sheet references, and ordinary sheet grouping outside formula Point mode retain their prior
paths.
