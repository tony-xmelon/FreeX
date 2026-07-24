# FreeP Scatter and Bubble Data Authoring

The shared Edit Chart Data workflow now covers the coordinate payloads that distinguish
PowerPoint Scatter and Bubble charts from category charts.

## Behavior

- Scatter charts show one X and one Y column per series.
- Bubble charts show one X, Y, and size column per series.
- Switching a category chart to Scatter or Bubble seeds PowerPoint-compatible default
  coordinates, which remain editable before commit.
- All coordinate and category edits commit through one `ReplaceChartDataCommand` and
  preserve undo/redo behavior.
- Saving an edited chart regenerates the embedded workbook and cached chart data together;
  native `c:xVal`, `c:yVal`, and `c:bubbleSize` payloads remain synchronized.

Both WPF and Avalonia use the same planner projection and batch command.

## Verification

- Planner and command tests: 82 passed, including Bubble coordinate round-trip and undo.
- WPF ChartDataDialog tests: 31 passed.
- Avalonia ChartDataDialog tests: 2 passed, including Scatter columns.
- Full FreeP Release build is required before merge.

This slice establishes functional and package parity for Scatter/Bubble data editing; it
does not claim a new renderer-fidelity result.
