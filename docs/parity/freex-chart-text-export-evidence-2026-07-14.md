# FreeX Chart Text Export Evidence - 2026-07-14

Scope: bounded FreeX print/export fidelity slice for chart text breadth. This evidence is host-neutral and stays in the shared print/page-layout planners used before WPF or Avalonia realizes print preview, PDF, XPS, or native print output.

## Evidence Added

- `PrintChartTextOverlayPlan` now carries a semantic `PrintChartTextOverlayRole` for chart title, category axis title, value axis title, legend entry, category tick label, value tick label, and data label overlays.
- `PrintExportDrawingEvidencePlanner` now aggregates chart text role counts page-by-page over the same `PageContentLayout` model consumed by print preview/export renderers.
- Focused tests prove one printable chart can expose title, axis-title, legend, category-tick, value-tick, and data-label evidence through the shared print/export summary before either desktop host paints the output.
- Pie-family tests prove legend-entry and data-label role classification for pie, 3-D pie, and doughnut chart text overlays.

## Remaining Gaps

- This is chart text role/breadth evidence, not final PDF/XPS vector graphics fidelity.
- Native foreground file/print/export continuation and focus-return evidence remains open for both hosts.
- Actual PDF/A and tagged-PDF output support remains unsupported; the current shared evidence only rejects unsupported requests honestly.
- Full chart text visual parity still needs final rendered PDF/XPS baselines, broader chart families, and host/Excel visual comparison.
