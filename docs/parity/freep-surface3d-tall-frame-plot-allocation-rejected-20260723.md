# FreeP Tall Surface3D Plot Allocation Probe Rejected

The 26-deck tall imported Surface3D reference has a wrapped title whose text
is already aligned, while the projected frame begins at a different raw raster
band than FreeP. A signature-guarded probe moved the plot top from the existing
`bounds.Y + 57` to `bounds.Y + 84` and reduced its height reservation from
`bounds.Height - 99` to `bounds.Height - 138`.

The probe was active in the consuming Release artifact, but it failed the
feature-owner gate:

- WPF whole page: `2.7190% -> 2.7158%`.
- WPF surface ROI `(580,90)-(1020,330)`: `6.4579% -> 6.5204%`.
- Avalonia whole page: `2.4792% -> 2.4849%`.
- Avalonia surface ROI: `6.3787% -> 6.5076%`.

The whole-page movement was therefore redistribution from the chart frame, not
Surface3D parity. The code was restored. The remaining tall-frame owner is the
imported mesh/facet projection, not a global title or plot-band allocation.
