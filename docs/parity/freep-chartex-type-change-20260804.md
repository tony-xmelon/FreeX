# FreeP native ChartEx type changes - 2026-08-04

An imported native ChartEx chart is preserved as a native ChartEx part until the
user explicitly changes its chart type. Previously the command changed only the
model's `ChartType`; save still emitted the preserved ChartEx family, so a change
such as Histogram to Line had no functional effect.

`ReplaceChartDataCommand` now treats an explicit type transition as a conversion
to the modeled classic chart path: it clears the native ChartEx flag, layout id,
and preserved ChartEx payload before writing the new type. Undo restores all three
source-authority fields exactly. Data-only edits continue to use the bounded
single-series ChartEx synchronization path and do not detach the native family.

Focused command coverage verifies both the conversion and undo behavior. This is
not a claim of full live authoring for every ChartEx family; ambiguous native
families remain preserved until the user explicitly converts them to a modeled
classic type.
