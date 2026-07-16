# FreeP Imported Chart Axis Strokes

Date: 2026-07-16

## Scope

Match the PowerPoint axis-tick stroke used by imported cartesian charts in
`06-charts.pptx` without changing authored charts or the existing imported
combo-chart contract.

## Change

`ChartRenderPlanner` now recognizes imported non-pie, non-combo cartesian
charts from the Office text-metrics signature and uses the measured PowerPoint
axis stroke `#898989` at `0.75` thickness. Classic Office charts and imported
combo charts continue to use the existing black stroke; authored-chart
defaults remain unchanged.

The PowerPoint reference was sampled directly at the aligned axis ticks and
returned RGB `137,137,137`. At the time of this slice, gridline placement and
the `#D9D9D9` default remained a separate residual. That residual was closed
by the follow-up `freep-imported-cartesian-grid-stroke-fidelity-20260716.md`,
which applies the measured full-width grid stroke and pixel offset.

## Verification

- Focused chart tests: `181 passed, 0 failed`.
- Renderer build: `0 warnings, 0 errors`.
- WPF diffs against the PowerPoint reference at `1280x720`:
  - slides 1-4: `2.3378%`, `1.8319%`, `0.6601%`, `1.5290%`.
- Avalonia diffs against the PowerPoint reference at `1280x720`:
  - slides 1-4: `2.4085%`, `1.8648%`, `0.6696%`, `1.5736%`.

Evidence artifacts are under:

- `artifacts/freep-imported-chart-strokes-20260716/final2-wpf/`
- `artifacts/freep-imported-chart-strokes-20260716/final2-avalonia/`

