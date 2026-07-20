# FreeP Chart Axis Display Token Retention

## Scope

Imported chart axes now retain the authored OOXML display tokens that were
previously discarded and replaced by writer defaults:

- `c:majorTickMark`
- `c:minorTickMark`
- `c:tickLblPos`
- `c:lblOffset`
- `c:noMultiLvlLbl`

The values are preserved through the chart model, cloning, and PPTX
read/write. Unspecified values remain unset, so existing renderer defaults and
new-chart output are unchanged. This is a package/function parity slice; it
does not claim a new raster calibration for chart axes.

## Evidence

- `ChartTests` focused host lane: `88/88` compile-first and `88/88` no-build.
- Chart presentation/corpus lane: `206/206` compile-first and `206/206`
  no-build.
- `FreeP.RenderCompare` Release build: `0` warnings, `0` errors.
- Fresh PowerPoint COM exports: `19-chart-labels` `3/3`; `18-chart-types`
  `4/4`.
- Fresh WPF averages remained `1.2707%` for `19-chart-labels` and `0.7585%`
  for `18-chart-types`; no renderer path consumes absent metadata.
