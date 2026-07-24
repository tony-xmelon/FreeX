# FreeP advanced chart insertion

## Scope

FreeP's chart model and shared render planner already cover nineteen chart types, but the insertion gallery previously exposed only clustered column, clustered bar, line, and pie. The shared `SlideObjectInsertionPlanner` now exposes the remaining modeled families:

- stacked and 100% stacked column;
- stacked and 100% stacked bar;
- line with markers;
- area and stacked area;
- scatter, doughnut, radar, bubble, and stock;
- surface and 3-D surface.

Both WPF and Avalonia register the same plans, so a command creates the same `ChartType` model and follows the existing PPTX writer path. Labels and key tips are localized through the normal FreeP resource catalog.

## Verification

- `SlideObjectInsertionPlannerTests` covers all nineteen chart insertion plans and checks the resulting model type.
- WPF ribbon completeness tests cover the expanded chart gallery.
- Avalonia command-routing tests execute each expanded chart command and check the resulting shape.
- Localization and generated command-inventory tests pass with the expanded shared command surface.

## Remaining function depth

This slice exposes insertion, not full PowerPoint chart editing. Chart data dialogs, combo-series authoring, axis/legend formatting, and application-specific chart galleries remain separate work.
