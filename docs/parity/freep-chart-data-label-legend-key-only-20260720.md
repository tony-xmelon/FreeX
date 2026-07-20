# FreeP chart data-label legend-key-only parity

## Scope

PowerPoint permits `c:dLbls` to contain only `c:showLegendKey=1`. This is a visible data-label feature even when no value, category, series, or percentage text is enabled.

## Fix

`ChartDataLabels.HasAny` now includes `ShowLegendKey`. The WPF/Avalonia planner keeps the data-point label plan when its text is empty but its legend-key swatch is authored, allowing the existing swatch paint path to render it. The DOCX-equivalent chart writer already emits `showLegendKey`; the corrected model guard now preserves that element on round-trip.

## Evidence

- Host model and chart package round-trip tests cover a legend-key-only chart-level label.
- Presentation planner tests require one empty-text plan per data point with a swatch bounds/fill.
- Existing PowerPoint chart-label corpus controls remain unchanged.
