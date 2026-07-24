# FreeP Chart Data-Label Options - 2026-07-24

## Scope

The existing shared Chart Options workflow now edits the complete modeled
chart-level data-label payload in WPF and Avalonia. It covers value,
percentage, category-name, series-name, and legend-key components; label
position; number format; and the separator used between composed label parts.

The workflow remains one undoable `SetChartDisplayOptionsCommand`. It updates
an existing `ChartDataLabels` object or creates one when a chart has no label
block but a non-value component is enabled. The existing PPTX reader/writer
round-trips the resulting `c:dLbls` fields.

## Verification

- Presentation planner/command tests: focused data-label cases **3/3**.
- WPF host dialog/shared-planner tests: **2/2**.
- Avalonia headless dialog test: **1/1**.
- Presentation, WPF host, and Avalonia Release builds: **0 warnings/errors**.
- Existing chart render and package tests remain the owners of renderer and
  schema behavior; this slice intentionally adds no renderer-only calibration.

## Remaining chart function scope

Advanced chart-area styling and richer data-editing semantics beyond the shared
grid remain open. PowerPoint-authoritative chart visual baselines are also
still required for exact rendering claims.
