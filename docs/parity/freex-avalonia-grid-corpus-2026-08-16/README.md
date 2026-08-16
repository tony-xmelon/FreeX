# FreeX Avalonia grid corpus — 2026-08-16

This bundle closes the renderer-coverage gap in the Excel range corpus: the
current-source chart, cell-style, and native PivotTable fixtures now have
retained Avalonia grid captures in addition to the established WPF/Excel
`FreeX.SheetGridImageCompare` lane.

| Family | Current-source fixtures | Captured surfaces |
| --- | ---: | ---: |
| Charts | 8 | 8 |
| Cell styles | 7 | 7 |
| Native PivotTables | 16 | 20 |
| Total | 31 | 35 |

The PivotTable count is higher than its fixture count because the layout
matrix, shared-cache, and show-values-as variants each contain multiple native
PivotTable ranges. Each capture records the explicit worksheet and Excel
`TableRange2` coordinates used by the matching WPF/Excel run.

Run `tools/Test-FreeXAvaloniaGridCorpusEvidence.ps1` to verify the tracked
manifest, files, and hashes. The captures establish current renderer and
corpus coverage. They deliberately do not create raw-pixel Office acceptance
metrics because the Avalonia range host renders at its own native geometry.

The original `Excel_native_pivot_slicer_timeline_001` fixture did load and
capture in both renderer lanes. Its separate FreeX-save/Open XML timeline
validation failure is not represented as a missing visual-capture surface.
