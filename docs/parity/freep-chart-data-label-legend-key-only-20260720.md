# FreeP chart data-label legend-key-only parity

## Scope

PowerPoint permits `c:dLbls` to contain only `c:showLegendKey=1`. This is a visible data-label feature even when no value, category, series, or percentage text is enabled.

## Fix

`ChartDataLabels.HasAny` now includes `ShowLegendKey`. The WPF/Avalonia planner keeps the data-point label plan when its text is empty but its legend-key swatch is authored, allowing the existing swatch paint path to render it. Swatch bounds and fills are now applied consistently for column, bar, line, pie, and scatter label routes. The dedicated scatter renderer loops also consume those bounds instead of painting only the original label rectangle. The DOCX-equivalent chart writer already emits `showLegendKey`; the corrected model guard now preserves that element on round-trip.

## Evidence

- Host model and chart package round-trip tests cover a legend-key-only chart-level label.
- Presentation planner tests require one empty-text plan per data point with a swatch bounds/fill.
- Presentation planner tests cover column, bar, line, pie, and scatter routes.
- Existing PowerPoint chart-label corpus controls remain unchanged.
