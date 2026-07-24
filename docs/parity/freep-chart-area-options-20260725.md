# FreeP Chart Area Options

## Function

FreeP now exposes a chart-area/plot-area formatting command for selected charts.
The command is available from the ribbon and through the WPF and Avalonia host dialogs. It supports solid fill, outline color, and outline width, with blank values restoring the inherited/default surface.

The change is model-first and undoable: `SetChartAreaOptionsCommand` updates only the selected target and restores the prior values through the command bus. Chart-space and plot-area shape properties round-trip through the PPTX reader/writer, including authored solid fills and outlines.

## Rendering

The shared chart scene plan carries chart-area and plot-area fill/stroke plans. WPF and Avalonia paint those surfaces before chart geometry and grid content, while retaining the existing white chart-area fallback when no authored formatting exists.

This slice is a functional parity improvement. It does not claim a broad visual calibration against PowerPoint; any future raster tuning should use a matching PowerPoint export and keep unformatted chart controls byte-stable.

## Verification

- `ChartAreaOptionsTests`: planner, command undo, PPTX round-trip, and shared scene-plan propagation passed 3/3.
- WPF `ChartAreaOptionsDialog` host test passed 1/1.
- Avalonia `ChartAreaOptionsDialog` headless route test passed 1/1.
- `ChartTests.RoundTrip_ChartAreaAndPlotAreaFormatting_PreservesSchemaPlacementAndModel` passed 1/1.
- Presentation, Host, and Avalonia Release project builds passed with 0 warnings/errors during the slice.
