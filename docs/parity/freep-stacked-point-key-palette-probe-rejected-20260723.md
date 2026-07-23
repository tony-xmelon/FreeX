# FreeP stacked point-key palette probe rejected

The current PowerPoint export of `22-chart-baseline-depth.pptx` contains additional exact
palette colors around the 100%-stacked chart's data-label keys. A guarded probe applied those
colors only to the imported `Actual`/`Forecast`, Q1-Q3, implicit-default chart signature. It did
not alter bar fills, Surface3D geometry, or other chart families.

Fresh matching evidence after rebuilding the consuming `FreeP.RenderCompare` artifact:

- WPF whole-page mean RGB delta: `2.5856% -> 2.5867%`.
- Avalonia whole-page mean RGB delta: `1.0919% -> 1.0919%`.
- PowerPoint export was byte-identical across the before/after captures.

The source color observation is therefore not sufficient for a palette-only fix. The remaining
owner is the data-label key's registration/rasterization or a broader chart-style layer. The
candidate was reverted; ordinary series fills and unrelated chart controls remain unchanged.
