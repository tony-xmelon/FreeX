# FreeP chart combo-series authoring

## Scope

FreeP's chart reader, writer, and neutral render planner already supported a secondary
line plot group through `ChartSeries.OverrideChartType`, but the shared Chart Series
Options authoring route could only move a series to the secondary axis. WPF and Avalonia
now expose the missing per-series choice:

- Same as chart;
- Line;
- Line with markers.

Selecting a combo override keeps the series on the secondary axis, creates the secondary
axis when needed, and commits through the existing undoable `SetChartSeriesOptionsCommand`.
The prior override and axis state are restored by undo. Existing unsupported chart-type
families remain unavailable because the current FreeP writer emits the supported combo
plot as a secondary line group.

## Verification

- Presentation chart planner and command tests cover validation, PPTX round-trip, and undo.
- WPF Chart Series Options dialog tests cover the new control and shared commit payload.
- Avalonia headless dialog tests cover the same shared payload.
- Focused Release builds completed with zero warnings and zero errors.

This is a functional authoring slice. It does not claim a new PowerPoint raster baseline;
the existing combo render path remains the visual authority.
