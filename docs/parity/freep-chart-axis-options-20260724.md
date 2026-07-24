# FreeP Chart Axis Options - 2026-07-24

## Scope

FreeP now exposes a shared chart-axis authoring workflow in WPF and Avalonia. The workflow
edits the existing `ChartAxis` model instead of introducing host-local chart state.

Supported fields are:

- category or value axis selection;
- axis title;
- automatic or explicit minimum and maximum scale;
- major and minor units;
- number format code;
- major gridline visibility.

The edit is committed as one `SetChartAxisOptionsCommand`, so the complete dialog action is
one undo/redo step. Empty scale fields preserve PowerPoint-style automatic scaling.

## Evidence

- `ChartAxisOptionsPlanner` is the shared working-copy policy for both hosts.
- `ChartAxisOptionsDialog` exists in WPF and Avalonia and routes through `EditingSession`.
- `PptxChartReader` and `PptxChartWriter` already own the corresponding axis XML fields.
- Presentation planner/command tests: `67/67`.
- WPF host chart-dialog tests: `18/18`.
- Avalonia headless chart-dialog tests: `3/3`.
- Ribbon definition profile tests: `18/18`.
- Release builds for Presentation, WPF Host, Avalonia, and Ribbon Definitions completed with
  zero warnings and zero errors.

## Remaining

Per-series and per-point formatting, chart-area/plot-area formatting, richer data-source
selection, and PowerPoint COM workflow evidence remain separate function slices.
