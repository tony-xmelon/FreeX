# FreeP imported Surface3D green face probe rejected - 2026-07-24

The post-blue current-main baseline for
`22-chart-baseline-depth.pptx` was refreshed before probing the next imported
3-by-3 Surface3D owner. PowerPoint's exact `#97BD80` mask had a main component
at `(796,177)-(934,221)` plus a small component at `(737,177)-(787,183)`.
WPF's corresponding connected mask was `(804,157)-(928,239)`, indicating that
the upper green face had a different footprint and shared-edge ownership.

A WPF-only replacement for the `series=1/category=1` green face used a measured
four-point polygon and preserved the shared `RenderFacets`/Avalonia path. It
was rejected after fresh consuming-artifact scoring:

- surface ROI: `4.8334% -> 5.3383%`;
- green ROI: `4.3089% -> 5.4224%`;
- whole slide: `2.4905% -> 2.5310%`;
- the green bbox moved closer but painted over the wrong neighboring material.

No product code from the probe remains. Rule: a closer exact-color bbox is not
enough for a Surface3D facet; shared projected edges and adjacent material
ownership must improve together. The next probe needs a topology/paint-order
model for the paired green regions rather than a single affine polygon.
