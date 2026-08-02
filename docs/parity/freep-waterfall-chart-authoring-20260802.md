# FreeP Waterfall Chart Authoring

Date: 2026-08-02

## Scope

PowerPoint Waterfall charts were previously admitted only through the generic/unknown chart fallback. This slice adds the shared functional path:

- `ChartType.Waterfall` is preserved in the model and package chart XML as `c:waterfallChart`.
- Insert Chart creates an editable single Value series with signed increments.
- Edit Chart Data exposes Waterfall as a chart-type option.
- The shared planner computes cumulative start/end levels and emits centered waterfall bars.
- WPF and Avalonia consume the same renderer-neutral rectangle primitives.

This is function-first coverage for a single-series 2-D Waterfall. It does not claim full PowerPoint parity for totals/subtotals, connector styling, data labels, 3-D effects, or imported advanced formatting.

## Verification

- Presentation focused chart/editor tests: `305/305`
- WPF ChartTests: `104/104`
- Avalonia Release application build: `0 warnings, 0 errors`
- Waterfall package round-trip: native `c:waterfallChart`, categories, and signed values preserved

## Deferred

PowerPoint-specific total/subtotal points, connector/outline styling, labels, and advanced Waterfall formatting remain in the richer chart-semantics backlog.
