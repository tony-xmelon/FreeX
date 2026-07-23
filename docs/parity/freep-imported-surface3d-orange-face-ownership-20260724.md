# FreeP imported Surface3D orange face ownership - 2026-07-24

The canonical imported 3-by-3 Surface3D in
`22-chart-baseline-depth.pptx` already had a WPF-only blue-face ownership
correction. The adjacent light-orange `series=0/category=0` face still had a
different projected footprint from PowerPoint. Its exact `#F18032` mask was:

- PowerPoint: `3858 px`, bbox `(604,185)-(787,228)`;
- WPF before: `3421 px`, bbox `(628,187)-(793,240)`.

The WPF render-only facet path now replaces that face with the measured
PowerPoint polygon in its original painter slot. The shared logical
`RenderFacets` mesh and Avalonia path remain unchanged; the same exact imported
value/frame guard used by the blue correction still limits the WPF branch to
the canonical `360x189` plot.

Fresh current-main evidence at 1280x720:

- WPF whole slide: `2.4905% -> 2.4862%`;
- surface ROI: `4.8334% -> 4.7811%`;
- orange ROI: `4.7449% -> 4.5916%`;
- orange mask: `3421 px`, bbox `(628,187)-(793,240)` -> `3531 px`,
  bbox `(609,185)-(786,227)`;
- PowerPoint orange mask: `3858 px`, bbox `(604,185)-(787,228)`;
- Avalonia candidate PNG: byte-stable;
- tall-frame WPF control: byte-stable;
- authored View3D control: `2.9318%`, unchanged;
- `24-run-baseline-wrap`: `0.6948%`, unchanged.

Focused `ChartBaselineCorpusTests`: `31/31`. The consuming
`FreeP.RenderCompare` Release build completed with `0` warnings and `0`
errors.
